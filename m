Return-Path: <linux-kernel-owner+w=401wt.eu-S1754320AbXL1Nvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbXL1Nvi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 08:51:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbXL1Nv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 08:51:29 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:44541 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752841AbXL1Nv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 08:51:28 -0500
Message-ID: <398849894.70377@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20071228135122.498901458@mail.ustc.edu.cn>
References: <20071228134119.112899193@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Fri, 28 Dec 2007 21:41:25 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Michael Rubin <mrubin@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 06/11] writeback: requeue_io_wait() on locked buffers
Content-Disposition: inline; filename=writeback-more_io_wait-d.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to requeue_io_wait() for case:

	pages skipped due to locked buffers

Cc: Michael Rubin <mrubin@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/fs-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.24-rc6-mm1.orig/fs/fs-writeback.c
+++ linux-2.6.24-rc6-mm1/fs/fs-writeback.c
@@ -449,11 +449,11 @@ int generic_sync_sb_inodes(struct super_
 		if (wbc->pages_skipped != pages_skipped) {
 			/*
 			 * writeback is not making progress due to locked
 			 * buffers.  Skip this inode for now.
 			 */
-			redirty_tail(inode);
+			requeue_io_wait(inode);
 		}
 		spin_unlock(&inode_lock);
 		iput(inode);
 		cond_resched();
 		spin_lock(&inode_lock);

-- 
