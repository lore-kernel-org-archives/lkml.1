Return-Path: <linux-kernel-owner+w=401wt.eu-S1759406AbXIMBBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759406AbXIMBBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 21:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbXIMBBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 21:01:44 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:44940 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477AbXIMBBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 21:01:44 -0400
Date: Wed, 12 Sep 2007 18:01:40 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH] State limits to safety of _safe iterators
Message-ID: <20070913010140.GA21306@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The _safe list iterators make a blanket statement about how they are
safe against removal.  This patch, inspired by private conversations
with people who unwisely but perhaps understandably took this blanket
statement at its word, adds comments stating limits to this safety.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 list.h |   42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff -urpNa -X dontdiff linux-2.6.22/include/linux/list.h linux-2.6.22-safedoc/include/linux/list.h
--- linux-2.6.22/include/linux/list.h	2007-07-08 16:32:17.000000000 -0700
+++ linux-2.6.22-safedoc/include/linux/list.h	2007-09-12 17:45:38.000000000 -0700
@@ -472,6 +472,12 @@ static inline void list_splice_init_rcu(
  * @pos:	the &struct list_head to use as a loop cursor.
  * @n:		another &struct list_head to use as temporary storage
  * @head:	the head for your list.
+ *
+ * Please note that this is safe only against removal by the code in
+ * this iterator's body (either directly or via function calls).  In
+ * particular, it is not safe against removal by other tasks unless
+ * you use appropriate locking, RCU, or other synchronization
+ * mechanism.
  */
 #define list_for_each_safe(pos, n, head) \
 	for (pos = (head)->next, n = pos->next; pos != (head); \
@@ -542,6 +548,12 @@ static inline void list_splice_init_rcu(
  * @n:		another type * to use as temporary storage
  * @head:	the head for your list.
  * @member:	the name of the list_struct within the struct.
+ *
+ * Please note that this is safe only against removal by the code in
+ * this iterator's body (either directly or via function calls).  In
+ * particular, it is not safe against removal by other tasks unless
+ * you use appropriate locking, RCU, or other synchronization
+ * mechanism.
  */
 #define list_for_each_entry_safe(pos, n, head, member)			\
 	for (pos = list_entry((head)->next, typeof(*pos), member),	\
@@ -558,6 +570,12 @@ static inline void list_splice_init_rcu(
  *
  * Iterate over list of given type, continuing after current point,
  * safe against removal of list entry.
+ *
+ * Please note that this is safe only against removal by the code in
+ * this iterator's body (either directly or via function calls).  In
+ * particular, it is not safe against removal by other tasks unless
+ * you use appropriate locking, RCU, or other synchronization
+ * mechanism.
  */
 #define list_for_each_entry_safe_continue(pos, n, head, member) 		\
 	for (pos = list_entry(pos->member.next, typeof(*pos), member), 		\
@@ -574,6 +592,12 @@ static inline void list_splice_init_rcu(
  *
  * Iterate over list of given type from current point, safe against
  * removal of list entry.
+ *
+ * Please note that this is safe only against removal by the code in
+ * this iterator's body (either directly or via function calls).  In
+ * particular, it is not safe against removal by other tasks unless
+ * you use appropriate locking, RCU, or other synchronization
+ * mechanism.
  */
 #define list_for_each_entry_safe_from(pos, n, head, member) 			\
 	for (n = list_entry(pos->member.next, typeof(*pos), member);		\
@@ -589,6 +613,12 @@ static inline void list_splice_init_rcu(
  *
  * Iterate backwards over list of given type, safe against removal
  * of list entry.
+ *
+ * Please note that this is safe only against removal by the code in
+ * this iterator's body (either directly or via function calls).  In
+ * particular, it is not safe against removal by other tasks unless
+ * you use appropriate locking, RCU, or other synchronization
+ * mechanism.
  */
 #define list_for_each_entry_safe_reverse(pos, n, head, member)		\
 	for (pos = list_entry((head)->prev, typeof(*pos), member),	\
@@ -623,6 +653,12 @@ static inline void list_splice_init_rcu(
  *
  * Iterate over an rcu-protected list, safe against removal of list entry.
  *
+ * Please note that this is safe only against removal by the code in
+ * this iterator's body (either directly or via function calls).  In
+ * particular, it is not safe against removal by other tasks unless
+ * you use appropriate locking, RCU, or other synchronization
+ * mechanism.
+ *
  * This list-traversal primitive may safely run concurrently with
  * the _rcu list-mutation primitives such as list_add_rcu()
  * as long as the traversal is guarded by rcu_read_lock().
@@ -942,6 +978,12 @@ static inline void hlist_add_after_rcu(s
  * @n:		another &struct hlist_node to use as temporary storage
  * @head:	the head for your list.
  * @member:	the name of the hlist_node within the struct.
+ *
+ * Please note that this is safe only against removal by the code in
+ * this iterator's body (either directly or via function calls).  In
+ * particular, it is not safe against removal by other tasks unless
+ * you use appropriate locking, RCU, or other synchronization
+ * mechanism.
  */
 #define hlist_for_each_entry_safe(tpos, pos, n, head, member) 		 \
 	for (pos = (head)->first;					 \
