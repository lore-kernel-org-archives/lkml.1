Return-Path: <linux-kernel-owner+w=401wt.eu-S1759850AbYCDCEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759850AbYCDCEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 21:04:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755139AbYCDCBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 21:01:20 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:10589 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522AbYCDCBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 21:01:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=PqDvhTTbzptWzwkPVAllLIENV5qoiNn35kynoWgYkYpa9OiFQaIrRYD9vfjXf7KHU9tS5vzVrUjoBXCMx09aqJGPMMmixGT8kOw4fLYew6IFstkp3Zq4BhC2QgTZKCIo3Hx+OTOM4/QSQrKR0/sJy+99xLhoUQh+ocomNOLe6hE=
Subject: [PATCH 09/13] ufs: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <de3bbd22cbe7683747f9244f3dd3e433bee28842.1204595498.git.harvey.harrison@gmail.com>
References: <de3bbd22cbe7683747f9244f3dd3e433bee28842.1204595498.git.harvey.harrison@gmail.com>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 18:01:05 -0800
Message-Id: <1204596065.22933.61.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/ufs/balloc.c |    4 ++--
 fs/ufs/dir.c    |   14 +++++++-------
 fs/ufs/inode.c  |    2 +-
 fs/ufs/ufs.h    |    2 +-
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/ufs/balloc.c b/fs/ufs/balloc.c
index 1fca381..0dff403 100644
--- a/fs/ufs/balloc.c
+++ b/fs/ufs/balloc.c
@@ -277,7 +277,7 @@ static void ufs_change_blocknr(struct inode *inode, sector_t beg,
 			if (!page)/* it was truncated */
 				continue;
 			if (IS_ERR(page)) {/* or EIO */
-				ufs_error(inode->i_sb, __FUNCTION__,
+				ufs_error(inode->i_sb, __func__,
 					  "read of page %llu failed\n",
 					  (unsigned long long)index);
 				continue;
@@ -308,7 +308,7 @@ static void ufs_change_blocknr(struct inode *inode, sector_t beg,
 				ll_rw_block(READ, 1, &bh);
 				wait_on_buffer(bh);
 				if (!buffer_uptodate(bh)) {
-					ufs_error(inode->i_sb, __FUNCTION__,
+					ufs_error(inode->i_sb, __func__,
 						  "read of block failed\n");
 					break;
 				}
diff --git a/fs/ufs/dir.c b/fs/ufs/dir.c
index ef563fc..df0bef1 100644
--- a/fs/ufs/dir.c
+++ b/fs/ufs/dir.c
@@ -179,7 +179,7 @@ bad_entry:
 	goto fail;
 Eend:
 	p = (struct ufs_dir_entry *)(kaddr + offs);
-	ufs_error(sb, __FUNCTION__,
+	ufs_error(sb, __func__,
 		   "entry in directory #%lu spans the page boundary"
 		   "offset=%lu",
 		   dir->i_ino, (page->index<<PAGE_CACHE_SHIFT)+offs);
@@ -284,7 +284,7 @@ struct ufs_dir_entry *ufs_find_entry(struct inode *dir, struct dentry *dentry,
 			kaddr += ufs_last_byte(dir, n) - reclen;
 			while ((char *) de <= kaddr) {
 				if (de->d_reclen == 0) {
-					ufs_error(dir->i_sb, __FUNCTION__,
+					ufs_error(dir->i_sb, __func__,
 						  "zero-length directory entry");
 					ufs_put_page(page);
 					goto out;
@@ -356,7 +356,7 @@ int ufs_add_link(struct dentry *dentry, struct inode *inode)
 				goto got_it;
 			}
 			if (de->d_reclen == 0) {
-				ufs_error(dir->i_sb, __FUNCTION__,
+				ufs_error(dir->i_sb, __func__,
 					  "zero-length directory entry");
 				err = -EIO;
 				goto out_unlock;
@@ -456,7 +456,7 @@ ufs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 		struct page *page = ufs_get_page(inode, n);
 
 		if (IS_ERR(page)) {
-			ufs_error(sb, __FUNCTION__,
+			ufs_error(sb, __func__,
 				  "bad page in #%lu",
 				  inode->i_ino);
 			filp->f_pos += PAGE_CACHE_SIZE - offset;
@@ -475,7 +475,7 @@ ufs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 		limit = kaddr + ufs_last_byte(inode, n) - UFS_DIR_REC_LEN(1);
 		for ( ;(char*)de <= limit; de = ufs_next_entry(sb, de)) {
 			if (de->d_reclen == 0) {
-				ufs_error(sb, __FUNCTION__,
+				ufs_error(sb, __func__,
 					"zero-length directory entry");
 				ufs_put_page(page);
 				return -EIO;
@@ -536,7 +536,7 @@ int ufs_delete_entry(struct inode *inode, struct ufs_dir_entry *dir,
 
 	while ((char*)de < (char*)dir) {
 		if (de->d_reclen == 0) {
-			ufs_error(inode->i_sb, __FUNCTION__,
+			ufs_error(inode->i_sb, __func__,
 				  "zero-length directory entry");
 			err = -EIO;
 			goto out;
@@ -633,7 +633,7 @@ int ufs_empty_dir(struct inode * inode)
 
 		while ((char *)de <= kaddr) {
 			if (de->d_reclen == 0) {
-				ufs_error(inode->i_sb, __FUNCTION__,
+				ufs_error(inode->i_sb, __func__,
 					"zero-length directory entry: "
 					"kaddr=%p, de=%p\n", kaddr, de);
 				goto not_empty;
diff --git a/fs/ufs/inode.c b/fs/ufs/inode.c
index 5446b88..39f8778 100644
--- a/fs/ufs/inode.c
+++ b/fs/ufs/inode.c
@@ -929,7 +929,7 @@ void ufs_delete_inode (struct inode * inode)
 	old_i_size = inode->i_size;
 	inode->i_size = 0;
 	if (inode->i_blocks && ufs_truncate(inode, old_i_size))
-		ufs_warning(inode->i_sb, __FUNCTION__, "ufs_truncate failed\n");
+		ufs_warning(inode->i_sb, __func__, "ufs_truncate failed\n");
 	ufs_free_inode (inode);
 	unlock_kernel();
 	return;
diff --git a/fs/ufs/ufs.h b/fs/ufs/ufs.h
index fcb9231..244a1aa 100644
--- a/fs/ufs/ufs.h
+++ b/fs/ufs/ufs.h
@@ -66,7 +66,7 @@ struct ufs_inode_info {
 #ifdef CONFIG_UFS_DEBUG
 #	define UFSD(f, a...)	{					\
 		printk ("UFSD (%s, %d): %s:",				\
-			__FILE__, __LINE__, __FUNCTION__);		\
+			__FILE__, __LINE__, __func__);		\
 		printk (f, ## a);					\
 	}
 #else
-- 
1.5.4.3.500.g83a2c


