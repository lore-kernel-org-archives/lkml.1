Return-Path: <linux-kernel-owner+w=401wt.eu-S933679AbXDIOzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933679AbXDIOzF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 10:55:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933760AbXDIOyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 10:54:41 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:43996 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933679AbXDIOyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 10:54:33 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 02/21] fs: Export drop_pagecache_sb symbol
Date: Mon,  9 Apr 2007 10:53:53 -0400
Message-Id: <11761304532298-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.3.268.g3dda
In-Reply-To: <11761304521844-git-send-email-jsipek@cs.sunysb.edu>
References: <11761304521844-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezkcs.sunysb.edu>

Signed-off-by: Erez Zadok <ezkcs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipekcs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/drop_caches.c   |    4 +++-
 include/linux/mm.h |    1 +
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/drop_caches.c b/fs/drop_caches.c
index 03ea769..6a7aa05 100644
--- a/fs/drop_caches.c
+++ b/fs/drop_caches.c
@@ -3,6 +3,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/fs.h>
 #include <linux/writeback.h>
@@ -12,7 +13,7 @@
 /* A global variable is a bit ugly, but it keeps the code simple */
 int sysctl_drop_caches;
 
-static void drop_pagecache_sb(struct super_block *sb)
+void drop_pagecache_sb(struct super_block *sb)
 {
 	struct inode *inode;
 
@@ -24,6 +25,7 @@ static void drop_pagecache_sb(struct super_block *sb)
 	}
 	spin_unlock(&inode_lock);
 }
+EXPORT_SYMBOL(drop_pagecache_sb);
 
 void drop_pagecache(void)
 {
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 60e0e4a..c680669 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1157,6 +1157,7 @@ int drop_caches_sysctl_handler(struct ctl_table *, int, struct file *,
 					void __user *, size_t *, loff_t *);
 unsigned long shrink_slab(unsigned long scanned, gfp_t gfp_mask,
 			unsigned long lru_pages);
+extern void drop_pagecache_sb(struct super_block *);
 void drop_pagecache(void);
 void drop_slab(void);
 
-- 
1.5.0.3.268.g3dda

