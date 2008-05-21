Return-Path: <linux-kernel-owner+w=401wt.eu-S1762810AbYEUF7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762810AbYEUF7B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 01:59:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755084AbYEUF6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 01:58:51 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:23429 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059AbYEUF6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 01:58:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=suEFz99u7btUJf0AY92LTzjrkUgxrfa+OBqQp16jDlv4AhPeCqSbRYXs3mTBZ0VZ147Wrp5vcz8qiQfgS9Ojh6+q/GN8a50NATI9FBHmU8npLjgt/lYJkvoap2UikLtogFXimGeqmLe2w8mNijD/6jL5JmIaSFpsRnlvs3w6qCI=
From: Jianjun Kong <kongjianjun@gmail.com>
To: torvalds@linux-foundation.org
Cc: xiyou.wangcong@gmail.com, linux-kernel@vger.kernel.org,
       Jianjun Kong <kongjianjun@gmail.com>
Subject: [PATCH] Standard indentation of arguments
Date: Wed, 21 May 2008 13:58:48 +0800
Message-Id: <12113495282137-git-send-email-kongjianjun@gmail.com>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: 0002-Standard-indentation-of-arguments.patch
References: 0002-Standard-indentation-of-arguments.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Standard indentation of arguments.
I use right blank space to displace the last table, in order to make the arguments alining. For example:

old:
extern void test_fun(struct list_head *new,
			struct list_head *prev,
			struct list_head *next);
new:
extern void test_fun(struct list_head *new,
		     struct list_head *prev,
		     struct list_head *next);

Signed-off-by: Jianjun Kong <kongjianjun@gmail.com>
---
 include/linux/list.h |   27 ++++++++++++++-------------
 1 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/include/linux/list.h b/include/linux/list.h
index 08cf4f6..6d16696 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -49,8 +49,8 @@ static inline void __list_add(struct list_head *new,
 }
 #else
 extern void __list_add(struct list_head *new,
-			      struct list_head *prev,
-			      struct list_head *next);
+		       struct list_head *prev,
+		       struct list_head *next);
 #endif
 
 /**
@@ -91,7 +91,8 @@ static inline void list_add_tail(struct list_head *new, struct list_head *head)
  * the prev/next entries already!
  */
 static inline void __list_add_rcu(struct list_head * new,
-		struct list_head * prev, struct list_head * next)
+				  struct list_head * prev,
+				  struct list_head * next)
 {
 	new->next = next;
 	new->prev = prev;
@@ -138,7 +139,7 @@ static inline void list_add_rcu(struct list_head *new, struct list_head *head)
  * list_for_each_entry_rcu().
  */
 static inline void list_add_tail_rcu(struct list_head *new,
-					struct list_head *head)
+				     struct list_head *head)
 {
 	__list_add_rcu(new, head->prev, head);
 }
@@ -220,7 +221,7 @@ static inline void list_replace(struct list_head *old,
 }
 
 static inline void list_replace_init(struct list_head *old,
-					struct list_head *new)
+				     struct list_head *new)
 {
 	list_replace(old, new);
 	INIT_LIST_HEAD(old);
@@ -235,7 +236,7 @@ static inline void list_replace_init(struct list_head *old,
  * Note: @old should not be empty.
  */
 static inline void list_replace_rcu(struct list_head *old,
-				struct list_head *new)
+				    struct list_head *new)
 {
 	new->next = old->next;
 	new->prev = old->prev;
@@ -284,7 +285,7 @@ static inline void list_move_tail(struct list_head *list,
  * @head: the head of the list
  */
 static inline int list_is_last(const struct list_head *list,
-				const struct list_head *head)
+			       const struct list_head *head)
 {
 	return list->next == head;
 }
@@ -346,7 +347,7 @@ static inline void __list_splice(const struct list_head *list,
  * @head: the place to add it in the first list.
  */
 static inline void list_splice(const struct list_head *list,
-				struct list_head *head)
+			       struct list_head *head)
 {
 	if (!list_empty(list))
 		__list_splice(list, head);
@@ -696,7 +697,7 @@ struct hlist_node {
 };
 
 #define HLIST_HEAD_INIT { .first = NULL }
-#define HLIST_HEAD(name) struct hlist_head name = {  .first = NULL }
+#define HLIST_HEAD(name) struct hlist_head name = { .first = NULL }
 #define INIT_HLIST_HEAD(ptr) ((ptr)->first = NULL)
 static inline void INIT_HLIST_NODE(struct hlist_node *h)
 {
@@ -771,7 +772,7 @@ static inline void hlist_del_init(struct hlist_node *n)
  * The @old entry will be replaced with the @new entry atomically.
  */
 static inline void hlist_replace_rcu(struct hlist_node *old,
-					struct hlist_node *new)
+				     struct hlist_node *new)
 {
 	struct hlist_node *next = old->next;
 
@@ -815,7 +816,7 @@ static inline void hlist_add_head(struct hlist_node *n, struct hlist_head *h)
  * list-traversal primitive must be guarded by rcu_read_lock().
  */
 static inline void hlist_add_head_rcu(struct hlist_node *n,
-					struct hlist_head *h)
+				      struct hlist_head *h)
 {
 	struct hlist_node *first = h->first;
 	n->next = first;
@@ -828,7 +829,7 @@ static inline void hlist_add_head_rcu(struct hlist_node *n,
 
 /* next must be != NULL */
 static inline void hlist_add_before(struct hlist_node *n,
-					struct hlist_node *next)
+				    struct hlist_node *next)
 {
 	n->pprev = next->pprev;
 	n->next = next;
@@ -837,7 +838,7 @@ static inline void hlist_add_before(struct hlist_node *n,
 }
 
 static inline void hlist_add_after(struct hlist_node *n,
-					struct hlist_node *next)
+				   struct hlist_node *next)
 {
 	next->next = n->next;
 	n->next = next;
-- 
1.5.2.5

