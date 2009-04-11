Return-Path: <linux-kernel-owner+w=401wt.eu-S1757787AbZDKKH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757787AbZDKKH3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 06:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755741AbZDKKHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 06:07:18 -0400
Received: from mail.gmx.net ([213.165.64.20]:60071 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752335AbZDKKHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 06:07:17 -0400
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, lowdanie@gmail.com
Content-Type: text/plain; charset="iso-8859-1"
Date: Sat, 11 Apr 2009 12:07:14 +0200
From: "Wolfram Strepp" <wstrepp@gmx.de>
Message-ID: <20090411100714.325570@gmx.net>
MIME-Version: 1.0
Subject: [PATCH 1/3] rb_tree: reorganize code in rb_erase() for additional
 changes
To: akpm@linux-foundation.org
X-Authenticated: #14768304
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX19oo0I9WZtoV2HyWQKPjQE4chifXDn3gJiBgq+9Bu
 Y9bh+vA98PJqIfsY2MdGf8sn1RaHMMNPbtSA== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: tA+IBBYebHIhJ8Jg2DQ06r4iJihyalA/
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First, move some code around in order to make the next change more obvious.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Wolfram Strepp <wstrepp@gmx.de>

---
 lib/rbtree.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)
Index: linux-2.6/lib/rbtree.c
===================================================================
--- linux-2.6.orig/lib/rbtree.c
+++ linux-2.6/lib/rbtree.c
@@ -237,6 +237,16 @@ void rb_erase(struct rb_node *node, stru
 		node = node->rb_right;
 		while ((left = node->rb_left) != NULL)
 			node = left;
+
+		if (rb_parent(old))
+		{
+			if (rb_parent(old)->rb_left == old)
+				rb_parent(old)->rb_left = node;
+			else
+				rb_parent(old)->rb_right = node;
+		} else
+			root->rb_node = node;
+
 		child = node->rb_right;
 		parent = rb_parent(node);
 		color = rb_color(node);
@@ -253,15 +263,6 @@ void rb_erase(struct rb_node *node, stru
 		node->rb_right = old->rb_right;
 		node->rb_left = old->rb_left;
 
-		if (rb_parent(old))
-		{
-			if (rb_parent(old)->rb_left == old)
-				rb_parent(old)->rb_left = node;
-			else
-				rb_parent(old)->rb_right = node;
-		} else
-			root->rb_node = node;
-
 		rb_set_parent(old->rb_left, node);
 		if (old->rb_right)
 			rb_set_parent(old->rb_right, node);


-- 
Psssst! Schon vom neuen GMX MultiMessenger gehört? Der kann`s mit allen: http://www.gmx.net/de/go/multimessenger01
