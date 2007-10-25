Return-Path: <linux-kernel-owner+w=401wt.eu-S1756074AbXJYV1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074AbXJYV1k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 17:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbXJYV1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 17:27:32 -0400
Received: from xenotime.net ([66.160.160.81]:40566 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753035AbXJYV1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 17:27:31 -0400
Date: Thu, 25 Oct 2007 14:27:24 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: tglx@linutronix.de, nickpiggin@yahoo.com.au, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH] x86 bitops: fix code style issues
Message-Id: <20071025142724.71d184ba.rdunlap@xenotime.net>
In-Reply-To: <20071025134814.caced2e3.akpm@linux-foundation.org>
References: <20071023220959.a359d57d.rdunlap@xenotime.net>
	<200710241800.19764.nickpiggin@yahoo.com.au>
	<20071025093159.3ea69d03.rdunlap@xenotime.net>
	<alpine.LFD.0.9999.0710251840530.3186@localhost.localdomain>
	<20071025095540.827d4333.rdunlap@xenotime.net>
	<20071025134814.caced2e3.akpm@linux-foundation.org>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Coding style cleanups:

- change __inline__ to inline;
- drop space in "* addr" parameters;
- drop space between func. name and '('

The "volatile" keywords are correct according to email from one
Linus Torvalds.

[Several other arches need some of this also.]

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/asm-x86/bitops_64.h |   52 ++++++++++++++++++++++----------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

--- linux-2.6.24-rc1.orig/include/asm-x86/bitops_64.h
+++ linux-2.6.24-rc1/include/asm-x86/bitops_64.h
@@ -29,7 +29,7 @@
  * Note that @nr may be almost arbitrarily large; this function is not
  * restricted to acting on a single-word quantity.
  */
-static __inline__ void set_bit(int nr, volatile void * addr)
+static inline void set_bit(int nr, volatile void *addr)
 {
 	__asm__ __volatile__( LOCK_PREFIX
 		"btsl %1,%0"
@@ -46,7 +46,7 @@ static __inline__ void set_bit(int nr, v
  * If it's called on the same region of memory simultaneously, the effect
  * may be that only one operation succeeds.
  */
-static __inline__ void __set_bit(int nr, volatile void * addr)
+static inline void __set_bit(int nr, volatile void *addr)
 {
 	__asm__ volatile(
 		"btsl %1,%0"
@@ -64,7 +64,7 @@ static __inline__ void __set_bit(int nr,
  * you should call smp_mb__before_clear_bit() and/or smp_mb__after_clear_bit()
  * in order to ensure changes are visible on other processors.
  */
-static __inline__ void clear_bit(int nr, volatile void * addr)
+static inline void clear_bit(int nr, volatile void *addr)
 {
 	__asm__ __volatile__( LOCK_PREFIX
 		"btrl %1,%0"
@@ -86,7 +86,7 @@ static inline void clear_bit_unlock(unsi
 	clear_bit(nr, addr);
 }
 
-static __inline__ void __clear_bit(int nr, volatile void * addr)
+static inline void __clear_bit(int nr, volatile void *addr)
 {
 	__asm__ __volatile__(
 		"btrl %1,%0"
@@ -124,7 +124,7 @@ static inline void __clear_bit_unlock(un
  * If it's called on the same region of memory simultaneously, the effect
  * may be that only one operation succeeds.
  */
-static __inline__ void __change_bit(int nr, volatile void * addr)
+static inline void __change_bit(int nr, volatile void *addr)
 {
 	__asm__ __volatile__(
 		"btcl %1,%0"
@@ -141,7 +141,7 @@ static __inline__ void __change_bit(int 
  * Note that @nr may be almost arbitrarily large; this function is not
  * restricted to acting on a single-word quantity.
  */
-static __inline__ void change_bit(int nr, volatile void * addr)
+static inline void change_bit(int nr, volatile void *addr)
 {
 	__asm__ __volatile__( LOCK_PREFIX
 		"btcl %1,%0"
@@ -157,7 +157,7 @@ static __inline__ void change_bit(int nr
  * This operation is atomic and cannot be reordered.  
  * It also implies a memory barrier.
  */
-static __inline__ int test_and_set_bit(int nr, volatile void * addr)
+static inline int test_and_set_bit(int nr, volatile void *addr)
 {
 	int oldbit;
 
@@ -175,7 +175,7 @@ static __inline__ int test_and_set_bit(i
  *
  * This is the same as test_and_set_bit on x86.
  */
-static __inline__ int test_and_set_bit_lock(int nr, volatile void *addr)
+static inline int test_and_set_bit_lock(int nr, volatile void *addr)
 {
 	return test_and_set_bit(nr, addr);
 }
@@ -189,7 +189,7 @@ static __inline__ int test_and_set_bit_l
  * If two examples of this operation race, one can appear to succeed
  * but actually fail.  You must protect multiple accesses with a lock.
  */
-static __inline__ int __test_and_set_bit(int nr, volatile void * addr)
+static inline int __test_and_set_bit(int nr, volatile void *addr)
 {
 	int oldbit;
 
@@ -208,7 +208,7 @@ static __inline__ int __test_and_set_bit
  * This operation is atomic and cannot be reordered.  
  * It also implies a memory barrier.
  */
-static __inline__ int test_and_clear_bit(int nr, volatile void * addr)
+static inline int test_and_clear_bit(int nr, volatile void *addr)
 {
 	int oldbit;
 
@@ -228,7 +228,7 @@ static __inline__ int test_and_clear_bit
  * If two examples of this operation race, one can appear to succeed
  * but actually fail.  You must protect multiple accesses with a lock.
  */
-static __inline__ int __test_and_clear_bit(int nr, volatile void * addr)
+static inline int __test_and_clear_bit(int nr, volatile void *addr)
 {
 	int oldbit;
 
@@ -240,7 +240,7 @@ static __inline__ int __test_and_clear_b
 }
 
 /* WARNING: non atomic and it can be reordered! */
-static __inline__ int __test_and_change_bit(int nr, volatile void * addr)
+static inline int __test_and_change_bit(int nr, volatile void *addr)
 {
 	int oldbit;
 
@@ -259,7 +259,7 @@ static __inline__ int __test_and_change_
  * This operation is atomic and cannot be reordered.  
  * It also implies a memory barrier.
  */
-static __inline__ int test_and_change_bit(int nr, volatile void * addr)
+static inline int test_and_change_bit(int nr, volatile void *addr)
 {
 	int oldbit;
 
@@ -276,15 +276,15 @@ static __inline__ int test_and_change_bi
  * @nr: bit number to test
  * @addr: Address to start counting from
  */
-static int test_bit(int nr, const volatile void * addr);
+static int test_bit(int nr, const volatile void *addr);
 #endif
 
-static __inline__ int constant_test_bit(int nr, const volatile void * addr)
+static inline int constant_test_bit(int nr, const volatile void *addr)
 {
 	return ((1UL << (nr & 31)) & (((const volatile unsigned int *) addr)[nr >> 5])) != 0;
 }
 
-static __inline__ int variable_test_bit(int nr, volatile const void * addr)
+static inline int variable_test_bit(int nr, volatile const void *addr)
 {
 	int oldbit;
 
@@ -302,10 +302,10 @@ static __inline__ int variable_test_bit(
 
 #undef ADDR
 
-extern long find_first_zero_bit(const unsigned long * addr, unsigned long size);
-extern long find_next_zero_bit (const unsigned long * addr, long size, long offset);
-extern long find_first_bit(const unsigned long * addr, unsigned long size);
-extern long find_next_bit(const unsigned long * addr, long size, long offset);
+extern long find_first_zero_bit(const unsigned long *addr, unsigned long size);
+extern long find_next_zero_bit(const unsigned long *addr, long size, long offset);
+extern long find_first_bit(const unsigned long *addr, unsigned long size);
+extern long find_next_bit(const unsigned long *addr, long size, long offset);
 
 /* return index of first bet set in val or max when no bit is set */
 static inline long __scanbit(unsigned long val, unsigned long max)
@@ -366,7 +366,7 @@ static inline void __clear_bit_string(un
  *
  * Undefined if no zero exists, so code should check against ~0UL first.
  */
-static __inline__ unsigned long ffz(unsigned long word)
+static inline unsigned long ffz(unsigned long word)
 {
 	__asm__("bsfq %1,%0"
 		:"=r" (word)
@@ -380,7 +380,7 @@ static __inline__ unsigned long ffz(unsi
  *
  * Undefined if no bit exists, so code should check against 0 first.
  */
-static __inline__ unsigned long __ffs(unsigned long word)
+static inline unsigned long __ffs(unsigned long word)
 {
 	__asm__("bsfq %1,%0"
 		:"=r" (word)
@@ -394,7 +394,7 @@ static __inline__ unsigned long __ffs(un
  *
  * Undefined if no zero exists, so code should check against ~0UL first.
  */
-static __inline__ unsigned long __fls(unsigned long word)
+static inline unsigned long __fls(unsigned long word)
 {
 	__asm__("bsrq %1,%0"
 		:"=r" (word)
@@ -414,7 +414,7 @@ static __inline__ unsigned long __fls(un
  * the libc and compiler builtin ffs routines, therefore
  * differs in spirit from the above ffz (man ffs).
  */
-static __inline__ int ffs(int x)
+static inline int ffs(int x)
 {
 	int r;
 
@@ -430,7 +430,7 @@ static __inline__ int ffs(int x)
  *
  * This is defined the same way as fls.
  */
-static __inline__ int fls64(__u64 x)
+static inline int fls64(__u64 x)
 {
 	if (x == 0)
 		return 0;
@@ -443,7 +443,7 @@ static __inline__ int fls64(__u64 x)
  *
  * This is defined the same way as ffs.
  */
-static __inline__ int fls(int x)
+static inline int fls(int x)
 {
 	int r;
 
