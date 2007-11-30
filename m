Return-Path: <linux-kernel-owner+w=401wt.eu-S934717AbXK3NF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934717AbXK3NF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 08:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758527AbXK3NFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 08:05:07 -0500
Received: from sacred.ru ([62.205.161.221]:34394 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757919AbXK3NFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 08:05:05 -0500
Message-ID: <47500A75.2060500@openvz.org>
Date: Fri, 30 Nov 2007 16:04:53 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: [PATCH 2/7][QUOTA] Use sysctl paths to register tables
References: <475008F5.3000506@openvz.org>
In-Reply-To: <475008F5.3000506@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Fri, 30 Nov 2007 16:04:53 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We need the fs/quota/ path for the quota tables.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

diff --git a/fs/dquot.c b/fs/dquot.c
index efee14d..1968495 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -1900,22 +1900,14 @@ static ctl_table fs_dqstats_table[] = {
 	{ .ctl_name = 0 },
 };
 
-static ctl_table fs_table[] = {
+static struct ctl_path fs_quota_path[] = {
 	{
-		.ctl_name	= FS_DQSTATS,
-		.procname	= "quota",
-		.mode		= 0555,
-		.child		= fs_dqstats_table,
+		.procname	= "fs",
+		.ctl_name	= CTL_FS,
 	},
-	{ .ctl_name = 0 },
-};
-
-static ctl_table sys_table[] = {
 	{
-		.ctl_name	= CTL_FS,
-		.procname	= "fs",
-		.mode		= 0555,
-		.child		= fs_table,
+		.procname	= "quota",
+		.ctl_name	= FS_DQSTATS,
 	},
 	{ .ctl_name = 0 },
 };
@@ -1929,7 +1921,7 @@ static int __init dquot_init(void)
 	printk(KERN_NOTICE "VFS: Disk quotas %s\n", __DQUOT_VERSION__);
 
 #ifdef CONFIG_SYSCTL
-	register_sysctl_table(sys_table);
+	register_sysctl_paths(fs_quota_path, fs_dqstats_table);
 #endif
 
 	dquot_cachep = kmem_cache_create("dquot",
-- 
1.5.3.4

