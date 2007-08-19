Return-Path: <linux-kernel-owner+w=401wt.eu-S1753898AbXHSHRG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbXHSHRG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 03:17:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629AbXHSHPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 03:15:22 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:53702 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753458AbXHSHOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 03:14:49 -0400
Message-ID: <387507685.32383@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070819071445.137947640@mail.ustc.edu.cn>
References: <20070819065349.160284305@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Sun, 19 Aug 2007 14:53:55 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Ken Chen <kenchen@google.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] prevent time-ordering warnings
Content-Disposition: inline; filename=dirty-order-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It's -mm staff.

Just to make the inode list time ordering check logic comfortable.
Otherwise the old behavior is preferred.

Cc: Ken Chen <kenchen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/fs-writeback.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- linux-2.6.23-rc2-mm2.orig/fs/fs-writeback.c
+++ linux-2.6.23-rc2-mm2/fs/fs-writeback.c
@@ -224,14 +224,7 @@ static void redirty_tail(struct inode *i
 	struct super_block *sb = inode->i_sb;
 
 	check_dirty_inode(inode);
-	if (!list_empty(&sb->s_dirty)) {
-		struct inode *tail_inode;
-
-		tail_inode = list_entry(sb->s_dirty.next, struct inode, i_list);
-		if (!time_after_eq(inode->dirtied_when,
-				tail_inode->dirtied_when))
-			inode->dirtied_when = jiffies;
-	}
+	inode->dirtied_when = jiffies;
 	list_move(&inode->i_list, &sb->s_dirty);
 	check_dirty_inode(inode);
 }

-- 
