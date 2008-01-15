Return-Path: <linux-kernel-owner+w=401wt.eu-S1756926AbYAOMu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926AbYAOMu4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 07:50:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754405AbYAOMs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 07:48:28 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:48051 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751403AbYAOMsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 07:48:08 -0500
Message-ID: <400401295.20625@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20080115124801.430525129@mail.ustc.edu.cn>
References: <20080115123637.518924046@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jan 2008 20:36:46 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Michael Rubin <mrubin@google.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 09/13] writeback: requeue_io() on redirtied inode
Content-Disposition: inline; filename=writeback-remove-redirty-b.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Redirtied inodes could be seen in really fast writes.
They should really be synced as soon as possible.

redirty_tail() could delay the inode for up to 30s.
Kill the delay by using requeue_io() instead.

Cc: Michael Rubin <mrubin@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/fs-writeback.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

--- linux-mm.orig/fs/fs-writeback.c
+++ linux-mm/fs/fs-writeback.c
@@ -294,7 +294,7 @@ __sync_single_inode(struct inode *inode,
 			 * Someone redirtied the inode while were writing back
 			 * the pages.
 			 */
-			redirty_tail(inode);
+			requeue_io(inode);
 		} else if (atomic_read(&inode->i_count)) {
 			/*
 			 * The inode is clean, inuse

-- 
