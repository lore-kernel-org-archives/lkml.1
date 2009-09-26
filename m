Return-Path: <linux-kernel-owner+w=401wt.eu-S1752607AbZIZSfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbZIZSfJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 14:35:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbZIZSfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 14:35:04 -0400
Received: from de01.mail.all-tld.net ([195.140.232.8]:64533 "EHLO
	de01.mail.all-tld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbZIZSfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 14:35:01 -0400
From: Anders Larsen <al@alarsen.net>
Subject: [PATCH] qnx4fs: remove remains of the (defunct) write support
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: trivial@kernel.org
Date: Sat, 26 Sep 2009 20:15:44 +0200
Message-ID: <20090926181544.5597.17433.stgit@oscar.alarsen.net>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ALL-TLD-GmbH-Information: AEV Virus and Spam Secure Mail System
X-ALL-TLD-GmbH-SpamCheck: 
X-MailScanner-From: al@alarsen.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 945ffe54bbd56ceed62de3b908800fd7c6ffb284 removed the (defunct)
write support but missed a chunk of related, dead code.

Signed-off-by: Anders Larsen <al@alarsen.net>
---

 fs/qnx4/bitmap.c |    7 -------
 fs/qnx4/inode.c  |   22 +---------------------
 2 files changed, 1 insertions(+), 28 deletions(-)

diff --git a/fs/qnx4/bitmap.c b/fs/qnx4/bitmap.c
index 32f5d13..a17440b 100644
--- a/fs/qnx4/bitmap.c
+++ b/fs/qnx4/bitmap.c
@@ -17,13 +17,6 @@
 #include <linux/bitops.h>
 #include "qnx4.h"
 
-#if 0
-int qnx4_new_block(struct super_block *sb)
-{
-	return 0;
-}
-#endif  /*  0  */
-
 static void count_bits(register const char *bmPart, register int size,
 		       int *const tf)
 {
diff --git a/fs/qnx4/inode.c b/fs/qnx4/inode.c
index c406fe1..57ac963 100644
--- a/fs/qnx4/inode.c
+++ b/fs/qnx4/inode.c
@@ -64,25 +64,7 @@ static struct buffer_head *qnx4_getblk(struct inode *inode, int nr,
 		result = sb_getblk(inode->i_sb, nr);
 		return result;
 	}
-	if (!create) {
-		return NULL;
-	}
-#if 0
-	tmp = qnx4_new_block(inode->i_sb);
-	if (!tmp) {
-		return NULL;
-	}
-	result = sb_getblk(inode->i_sb, tmp);
-	if (tst) {
-		qnx4_free_block(inode->i_sb, tmp);
-		brelse(result);
-		goto repeat;
-	}
-	tst = tmp;
-#endif
-	inode->i_ctime = CURRENT_TIME_SEC;
-	mark_inode_dirty(inode);
-	return result;
+	return NULL;
 }
 
 struct buffer_head *qnx4_bread(struct inode *inode, int block, int create)
@@ -113,8 +95,6 @@ static int qnx4_get_block( struct inode *inode, sector_t iblock, struct buffer_h
 	if ( phys ) {
 		// logical block is before EOF
 		map_bh(bh, inode->i_sb, phys);
-	} else if ( create ) {
-		// to be done.
 	}
 	return 0;
 }

