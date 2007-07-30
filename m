Return-Path: <linux-kernel-owner+w=401wt.eu-S966459AbXG3Cse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966459AbXG3Cse (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 22:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966074AbXG3Cr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 22:47:28 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:41609 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S936573AbXG3CrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 22:47:22 -0400
Message-Id: <20070730024720.357083990@mvista.com>
References: <20070730024534.369897977@mvista.com>
User-Agent: quilt/0.46-1
Date: Sun, 29 Jul 2007 19:45:40 -0700
From: Daniel Walker <dwalker@mvista.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Content-Disposition: inline; filename=locking-cleanup.patch
Subject: [PATCH -rt 6/9] spinlock/rt_lock random cleanups
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Walker <dwalker@mvista.com>

---
 include/linux/rt_lock.h  |    6 ++++--
 include/linux/spinlock.h |    5 +++--
 2 files changed, 7 insertions(+), 4 deletions(-)

Index: linux-2.6.22/include/linux/rt_lock.h
===================================================================
--- linux-2.6.22.orig/include/linux/rt_lock.h
+++ linux-2.6.22/include/linux/rt_lock.h
@@ -128,12 +128,14 @@ struct semaphore name = \
  */
 #define DECLARE_MUTEX_LOCKED COMPAT_DECLARE_MUTEX_LOCKED
 
-extern void fastcall __sema_init(struct semaphore *sem, int val, char *name, char *file, int line);
+extern void fastcall
+__sema_init(struct semaphore *sem, int val, char *name, char *file, int line);
 
 #define rt_sema_init(sem, val) \
 		__sema_init(sem, val, #sem, __FILE__, __LINE__)
 
-extern void fastcall __init_MUTEX(struct semaphore *sem, char *name, char *file, int line);
+extern void fastcall
+__init_MUTEX(struct semaphore *sem, char *name, char *file, int line);
 #define rt_init_MUTEX(sem) \
 		__init_MUTEX(sem, #sem, __FILE__, __LINE__)
 
Index: linux-2.6.22/include/linux/spinlock.h
===================================================================
--- linux-2.6.22.orig/include/linux/spinlock.h
+++ linux-2.6.22/include/linux/spinlock.h
@@ -126,7 +126,7 @@ extern int __lockfunc generic__raw_read_
 
 #ifdef CONFIG_DEBUG_SPINLOCK
  extern __lockfunc void _raw_spin_lock(raw_spinlock_t *lock);
-#define _raw_spin_lock_flags(lock, flags) _raw_spin_lock(lock)
+# define _raw_spin_lock_flags(lock, flags) _raw_spin_lock(lock)
  extern __lockfunc int _raw_spin_trylock(raw_spinlock_t *lock);
  extern __lockfunc void _raw_spin_unlock(raw_spinlock_t *lock);
  extern __lockfunc void _raw_read_lock(raw_rwlock_t *lock);
@@ -325,7 +325,8 @@ do {							\
 
 # define _read_trylock(rwl)	rt_read_trylock(rwl)
 # define _write_trylock(rwl)	rt_write_trylock(rwl)
-#define _write_trylock_irqsave(rwl, flags)  rt_write_trylock_irqsave(rwl, flags)
+# define _write_trylock_irqsave(rwl, flags) \
+	rt_write_trylock_irqsave(rwl, flags)
 
 # define _read_lock(rwl)	rt_read_lock(rwl)
 # define _write_lock(rwl)	rt_write_lock(rwl)

-- 
