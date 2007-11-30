Return-Path: <linux-kernel-owner+w=401wt.eu-S935025AbXK3NSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935025AbXK3NSy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 08:18:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763481AbXK3NSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 08:18:44 -0500
Received: from sacred.ru ([62.205.161.221]:55435 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761708AbXK3NSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 08:18:43 -0500
Message-ID: <47500D8C.3000407@openvz.org>
Date: Fri, 30 Nov 2007 16:18:04 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: [PATCH 7/7][MQUEUE] Use the ctl paths to register tables
References: <475008F5.3000506@openvz.org>
In-Reply-To: <475008F5.3000506@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Fri, 30 Nov 2007 16:18:02 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Noting special - just build the "fs/mqueue/" path and use it.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 9ff4abf..22cb219 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -1229,21 +1229,13 @@ static ctl_table mq_sysctls[] = {
 	{ .ctl_name = 0 }
 };
 
-static ctl_table mq_sysctl_dir[] = {
+static struct ctl_path mq_sysctl_path[] = {
 	{
-		.procname	= "mqueue",
-		.mode		= 0555,
-		.child		= mq_sysctls,
+		.procname	= "fs",
+		.ctl_name	= CTL_FS,
 	},
-	{ .ctl_name = 0 }
-};
-
-static ctl_table mq_sysctl_root[] = {
 	{
-		.ctl_name	= CTL_FS,
-		.procname	= "fs",
-		.mode		= 0555,
-		.child		= mq_sysctl_dir,
+		.procname	= "mqueue",
 	},
 	{ .ctl_name = 0 }
 };
@@ -1262,7 +1254,7 @@ static int __init init_mqueue_fs(void)
 		return -ENOMEM;
 #ifdef CONFIG_SYSCTL
 	/* ignore failues - they are not fatal */
-	mq_sysctl_table = register_sysctl_table(mq_sysctl_root);
+	mq_sysctl_table = register_sysctl_paths(mq_sysctl_path, mq_sysctls);
 #endif
 	error = register_filesystem(&mqueue_fs_type);
 	if (error)
-- 
1.5.3.4

