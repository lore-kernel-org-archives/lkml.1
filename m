Return-Path: <linux-kernel-owner+w=401wt.eu-S1756356AbYAOMtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356AbYAOMtg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 07:49:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755091AbYAOMsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 07:48:17 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:47989 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753184AbYAOMsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 07:48:08 -0500
Message-ID: <400401293.21086@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20080115124801.012754821@mail.ustc.edu.cn>
References: <20080115123637.518924046@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jan 2008 20:36:45 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Michael Rubin <mrubin@google.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 08/13] writeback: defer writeback on locked buffers
Content-Disposition: inline; filename=writeback-more_io_wait-d.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to requeue_io_wait() for case:

	pages skipped due to locked buffers.

Cc: Michael Rubin <mrubin@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/fs-writeback.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

--- linux-mm.orig/fs/fs-writeback.c
+++ linux-mm/fs/fs-writeback.c
@@ -456,7 +456,7 @@ int generic_sync_sb_inodes(struct super_
 			 * writeback is not making progress due to locked
 			 * buffers.  Skip this inode for now.
 			 */
-			redirty_tail(inode);
+			requeue_io_wait(inode);
 		}
 		spin_unlock(&inode_lock);
 		iput(inode);

-- 
