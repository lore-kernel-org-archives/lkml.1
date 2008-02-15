Return-Path: <linux-kernel-owner+w=401wt.eu-S1760995AbYBOSA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760995AbYBOSA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 13:00:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760172AbYBOR6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 12:58:45 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:58483 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760021AbYBOR6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 12:58:43 -0500
Date: Fri, 15 Feb 2008 21:02:00 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] kill double_spin_lock()
Message-ID: <20080215180200.GA4353@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

double_spin_lock() has no callers, and it can't be used without additional
lockdep annotations, remove it.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 25/include/linux/spinlock.h~4_DSL	2008-02-15 16:59:17.000000000 +0300
+++ 25/include/linux/spinlock.h	2008-02-15 19:52:20.000000000 +0300
@@ -296,43 +296,6 @@ do {						\
 })
 
 /*
- * Locks two spinlocks l1 and l2.
- * l1_first indicates if spinlock l1 should be taken first.
- */
-static inline void double_spin_lock(spinlock_t *l1, spinlock_t *l2,
-				    bool l1_first)
-	__acquires(l1)
-	__acquires(l2)
-{
-	if (l1_first) {
-		spin_lock(l1);
-		spin_lock(l2);
-	} else {
-		spin_lock(l2);
-		spin_lock(l1);
-	}
-}
-
-/*
- * Unlocks two spinlocks l1 and l2.
- * l1_taken_first indicates if spinlock l1 was taken first and therefore
- * should be released after spinlock l2.
- */
-static inline void double_spin_unlock(spinlock_t *l1, spinlock_t *l2,
-				      bool l1_taken_first)
-	__releases(l1)
-	__releases(l2)
-{
-	if (l1_taken_first) {
-		spin_unlock(l2);
-		spin_unlock(l1);
-	} else {
-		spin_unlock(l1);
-		spin_unlock(l2);
-	}
-}
-
-/*
  * Pull the atomic_t declaration:
  * (asm-mips/atomic.h needs above definitions)
  */

