Return-Path: <linux-kernel-owner+w=401wt.eu-S1755353AbZLDWTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbZLDWTO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 17:19:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbZLDWTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 17:19:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41575 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918AbZLDWTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 17:19:11 -0500
Message-ID: <4B198B4C.3030201@gmail.com>
Date: Fri, 04 Dec 2009 23:21:00 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: chris.mason@oracle.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 09/31] Constify struct extent_io_ops for 2.6.32 v1
References: <4B198670.2000406@gmail.com>
In-Reply-To: <4B198670.2000406@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>

Constify struct extent_io_ops.

Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 fs/btrfs/disk-io.c   |    4 ++--
 fs/btrfs/extent_io.h |   30 +++++++++++++++---------------
 fs/btrfs/inode.c     |    4 ++--
 3 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 02b6afb..6c78215 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -39,7 +39,7 @@
 #include "tree-log.h"
 #include "free-space-cache.h"
 
-static struct extent_io_ops btree_extent_io_ops;
+static const struct extent_io_ops btree_extent_io_ops;
 static void end_workqueue_fn(struct btrfs_work *work);
 static void free_fs_root(struct btrfs_root *root);
 
@@ -2585,7 +2585,7 @@ out:
 	return 0;
 }
 
-static struct extent_io_ops btree_extent_io_ops = {
+static const struct extent_io_ops btree_extent_io_ops = {
 	.write_cache_pages_lock_hook = btree_lock_page_hook,
 	.readpage_end_io_hook = btree_readpage_end_io_hook,
 	.submit_bio_hook = btree_submit_bio_hook,
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 36de250..7ec75c7 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -49,36 +49,36 @@ typedef	int (extent_submit_bio_hook_t)(struct inode *inode, int rw,
 				       struct bio *bio, int mirror_num,
 				       unsigned long bio_flags);
 struct extent_io_ops {
-	int (*fill_delalloc)(struct inode *inode, struct page *locked_page,
+	int (* const fill_delalloc)(struct inode *inode, struct page *locked_page,
 			     u64 start, u64 end, int *page_started,
 			     unsigned long *nr_written);
-	int (*writepage_start_hook)(struct page *page, u64 start, u64 end);
-	int (*writepage_io_hook)(struct page *page, u64 start, u64 end);
+	int (* const writepage_start_hook)(struct page *page, u64 start, u64 end);
+	int (* const writepage_io_hook)(struct page *page, u64 start, u64 end);
 	extent_submit_bio_hook_t *submit_bio_hook;
-	int (*merge_bio_hook)(struct page *page, unsigned long offset,
+	int (* const merge_bio_hook)(struct page *page, unsigned long offset,
 			      size_t size, struct bio *bio,
 			      unsigned long bio_flags);
-	int (*readpage_io_hook)(struct page *page, u64 start, u64 end);
-	int (*readpage_io_failed_hook)(struct bio *bio, struct page *page,
+	int (* const readpage_io_hook)(struct page *page, u64 start, u64 end);
+	int (* const readpage_io_failed_hook)(struct bio *bio, struct page *page,
 				       u64 start, u64 end,
 				       struct extent_state *state);
-	int (*writepage_io_failed_hook)(struct bio *bio, struct page *page,
+	int (* const writepage_io_failed_hook)(struct bio *bio, struct page *page,
 					u64 start, u64 end,
 				       struct extent_state *state);
-	int (*readpage_end_io_hook)(struct page *page, u64 start, u64 end,
+	int (* const readpage_end_io_hook)(struct page *page, u64 start, u64 end,
 				    struct extent_state *state);
-	int (*writepage_end_io_hook)(struct page *page, u64 start, u64 end,
+	int (* const writepage_end_io_hook)(struct page *page, u64 start, u64 end,
 				      struct extent_state *state, int uptodate);
-	int (*set_bit_hook)(struct inode *inode, u64 start, u64 end,
+	int (* const set_bit_hook)(struct inode *inode, u64 start, u64 end,
 			    unsigned long old, unsigned long bits);
-	int (*clear_bit_hook)(struct inode *inode, struct extent_state *state,
+	int (* const clear_bit_hook)(struct inode *inode, struct extent_state *state,
 			      unsigned long bits);
-	int (*merge_extent_hook)(struct inode *inode,
+	int (* const merge_extent_hook)(struct inode *inode,
 				 struct extent_state *new,
 				 struct extent_state *other);
-	int (*split_extent_hook)(struct inode *inode,
+	int (* const split_extent_hook)(struct inode *inode,
 				 struct extent_state *orig, u64 split);
-	int (*write_cache_pages_lock_hook)(struct page *page);
+	int (* const write_cache_pages_lock_hook)(struct page *page);
 };
 
 struct extent_io_tree {
@@ -88,7 +88,7 @@ struct extent_io_tree {
 	u64 dirty_bytes;
 	spinlock_t lock;
 	spinlock_t buffer_lock;
-	struct extent_io_ops *ops;
+	const struct extent_io_ops *ops;
 };
 
 struct extent_state {
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b3ad168..3453cba 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -63,7 +63,7 @@ static const struct inode_operations btrfs_file_inode_operations;
 static const struct address_space_operations btrfs_aops;
 static const struct address_space_operations btrfs_symlink_aops;
 static const struct file_operations btrfs_dir_file_operations;
-static struct extent_io_ops btrfs_extent_io_ops;
+static const struct extent_io_ops btrfs_extent_io_ops;
 
 static struct kmem_cache *btrfs_inode_cachep;
 struct kmem_cache *btrfs_trans_handle_cachep;
@@ -5854,7 +5854,7 @@ static const struct file_operations btrfs_dir_file_operations = {
 	.fsync		= btrfs_sync_file,
 };
 
-static struct extent_io_ops btrfs_extent_io_ops = {
+static const struct extent_io_ops btrfs_extent_io_ops = {
 	.fill_delalloc = run_delalloc_range,
 	.submit_bio_hook = btrfs_submit_bio_hook,
 	.merge_bio_hook = btrfs_merge_bio_hook,

