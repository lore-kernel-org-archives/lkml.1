Return-Path: <linux-kernel-owner+w=401wt.eu-S935965AbYEUPzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935965AbYEUPzB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 11:55:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935469AbYEUPyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 11:54:43 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:37481 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935054AbYEUPyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 11:54:41 -0400
Subject: [RFC][Patch 2/4] integrity: special fs magic
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: safford@watson.ibm.com, serue@linux.vnet.ibm.com, sailer@watson.ibm.com,
       zohar@us.ibm.com, Stephen Smalley <sds@tycho.nsa.gov>,
       CaseySchaufler <casey@schaufler-ca.com>
Content-Type: text/plain
Date: Wed, 21 May 2008 11:54:29 -0400
Message-Id: <1211385269.20922.26.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Move special fs magic number definitions to magic.h
- Add magic.h include

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
Index: linux-2.6.26-rc3-git2/mm/shmem.c
===================================================================
--- linux-2.6.26-rc3-git2.orig/mm/shmem.c
+++ linux-2.6.26-rc3-git2/mm/shmem.c
@@ -50,14 +50,12 @@
 #include <linux/migrate.h>
 #include <linux/highmem.h>
 #include <linux/seq_file.h>
+#include <linux/magic.h>
 
 #include <asm/uaccess.h>
 #include <asm/div64.h>
 #include <asm/pgtable.h>
 
-/* This magic number is used in glibc for posix shared memory */
-#define TMPFS_MAGIC	0x01021994
-
 #define ENTRIES_PER_PAGE (PAGE_CACHE_SIZE/sizeof(unsigned long))
 #define ENTRIES_PER_PAGEPAGE (ENTRIES_PER_PAGE*ENTRIES_PER_PAGE)
 #define BLOCKS_PER_PAGE  (PAGE_CACHE_SIZE/512)
Index: linux-2.6.26-rc3-git2/security/inode.c
===================================================================
--- linux-2.6.26-rc3-git2.orig/security/inode.c
+++ linux-2.6.26-rc3-git2/security/inode.c
@@ -20,8 +20,7 @@
 #include <linux/init.h>
 #include <linux/namei.h>
 #include <linux/security.h>
-
-#define SECURITYFS_MAGIC	0x73636673
+#include <linux/magic.h>
 
 static struct vfsmount *mount;
 static int mount_count;
Index: linux-2.6.26-rc3-git2/include/linux/magic.h
===================================================================
--- linux-2.6.26-rc3-git2.orig/include/linux/magic.h
+++ linux-2.6.26-rc3-git2/include/linux/magic.h
@@ -6,6 +6,10 @@
 #define AFS_SUPER_MAGIC                0x5346414F
 #define AUTOFS_SUPER_MAGIC	0x0187
 #define CODA_SUPER_MAGIC	0x73757245
+#define DEBUGFS_MAGIC          0x64626720
+#define SYSFS_MAGIC		0x62656572
+#define SECURITYFS_MAGIC	0x73636673
+#define TMPFS_MAGIC		0x01021994
 #define EFS_SUPER_MAGIC		0x414A53
 #define EXT2_SUPER_MAGIC	0xEF53
 #define EXT3_SUPER_MAGIC	0xEF53
Index: linux-2.6.26-rc3-git2/fs/debugfs/inode.c
===================================================================
--- linux-2.6.26-rc3-git2.orig/fs/debugfs/inode.c
+++ linux-2.6.26-rc3-git2/fs/debugfs/inode.c
@@ -26,8 +26,7 @@
 #include <linux/debugfs.h>
 #include <linux/fsnotify.h>
 #include <linux/string.h>
-
-#define DEBUGFS_MAGIC	0x64626720
+#include <linux/magic.h>
 
 static struct vfsmount *debugfs_mount;
 static int debugfs_mount_count;


