Return-Path: <linux-kernel-owner+w=401wt.eu-S934740AbYEAADO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934740AbYEAADO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 20:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934038AbYD3X6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 19:58:53 -0400
Received: from mx1.suse.de ([195.135.220.2]:47526 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764156AbYD3X6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 19:58:51 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 11/11] klist: fix coding style errors in klist.h and klist.c
Date: Wed, 30 Apr 2008 16:57:50 -0700
Message-Id: <1209599870-22919-11-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <20080430235701.GA20981@suse.de>
References: <20080430235701.GA20981@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Finally clean up the odd spacing in these files.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/klist.h |   30 ++++----
 lib/klist.c           |  206 ++++++++++++++++++++-----------------------------
 2 files changed, 100 insertions(+), 136 deletions(-)

diff --git a/include/linux/klist.h b/include/linux/klist.h
index b49385f..06c338e 100644
--- a/include/linux/klist.h
+++ b/include/linux/klist.h
@@ -34,38 +34,38 @@ struct klist {
 #define DEFINE_KLIST(_name, _get, _put)					\
 	struct klist _name = KLIST_INIT(_name, _get, _put)
 
-extern void klist_init(struct klist * k, void (*get)(struct klist_node *),
+extern void klist_init(struct klist *k, void (*get)(struct klist_node *),
 		       void (*put)(struct klist_node *));
 
 struct klist_node {
-	struct klist		* n_klist;
+	struct klist		*n_klist;
 	struct list_head	n_node;
 	struct kref		n_ref;
 	struct completion	n_removed;
 };
 
-extern void klist_add_tail(struct klist_node * n, struct klist * k);
-extern void klist_add_head(struct klist_node * n, struct klist * k);
+extern void klist_add_tail(struct klist_node *n, struct klist *k);
+extern void klist_add_head(struct klist_node *n, struct klist *k);
 extern void klist_add_after(struct klist_node *n, struct klist_node *pos);
 extern void klist_add_before(struct klist_node *n, struct klist_node *pos);
 
-extern void klist_del(struct klist_node * n);
-extern void klist_remove(struct klist_node * n);
+extern void klist_del(struct klist_node *n);
+extern void klist_remove(struct klist_node *n);
 
-extern int klist_node_attached(struct klist_node * n);
+extern int klist_node_attached(struct klist_node *n);
 
 
 struct klist_iter {
-	struct klist		* i_klist;
-	struct list_head	* i_head;
-	struct klist_node	* i_cur;
+	struct klist		*i_klist;
+	struct list_head	*i_head;
+	struct klist_node	*i_cur;
 };
 
 
-extern void klist_iter_init(struct klist * k, struct klist_iter * i);
-extern void klist_iter_init_node(struct klist * k, struct klist_iter * i, 
-				 struct klist_node * n);
-extern void klist_iter_exit(struct klist_iter * i);
-extern struct klist_node * klist_next(struct klist_iter * i);
+extern void klist_iter_init(struct klist *k, struct klist_iter *i);
+extern void klist_iter_init_node(struct klist *k, struct klist_iter *i,
+				 struct klist_node *n);
+extern void klist_iter_exit(struct klist_iter *i);
+extern struct klist_node *klist_next(struct klist_iter *i);
 
 #endif
diff --git a/lib/klist.c b/lib/klist.c
index ebba948..cca37f9 100644
--- a/lib/klist.c
+++ b/lib/klist.c
@@ -1,38 +1,37 @@
 /*
- *	klist.c - Routines for manipulating klists.
+ * klist.c - Routines for manipulating klists.
  *
+ * Copyright (C) 2005 Patrick Mochel
  *
- *	This klist interface provides a couple of structures that wrap around 
- *	struct list_head to provide explicit list "head" (struct klist) and 
- *	list "node" (struct klist_node) objects. For struct klist, a spinlock
- *	is included that protects access to the actual list itself. struct 
- *	klist_node provides a pointer to the klist that owns it and a kref
- *	reference count that indicates the number of current users of that node
- *	in the list.
+ * This file is released under the GPL v2.
  *
- *	The entire point is to provide an interface for iterating over a list
- *	that is safe and allows for modification of the list during the
- *	iteration (e.g. insertion and removal), including modification of the
- *	current node on the list.
+ * This klist interface provides a couple of structures that wrap around
+ * struct list_head to provide explicit list "head" (struct klist) and list
+ * "node" (struct klist_node) objects. For struct klist, a spinlock is
+ * included that protects access to the actual list itself. struct
+ * klist_node provides a pointer to the klist that owns it and a kref
+ * reference count that indicates the number of current users of that node
+ * in the list.
  *
- *	It works using a 3rd object type - struct klist_iter - that is declared
- *	and initialized before an iteration. klist_next() is used to acquire the
- *	next element in the list. It returns NULL if there are no more items.
- *	Internally, that routine takes the klist's lock, decrements the reference
- *	count of the previous klist_node and increments the count of the next
- *	klist_node. It then drops the lock and returns.
+ * The entire point is to provide an interface for iterating over a list
+ * that is safe and allows for modification of the list during the
+ * iteration (e.g. insertion and removal), including modification of the
+ * current node on the list.
  *
- *	There are primitives for adding and removing nodes to/from a klist. 
- *	When deleting, klist_del() will simply decrement the reference count. 
- *	Only when the count goes to 0 is the node removed from the list. 
- *	klist_remove() will try to delete the node from the list and block
- *	until it is actually removed. This is useful for objects (like devices)
- *	that have been removed from the system and must be freed (but must wait
- *	until all accessors have finished).
+ * It works using a 3rd object type - struct klist_iter - that is declared
+ * and initialized before an iteration. klist_next() is used to acquire the
+ * next element in the list. It returns NULL if there are no more items.
+ * Internally, that routine takes the klist's lock, decrements the
+ * reference count of the previous klist_node and increments the count of
+ * the next klist_node. It then drops the lock and returns.
  *
- *	Copyright (C) 2005 Patrick Mochel
- *
- *	This file is released under the GPL v2.
+ * There are primitives for adding and removing nodes to/from a klist.
+ * When deleting, klist_del() will simply decrement the reference count.
+ * Only when the count goes to 0 is the node removed from the list.
+ * klist_remove() will try to delete the node from the list and block until
+ * it is actually removed. This is useful for objects (like devices) that
+ * have been removed from the system and must be freed (but must wait until
+ * all accessors have finished).
  */
 
 #include <linux/klist.h>
@@ -40,10 +39,10 @@
 
 
 /**
- *	klist_init - Initialize a klist structure. 
- *	@k:	The klist we're initializing.
- *	@get:	The get function for the embedding object (NULL if none)
- *	@put:	The put function for the embedding object (NULL if none)
+ * klist_init - Initialize a klist structure.
+ * @k: The klist we're initializing.
+ * @get: The get function for the embedding object (NULL if none)
+ * @put: The put function for the embedding object (NULL if none)
  *
  * Initialises the klist structure.  If the klist_node structures are
  * going to be embedded in refcounted objects (necessary for safe
@@ -51,8 +50,7 @@
  * functions that take and release references on the embedding
  * objects.
  */
-
-void klist_init(struct klist * k, void (*get)(struct klist_node *),
+void klist_init(struct klist *k, void (*get)(struct klist_node *),
 		void (*put)(struct klist_node *))
 {
 	INIT_LIST_HEAD(&k->k_list);
@@ -60,26 +58,23 @@ void klist_init(struct klist * k, void (*get)(struct klist_node *),
 	k->get = get;
 	k->put = put;
 }
-
 EXPORT_SYMBOL_GPL(klist_init);
 
-
-static void add_head(struct klist * k, struct klist_node * n)
+static void add_head(struct klist *k, struct klist_node *n)
 {
 	spin_lock(&k->k_lock);
 	list_add(&n->n_node, &k->k_list);
 	spin_unlock(&k->k_lock);
 }
 
-static void add_tail(struct klist * k, struct klist_node * n)
+static void add_tail(struct klist *k, struct klist_node *n)
 {
 	spin_lock(&k->k_lock);
 	list_add_tail(&n->n_node, &k->k_list);
 	spin_unlock(&k->k_lock);
 }
 
-
-static void klist_node_init(struct klist * k, struct klist_node * n)
+static void klist_node_init(struct klist *k, struct klist_node *n)
 {
 	INIT_LIST_HEAD(&n->n_node);
 	init_completion(&n->n_removed);
@@ -89,37 +84,30 @@ static void klist_node_init(struct klist * k, struct klist_node * n)
 		k->get(n);
 }
 
-
 /**
- *	klist_add_head - Initialize a klist_node and add it to front.
- *	@n:	node we're adding.
- *	@k:	klist it's going on.
+ * klist_add_head - Initialize a klist_node and add it to front.
+ * @n: node we're adding.
+ * @k: klist it's going on.
  */
-
-void klist_add_head(struct klist_node * n, struct klist * k)
+void klist_add_head(struct klist_node *n, struct klist *k)
 {
 	klist_node_init(k, n);
 	add_head(k, n);
 }
-
 EXPORT_SYMBOL_GPL(klist_add_head);
 
-
 /**
- *	klist_add_tail - Initialize a klist_node and add it to back.
- *	@n:	node we're adding.
- *	@k:	klist it's going on.
+ * klist_add_tail - Initialize a klist_node and add it to back.
+ * @n: node we're adding.
+ * @k: klist it's going on.
  */
-
-void klist_add_tail(struct klist_node * n, struct klist * k)
+void klist_add_tail(struct klist_node *n, struct klist *k)
 {
 	klist_node_init(k, n);
 	add_tail(k, n);
 }
-
 EXPORT_SYMBOL_GPL(klist_add_tail);
 
-
 /**
  * klist_add_after - Init a klist_node and add it after an existing node
  * @n: node we're adding.
@@ -152,30 +140,27 @@ void klist_add_before(struct klist_node *n, struct klist_node *pos)
 }
 EXPORT_SYMBOL_GPL(klist_add_before);
 
-
-static void klist_release(struct kref * kref)
+static void klist_release(struct kref *kref)
 {
-	struct klist_node * n = container_of(kref, struct klist_node, n_ref);
+	struct klist_node *n = container_of(kref, struct klist_node, n_ref);
 
 	list_del(&n->n_node);
 	complete(&n->n_removed);
 	n->n_klist = NULL;
 }
 
-static int klist_dec_and_del(struct klist_node * n)
+static int klist_dec_and_del(struct klist_node *n)
 {
 	return kref_put(&n->n_ref, klist_release);
 }
 
-
 /**
- *	klist_del - Decrement the reference count of node and try to remove.
- *	@n:	node we're deleting.
+ * klist_del - Decrement the reference count of node and try to remove.
+ * @n: node we're deleting.
  */
-
-void klist_del(struct klist_node * n)
+void klist_del(struct klist_node *n)
 {
-	struct klist * k = n->n_klist;
+	struct klist *k = n->n_klist;
 	void (*put)(struct klist_node *) = k->put;
 
 	spin_lock(&k->k_lock);
@@ -185,48 +170,40 @@ void klist_del(struct klist_node * n)
 	if (put)
 		put(n);
 }
-
 EXPORT_SYMBOL_GPL(klist_del);
 
-
 /**
- *	klist_remove - Decrement the refcount of node and wait for it to go away.
- *	@n:	node we're removing.
+ * klist_remove - Decrement the refcount of node and wait for it to go away.
+ * @n: node we're removing.
  */
-
-void klist_remove(struct klist_node * n)
+void klist_remove(struct klist_node *n)
 {
 	klist_del(n);
 	wait_for_completion(&n->n_removed);
 }
-
 EXPORT_SYMBOL_GPL(klist_remove);
 
-
 /**
- *	klist_node_attached - Say whether a node is bound to a list or not.
- *	@n:	Node that we're testing.
+ * klist_node_attached - Say whether a node is bound to a list or not.
+ * @n: Node that we're testing.
  */
-
-int klist_node_attached(struct klist_node * n)
+int klist_node_attached(struct klist_node *n)
 {
 	return (n->n_klist != NULL);
 }
-
 EXPORT_SYMBOL_GPL(klist_node_attached);
 
-
 /**
- *	klist_iter_init_node - Initialize a klist_iter structure.
- *	@k:	klist we're iterating.
- *	@i:	klist_iter we're filling.
- *	@n:	node to start with.
+ * klist_iter_init_node - Initialize a klist_iter structure.
+ * @k: klist we're iterating.
+ * @i: klist_iter we're filling.
+ * @n: node to start with.
  *
- *	Similar to klist_iter_init(), but starts the action off with @n, 
- *	instead of with the list head.
+ * Similar to klist_iter_init(), but starts the action off with @n,
+ * instead of with the list head.
  */
-
-void klist_iter_init_node(struct klist * k, struct klist_iter * i, struct klist_node * n)
+void klist_iter_init_node(struct klist *k, struct klist_iter *i,
+			  struct klist_node *n)
 {
 	i->i_klist = k;
 	i->i_head = &k->k_list;
@@ -234,66 +211,56 @@ void klist_iter_init_node(struct klist * k, struct klist_iter * i, struct klist_
 	if (n)
 		kref_get(&n->n_ref);
 }
-
 EXPORT_SYMBOL_GPL(klist_iter_init_node);
 
-
 /**
- *	klist_iter_init - Iniitalize a klist_iter structure.
- *	@k:	klist we're iterating.
- *	@i:	klist_iter structure we're filling.
+ * klist_iter_init - Iniitalize a klist_iter structure.
+ * @k: klist we're iterating.
+ * @i: klist_iter structure we're filling.
  *
- *	Similar to klist_iter_init_node(), but start with the list head.
+ * Similar to klist_iter_init_node(), but start with the list head.
  */
-
-void klist_iter_init(struct klist * k, struct klist_iter * i)
+void klist_iter_init(struct klist *k, struct klist_iter *i)
 {
 	klist_iter_init_node(k, i, NULL);
 }
-
 EXPORT_SYMBOL_GPL(klist_iter_init);
 
-
 /**
- *	klist_iter_exit - Finish a list iteration.
- *	@i:	Iterator structure.
+ * klist_iter_exit - Finish a list iteration.
+ * @i: Iterator structure.
  *
- *	Must be called when done iterating over list, as it decrements the 
- *	refcount of the current node. Necessary in case iteration exited before
- *	the end of the list was reached, and always good form.
+ * Must be called when done iterating over list, as it decrements the
+ * refcount of the current node. Necessary in case iteration exited before
+ * the end of the list was reached, and always good form.
  */
-
-void klist_iter_exit(struct klist_iter * i)
+void klist_iter_exit(struct klist_iter *i)
 {
 	if (i->i_cur) {
 		klist_del(i->i_cur);
 		i->i_cur = NULL;
 	}
 }
-
 EXPORT_SYMBOL_GPL(klist_iter_exit);
 
-
-static struct klist_node * to_klist_node(struct list_head * n)
+static struct klist_node *to_klist_node(struct list_head *n)
 {
 	return container_of(n, struct klist_node, n_node);
 }
 
-
 /**
- *	klist_next - Ante up next node in list.
- *	@i:	Iterator structure.
+ * klist_next - Ante up next node in list.
+ * @i: Iterator structure.
  *
- *	First grab list lock. Decrement the reference count of the previous
- *	node, if there was one. Grab the next node, increment its reference 
- *	count, drop the lock, and return that next node.
+ * First grab list lock. Decrement the reference count of the previous
+ * node, if there was one. Grab the next node, increment its reference
+ * count, drop the lock, and return that next node.
  */
-
-struct klist_node * klist_next(struct klist_iter * i)
+struct klist_node *klist_next(struct klist_iter *i)
 {
-	struct list_head * next;
-	struct klist_node * lnode = i->i_cur;
-	struct klist_node * knode = NULL;
+	struct list_head *next;
+	struct klist_node *lnode = i->i_cur;
+	struct klist_node *knode = NULL;
 	void (*put)(struct klist_node *) = i->i_klist->put;
 
 	spin_lock(&i->i_klist->k_lock);
@@ -314,7 +281,4 @@ struct klist_node * klist_next(struct klist_iter * i)
 		put(lnode);
 	return knode;
 }
-
 EXPORT_SYMBOL_GPL(klist_next);
-
-
-- 
1.5.5.1

