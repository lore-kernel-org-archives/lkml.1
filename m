Return-Path: <linux-kernel-owner+w=401wt.eu-S1753872AbXJAFwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbXJAFwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 01:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751914AbXJAFvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 01:51:21 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40706 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbXJAFvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 01:51:19 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 04/19] Unionfs: use consistent printk prefixes
Date: Mon,  1 Oct 2007 01:50:41 -0400
Message-Id: <11912178582875-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <1191217856647-git-send-email-ezk@cs.sunysb.edu>
References: <1191217856647-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/inode.c |    4 ++--
 fs/unionfs/union.h |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index 021e206..ba85a67 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -90,7 +90,7 @@ static int unionfs_create(struct inode *parent, struct dentry *dentry,
 			unlock_dir(lower_dir_dentry);
 
 			if (err) {
-				printk("unionfs_create: could not unlink "
+				printk("unionfs: create: could not unlink "
 				       "whiteout, err = %d\n", err);
 				goto out;
 			}
@@ -1088,7 +1088,7 @@ static int unionfs_setattr(struct dentry *dentry, struct iattr *ia)
 		if (ia->ia_size != i_size_read(inode)) {
 			err = vmtruncate(inode, ia->ia_size);
 			if (err)
-				printk("unionfs_setattr: vmtruncate failed\n");
+				printk("unionfs: setattr: vmtruncate failed\n");
 		}
 	}
 
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index 7ce4771..91f7f1e 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -474,7 +474,7 @@ static inline struct vfsmount *unionfs_mntget(struct dentry *dentry,
 	mnt = mntget(unionfs_lower_mnt_idx(dentry, bindex));
 #ifdef CONFIG_UNION_FS_DEBUG
 	if (!mnt)
-		printk(KERN_DEBUG "unionfs_mntget: mnt=%p bindex=%d\n",
+		printk(KERN_DEBUG "unionfs: mntget: mnt=%p bindex=%d\n",
 		       mnt, bindex);
 #endif /* CONFIG_UNION_FS_DEBUG */
 
@@ -500,7 +500,7 @@ static inline void unionfs_mntput(struct dentry *dentry, int bindex)
 	 */
 	if (!mnt && !(bindex > dbstart(dentry) && bindex < dbend(dentry)))
 		printk(KERN_WARNING
-		       "unionfs_mntput: mnt=%p bindex=%d\n",
+		       "unionfs: mntput: mnt=%p bindex=%d\n",
 		       mnt, bindex);
 #endif /* CONFIG_UNION_FS_DEBUG */
 	mntput(mnt);
-- 
1.5.2.2

