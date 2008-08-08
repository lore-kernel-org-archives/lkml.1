Return-Path: <linux-kernel-owner+w=401wt.eu-S1759263AbYHHS4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759263AbYHHS4H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 14:56:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755488AbYHHSzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 14:55:52 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58008 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754988AbYHHSzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 14:55:51 -0400
Subject: [PATCH 2/4] integrity: special fs magic
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
       Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, sailer@watson.ibm.com, zohar@us.ibm.com
References: <20080808184349.999902616@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Fri, 08 Aug 2008 14:55:42 -0400
Message-Id: <1218221742.4444.12.camel@localhost.localdomain>
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

Index: security-testing-2.6/fs/debugfs/inode.c
===================================================================
--- security-testing-2.6.orig/fs/debugfs/inode.c
+++ security-testing-2.6/fs/debugfs/inode.c
@@ -26,8 +26,7 @@
 #include <linux/debugfs.h>
 #include <linux/fsnotify.h>
 #include <linux/string.h>
-
-#define DEBUGFS_MAGIC	0x64626720
+#include <linux/magic.h>
 
 static struct vfsmount *debugfs_mount;
 static int debugfs_mount_count;
Index: security-testing-2.6/include/linux/magic.h
===================================================================
--- security-testing-2.6.orig/include/linux/magic.h
+++ security-testing-2.6/include/linux/magic.h
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
Index: security-testing-2.6/mm/shmem.c
===================================================================
--- security-testing-2.6.orig/mm/shmem.c
+++ security-testing-2.6/mm/shmem.c
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
Index: security-testing-2.6/security/inode.c
===================================================================
--- security-testing-2.6.orig/security/inode.c
+++ security-testing-2.6/security/inode.c
@@ -20,8 +20,7 @@
 #include <linux/init.h>
 #include <linux/namei.h>
 #include <linux/security.h>
-
-#define SECURITYFS_MAGIC	0x73636673
+#include <linux/magic.h>
 
 static struct vfsmount *mount;
 static int mount_count;

-- 

