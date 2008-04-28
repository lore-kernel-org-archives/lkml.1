Return-Path: <linux-kernel-owner+w=401wt.eu-S936096AbYD1Plt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936096AbYD1Plt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 11:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934818AbYD1PjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 11:39:21 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:49097 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964789AbYD1PjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 11:39:19 -0400
Date: Mon, 28 Apr 2008 18:38:45 +0300
From: Adrian Bunk <bunk@kernel.org>
To: reiserfs-devel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@mailshack.com>, jdike@addtoit.com,
       Ingo Molnar <mingo@elte.hu>
Subject: [2.6 patch] reiserfs: some functions mustn't be inline
Message-ID: <20080428153845.GG2813@cs181133002.pp.htv.fi>
References: <20080424215739.GA32378@elte.hu> <alpine.LFD.1.10.0804241510420.2779@woody.linux-foundation.org> <20080426151516.GA27894@elte.hu> <alpine.LFD.1.10.0804260955300.2813@woody.linux-foundation.org> <20080426172222.GD17345@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080426172222.GD17345@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following build errors with UML and gcc 4.3:

<--  snip  -->

...
  CC      fs/reiserfs/do_balan.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/reiserfs/do_balan.c: In function ‘balance_leaf’:
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/reiserfs/do_balan.c:34: sorry, unimplemented: inlining failed in call to ‘do_balance_mark_leaf_dirty’: function body not available
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/reiserfs/do_balan.c:1018: sorry, unimplemented: called from here
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/reiserfs/do_balan.c:34: sorry, unimplemented: inlining failed in call to ‘do_balance_mark_leaf_dirty’: function body not available
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/reiserfs/do_balan.c:1174: sorry, unimplemented: called from here
make[3]: *** [fs/reiserfs/do_balan.o] Error 1
...
  CC      fs/reiserfs/namei.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/reiserfs/namei.c: In function ‘search_by_entry_key’:
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/reiserfs/namei.c:66: sorry, unimplemented: inlining failed in call to ‘set_de_name_and_namelen’: function body not available
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/reiserfs/namei.c:162: sorry, unimplemented: called from here
make[3]: *** [fs/reiserfs/namei.o] Error 1
...
  CC      fs/reiserfs/inode.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/reiserfs/inode.c: In function ‘reiserfs_get_block’:
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/reiserfs/inode.c:108: sorry, unimplemented: inlining failed in call to ‘make_le_item_head’: function body not available
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/reiserfs/inode.c:776: sorry, unimplemented: called from here
make[3]: *** [fs/reiserfs/inode.o] Error 1
...
  CC      fs/reiserfs/stree.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/reiserfs/stree.c: In function ‘comp_keys’:
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/reiserfs/stree.c:86: sorry, unimplemented: inlining failed in call to ‘comp_short_keys’: function body not available
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/reiserfs/stree.c:111: sorry, unimplemented: called from here
make[3]: *** [fs/reiserfs/stree.o] Error 1
...
  CC      fs/reiserfs/stree.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/reiserfs/stree.c: In function ‘get_lkey’:
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/reiserfs/stree.c:61: sorry, unimplemented: inlining failed in call to ‘B_IS_IN_TREE’: function body not available
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/reiserfs/stree.c:265: sorry, unimplemented: called from here
make[3]: *** [fs/reiserfs/stree.o] Error 1
...
  CC      fs/reiserfs/stree.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/reiserfs/stree.c: In function ‘key_in_buffer’:
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/reiserfs/stree.c:294: sorry, unimplemented: inlining failed in call to ‘get_rkey’: function body not available
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/reiserfs/stree.c:356: sorry, unimplemented: called from here
make[3]: *** [fs/reiserfs/stree.o] Error 1
...
  CC      fs/reiserfs/stree.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/reiserfs/stree.c: In function ‘prepare_for_delete_or_cut’:
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/reiserfs/stree.c:74: sorry, unimplemented: inlining failed in call to ‘copy_item_head’: function body not available
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/reiserfs/stree.c:1041: sorry, unimplemented: called from here
make[3]: *** [fs/reiserfs/stree.o] Error 1
...
  CC      fs/reiserfs/stree.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/reiserfs/stree.c: In function ‘reiserfs_delete_solid_item’:
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/reiserfs/stree.c:153: sorry, unimplemented: inlining failed in call to ‘le_key2cpu_key’: function body not available
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/reiserfs/stree.c:1335: sorry, unimplemented: called from here
make[3]: *** [fs/reiserfs/stree.o] Error 1
...
  CC      fs/reiserfs/stree.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/reiserfs/stree.c: In function ‘decrement_counters_in_path’:
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/reiserfs/stree.c:362: sorry, unimplemented: inlining failed in call to ‘decrement_bcount’: function body not available
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/reiserfs/stree.c:387: sorry, unimplemented: called from here
make[3]: *** [fs/reiserfs/stree.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 fs/reiserfs/do_balan.c |    4 ++--
 fs/reiserfs/inode.c    |    8 ++++----
 fs/reiserfs/namei.c    |    2 +-
 fs/reiserfs/stree.c    |   17 ++++++++---------
 4 files changed, 15 insertions(+), 16 deletions(-)

da1507ac13cfd50db5dddc0186e0ff1f1ae26517 diff --git a/fs/reiserfs/do_balan.c b/fs/reiserfs/do_balan.c
index 7ee4208..42be2a6 100644
--- a/fs/reiserfs/do_balan.c
+++ b/fs/reiserfs/do_balan.c
@@ -29,8 +29,8 @@ struct tree_balance *cur_tb = NULL;	/* detects whether more than one
 					   is interrupting do_balance */
 #endif
 
-inline void do_balance_mark_leaf_dirty(struct tree_balance *tb,
-				       struct buffer_head *bh, int flag)
+void do_balance_mark_leaf_dirty(struct tree_balance *tb,
+				struct buffer_head *bh, int flag)
 {
 	journal_mark_dirty(tb->transaction_handle,
 			   tb->transaction_handle->t_super, bh);
diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index 5791793..3e06b99 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -101,10 +101,10 @@ void make_cpu_key(struct cpu_key *key, struct inode *inode, loff_t offset,
 //
 // when key is 0, do not set version and short key
 //
-inline void make_le_item_head(struct item_head *ih, const struct cpu_key *key,
-			      int version,
-			      loff_t offset, int type, int length,
-			      int entry_count /*or ih_free_space */ )
+void make_le_item_head(struct item_head *ih, const struct cpu_key *key,
+		       int version,
+		       loff_t offset, int type, int length,
+		       int entry_count /*or ih_free_space */ )
 {
 	if (key) {
 		ih->ih_key.k_dir_id = cpu_to_le32(key->on_disk_key.k_dir_id);
diff --git a/fs/reiserfs/namei.c b/fs/reiserfs/namei.c
index 8867533..f592296 100644
--- a/fs/reiserfs/namei.c
+++ b/fs/reiserfs/namei.c
@@ -62,7 +62,7 @@ static inline void set_de_item_location(struct reiserfs_dir_entry *de,
 }
 
 // de_bh, de_ih, de_deh (points to first element of array), de_item_num is set
-inline void set_de_name_and_namelen(struct reiserfs_dir_entry *de)
+void set_de_name_and_namelen(struct reiserfs_dir_entry *de)
 {
 	struct reiserfs_de_head *deh = de->de_deh + de->de_entry_num;
 
diff --git a/fs/reiserfs/stree.c b/fs/reiserfs/stree.c
index d2db241..9b84b4c 100644
--- a/fs/reiserfs/stree.c
+++ b/fs/reiserfs/stree.c
@@ -57,7 +57,7 @@
 #include <linux/quotaops.h>
 
 /* Does the buffer contain a disk block which is in the tree. */
-inline int B_IS_IN_TREE(const struct buffer_head *p_s_bh)
+int B_IS_IN_TREE(const struct buffer_head *p_s_bh)
 {
 
 	RFALSE(B_LEVEL(p_s_bh) > MAX_HEIGHT,
@@ -69,8 +69,7 @@ inline int B_IS_IN_TREE(const struct buffer_head *p_s_bh)
 //
 // to gets item head in le form
 //
-inline void copy_item_head(struct item_head *p_v_to,
-			   const struct item_head *p_v_from)
+void copy_item_head(struct item_head *p_v_to, const struct item_head *p_v_from)
 {
 	memcpy(p_v_to, p_v_from, IH_SIZE);
 }
@@ -81,8 +80,8 @@ inline void copy_item_head(struct item_head *p_v_to,
    Returns: -1 if key1 < key2 
    0 if key1 == key2
    1 if key1 > key2 */
-inline int comp_short_keys(const struct reiserfs_key *le_key,
-			   const struct cpu_key *cpu_key)
+int comp_short_keys(const struct reiserfs_key *le_key,
+		    const struct cpu_key *cpu_key)
 {
 	__u32 n;
 	n = le32_to_cpu(le_key->k_dir_id);
@@ -150,7 +149,7 @@ inline int comp_short_le_keys(const struct reiserfs_key *key1,
 	return 0;
 }
 
-inline void le_key2cpu_key(struct cpu_key *to, const struct reiserfs_key *from)
+void le_key2cpu_key(struct cpu_key *to, const struct reiserfs_key *from)
 {
 	int version;
 	to->on_disk_key.k_dir_id = le32_to_cpu(from->k_dir_id);
@@ -289,8 +288,8 @@ static inline const struct reiserfs_key *get_lkey(const struct treepath
 }
 
 /* Get delimiting key of the buffer at the path and its right neighbor. */
-inline const struct reiserfs_key *get_rkey(const struct treepath *p_s_chk_path,
-					   const struct super_block *p_s_sb)
+const struct reiserfs_key *get_rkey(const struct treepath *p_s_chk_path,
+				    const struct super_block *p_s_sb)
 {
 	int n_position, n_path_offset = p_s_chk_path->path_length;
 	struct buffer_head *p_s_parent;
@@ -359,7 +358,7 @@ static inline int key_in_buffer(struct treepath *p_s_chk_path,	/* Path which sho
 	return 1;
 }
 
-inline void decrement_bcount(struct buffer_head *p_s_bh)
+void decrement_bcount(struct buffer_head *p_s_bh)
 {
 	if (p_s_bh) {
 		if (atomic_read(&(p_s_bh->b_count))) {

