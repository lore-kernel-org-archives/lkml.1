Return-Path: <linux-kernel-owner+w=401wt.eu-S1753216AbXL1Nwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbXL1Nwe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 08:52:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbXL1Nvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 08:51:32 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:44602 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752915AbXL1Nv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 08:51:28 -0500
Message-ID: <398849895.70302@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20071228135123.092384048@mail.ustc.edu.cn>
References: <20071228134119.112899193@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Fri, 28 Dec 2007 21:41:29 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Michael Rubin <mrubin@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 10/11] writeback: remove redirty_tail()
Content-Disposition: inline; filename=writeback-remove-redirty_tail.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove redirty_tail(). It's no longer used.

Cc: Michael Rubin <mrubin@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/fs-writeback.c |   24 ------------------------
 1 file changed, 24 deletions(-)

--- linux-2.6.24-rc6-mm1.orig/fs/fs-writeback.c
+++ linux-2.6.24-rc6-mm1/fs/fs-writeback.c
@@ -146,34 +146,10 @@ static int write_inode(struct inode *ino
 		return inode->i_sb->s_op->write_inode(inode, sync);
 	return 0;
 }
 
 /*
- * Redirty an inode: set its when-it-was dirtied timestamp and move it to the
- * furthest end of its superblock's dirty-inode list.
- *
- * Before stamping the inode's ->dirtied_when, we check to see whether it is
- * already the most-recently-dirtied inode on the s_dirty list.  If that is
- * the case then the inode must have been redirtied while it was being written
- * out and we don't reset its dirtied_when.
- */
-static void redirty_tail(struct inode *inode)
-{
-	struct super_block *sb = inode->i_sb;
-
-	if (!list_empty(&sb->s_dirty)) {
-		struct inode *tail_inode;
-
-		tail_inode = list_entry(sb->s_dirty.next, struct inode, i_list);
-		if (!time_after_eq(inode->dirtied_when,
-				tail_inode->dirtied_when))
-			inode->dirtied_when = jiffies;
-	}
-	list_move(&inode->i_list, &sb->s_dirty);
-}
-
-/*
  * requeue inode for re-scanning after sb->s_io list is exhausted.
  */
 static void requeue_io(struct inode *inode)
 {
 	list_move(&inode->i_list, &inode->i_sb->s_more_io);

-- 
