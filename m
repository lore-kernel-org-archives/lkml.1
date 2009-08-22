Return-Path: <linux-kernel-owner+w=401wt.eu-S933199AbZHVSk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933199AbZHVSk4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 14:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933153AbZHVSkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 14:40:55 -0400
Received: from server1.wserver.cz ([82.113.45.157]:57498 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933130AbZHVSkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 14:40:55 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: akpm@linux-foundation.org
Cc: vs@namesys.com, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] FS: reiser4, add parenths around !X & Y
Date: Sat, 22 Aug 2009 20:40:55 +0200
Message-Id: <1250966455-29446-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change !X & Y to !(X & Y) to avoid compiler confusion and
fix a bug.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 fs/reiser4/carry_ops.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/reiser4/carry_ops.c b/fs/reiser4/carry_ops.c
index 4ed55dc..0906dbd 100644
--- a/fs/reiser4/carry_ops.c
+++ b/fs/reiser4/carry_ops.c
@@ -79,7 +79,7 @@ static carry_node *find_left_neighbor(carry_op * op	/* node to find left
 	left->free = 1;
 
 	flags = GN_TRY_LOCK;
-	if (!op->u.insert.flags & COPI_LOAD_LEFT)
+	if (!(op->u.insert.flags & COPI_LOAD_LEFT))
 		flags |= GN_NO_ALLOC;
 
 	/* then, feeling lucky, peek left neighbor in the cache. */
@@ -203,7 +203,7 @@ static carry_node *find_right_neighbor(carry_op * op	/* node to find right
 	read_unlock_tree(tree);
 
 	flags = GN_CAN_USE_UPPER_LEVELS;
-	if (!op->u.insert.flags & COPI_LOAD_RIGHT)
+	if (!(op->u.insert.flags & COPI_LOAD_RIGHT))
 		flags = GN_NO_ALLOC;
 
 	/* then, try to lock right neighbor */
-- 
1.6.3.3

