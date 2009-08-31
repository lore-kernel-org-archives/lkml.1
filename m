Return-Path: <linux-kernel-owner+w=401wt.eu-S1752185AbZHaRIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbZHaRIF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 13:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755AbZHaRIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 13:08:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:32875 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073AbZHaRIC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 13:08:02 -0400
Date: Mon, 31 Aug 2009 17:07:00 GMT
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
In-Reply-To: <20090831124415.918799705@de.ibm.com>
References: <20090831124415.918799705@de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] locking, powerpc: Rename __spin_try_lock() and friends
Message-ID: <tip-8307a98097222f4d9c2e62ebccd6f5df439328de@git.kernel.org>
Git-Commit-ID: 8307a98097222f4d9c2e62ebccd6f5df439328de
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 31 Aug 2009 17:07:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8307a98097222f4d9c2e62ebccd6f5df439328de
Gitweb:     http://git.kernel.org/tip/8307a98097222f4d9c2e62ebccd6f5df439328de
Author:     Heiko Carstens <heiko.carstens@de.ibm.com>
AuthorDate: Mon, 31 Aug 2009 14:43:31 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 31 Aug 2009 18:08:48 +0200

locking, powerpc: Rename __spin_try_lock() and friends

Needed to avoid namespace conflicts when the common code
function bodies of _spin_try_lock() etc. are moved to a header
file where the function name would be __spin_try_lock().

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
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
LKML-Reference: <20090831124415.918799705@de.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/powerpc/include/asm/spinlock.h |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/include/asm/spinlock.h b/arch/powerpc/include/asm/spinlock.h
index c3b1931..198266c 100644
--- a/arch/powerpc/include/asm/spinlock.h
+++ b/arch/powerpc/include/asm/spinlock.h
@@ -54,7 +54,7 @@
  * This returns the old value in the lock, so we succeeded
  * in getting the lock if the return value is 0.
  */
-static inline unsigned long __spin_trylock(raw_spinlock_t *lock)
+static inline unsigned long arch_spin_trylock(raw_spinlock_t *lock)
 {
 	unsigned long tmp, token;
 
@@ -76,7 +76,7 @@ static inline unsigned long __spin_trylock(raw_spinlock_t *lock)
 static inline int __raw_spin_trylock(raw_spinlock_t *lock)
 {
 	CLEAR_IO_SYNC;
-	return __spin_trylock(lock) == 0;
+	return arch_spin_trylock(lock) == 0;
 }
 
 /*
@@ -108,7 +108,7 @@ static inline void __raw_spin_lock(raw_spinlock_t *lock)
 {
 	CLEAR_IO_SYNC;
 	while (1) {
-		if (likely(__spin_trylock(lock) == 0))
+		if (likely(arch_spin_trylock(lock) == 0))
 			break;
 		do {
 			HMT_low();
@@ -126,7 +126,7 @@ void __raw_spin_lock_flags(raw_spinlock_t *lock, unsigned long flags)
 
 	CLEAR_IO_SYNC;
 	while (1) {
-		if (likely(__spin_trylock(lock) == 0))
+		if (likely(arch_spin_trylock(lock) == 0))
 			break;
 		local_save_flags(flags_dis);
 		local_irq_restore(flags);
@@ -181,7 +181,7 @@ extern void __raw_spin_unlock_wait(raw_spinlock_t *lock);
  * This returns the old value in the lock + 1,
  * so we got a read lock if the return value is > 0.
  */
-static inline long __read_trylock(raw_rwlock_t *rw)
+static inline long arch_read_trylock(raw_rwlock_t *rw)
 {
 	long tmp;
 
@@ -205,7 +205,7 @@ static inline long __read_trylock(raw_rwlock_t *rw)
  * This returns the old value in the lock,
  * so we got the write lock if the return value is 0.
  */
-static inline long __write_trylock(raw_rwlock_t *rw)
+static inline long arch_write_trylock(raw_rwlock_t *rw)
 {
 	long tmp, token;
 
@@ -228,7 +228,7 @@ static inline long __write_trylock(raw_rwlock_t *rw)
 static inline void __raw_read_lock(raw_rwlock_t *rw)
 {
 	while (1) {
-		if (likely(__read_trylock(rw) > 0))
+		if (likely(arch_read_trylock(rw) > 0))
 			break;
 		do {
 			HMT_low();
@@ -242,7 +242,7 @@ static inline void __raw_read_lock(raw_rwlock_t *rw)
 static inline void __raw_write_lock(raw_rwlock_t *rw)
 {
 	while (1) {
-		if (likely(__write_trylock(rw) == 0))
+		if (likely(arch_write_trylock(rw) == 0))
 			break;
 		do {
 			HMT_low();
@@ -255,12 +255,12 @@ static inline void __raw_write_lock(raw_rwlock_t *rw)
 
 static inline int __raw_read_trylock(raw_rwlock_t *rw)
 {
-	return __read_trylock(rw) > 0;
+	return arch_read_trylock(rw) > 0;
 }
 
 static inline int __raw_write_trylock(raw_rwlock_t *rw)
 {
-	return __write_trylock(rw) == 0;
+	return arch_write_trylock(rw) == 0;
 }
 
 static inline void __raw_read_unlock(raw_rwlock_t *rw)
