Return-Path: <linux-kernel-owner+w=401wt.eu-S932944AbXHLJWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932944AbXHLJWU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 05:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761411AbXHLJVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 05:21:16 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:37040 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1759594AbXHLJVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 05:21:12 -0400
Message-ID: <386910467.21096@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070812092053.113127445@mail.ustc.edu.cn>
References: <20070812091120.189651872@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Sun, 12 Aug 2007 17:11:25 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: "Cc: Ken Chen" <kenchen@google.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Subject: [PATCH 5/6] prevent time-ordering warnings
Content-Disposition: inline; filename=dirty-order-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Just to make the inode list time ordering check logic comfortable.
Otherwise meaningless.

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
