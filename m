Return-Path: <linux-kernel-owner+w=401wt.eu-S1757324AbYAOMwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324AbYAOMwY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 07:52:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753017AbYAOMsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 07:48:36 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:48023 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754980AbYAOMsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 07:48:07 -0500
Message-ID: <400401293.44721@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20080115124802.215191468@mail.ustc.edu.cn>
References: <20080115123637.518924046@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jan 2008 20:36:48 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Michael Rubin <mrubin@google.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 11/13] writeback: queue_dirty() on memory-backed bdi
Content-Disposition: inline; filename=writeback-remove-redirty-a.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace redirty_tail() with queue_dirty() on memory backed bdi.
It makes no difference - only simpler.

Cc: Michael Rubin <mrubin@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/fs-writeback.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

--- linux-mm.orig/fs/fs-writeback.c
+++ linux-mm/fs/fs-writeback.c
@@ -407,7 +407,7 @@ int generic_sync_sb_inodes(struct super_
 		int err;
 
 		if (!bdi_cap_writeback_dirty(bdi)) {
-			redirty_tail(inode);
+			queue_dirty(inode);
 			if (sb_is_blkdev_sb(sb)) {
 				/*
 				 * Dirty memory-backed blockdev: the ramdisk

-- 
