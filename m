Return-Path: <linux-kernel-owner+w=401wt.eu-S1758143AbXLJC4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758143AbXLJC4y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 21:56:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754862AbXLJCom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 21:44:42 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:49777 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716AbXLJCnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 21:43:13 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: hch@infradead.org, viro@ftp.linux.org.uk, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 36/42] VFS: export drop_pagecache_sb
Date: Sun,  9 Dec 2007 21:42:09 -0500
Message-Id: <11972545593966-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11972545353262-git-send-email-ezk@cs.sunysb.edu>
References: <11972545353262-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Needed to maintain cache coherency after branch management.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/drop_caches.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/drop_caches.c b/fs/drop_caches.c
index 59375ef..90410ac 100644
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
-- 
1.5.2.2

