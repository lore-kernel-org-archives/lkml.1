Return-Path: <linux-kernel-owner+w=401wt.eu-S1758170AbYAJCUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170AbYAJCUW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 21:20:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754714AbYAJCUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 21:20:07 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:37648 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131AbYAJCUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 21:20:05 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>, Joe Perches <joe@perches.com>
Subject: [PATCH 1/4] Unionfs: merged several printk KERN_CONT together into one pr_debug
Date: Wed,  9 Jan 2008 21:16:29 -0500
Message-Id: <11999313932160-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <1199931392670-git-send-email-ezk@cs.sunysb.edu>
References: <1199931392670-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Joe Perches <joe@perches.com>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/debug.c |   51 +++++++++++++++++++++++++--------------------------
 1 files changed, 25 insertions(+), 26 deletions(-)

diff --git a/fs/unionfs/debug.c b/fs/unionfs/debug.c
index 5f1d887..d154c32 100644
--- a/fs/unionfs/debug.c
+++ b/fs/unionfs/debug.c
@@ -472,16 +472,16 @@ void __show_inode_times(const struct inode *inode,
 		lower_inode = unionfs_lower_inode_idx(inode, bindex);
 		if (unlikely(!lower_inode))
 			continue;
-		pr_debug("IT(%lu:%d): ", inode->i_ino, bindex);
-		printk(KERN_CONT "%s:%s:%d ", file, fxn, line);
-		printk(KERN_CONT "um=%lu/%lu lm=%lu/%lu ",
-		       inode->i_mtime.tv_sec, inode->i_mtime.tv_nsec,
-		       lower_inode->i_mtime.tv_sec,
-		       lower_inode->i_mtime.tv_nsec);
-		printk(KERN_CONT "uc=%lu/%lu lc=%lu/%lu\n",
-		       inode->i_ctime.tv_sec, inode->i_ctime.tv_nsec,
-		       lower_inode->i_ctime.tv_sec,
-		       lower_inode->i_ctime.tv_nsec);
+		pr_debug("IT(%lu:%d): %s:%s:%d "
+			 "um=%lu/%lu lm=%lu/%lu uc=%lu/%lu lc=%lu/%lu\n",
+			 inode->i_ino, bindex,
+			 file, fxn, line,
+			 inode->i_mtime.tv_sec, inode->i_mtime.tv_nsec,
+			 lower_inode->i_mtime.tv_sec,
+			 lower_inode->i_mtime.tv_nsec,
+			 inode->i_ctime.tv_sec, inode->i_ctime.tv_nsec,
+			 lower_inode->i_ctime.tv_sec,
+			 lower_inode->i_ctime.tv_nsec);
 	}
 }
 
@@ -496,17 +496,16 @@ void __show_dinode_times(const struct dentry *dentry,
 		lower_inode = unionfs_lower_inode_idx(inode, bindex);
 		if (!lower_inode)
 			continue;
-		pr_debug("DT(%s:%lu:%d): ", dentry->d_name.name, inode->i_ino,
-			 bindex);
-		printk(KERN_CONT "%s:%s:%d ", file, fxn, line);
-		printk(KERN_CONT "um=%lu/%lu lm=%lu/%lu ",
-		       inode->i_mtime.tv_sec, inode->i_mtime.tv_nsec,
-		       lower_inode->i_mtime.tv_sec,
-		       lower_inode->i_mtime.tv_nsec);
-		printk(KERN_CONT "uc=%lu/%lu lc=%lu/%lu\n",
-		       inode->i_ctime.tv_sec, inode->i_ctime.tv_nsec,
-		       lower_inode->i_ctime.tv_sec,
-		       lower_inode->i_ctime.tv_nsec);
+		pr_debug("DT(%s:%lu:%d): %s:%s:%d "
+			 "um=%lu/%lu lm=%lu/%lu uc=%lu/%lu lc=%lu/%lu\n",
+			 dentry->d_name.name, inode->i_ino, bindex,
+			 file, fxn, line,
+			 inode->i_mtime.tv_sec, inode->i_mtime.tv_nsec,
+			 lower_inode->i_mtime.tv_sec,
+			 lower_inode->i_mtime.tv_nsec,
+			 inode->i_ctime.tv_sec, inode->i_ctime.tv_nsec,
+			 lower_inode->i_ctime.tv_sec,
+			 lower_inode->i_ctime.tv_nsec);
 	}
 }
 
@@ -525,10 +524,10 @@ void __show_inode_counts(const struct inode *inode,
 		lower_inode = unionfs_lower_inode_idx(inode, bindex);
 		if (unlikely(!lower_inode))
 			continue;
-		printk(KERN_CONT "SIC(%lu:%d:%d): ", inode->i_ino, bindex,
-		       atomic_read(&(inode)->i_count));
-		printk(KERN_CONT "lc=%d ",
-		       atomic_read(&(lower_inode)->i_count));
-		printk(KERN_CONT "%s:%s:%d\n", file, fxn, line);
+		pr_debug("SIC(%lu:%d:%d): lc=%d %s:%s:%d\n",
+			 inode->i_ino, bindex,
+			 atomic_read(&(inode)->i_count),
+			 atomic_read(&(lower_inode)->i_count),
+			 file, fxn, line);
 	}
 }
-- 
1.5.2.2

