Return-Path: <linux-kernel-owner+w=401wt.eu-S1754234AbZAJLNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbZAJLNB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 06:13:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755338AbZAJLMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 06:12:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:37611 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048AbZAJLMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 06:12:30 -0500
Subject: [PATCH] rbtree: add const qualifier to some functions
From: David Woodhouse <dwmw2@infradead.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Artem Bityutskiy <dedekind@infradead.org>
In-Reply-To: <20090108173807.2387.93418.sendpatchset@localhost.localdomain>
References: <20090108173807.2387.93418.sendpatchset@localhost.localdomain>
X-OriginalArrivalTime: 08 Jan 2009 15:38:38.0755 (UTC)
 FILETIME=[2D238730:01C971A7]
X-Nokia-AV: Clean
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-Spam-Score: -4.0 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on bombadil.infradead.org
 summary: Content analysis details:   (-4.0 points) pts rule name           
 description ---- ----------------------
 -------------------------------------------------- -4.0 RCVD_IN_DNSWL_MED  
 RBL: Sender listed at http://www.dnswl.org/, medium trust [192.100.105.134
 listed in list.dnswl.org]
X-SRS-Rewrite: SMTP reverse-path rewritten from <dedekind@infradead.org> by
 bombadil.infradead.org See http://www.infradead.org/rpr.html
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 10 Jan 2009 11:12:09 +0000
Message-Id: <1231585929.5806.44.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-2.fc10) 
Content-Transfer-Encoding: 8bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

The 'rb_first()', 'rb_last()', 'rb_next()' and 'rb_prev()' calls
take a pointer to an RB node or RB root. They do not change the
pointed objects, so add a 'const' qualifier in order to make life
of the users of these functions easier.

Indeed, if I have my own constant pointer &const struct my_type *p,
and I call 'rb_next(&p->rb)', I get a GCC warning:

warning: passing argument 1 of ‘rb_next’ discards qualifiers from pointer target type

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 include/linux/rbtree.h |    8 ++++----
 lib/rbtree.c           |   12 ++++++------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/rbtree.h b/include/linux/rbtree.h
index 344bc34..9c29541 100644
--- a/include/linux/rbtree.h
+++ b/include/linux/rbtree.h
@@ -140,10 +140,10 @@ extern void rb_insert_color(struct rb_node *, struct rb_root *);
 extern void rb_erase(struct rb_node *, struct rb_root *);
 
 /* Find logical next and previous nodes in a tree */
-extern struct rb_node *rb_next(struct rb_node *);
-extern struct rb_node *rb_prev(struct rb_node *);
-extern struct rb_node *rb_first(struct rb_root *);
-extern struct rb_node *rb_last(struct rb_root *);
+extern struct rb_node *rb_next(const struct rb_node *);
+extern struct rb_node *rb_prev(const struct rb_node *);
+extern struct rb_node *rb_first(const struct rb_root *);
+extern struct rb_node *rb_last(const struct rb_root *);
 
 /* Fast replacement of a single node without remove/rebalance/add/rebalance */
 extern void rb_replace_node(struct rb_node *victim, struct rb_node *new, 
diff --git a/lib/rbtree.c b/lib/rbtree.c
index 48499c2..9956b99 100644
--- a/lib/rbtree.c
+++ b/lib/rbtree.c
@@ -292,7 +292,7 @@ EXPORT_SYMBOL(rb_erase);
 /*
  * This function returns the first node (in sort order) of the tree.
  */
-struct rb_node *rb_first(struct rb_root *root)
+struct rb_node *rb_first(const struct rb_root *root)
 {
 	struct rb_node	*n;
 
@@ -305,7 +305,7 @@ struct rb_node *rb_first(struct rb_root *root)
 }
 EXPORT_SYMBOL(rb_first);
 
-struct rb_node *rb_last(struct rb_root *root)
+struct rb_node *rb_last(const struct rb_root *root)
 {
 	struct rb_node	*n;
 
@@ -318,7 +318,7 @@ struct rb_node *rb_last(struct rb_root *root)
 }
 EXPORT_SYMBOL(rb_last);
 
-struct rb_node *rb_next(struct rb_node *node)
+struct rb_node *rb_next(const struct rb_node *node)
 {
 	struct rb_node *parent;
 
@@ -331,7 +331,7 @@ struct rb_node *rb_next(struct rb_node *node)
 		node = node->rb_right; 
 		while (node->rb_left)
 			node=node->rb_left;
-		return node;
+		return (struct rb_node *)node;
 	}
 
 	/* No right-hand children.  Everything down and left is
@@ -347,7 +347,7 @@ struct rb_node *rb_next(struct rb_node *node)
 }
 EXPORT_SYMBOL(rb_next);
 
-struct rb_node *rb_prev(struct rb_node *node)
+struct rb_node *rb_prev(const struct rb_node *node)
 {
 	struct rb_node *parent;
 
@@ -360,7 +360,7 @@ struct rb_node *rb_prev(struct rb_node *node)
 		node = node->rb_left; 
 		while (node->rb_right)
 			node=node->rb_right;
-		return node;
+		return (struct rb_node *)node;
 	}
 
 	/* No left-hand children. Go up till we find an ancestor which
-- 
1.6.0.6

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

