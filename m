Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbYJGSaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbYJGSaO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 14:30:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753967AbYJGS34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 14:29:56 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:41935 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753406AbYJGS3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 14:29:55 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH 2/4] integrity: special fs magic
Date: Tue,  7 Oct 2008 14:00:12 -0400
Message-Id: <87b9b5f88d5ed93a7985c14b413cf8d74ceea69c.1223401604.git.zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <cover.1223401603.git.zohar@linux.vnet.ibm.com>
References: <cover.1223401603.git.zohar@linux.vnet.ibm.com>
In-Reply-To: <cover.1223401603.git.zohar@linux.vnet.ibm.com>
References: <cover.1223401603.git.zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Discussion on the mailing list questioned the use of these
magic values in userspace, concluding these values are already
exported to userspace via statfs and their correct/incorrect
usage is left up to the userspace application.

  - Move special fs magic number definitions to magic.h
  - Add magic.h include

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Reviewed-by: James Morris <jmorris@namei.org>
---
diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 08e28c9..3dbe216 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -26,8 +26,7 @@
 #include <linux/debugfs.h>
 #include <linux/fsnotify.h>
 #include <linux/string.h>
-
-#define DEBUGFS_MAGIC	0x64626720
+#include <linux/magic.h>
 
 static struct vfsmount *debugfs_mount;
 static int debugfs_mount_count;
diff --git a/include/linux/magic.h b/include/linux/magic.h
index 1fa0c2c..f7f3fdd 100644
--- a/include/linux/magic.h
+++ b/include/linux/magic.h
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
diff --git a/mm/shmem.c b/mm/shmem.c
index c1e5a3b..c4e63c4 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
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
diff --git a/security/inode.c b/security/inode.c
index acc6cf0..b66df8e 100644
--- a/security/inode.c
+++ b/security/inode.c
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
1.5.5.1

