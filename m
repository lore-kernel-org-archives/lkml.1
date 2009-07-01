Return-Path: <linux-kernel-owner+w=401wt.eu-S1753832AbZGAUlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbZGAUlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 16:41:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbZGAUkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 16:40:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:44726 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755156AbZGAUkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 16:40:49 -0400
Date: Wed, 1 Jul 2009 20:40:08 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, peterz@infradead.org, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, efault@gmx.de,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090701174608.GA5823@ghostprotocols.net>
References: <20090701174608.GA5823@ghostprotocols.net>
Subject: [tip:perfcounters/urgent] perf_counter tools: Share list.h with the kernel
Message-ID: <tip-5da50258584469ddfee6545feb4eb2252a8d7e7b@git.kernel.org>
Git-Commit-ID: 5da50258584469ddfee6545feb4eb2252a8d7e7b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Jul 2009 20:40:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5da50258584469ddfee6545feb4eb2252a8d7e7b
Gitweb:     http://git.kernel.org/tip/5da50258584469ddfee6545feb4eb2252a8d7e7b
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 1 Jul 2009 14:46:08 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 1 Jul 2009 22:37:23 +0200

perf_counter tools: Share list.h with the kernel

The copy we were using came from another copy I did for the dwarves
(pahole) package, that came from the kernel years ago.

The only function that is used by the perf tools and that isn't in the
kernel is list_del_range, that I'm leaving in the perf tools only for
now.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20090701174608.GA5823@ghostprotocols.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/Makefile                      |    3 +-
 tools/perf/builtin-annotate.c            |    2 +-
 tools/perf/builtin-report.c              |    2 +-
 tools/perf/util/callchain.h              |    2 +-
 tools/perf/util/include/asm/system.h     |    1 +
 tools/perf/util/include/linux/list.h     |   18 +
 tools/perf/util/include/linux/poison.h   |    1 +
 tools/perf/util/include/linux/prefetch.h |    6 +
 tools/perf/util/list.h                   |  603 ------------------------------
 tools/perf/util/symbol.h                 |    2 +-
 10 files changed, 32 insertions(+), 608 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index c4f4882..8f7fd1b 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -290,9 +290,10 @@ LIB_FILE=libperf.a
 
 LIB_H += ../../include/linux/perf_counter.h
 LIB_H += ../../include/linux/rbtree.h
+LIB_H += ../../include/linux/list.h
+LIB_H += util/include/linux/list.h
 LIB_H += perf.h
 LIB_H += util/types.h
-LIB_H += util/list.h
 LIB_H += util/levenshtein.h
 LIB_H += util/parse-options.h
 LIB_H += util/parse-events.h
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 1960c22..132de8b 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -10,7 +10,7 @@
 #include "util/util.h"
 
 #include "util/color.h"
-#include "util/list.h"
+#include <linux/list.h>
 #include "util/cache.h"
 #include <linux/rbtree.h>
 #include "util/symbol.h"
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 0d35e2b..be1b758 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -10,7 +10,7 @@
 #include "util/util.h"
 
 #include "util/color.h"
-#include "util/list.h"
+#include <linux/list.h>
 #include "util/cache.h"
 #include <linux/rbtree.h>
 #include "util/symbol.h"
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 0606b8f..e9bd5e8 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -2,7 +2,7 @@
 #define __PERF_CALLCHAIN_H
 
 #include "../perf.h"
-#include "list.h"
+#include <linux/list.h>
 #include <linux/rbtree.h>
 #include "symbol.h"
 
diff --git a/tools/perf/util/include/asm/system.h b/tools/perf/util/include/asm/system.h
new file mode 100644
index 0000000..710cecc
--- /dev/null
+++ b/tools/perf/util/include/asm/system.h
@@ -0,0 +1 @@
+/* Empty */
diff --git a/tools/perf/util/include/linux/list.h b/tools/perf/util/include/linux/list.h
new file mode 100644
index 0000000..dbe4b81
--- /dev/null
+++ b/tools/perf/util/include/linux/list.h
@@ -0,0 +1,18 @@
+#include "../../../../include/linux/list.h"
+
+#ifndef PERF_LIST_H
+#define PERF_LIST_H
+/**
+ * list_del_range - deletes range of entries from list.
+ * @begin: first element in the range to delete from the list.
+ * @end: last element in the range to delete from the list.
+ * Note: list_empty on the range of entries does not return true after this,
+ * the entries is in an undefined state.
+ */
+static inline void list_del_range(struct list_head *begin,
+				  struct list_head *end)
+{
+	begin->prev->next = end->next;
+	end->next->prev = begin->prev;
+}
+#endif
diff --git a/tools/perf/util/include/linux/poison.h b/tools/perf/util/include/linux/poison.h
new file mode 100644
index 0000000..fef6dbc
--- /dev/null
+++ b/tools/perf/util/include/linux/poison.h
@@ -0,0 +1 @@
+#include "../../../../include/linux/poison.h"
diff --git a/tools/perf/util/include/linux/prefetch.h b/tools/perf/util/include/linux/prefetch.h
new file mode 100644
index 0000000..7841e48
--- /dev/null
+++ b/tools/perf/util/include/linux/prefetch.h
@@ -0,0 +1,6 @@
+#ifndef PERF_LINUX_PREFETCH_H
+#define PERF_LINUX_PREFETCH_H
+
+static inline void prefetch(void *a __attribute__((unused))) { }
+
+#endif
diff --git a/tools/perf/util/list.h b/tools/perf/util/list.h
deleted file mode 100644
index e2548e8..0000000
--- a/tools/perf/util/list.h
+++ /dev/null
@@ -1,603 +0,0 @@
-#ifndef _LINUX_LIST_H
-#define _LINUX_LIST_H
-/*
-  Copyright (C) Cast of dozens, comes from the Linux kernel
-
-  This program is free software; you can redistribute it and/or modify it
-  under the terms of version 2 of the GNU General Public License as
-  published by the Free Software Foundation.
-*/
-
-#include <stddef.h>
-
-/*
- * These are non-NULL pointers that will result in page faults
- * under normal circumstances, used to verify that nobody uses
- * non-initialized list entries.
- */
-#define LIST_POISON1 ((void *)0x00100100)
-#define LIST_POISON2 ((void *)0x00200200)
-
-/**
- * container_of - cast a member of a structure out to the containing structure
- * @ptr:	the pointer to the member.
- * @type:	the type of the container struct this is embedded in.
- * @member:	the name of the member within the struct.
- *
- */
-#define container_of(ptr, type, member) ({			\
-        const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
-        (type *)( (char *)__mptr - offsetof(type,member) );})
-
-/*
- * Simple doubly linked list implementation.
- *
- * Some of the internal functions ("__xxx") are useful when
- * manipulating whole lists rather than single entries, as
- * sometimes we already know the next/prev entries and we can
- * generate better code by using them directly rather than
- * using the generic single-entry routines.
- */
-
-struct list_head {
-	struct list_head *next, *prev;
-};
-
-#define LIST_HEAD_INIT(name) { &(name), &(name) }
-
-#define LIST_HEAD(name) \
-	struct list_head name = LIST_HEAD_INIT(name)
-
-static inline void INIT_LIST_HEAD(struct list_head *list)
-{
-	list->next = list;
-	list->prev = list;
-}
-
-/*
- * Insert a new entry between two known consecutive entries.
- *
- * This is only for internal list manipulation where we know
- * the prev/next entries already!
- */
-static inline void __list_add(struct list_head *new,
-			      struct list_head *prev,
-			      struct list_head *next)
-{
-	next->prev = new;
-	new->next = next;
-	new->prev = prev;
-	prev->next = new;
-}
-
-/**
- * list_add - add a new entry
- * @new: new entry to be added
- * @head: list head to add it after
- *
- * Insert a new entry after the specified head.
- * This is good for implementing stacks.
- */
-static inline void list_add(struct list_head *new, struct list_head *head)
-{
-	__list_add(new, head, head->next);
-}
-
-/**
- * list_add_tail - add a new entry
- * @new: new entry to be added
- * @head: list head to add it before
- *
- * Insert a new entry before the specified head.
- * This is useful for implementing queues.
- */
-static inline void list_add_tail(struct list_head *new, struct list_head *head)
-{
-	__list_add(new, head->prev, head);
-}
-
-/*
- * Delete a list entry by making the prev/next entries
- * point to each other.
- *
- * This is only for internal list manipulation where we know
- * the prev/next entries already!
- */
-static inline void __list_del(struct list_head * prev, struct list_head * next)
-{
-	next->prev = prev;
-	prev->next = next;
-}
-
-/**
- * list_del - deletes entry from list.
- * @entry: the element to delete from the list.
- * Note: list_empty on entry does not return true after this, the entry is
- * in an undefined state.
- */
-static inline void list_del(struct list_head *entry)
-{
-	__list_del(entry->prev, entry->next);
-	entry->next = LIST_POISON1;
-	entry->prev = LIST_POISON2;
-}
-
-/**
- * list_del_range - deletes range of entries from list.
- * @beging: first element in the range to delete from the list.
- * @beging: first element in the range to delete from the list.
- * Note: list_empty on the range of entries does not return true after this,
- * the entries is in an undefined state.
- */
-static inline void list_del_range(struct list_head *begin,
-				  struct list_head *end)
-{
-	begin->prev->next = end->next;
-	end->next->prev = begin->prev;
-}
-
-/**
- * list_replace - replace old entry by new one
- * @old : the element to be replaced
- * @new : the new element to insert
- * Note: if 'old' was empty, it will be overwritten.
- */
-static inline void list_replace(struct list_head *old,
-				struct list_head *new)
-{
-	new->next = old->next;
-	new->next->prev = new;
-	new->prev = old->prev;
-	new->prev->next = new;
-}
-
-static inline void list_replace_init(struct list_head *old,
-					struct list_head *new)
-{
-	list_replace(old, new);
-	INIT_LIST_HEAD(old);
-}
-
-/**
- * list_del_init - deletes entry from list and reinitialize it.
- * @entry: the element to delete from the list.
- */
-static inline void list_del_init(struct list_head *entry)
-{
-	__list_del(entry->prev, entry->next);
-	INIT_LIST_HEAD(entry);
-}
-
-/**
- * list_move - delete from one list and add as another's head
- * @list: the entry to move
- * @head: the head that will precede our entry
- */
-static inline void list_move(struct list_head *list, struct list_head *head)
-{
-        __list_del(list->prev, list->next);
-        list_add(list, head);
-}
-
-/**
- * list_move_tail - delete from one list and add as another's tail
- * @list: the entry to move
- * @head: the head that will follow our entry
- */
-static inline void list_move_tail(struct list_head *list,
-				  struct list_head *head)
-{
-        __list_del(list->prev, list->next);
-        list_add_tail(list, head);
-}
-
-/**
- * list_is_last - tests whether @list is the last entry in list @head
- * @list: the entry to test
- * @head: the head of the list
- */
-static inline int list_is_last(const struct list_head *list,
-				const struct list_head *head)
-{
-	return list->next == head;
-}
-
-/**
- * list_empty - tests whether a list is empty
- * @head: the list to test.
- */
-static inline int list_empty(const struct list_head *head)
-{
-	return head->next == head;
-}
-
-/**
- * list_empty_careful - tests whether a list is empty and not being modified
- * @head: the list to test
- *
- * Description:
- * tests whether a list is empty _and_ checks that no other CPU might be
- * in the process of modifying either member (next or prev)
- *
- * NOTE: using list_empty_careful() without synchronization
- * can only be safe if the only activity that can happen
- * to the list entry is list_del_init(). Eg. it cannot be used
- * if another CPU could re-list_add() it.
- */
-static inline int list_empty_careful(const struct list_head *head)
-{
-	struct list_head *next = head->next;
-	return (next == head) && (next == head->prev);
-}
-
-static inline void __list_splice(struct list_head *list,
-				 struct list_head *head)
-{
-	struct list_head *first = list->next;
-	struct list_head *last = list->prev;
-	struct list_head *at = head->next;
-
-	first->prev = head;
-	head->next = first;
-
-	last->next = at;
-	at->prev = last;
-}
-
-/**
- * list_splice - join two lists
- * @list: the new list to add.
- * @head: the place to add it in the first list.
- */
-static inline void list_splice(struct list_head *list, struct list_head *head)
-{
-	if (!list_empty(list))
-		__list_splice(list, head);
-}
-
-/**
- * list_splice_init - join two lists and reinitialise the emptied list.
- * @list: the new list to add.
- * @head: the place to add it in the first list.
- *
- * The list at @list is reinitialised
- */
-static inline void list_splice_init(struct list_head *list,
-				    struct list_head *head)
-{
-	if (!list_empty(list)) {
-		__list_splice(list, head);
-		INIT_LIST_HEAD(list);
-	}
-}
-
-/**
- * list_entry - get the struct for this entry
- * @ptr:	the &struct list_head pointer.
- * @type:	the type of the struct this is embedded in.
- * @member:	the name of the list_struct within the struct.
- */
-#define list_entry(ptr, type, member) \
-	container_of(ptr, type, member)
-
-/**
- * list_first_entry - get the first element from a list
- * @ptr:       the list head to take the element from.
- * @type:      the type of the struct this is embedded in.
- * @member:    the name of the list_struct within the struct.
- *
- * Note, that list is expected to be not empty.
- */
-#define list_first_entry(ptr, type, member) \
-	list_entry((ptr)->next, type, member)
-
-/**
- * list_for_each	-	iterate over a list
- * @pos:	the &struct list_head to use as a loop cursor.
- * @head:	the head for your list.
- */
-#define list_for_each(pos, head) \
-	for (pos = (head)->next; pos != (head); \
-        	pos = pos->next)
-
-/**
- * __list_for_each	-	iterate over a list
- * @pos:	the &struct list_head to use as a loop cursor.
- * @head:	the head for your list.
- *
- * This variant differs from list_for_each() in that it's the
- * simplest possible list iteration code, no prefetching is done.
- * Use this for code that knows the list to be very short (empty
- * or 1 entry) most of the time.
- */
-#define __list_for_each(pos, head) \
-	for (pos = (head)->next; pos != (head); pos = pos->next)
-
-/**
- * list_for_each_prev	-	iterate over a list backwards
- * @pos:	the &struct list_head to use as a loop cursor.
- * @head:	the head for your list.
- */
-#define list_for_each_prev(pos, head) \
-	for (pos = (head)->prev; pos != (head); \
-        	pos = pos->prev)
-
-/**
- * list_for_each_safe - iterate over a list safe against removal of list entry
- * @pos:	the &struct list_head to use as a loop cursor.
- * @n:		another &struct list_head to use as temporary storage
- * @head:	the head for your list.
- */
-#define list_for_each_safe(pos, n, head) \
-	for (pos = (head)->next, n = pos->next; pos != (head); \
-		pos = n, n = pos->next)
-
-/**
- * list_for_each_entry	-	iterate over list of given type
- * @pos:	the type * to use as a loop cursor.
- * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
- */
-#define list_for_each_entry(pos, head, member)				\
-	for (pos = list_entry((head)->next, typeof(*pos), member);	\
-	     &pos->member != (head); 	\
-	     pos = list_entry(pos->member.next, typeof(*pos), member))
-
-/**
- * list_for_each_entry_reverse - iterate backwards over list of given type.
- * @pos:	the type * to use as a loop cursor.
- * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
- */
-#define list_for_each_entry_reverse(pos, head, member)			\
-	for (pos = list_entry((head)->prev, typeof(*pos), member);	\
-	     &pos->member != (head); 	\
-	     pos = list_entry(pos->member.prev, typeof(*pos), member))
-
-/**
- * list_prepare_entry - prepare a pos entry for use in list_for_each_entry_continue
- * @pos:	the type * to use as a start point
- * @head:	the head of the list
- * @member:	the name of the list_struct within the struct.
- *
- * Prepares a pos entry for use as a start point in list_for_each_entry_continue.
- */
-#define list_prepare_entry(pos, head, member) \
-	((pos) ? : list_entry(head, typeof(*pos), member))
-
-/**
- * list_for_each_entry_continue - continue iteration over list of given type
- * @pos:	the type * to use as a loop cursor.
- * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
- *
- * Continue to iterate over list of given type, continuing after
- * the current position.
- */
-#define list_for_each_entry_continue(pos, head, member) 		\
-	for (pos = list_entry(pos->member.next, typeof(*pos), member);	\
-	     &pos->member != (head);	\
-	     pos = list_entry(pos->member.next, typeof(*pos), member))
-
-/**
- * list_for_each_entry_from - iterate over list of given type from the current point
- * @pos:	the type * to use as a loop cursor.
- * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
- *
- * Iterate over list of given type, continuing from current position.
- */
-#define list_for_each_entry_from(pos, head, member) 			\
-	for (; &pos->member != (head);	\
-	     pos = list_entry(pos->member.next, typeof(*pos), member))
-
-/**
- * list_for_each_entry_safe - iterate over list of given type safe against removal of list entry
- * @pos:	the type * to use as a loop cursor.
- * @n:		another type * to use as temporary storage
- * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
- */
-#define list_for_each_entry_safe(pos, n, head, member)			\
-	for (pos = list_entry((head)->next, typeof(*pos), member),	\
-		n = list_entry(pos->member.next, typeof(*pos), member);	\
-	     &pos->member != (head); 					\
-	     pos = n, n = list_entry(n->member.next, typeof(*n), member))
-
-/**
- * list_for_each_entry_safe_continue
- * @pos:	the type * to use as a loop cursor.
- * @n:		another type * to use as temporary storage
- * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
- *
- * Iterate over list of given type, continuing after current point,
- * safe against removal of list entry.
- */
-#define list_for_each_entry_safe_continue(pos, n, head, member) 		\
-	for (pos = list_entry(pos->member.next, typeof(*pos), member), 		\
-		n = list_entry(pos->member.next, typeof(*pos), member);		\
-	     &pos->member != (head);						\
-	     pos = n, n = list_entry(n->member.next, typeof(*n), member))
-
-/**
- * list_for_each_entry_safe_from
- * @pos:	the type * to use as a loop cursor.
- * @n:		another type * to use as temporary storage
- * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
- *
- * Iterate over list of given type from current point, safe against
- * removal of list entry.
- */
-#define list_for_each_entry_safe_from(pos, n, head, member) 			\
-	for (n = list_entry(pos->member.next, typeof(*pos), member);		\
-	     &pos->member != (head);						\
-	     pos = n, n = list_entry(n->member.next, typeof(*n), member))
-
-/**
- * list_for_each_entry_safe_reverse
- * @pos:	the type * to use as a loop cursor.
- * @n:		another type * to use as temporary storage
- * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
- *
- * Iterate backwards over list of given type, safe against removal
- * of list entry.
- */
-#define list_for_each_entry_safe_reverse(pos, n, head, member)		\
-	for (pos = list_entry((head)->prev, typeof(*pos), member),	\
-		n = list_entry(pos->member.prev, typeof(*pos), member);	\
-	     &pos->member != (head); 					\
-	     pos = n, n = list_entry(n->member.prev, typeof(*n), member))
-
-/*
- * Double linked lists with a single pointer list head.
- * Mostly useful for hash tables where the two pointer list head is
- * too wasteful.
- * You lose the ability to access the tail in O(1).
- */
-
-struct hlist_head {
-	struct hlist_node *first;
-};
-
-struct hlist_node {
-	struct hlist_node *next, **pprev;
-};
-
-#define HLIST_HEAD_INIT { .first = NULL }
-#define HLIST_HEAD(name) struct hlist_head name = {  .first = NULL }
-#define INIT_HLIST_HEAD(ptr) ((ptr)->first = NULL)
-static inline void INIT_HLIST_NODE(struct hlist_node *h)
-{
-	h->next = NULL;
-	h->pprev = NULL;
-}
-
-static inline int hlist_unhashed(const struct hlist_node *h)
-{
-	return !h->pprev;
-}
-
-static inline int hlist_empty(const struct hlist_head *h)
-{
-	return !h->first;
-}
-
-static inline void __hlist_del(struct hlist_node *n)
-{
-	struct hlist_node *next = n->next;
-	struct hlist_node **pprev = n->pprev;
-	*pprev = next;
-	if (next)
-		next->pprev = pprev;
-}
-
-static inline void hlist_del(struct hlist_node *n)
-{
-	__hlist_del(n);
-	n->next = LIST_POISON1;
-	n->pprev = LIST_POISON2;
-}
-
-static inline void hlist_del_init(struct hlist_node *n)
-{
-	if (!hlist_unhashed(n)) {
-		__hlist_del(n);
-		INIT_HLIST_NODE(n);
-	}
-}
-
-static inline void hlist_add_head(struct hlist_node *n, struct hlist_head *h)
-{
-	struct hlist_node *first = h->first;
-	n->next = first;
-	if (first)
-		first->pprev = &n->next;
-	h->first = n;
-	n->pprev = &h->first;
-}
-
-/* next must be != NULL */
-static inline void hlist_add_before(struct hlist_node *n,
-					struct hlist_node *next)
-{
-	n->pprev = next->pprev;
-	n->next = next;
-	next->pprev = &n->next;
-	*(n->pprev) = n;
-}
-
-static inline void hlist_add_after(struct hlist_node *n,
-					struct hlist_node *next)
-{
-	next->next = n->next;
-	n->next = next;
-	next->pprev = &n->next;
-
-	if(next->next)
-		next->next->pprev  = &next->next;
-}
-
-#define hlist_entry(ptr, type, member) container_of(ptr,type,member)
-
-#define hlist_for_each(pos, head) \
-	for (pos = (head)->first; pos; \
-	     pos = pos->next)
-
-#define hlist_for_each_safe(pos, n, head) \
-	for (pos = (head)->first; pos && ({ n = pos->next; 1; }); \
-	     pos = n)
-
-/**
- * hlist_for_each_entry	- iterate over list of given type
- * @tpos:	the type * to use as a loop cursor.
- * @pos:	the &struct hlist_node to use as a loop cursor.
- * @head:	the head for your list.
- * @member:	the name of the hlist_node within the struct.
- */
-#define hlist_for_each_entry(tpos, pos, head, member)			 \
-	for (pos = (head)->first;					 \
-	     pos && 			 \
-		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
-	     pos = pos->next)
-
-/**
- * hlist_for_each_entry_continue - iterate over a hlist continuing after current point
- * @tpos:	the type * to use as a loop cursor.
- * @pos:	the &struct hlist_node to use as a loop cursor.
- * @member:	the name of the hlist_node within the struct.
- */
-#define hlist_for_each_entry_continue(tpos, pos, member)		 \
-	for (pos = (pos)->next;						 \
-	     pos && 			 \
-		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
-	     pos = pos->next)
-
-/**
- * hlist_for_each_entry_from - iterate over a hlist continuing from current point
- * @tpos:	the type * to use as a loop cursor.
- * @pos:	the &struct hlist_node to use as a loop cursor.
- * @member:	the name of the hlist_node within the struct.
- */
-#define hlist_for_each_entry_from(tpos, pos, member)			 \
-	for (; pos && 			 \
-		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
-	     pos = pos->next)
-
-/**
- * hlist_for_each_entry_safe - iterate over list of given type safe against removal of list entry
- * @tpos:	the type * to use as a loop cursor.
- * @pos:	the &struct hlist_node to use as a loop cursor.
- * @n:		another &struct hlist_node to use as temporary storage
- * @head:	the head for your list.
- * @member:	the name of the hlist_node within the struct.
- */
-#define hlist_for_each_entry_safe(tpos, pos, n, head, member) 		 \
-	for (pos = (head)->first;					 \
-	     pos && ({ n = pos->next; 1; }) && 				 \
-		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
-	     pos = n)
-
-#endif
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 3a275db..65a8449 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -3,7 +3,7 @@
 
 #include <linux/types.h>
 #include "types.h"
-#include "list.h"
+#include <linux/list.h>
 #include <linux/rbtree.h>
 
 struct symbol {
