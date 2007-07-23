Return-Path: <linux-kernel-owner+w=401wt.eu-S1762039AbXGWQFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762039AbXGWQFF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 12:05:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759486AbXGWQEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 12:04:21 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:53103 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758215AbXGWQEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 12:04:20 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 23 Jul 2007 21:35:38 +0530
Message-Id: <20070723160538.22137.35213.sendpatchset@cselinux1.cse.iitk.ac.in>
In-Reply-To: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
Subject: [PATCH 2/8] i386: bitops: Rectify bogus "Ir" constraints
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Satyam Sharma <ssatyam@cse.iitk.ac.in>

[2/8] i386: bitops: Rectify bogus "Ir" constraints

The "I" constraint (on the i386 platform) is used to restrict constants to
the 0..31 range, for use with instructions that must deal with bit numbers.

However:
* The "I" constraint modifier is applicable only to immediate-value operands,
  and combining it with "r" is bogus.
* gcc will just ignore "I" if we specify "Ir" anyway and treat it same as "r".
* Bitops in Linux allow @nr to be arbitrarily large anyway, so we don't want
  to restrict ourselves to @nr < 32 in the first place.

So just kill the bogus "I" constraint modifier.

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: David Howells <dhowells@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>

---

 include/asm-i386/bitops.h |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/asm-i386/bitops.h b/include/asm-i386/bitops.h
index ba8e4bb..17a302d 100644
--- a/include/asm-i386/bitops.h
+++ b/include/asm-i386/bitops.h
@@ -43,7 +43,7 @@ static inline void set_bit(int nr, volatile unsigned long * addr)
 	__asm__ __volatile__( LOCK_PREFIX
 		"btsl %1,%0"
 		:"+m" (ADDR)
-		:"Ir" (nr));
+		:"r" (nr));
 }
 
 /**
@@ -63,7 +63,7 @@ static inline void __set_bit(int nr, volatile unsigned long * addr)
 	__asm__(
 		"btsl %1,%0"
 		:"+m" (ADDR)
-		:"Ir" (nr));
+		:"r" (nr));
 }
 
 /**
@@ -81,7 +81,7 @@ static inline void clear_bit(int nr, volatile unsigned long * addr)
 	__asm__ __volatile__( LOCK_PREFIX
 		"btrl %1,%0"
 		:"+m" (ADDR)
-		:"Ir" (nr));
+		:"r" (nr));
 }
 
 /**
@@ -101,7 +101,7 @@ static inline void __clear_bit(int nr, volatile unsigned long * addr)
 	__asm__ __volatile__(
 		"btrl %1,%0"
 		:"+m" (ADDR)
-		:"Ir" (nr));
+		:"r" (nr));
 }
 
 /*
@@ -128,7 +128,7 @@ static inline void __change_bit(int nr, volatile unsigned long * addr)
 	__asm__ __volatile__(
 		"btcl %1,%0"
 		:"+m" (ADDR)
-		:"Ir" (nr));
+		:"r" (nr));
 }
 
 /**
@@ -146,7 +146,7 @@ static inline void change_bit(int nr, volatile unsigned long * addr)
 	__asm__ __volatile__( LOCK_PREFIX
 		"btcl %1,%0"
 		:"+m" (ADDR)
-		:"Ir" (nr));
+		:"r" (nr));
 }
 
 /**
@@ -166,7 +166,7 @@ static inline int test_and_set_bit(int nr, volatile unsigned long * addr)
 	__asm__ __volatile__( LOCK_PREFIX
 		"btsl %2,%1\n\tsbbl %0,%0"
 		:"=r" (oldbit),"+m" (ADDR)
-		:"Ir" (nr) : "memory");
+		:"r" (nr) : "memory");
 	return oldbit;
 }
 
@@ -189,7 +189,7 @@ static inline int __test_and_set_bit(int nr, volatile unsigned long * addr)
 	__asm__(
 		"btsl %2,%1\n\tsbbl %0,%0"
 		:"=r" (oldbit),"+m" (ADDR)
-		:"Ir" (nr));
+		:"r" (nr));
 	return oldbit;
 }
 
@@ -210,7 +210,7 @@ static inline int test_and_clear_bit(int nr, volatile unsigned long * addr)
 	__asm__ __volatile__( LOCK_PREFIX
 		"btrl %2,%1\n\tsbbl %0,%0"
 		:"=r" (oldbit),"+m" (ADDR)
-		:"Ir" (nr) : "memory");
+		:"r" (nr) : "memory");
 	return oldbit;
 }
 
@@ -233,7 +233,7 @@ static inline int __test_and_clear_bit(int nr, volatile unsigned long *addr)
 	__asm__(
 		"btrl %2,%1\n\tsbbl %0,%0"
 		:"=r" (oldbit),"+m" (ADDR)
-		:"Ir" (nr));
+		:"r" (nr));
 	return oldbit;
 }
 
@@ -256,7 +256,7 @@ static inline int __test_and_change_bit(int nr, volatile unsigned long *addr)
 	__asm__ __volatile__(
 		"btcl %2,%1\n\tsbbl %0,%0"
 		:"=r" (oldbit),"+m" (ADDR)
-		:"Ir" (nr) : "memory");
+		:"r" (nr) : "memory");
 	return oldbit;
 }
 
@@ -277,7 +277,7 @@ static inline int test_and_change_bit(int nr, volatile unsigned long* addr)
 	__asm__ __volatile__( LOCK_PREFIX
 		"btcl %2,%1\n\tsbbl %0,%0"
 		:"=r" (oldbit),"+m" (ADDR)
-		:"Ir" (nr) : "memory");
+		:"r" (nr) : "memory");
 	return oldbit;
 }
 
@@ -302,7 +302,7 @@ static inline int variable_test_bit(int nr, const volatile unsigned long * addr)
 	__asm__ __volatile__(
 		"btl %2,%1\n\tsbbl %0,%0"
 		:"=r" (oldbit)
-		:"m" (ADDR),"Ir" (nr));
+		:"m" (ADDR),"r" (nr));
 	return oldbit;
 }
 
