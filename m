Return-Path: <linux-kernel-owner+w=401wt.eu-S933273AbZKFWmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933273AbZKFWmo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:42:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933169AbZKFWml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:42:41 -0500
Received: from www.tglx.de ([62.245.132.106]:54130 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933248AbZKFWmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:42:39 -0500
Message-Id: <20091106223807.053291797@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 06 Nov 2009 22:42:23 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 16/16] locking: Remove old style lock initializers
References: <20091106223547.784916750@linutronix.de>
Content-Disposition: inline;
	filename=locking-remove-oldstyle-lock-initializers.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SPIN_LOCK_UNLOCKED and RW_LOCK_UNLOCKED have been deprecated for
years. Now the last users are gone. Remove the cruft.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/spinlock.h       |    4 ++--
 include/linux/spinlock_types.h |    9 ---------
 2 files changed, 2 insertions(+), 11 deletions(-)

Index: linux-2.6/include/linux/spinlock.h
===================================================================
--- linux-2.6.orig/include/linux/spinlock.h
+++ linux-2.6/include/linux/spinlock.h
@@ -102,7 +102,7 @@ do {								\
 
 #else
 # define spin_lock_init(lock)					\
-	do { *(lock) = SPIN_LOCK_UNLOCKED; } while (0)
+	do { *(lock) = __SPIN_LOCK_UNLOCKED(lock); } while (0)
 #endif
 
 #ifdef CONFIG_DEBUG_SPINLOCK
@@ -116,7 +116,7 @@ do {								\
 } while (0)
 #else
 # define rwlock_init(lock)					\
-	do { *(lock) = RW_LOCK_UNLOCKED; } while (0)
+	do { *(lock) = __RW_LOCK_UNLOCKED(lock); } while (0)
 #endif
 
 #define spin_is_locked(lock)	__raw_spin_is_locked(&(lock)->raw_lock)
Index: linux-2.6/include/linux/spinlock_types.h
===================================================================
--- linux-2.6.orig/include/linux/spinlock_types.h
+++ linux-2.6/include/linux/spinlock_types.h
@@ -85,15 +85,6 @@ typedef struct {
 				RW_DEP_MAP_INIT(lockname) }
 #endif
 
-/*
- * SPIN_LOCK_UNLOCKED and RW_LOCK_UNLOCKED defeat lockdep state tracking and
- * are hence deprecated.
- * Please use DEFINE_SPINLOCK()/DEFINE_RWLOCK() or
- * __SPIN_LOCK_UNLOCKED()/__RW_LOCK_UNLOCKED() as appropriate.
- */
-#define SPIN_LOCK_UNLOCKED	__SPIN_LOCK_UNLOCKED(old_style_spin_init)
-#define RW_LOCK_UNLOCKED	__RW_LOCK_UNLOCKED(old_style_rw_init)
-
 #define DEFINE_SPINLOCK(x)	spinlock_t x = __SPIN_LOCK_UNLOCKED(x)
 #define DEFINE_RWLOCK(x)	rwlock_t x = __RW_LOCK_UNLOCKED(x)
 


