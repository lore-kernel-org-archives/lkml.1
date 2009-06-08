Return-Path: <linux-kernel-owner+w=401wt.eu-S1757434AbZFHT34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434AbZFHT34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 15:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755306AbZFHTXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 15:23:43 -0400
Received: from thunk.org ([69.25.196.29]:39592 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755078AbZFHTXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 15:23:20 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 28/49] ext4: Simplify function signature for ext4_da_get_block_write()
Date: Mon,  8 Jun 2009 15:22:46 -0400
Message-Id: <1244488987-32564-29-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.6.3.2.1.gb9f7d.dirty
In-Reply-To: <1244488987-32564-28-git-send-email-tytso@mit.edu>
References: <1244488987-32564-1-git-send-email-tytso@mit.edu>
 <1244488987-32564-2-git-send-email-tytso@mit.edu>
 <1244488987-32564-3-git-send-email-tytso@mit.edu>
 <1244488987-32564-4-git-send-email-tytso@mit.edu>
 <1244488987-32564-5-git-send-email-tytso@mit.edu>
 <1244488987-32564-6-git-send-email-tytso@mit.edu>
 <1244488987-32564-7-git-send-email-tytso@mit.edu>
 <1244488987-32564-8-git-send-email-tytso@mit.edu>
 <1244488987-32564-9-git-send-email-tytso@mit.edu>
 <1244488987-32564-10-git-send-email-tytso@mit.edu>
 <1244488987-32564-11-git-send-email-tytso@mit.edu>
 <1244488987-32564-12-git-send-email-tytso@mit.edu>
 <1244488987-32564-13-git-send-email-tytso@mit.edu>
 <1244488987-32564-14-git-send-email-tytso@mit.edu>
 <1244488987-32564-15-git-send-email-tytso@mit.edu>
 <1244488987-32564-16-git-send-email-tytso@mit.edu>
 <1244488987-32564-17-git-send-email-tytso@mit.edu>
 <1244488987-32564-18-git-send-email-tytso@mit.edu>
 <1244488987-32564-19-git-send-email-tytso@mit.edu>
 <1244488987-32564-20-git-send-email-tytso@mit.edu>
 <1244488987-32564-21-git-send-email-tytso@mit.edu>
 <1244488987-32564-22-git-send-email-tytso@mit.edu>
 <1244488987-32564-23-git-send-email-tytso@mit.edu>
 <1244488987-32564-24-git-send-email-tytso@mit.edu>
 <1244488987-32564-25-git-send-email-tytso@mit.edu>
 <1244488987-32564-26-git-send-email-tytso@mit.edu>
 <1244488987-32564-27-git-send-email-tytso@mit.edu>
 <1244488987-32564-28-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function ext4_da_get_block_write() is called in exactly one write,
and the last argument, create, is always 1.  Remove it to simplify the
code slightly.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 4e7f363..476d843 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2000,7 +2000,7 @@ static void ext4_print_free_blocks(struct inode *inode)
 
 #define		EXT4_DELALLOC_RSVED	1
 static int ext4_da_get_block_write(struct inode *inode, sector_t iblock,
-				   struct buffer_head *bh_result, int create)
+				   struct buffer_head *bh_result)
 {
 	int ret;
 	unsigned max_blocks = bh_result->b_size >> inode->i_blkbits;
@@ -2010,7 +2010,7 @@ static int ext4_da_get_block_write(struct inode *inode, sector_t iblock,
 	handle = ext4_journal_current_handle();
 	BUG_ON(!handle);
 	ret = ext4_get_blocks_wrap(handle, inode, iblock, max_blocks,
-				   bh_result, create, 0, EXT4_DELALLOC_RSVED);
+				   bh_result, 1, 0, EXT4_DELALLOC_RSVED);
 	if (ret <= 0)
 		return ret;
 
@@ -2088,7 +2088,7 @@ static int mpage_da_map_blocks(struct mpage_da_data *mpd)
 	if (!new.b_size)
 		return 0;
 
-	err = ext4_da_get_block_write(mpd->inode, next, &new, 1);
+	err = ext4_da_get_block_write(mpd->inode, next, &new);
 	if (err) {
 		/*
 		 * If get block returns with error we simply
-- 
1.6.3.2.1.gb9f7d.dirty

