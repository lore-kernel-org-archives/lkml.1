Return-Path: <linux-kernel-owner+w=401wt.eu-S1754146AbZKHMWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbZKHMWn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 07:22:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754105AbZKHMWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 07:22:41 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:59086 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbZKHMWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 07:22:32 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Jan Harkes <jaharkes@cs.cmu.edu>
Subject: [PATCH 10/23] sysctl fs: Remove dead binary sysctl support
Date: Sun,  8 Nov 2009 04:21:57 -0800
Message-Id: <1257682930-31401-10-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m14op5jjo4.fsf@fess.ebiederm.org>
References: <m14op5jjo4.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Now that sys_sysctl is a generic wrapper around /proc/sys  .ctl_name
and .strategy members of sysctl tables are dead code.  Remove them.

Cc: Jan Harkes <jaharkes@cs.cmu.edu>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/coda/sysctl.c                 |    4 ----
 fs/eventpoll.c                   |    2 +-
 fs/lockd/svc.c                   |   14 +++-----------
 fs/nfs/sysctl.c                  |   14 +++-----------
 fs/notify/inotify/inotify_user.c |    8 +-------
 fs/ntfs/sysctl.c                 |    2 --
 fs/ocfs2/stackglue.c             |   13 ++++---------
 fs/quota/dquot.c                 |   17 +++--------------
 fs/xfs/linux-2.6/xfs_sysctl.c    |   32 --------------------------------
 9 files changed, 15 insertions(+), 91 deletions(-)

diff --git a/fs/coda/sysctl.c b/fs/coda/sysctl.c
index 43c96ce..354c050 100644
--- a/fs/coda/sysctl.c
+++ b/fs/coda/sysctl.c
@@ -17,7 +17,6 @@ static struct ctl_table_header *fs_table_header;
 
 static ctl_table coda_table[] = {
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "timeout",
 		.data		= &coda_timeout,
 		.maxlen		= sizeof(int),
@@ -25,7 +24,6 @@ static ctl_table coda_table[] = {
 		.proc_handler	= &proc_dointvec
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "hard",
 		.data		= &coda_hard,
 		.maxlen		= sizeof(int),
@@ -33,7 +31,6 @@ static ctl_table coda_table[] = {
 		.proc_handler	= &proc_dointvec
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "fake_statfs",
 		.data		= &coda_fake_statfs,
 		.maxlen		= sizeof(int),
@@ -46,7 +43,6 @@ static ctl_table coda_table[] = {
 #ifdef CONFIG_SYSCTL
 static ctl_table fs_table[] = {
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "coda",
 		.mode		= 0555,
 		.child		= coda_table
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 085c5c0..70aa66c 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -254,7 +254,7 @@ ctl_table epoll_table[] = {
 		.proc_handler	= &proc_dointvec_minmax,
 		.extra1		= &zero,
 	},
-	{ .ctl_name = 0 }
+	{ }
 };
 #endif /* CONFIG_SYSCTL */
 
diff --git a/fs/lockd/svc.c b/fs/lockd/svc.c
index 1a54ae1..307ed4c 100644
--- a/fs/lockd/svc.c
+++ b/fs/lockd/svc.c
@@ -371,7 +371,6 @@ EXPORT_SYMBOL_GPL(lockd_down);
 
 static ctl_table nlm_sysctls[] = {
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "nlm_grace_period",
 		.data		= &nlm_grace_period,
 		.maxlen		= sizeof(unsigned long),
@@ -381,7 +380,6 @@ static ctl_table nlm_sysctls[] = {
 		.extra2		= (unsigned long *) &nlm_grace_period_max,
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "nlm_timeout",
 		.data		= &nlm_timeout,
 		.maxlen		= sizeof(unsigned long),
@@ -391,7 +389,6 @@ static ctl_table nlm_sysctls[] = {
 		.extra2		= (unsigned long *) &nlm_timeout_max,
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "nlm_udpport",
 		.data		= &nlm_udpport,
 		.maxlen		= sizeof(int),
@@ -401,7 +398,6 @@ static ctl_table nlm_sysctls[] = {
 		.extra2		= (int *) &nlm_port_max,
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "nlm_tcpport",
 		.data		= &nlm_tcpport,
 		.maxlen		= sizeof(int),
@@ -411,7 +407,6 @@ static ctl_table nlm_sysctls[] = {
 		.extra2		= (int *) &nlm_port_max,
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "nsm_use_hostnames",
 		.data		= &nsm_use_hostnames,
 		.maxlen		= sizeof(int),
@@ -419,34 +414,31 @@ static ctl_table nlm_sysctls[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "nsm_local_state",
 		.data		= &nsm_local_state,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
-	{ .ctl_name = 0 }
+	{ }
 };
 
 static ctl_table nlm_sysctl_dir[] = {
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "nfs",
 		.mode		= 0555,
 		.child		= nlm_sysctls,
 	},
-	{ .ctl_name = 0 }
+	{ }
 };
 
 static ctl_table nlm_sysctl_root[] = {
 	{
-		.ctl_name	= CTL_FS,
 		.procname	= "fs",
 		.mode		= 0555,
 		.child		= nlm_sysctl_dir,
 	},
-	{ .ctl_name = 0 }
+	{ }
 };
 
 #endif	/* CONFIG_SYSCTL */
diff --git a/fs/nfs/sysctl.c b/fs/nfs/sysctl.c
index b62481d..af51e6a 100644
--- a/fs/nfs/sysctl.c
+++ b/fs/nfs/sysctl.c
@@ -22,7 +22,6 @@ static struct ctl_table_header *nfs_callback_sysctl_table;
 static ctl_table nfs_cb_sysctls[] = {
 #ifdef CONFIG_NFS_V4
 	{
-		.ctl_name = CTL_UNNUMBERED,
 		.procname = "nfs_callback_tcpport",
 		.data = &nfs_callback_set_tcpport,
 		.maxlen = sizeof(int),
@@ -32,53 +31,46 @@ static ctl_table nfs_cb_sysctls[] = {
 		.extra2 = (int *)&nfs_set_port_max,
 	},
 	{
-		.ctl_name = CTL_UNNUMBERED,
 		.procname = "idmap_cache_timeout",
 		.data = &nfs_idmap_cache_timeout,
 		.maxlen = sizeof(int),
 		.mode = 0644,
 		.proc_handler = &proc_dointvec_jiffies,
-		.strategy = &sysctl_jiffies,
 	},
 #endif
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "nfs_mountpoint_timeout",
 		.data		= &nfs_mountpoint_expiry_timeout,
 		.maxlen		= sizeof(nfs_mountpoint_expiry_timeout),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_jiffies,
-		.strategy	= &sysctl_jiffies,
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "nfs_congestion_kb",
 		.data		= &nfs_congestion_kb,
 		.maxlen		= sizeof(nfs_congestion_kb),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
-	{ .ctl_name = 0 }
+	{ }
 };
 
 static ctl_table nfs_cb_sysctl_dir[] = {
 	{
-		.ctl_name = CTL_UNNUMBERED,
 		.procname = "nfs",
 		.mode = 0555,
 		.child = nfs_cb_sysctls,
 	},
-	{ .ctl_name = 0 }
+	{ }
 };
 
 static ctl_table nfs_cb_sysctl_root[] = {
 	{
-		.ctl_name = CTL_FS,
 		.procname = "fs",
 		.mode = 0555,
 		.child = nfs_cb_sysctl_dir,
 	},
-	{ .ctl_name = 0 }
+	{ }
 };
 
 int nfs_register_sysctl(void)
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index dcd2040..5275921 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -69,36 +69,30 @@ static int zero;
 
 ctl_table inotify_table[] = {
 	{
-		.ctl_name	= INOTIFY_MAX_USER_INSTANCES,
 		.procname	= "max_user_instances",
 		.data		= &inotify_max_user_instances,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &zero,
 	},
 	{
-		.ctl_name	= INOTIFY_MAX_USER_WATCHES,
 		.procname	= "max_user_watches",
 		.data		= &inotify_max_user_watches,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &zero,
 	},
 	{
-		.ctl_name	= INOTIFY_MAX_QUEUED_EVENTS,
 		.procname	= "max_queued_events",
 		.data		= &inotify_max_queued_events,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &zero
 	},
-	{ .ctl_name = 0 }
+	{ }
 };
 #endif /* CONFIG_SYSCTL */
 
diff --git a/fs/ntfs/sysctl.c b/fs/ntfs/sysctl.c
index 9ef85e6..99612ea 100644
--- a/fs/ntfs/sysctl.c
+++ b/fs/ntfs/sysctl.c
@@ -36,7 +36,6 @@
 /* Definition of the ntfs sysctl. */
 static ctl_table ntfs_sysctls[] = {
 	{
-		.ctl_name	= CTL_UNNUMBERED,	/* Binary and text IDs. */
 		.procname	= "ntfs-debug",
 		.data		= &debug_msgs,		/* Data pointer and size. */
 		.maxlen		= sizeof(debug_msgs),
@@ -49,7 +48,6 @@ static ctl_table ntfs_sysctls[] = {
 /* Define the parent directory /proc/sys/fs. */
 static ctl_table sysctls_root[] = {
 	{
-		.ctl_name	= CTL_FS,
 		.procname	= "fs",
 		.mode		= 0555,
 		.child		= ntfs_sysctls
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index 3f2f1c4..ed12c11 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -620,51 +620,46 @@ error:
 
 static ctl_table ocfs2_nm_table[] = {
 	{
-		.ctl_name	= 1,
 		.procname	= "hb_ctl_path",
 		.data		= ocfs2_hb_ctl_path,
 		.maxlen		= OCFS2_MAX_HB_CTL_PATH,
 		.mode		= 0644,
 		.proc_handler	= &proc_dostring,
-		.strategy	= &sysctl_string,
 	},
-	{ .ctl_name = 0 }
+	{ }
 };
 
 static ctl_table ocfs2_mod_table[] = {
 	{
-		.ctl_name	= FS_OCFS2_NM,
 		.procname	= "nm",
 		.data		= NULL,
 		.maxlen		= 0,
 		.mode		= 0555,
 		.child		= ocfs2_nm_table
 	},
-	{ .ctl_name = 0}
+	{ }
 };
 
 static ctl_table ocfs2_kern_table[] = {
 	{
-		.ctl_name	= FS_OCFS2,
 		.procname	= "ocfs2",
 		.data		= NULL,
 		.maxlen		= 0,
 		.mode		= 0555,
 		.child		= ocfs2_mod_table
 	},
-	{ .ctl_name = 0}
+	{ }
 };
 
 static ctl_table ocfs2_root_table[] = {
 	{
-		.ctl_name	= CTL_FS,
 		.procname	= "fs",
 		.data		= NULL,
 		.maxlen		= 0,
 		.mode		= 0555,
 		.child		= ocfs2_kern_table
 	},
-	{ .ctl_name = 0 }
+	{ }
 };
 
 static struct ctl_table_header *ocfs2_table_header = NULL;
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 39b49c4..60940f8 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -2473,7 +2473,6 @@ const struct quotactl_ops vfs_quotactl_ops = {
 
 static ctl_table fs_dqstats_table[] = {
 	{
-		.ctl_name	= FS_DQ_LOOKUPS,
 		.procname	= "lookups",
 		.data		= &dqstats.lookups,
 		.maxlen		= sizeof(int),
@@ -2481,7 +2480,6 @@ static ctl_table fs_dqstats_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= FS_DQ_DROPS,
 		.procname	= "drops",
 		.data		= &dqstats.drops,
 		.maxlen		= sizeof(int),
@@ -2489,7 +2487,6 @@ static ctl_table fs_dqstats_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= FS_DQ_READS,
 		.procname	= "reads",
 		.data		= &dqstats.reads,
 		.maxlen		= sizeof(int),
@@ -2497,7 +2494,6 @@ static ctl_table fs_dqstats_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= FS_DQ_WRITES,
 		.procname	= "writes",
 		.data		= &dqstats.writes,
 		.maxlen		= sizeof(int),
@@ -2505,7 +2501,6 @@ static ctl_table fs_dqstats_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= FS_DQ_CACHE_HITS,
 		.procname	= "cache_hits",
 		.data		= &dqstats.cache_hits,
 		.maxlen		= sizeof(int),
@@ -2513,7 +2508,6 @@ static ctl_table fs_dqstats_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= FS_DQ_ALLOCATED,
 		.procname	= "allocated_dquots",
 		.data		= &dqstats.allocated_dquots,
 		.maxlen		= sizeof(int),
@@ -2521,7 +2515,6 @@ static ctl_table fs_dqstats_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= FS_DQ_FREE,
 		.procname	= "free_dquots",
 		.data		= &dqstats.free_dquots,
 		.maxlen		= sizeof(int),
@@ -2529,7 +2522,6 @@ static ctl_table fs_dqstats_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= FS_DQ_SYNCS,
 		.procname	= "syncs",
 		.data		= &dqstats.syncs,
 		.maxlen		= sizeof(int),
@@ -2538,7 +2530,6 @@ static ctl_table fs_dqstats_table[] = {
 	},
 #ifdef CONFIG_PRINT_QUOTA_WARNING
 	{
-		.ctl_name	= FS_DQ_WARNINGS,
 		.procname	= "warnings",
 		.data		= &flag_print_warnings,
 		.maxlen		= sizeof(int),
@@ -2546,27 +2537,25 @@ static ctl_table fs_dqstats_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 #endif
-	{ .ctl_name = 0 },
+	{ },
 };
 
 static ctl_table fs_table[] = {
 	{
-		.ctl_name	= FS_DQSTATS,
 		.procname	= "quota",
 		.mode		= 0555,
 		.child		= fs_dqstats_table,
 	},
-	{ .ctl_name = 0 },
+	{ },
 };
 
 static ctl_table sys_table[] = {
 	{
-		.ctl_name	= CTL_FS,
 		.procname	= "fs",
 		.mode		= 0555,
 		.child		= fs_table,
 	},
-	{ .ctl_name = 0 },
+	{ },
 };
 
 static int __init dquot_init(void)
diff --git a/fs/xfs/linux-2.6/xfs_sysctl.c b/fs/xfs/linux-2.6/xfs_sysctl.c
index c5bc67c..6880147 100644
--- a/fs/xfs/linux-2.6/xfs_sysctl.c
+++ b/fs/xfs/linux-2.6/xfs_sysctl.c
@@ -55,170 +55,140 @@ xfs_stats_clear_proc_handler(
 
 static ctl_table xfs_table[] = {
 	{
-		.ctl_name	= XFS_SGID_INHERIT,
 		.procname	= "irix_sgid_inherit",
 		.data		= &xfs_params.sgid_inherit.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &xfs_params.sgid_inherit.min,
 		.extra2		= &xfs_params.sgid_inherit.max
 	},
 	{
-		.ctl_name	= XFS_SYMLINK_MODE,
 		.procname	= "irix_symlink_mode",
 		.data		= &xfs_params.symlink_mode.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &xfs_params.symlink_mode.min,
 		.extra2		= &xfs_params.symlink_mode.max
 	},
 	{
-		.ctl_name	= XFS_PANIC_MASK,
 		.procname	= "panic_mask",
 		.data		= &xfs_params.panic_mask.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &xfs_params.panic_mask.min,
 		.extra2		= &xfs_params.panic_mask.max
 	},
 
 	{
-		.ctl_name	= XFS_ERRLEVEL,
 		.procname	= "error_level",
 		.data		= &xfs_params.error_level.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &xfs_params.error_level.min,
 		.extra2		= &xfs_params.error_level.max
 	},
 	{
-		.ctl_name	= XFS_SYNCD_TIMER,
 		.procname	= "xfssyncd_centisecs",
 		.data		= &xfs_params.syncd_timer.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &xfs_params.syncd_timer.min,
 		.extra2		= &xfs_params.syncd_timer.max
 	},
 	{
-		.ctl_name	= XFS_INHERIT_SYNC,
 		.procname	= "inherit_sync",
 		.data		= &xfs_params.inherit_sync.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &xfs_params.inherit_sync.min,
 		.extra2		= &xfs_params.inherit_sync.max
 	},
 	{
-		.ctl_name	= XFS_INHERIT_NODUMP,
 		.procname	= "inherit_nodump",
 		.data		= &xfs_params.inherit_nodump.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &xfs_params.inherit_nodump.min,
 		.extra2		= &xfs_params.inherit_nodump.max
 	},
 	{
-		.ctl_name	= XFS_INHERIT_NOATIME,
 		.procname	= "inherit_noatime",
 		.data		= &xfs_params.inherit_noatim.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &xfs_params.inherit_noatim.min,
 		.extra2		= &xfs_params.inherit_noatim.max
 	},
 	{
-		.ctl_name	= XFS_BUF_TIMER,
 		.procname	= "xfsbufd_centisecs",
 		.data		= &xfs_params.xfs_buf_timer.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &xfs_params.xfs_buf_timer.min,
 		.extra2		= &xfs_params.xfs_buf_timer.max
 	},
 	{
-		.ctl_name	= XFS_BUF_AGE,
 		.procname	= "age_buffer_centisecs",
 		.data		= &xfs_params.xfs_buf_age.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &xfs_params.xfs_buf_age.min,
 		.extra2		= &xfs_params.xfs_buf_age.max
 	},
 	{
-		.ctl_name	= XFS_INHERIT_NOSYM,
 		.procname	= "inherit_nosymlinks",
 		.data		= &xfs_params.inherit_nosym.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &xfs_params.inherit_nosym.min,
 		.extra2		= &xfs_params.inherit_nosym.max
 	},
 	{
-		.ctl_name	= XFS_ROTORSTEP,
 		.procname	= "rotorstep",
 		.data		= &xfs_params.rotorstep.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &xfs_params.rotorstep.min,
 		.extra2		= &xfs_params.rotorstep.max
 	},
 	{
-		.ctl_name	= XFS_INHERIT_NODFRG,
 		.procname	= "inherit_nodefrag",
 		.data		= &xfs_params.inherit_nodfrg.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &xfs_params.inherit_nodfrg.min,
 		.extra2		= &xfs_params.inherit_nodfrg.max
 	},
 	{
-		.ctl_name	= XFS_FILESTREAM_TIMER,
 		.procname	= "filestream_centisecs",
 		.data		= &xfs_params.fstrm_timer.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &xfs_params.fstrm_timer.min,
 		.extra2		= &xfs_params.fstrm_timer.max,
 	},
 	/* please keep this the last entry */
 #ifdef CONFIG_PROC_FS
 	{
-		.ctl_name	= XFS_STATS_CLEAR,
 		.procname	= "stats_clear",
 		.data		= &xfs_params.stats_clear.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &xfs_stats_clear_proc_handler,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &xfs_params.stats_clear.min,
 		.extra2		= &xfs_params.stats_clear.max
 	},
@@ -229,7 +199,6 @@ static ctl_table xfs_table[] = {
 
 static ctl_table xfs_dir_table[] = {
 	{
-		.ctl_name	= FS_XFS,
 		.procname	= "xfs",
 		.mode		= 0555,
 		.child		= xfs_table
@@ -239,7 +208,6 @@ static ctl_table xfs_dir_table[] = {
 
 static ctl_table xfs_root_table[] = {
 	{
-		.ctl_name	= CTL_FS,
 		.procname	= "fs",
 		.mode		= 0555,
 		.child		= xfs_dir_table
-- 
1.6.5.2.143.g8cc62

