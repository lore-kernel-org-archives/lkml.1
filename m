Return-Path: <linux-kernel-owner+w=401wt.eu-S1758778AbYC2DHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778AbYC2DHk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 23:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753710AbYC2DHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 23:07:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49674 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758092AbYC2DH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 23:07:29 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] NULL noise: fs/*, mm/*, kernel/*
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1JfRPk-0002Vz-Hp@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 29 Mar 2008 03:07:28 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/reiserfs/do_balan.c |    8 ++++----
 fs/reiserfs/fix_node.c |    8 +++++---
 fs/reiserfs/lbalance.c |    2 +-
 fs/reiserfs/namei.c    |    2 +-
 fs/smbfs/smbiod.c      |    2 +-
 kernel/cgroup.c        |    4 ++--
 kernel/futex.c         |    2 +-
 mm/sparse-vmemmap.c    |    8 ++++----
 8 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/fs/reiserfs/do_balan.c b/fs/reiserfs/do_balan.c
index f85c5cf..7ee4208 100644
--- a/fs/reiserfs/do_balan.c
+++ b/fs/reiserfs/do_balan.c
@@ -283,7 +283,7 @@ static int balance_leaf(struct tree_balance *tb, struct item_head *ih,	/* item h
 		return balance_leaf_when_delete(tb, flag);
 
 	zeros_num = 0;
-	if (flag == M_INSERT && body == 0)
+	if (flag == M_INSERT && !body)
 		zeros_num = ih_item_len(ih);
 
 	pos_in_item = tb->tb_path->pos_in_item;
@@ -1728,7 +1728,7 @@ struct buffer_head *get_FEB(struct tree_balance *tb)
 	struct buffer_info bi;
 
 	for (i = 0; i < MAX_FEB_SIZE; i++)
-		if (tb->FEB[i] != 0)
+		if (tb->FEB[i] != NULL)
 			break;
 
 	if (i == MAX_FEB_SIZE)
@@ -1827,7 +1827,7 @@ int get_left_neighbor_position(struct tree_balance *tb, int h)
 {
 	int Sh_position = PATH_H_POSITION(tb->tb_path, h + 1);
 
-	RFALSE(PATH_H_PPARENT(tb->tb_path, h) == 0 || tb->FL[h] == 0,
+	RFALSE(PATH_H_PPARENT(tb->tb_path, h) == NULL || tb->FL[h] == NULL,
 	       "vs-12325: FL[%d](%p) or F[%d](%p) does not exist",
 	       h, tb->FL[h], h, PATH_H_PPARENT(tb->tb_path, h));
 
@@ -1841,7 +1841,7 @@ int get_right_neighbor_position(struct tree_balance *tb, int h)
 {
 	int Sh_position = PATH_H_POSITION(tb->tb_path, h + 1);
 
-	RFALSE(PATH_H_PPARENT(tb->tb_path, h) == 0 || tb->FR[h] == 0,
+	RFALSE(PATH_H_PPARENT(tb->tb_path, h) == NULL || tb->FR[h] == NULL,
 	       "vs-12330: F[%d](%p) or FR[%d](%p) does not exist",
 	       h, PATH_H_PPARENT(tb->tb_path, h), h, tb->FR[h]);
 
diff --git a/fs/reiserfs/fix_node.c b/fs/reiserfs/fix_node.c
index 0ee35c6..07d05e0 100644
--- a/fs/reiserfs/fix_node.c
+++ b/fs/reiserfs/fix_node.c
@@ -153,7 +153,7 @@ static void create_virtual_node(struct tree_balance *tb, int h)
 	if (vn->vn_mode == M_INSERT) {
 		struct virtual_item *vi = vn->vn_vi + vn->vn_affected_item_num;
 
-		RFALSE(vn->vn_ins_ih == 0,
+		RFALSE(vn->vn_ins_ih == NULL,
 		       "vs-8040: item header of inserted item is not specified");
 		vi->vi_item_len = tb->insert_size[0];
 		vi->vi_ih = vn->vn_ins_ih;
@@ -857,7 +857,8 @@ static int get_lfree(struct tree_balance *tb, int h)
 	struct buffer_head *l, *f;
 	int order;
 
-	if ((f = PATH_H_PPARENT(tb->tb_path, h)) == 0 || (l = tb->FL[h]) == 0)
+	if ((f = PATH_H_PPARENT(tb->tb_path, h)) == NULL ||
+	    (l = tb->FL[h]) == NULL)
 		return 0;
 
 	if (f == l)
@@ -878,7 +879,8 @@ static int get_rfree(struct tree_balance *tb, int h)
 	struct buffer_head *r, *f;
 	int order;
 
-	if ((f = PATH_H_PPARENT(tb->tb_path, h)) == 0 || (r = tb->FR[h]) == 0)
+	if ((f = PATH_H_PPARENT(tb->tb_path, h)) == NULL ||
+	    (r = tb->FR[h]) == NULL)
 		return 0;
 
 	if (f == r)
diff --git a/fs/reiserfs/lbalance.c b/fs/reiserfs/lbalance.c
index 281f806..6de060a 100644
--- a/fs/reiserfs/lbalance.c
+++ b/fs/reiserfs/lbalance.c
@@ -626,7 +626,7 @@ static void leaf_define_dest_src_infos(int shift_mode, struct tree_balance *tb,
 			       "vs-10250: leaf_define_dest_src_infos: shift type is unknown (%d)",
 			       shift_mode);
 	}
-	RFALSE(src_bi->bi_bh == 0 || dest_bi->bi_bh == 0,
+	RFALSE(!src_bi->bi_bh || !dest_bi->bi_bh,
 	       "vs-10260: mode==%d, source (%p) or dest (%p) buffer is initialized incorrectly",
 	       shift_mode, src_bi->bi_bh, dest_bi->bi_bh);
 }
diff --git a/fs/reiserfs/namei.c b/fs/reiserfs/namei.c
index b378eea..8867533 100644
--- a/fs/reiserfs/namei.c
+++ b/fs/reiserfs/namei.c
@@ -452,7 +452,7 @@ static int reiserfs_add_entry(struct reiserfs_transaction_handle *th,
 	buflen = DEH_SIZE + ROUND_UP(namelen);
 	if (buflen > sizeof(small_buf)) {
 		buffer = kmalloc(buflen, GFP_NOFS);
-		if (buffer == 0)
+		if (!buffer)
 			return -ENOMEM;
 	} else
 		buffer = small_buf;
diff --git a/fs/smbfs/smbiod.c b/fs/smbfs/smbiod.c
index fae8e85..6bd9b69 100644
--- a/fs/smbfs/smbiod.c
+++ b/fs/smbfs/smbiod.c
@@ -206,7 +206,7 @@ int smbiod_retry(struct smb_sb_info *server)
 
 	smb_close_socket(server);
 
-	if (pid == 0) {
+	if (!pid) {
 		/* FIXME: this is fatal, umount? */
 		printk(KERN_ERR "smb_retry: no connection process\n");
 		server->state = CONN_RETRIED;
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e9c2fb0..53d86b4 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2082,7 +2082,7 @@ static int cgroup_tasks_open(struct inode *unused, struct file *file)
 
 		kfree(pidarray);
 	} else {
-		ctr->buf = 0;
+		ctr->buf = NULL;
 		ctr->bufsz = 0;
 	}
 	file->private_data = ctr;
@@ -2614,7 +2614,7 @@ static int proc_cgroupstats_show(struct seq_file *m, void *v)
 
 static int cgroupstats_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, proc_cgroupstats_show, 0);
+	return single_open(file, proc_cgroupstats_show, NULL);
 }
 
 static struct file_operations proc_cgroupstats_operations = {
diff --git a/kernel/futex.c b/kernel/futex.c
index 87a6428..e43945e 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -281,7 +281,7 @@ static int get_futex_key(u32 __user *uaddr, struct rw_semaphore *fshared,
  */
 static void get_futex_key_refs(union futex_key *key)
 {
-	if (key->both.ptr == 0)
+	if (key->both.ptr == NULL)
 		return;
 	switch (key->both.offset & (FUT_OFF_INODE|FUT_OFF_MMSHARED)) {
 		case FUT_OFF_INODE:
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index cd75b21..99c4f36 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -76,7 +76,7 @@ pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node)
 		pte_t entry;
 		void *p = vmemmap_alloc_block(PAGE_SIZE, node);
 		if (!p)
-			return 0;
+			return NULL;
 		entry = pfn_pte(__pa(p) >> PAGE_SHIFT, PAGE_KERNEL);
 		set_pte_at(&init_mm, addr, pte, entry);
 	}
@@ -89,7 +89,7 @@ pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node)
 	if (pmd_none(*pmd)) {
 		void *p = vmemmap_alloc_block(PAGE_SIZE, node);
 		if (!p)
-			return 0;
+			return NULL;
 		pmd_populate_kernel(&init_mm, pmd, p);
 	}
 	return pmd;
@@ -101,7 +101,7 @@ pud_t * __meminit vmemmap_pud_populate(pgd_t *pgd, unsigned long addr, int node)
 	if (pud_none(*pud)) {
 		void *p = vmemmap_alloc_block(PAGE_SIZE, node);
 		if (!p)
-			return 0;
+			return NULL;
 		pud_populate(&init_mm, pud, p);
 	}
 	return pud;
@@ -113,7 +113,7 @@ pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
 	if (pgd_none(*pgd)) {
 		void *p = vmemmap_alloc_block(PAGE_SIZE, node);
 		if (!p)
-			return 0;
+			return NULL;
 		pgd_populate(&init_mm, pgd, p);
 	}
 	return pgd;
-- 
1.5.3.GIT


