Return-Path: <linux-kernel-owner+w=401wt.eu-S1757447AbYBQIRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447AbYBQIRs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 03:17:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756497AbYBQIRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 03:17:35 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:33949 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754219AbYBQIRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 03:17:04 -0500
Date: Sun, 17 Feb 2008 10:16:37 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Nick Piggin <npiggin@suse.de>, viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [2.6 patch] remove generic_commit_write()
Message-ID: <20080217081637.GB3848@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the obsolete and no longer used generic_commit_write().

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 fs/buffer.c                 |   18 ------------------
 include/linux/buffer_head.h |    1 -
 2 files changed, 19 deletions(-)

ef68a189129f02603fb49b09d331d1ea2fcd25da diff --git a/fs/buffer.c b/fs/buffer.c
index 9f55970..4f89fd9 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2311,23 +2311,6 @@ int block_commit_write(struct page *page, unsigned from, unsigned to)
 	return 0;
 }
 
-int generic_commit_write(struct file *file, struct page *page,
-		unsigned from, unsigned to)
-{
-	struct inode *inode = page->mapping->host;
-	loff_t pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
-	__block_commit_write(inode,page,from,to);
-	/*
-	 * No need to use i_size_read() here, the i_size
-	 * cannot change under us because we hold i_mutex.
-	 */
-	if (pos > inode->i_size) {
-		i_size_write(inode, pos);
-		mark_inode_dirty(inode);
-	}
-	return 0;
-}
-
 /*
  * block_page_mkwrite() is not allowed to change the file size as it gets
  * called from a page fault handler when a page is first dirtied. Hence we must
@@ -3300,7 +3283,6 @@ EXPORT_SYMBOL(end_buffer_write_sync);
 EXPORT_SYMBOL(file_fsync);
 EXPORT_SYMBOL(fsync_bdev);
 EXPORT_SYMBOL(generic_block_bmap);
-EXPORT_SYMBOL(generic_commit_write);
 EXPORT_SYMBOL(generic_cont_expand_simple);
 EXPORT_SYMBOL(init_buffer);
 EXPORT_SYMBOL(invalidate_bdev);
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 932eb02..82aa36c 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -225,7 +225,6 @@ int block_page_mkwrite(struct vm_area_struct *vma, struct page *page,
 				get_block_t get_block);
 void block_sync_page(struct page *);
 sector_t generic_block_bmap(struct address_space *, sector_t, get_block_t *);
-int generic_commit_write(struct file *, struct page *, unsigned, unsigned);
 int block_truncate_page(struct address_space *, loff_t, get_block_t *);
 int file_fsync(struct file *, struct dentry *, int);
 int nobh_write_begin(struct file *, struct address_space *,

