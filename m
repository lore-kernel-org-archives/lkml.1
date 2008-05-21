Return-Path: <linux-kernel-owner+w=401wt.eu-S934781AbYEUBIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934781AbYEUBIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 21:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933150AbYEUBHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 21:07:17 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48442 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933036AbYEUBHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 21:07:02 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] ocfs2 endianness fixes
Cc: joel.becker@oracle.com, linux-kernel@vger.kernel.org
Message-Id: <E1JycnF-0008Ks-LF@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 21 May 2008 02:07:01 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Content-Length: 1027
Lines: 30

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/ocfs2/alloc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 41f84c9..10bfb46 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -2788,7 +2788,7 @@ static int ocfs2_merge_rec_right(struct inode *inode,
 	BUG_ON(index >= le16_to_cpu(el->l_next_free_rec));
 	left_rec = &el->l_recs[index];
 
-	if (index == le16_to_cpu(el->l_next_free_rec - 1) &&
+	if (index == le16_to_cpu(el->l_next_free_rec) - 1 &&
 	    le16_to_cpu(el->l_next_free_rec) == le16_to_cpu(el->l_count)) {
 		/* we meet with a cross extent block merge. */
 		ret = ocfs2_get_right_path(inode, left_path, &right_path);
@@ -2802,7 +2802,7 @@ static int ocfs2_merge_rec_right(struct inode *inode,
 		BUG_ON(next_free <= 0);
 		right_rec = &right_el->l_recs[0];
 		if (ocfs2_is_empty_extent(right_rec)) {
-			BUG_ON(le16_to_cpu(next_free) <= 1);
+			BUG_ON(next_free <= 1);
 			right_rec = &right_el->l_recs[1];
 		}
 
-- 
1.5.3.GIT


