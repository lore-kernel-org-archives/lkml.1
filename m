Return-Path: <linux-kernel-owner+w=401wt.eu-S932468AbXK3NDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468AbXK3NDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 08:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758332AbXK3NDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 08:03:00 -0500
Received: from sacred.ru ([62.205.161.221]:45602 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758028AbXK3NC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 08:02:59 -0500
Message-ID: <475009FA.20409@openvz.org>
Date: Fri, 30 Nov 2007 16:02:50 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: [PATCH 1/7][QUOTA] Move sysctl management code under ifdef CONFIG_SYSCTL
References: <475008F5.3000506@openvz.org>
In-Reply-To: <475008F5.3000506@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Fri, 30 Nov 2007 16:02:48 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This includes the tables themselves and the call to the
register_sysctl_table(). Since this call is done from the __init
call, I hope this is OK to keep the #ifdef inside the function, 
rather than making proper helpers outside it.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

diff --git a/fs/dquot.c b/fs/dquot.c
index 50e7c2a..efee14d 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -1821,6 +1821,7 @@ struct quotactl_ops vfs_quotactl_ops = {
 	.set_dqblk	= vfs_set_dqblk
 };
 
+#ifdef CONFIG_SYSCTL
 static ctl_table fs_dqstats_table[] = {
 	{
 		.ctl_name	= FS_DQ_LOOKUPS,
@@ -1918,6 +1919,7 @@ static ctl_table sys_table[] = {
 	},
 	{ .ctl_name = 0 },
 };
+#endif
 
 static int __init dquot_init(void)
 {
@@ -1926,7 +1928,9 @@ static int __init dquot_init(void)
 
 	printk(KERN_NOTICE "VFS: Disk quotas %s\n", __DQUOT_VERSION__);
 
+#ifdef CONFIG_SYSCTL
 	register_sysctl_table(sys_table);
+#endif
 
 	dquot_cachep = kmem_cache_create("dquot",
 			sizeof(struct dquot), sizeof(unsigned long) * 4,
-- 
1.5.3.4


