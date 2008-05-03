Return-Path: <linux-kernel-owner+w=401wt.eu-S1757568AbYECOeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568AbYECOeT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 10:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755538AbYECOeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 10:34:00 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:49859 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755190AbYECOd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 10:33:58 -0400
X-Greylist: delayed 774 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 May 2008 10:33:58 EDT
From: monstr@seznam.cz
To: paulus@samba.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Michal Simek <monstr@monstr.eu>
Subject: [PATCH 1/1] DEBUGFS: Fixing name for debug fs
Date: Sat,  3 May 2008 16:35:14 +0200
Message-Id: <c65b09261996cf3500b6faee201e2dd6c152973e.1209825194.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <1209825314-8048-1-git-send-email-monstr@seznam.cz>
References: <monstr@seznam.cz>
 <1209825314-8048-1-git-send-email-monstr@seznam.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

This change is made because powerpc_debugfs_root is arch
specific name.

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/powerpc/kernel/irq.c          |    2 +-
 arch/powerpc/kernel/prom.c         |    2 +-
 arch/powerpc/kernel/setup-common.c |    6 +++---
 include/asm-powerpc/system.h       |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 2f73f70..95008ee 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -1072,7 +1072,7 @@ static const struct file_operations virq_debug_fops = {
 
 static int __init irq_debugfs_init(void)
 {
-	if (debugfs_create_file("virq_mapping", S_IRUGO, powerpc_debugfs_root,
+	if (debugfs_create_file("virq_mapping", S_IRUGO, debugfs_root,
 				 NULL, &virq_debug_fops))
 		return -ENOMEM;
 
diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index 2aefe2a..0946370 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -1631,7 +1631,7 @@ static int __init export_flat_device_tree(void)
 	flat_dt_blob.size = initial_boot_params->totalsize;
 
 	d = debugfs_create_blob("flat-device-tree", S_IFREG | S_IRUSR,
-				powerpc_debugfs_root, &flat_dt_blob);
+				debugfs_root, &flat_dt_blob);
 	if (!d)
 		return 1;
 
diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
index db540ea..e47caba 100644
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -661,13 +661,13 @@ late_initcall(check_cache_coherency);
 #endif /* CONFIG_CHECK_CACHE_COHERENCY */
 
 #ifdef CONFIG_DEBUG_FS
-struct dentry *powerpc_debugfs_root;
+struct dentry *debugfs_root;
 
 static int powerpc_debugfs_init(void)
 {
-	powerpc_debugfs_root = debugfs_create_dir("powerpc", NULL);
+	debugfs_root = debugfs_create_dir("powerpc", NULL);
 
-	return powerpc_debugfs_root == NULL;
+	return debugfs_root == NULL;
 }
 arch_initcall(powerpc_debugfs_init);
 #endif
diff --git a/include/asm-powerpc/system.h b/include/asm-powerpc/system.h
index 2b6559a..9d1ef16 100644
--- a/include/asm-powerpc/system.h
+++ b/include/asm-powerpc/system.h
@@ -570,7 +570,7 @@ static inline void create_function_call(unsigned long addr, void * func)
 extern void account_system_vtime(struct task_struct *);
 #endif
 
-extern struct dentry *powerpc_debugfs_root;
+extern struct dentry *debugfs_root;
 
 #endif /* __KERNEL__ */
 #endif /* _ASM_POWERPC_SYSTEM_H */
-- 
1.5.4.GIT

