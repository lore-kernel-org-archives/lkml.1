Return-Path: <linux-kernel-owner+w=401wt.eu-S1757350AbYHMIsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350AbYHMIsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755786AbYHMIjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:39:52 -0400
Received: from smtp.nokia.com ([192.100.122.230]:37224 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755724AbYHMIjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:39:48 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Zoltan Sogor <weth@inf.u-szeged.hu>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH] UBIFS: print pid in dump function
Date: Wed, 13 Aug 2008 13:17:48 +0300
Message-Id: <1218622675-28853-20-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
References: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 13 Aug 2008 08:39:03.0987 (UTC) FILETIME=[0AABC830:01C8FD20]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Useful when something fails and there are many processes
racing.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ubifs/debug.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/ubifs/debug.c b/fs/ubifs/debug.c
index 0adfb29..b9cb774 100644
--- a/fs/ubifs/debug.c
+++ b/fs/ubifs/debug.c
@@ -568,8 +568,8 @@ void dbg_dump_budget_req(const struct ubifs_budget_req *req)
 void dbg_dump_lstats(const struct ubifs_lp_stats *lst)
 {
 	spin_lock(&dbg_lock);
-	printk(KERN_DEBUG "Lprops statistics: empty_lebs %d, idx_lebs  %d\n",
-	       lst->empty_lebs, lst->idx_lebs);
+	printk(KERN_DEBUG "(pid %d) Lprops statistics: empty_lebs %d, "
+	       "idx_lebs  %d\n", current->pid, lst->empty_lebs, lst->idx_lebs);
 	printk(KERN_DEBUG "\ttaken_empty_lebs %d, total_free %lld, "
 	       "total_dirty %lld\n", lst->taken_empty_lebs, lst->total_free,
 	       lst->total_dirty);
@@ -587,8 +587,8 @@ void dbg_dump_budg(struct ubifs_info *c)
 	struct ubifs_gced_idx_leb *idx_gc;
 
 	spin_lock(&dbg_lock);
-	printk(KERN_DEBUG "Budgeting info: budg_data_growth %lld, "
-	       "budg_dd_growth %lld, budg_idx_growth %lld\n",
+	printk(KERN_DEBUG "(pid %d) Budgeting info: budg_data_growth %lld, "
+	       "budg_dd_growth %lld, budg_idx_growth %lld\n", current->pid,
 	       c->budg_data_growth, c->budg_dd_growth, c->budg_idx_growth);
 	printk(KERN_DEBUG "\tdata budget sum %lld, total budget sum %lld, "
 	       "freeable_cnt %d\n", c->budg_data_growth + c->budg_dd_growth,
@@ -634,7 +634,7 @@ void dbg_dump_lprops(struct ubifs_info *c)
 	struct ubifs_lprops lp;
 	struct ubifs_lp_stats lst;
 
-	printk(KERN_DEBUG "Dumping LEB properties\n");
+	printk(KERN_DEBUG "(pid %d) Dumping LEB properties\n", current->pid);
 	ubifs_get_lp_stats(c, &lst);
 	dbg_dump_lstats(&lst);
 
@@ -655,7 +655,7 @@ void dbg_dump_leb(const struct ubifs_info *c, int lnum)
 	if (dbg_failure_mode)
 		return;
 
-	printk(KERN_DEBUG "Dumping LEB %d\n", lnum);
+	printk(KERN_DEBUG "(pid %d) Dumping LEB %d\n", current->pid, lnum);
 
 	sleb = ubifs_scan(c, lnum, 0, c->dbg_buf);
 	if (IS_ERR(sleb)) {
@@ -720,8 +720,8 @@ void dbg_dump_heap(struct ubifs_info *c, struct ubifs_lpt_heap *heap, int cat)
 {
 	int i;
 
-	printk(KERN_DEBUG "Dumping heap cat %d (%d elements)\n",
-	       cat, heap->cnt);
+	printk(KERN_DEBUG "(pid %d) Dumping heap cat %d (%d elements)\n",
+	       current->pid, cat, heap->cnt);
 	for (i = 0; i < heap->cnt; i++) {
 		struct ubifs_lprops *lprops = heap->arr[i];
 
@@ -736,7 +736,7 @@ void dbg_dump_pnode(struct ubifs_info *c, struct ubifs_pnode *pnode,
 {
 	int i;
 
-	printk(KERN_DEBUG "Dumping pnode:\n");
+	printk(KERN_DEBUG "(pid %d) Dumping pnode:\n", current->pid);
 	printk(KERN_DEBUG "\taddress %zx parent %zx cnext %zx\n",
 	       (size_t)pnode, (size_t)parent, (size_t)pnode->cnext);
 	printk(KERN_DEBUG "\tflags %lu iip %d level %d num %d\n",
@@ -755,7 +755,7 @@ void dbg_dump_tnc(struct ubifs_info *c)
 	int level;
 
 	printk(KERN_DEBUG "\n");
-	printk(KERN_DEBUG "Dumping the TNC tree\n");
+	printk(KERN_DEBUG "(pid %d) Dumping the TNC tree\n", current->pid);
 	znode = ubifs_tnc_levelorder_next(c->zroot.znode, NULL);
 	level = znode->level;
 	printk(KERN_DEBUG "== Level %d ==\n", level);
-- 
1.5.4.1

