Return-Path: <linux-kernel-owner+w=401wt.eu-S1756353AbYHGMez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353AbYHGMez (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758620AbYHGMed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:34:33 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:26464 "EHLO
	viefep13-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754041AbYHGMec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:34:32 -0400
Subject: Re: [RFC][PATCH 7/7] lockdep: spin_lock_nest_lock()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, jeremy@goop.org, hugh@veritas.com,
       mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       davej@redhat.com
In-Reply-To: <20080804131012.246115111@chello.nl>
References: <20080804130317.994042639@chello.nl>
	 <20080804131012.246115111@chello.nl>
Content-Type: text/plain
Date: Thu, 07 Aug 2008 13:25:45 +0200
Message-Id: <1218108345.8625.23.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please fold (or tell me to provide a new patch)


Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
diff -u linux-2.6/include/linux/spinlock.h linux-2.6/include/linux/spinlock.h
--- linux-2.6/include/linux/spinlock.h
+++ linux-2.6/include/linux/spinlock.h
@@ -185,8 +185,8 @@
 # define spin_lock_nested(lock, subclass) _spin_lock_nested(lock, subclass)
 # define spin_lock_nest_lock(lock, nest_lock)				\
 	 do {								\
-		 typecheck(struct lockdep_map *, &nest_lock->dep_map);	\
-		 _spin_lock_nest_lock(lock, &nest_lock->dep_map);	\
+		 typecheck(struct lockdep_map *, &(nest_lock)->dep_map);\
+		 _spin_lock_nest_lock(lock, &(nest_lock)->dep_map);	\
 	 } while (0)
 #else
 # define spin_lock_nested(lock, subclass) _spin_lock(lock)
diff -u linux-2.6/kernel/spinlock.c linux-2.6/kernel/spinlock.c
--- linux-2.6/kernel/spinlock.c
+++ linux-2.6/kernel/spinlock.c
@@ -323,7 +323,7 @@
 	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
 }
 
-EXPORT_SYMBOL(_spin_lock_nest_lock)
+EXPORT_SYMBOL(_spin_lock_nest_lock);
 
 #endif
 
--- linux-2.6.orig/include/linux/spinlock_api_smp.h
+++ linux-2.6/include/linux/spinlock_api_smp.h
@@ -22,6 +22,8 @@ int in_lock_functions(unsigned long addr
 void __lockfunc _spin_lock(spinlock_t *lock)		__acquires(lock);
 void __lockfunc _spin_lock_nested(spinlock_t *lock, int subclass)
 							__acquires(lock);
+void __lockfunc _spin_lock_nest_lock(spinlock_t *lock, struct lockdep_map *map)
+							__acquires(lock);
 void __lockfunc _read_lock(rwlock_t *lock)		__acquires(lock);
 void __lockfunc _write_lock(rwlock_t *lock)		__acquires(lock);
 void __lockfunc _spin_lock_bh(spinlock_t *lock)		__acquires(lock);





