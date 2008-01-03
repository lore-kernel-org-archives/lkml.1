Return-Path: <linux-kernel-owner+w=401wt.eu-S1760167AbYACF6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760167AbYACF6Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 00:58:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754694AbYACF6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 00:58:06 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:50692 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357AbYACF6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 00:58:04 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 1/3] Unionfs: use printk KERN_CONT for debugging messages
Date: Thu,  3 Jan 2008 00:57:38 -0500
Message-Id: <1199339862303-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11993398601-git-send-email-ezk@cs.sunysb.edu>
References: <11993398601-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/debug.c |   50 ++++++++++++++++++++++++++------------------------
 1 files changed, 26 insertions(+), 24 deletions(-)

diff --git a/fs/unionfs/debug.c b/fs/unionfs/debug.c
index c2b8b58..5f1d887 100644
--- a/fs/unionfs/debug.c
+++ b/fs/unionfs/debug.c
@@ -456,9 +456,10 @@ void __show_branch_counts(const struct super_block *sb,
 			mnt = UNIONFS_D(sb->s_root)->lower_paths[i].mnt;
 		else
 			mnt = NULL;
-		pr_debug("%d:", (mnt ? atomic_read(&mnt->mnt_count) : -99));
+		printk(KERN_CONT "%d:",
+		       (mnt ? atomic_read(&mnt->mnt_count) : -99));
 	}
-	pr_debug("%s:%s:%d\n", file, fxn, line);
+	printk(KERN_CONT "%s:%s:%d\n", file, fxn, line);
 }
 
 void __show_inode_times(const struct inode *inode,
@@ -472,15 +473,15 @@ void __show_inode_times(const struct inode *inode,
 		if (unlikely(!lower_inode))
 			continue;
 		pr_debug("IT(%lu:%d): ", inode->i_ino, bindex);
-		pr_debug("%s:%s:%d ", file, fxn, line);
-		pr_debug("um=%lu/%lu lm=%lu/%lu ",
-			 inode->i_mtime.tv_sec, inode->i_mtime.tv_nsec,
-			 lower_inode->i_mtime.tv_sec,
-			 lower_inode->i_mtime.tv_nsec);
-		pr_debug("uc=%lu/%lu lc=%lu/%lu\n",
-			 inode->i_ctime.tv_sec, inode->i_ctime.tv_nsec,
-			 lower_inode->i_ctime.tv_sec,
-			 lower_inode->i_ctime.tv_nsec);
+		printk(KERN_CONT "%s:%s:%d ", file, fxn, line);
+		printk(KERN_CONT "um=%lu/%lu lm=%lu/%lu ",
+		       inode->i_mtime.tv_sec, inode->i_mtime.tv_nsec,
+		       lower_inode->i_mtime.tv_sec,
+		       lower_inode->i_mtime.tv_nsec);
+		printk(KERN_CONT "uc=%lu/%lu lc=%lu/%lu\n",
+		       inode->i_ctime.tv_sec, inode->i_ctime.tv_nsec,
+		       lower_inode->i_ctime.tv_sec,
+		       lower_inode->i_ctime.tv_nsec);
 	}
 }
 
@@ -497,15 +498,15 @@ void __show_dinode_times(const struct dentry *dentry,
 			continue;
 		pr_debug("DT(%s:%lu:%d): ", dentry->d_name.name, inode->i_ino,
 			 bindex);
-		pr_debug("%s:%s:%d ", file, fxn, line);
-		pr_debug("um=%lu/%lu lm=%lu/%lu ",
-			 inode->i_mtime.tv_sec, inode->i_mtime.tv_nsec,
-			 lower_inode->i_mtime.tv_sec,
-			 lower_inode->i_mtime.tv_nsec);
-		pr_debug("uc=%lu/%lu lc=%lu/%lu\n",
-			 inode->i_ctime.tv_sec, inode->i_ctime.tv_nsec,
-			 lower_inode->i_ctime.tv_sec,
-			 lower_inode->i_ctime.tv_nsec);
+		printk(KERN_CONT "%s:%s:%d ", file, fxn, line);
+		printk(KERN_CONT "um=%lu/%lu lm=%lu/%lu ",
+		       inode->i_mtime.tv_sec, inode->i_mtime.tv_nsec,
+		       lower_inode->i_mtime.tv_sec,
+		       lower_inode->i_mtime.tv_nsec);
+		printk(KERN_CONT "uc=%lu/%lu lc=%lu/%lu\n",
+		       inode->i_ctime.tv_sec, inode->i_ctime.tv_nsec,
+		       lower_inode->i_ctime.tv_sec,
+		       lower_inode->i_ctime.tv_nsec);
 	}
 }
 
@@ -524,9 +525,10 @@ void __show_inode_counts(const struct inode *inode,
 		lower_inode = unionfs_lower_inode_idx(inode, bindex);
 		if (unlikely(!lower_inode))
 			continue;
-		pr_debug("SIC(%lu:%d:%d): ", inode->i_ino, bindex,
-			 atomic_read(&(inode)->i_count));
-		pr_debug("lc=%d ", atomic_read(&(lower_inode)->i_count));
-		pr_debug("%s:%s:%d\n", file, fxn, line);
+		printk(KERN_CONT "SIC(%lu:%d:%d): ", inode->i_ino, bindex,
+		       atomic_read(&(inode)->i_count));
+		printk(KERN_CONT "lc=%d ",
+		       atomic_read(&(lower_inode)->i_count));
+		printk(KERN_CONT "%s:%s:%d\n", file, fxn, line);
 	}
 }
-- 
1.5.2.2

