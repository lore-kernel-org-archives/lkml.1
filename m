Return-Path: <linux-kernel-owner+w=401wt.eu-S1753890AbYC3Ox5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbYC3Ox5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 10:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbYC3Oxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 10:53:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:13677 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbYC3Oxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 10:53:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=QgAj1v2XZ2tmVy8Hrd9QYQ9PuxT6H6akY5BjDKqh2cBMvMKuslo3ByR45NyFtGcC6TA8pvZ1ZL1d06i2RH5xM5mrx5ISdjJnxW4WSg8BdHfzxwPaJFHIv2pmdy58nPNcsZZ0YNi3ew7GA9WAY0UYEEcXjsfRqHgEbuSXVamc9Xc=
Date: Sun, 30 Mar 2008 18:50:09 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -mm 5/3] proc: remove proc_root_fs
Message-ID: <20080330145009.GB4317@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use creation by full path instead: "fs/foo".

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/cifs/cifs_debug.c    |    4 ++--
 fs/ext4/mballoc.c       |    7 +++----
 fs/jfs/jfs_debug.c      |    4 ++--
 fs/nfs/client.c         |    6 +++---
 fs/proc/root.c          |    5 ++---
 include/linux/proc_fs.h |    1 -
 6 files changed, 12 insertions(+), 15 deletions(-)

--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -468,7 +468,7 @@ cifs_proc_init(void)
 {
 	struct proc_dir_entry *pde;
 
-	proc_fs_cifs = proc_mkdir("cifs", proc_root_fs);
+	proc_fs_cifs = proc_mkdir("fs/cifs", NULL);
 	if (proc_fs_cifs == NULL)
 		return;
 
@@ -559,7 +559,7 @@ cifs_proc_clean(void)
 	remove_proc_entry("LinuxExtensionsEnabled", proc_fs_cifs);
 	remove_proc_entry("Experimental", proc_fs_cifs);
 	remove_proc_entry("LookupCacheEnabled", proc_fs_cifs);
-	remove_proc_entry("cifs", proc_root_fs);
+	remove_proc_entry("fs/cifs", NULL);
 }
 
 static int
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2873,7 +2873,6 @@ static noinline void ext4_mb_free_committed_blocks(struct super_block *sb)
 	mb_debug("freed %u blocks in %u structures\n", count, count2);
 }
 
-#define EXT4_ROOT			"ext4"
 #define EXT4_MB_STATS_NAME		"stats"
 #define EXT4_MB_MAX_TO_SCAN_NAME	"max_to_scan"
 #define EXT4_MB_MIN_TO_SCAN_NAME	"min_to_scan"
@@ -3013,9 +3012,9 @@ int __init init_ext4_mballoc(void)
 		return -ENOMEM;
 	}
 #ifdef CONFIG_PROC_FS
-	proc_root_ext4 = proc_mkdir(EXT4_ROOT, proc_root_fs);
+	proc_root_ext4 = proc_mkdir("fs/ext4", NULL);
 	if (proc_root_ext4 == NULL)
-		printk(KERN_ERR "EXT4-fs: Unable to create %s\n", EXT4_ROOT);
+		printk(KERN_ERR "EXT4-fs: Unable to create fs/ext4\n");
 #endif
 	return 0;
 }
@@ -3026,7 +3025,7 @@ void exit_ext4_mballoc(void)
 	kmem_cache_destroy(ext4_pspace_cachep);
 	kmem_cache_destroy(ext4_ac_cachep);
 #ifdef CONFIG_PROC_FS
-	remove_proc_entry(EXT4_ROOT, proc_root_fs);
+	remove_proc_entry("fs/ext4", NULL);
 #endif
 }
 
--- a/fs/jfs/jfs_debug.c
+++ b/fs/jfs/jfs_debug.c
@@ -89,7 +89,7 @@ void jfs_proc_init(void)
 {
 	int i;
 
-	if (!(base = proc_mkdir("jfs", proc_root_fs)))
+	if (!(base = proc_mkdir("fs/jfs", NULL)))
 		return;
 	base->owner = THIS_MODULE;
 
@@ -109,7 +109,7 @@ void jfs_proc_clean(void)
 	if (base) {
 		for (i = 0; i < NPROCENT; i++)
 			remove_proc_entry(Entries[i].name, base);
-		remove_proc_entry("jfs", proc_root_fs);
+		remove_proc_entry("fs/jfs", NULL);
 	}
 }
 
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -1477,7 +1477,7 @@ int __init nfs_fs_proc_init(void)
 {
 	struct proc_dir_entry *p;
 
-	proc_fs_nfs = proc_mkdir("nfsfs", proc_root_fs);
+	proc_fs_nfs = proc_mkdir("fs/nfsfs", NULL);
 	if (!proc_fs_nfs)
 		goto error_0;
 
@@ -1503,7 +1503,7 @@ int __init nfs_fs_proc_init(void)
 error_2:
 	remove_proc_entry("servers", proc_fs_nfs);
 error_1:
-	remove_proc_entry("nfsfs", proc_root_fs);
+	remove_proc_entry("fs/nfsfs", NULL);
 error_0:
 	return -ENOMEM;
 }
@@ -1515,7 +1515,7 @@ void nfs_fs_proc_exit(void)
 {
 	remove_proc_entry("volumes", proc_fs_nfs);
 	remove_proc_entry("servers", proc_fs_nfs);
-	remove_proc_entry("nfsfs", proc_root_fs);
+	remove_proc_entry("fs/nfsfs", NULL);
 }
 
 #endif /* CONFIG_PROC_FS */
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -22,7 +22,7 @@
 
 #include "internal.h"
 
-struct proc_dir_entry *proc_root_fs, *proc_root_driver;
+struct proc_dir_entry *proc_root_driver;
 
 static int proc_test_super(struct super_block *sb, void *data)
 {
@@ -126,7 +126,7 @@ void __init proc_root_init(void)
 #ifdef CONFIG_SYSVIPC
 	proc_mkdir("sysvipc", NULL);
 #endif
-	proc_root_fs = proc_mkdir("fs", NULL);
+	proc_mkdir("fs", NULL);
 	proc_root_driver = proc_mkdir("driver", NULL);
 	proc_mkdir("fs/nfsd", NULL); /* somewhere for the nfsd filesystem to be mounted */
 #if defined(CONFIG_SUN_OPENPROMFS) || defined(CONFIG_SUN_OPENPROMFS_MODULE)
@@ -235,5 +235,4 @@ EXPORT_SYMBOL(create_proc_entry);
 EXPORT_SYMBOL(proc_create);
 EXPORT_SYMBOL(remove_proc_entry);
 EXPORT_SYMBOL(proc_root);
-EXPORT_SYMBOL(proc_root_fs);
 EXPORT_SYMBOL(proc_root_driver);
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -97,7 +97,6 @@ struct vmcore {
 #ifdef CONFIG_PROC_FS
 
 extern struct proc_dir_entry proc_root;
-extern struct proc_dir_entry *proc_root_fs;
 extern struct proc_dir_entry *proc_root_driver;
 extern struct proc_dir_entry *proc_root_kcore;
 
-- 
1.5.4.3


