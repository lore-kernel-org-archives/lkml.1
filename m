Return-Path: <linux-kernel-owner+w=401wt.eu-S1761906AbYBRUxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761906AbYBRUxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 15:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761281AbYBRUwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 15:52:38 -0500
Received: from wr-out-0506.google.com ([64.233.184.238]:22831 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760550AbYBRUwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 15:52:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=slVo+Sod9HavnMh9bTmkhLcd9p/5j0yuBqhsfLXpFmXEZHGmu6n8BzAOJT9mXEJZSH6HPDzww9/RD1oeTFRM/Jz+ftgFIKjPwCIy7x2JAu+yOsdPLZWwkjSGYHVS4202bCEG5XXHCqYa46ooVVaqIECLwd9hQAG50s216Ot51Ho=
Subject: [PATCH 1/6] reiserfs: fix sparse warnings in fix_node.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 18 Feb 2008 12:52:40 -0800
Message-Id: <1203367960.5757.61.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/reiserfs/fix_node.c:156:3: warning: Using plain integer as NULL pointer
fs/reiserfs/fix_node.c:860:46: warning: Using plain integer as NULL pointer
fs/reiserfs/fix_node.c:860:70: warning: Using plain integer as NULL pointer
fs/reiserfs/fix_node.c:881:46: warning: Using plain integer as NULL pointer
fs/reiserfs/fix_node.c:881:70: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/reiserfs/fix_node.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/reiserfs/fix_node.c b/fs/reiserfs/fix_node.c
index 0ee35c6..07d05e0 100644
--- a/fs/reiserfs/fix_node.c
+++ b/fs/reiserfs/fix_node.c
@@ -153,7 +153,7 @@ static void create_virtual_node(struct tree_balance *tb, int h)
 	if (vn->vn_mode == M_INSERT) {
 		struct virtual_item *vi = vn->vn_vi + vn->vn_affected_item_num;
 
-		RFALSE(vn->vn_ins_ih == 0,
+		RFALSE(vn->vn_ins_ih == NULL,
 		       "vs-8040: item header of inserted item is not specified");
 		vi->vi_item_len = tb->insert_size[0];
 		vi->vi_ih = vn->vn_ins_ih;
@@ -857,7 +857,8 @@ static int get_lfree(struct tree_balance *tb, int h)
 	struct buffer_head *l, *f;
 	int order;
 
-	if ((f = PATH_H_PPARENT(tb->tb_path, h)) == 0 || (l = tb->FL[h]) == 0)
+	if ((f = PATH_H_PPARENT(tb->tb_path, h)) == NULL ||
+	    (l = tb->FL[h]) == NULL)
 		return 0;
 
 	if (f == l)
@@ -878,7 +879,8 @@ static int get_rfree(struct tree_balance *tb, int h)
 	struct buffer_head *r, *f;
 	int order;
 
-	if ((f = PATH_H_PPARENT(tb->tb_path, h)) == 0 || (r = tb->FR[h]) == 0)
+	if ((f = PATH_H_PPARENT(tb->tb_path, h)) == NULL ||
+	    (r = tb->FR[h]) == NULL)
 		return 0;
 
 	if (f == r)
-- 
1.5.4.1.1278.gc75be


