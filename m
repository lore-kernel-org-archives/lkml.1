Return-Path: <linux-kernel-owner+w=401wt.eu-S1754189AbYC3OyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbYC3OyW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 10:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbYC3OyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 10:54:14 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:13677 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650AbYC3OyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 10:54:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=cKkkI1PbUn2LK1RJ8YGquGPQ+LXvvFImDYXYnN/2Sv8CMujc8YRtdqsyTJNAbWJD2V9A9+QrLDpVdYJmuixSp3xrp6J3XQyQ0o8mRNz21hVo/Rz/A7sPsfPo+E4iSZw9ALIoSBZrBh3YDA6NSrKI4rjlABWoKgGhINpTaw1Ag9c=
Date: Sun, 30 Mar 2008 18:50:40 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -mm 6/3] proc: remove proc_root_driver
Message-ID: <20080330145040.GC4317@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use creation by full path: "driver/foo".

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/block/cciss.c       |    4 ++--
 drivers/block/cpqarray.c    |    4 ++--
 drivers/block/pktcdvd.c     |    4 ++--
 drivers/net/wireless/airo.c |    8 ++++----
 fs/proc/root.c              |    5 +----
 include/linux/proc_fs.h     |    3 ---
 6 files changed, 11 insertions(+), 17 deletions(-)

--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -424,7 +424,7 @@ static void __devinit cciss_procinit(int i)
 	struct proc_dir_entry *pde;
 
 	if (proc_cciss == NULL)
-		proc_cciss = proc_mkdir("cciss", proc_root_driver);
+		proc_cciss = proc_mkdir("driver/cciss", NULL);
 	if (!proc_cciss)
 		return;
 	pde = proc_create(hba[i]->devname, S_IWUSR | S_IRUSR | S_IRGRP |
@@ -3684,7 +3684,7 @@ static void __exit cciss_cleanup(void)
 			cciss_remove_one(hba[i]->pdev);
 		}
 	}
-	remove_proc_entry("cciss", proc_root_driver);
+	remove_proc_entry("driver/cciss", NULL);
 }
 
 static void fail_all_cmds(unsigned long ctlr)
--- a/drivers/block/cpqarray.c
+++ b/drivers/block/cpqarray.c
@@ -214,7 +214,7 @@ static struct proc_dir_entry *proc_array;
 static void __init ida_procinit(int i)
 {
 	if (proc_array == NULL) {
-		proc_array = proc_mkdir("cpqarray", proc_root_driver);
+		proc_array = proc_mkdir("driver/cpqarray", NULL);
 		if (!proc_array) return;
 	}
 
@@ -1796,7 +1796,7 @@ static void __exit cpqarray_exit(void)
 		}
 	}
 
-	remove_proc_entry("cpqarray", proc_root_driver);
+	remove_proc_entry("driver/cpqarray", NULL);
 }
 
 module_init(cpqarray_init)
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -3101,7 +3101,7 @@ static int __init pkt_init(void)
 		goto out_misc;
 	}
 
-	pkt_proc = proc_mkdir(DRIVER_NAME, proc_root_driver);
+	pkt_proc = proc_mkdir("driver/"DRIVER_NAME, NULL);
 
 	return 0;
 
@@ -3117,7 +3117,7 @@ out2:
 
 static void __exit pkt_exit(void)
 {
-	remove_proc_entry(DRIVER_NAME, proc_root_driver);
+	remove_proc_entry("driver/"DRIVER_NAME, NULL);
 	misc_deregister(&pkt_misc);
 
 	pkt_debugfs_cleanup();
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -5625,9 +5625,9 @@ static int __init airo_init_module( void )
 	int have_isa_dev = 0;
 #endif
 
-	airo_entry = create_proc_entry("aironet",
+	airo_entry = create_proc_entry("driver/aironet",
 				       S_IFDIR | airo_perm,
-				       proc_root_driver);
+				       NULL);
 
 	if (airo_entry) {
 		airo_entry->uid = proc_uid;
@@ -5651,7 +5651,7 @@ static int __init airo_init_module( void )
 	airo_print_info("", "Finished probing for PCI adapters");
 
 	if (i) {
-		remove_proc_entry("aironet", proc_root_driver);
+		remove_proc_entry("driver/aironet", NULL);
 		return i;
 	}
 #endif
@@ -5673,7 +5673,7 @@ static void __exit airo_cleanup_module( void )
 #ifdef CONFIG_PCI
 	pci_unregister_driver(&airo_driver);
 #endif
-	remove_proc_entry("aironet", proc_root_driver);
+	remove_proc_entry("driver/aironet", NULL);
 }
 
 /*
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -22,8 +22,6 @@
 
 #include "internal.h"
 
-struct proc_dir_entry *proc_root_driver;
-
 static int proc_test_super(struct super_block *sb, void *data)
 {
 	return sb->s_fs_info == data;
@@ -127,7 +125,7 @@ void __init proc_root_init(void)
 	proc_mkdir("sysvipc", NULL);
 #endif
 	proc_mkdir("fs", NULL);
-	proc_root_driver = proc_mkdir("driver", NULL);
+	proc_mkdir("driver", NULL);
 	proc_mkdir("fs/nfsd", NULL); /* somewhere for the nfsd filesystem to be mounted */
 #if defined(CONFIG_SUN_OPENPROMFS) || defined(CONFIG_SUN_OPENPROMFS_MODULE)
 	/* just give it a mountpoint */
@@ -235,4 +233,3 @@ EXPORT_SYMBOL(create_proc_entry);
 EXPORT_SYMBOL(proc_create);
 EXPORT_SYMBOL(remove_proc_entry);
 EXPORT_SYMBOL(proc_root);
-EXPORT_SYMBOL(proc_root_driver);
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -97,7 +97,6 @@ struct vmcore {
 #ifdef CONFIG_PROC_FS
 
 extern struct proc_dir_entry proc_root;
-extern struct proc_dir_entry *proc_root_driver;
 extern struct proc_dir_entry *proc_root_kcore;
 
 extern spinlock_t proc_subdir_lock;
@@ -211,8 +210,6 @@ extern void dup_mm_exe_file(struct mm_struct *oldmm, struct mm_struct *newmm);
 
 #else
 
-#define proc_root_driver NULL
-
 #define proc_net_fops_create(net, name, mode, fops)  ({ (void)(mode), NULL; })
 static inline void proc_net_remove(struct net *net, const char *name) {}
 
-- 
1.5.4.3


