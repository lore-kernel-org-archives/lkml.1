Return-Path: <linux-kernel-owner+w=401wt.eu-S1754532AbXLSRkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbXLSRkU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 12:40:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbXLSRkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 12:40:05 -0500
Received: from fk-out-0910.google.com ([209.85.128.185]:26555 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbXLSRkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 12:40:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=fotzgFh6PmZNrCEQDrKaqhyVosxcDzJyHpT0tQ7+UdgYzULTsSp71GovT1cIl3L64D1KdOzfah2Fjp/ckIE8Y5AknEjsX57wU01tXCfh/SYj/CMsGPhg3u5bgXtKpwUMis0MEB5sTwv+QdEjrABD5pkkZzqeTykVeNm02pgGK78=
Date: Wed, 19 Dec 2007 20:39:49 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] lockdep: tiny code cleanup according to checkpatch
Message-ID: <20071219173949.GC7413@cvg.cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes a tiny code cleanup over lockdep.c
according to checkpatch. Nothing serious - space
cleanup, noninline keyword moved in between of
storage class and type.

Signed-Off-By: Cyrill Gorcunov <gorcunov@gmail.com>
---

 kernel/lockdep.c |   23 +++++++++--------------
 1 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 723bd9f..397bfd0 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -274,14 +274,12 @@ void lockdep_off(void)
 {
 	current->lockdep_recursion++;
 }
-
 EXPORT_SYMBOL(lockdep_off);
 
 void lockdep_on(void)
 {
 	current->lockdep_recursion--;
 }
-
 EXPORT_SYMBOL(lockdep_on);
 
 /*
@@ -427,7 +425,7 @@ static const char *usage_str[] =
 	[LOCK_ENABLED_HARDIRQS_READ] =	"hardirq-on-R",
 };
 
-const char * __get_key_name(struct lockdep_subclass_key *key, char *str)
+const char *__get_key_name(struct lockdep_subclass_key *key, char *str)
 {
 	return kallsyms_lookup((unsigned long)key, NULL, NULL, NULL, str);
 }
@@ -543,7 +541,7 @@ static void print_lock_class_header(struct lock_class *class, int depth)
 	}
 	printk("%*s }\n", depth, "");
 
-	printk("%*s ... key      at: ",depth,"");
+	printk("%*s ... key      at: ", depth, "");
 	print_ip_sym((unsigned long)class->key);
 }
 
@@ -565,7 +563,7 @@ static void print_lock_dependencies(struct lock_class *class, int depth)
 
 		print_lock_dependencies(entry->class, depth + 1);
 
-		printk("%*s ... acquired at:\n",depth,"");
+		printk("%*s ... acquired at:\n", depth, "");
 		print_stack_trace(&entry->trace, 2);
 		printk("\n");
 	}
@@ -724,7 +722,7 @@ register_lock_class(struct lockdep_map *lock, unsigned int subclass, int force)
 
 	/*
 	 * Debug-check: all keys must be persistent!
- 	 */
+	 */
 	if (!static_obj(lock->key)) {
 		debug_locks_off();
 		printk("INFO: trying to register non-static key.\n");
@@ -941,7 +939,7 @@ static noinline int print_circular_bug_tail(void)
 
 #define RECURSION_LIMIT 40
 
-static int noinline print_infinite_recursion_bug(void)
+static noinline int print_infinite_recursion_bug(void)
 {
 	if (!debug_locks_off_graph_unlock())
 		return 0;
@@ -1575,7 +1573,7 @@ static int validate_chain(struct task_struct *curr, struct lockdep_map *lock,
 }
 #else
 static inline int validate_chain(struct task_struct *curr,
-	       	struct lockdep_map *lock, struct held_lock *hlock,
+		struct lockdep_map *lock, struct held_lock *hlock,
 		int chain_head, u64 chain_key)
 {
 	return 1;
@@ -1792,7 +1790,7 @@ static int mark_lock_irq(struct task_struct *curr, struct held_lock *this,
 {
 	int ret = 1;
 
-	switch(new_bit) {
+	switch (new_bit) {
 	case LOCK_USED_IN_HARDIRQ:
 		if (!valid_state(curr, this, new_bit, LOCK_ENABLED_HARDIRQS))
 			return 0;
@@ -2051,7 +2049,6 @@ void trace_hardirqs_on(void)
 	curr->hardirq_enable_event = ++curr->irq_events;
 	debug_atomic_inc(&hardirqs_on_events);
 }
-
 EXPORT_SYMBOL(trace_hardirqs_on);
 
 /*
@@ -2340,7 +2337,6 @@ void lockdep_init_map(struct lockdep_map *lock, const char *name,
 	if (subclass)
 		register_lock_class(lock, subclass, 1);
 }
-
 EXPORT_SYMBOL_GPL(lockdep_init_map);
 
 /*
@@ -2705,7 +2701,6 @@ void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	current->lockdep_recursion = 0;
 	raw_local_irq_restore(flags);
 }
-
 EXPORT_SYMBOL_GPL(lock_acquire);
 
 void lock_release(struct lockdep_map *lock, int nested, unsigned long ip)
@@ -3080,8 +3075,8 @@ print_freed_lock_bug(struct task_struct *curr, const void *mem_from,
 	dump_stack();
 }
 
-static inline int not_in_range(const void* mem_from, unsigned long mem_len,
-				const void* lock_from, unsigned long lock_len)
+static inline int not_in_range(const void *mem_from, unsigned long mem_len,
+				const void *lock_from, unsigned long lock_len)
 {
 	return lock_from + lock_len <= mem_from ||
 		mem_from + mem_len <= lock_from;
