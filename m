Return-Path: <linux-kernel-owner+w=401wt.eu-S965283AbXBLSbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965283AbXBLSbd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 13:31:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965282AbXBLSbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 13:31:15 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:34241 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965277AbXBLSbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 13:31:10 -0500
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 3/3] Unionfs: Documentation update
Date: Mon, 12 Feb 2007 13:30:52 -0500
Message-Id: <11713050532613-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.rc3.g5057
In-Reply-To: <11713050521708-git-send-email-jsipek@cs.sunysb.edu>
References: <11713050521708-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Be little gentler & updated the URLs

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 Documentation/filesystems/unionfs/00-INDEX   |    8 ++++--
 Documentation/filesystems/unionfs/issues.txt |   23 +++++++++++++++++++
 Documentation/filesystems/unionfs/usage.txt  |   31 ++++++++-----------------
 fs/Kconfig                                   |    2 +-
 fs/unionfs/main.c                            |    2 +-
 5 files changed, 40 insertions(+), 26 deletions(-)
 create mode 100644 Documentation/filesystems/unionfs/issues.txt

diff --git a/Documentation/filesystems/unionfs/00-INDEX b/Documentation/filesystems/unionfs/00-INDEX
index 32e96f2..96fdf67 100644
--- a/Documentation/filesystems/unionfs/00-INDEX
+++ b/Documentation/filesystems/unionfs/00-INDEX
@@ -1,8 +1,10 @@
 00-INDEX
 	- this file.
 concepts.txt
-	- A brief introduction of concepts
+	- A brief introduction of concepts.
+issues.txt
+	- A summary of known issues with unionfs.
 rename.txt
-	- Information regarding rename operations
+	- Information regarding rename operations.
 usage.txt
-	- Usage and known limitations
+	- Usage information and examples.
diff --git a/Documentation/filesystems/unionfs/issues.txt b/Documentation/filesystems/unionfs/issues.txt
new file mode 100644
index 0000000..b070175
--- /dev/null
+++ b/Documentation/filesystems/unionfs/issues.txt
@@ -0,0 +1,23 @@
+KNOWN Unionfs ISSUES:
+=====================
+
+1. The NFS server returns -EACCES for read-only exports, instead of -EROFS.
+   This means we can't reliably detect a read-only NFS export.
+
+2. Modifying a Unionfs branch directly, while the union is mounted, is
+   currently unsupported.  We have tested Unionfs under such conditions, and
+   fixed any bugs we found (Unionfs comes with an extensive regression test
+   suite).  However, it may still be possible that changes made to lower
+   branches directly could cause cache incoherency which, in the worst case,
+   may case an oops.  We are currently addressing this problem for Unionfs
+   and also generically for all stackable file systems, by handing mmap and
+   introducing small VFS/MM changes that would allow a file system to handle
+   cache coherency correctly.
+
+3. Unionfs should not use lookup_one_len() on the underlying f/s as it
+   confuses NFS.  Currently, unionfs_lookup() passes lookup intents to the
+   lower file-system, this eliminates part of the problem.  The remaining
+   calls to lookup_one_len may need to be changed to pass an intent.
+
+
+For more information, see <unionfs.filesystems.org>.
diff --git a/Documentation/filesystems/unionfs/usage.txt b/Documentation/filesystems/unionfs/usage.txt
index 3968c9e..14e0856 100644
--- a/Documentation/filesystems/unionfs/usage.txt
+++ b/Documentation/filesystems/unionfs/usage.txt
@@ -1,17 +1,18 @@
 Unionfs is a stackable unification file system, which can appear to merge
 the contents of several directories (branches), while keeping their physical
-content separate. Unionfs is useful for unified source tree management,
+content separate.  Unionfs is useful for unified source tree management,
 merged contents of split CD-ROM, merged separate software package
-directories, data grids, and more. Unionfs allows any mix of read-only and
+directories, data grids, and more.  Unionfs allows any mix of read-only and
 read-write branches, as well as insertion and deletion of branches anywhere
-in the fan-out. To maintain unix semantics, Unionfs handles elimination of
+in the fan-out.  To maintain Unix semantics, Unionfs handles elimination of
 duplicates, partial-error conditions, and more.
 
-mount -t unionfs -o branch-option[,union-options[,...]] none MOUNTPOINT
+# mount -t unionfs -o branch-option[,union-options[,...]] none MOUNTPOINT
 
 The available branch-option for the mount command is:
 
-dirs=branch[=ro|=rw][:...]
+	dirs=branch[=ro|=rw][:...]
+
 specifies a separated list of which directories compose the union.
 Directories that come earlier in the list have a higher precedence than
 those which come later. Additionally, read-only or read-write permissions of
@@ -19,24 +20,12 @@ the branch can be specified by appending =ro or =rw (default) to each
 directory.
 
 Syntax:
-dirs=/branch1[=ro|=rw]:/branch2[=ro|=rw]:...:/branchN[=ro|=rw]
-
-Example:
-dirs=/writable_branch=rw:/read-only_branch=ro
 
+	dirs=/branch1[=ro|=rw]:/branch2[=ro|=rw]:...:/branchN[=ro|=rw]
 
-KNOWN ISSUES:
-=============
-
-The NFS server returns -EACCES for read-only exports, instead of -EROFS.
-This means we can't reliably detect a read-only NFS export.
+Example:
 
-Modifying a Unionfs branch directly, while the union is mounted, is
-currently unsupported.  Any such change can cause Unionfs to oops, or stay
-silent and even RESULT IN DATA LOSS.
+	dirs=/writable_branch=rw:/read-only_branch=ro
 
-Unionfs should not use lookup_one_len() on the underlying fs as it confuses
-NFS. Currently, unionfs_lookup() passes lookup intents to the lower
-filesystem, this eliminates part of the problem. The remaining calls to
-lookup_one_len may need to be changed to pass an intent.
 
+For more information, see unionfs.filesystems.org.
diff --git a/fs/Kconfig b/fs/Kconfig
index 99ea991..10a216e 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -1063,7 +1063,7 @@ config UNION_FS
 	  merge the contents of several directories (branches), while keeping
 	  their physical content separate.
 
-	  See <http://www.unionfs.org> for details
+	  See <http://unionfs.filesystems.org> for details
 
 config UNION_FS_XATTR
 	bool "Unionfs extended attributes"
diff --git a/fs/unionfs/main.c b/fs/unionfs/main.c
index 36d30bc..ca7ee26 100644
--- a/fs/unionfs/main.c
+++ b/fs/unionfs/main.c
@@ -679,7 +679,7 @@ static void __exit exit_unionfs_fs(void)
 MODULE_AUTHOR("Erez Zadok, Filesystems and Storage Lab, Stony Brook University"
 		" (http://www.fsl.cs.sunysb.edu)");
 MODULE_DESCRIPTION("Unionfs " UNIONFS_VERSION
-		" (http://www.unionfs.org)");
+		" (http://unionfs.filesystems.org)");
 MODULE_LICENSE("GPL");
 
 module_init(init_unionfs_fs);
-- 
1.5.0.rc3.g5057

