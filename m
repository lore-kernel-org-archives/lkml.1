Return-Path: <linux-kernel-owner+w=401wt.eu-S1030528AbXDLAgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030528AbXDLAgy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 20:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753729AbXDLAgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 20:36:54 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:20406 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724AbXDLAgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 20:36:53 -0400
Date: Wed, 11 Apr 2007 17:39:13 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: inaky.perez-gonzalez@intel.com, dwalker@mvista.com, tglx@linutronix.de,
       oleg@tv-sign.ru, akpm <akpm@linux-foundation.org>
Subject: [PATCH] kernel-doc: fix plist.h comments
Message-Id: <20070411173913.3a758a46.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Make kernel-doc comments match macro names.
Correct parameter names in a few places.
Remove '#' from beginning of kernel-doc comment macro names.
Remove extra (erroneous) blank lines in kernel-doc.

Warning(plist.h:100): Cannot understand  * #PLIST_HEAD_INIT - static struct plist_head initializer on line 100 - I thought it was a doc line
Warning(plist.h:112): Cannot understand  * #PLIST_NODE_INIT - static struct plist_node initializer on line 112 - I thought it was a doc line
Warning(plist.h:103): No description found for parameter '_lock'
Warning(plist.h:129): No description found for parameter 'lock'
Warning(plist.h:158): No description found for parameter 'pos'
Warning(plist.h:169): No description found for parameter 'pos'
Warning(plist.h:169): No description found for parameter 'n'
Warning(plist.h:179): No description found for parameter 'mem'

This still leaves one warning & one error that need attention:
Error(plist.h:219): cannot understand prototype: '('
Warning(plist.h): no structured comments found

cc: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
cc: Daniel Walker <dwalker@mvista.com>
cc: Thomas Gleixner <tglx@linutronix.de>
cc: Oleg Nesterov <oleg@tv-sign.ru>

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/linux/plist.h |   54 +++++++++++++++++++++-----------------------------
 1 file changed, 23 insertions(+), 31 deletions(-)

--- linux-2621-rc6.orig/include/linux/plist.h
+++ linux-2621-rc6/include/linux/plist.h
@@ -97,9 +97,9 @@ struct plist_node {
 #endif
 
 /**
- * #PLIST_HEAD_INIT - static struct plist_head initializer
- *
+ * PLIST_HEAD_INIT - static struct plist_head initializer
  * @head:	struct plist_head variable name
+ * @_lock:	lock to initialize for this list
  */
 #define PLIST_HEAD_INIT(head, _lock)			\
 {							\
@@ -109,8 +109,7 @@ struct plist_node {
 }
 
 /**
- * #PLIST_NODE_INIT - static struct plist_node initializer
- *
+ * PLIST_NODE_INIT - static struct plist_node initializer
  * @node:	struct plist_node variable name
  * @__prio:	initial node priority
  */
@@ -122,8 +121,8 @@ struct plist_node {
 
 /**
  * plist_head_init - dynamic struct plist_head initializer
- *
  * @head:	&struct plist_head pointer
+ * @lock:	list spinlock, remembered for debugging
  */
 static inline void
 plist_head_init(struct plist_head *head, spinlock_t *lock)
@@ -137,7 +136,6 @@ plist_head_init(struct plist_head *head,
 
 /**
  * plist_node_init - Dynamic struct plist_node initializer
- *
  * @node:	&struct plist_node pointer
  * @prio:	initial node priority
  */
@@ -152,49 +150,46 @@ extern void plist_del(struct plist_node 
 
 /**
  * plist_for_each - iterate over the plist
- *
- * @pos1:	the type * to use as a loop counter.
- * @head:	the head for your list.
+ * @pos:	the type * to use as a loop counter
+ * @head:	the head for your list
  */
 #define plist_for_each(pos, head)	\
 	 list_for_each_entry(pos, &(head)->node_list, plist.node_list)
 
 /**
- * plist_for_each_entry_safe - iterate over a plist of given type safe
- * against removal of list entry
+ * plist_for_each_safe - iterate safely over a plist of given type
+ * @pos:	the type * to use as a loop counter
+ * @n:	another type * to use as temporary storage
+ * @head:	the head for your list
  *
- * @pos1:	the type * to use as a loop counter.
- * @n1:	another type * to use as temporary storage
- * @head:	the head for your list.
+ * Iterate over a plist of given type, safe against removal of list entry.
  */
 #define plist_for_each_safe(pos, n, head)	\
 	 list_for_each_entry_safe(pos, n, &(head)->node_list, plist.node_list)
 
 /**
  * plist_for_each_entry	- iterate over list of given type
- *
- * @pos:	the type * to use as a loop counter.
- * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
+ * @pos:	the type * to use as a loop counter
+ * @head:	the head for your list
+ * @mem:	the name of the list_struct within the struct
  */
 #define plist_for_each_entry(pos, head, mem)	\
 	 list_for_each_entry(pos, &(head)->node_list, mem.plist.node_list)
 
 /**
- * plist_for_each_entry_safe - iterate over list of given type safe against
- * removal of list entry
- *
- * @pos:	the type * to use as a loop counter.
+ * plist_for_each_entry_safe - iterate safely over list of given type
+ * @pos:	the type * to use as a loop counter
  * @n:		another type * to use as temporary storage
- * @head:	the head for your list.
- * @m:		the name of the list_struct within the struct.
+ * @head:	the head for your list
+ * @m:		the name of the list_struct within the struct
+ *
+ * Iterate over list of given type, safe against removal of list entry.
  */
 #define plist_for_each_entry_safe(pos, n, head, m)	\
 	list_for_each_entry_safe(pos, n, &(head)->node_list, m.plist.node_list)
 
 /**
  * plist_head_empty - return !0 if a plist_head is empty
- *
  * @head:	&struct plist_head pointer
  */
 static inline int plist_head_empty(const struct plist_head *head)
@@ -204,7 +199,6 @@ static inline int plist_head_empty(const
 
 /**
  * plist_node_empty - return !0 if plist_node is not on a list
- *
  * @node:	&struct plist_node pointer
  */
 static inline int plist_node_empty(const struct plist_node *node)
@@ -216,10 +210,9 @@ static inline int plist_node_empty(const
 
 /**
  * plist_first_entry - get the struct for the first entry
- *
- * @ptr:	the &struct plist_head pointer.
- * @type:	the type of the struct this is embedded in.
- * @member:	the name of the list_struct within the struct.
+ * @head:	the &struct plist_head pointer
+ * @type:	the type of the struct this is embedded in
+ * @member:	the name of the list_struct within the struct
  */
 #ifdef CONFIG_DEBUG_PI_LIST
 # define plist_first_entry(head, type, member)	\
@@ -234,7 +227,6 @@ static inline int plist_node_empty(const
 
 /**
  * plist_first - return the first node (and thus, highest priority)
- *
  * @head:	the &struct plist_head pointer
  *
  * Assumes the plist is _not_ empty.
