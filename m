Return-Path: <linux-kernel-owner+w=401wt.eu-S936135AbXGZQri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936135AbXGZQri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 12:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932122AbXGZQrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 12:47:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48600 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765622AbXGZQrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 12:47:04 -0400
Date: Thu, 26 Jul 2007 17:47:03 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] more reiserfs endianness annotations
Message-ID: <20070726164703.GP27237@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/fs/reiserfs/stree.c b/fs/reiserfs/stree.c
index b6f1259..981027d 100644
--- a/fs/reiserfs/stree.c
+++ b/fs/reiserfs/stree.c
@@ -1042,7 +1042,8 @@ static char prepare_for_delete_or_cut(struct reiserfs_transaction_handle *th, st
 		pos = I_UNFM_NUM(&s_ih);
 
 		while (le_ih_k_offset (&s_ih) + (pos - 1) * blk_size > n_new_file_length) {
-		    __u32 *unfm, block;
+		    __le32 *unfm;
+		    __u32 block;
 
 		    /* Each unformatted block deletion may involve one additional
 		     * bitmap block into the transaction, thereby the initial
@@ -1052,7 +1053,7 @@ static char prepare_for_delete_or_cut(struct reiserfs_transaction_handle *th, st
 			break;
 		    }
 
-		    unfm = (__u32 *)B_I_PITEM(p_s_bh, &s_ih) + pos - 1;
+		    unfm = (__le32 *)B_I_PITEM(p_s_bh, &s_ih) + pos - 1;
 		    block = get_block_num(unfm, 0);
 
 		    if (block != 0) {
