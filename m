Return-Path: <linux-kernel-owner+w=401wt.eu-S1754305AbYBQR4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbYBQR4S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 12:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750920AbYBQR4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 12:56:00 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:58958 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbYBQRz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 12:55:59 -0500
Date: Sun, 17 Feb 2008 18:55:49 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: mark.fasheh@oracle.com, kurt.hackel@oracle.com, ocfs2-devel@oss.oracle.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 3/7] fs/ocfs2: Use BUG_ON
Message-ID: <Pine.LNX.4.64.0802171855070.28055@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

if (...) BUG(); should be replaced with BUG_ON(...) when the test has no
side-effects to allow a definition of BUG_ON that drops the code completely.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@ disable unlikely @ expression E,f; @@

(
  if (<... f(...) ...>) { BUG(); }
|
- if (unlikely(E)) { BUG(); }
+ BUG_ON(E);
)

@@ expression E,f; @@

(
  if (<... f(...) ...>) { BUG(); }
|
- if (E) { BUG(); }
+ BUG_ON(E);
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---

diff -u -p a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c 2008-02-05 20:56:02.000000000 +0100
+++ b/fs/ocfs2/alloc.c 2008-02-17 16:40:41.000000000 +0100
@@ -1029,8 +1029,7 @@ static void ocfs2_rotate_leaf(struct ocf
 	BUG_ON(!next_free);
 
 	/* The tree code before us didn't allow enough room in the leaf. */
-	if (el->l_next_free_rec == el->l_count && !has_empty)
-		BUG();
+	BUG_ON(el->l_next_free_rec == el->l_count && !has_empty);
 
 	/*
 	 * The easiest way to approach this is to just remove the
diff -u -p a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
--- a/fs/ocfs2/journal.c 2008-02-02 16:09:08.000000000 +0100
+++ b/fs/ocfs2/journal.c 2008-02-17 16:40:59.000000000 +0100
@@ -586,8 +586,7 @@ int ocfs2_journal_load(struct ocfs2_jour
 
 	mlog_entry_void();
 
-	if (!journal)
-		BUG();
+	BUG_ON(!journal);
 
 	osb = journal->j_osb;
 
