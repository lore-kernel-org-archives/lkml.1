Return-Path: <linux-kernel-owner+w=401wt.eu-S1764680AbXKCATY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764680AbXKCATY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762440AbXKCAEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:04:30 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:57896 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762314AbXKCAE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:04:28 -0400
Date: Sat, 3 Nov 2007 01:04:05 +0100
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] proper prototype for get_filesystem_list()
Message-ID: <20071103000405.GC4594@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a proper prototype for migration_init() in
include/linux/fs.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 fs/proc/proc_misc.c |    1 -
 include/linux/fs.h  |    1 +
 init/do_mounts.c    |    3 +--
 3 files changed, 2 insertions(+), 3 deletions(-)

769db79bc8aef7d9612c5ea7045f8a956d628e7a 
diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index e0d064e..163b7d2 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -63,7 +63,6 @@
  */
 extern int get_hardware_list(char *);
 extern int get_stram_list(char *);
-extern int get_filesystem_list(char *);
 extern int get_exec_domain_list(char *);
 extern int get_dma_list(char *);
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b3ec4a4..d296dcc 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2095,6 +2095,7 @@ struct ctl_table;
 int proc_nr_files(struct ctl_table *table, int write, struct file *filp,
 		  void __user *buffer, size_t *lenp, loff_t *ppos);
 
+int get_filesystem_list(char * buf);
 
 #endif /* __KERNEL__ */
 #endif /* _LINUX_FS_H */
diff --git a/init/do_mounts.c b/init/do_mounts.c
index 4efa1e5..3aafc09 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -11,6 +11,7 @@
 #include <linux/mount.h>
 #include <linux/device.h>
 #include <linux/init.h>
+#include <linux/fs.h>
 
 #include <linux/nfs_fs.h>
 #include <linux/nfs_fs_sb.h>
@@ -18,8 +19,6 @@
 
 #include "do_mounts.h"
 
-extern int get_filesystem_list(char * buf);
-
 int __initdata rd_doload;	/* 1 = load RAM disk, 0 = don't load */
 
 int root_mountflags = MS_RDONLY | MS_SILENT;

