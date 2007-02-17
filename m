Return-Path: <linux-kernel-owner+w=401wt.eu-S965073AbXBQI5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965073AbXBQI5J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 03:57:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965075AbXBQI5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 03:57:08 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:33982 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965070AbXBQI5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 03:57:06 -0500
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 2/2] fs/unionfs/: Remove unused structure members & macros
Date: Sat, 17 Feb 2007 03:56:56 -0500
Message-Id: <11717026162673-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.19.gddff
In-Reply-To: <11717026161843-git-send-email-jsipek@cs.sunysb.edu>
References: <11717026161843-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes:
- hidden_mnt pointer from struct unionfs_data
- mount_flag from struct unionfs_sb_info
- mount_flag related macros

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/union.h |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index fc87b03..60276c7 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -54,9 +54,6 @@
 /* unionfs root inode number */
 #define UNIONFS_ROOT_INO     1
 
-/* Mount time flags */
-#define MOUNT_FLAG(sb)     (UNIONFS_SB(sb)->mount_flag)
-
 /* number of characters while generating unique temporary file names */
 #define	UNIONFS_TMPNAM_LEN	12
 
@@ -124,7 +121,6 @@ struct unionfs_dentry_info {
 /* These are the pointers to our various objects. */
 struct unionfs_data {
 	struct super_block *sb;
-	struct vfsmount *hidden_mnt;
 	atomic_t sbcount;
 	int branchperms;
 };
@@ -134,7 +130,6 @@ struct unionfs_sb_info {
 	int bend;
 
 	atomic_t generation;
-	unsigned long mount_flag;
 	struct rw_semaphore rwsem;
 
 	struct unionfs_data *data;
@@ -341,8 +336,6 @@ static inline int d_deleted(struct dentry *d)
 
 struct dentry *unionfs_lookup_backend(struct dentry *dentry, struct nameidata *nd, int lookupmode);
 
-#define IS_SET(sb, check_flag) ((check_flag) & MOUNT_FLAG(sb))
-
 /* unionfs_permission, check if we should bypass error to facilitate copyup */
 #define IS_COPYUP_ERR(err) ((err) == -EROFS)
 
@@ -405,8 +398,6 @@ static inline int is_robranch(const struct dentry *dentry)
 #define UNIONFS_DIR_OPAQUE_NAME "__dir_opaque"
 #define UNIONFS_DIR_OPAQUE UNIONFS_WHPFX UNIONFS_DIR_OPAQUE_NAME
 
-#define VALID_MOUNT_FLAGS (0)
-
 #ifndef DEFAULT_POLLMASK
 #define DEFAULT_POLLMASK (POLLIN | POLLOUT | POLLRDNORM | POLLWRNORM)
 #endif
-- 
1.5.0.19.gddff

