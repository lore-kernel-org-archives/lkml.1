Return-Path: <linux-kernel-owner+w=401wt.eu-S1759681AbYGPUFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759681AbYGPUFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 16:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759213AbYGPUFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 16:05:20 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60328 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759105AbYGPUFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 16:05:18 -0400
Subject: [Patch 3/5] integrity: special fs magic
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       safford@watson.ibm.com, serue@linux.vnet.ibm.com, sailer@watson.ibm.com,
       zohar@us.ibm.com, debora@linux.vnet.ibm.com, srajiv@linux.vnet.ibm.com
In-Reply-To: <Xine.LNX.4.64.0807160910470.8360@us.intercode.com.au>
References: <20080707192529.489789904@linux.vnet.ibm.com>
	 <1215467789.27626.3.camel@localhost.localdomain>
	 <Xine.LNX.4.64.0807160910470.8360@us.intercode.com.au>
Content-Type: text/plain
Date: Wed, 16 Jul 2008 16:05:13 -0400
Message-Id: <1216238713.5886.28.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Move special fs magic number definitions to magic.h
- Add magic.h include

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>

Reviewed-by: James Morris <jmorris@namei.org>
---
Index: linux-2.6.26-git3/mm/shmem.c
===================================================================
--- linux-2.6.26-git3.orig/mm/shmem.c
+++ linux-2.6.26-git3/mm/shmem.c
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
Index: linux-2.6.26-git3/security/inode.c
===================================================================
--- linux-2.6.26-git3.orig/security/inode.c
+++ linux-2.6.26-git3/security/inode.c
@@ -20,8 +20,7 @@
 #include <linux/init.h>
 #include <linux/namei.h>
 #include <linux/security.h>
-
-#define SECURITYFS_MAGIC	0x73636673
+#include <linux/magic.h>
 
 static struct vfsmount *mount;
 static int mount_count;
Index: linux-2.6.26-git3/include/linux/magic.h
===================================================================
--- linux-2.6.26-git3.orig/include/linux/magic.h
+++ linux-2.6.26-git3/include/linux/magic.h
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
Index: linux-2.6.26-git3/fs/debugfs/inode.c
===================================================================
--- linux-2.6.26-git3.orig/fs/debugfs/inode.c
+++ linux-2.6.26-git3/fs/debugfs/inode.c
@@ -26,8 +26,7 @@
 #include <linux/debugfs.h>
 #include <linux/fsnotify.h>
 #include <linux/string.h>
-
-#define DEBUGFS_MAGIC	0x64626720
+#include <linux/magic.h>
 
 static struct vfsmount *debugfs_mount;
 static int debugfs_mount_count;


