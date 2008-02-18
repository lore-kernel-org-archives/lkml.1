Return-Path: <linux-kernel-owner+w=401wt.eu-S1761988AbYBRUxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761988AbYBRUxf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 15:53:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761339AbYBRUwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 15:52:39 -0500
Received: from wr-out-0506.google.com ([64.233.184.225]:23067 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760876AbYBRUwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 15:52:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=cMTs3SbY6hM353KPDfIQjRnhMJ90Q3QwW2EYgrwsJpu6jNsvJZNU2wCXrgBWpyaljoyuIwsGK0fqED820YFNFN/3YaBjtnBPAbqj5Lva2tmNgdqZNLdGeUWsjsNU30pVSYDDA1yLP21O8T9JlmQYmEqLdhkkx9okDWPo5P+p7Mc=
Subject: [PATCH 2/6] reiserfs: fix sparse warnings in do_balan.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 18 Feb 2008 12:52:40 -0800
Message-Id: <1203367960.5757.62.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/reiserfs/do_balan.c:286:34: warning: Using plain integer as NULL pointer
fs/reiserfs/do_balan.c:1731:21: warning: Using plain integer as NULL pointer
fs/reiserfs/do_balan.c:1830:2: warning: Using plain integer as NULL pointer
fs/reiserfs/do_balan.c:1830:2: warning: Using plain integer as NULL pointer
fs/reiserfs/do_balan.c:1844:2: warning: Using plain integer as NULL pointer
fs/reiserfs/do_balan.c:1844:2: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/reiserfs/do_balan.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/reiserfs/do_balan.c b/fs/reiserfs/do_balan.c
index f85c5cf..098bd54 100644
--- a/fs/reiserfs/do_balan.c
+++ b/fs/reiserfs/do_balan.c
@@ -283,7 +283,7 @@ static int balance_leaf(struct tree_balance *tb, struct item_head *ih,	/* item h
 		return balance_leaf_when_delete(tb, flag);
 
 	zeros_num = 0;
-	if (flag == M_INSERT && body == 0)
+	if (flag == M_INSERT && body == NULL)
 		zeros_num = ih_item_len(ih);
 
 	pos_in_item = tb->tb_path->pos_in_item;
@@ -1728,7 +1728,7 @@ struct buffer_head *get_FEB(struct tree_balance *tb)
 	struct buffer_info bi;
 
 	for (i = 0; i < MAX_FEB_SIZE; i++)
-		if (tb->FEB[i] != 0)
+		if (tb->FEB[i])
 			break;
 
 	if (i == MAX_FEB_SIZE)
@@ -1827,7 +1827,7 @@ int get_left_neighbor_position(struct tree_balance *tb, int h)
 {
 	int Sh_position = PATH_H_POSITION(tb->tb_path, h + 1);
 
-	RFALSE(PATH_H_PPARENT(tb->tb_path, h) == 0 || tb->FL[h] == 0,
+	RFALSE(PATH_H_PPARENT(tb->tb_path, h) == NULL || tb->FL[h] == NULL,
 	       "vs-12325: FL[%d](%p) or F[%d](%p) does not exist",
 	       h, tb->FL[h], h, PATH_H_PPARENT(tb->tb_path, h));
 
@@ -1841,7 +1841,7 @@ int get_right_neighbor_position(struct tree_balance *tb, int h)
 {
 	int Sh_position = PATH_H_POSITION(tb->tb_path, h + 1);
 
-	RFALSE(PATH_H_PPARENT(tb->tb_path, h) == 0 || tb->FR[h] == 0,
+	RFALSE(PATH_H_PPARENT(tb->tb_path, h) == NULL || tb->FR[h] == NULL,
 	       "vs-12330: F[%d](%p) or FR[%d](%p) does not exist",
 	       h, PATH_H_PPARENT(tb->tb_path, h), h, tb->FR[h]);
 
-- 
1.5.4.1.1278.gc75be


