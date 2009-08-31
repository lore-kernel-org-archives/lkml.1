Return-Path: <linux-kernel-owner+w=401wt.eu-S1752421AbZHaRII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbZHaRII (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 13:08:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751695AbZHaRIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 13:08:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:32877 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731AbZHaRID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 13:08:03 -0400
Date: Mon, 31 Aug 2009 17:07:15 GMT
From: tip-bot for Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: mingo@redhat.com, torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       schwidefsky@de.ibm.com, ehrhardt@linux.vnet.ibm.com, arnd@arndb.de,
       akpm@linux-foundation.org, heiko.carstens@de.ibm.com,
       zippel@linux-m68k.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       hpa@zytor.com, paulus@samba.org, horsth@linux.vnet.ibm.com,
       davem@davemloft.net, benh@kernel.crashing.org, geert@linux-m68k.org,
       linux-arch@vger.kernel.org, mingo@elte.hu, nickpiggin@yahoo.com.au
Reply-To: mingo@redhat.com, a.p.zijlstra@chello.nl,
       torvalds@linux-foundation.org, schwidefsky@de.ibm.com,
       ehrhardt@linux.vnet.ibm.com, arnd@arndb.de, akpm@linux-foundation.org,
       heiko.carstens@de.ibm.com, tglx@linutronix.de, zippel@linux-m68k.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, paulus@samba.org,
       horsth@linux.vnet.ibm.com, davem@davemloft.net,
       benh@kernel.crashing.org, geert@linux-m68k.org,
       linux-arch@vger.kernel.org, nickpiggin@yahoo.com.au, mingo@elte.hu
In-Reply-To: <20090831124416.306495811@de.ibm.com>
References: <20090831124416.306495811@de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] locking, sparc: Rename __spin_try_lock() and friends
Message-ID: <tip-9f34ceb60357a7166c929d7b52bd057ad7ffc54b@git.kernel.org>
Git-Commit-ID: 9f34ceb60357a7166c929d7b52bd057ad7ffc54b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 31 Aug 2009 17:07:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9f34ceb60357a7166c929d7b52bd057ad7ffc54b
Gitweb:     http://git.kernel.org/tip/9f34ceb60357a7166c929d7b52bd057ad7ffc54b
Author:     Heiko Carstens <heiko.carstens@de.ibm.com>
AuthorDate: Mon, 31 Aug 2009 14:43:32 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 31 Aug 2009 18:08:48 +0200

locking, sparc: Rename __spin_try_lock() and friends

Needed to avoid namespace conflicts when the common code
function bodies of _spin_try_lock() etc. are moved to a header
file where the function name would be __spin_try_lock().

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Horst Hartmann <horsth@linux.vnet.ibm.com>
Cc: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: <linux-arch@vger.kernel.org>
LKML-Reference: <20090831124416.306495811@de.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/sparc/include/asm/spinlock_32.h |   12 ++++++------
 arch/sparc/include/asm/spinlock_64.h |   28 ++++++++++++++--------------
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/sparc/include/asm/spinlock_32.h b/arch/sparc/include/asm/spinlock_32.h
index 46f91ab..857630c 100644
--- a/arch/sparc/include/asm/spinlock_32.h
+++ b/arch/sparc/include/asm/spinlock_32.h
@@ -76,7 +76,7 @@ static inline void __raw_spin_unlock(raw_spinlock_t *lock)
  *
  * Unfortunately this scheme limits us to ~16,000,000 cpus.
  */
-static inline void __read_lock(raw_rwlock_t *rw)
+static inline void arch_read_lock(raw_rwlock_t *rw)
 {
 	register raw_rwlock_t *lp asm("g1");
 	lp = rw;
@@ -92,11 +92,11 @@ static inline void __read_lock(raw_rwlock_t *rw)
 #define __raw_read_lock(lock) \
 do {	unsigned long flags; \
 	local_irq_save(flags); \
-	__read_lock(lock); \
+	arch_read_lock(lock); \
 	local_irq_restore(flags); \
 } while(0)
 
-static inline void __read_unlock(raw_rwlock_t *rw)
+static inline void arch_read_unlock(raw_rwlock_t *rw)
 {
 	register raw_rwlock_t *lp asm("g1");
 	lp = rw;
@@ -112,7 +112,7 @@ static inline void __read_unlock(raw_rwlock_t *rw)
 #define __raw_read_unlock(lock) \
 do {	unsigned long flags; \
 	local_irq_save(flags); \
-	__read_unlock(lock); \
+	arch_read_unlock(lock); \
 	local_irq_restore(flags); \
 } while(0)
 
@@ -150,7 +150,7 @@ static inline int __raw_write_trylock(raw_rwlock_t *rw)
 	return (val == 0);
 }
 
-static inline int __read_trylock(raw_rwlock_t *rw)
+static inline int arch_read_trylock(raw_rwlock_t *rw)
 {
 	register raw_rwlock_t *lp asm("g1");
 	register int res asm("o0");
@@ -169,7 +169,7 @@ static inline int __read_trylock(raw_rwlock_t *rw)
 ({	unsigned long flags; \
 	int res; \
 	local_irq_save(flags); \
-	res = __read_trylock(lock); \
+	res = arch_read_trylock(lock); \
 	local_irq_restore(flags); \
 	res; \
 })
diff --git a/arch/sparc/include/asm/spinlock_64.h b/arch/sparc/include/asm/spinlock_64.h
index f6b2b92..43e5147 100644
--- a/arch/sparc/include/asm/spinlock_64.h
+++ b/arch/sparc/include/asm/spinlock_64.h
@@ -92,7 +92,7 @@ static inline void __raw_spin_lock_flags(raw_spinlock_t *lock, unsigned long fla
 
 /* Multi-reader locks, these are much saner than the 32-bit Sparc ones... */
 
-static void inline __read_lock(raw_rwlock_t *lock)
+static void inline arch_read_lock(raw_rwlock_t *lock)
 {
 	unsigned long tmp1, tmp2;
 
@@ -115,7 +115,7 @@ static void inline __read_lock(raw_rwlock_t *lock)
 	: "memory");
 }
 
-static int inline __read_trylock(raw_rwlock_t *lock)
+static int inline arch_read_trylock(raw_rwlock_t *lock)
 {
 	int tmp1, tmp2;
 
@@ -136,7 +136,7 @@ static int inline __read_trylock(raw_rwlock_t *lock)
 	return tmp1;
 }
 
-static void inline __read_unlock(raw_rwlock_t *lock)
+static void inline arch_read_unlock(raw_rwlock_t *lock)
 {
 	unsigned long tmp1, tmp2;
 
@@ -152,7 +152,7 @@ static void inline __read_unlock(raw_rwlock_t *lock)
 	: "memory");
 }
 
-static void inline __write_lock(raw_rwlock_t *lock)
+static void inline arch_write_lock(raw_rwlock_t *lock)
 {
 	unsigned long mask, tmp1, tmp2;
 
@@ -177,7 +177,7 @@ static void inline __write_lock(raw_rwlock_t *lock)
 	: "memory");
 }
 
-static void inline __write_unlock(raw_rwlock_t *lock)
+static void inline arch_write_unlock(raw_rwlock_t *lock)
 {
 	__asm__ __volatile__(
 "	stw		%%g0, [%0]"
@@ -186,7 +186,7 @@ static void inline __write_unlock(raw_rwlock_t *lock)
 	: "memory");
 }
 
-static int inline __write_trylock(raw_rwlock_t *lock)
+static int inline arch_write_trylock(raw_rwlock_t *lock)
 {
 	unsigned long mask, tmp1, tmp2, result;
 
@@ -210,14 +210,14 @@ static int inline __write_trylock(raw_rwlock_t *lock)
 	return result;
 }
 
-#define __raw_read_lock(p)	__read_lock(p)
-#define __raw_read_lock_flags(p, f) __read_lock(p)
-#define __raw_read_trylock(p)	__read_trylock(p)
-#define __raw_read_unlock(p)	__read_unlock(p)
-#define __raw_write_lock(p)	__write_lock(p)
-#define __raw_write_lock_flags(p, f) __write_lock(p)
-#define __raw_write_unlock(p)	__write_unlock(p)
-#define __raw_write_trylock(p)	__write_trylock(p)
+#define __raw_read_lock(p)	arch_read_lock(p)
+#define __raw_read_lock_flags(p, f) arch_read_lock(p)
+#define __raw_read_trylock(p)	arch_read_trylock(p)
+#define __raw_read_unlock(p)	arch_read_unlock(p)
+#define __raw_write_lock(p)	arch_write_lock(p)
+#define __raw_write_lock_flags(p, f) arch_write_lock(p)
+#define __raw_write_unlock(p)	arch_write_unlock(p)
+#define __raw_write_trylock(p)	arch_write_trylock(p)
 
 #define __raw_read_can_lock(rw)		(!((rw)->lock & 0x80000000UL))
 #define __raw_write_can_lock(rw)	(!(rw)->lock)
