Return-Path: <linux-kernel-owner+w=401wt.eu-S1763661AbXGWQFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763661AbXGWQFh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 12:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762440AbXGWQE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 12:04:26 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:53109 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761512AbXGWQEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 12:04:25 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 23 Jul 2007 21:35:43 +0530
Message-Id: <20070723160543.22137.9416.sendpatchset@cselinux1.cse.iitk.ac.in>
In-Reply-To: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
Subject: [PATCH 3/8] i386: bitops: Rectify bogus "+m" constraints
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Satyam Sharma <ssatyam@cse.iitk.ac.in>

[3/8] i386: bitops: Rectify bogus "+m" constraints

>From the gcc manual:

  Extended asm supports input-output or read-write operands. Use the
  constraint character `+' to indicate such an operand and list it with
  the output operands. You should only use read-write operands when the
  constraints for the operand (or the operand in which only some of the
  bits are to be changed) allow a register.

So, using the "+" constraint modifier for memory, like "+m" is bogus.
We must simply specify "=m" which handles the case correctly.

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: David Howells <dhowells@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>

---

 include/asm-i386/bitops.h |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/asm-i386/bitops.h b/include/asm-i386/bitops.h
index 17a302d..d623fd9 100644
--- a/include/asm-i386/bitops.h
+++ b/include/asm-i386/bitops.h
@@ -42,7 +42,7 @@ static inline void set_bit(int nr, volatile unsigned long * addr)
 {
 	__asm__ __volatile__( LOCK_PREFIX
 		"btsl %1,%0"
-		:"+m" (ADDR)
+		:"=m" (ADDR)
 		:"r" (nr));
 }
 
@@ -62,7 +62,7 @@ static inline void __set_bit(int nr, volatile unsigned long * addr)
 {
 	__asm__(
 		"btsl %1,%0"
-		:"+m" (ADDR)
+		:"=m" (ADDR)
 		:"r" (nr));
 }
 
@@ -80,7 +80,7 @@ static inline void clear_bit(int nr, volatile unsigned long * addr)
 {
 	__asm__ __volatile__( LOCK_PREFIX
 		"btrl %1,%0"
-		:"+m" (ADDR)
+		:"=m" (ADDR)
 		:"r" (nr));
 }
 
@@ -100,7 +100,7 @@ static inline void __clear_bit(int nr, volatile unsigned long * addr)
 {
 	__asm__ __volatile__(
 		"btrl %1,%0"
-		:"+m" (ADDR)
+		:"=m" (ADDR)
 		:"r" (nr));
 }
 
@@ -127,7 +127,7 @@ static inline void __change_bit(int nr, volatile unsigned long * addr)
 {
 	__asm__ __volatile__(
 		"btcl %1,%0"
-		:"+m" (ADDR)
+		:"=m" (ADDR)
 		:"r" (nr));
 }
 
@@ -145,7 +145,7 @@ static inline void change_bit(int nr, volatile unsigned long * addr)
 {
 	__asm__ __volatile__( LOCK_PREFIX
 		"btcl %1,%0"
-		:"+m" (ADDR)
+		:"=m" (ADDR)
 		:"r" (nr));
 }
 
@@ -165,7 +165,7 @@ static inline int test_and_set_bit(int nr, volatile unsigned long * addr)
 
 	__asm__ __volatile__( LOCK_PREFIX
 		"btsl %2,%1\n\tsbbl %0,%0"
-		:"=r" (oldbit),"+m" (ADDR)
+		:"=r" (oldbit),"=m" (ADDR)
 		:"r" (nr) : "memory");
 	return oldbit;
 }
@@ -188,7 +188,7 @@ static inline int __test_and_set_bit(int nr, volatile unsigned long * addr)
 
 	__asm__(
 		"btsl %2,%1\n\tsbbl %0,%0"
-		:"=r" (oldbit),"+m" (ADDR)
+		:"=r" (oldbit),"=m" (ADDR)
 		:"r" (nr));
 	return oldbit;
 }
@@ -209,7 +209,7 @@ static inline int test_and_clear_bit(int nr, volatile unsigned long * addr)
 
 	__asm__ __volatile__( LOCK_PREFIX
 		"btrl %2,%1\n\tsbbl %0,%0"
-		:"=r" (oldbit),"+m" (ADDR)
+		:"=r" (oldbit),"=m" (ADDR)
 		:"r" (nr) : "memory");
 	return oldbit;
 }
@@ -232,7 +232,7 @@ static inline int __test_and_clear_bit(int nr, volatile unsigned long *addr)
 
 	__asm__(
 		"btrl %2,%1\n\tsbbl %0,%0"
-		:"=r" (oldbit),"+m" (ADDR)
+		:"=r" (oldbit),"=m" (ADDR)
 		:"r" (nr));
 	return oldbit;
 }
@@ -255,7 +255,7 @@ static inline int __test_and_change_bit(int nr, volatile unsigned long *addr)
 
 	__asm__ __volatile__(
 		"btcl %2,%1\n\tsbbl %0,%0"
-		:"=r" (oldbit),"+m" (ADDR)
+		:"=r" (oldbit),"=m" (ADDR)
 		:"r" (nr) : "memory");
 	return oldbit;
 }
@@ -276,7 +276,7 @@ static inline int test_and_change_bit(int nr, volatile unsigned long* addr)
 
 	__asm__ __volatile__( LOCK_PREFIX
 		"btcl %2,%1\n\tsbbl %0,%0"
-		:"=r" (oldbit),"+m" (ADDR)
+		:"=r" (oldbit),"=m" (ADDR)
 		:"r" (nr) : "memory");
 	return oldbit;
 }
