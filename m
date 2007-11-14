Return-Path: <linux-kernel-owner+w=401wt.eu-S1763694AbXKNCIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763694AbXKNCIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 21:08:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761603AbXKNCFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 21:05:31 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:4774 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761605AbXKNCF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 21:05:29 -0500
Subject: [PATCH] - [10/15] - remove defconfig ptr comparisons to 0 -
	fs/reiserfs
From: Joe Perches <joe@perches.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Hans Reiser <reiserfs-dev@namesys.com>, reiserfs-devel@vger.kernel.org
Content-Type: text/plain
Date: Tue, 13 Nov 2007 18:05:28 -0800
Message-Id: <1195005928.5163.96.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove defconfig ptr comparison to 0

Remove sparse warning: Using plain integer as NULL pointer

Signed-off-by: Joe Perches <joe@perches.com>

---

diff --git a/fs/reiserfs/do_balan.c b/fs/reiserfs/do_balan.c
index f85c5cf..40786d2 100644
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
+		if (tb->FEB[i])
 			break;
 
 	if (i == MAX_FEB_SIZE)
diff --git a/fs/reiserfs/fix_node.c b/fs/reiserfs/fix_node.c
index 0ee35c6..af375c6 100644
--- a/fs/reiserfs/fix_node.c
+++ b/fs/reiserfs/fix_node.c
@@ -857,7 +857,7 @@ static int get_lfree(struct tree_balance *tb, int h)
 	struct buffer_head *l, *f;
 	int order;
 
-	if ((f = PATH_H_PPARENT(tb->tb_path, h)) == 0 || (l = tb->FL[h]) == 0)
+	if (!(f = PATH_H_PPARENT(tb->tb_path, h)) || !(l = tb->FL[h]))
 		return 0;
 
 	if (f == l)
@@ -878,7 +878,7 @@ static int get_rfree(struct tree_balance *tb, int h)
 	struct buffer_head *r, *f;
 	int order;
 
-	if ((f = PATH_H_PPARENT(tb->tb_path, h)) == 0 || (r = tb->FR[h]) == 0)
+	if (!(f = PATH_H_PPARENT(tb->tb_path, h)) || !(r = tb->FR[h]))
 		return 0;
 
 	if (f == r)
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


