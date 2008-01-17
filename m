Return-Path: <linux-kernel-owner+w=401wt.eu-S1756621AbYAQMou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621AbYAQMou (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 07:44:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbYAQMoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 07:44:14 -0500
Received: from bde.crans.org ([138.231.137.76]:58729 "EHLO bde.crans.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702AbYAQMoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 07:44:10 -0500
From: Mathieu Segaud <mathieu.segaud@regala.cx>
To: reiserfs-devel@vger.kernel.org
Cc: reiserfs-devel@namesys.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Mathieu Segaud <mathieu.segaud@regala.cx>
Subject: [PATCH] reiserfs: coding style fixes
Date: Thu, 17 Jan 2008 13:44:08 +0100
Message-Id: <1200573848-1382-2-git-send-email-mathieu.segaud@regala.cx>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1200573848-1382-1-git-send-email-mathieu.segaud@regala.cx>
References: <1200573848-1382-1-git-send-email-mathieu.segaud@regala.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mathieu Segaud <mathieu.segaud@regala.cx>
---
 fs/reiserfs/ioctl.c |   22 ++++++++++++----------
 1 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/reiserfs/ioctl.c b/fs/reiserfs/ioctl.c
index 691008d..1468be5 100644
--- a/fs/reiserfs/ioctl.c
+++ b/fs/reiserfs/ioctl.c
@@ -17,7 +17,8 @@ static int reiserfs_unpack(struct inode *inode, struct file *filp);
 ** reiserfs_ioctl - handler for ioctl for inode
 ** supported commands:
 **  1) REISERFS_IOC_UNPACK - try to unpack tail from direct item into indirect
-**                           and prevent packing file (argument arg has to be non-zero)
+**                           and prevent packing file (argument arg has to be
+**			     non-zero)
 **  2) REISERFS_IOC_[GS]ETFLAGS, REISERFS_IOC_[GS]ETVERSION
 **  3) That's all for a while ...
 */
@@ -47,7 +48,7 @@ long reiserfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		}
 
 		flags = REISERFS_I(inode)->i_attrs;
-		i_attrs_to_sd_attrs(inode, (__u16 *) & flags);
+		i_attrs_to_sd_attrs(inode, (__u16 *) &flags);
 		retval = put_user(flags, (int __user *)arg);
 		goto out;
 	case REISERFS_IOC_SETFLAGS:{
@@ -71,7 +72,10 @@ long reiserfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 				goto out;
 			}
 
-			/* Is it quota file? Do not allow user to mess with it. */
+			/*
+			 * Is it quota file?
+			 * Do not allow user to mess with it.
+			 */
 			if (IS_NOQUOTA(inode)) {
 				retval = -EPERM;
 				goto out;
@@ -182,9 +186,8 @@ static int reiserfs_unpack(struct inode *inode, struct file *filp)
 		return 0;
 	}
 	/* ioctl already done */
-	if (REISERFS_I(inode)->i_flags & i_nopack_mask) {
+	if (REISERFS_I(inode)->i_flags & i_nopack_mask)
 		return 0;
-	}
 
 	/* we need to make sure nobody is changing the file size beneath
 	 ** us
@@ -200,16 +203,15 @@ static int reiserfs_unpack(struct inode *inode, struct file *filp)
 	}
 
 	/* we unpack by finding the page with the tail, and calling
-	 ** reiserfs_prepare_write on that page.  This will force a 
+	 ** reiserfs_prepare_write on that page.  This will force a
 	 ** reiserfs_get_block to unpack the tail for us.
 	 */
 	index = inode->i_size >> PAGE_CACHE_SHIFT;
 	mapping = inode->i_mapping;
 	page = grab_cache_page(mapping, index);
 	retval = -ENOMEM;
-	if (!page) {
+	if (!page)
 		goto out;
-	}
 	retval = reiserfs_prepare_write(NULL, page, write_from, write_from);
 	if (retval)
 		goto out_unlock;
@@ -219,11 +221,11 @@ static int reiserfs_unpack(struct inode *inode, struct file *filp)
 	retval = reiserfs_commit_write(NULL, page, write_from, write_from);
 	REISERFS_I(inode)->i_flags |= i_nopack_mask;
 
-      out_unlock:
+out_unlock:
 	unlock_page(page);
 	page_cache_release(page);
 
-      out:
+out:
 	mutex_unlock(&inode->i_mutex);
 	reiserfs_write_unlock(inode->i_sb);
 	return retval;
-- 
1.5.3.8

