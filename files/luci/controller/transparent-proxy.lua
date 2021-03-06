-- Copyright (C) 2014-2017 Jian Chang <aa65535@live.com>
-- Copyright (C) 2017 Ian Li <OpenSource@ianli.xyz>
-- Licensed to the public under the GNU General Public License v3.

module("luci.controller.transparent-proxy", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/transparent-proxy") then
		return
	end

	entry({"admin", "vpn", "transparent-proxy"},
		alias("admin", "vpn", "transparent-proxy", "general"),
		_("Transparent Proxy"), 10).dependent = true

	entry({"admin", "vpn", "transparent-proxy", "general"},
		cbi("transparent-proxy/general"),
		_("General Settings"), 10).leaf = true

	entry({"admin", "vpn", "transparent-proxy", "status"},
		call("action_status")).leaf = true

	entry({"admin", "vpn", "transparent-proxy", "access-control"},
		cbi("transparent-proxy/access-control"),
		_("Access Control"), 30).leaf = true
end

local function is_ipset_exist(name)
	return luci.sys.call("ipset list %s >/dev/null" %{name}) == 0
end

function action_status()
	luci.http.prepare_content("application/json")
	luci.http.write_json({
		rules = is_ipset_exist("tp_spec_dst_fw"),
	})
end
