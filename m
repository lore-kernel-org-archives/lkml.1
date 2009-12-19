Return-Path: <linux-kernel-owner+w=401wt.eu-S1752766AbZLSO6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbZLSO6j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 09:58:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbZLSO6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 09:58:37 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42540 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbZLSO6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 09:58:35 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20091219358.549678091@firstfloor.org>
In-Reply-To: <20091219358.549678091@firstfloor.org>
To: torvalds@linux-foundation.org, akpm@osdl.org, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [1/2] SYSCTL: Make bin_table not const
Message-Id: <20091219145832.A0424B158A@basil.firstfloor.org>
Date: Sat, 19 Dec 2009 15:58:32 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Turn all the bin_tables from const to non-const. This is needed for the next
patch. Unfortunately there were a lot of them, so the patch is rather 
large, but it is completely mechanic. 

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 kernel/sysctl_binary.c |  120 ++++++++++++++++++++++++-------------------------
 1 file changed, 60 insertions(+), 60 deletions(-)

Index: linux-2.6.33-rc1-ak/kernel/sysctl_binary.c
===================================================================
--- linux-2.6.33-rc1-ak.orig/kernel/sysctl_binary.c
+++ linux-2.6.33-rc1-ak/kernel/sysctl_binary.c
@@ -40,10 +40,10 @@ struct bin_table {
 	bin_convert_t		*convert;
 	int			ctl_name;
 	const char		*procname;
-	const struct bin_table	*child;
+	struct bin_table	*child;
 };
 
-static const struct bin_table bin_random_table[] = {
+static struct bin_table bin_random_table[] = {
 	{ CTL_INT,	RANDOM_POOLSIZE,	"poolsize" },
 	{ CTL_INT,	RANDOM_ENTROPY_COUNT,	"entropy_avail" },
 	{ CTL_INT,	RANDOM_READ_THRESH,	"read_wakeup_threshold" },
@@ -53,13 +53,13 @@ static const struct bin_table bin_random
 	{}
 };
 
-static const struct bin_table bin_pty_table[] = {
+static struct bin_table bin_pty_table[] = {
 	{ CTL_INT,	PTY_MAX,	"max" },
 	{ CTL_INT,	PTY_NR,		"nr" },
 	{}
 };
 
-static const struct bin_table bin_kern_table[] = {
+static struct bin_table bin_kern_table[] = {
 	{ CTL_STR,	KERN_OSTYPE,			"ostype" },
 	{ CTL_STR,	KERN_OSRELEASE,			"osrelease" },
 	/* KERN_OSREV not used */
@@ -139,7 +139,7 @@ static const struct bin_table bin_kern_t
 	{}
 };
 
-static const struct bin_table bin_vm_table[] = {
+static struct bin_table bin_vm_table[] = {
 	{ CTL_INT,	VM_OVERCOMMIT_MEMORY,		"overcommit_memory" },
 	{ CTL_INT,	VM_PAGE_CLUSTER,		"page-cluster" },
 	{ CTL_INT,	VM_DIRTY_BACKGROUND,		"dirty_background_ratio" },
@@ -171,7 +171,7 @@ static const struct bin_table bin_vm_tab
 	{}
 };
 
-static const struct bin_table bin_net_core_table[] = {
+static struct bin_table bin_net_core_table[] = {
 	{ CTL_INT,	NET_CORE_WMEM_MAX,	"wmem_max" },
 	{ CTL_INT,	NET_CORE_RMEM_MAX,	"rmem_max" },
 	{ CTL_INT,	NET_CORE_WMEM_DEFAULT,	"wmem_default" },
@@ -197,14 +197,14 @@ static const struct bin_table bin_net_co
 	{},
 };
 
-static const struct bin_table bin_net_unix_table[] = {
+static struct bin_table bin_net_unix_table[] = {
 	/* NET_UNIX_DESTROY_DELAY unused */
 	/* NET_UNIX_DELETE_DELAY unused */
 	{ CTL_INT,	NET_UNIX_MAX_DGRAM_QLEN,	"max_dgram_qlen" },
 	{}
 };
 
-static const struct bin_table bin_net_ipv4_route_table[] = {
+static struct bin_table bin_net_ipv4_route_table[] = {
 	{ CTL_INT,	NET_IPV4_ROUTE_FLUSH,			"flush" },
 	/* NET_IPV4_ROUTE_MIN_DELAY "min_delay" no longer used */
 	/* NET_IPV4_ROUTE_MAX_DELAY "max_delay" no longer used */
@@ -227,7 +227,7 @@ static const struct bin_table bin_net_ip
 	{}
 };
 
-static const struct bin_table bin_net_ipv4_conf_vars_table[] = {
+static struct bin_table bin_net_ipv4_conf_vars_table[] = {
 	{ CTL_INT,	NET_IPV4_CONF_FORWARDING,		"forwarding" },
 	{ CTL_INT,	NET_IPV4_CONF_MC_FORWARDING,		"mc_forwarding" },
 
@@ -255,14 +255,14 @@ static const struct bin_table bin_net_ip
 	{}
 };
 
-static const struct bin_table bin_net_ipv4_conf_table[] = {
+static struct bin_table bin_net_ipv4_conf_table[] = {
 	{ CTL_DIR,	NET_PROTO_CONF_ALL,	"all",		bin_net_ipv4_conf_vars_table },
 	{ CTL_DIR,	NET_PROTO_CONF_DEFAULT,	"default",	bin_net_ipv4_conf_vars_table },
 	{ CTL_DIR,	0, NULL, bin_net_ipv4_conf_vars_table },
 	{}
 };
 
-static const struct bin_table bin_net_neigh_vars_table[] = {
+static struct bin_table bin_net_neigh_vars_table[] = {
 	{ CTL_INT,	NET_NEIGH_MCAST_SOLICIT,	"mcast_solicit" },
 	{ CTL_INT,	NET_NEIGH_UCAST_SOLICIT,	"ucast_solicit" },
 	{ CTL_INT,	NET_NEIGH_APP_SOLICIT,		"app_solicit" },
@@ -284,13 +284,13 @@ static const struct bin_table bin_net_ne
 	{}
 };
 
-static const struct bin_table bin_net_neigh_table[] = {
+static struct bin_table bin_net_neigh_table[] = {
 	{ CTL_DIR,	NET_PROTO_CONF_DEFAULT, "default", bin_net_neigh_vars_table },
 	{ CTL_DIR,	0, NULL, bin_net_neigh_vars_table },
 	{}
 };
 
-static const struct bin_table bin_net_ipv4_netfilter_table[] = {
+static struct bin_table bin_net_ipv4_netfilter_table[] = {
 	{ CTL_INT,	NET_IPV4_NF_CONNTRACK_MAX,		"ip_conntrack_max" },
 
 	/* NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_SYN_SENT "ip_conntrack_tcp_timeout_syn_sent" no longer used */
@@ -327,7 +327,7 @@ static const struct bin_table bin_net_ip
 	{}
 };
 
-static const struct bin_table bin_net_ipv4_table[] = {
+static struct bin_table bin_net_ipv4_table[] = {
 	{CTL_INT,	NET_IPV4_FORWARD,			"ip_forward" },
 
 	{ CTL_DIR,	NET_IPV4_CONF,		"conf",		bin_net_ipv4_conf_table },
@@ -431,13 +431,13 @@ static const struct bin_table bin_net_ip
 	{}
 };
 
-static const struct bin_table bin_net_ipx_table[] = {
+static struct bin_table bin_net_ipx_table[] = {
 	{ CTL_INT,	NET_IPX_PPROP_BROADCASTING,	"ipx_pprop_broadcasting" },
 	/* NET_IPX_FORWARDING unused */
 	{}
 };
 
-static const struct bin_table bin_net_atalk_table[] = {
+static struct bin_table bin_net_atalk_table[] = {
 	{ CTL_INT,	NET_ATALK_AARP_EXPIRY_TIME,		"aarp-expiry-time" },
 	{ CTL_INT,	NET_ATALK_AARP_TICK_TIME,		"aarp-tick-time" },
 	{ CTL_INT,	NET_ATALK_AARP_RETRANSMIT_LIMIT,	"aarp-retransmit-limit" },
@@ -445,7 +445,7 @@ static const struct bin_table bin_net_at
 	{},
 };
 
-static const struct bin_table bin_net_netrom_table[] = {
+static struct bin_table bin_net_netrom_table[] = {
 	{ CTL_INT,	NET_NETROM_DEFAULT_PATH_QUALITY,		"default_path_quality" },
 	{ CTL_INT,	NET_NETROM_OBSOLESCENCE_COUNT_INITIALISER,	"obsolescence_count_initialiser" },
 	{ CTL_INT,	NET_NETROM_NETWORK_TTL_INITIALISER,		"network_ttl_initialiser" },
@@ -461,7 +461,7 @@ static const struct bin_table bin_net_ne
 	{}
 };
 
-static const struct bin_table bin_net_ax25_param_table[] = {
+static struct bin_table bin_net_ax25_param_table[] = {
 	{ CTL_INT,	NET_AX25_IP_DEFAULT_MODE,	"ip_default_mode" },
 	{ CTL_INT,	NET_AX25_DEFAULT_MODE,		"ax25_default_mode" },
 	{ CTL_INT,	NET_AX25_BACKOFF_TYPE,		"backoff_type" },
@@ -479,12 +479,12 @@ static const struct bin_table bin_net_ax
 	{}
 };
 
-static const struct bin_table bin_net_ax25_table[] = {
+static struct bin_table bin_net_ax25_table[] = {
 	{ CTL_DIR,	0, NULL, bin_net_ax25_param_table },
 	{}
 };
 
-static const struct bin_table bin_net_rose_table[] = {
+static struct bin_table bin_net_rose_table[] = {
 	{ CTL_INT,	NET_ROSE_RESTART_REQUEST_TIMEOUT,	"restart_request_timeout" },
 	{ CTL_INT,	NET_ROSE_CALL_REQUEST_TIMEOUT,		"call_request_timeout" },
 	{ CTL_INT,	NET_ROSE_RESET_REQUEST_TIMEOUT,		"reset_request_timeout" },
@@ -498,7 +498,7 @@ static const struct bin_table bin_net_ro
 	{}
 };
 
-static const struct bin_table bin_net_ipv6_conf_var_table[] = {
+static struct bin_table bin_net_ipv6_conf_var_table[] = {
 	{ CTL_INT,	NET_IPV6_FORWARDING,			"forwarding" },
 	{ CTL_INT,	NET_IPV6_HOP_LIMIT,			"hop_limit" },
 	{ CTL_INT,	NET_IPV6_MTU,				"mtu" },
@@ -526,14 +526,14 @@ static const struct bin_table bin_net_ip
 	{}
 };
 
-static const struct bin_table bin_net_ipv6_conf_table[] = {
+static struct bin_table bin_net_ipv6_conf_table[] = {
 	{ CTL_DIR,	NET_PROTO_CONF_ALL,		"all",	bin_net_ipv6_conf_var_table },
 	{ CTL_DIR,	NET_PROTO_CONF_DEFAULT, 	"default", bin_net_ipv6_conf_var_table },
 	{ CTL_DIR,	0, NULL, bin_net_ipv6_conf_var_table },
 	{}
 };
 
-static const struct bin_table bin_net_ipv6_route_table[] = {
+static struct bin_table bin_net_ipv6_route_table[] = {
 	/* NET_IPV6_ROUTE_FLUSH	"flush"  no longer used */
 	{ CTL_INT,	NET_IPV6_ROUTE_GC_THRESH,		"gc_thresh" },
 	{ CTL_INT,	NET_IPV6_ROUTE_MAX_SIZE,		"max_size" },
@@ -547,12 +547,12 @@ static const struct bin_table bin_net_ip
 	{}
 };
 
-static const struct bin_table bin_net_ipv6_icmp_table[] = {
+static struct bin_table bin_net_ipv6_icmp_table[] = {
 	{ CTL_INT,	NET_IPV6_ICMP_RATELIMIT,	"ratelimit" },
 	{}
 };
 
-static const struct bin_table bin_net_ipv6_table[] = {
+static struct bin_table bin_net_ipv6_table[] = {
 	{ CTL_DIR,	NET_IPV6_CONF,		"conf",		bin_net_ipv6_conf_table },
 	{ CTL_DIR,	NET_IPV6_NEIGH,		"neigh",	bin_net_neigh_table },
 	{ CTL_DIR,	NET_IPV6_ROUTE,		"route",	bin_net_ipv6_route_table },
@@ -567,7 +567,7 @@ static const struct bin_table bin_net_ip
 	{}
 };
 
-static const struct bin_table bin_net_x25_table[] = {
+static struct bin_table bin_net_x25_table[] = {
 	{ CTL_INT,	NET_X25_RESTART_REQUEST_TIMEOUT,	"restart_request_timeout" },
 	{ CTL_INT,	NET_X25_CALL_REQUEST_TIMEOUT,		"call_request_timeout" },
 	{ CTL_INT,	NET_X25_RESET_REQUEST_TIMEOUT,	"reset_request_timeout" },
@@ -577,13 +577,13 @@ static const struct bin_table bin_net_x2
 	{}
 };
 
-static const struct bin_table bin_net_tr_table[] = {
+static struct bin_table bin_net_tr_table[] = {
 	{ CTL_INT,	NET_TR_RIF_TIMEOUT,	"rif_timeout" },
 	{}
 };
 
 
-static const struct bin_table bin_net_decnet_conf_vars[] = {
+static struct bin_table bin_net_decnet_conf_vars[] = {
 	{ CTL_INT,	NET_DECNET_CONF_DEV_FORWARDING,	"forwarding" },
 	{ CTL_INT,	NET_DECNET_CONF_DEV_PRIORITY,	"priority" },
 	{ CTL_INT,	NET_DECNET_CONF_DEV_T2,		"t2" },
@@ -591,7 +591,7 @@ static const struct bin_table bin_net_de
 	{}
 };
 
-static const struct bin_table bin_net_decnet_conf[] = {
+static struct bin_table bin_net_decnet_conf[] = {
 	{ CTL_DIR, NET_DECNET_CONF_ETHER,    "ethernet", bin_net_decnet_conf_vars },
 	{ CTL_DIR, NET_DECNET_CONF_GRE,	     "ipgre",    bin_net_decnet_conf_vars },
 	{ CTL_DIR, NET_DECNET_CONF_X25,	     "x25",      bin_net_decnet_conf_vars },
@@ -602,7 +602,7 @@ static const struct bin_table bin_net_de
 	{}
 };
 
-static const struct bin_table bin_net_decnet_table[] = {
+static struct bin_table bin_net_decnet_table[] = {
 	{ CTL_DIR,	NET_DECNET_CONF,		"conf",	bin_net_decnet_conf },
 	{ CTL_DNADR,	NET_DECNET_NODE_ADDRESS,	"node_address" },
 	{ CTL_STR,	NET_DECNET_NODE_NAME,		"node_name" },
@@ -620,7 +620,7 @@ static const struct bin_table bin_net_de
 	{}
 };
 
-static const struct bin_table bin_net_sctp_table[] = {
+static struct bin_table bin_net_sctp_table[] = {
 	{ CTL_INT,	NET_SCTP_RTO_INITIAL,		"rto_initial" },
 	{ CTL_INT,	NET_SCTP_RTO_MIN,		"rto_min" },
 	{ CTL_INT,	NET_SCTP_RTO_MAX,		"rto_max" },
@@ -641,7 +641,7 @@ static const struct bin_table bin_net_sc
 	{}
 };
 
-static const struct bin_table bin_net_llc_llc2_timeout_table[] = {
+static struct bin_table bin_net_llc_llc2_timeout_table[] = {
 	{ CTL_INT,	NET_LLC2_ACK_TIMEOUT,	"ack" },
 	{ CTL_INT,	NET_LLC2_P_TIMEOUT,	"p" },
 	{ CTL_INT,	NET_LLC2_REJ_TIMEOUT,	"rej" },
@@ -649,23 +649,23 @@ static const struct bin_table bin_net_ll
 	{}
 };
 
-static const struct bin_table bin_net_llc_station_table[] = {
+static struct bin_table bin_net_llc_station_table[] = {
 	{ CTL_INT,	NET_LLC_STATION_ACK_TIMEOUT,	"ack_timeout" },
 	{}
 };
 
-static const struct bin_table bin_net_llc_llc2_table[] = {
+static struct bin_table bin_net_llc_llc2_table[] = {
 	{ CTL_DIR,	NET_LLC2,		"timeout",	bin_net_llc_llc2_timeout_table },
 	{}
 };
 
-static const struct bin_table bin_net_llc_table[] = {
+static struct bin_table bin_net_llc_table[] = {
 	{ CTL_DIR,	NET_LLC2,		"llc2",		bin_net_llc_llc2_table },
 	{ CTL_DIR,	NET_LLC_STATION,	"station",	bin_net_llc_station_table },
 	{}
 };
 
-static const struct bin_table bin_net_netfilter_table[] = {
+static struct bin_table bin_net_netfilter_table[] = {
 	{ CTL_INT,	NET_NF_CONNTRACK_MAX,			"nf_conntrack_max" },
 	/* NET_NF_CONNTRACK_TCP_TIMEOUT_SYN_SENT "nf_conntrack_tcp_timeout_syn_sent" no longer used */
 	/* NET_NF_CONNTRACK_TCP_TIMEOUT_SYN_RECV "nf_conntrack_tcp_timeout_syn_recv" no longer used */
@@ -702,7 +702,7 @@ static const struct bin_table bin_net_ne
 	{}
 };
 
-static const struct bin_table bin_net_irda_table[] = {
+static struct bin_table bin_net_irda_table[] = {
 	{ CTL_INT,	NET_IRDA_DISCOVERY,		"discovery" },
 	{ CTL_STR,	NET_IRDA_DEVNAME,		"devname" },
 	{ CTL_INT,	NET_IRDA_DEBUG,			"debug" },
@@ -720,7 +720,7 @@ static const struct bin_table bin_net_ir
 	{}
 };
 
-static const struct bin_table bin_net_table[] = {
+static struct bin_table bin_net_table[] = {
 	{ CTL_DIR,	NET_CORE,		"core",		bin_net_core_table },
 	/* NET_ETHER not used */
 	/* NET_802 not used */
@@ -746,7 +746,7 @@ static const struct bin_table bin_net_ta
 	{}
 };
 
-static const struct bin_table bin_fs_quota_table[] = {
+static struct bin_table bin_fs_quota_table[] = {
 	{ CTL_INT,	FS_DQ_LOOKUPS,		"lookups" },
 	{ CTL_INT,	FS_DQ_DROPS,		"drops" },
 	{ CTL_INT,	FS_DQ_READS,		"reads" },
@@ -759,7 +759,7 @@ static const struct bin_table bin_fs_quo
 	{}
 };
 
-static const struct bin_table bin_fs_xfs_table[] = {
+static struct bin_table bin_fs_xfs_table[] = {
 	{ CTL_INT,	XFS_SGID_INHERIT,	"irix_sgid_inherit" },
 	{ CTL_INT,	XFS_SYMLINK_MODE,	"irix_symlink_mode" },
 	{ CTL_INT,	XFS_PANIC_MASK,		"panic_mask" },
@@ -779,24 +779,24 @@ static const struct bin_table bin_fs_xfs
 	{}
 };
 
-static const struct bin_table bin_fs_ocfs2_nm_table[] = {
+static struct bin_table bin_fs_ocfs2_nm_table[] = {
 	{ CTL_STR,	1, "hb_ctl_path" },
 	{}
 };
 
-static const struct bin_table bin_fs_ocfs2_table[] = {
+static struct bin_table bin_fs_ocfs2_table[] = {
 	{ CTL_DIR,	1,	"nm",	bin_fs_ocfs2_nm_table },
 	{}
 };
 
-static const struct bin_table bin_inotify_table[] = {
+static struct bin_table bin_inotify_table[] = {
 	{ CTL_INT,	INOTIFY_MAX_USER_INSTANCES,	"max_user_instances" },
 	{ CTL_INT,	INOTIFY_MAX_USER_WATCHES,	"max_user_watches" },
 	{ CTL_INT,	INOTIFY_MAX_QUEUED_EVENTS,	"max_queued_events" },
 	{}
 };
 
-static const struct bin_table bin_fs_table[] = {
+static struct bin_table bin_fs_table[] = {
 	{ CTL_INT,	FS_NRINODE,		"inode-nr" },
 	{ CTL_INT,	FS_STATINODE,		"inode-state" },
 	/* FS_MAXINODE unused */
@@ -822,12 +822,12 @@ static const struct bin_table bin_fs_tab
 	{}
 };
 
-static const struct bin_table bin_ipmi_table[] = {
+static struct bin_table bin_ipmi_table[] = {
 	{ CTL_INT,	DEV_IPMI_POWEROFF_POWERCYCLE,	"poweroff_powercycle" },
 	{}
 };
 
-static const struct bin_table bin_mac_hid_files[] = {
+static struct bin_table bin_mac_hid_files[] = {
 	/* DEV_MAC_HID_KEYBOARD_SENDS_LINUX_KEYCODES unused */
 	/* DEV_MAC_HID_KEYBOARD_LOCK_KEYCODES unused */
 	{ CTL_INT,	DEV_MAC_HID_MOUSE_BUTTON_EMULATION,	"mouse_button_emulation" },
@@ -837,18 +837,18 @@ static const struct bin_table bin_mac_hi
 	{}
 };
 
-static const struct bin_table bin_raid_table[] = {
+static struct bin_table bin_raid_table[] = {
 	{ CTL_INT,	DEV_RAID_SPEED_LIMIT_MIN,	"speed_limit_min" },
 	{ CTL_INT,	DEV_RAID_SPEED_LIMIT_MAX,	"speed_limit_max" },
 	{}
 };
 
-static const struct bin_table bin_scsi_table[] = {
+static struct bin_table bin_scsi_table[] = {
 	{ CTL_INT, DEV_SCSI_LOGGING_LEVEL, "logging_level" },
 	{}
 };
 
-static const struct bin_table bin_dev_table[] = {
+static struct bin_table bin_dev_table[] = {
 	/* DEV_CDROM	"cdrom" no longer used */
 	/* DEV_HWMON unused */
 	/* DEV_PARPORT	"parport" no longer used */
@@ -859,26 +859,26 @@ static const struct bin_table bin_dev_ta
 	{}
 };
 
-static const struct bin_table bin_bus_isa_table[] = {
+static struct bin_table bin_bus_isa_table[] = {
 	{ CTL_INT,	BUS_ISA_MEM_BASE,	"membase" },
 	{ CTL_INT,	BUS_ISA_PORT_BASE,	"portbase" },
 	{ CTL_INT,	BUS_ISA_PORT_SHIFT,	"portshift" },
 	{}
 };
 
-static const struct bin_table bin_bus_table[] = {
+static struct bin_table bin_bus_table[] = {
 	{ CTL_DIR,	CTL_BUS_ISA,	"isa",	bin_bus_isa_table },
 	{}
 };
 
 
-static const struct bin_table bin_s390dbf_table[] = {
+static struct bin_table bin_s390dbf_table[] = {
 	{ CTL_INT,	5678 /* CTL_S390DBF_STOPPABLE */, "debug_stoppable" },
 	{ CTL_INT,	5679 /* CTL_S390DBF_ACTIVE */,	  "debug_active" },
 	{}
 };
 
-static const struct bin_table bin_sunrpc_table[] = {
+static struct bin_table bin_sunrpc_table[] = {
 	/* CTL_RPCDEBUG	"rpc_debug"  no longer used */
 	/* CTL_NFSDEBUG "nfs_debug"  no longer used */
 	/* CTL_NFSDDEBUG "nfsd_debug" no longer used  */
@@ -891,7 +891,7 @@ static const struct bin_table bin_sunrpc
 	{}
 };
 
-static const struct bin_table bin_pm_table[] = {
+static struct bin_table bin_pm_table[] = {
 	/* frv specific */
 	/* 1 == CTL_PM_SUSPEND	"suspend"  no longer used" */
 	{ CTL_INT,	2 /* CTL_PM_CMODE */,		"cmode" },
@@ -900,7 +900,7 @@ static const struct bin_table bin_pm_tab
 	{}
 };
 
-static const struct bin_table bin_root_table[] = {
+static struct bin_table bin_root_table[] = {
 	{ CTL_DIR,	CTL_KERN,	"kernel",	bin_kern_table },
 	{ CTL_DIR,	CTL_VM,		"vm",		bin_vm_table },
 	{ CTL_DIR,	CTL_NET,	"net",		bin_net_table },
@@ -1248,9 +1248,9 @@ out:
 	return result;
 }
 
-static const struct bin_table *get_sysctl(const int *name, int nlen, char *path)
+static struct bin_table *get_sysctl(const int *name, int nlen, char *path)
 {
-	const struct bin_table *table = &bin_root_table[0];
+	struct bin_table *table = &bin_root_table[0];
 	int ctl_name;
 
 	/* The binary sysctl tables have a small maximum depth so
@@ -1303,14 +1303,14 @@ repeat:
 	return ERR_PTR(-ENOTDIR);
 }
 
-static char *sysctl_getname(const int *name, int nlen, const struct bin_table **tablep)
+static char *sysctl_getname(const int *name, int nlen, struct bin_table **tablep)
 {
 	char *tmp, *result;
 
 	result = ERR_PTR(-ENOMEM);
 	tmp = __getname();
 	if (tmp) {
-		const struct bin_table *table = get_sysctl(name, nlen, tmp);
+		struct bin_table *table = get_sysctl(name, nlen, tmp);
 		result = tmp;
 		*tablep = table;
 		if (IS_ERR(table)) {
@@ -1324,7 +1324,7 @@ static char *sysctl_getname(const int *n
 static ssize_t binary_sysctl(const int *name, int nlen,
 	void __user *oldval, size_t oldlen, void __user *newval, size_t newlen)
 {
-	const struct bin_table *table = NULL;
+	struct bin_table *table = NULL;
 	struct nameidata nd;
 	struct vfsmount *mnt;
 	struct file *file;
