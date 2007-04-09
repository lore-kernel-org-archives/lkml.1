Return-Path: <linux-kernel-owner+w=401wt.eu-S933662AbXDIPBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933662AbXDIPBr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 11:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933865AbXDIPBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 11:01:43 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:43992 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933663AbXDIOyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 10:54:32 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 13/21] Unionfs: Remove the older incgen ioctl
Date: Mon,  9 Apr 2007 10:54:04 -0400
Message-Id: <11761304552199-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.3.268.g3dda
In-Reply-To: <11761304521844-git-send-email-jsipek@cs.sunysb.edu>
References: <11761304521844-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The new remount code now has the "incgen" functionality.

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/branchman.c  |   21 ---------------------
 fs/unionfs/commonfops.c |    6 ++----
 2 files changed, 2 insertions(+), 25 deletions(-)

diff --git a/fs/unionfs/branchman.c b/fs/unionfs/branchman.c
index 83d443a..6912be9 100644
--- a/fs/unionfs/branchman.c
+++ b/fs/unionfs/branchman.c
@@ -18,27 +18,6 @@
 
 #include "union.h"
 
-/* increase the superblock generation count; effectively invalidating every
- * upper inode, dentry and file object */
-int unionfs_ioctl_incgen(struct file *file, unsigned int cmd, unsigned long arg)
-{
-	struct super_block *sb;
-	int gen;
-
-	sb = file->f_dentry->d_sb;
-
-	unionfs_write_lock(sb);
-
-	gen = atomic_inc_return(&UNIONFS_SB(sb)->generation);
-
-	atomic_set(&UNIONFS_D(sb->s_root)->generation, gen);
-	atomic_set(&UNIONFS_I(sb->s_root->d_inode)->generation, gen);
-
-	unionfs_write_unlock(sb);
-
-	return gen;
-}
-
 /* return to userspace the branch indices containing the file in question
  *
  * We use fd_set and therefore we are limited to the number of the branches
diff --git a/fs/unionfs/commonfops.c b/fs/unionfs/commonfops.c
index 6606cba..8453f2d 100644
--- a/fs/unionfs/commonfops.c
+++ b/fs/unionfs/commonfops.c
@@ -623,10 +623,8 @@ long unionfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	switch (cmd) {
 	case UNIONFS_IOCTL_INCGEN:
 		/* Increment the superblock generation count */
-		err = -EACCES;
-		if (!capable(CAP_SYS_ADMIN))
-			goto out;
-		err = unionfs_ioctl_incgen(file, cmd, arg);
+		printk("unionfs: incgen ioctl deprecated; use \"-o remount,incgen\"\n");
+		err = -ENOSYS;
 		break;
 
 	case UNIONFS_IOCTL_QUERYFILE:
-- 
1.5.0.3.268.g3dda

