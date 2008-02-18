Return-Path: <linux-kernel-owner+w=401wt.eu-S1762088AbYBRUxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762088AbYBRUxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 15:53:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760876AbYBRUwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 15:52:40 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:16065 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760996AbYBRUwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 15:52:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GMKfxYjPx1gKEzYwxIu4pu081RMKfP0jZmuff0/lswJu0n/gH+XzdOxuMCchYKWZ+xMrIkyOPk5SIuBKaV00wCBhkp5hv+XMYPx+LDlW0L68hBbSR5jy6Z4+XjjeNR1Wi5D6pWk/NPnuUay7dG1s8LS+B9e7p+v2XX4DCHAce6o=
Subject: [PATCH 5/6] reiserfs: fix sparse warnings in do_balan.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 18 Feb 2008 12:52:42 -0800
Message-Id: <1203367962.5757.65.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/reiserfs/do_balan.c:1467:10: warning: symbol 'ret_val' shadows an earlier one
fs/reiserfs/do_balan.c:275:6: originally declared here
fs/reiserfs/do_balan.c:1471:23: warning: symbol 'ih' shadows an earlier one
fs/reiserfs/do_balan.c:249:67: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/reiserfs/do_balan.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/reiserfs/do_balan.c b/fs/reiserfs/do_balan.c
index 098bd54..486eb8a 100644
--- a/fs/reiserfs/do_balan.c
+++ b/fs/reiserfs/do_balan.c
@@ -1464,29 +1464,29 @@ static int balance_leaf(struct tree_balance *tb, struct item_head *ih,	/* item h
 				} else
 					/* item falls wholly into S_new[i] */
 				{
-					int ret_val;
+					int leaf_mi;
 					struct item_head *pasted;
 
 #ifdef CONFIG_REISERFS_CHECK
-					struct item_head *ih =
+					struct item_head *ih_check =
 					    B_N_PITEM_HEAD(tbS0, item_pos);
 
-					if (!is_direntry_le_ih(ih)
-					    && (pos_in_item != ih_item_len(ih)
+					if (!is_direntry_le_ih(ih_check)
+					    && (pos_in_item != ih_item_len(ih_check)
 						|| tb->insert_size[0] <= 0))
 						reiserfs_panic(tb->tb_sb,
 							       "PAP-12235: balance_leaf: pos_in_item must be equal to ih_item_len");
 #endif				/* CONFIG_REISERFS_CHECK */
 
-					ret_val =
+					leaf_mi =
 					    leaf_move_items(LEAF_FROM_S_TO_SNEW,
 							    tb, snum[i],
 							    sbytes[i],
 							    S_new[i]);
 
-					RFALSE(ret_val,
+					RFALSE(leaf_mi,
 					       "PAP-12240: unexpected value returned by leaf_move_items (%d)",
-					       ret_val);
+					       leaf_mi);
 
 					/* paste into item */
 					bi.tb = tb;
-- 
1.5.4.1.1278.gc75be



