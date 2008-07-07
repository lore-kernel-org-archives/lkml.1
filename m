Return-Path: <linux-kernel-owner+w=401wt.eu-S1758819AbYGGV50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758819AbYGGV50 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 17:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757409AbYGGV5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 17:57:00 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:60687 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758739AbYGGV47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 17:56:59 -0400
Subject: [PATCH 3/5] integrity: special fs magic
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, sailer@watson.ibm.com, zohar@us.ibm.com
References: <20080707192529.489789904@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Mon, 07 Jul 2008 17:56:56 -0400
Message-Id: <1215467816.27626.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Move special fs magic number definitions to magic.h
- Add magic.h include

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
Index: linux-2.6.26-rc9-git1/mm/shmem.c
===================================================================
--- linux-2.6.26-rc9-git1.orig/mm/shmem.c
+++ linux-2.6.26-rc9-git1/mm/shmem.c
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
Index: linux-2.6.26-rc9-git1/security/inode.c
===================================================================
--- linux-2.6.26-rc9-git1.orig/security/inode.c
+++ linux-2.6.26-rc9-git1/security/inode.c
@@ -20,8 +20,7 @@
 #include <linux/init.h>
 #include <linux/namei.h>
 #include <linux/security.h>
-
-#define SECURITYFS_MAGIC	0x73636673
+#include <linux/magic.h>
 
 static struct vfsmount *mount;
 static int mount_count;
Index: linux-2.6.26-rc9-git1/include/linux/magic.h
===================================================================
--- linux-2.6.26-rc9-git1.orig/include/linux/magic.h
+++ linux-2.6.26-rc9-git1/include/linux/magic.h
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
Index: linux-2.6.26-rc9-git1/fs/debugfs/inode.c
===================================================================
--- linux-2.6.26-rc9-git1.orig/fs/debugfs/inode.c
+++ linux-2.6.26-rc9-git1/fs/debugfs/inode.c
@@ -26,8 +26,7 @@
 #include <linux/debugfs.h>
 #include <linux/fsnotify.h>
 #include <linux/string.h>
-
-#define DEBUGFS_MAGIC	0x64626720
+#include <linux/magic.h>
 
 static struct vfsmount *debugfs_mount;
 static int debugfs_mount_count;

-- 

