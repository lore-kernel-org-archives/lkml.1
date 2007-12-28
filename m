Return-Path: <linux-kernel-owner+w=401wt.eu-S1755830AbXL1Nxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbXL1Nxq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 08:53:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752915AbXL1Nvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 08:51:44 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:44585 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752937AbXL1Nv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 08:51:29 -0500
Message-ID: <398849895.11859@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20071228135122.931500020@mail.ustc.edu.cn>
References: <20071228134119.112899193@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Fri, 28 Dec 2007 21:41:28 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Michael Rubin <mrubin@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 09/11] writeback: replace redirty_tail() on memory-backed bdi
Content-Disposition: inline; filename=writeback-remove-redirty-a.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace redirty_tail() with queue_dirty() on memory backed bdi.

Cc: Michael Rubin <mrubin@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/fs-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.24-rc6-mm1.orig/fs/fs-writeback.c
+++ linux-2.6.24-rc6-mm1/fs/fs-writeback.c
@@ -400,11 +400,11 @@ int generic_sync_sb_inodes(struct super_
 		struct backing_dev_info *bdi = mapping->backing_dev_info;
 		long pages_skipped;
 		int err;
 
 		if (!bdi_cap_writeback_dirty(bdi)) {
-			redirty_tail(inode);
+			queue_dirty(inode);
 			if (sb_is_blkdev_sb(sb)) {
 				/*
 				 * Dirty memory-backed blockdev: the ramdisk
 				 * driver does this.  Skip just this inode
 				 */

-- 
