Return-Path: <linux-kernel-owner+w=401wt.eu-S1754707AbYLIWHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbYLIWHG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 17:07:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754268AbYLIWGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 17:06:51 -0500
Received: from mail-ew0-f31.google.com ([209.85.219.31]:46448 "EHLO
	mail-ew0-f31.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755280AbYLIWGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 17:06:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=hE1QyTOFMABY3qpZMKwvEumicdri0bA7lsm2UcFhAtK3Q3Q2Zj6uqHnte264DU+ESJ
         3u4JaH1vb7m2LTwanqpJ/Tqq4XxOOWzORO//RT/U7LC0+ufezJxEWpnboBZ9s6ezFAw1
         RVGqhxfwkxsPAyr0JDMZx/BUBc2K/wKFqHwVc=
Message-ID: <493EEBF6.1040103@gmail.com>
Date: Tue, 09 Dec 2008 23:06:46 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 25/31] fs: Make static
References: <493EA286.7080500@gmail.com>
In-Reply-To: <493EA286.7080500@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse asked whether these could be static.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 fs/bio-integrity.c    |    7 ++++---
 fs/ext4/extents.c     |    5 +++--
 fs/ext4/mballoc.c     |    2 +-
 fs/jbd2/transaction.c |    2 +-
 fs/reiserfs/journal.c |    2 +-
 fs/select.c           |    7 ++++---
 6 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index 19caf7c..80a7b33 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -226,7 +226,8 @@ unsigned int bio_integrity_tag_size(struct bio *bio)
 }
 EXPORT_SYMBOL(bio_integrity_tag_size);
 
-int bio_integrity_tag(struct bio *bio, void *tag_buf, unsigned int len, int set)
+static int bio_integrity_tag(struct bio *bio, void *tag_buf, unsigned int len,
+		int set)
 {
 	struct bio_integrity_payload *bip = bio->bi_integrity;
 	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
@@ -536,7 +537,7 @@ EXPORT_SYMBOL(bio_integrity_endio);
  * @bip:	Integrity vector to advance
  * @skip:	Number of bytes to advance it
  */
-void bio_integrity_mark_head(struct bio_integrity_payload *bip,
+static void bio_integrity_mark_head(struct bio_integrity_payload *bip,
 			     unsigned int skip)
 {
 	struct bio_vec *iv;
@@ -562,7 +563,7 @@ void bio_integrity_mark_head(struct bio_integrity_payload *bip,
  * @bip:	Integrity vector to truncate
  * @len:	New length of integrity vector
  */
-void bio_integrity_mark_tail(struct bio_integrity_payload *bip,
+static void bio_integrity_mark_tail(struct bio_integrity_payload *bip,
 			     unsigned int len)
 {
 	struct bio_vec *iv;
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ea2ce3c..2387b85 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3083,7 +3083,7 @@ retry:
 /*
  * Callback function called for each extent to gather FIEMAP information.
  */
-int ext4_ext_fiemap_cb(struct inode *inode, struct ext4_ext_path *path,
+static int ext4_ext_fiemap_cb(struct inode *inode, struct ext4_ext_path *path,
 		       struct ext4_ext_cache *newex, struct ext4_extent *ex,
 		       void *data)
 {
@@ -3152,7 +3152,8 @@ int ext4_ext_fiemap_cb(struct inode *inode, struct ext4_ext_path *path,
 /* fiemap flags we can handle specified here */
 #define EXT4_FIEMAP_FLAGS	(FIEMAP_FLAG_SYNC|FIEMAP_FLAG_XATTR)
 
-int ext4_xattr_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo)
+static int ext4_xattr_fiemap(struct inode *inode,
+		struct fiemap_extent_info *fieinfo)
 {
 	__u64 physical = 0;
 	__u64 length;
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 444ad99..c85c20e 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2242,7 +2242,7 @@ ext4_mb_store_history(struct ext4_allocation_context *ac)
 
 
 /* Create and initialize ext4_group_info data for the given group. */
-int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
+static int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
 			  struct ext4_group_desc *desc)
 {
 	int i, len;
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 39b7805..c376d3a 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1372,7 +1372,7 @@ __blist_del_buffer(struct journal_head **list, struct journal_head *jh)
  *
  * Called under j_list_lock.  The journal may not be locked.
  */
-void __jbd2_journal_temp_unlink_buffer(struct journal_head *jh)
+static void __jbd2_journal_temp_unlink_buffer(struct journal_head *jh)
 {
 	struct journal_head **list = NULL;
 	transaction_t *transaction;
diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index 9643c3b..476fc6e 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -1872,7 +1872,7 @@ static int flush_used_journal_lists(struct super_block *s,
 ** removes any nodes in table with name block and dev as bh.
 ** only touchs the hnext and hprev pointers.
 */
-void remove_journal_hash(struct super_block *sb,
+static void remove_journal_hash(struct super_block *sb,
 			 struct reiserfs_journal_cnode **table,
 			 struct reiserfs_journal_list *jl,
 			 unsigned long block, int remove_freed)
diff --git a/fs/select.c b/fs/select.c
index 87df51e..c24614e 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -532,9 +532,10 @@ asmlinkage long sys_select(int n, fd_set __user *inp, fd_set __user *outp,
 }
 
 #ifdef HAVE_SET_RESTORE_SIGMASK
-asmlinkage long sys_pselect7(int n, fd_set __user *inp, fd_set __user *outp,
-		fd_set __user *exp, struct timespec __user *tsp,
-		const sigset_t __user *sigmask, size_t sigsetsize)
+static asmlinkage long sys_pselect7(int n, fd_set __user *inp,
+		fd_set __user *outp, fd_set __user *exp,
+		struct timespec __user *tsp, const sigset_t __user *sigmask,
+		size_t sigsetsize)
 {
 	sigset_t ksigmask, sigsaved;
 	struct timespec ts, end_time, *to = NULL;

