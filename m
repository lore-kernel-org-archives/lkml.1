Return-Path: <linux-kernel-owner+w=401wt.eu-S1754170AbXJAFyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbXJAFyh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 01:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbXJAFvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 01:51:44 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40786 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbXJAFva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 01:51:30 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 18/19] Unionfs: coding style: miscellaneous fixes
Date: Mon,  1 Oct 2007 01:50:55 -0400
Message-Id: <11912178642252-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <1191217856647-git-send-email-ezk@cs.sunysb.edu>
References: <1191217856647-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

No braces around single-statement if's.
No externs in .c files.
use <linux/mman.h> not <asm/mman.h>.
Use (foo *) not (foo*).

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/rdstate.c |    3 +--
 fs/unionfs/super.c   |    3 +--
 fs/unionfs/union.h   |    3 ++-
 fs/unionfs/xattr.c   |    6 +++---
 4 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/unionfs/rdstate.c b/fs/unionfs/rdstate.c
index 93ea588..0df5f52 100644
--- a/fs/unionfs/rdstate.c
+++ b/fs/unionfs/rdstate.c
@@ -218,12 +218,11 @@ struct filldir_node *find_filldir_node(struct unionfs_dir_state *rdstate,
 			 * if the duplicate is in this branch, then the file
 			 * system is corrupted.
 			 */
-			if (unlikely(cursor->bindex == rdstate->bindex)) {
+			if (unlikely(cursor->bindex == rdstate->bindex))
 				printk(KERN_ERR "unionfs: filldir: possible "
 				       "I/O error: a file is duplicated "
 				       "in the same branch %d: %s\n",
 				       rdstate->bindex, cursor->name);
-			}
 			break;
 		}
 	}
diff --git a/fs/unionfs/super.c b/fs/unionfs/super.c
index 0a0b075..515689d 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -26,7 +26,6 @@ static struct kmem_cache *unionfs_inode_cachep;
 
 static void unionfs_read_inode(struct inode *inode)
 {
-	extern struct address_space_operations unionfs_aops;
 	int size;
 	struct unionfs_inode_info *info = UNIONFS_I(inode);
 
@@ -965,7 +964,7 @@ static int unionfs_show_options(struct seq_file *m, struct vfsmount *mnt)
 
 	unionfs_lock_dentry(sb->s_root);
 
-	tmp_page = (char*) __get_free_page(GFP_KERNEL);
+	tmp_page = (char *) __get_free_page(GFP_KERNEL);
 	if (unlikely(!tmp_page)) {
 		ret = -ENOMEM;
 		goto out;
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index ee8324c..8eb2ee4 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -44,8 +44,8 @@
 #include <linux/magic.h>
 #include <linux/log2.h>
 #include <linux/poison.h>
+#include <linux/mman.h>
 
-#include <asm/mman.h>
 #include <asm/system.h>
 
 #include <linux/union_fs.h>
@@ -70,6 +70,7 @@ extern struct inode_operations unionfs_dir_iops;
 extern struct inode_operations unionfs_symlink_iops;
 extern struct super_operations unionfs_sops;
 extern struct dentry_operations unionfs_dops;
+extern struct address_space_operations unionfs_aops;
 
 /* How long should an entry be allowed to persist */
 #define RDCACHE_JIFFIES	(5*HZ)
diff --git a/fs/unionfs/xattr.c b/fs/unionfs/xattr.c
index 71ff7d0..602cedf 100644
--- a/fs/unionfs/xattr.c
+++ b/fs/unionfs/xattr.c
@@ -55,7 +55,7 @@ ssize_t unionfs_getxattr(struct dentry *dentry, const char *name, void *value,
 
 	lower_dentry = unionfs_lower_dentry(dentry);
 
-	err = vfs_getxattr(lower_dentry, (char*) name, value, size);
+	err = vfs_getxattr(lower_dentry, (char *) name, value, size);
 
 out:
 	unionfs_unlock_dentry(dentry);
@@ -84,7 +84,7 @@ int unionfs_setxattr(struct dentry *dentry, const char *name,
 
 	lower_dentry = unionfs_lower_dentry(dentry);
 
-	err = vfs_setxattr(lower_dentry, (char*) name, (void*) value,
+	err = vfs_setxattr(lower_dentry, (char *) name, (void *) value,
 			   size, flags);
 
 out:
@@ -113,7 +113,7 @@ int unionfs_removexattr(struct dentry *dentry, const char *name)
 
 	lower_dentry = unionfs_lower_dentry(dentry);
 
-	err = vfs_removexattr(lower_dentry, (char*) name);
+	err = vfs_removexattr(lower_dentry, (char *) name);
 
 out:
 	unionfs_unlock_dentry(dentry);
-- 
1.5.2.2

