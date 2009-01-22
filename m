Return-Path: <linux-kernel-owner+w=401wt.eu-S1757568AbZAVRoD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568AbZAVRoD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 12:44:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755275AbZAVRns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 12:43:48 -0500
Received: from casper.infradead.org ([85.118.1.10]:37904 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256AbZAVRnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 12:43:47 -0500
Message-Id: <20090122174052.154165291@chello.nl>
References: <20090122173701.674448070@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 22 Jan 2009 18:37:03 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC PATCH 02/19] lockdep: sanitize bit names
Content-Disposition: inline; filename=lockdep-generate.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s/\(LOCKF\?_ENABLED_[^ ]*\)S\(_READ\)\?\>/\1\2/g

So that the USED_IN and ENABLED have the same names.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/lockdep.h |   22 ++++++------
 kernel/lockdep.c        |   84 ++++++++++++++++++++++++------------------------
 kernel/lockdep_proc.c   |   12 +++---
 3 files changed, 59 insertions(+), 59 deletions(-)

Index: linux-2.6/include/linux/lockdep.h
===================================================================
--- linux-2.6.orig/include/linux/lockdep.h
+++ linux-2.6/include/linux/lockdep.h
@@ -28,14 +28,14 @@ enum lock_usage_bit
 	LOCK_USED_IN_HARDIRQ,
 	LOCK_USED_IN_SOFTIRQ,
 	LOCK_USED_IN_RECLAIM_FS,
-	LOCK_ENABLED_SOFTIRQS,
-	LOCK_ENABLED_HARDIRQS,
+	LOCK_ENABLED_SOFTIRQ,
+	LOCK_ENABLED_HARDIRQ,
 	LOCK_HELD_OVER_RECLAIM_FS,
 	LOCK_USED_IN_HARDIRQ_READ,
 	LOCK_USED_IN_SOFTIRQ_READ,
 	LOCK_USED_IN_RECLAIM_FS_READ,
-	LOCK_ENABLED_SOFTIRQS_READ,
-	LOCK_ENABLED_HARDIRQS_READ,
+	LOCK_ENABLED_SOFTIRQ_READ,
+	LOCK_ENABLED_HARDIRQ_READ,
 	LOCK_HELD_OVER_RECLAIM_FS_READ,
 	LOCK_USAGE_STATES
 };
@@ -47,22 +47,22 @@ enum lock_usage_bit
 #define LOCKF_USED_IN_HARDIRQ		(1 << LOCK_USED_IN_HARDIRQ)
 #define LOCKF_USED_IN_SOFTIRQ		(1 << LOCK_USED_IN_SOFTIRQ)
 #define LOCKF_USED_IN_RECLAIM_FS	(1 << LOCK_USED_IN_RECLAIM_FS)
-#define LOCKF_ENABLED_HARDIRQS		(1 << LOCK_ENABLED_HARDIRQS)
-#define LOCKF_ENABLED_SOFTIRQS		(1 << LOCK_ENABLED_SOFTIRQS)
+#define LOCKF_ENABLED_HARDIRQ		(1 << LOCK_ENABLED_HARDIRQ)
+#define LOCKF_ENABLED_SOFTIRQ		(1 << LOCK_ENABLED_SOFTIRQ)
 #define LOCKF_HELD_OVER_RECLAIM_FS	(1 << LOCK_HELD_OVER_RECLAIM_FS)
 
-#define LOCKF_ENABLED_IRQS (LOCKF_ENABLED_HARDIRQS | LOCKF_ENABLED_SOFTIRQS)
+#define LOCKF_ENABLED_IRQ (LOCKF_ENABLED_HARDIRQ | LOCKF_ENABLED_SOFTIRQ)
 #define LOCKF_USED_IN_IRQ (LOCKF_USED_IN_HARDIRQ | LOCKF_USED_IN_SOFTIRQ)
 
 #define LOCKF_USED_IN_HARDIRQ_READ	(1 << LOCK_USED_IN_HARDIRQ_READ)
 #define LOCKF_USED_IN_SOFTIRQ_READ	(1 << LOCK_USED_IN_SOFTIRQ_READ)
 #define LOCKF_USED_IN_RECLAIM_FS_READ	(1 << LOCK_USED_IN_RECLAIM_FS_READ)
-#define LOCKF_ENABLED_HARDIRQS_READ	(1 << LOCK_ENABLED_HARDIRQS_READ)
-#define LOCKF_ENABLED_SOFTIRQS_READ	(1 << LOCK_ENABLED_SOFTIRQS_READ)
+#define LOCKF_ENABLED_HARDIRQ_READ	(1 << LOCK_ENABLED_HARDIRQ_READ)
+#define LOCKF_ENABLED_SOFTIRQ_READ	(1 << LOCK_ENABLED_SOFTIRQ_READ)
 #define LOCKF_HELD_OVER_RECLAIM_FS_READ	(1 << LOCK_HELD_OVER_RECLAIM_FS_READ)
 
-#define LOCKF_ENABLED_IRQS_READ \
-		(LOCKF_ENABLED_HARDIRQS_READ | LOCKF_ENABLED_SOFTIRQS_READ)
+#define LOCKF_ENABLED_IRQ_READ \
+		(LOCKF_ENABLED_HARDIRQ_READ | LOCKF_ENABLED_SOFTIRQ_READ)
 #define LOCKF_USED_IN_IRQ_READ \
 		(LOCKF_USED_IN_HARDIRQ_READ | LOCKF_USED_IN_SOFTIRQ_READ)
 
Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -450,12 +450,12 @@ static const char *usage_str[] =
 	[LOCK_USED] =			"initial-use ",
 	[LOCK_USED_IN_HARDIRQ] =	"in-hardirq-W",
 	[LOCK_USED_IN_SOFTIRQ] =	"in-softirq-W",
-	[LOCK_ENABLED_SOFTIRQS] =	"softirq-on-W",
-	[LOCK_ENABLED_HARDIRQS] =	"hardirq-on-W",
+	[LOCK_ENABLED_SOFTIRQ] =	"softirq-on-W",
+	[LOCK_ENABLED_HARDIRQ] =	"hardirq-on-W",
 	[LOCK_USED_IN_HARDIRQ_READ] =	"in-hardirq-R",
 	[LOCK_USED_IN_SOFTIRQ_READ] =	"in-softirq-R",
-	[LOCK_ENABLED_SOFTIRQS_READ] =	"softirq-on-R",
-	[LOCK_ENABLED_HARDIRQS_READ] =	"hardirq-on-R",
+	[LOCK_ENABLED_SOFTIRQ_READ] =	"softirq-on-R",
+	[LOCK_ENABLED_HARDIRQ_READ] =	"hardirq-on-R",
 	[LOCK_USED_IN_RECLAIM_FS] =	"in-reclaim-W",
 	[LOCK_USED_IN_RECLAIM_FS_READ] = "in-reclaim-R",
 	[LOCK_HELD_OVER_RECLAIM_FS] =	"ov-reclaim-W",
@@ -476,28 +476,28 @@ get_usage_chars(struct lock_class *class
 	if (class->usage_mask & LOCKF_USED_IN_HARDIRQ)
 		*c1 = '+';
 	else
-		if (class->usage_mask & LOCKF_ENABLED_HARDIRQS)
+		if (class->usage_mask & LOCKF_ENABLED_HARDIRQ)
 			*c1 = '-';
 
 	if (class->usage_mask & LOCKF_USED_IN_SOFTIRQ)
 		*c2 = '+';
 	else
-		if (class->usage_mask & LOCKF_ENABLED_SOFTIRQS)
+		if (class->usage_mask & LOCKF_ENABLED_SOFTIRQ)
 			*c2 = '-';
 
-	if (class->usage_mask & LOCKF_ENABLED_HARDIRQS_READ)
+	if (class->usage_mask & LOCKF_ENABLED_HARDIRQ_READ)
 		*c3 = '-';
 	if (class->usage_mask & LOCKF_USED_IN_HARDIRQ_READ) {
 		*c3 = '+';
-		if (class->usage_mask & LOCKF_ENABLED_HARDIRQS_READ)
+		if (class->usage_mask & LOCKF_ENABLED_HARDIRQ_READ)
 			*c3 = '?';
 	}
 
-	if (class->usage_mask & LOCKF_ENABLED_SOFTIRQS_READ)
+	if (class->usage_mask & LOCKF_ENABLED_SOFTIRQ_READ)
 		*c4 = '-';
 	if (class->usage_mask & LOCKF_USED_IN_SOFTIRQ_READ) {
 		*c4 = '+';
-		if (class->usage_mask & LOCKF_ENABLED_SOFTIRQS_READ)
+		if (class->usage_mask & LOCKF_ENABLED_SOFTIRQ_READ)
 			*c4 = '?';
 	}
 
@@ -1296,7 +1296,7 @@ check_prev_add_irq(struct task_struct *c
 	 * forwards-subgraph starting at <next>:
 	 */
 	if (!check_usage(curr, prev, next, LOCK_USED_IN_HARDIRQ,
-					LOCK_ENABLED_HARDIRQS, "hard"))
+					LOCK_ENABLED_HARDIRQ, "hard"))
 		return 0;
 
 	/*
@@ -1306,7 +1306,7 @@ check_prev_add_irq(struct task_struct *c
 	 * forwards-subgraph starting at <next>:
 	 */
 	if (!check_usage(curr, prev, next, LOCK_USED_IN_HARDIRQ_READ,
-					LOCK_ENABLED_HARDIRQS, "hard-read"))
+					LOCK_ENABLED_HARDIRQ, "hard-read"))
 		return 0;
 
 	/*
@@ -1316,7 +1316,7 @@ check_prev_add_irq(struct task_struct *c
 	 * forwards-subgraph starting at <next>:
 	 */
 	if (!check_usage(curr, prev, next, LOCK_USED_IN_SOFTIRQ,
-					LOCK_ENABLED_SOFTIRQS, "soft"))
+					LOCK_ENABLED_SOFTIRQ, "soft"))
 		return 0;
 	/*
 	 * Prove that the new dependency does not connect a softirq-safe-read
@@ -1325,7 +1325,7 @@ check_prev_add_irq(struct task_struct *c
 	 * forwards-subgraph starting at <next>:
 	 */
 	if (!check_usage(curr, prev, next, LOCK_USED_IN_SOFTIRQ_READ,
-					LOCK_ENABLED_SOFTIRQS, "soft"))
+					LOCK_ENABLED_SOFTIRQ, "soft"))
 		return 0;
 
 	/*
@@ -2008,17 +2008,17 @@ static int mark_lock_irq(struct task_str
 
 	switch(new_bit) {
 	case LOCK_USED_IN_HARDIRQ:
-		if (!valid_state(curr, this, new_bit, LOCK_ENABLED_HARDIRQS))
+		if (!valid_state(curr, this, new_bit, LOCK_ENABLED_HARDIRQ))
 			return 0;
 		if (!valid_state(curr, this, new_bit,
-				 LOCK_ENABLED_HARDIRQS_READ))
+				 LOCK_ENABLED_HARDIRQ_READ))
 			return 0;
 		/*
 		 * just marked it hardirq-safe, check that this lock
 		 * took no hardirq-unsafe lock in the past:
 		 */
 		if (!check_usage_forwards(curr, this,
-					  LOCK_ENABLED_HARDIRQS, "hard"))
+					  LOCK_ENABLED_HARDIRQ, "hard"))
 			return 0;
 #if STRICT_READ_CHECKS
 		/*
@@ -2026,24 +2026,24 @@ static int mark_lock_irq(struct task_str
 		 * took no hardirq-unsafe-read lock in the past:
 		 */
 		if (!check_usage_forwards(curr, this,
-				LOCK_ENABLED_HARDIRQS_READ, "hard-read"))
+				LOCK_ENABLED_HARDIRQ_READ, "hard-read"))
 			return 0;
 #endif
 		if (hardirq_verbose(hlock_class(this)))
 			ret = 2;
 		break;
 	case LOCK_USED_IN_SOFTIRQ:
-		if (!valid_state(curr, this, new_bit, LOCK_ENABLED_SOFTIRQS))
+		if (!valid_state(curr, this, new_bit, LOCK_ENABLED_SOFTIRQ))
 			return 0;
 		if (!valid_state(curr, this, new_bit,
-				 LOCK_ENABLED_SOFTIRQS_READ))
+				 LOCK_ENABLED_SOFTIRQ_READ))
 			return 0;
 		/*
 		 * just marked it softirq-safe, check that this lock
 		 * took no softirq-unsafe lock in the past:
 		 */
 		if (!check_usage_forwards(curr, this,
-					  LOCK_ENABLED_SOFTIRQS, "soft"))
+					  LOCK_ENABLED_SOFTIRQ, "soft"))
 			return 0;
 #if STRICT_READ_CHECKS
 		/*
@@ -2051,7 +2051,7 @@ static int mark_lock_irq(struct task_str
 		 * took no softirq-unsafe-read lock in the past:
 		 */
 		if (!check_usage_forwards(curr, this,
-				LOCK_ENABLED_SOFTIRQS_READ, "soft-read"))
+				LOCK_ENABLED_SOFTIRQ_READ, "soft-read"))
 			return 0;
 #endif
 		if (softirq_verbose(hlock_class(this)))
@@ -2083,27 +2083,27 @@ static int mark_lock_irq(struct task_str
 			ret = 2;
 		break;
 	case LOCK_USED_IN_HARDIRQ_READ:
-		if (!valid_state(curr, this, new_bit, LOCK_ENABLED_HARDIRQS))
+		if (!valid_state(curr, this, new_bit, LOCK_ENABLED_HARDIRQ))
 			return 0;
 		/*
 		 * just marked it hardirq-read-safe, check that this lock
 		 * took no hardirq-unsafe lock in the past:
 		 */
 		if (!check_usage_forwards(curr, this,
-					  LOCK_ENABLED_HARDIRQS, "hard"))
+					  LOCK_ENABLED_HARDIRQ, "hard"))
 			return 0;
 		if (hardirq_verbose(hlock_class(this)))
 			ret = 2;
 		break;
 	case LOCK_USED_IN_SOFTIRQ_READ:
-		if (!valid_state(curr, this, new_bit, LOCK_ENABLED_SOFTIRQS))
+		if (!valid_state(curr, this, new_bit, LOCK_ENABLED_SOFTIRQ))
 			return 0;
 		/*
 		 * just marked it softirq-read-safe, check that this lock
 		 * took no softirq-unsafe lock in the past:
 		 */
 		if (!check_usage_forwards(curr, this,
-					  LOCK_ENABLED_SOFTIRQS, "soft"))
+					  LOCK_ENABLED_SOFTIRQ, "soft"))
 			return 0;
 		if (softirq_verbose(hlock_class(this)))
 			ret = 2;
@@ -2121,7 +2121,7 @@ static int mark_lock_irq(struct task_str
 		if (reclaim_verbose(hlock_class(this)))
 			ret = 2;
 		break;
-	case LOCK_ENABLED_HARDIRQS:
+	case LOCK_ENABLED_HARDIRQ:
 		if (!valid_state(curr, this, new_bit, LOCK_USED_IN_HARDIRQ))
 			return 0;
 		if (!valid_state(curr, this, new_bit,
@@ -2147,7 +2147,7 @@ static int mark_lock_irq(struct task_str
 		if (hardirq_verbose(hlock_class(this)))
 			ret = 2;
 		break;
-	case LOCK_ENABLED_SOFTIRQS:
+	case LOCK_ENABLED_SOFTIRQ:
 		if (!valid_state(curr, this, new_bit, LOCK_USED_IN_SOFTIRQ))
 			return 0;
 		if (!valid_state(curr, this, new_bit,
@@ -2199,7 +2199,7 @@ static int mark_lock_irq(struct task_str
 		if (reclaim_verbose(hlock_class(this)))
 			ret = 2;
 		break;
-	case LOCK_ENABLED_HARDIRQS_READ:
+	case LOCK_ENABLED_HARDIRQ_READ:
 		if (!valid_state(curr, this, new_bit, LOCK_USED_IN_HARDIRQ))
 			return 0;
 #if STRICT_READ_CHECKS
@@ -2214,7 +2214,7 @@ static int mark_lock_irq(struct task_str
 		if (hardirq_verbose(hlock_class(this)))
 			ret = 2;
 		break;
-	case LOCK_ENABLED_SOFTIRQS_READ:
+	case LOCK_ENABLED_SOFTIRQ_READ:
 		if (!valid_state(curr, this, new_bit, LOCK_USED_IN_SOFTIRQ))
 			return 0;
 #if STRICT_READ_CHECKS
@@ -2274,16 +2274,16 @@ mark_held_locks(struct task_struct *curr
 		switch (mark) {
 		case HARDIRQ:
 			if (hlock->read)
-				usage_bit = LOCK_ENABLED_HARDIRQS_READ;
+				usage_bit = LOCK_ENABLED_HARDIRQ_READ;
 			else
-				usage_bit = LOCK_ENABLED_HARDIRQS;
+				usage_bit = LOCK_ENABLED_HARDIRQ;
 			break;
 
 		case SOFTIRQ:
 			if (hlock->read)
-				usage_bit = LOCK_ENABLED_SOFTIRQS_READ;
+				usage_bit = LOCK_ENABLED_SOFTIRQ_READ;
 			else
-				usage_bit = LOCK_ENABLED_SOFTIRQS;
+				usage_bit = LOCK_ENABLED_SOFTIRQ;
 			break;
 
 		case RECLAIM_FS:
@@ -2515,19 +2515,19 @@ static int mark_irqflags(struct task_str
 	if (!hlock->hardirqs_off) {
 		if (hlock->read) {
 			if (!mark_lock(curr, hlock,
-					LOCK_ENABLED_HARDIRQS_READ))
+					LOCK_ENABLED_HARDIRQ_READ))
 				return 0;
 			if (curr->softirqs_enabled)
 				if (!mark_lock(curr, hlock,
-						LOCK_ENABLED_SOFTIRQS_READ))
+						LOCK_ENABLED_SOFTIRQ_READ))
 					return 0;
 		} else {
 			if (!mark_lock(curr, hlock,
-					LOCK_ENABLED_HARDIRQS))
+					LOCK_ENABLED_HARDIRQ))
 				return 0;
 			if (curr->softirqs_enabled)
 				if (!mark_lock(curr, hlock,
-						LOCK_ENABLED_SOFTIRQS))
+						LOCK_ENABLED_SOFTIRQ))
 					return 0;
 		}
 	}
@@ -2635,10 +2635,10 @@ static int mark_lock(struct task_struct 
 	case LOCK_USED_IN_SOFTIRQ:
 	case LOCK_USED_IN_HARDIRQ_READ:
 	case LOCK_USED_IN_SOFTIRQ_READ:
-	case LOCK_ENABLED_HARDIRQS:
-	case LOCK_ENABLED_SOFTIRQS:
-	case LOCK_ENABLED_HARDIRQS_READ:
-	case LOCK_ENABLED_SOFTIRQS_READ:
+	case LOCK_ENABLED_HARDIRQ:
+	case LOCK_ENABLED_SOFTIRQ:
+	case LOCK_ENABLED_HARDIRQ_READ:
+	case LOCK_ENABLED_SOFTIRQ_READ:
 	case LOCK_USED_IN_RECLAIM_FS:
 	case LOCK_USED_IN_RECLAIM_FS_READ:
 	case LOCK_HELD_OVER_RECLAIM_FS:
Index: linux-2.6/kernel/lockdep_proc.c
===================================================================
--- linux-2.6.orig/kernel/lockdep_proc.c
+++ linux-2.6/kernel/lockdep_proc.c
@@ -300,27 +300,27 @@ static int lockdep_stats_show(struct seq
 			nr_uncategorized++;
 		if (class->usage_mask & LOCKF_USED_IN_IRQ)
 			nr_irq_safe++;
-		if (class->usage_mask & LOCKF_ENABLED_IRQS)
+		if (class->usage_mask & LOCKF_ENABLED_IRQ)
 			nr_irq_unsafe++;
 		if (class->usage_mask & LOCKF_USED_IN_SOFTIRQ)
 			nr_softirq_safe++;
-		if (class->usage_mask & LOCKF_ENABLED_SOFTIRQS)
+		if (class->usage_mask & LOCKF_ENABLED_SOFTIRQ)
 			nr_softirq_unsafe++;
 		if (class->usage_mask & LOCKF_USED_IN_HARDIRQ)
 			nr_hardirq_safe++;
-		if (class->usage_mask & LOCKF_ENABLED_HARDIRQS)
+		if (class->usage_mask & LOCKF_ENABLED_HARDIRQ)
 			nr_hardirq_unsafe++;
 		if (class->usage_mask & LOCKF_USED_IN_IRQ_READ)
 			nr_irq_read_safe++;
-		if (class->usage_mask & LOCKF_ENABLED_IRQS_READ)
+		if (class->usage_mask & LOCKF_ENABLED_IRQ_READ)
 			nr_irq_read_unsafe++;
 		if (class->usage_mask & LOCKF_USED_IN_SOFTIRQ_READ)
 			nr_softirq_read_safe++;
-		if (class->usage_mask & LOCKF_ENABLED_SOFTIRQS_READ)
+		if (class->usage_mask & LOCKF_ENABLED_SOFTIRQ_READ)
 			nr_softirq_read_unsafe++;
 		if (class->usage_mask & LOCKF_USED_IN_HARDIRQ_READ)
 			nr_hardirq_read_safe++;
-		if (class->usage_mask & LOCKF_ENABLED_HARDIRQS_READ)
+		if (class->usage_mask & LOCKF_ENABLED_HARDIRQ_READ)
 			nr_hardirq_read_unsafe++;
 
 #ifdef CONFIG_PROVE_LOCKING

-- 

