Return-Path: <linux-kernel-owner+w=401wt.eu-S1763103AbZATWIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763103AbZATWIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 17:08:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755517AbZATWHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 17:07:35 -0500
Received: from cs20.apochromatic.org ([204.152.189.161]:60107 "EHLO
	cs20.apochromatic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbZATWHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 17:07:33 -0500
From: Matt Fleming <matt@console-pimps.org>
To: linux-sh@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Matt Fleming <matt@console-pimps.org>
Subject: [PATCH 1/2] sh: Relax inline assembly constraints
Date: Tue, 20 Jan 2009 21:14:37 +0000
Message-Id: <1232486078-11227-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When dereferencing the memory address contained in a register and
modifying the value at that memory address, the register should not be
listed in the inline asm outputs. The value at the memory address is an
output (which is taken care of with the "memory" clobber), not the register.

Signed-off-by: Matt Fleming <matt@console-pimps.org>
---
 arch/sh/include/asm/bitops-llsc.h  |   72 ++++++++++++++++++------------------
 arch/sh/include/asm/cmpxchg-llsc.h |   38 +++++++++---------
 2 files changed, 55 insertions(+), 55 deletions(-)

diff --git a/arch/sh/include/asm/bitops-llsc.h b/arch/sh/include/asm/bitops-llsc.h
index 1d2fc0b..d8328be 100644
--- a/arch/sh/include/asm/bitops-llsc.h
+++ b/arch/sh/include/asm/bitops-llsc.h
@@ -1,7 +1,7 @@
 #ifndef __ASM_SH_BITOPS_LLSC_H
 #define __ASM_SH_BITOPS_LLSC_H
 
-static inline void set_bit(int nr, volatile void * addr)
+static inline void set_bit(int nr, volatile void *addr)
 {
 	int	mask;
 	volatile unsigned int *a = addr;
@@ -13,16 +13,16 @@ static inline void set_bit(int nr, volatile void * addr)
 	__asm__ __volatile__ (
 		"1:						\n\t"
 		"movli.l	@%1, %0	! set_bit		\n\t"
-		"or		%3, %0				\n\t"
+		"or		%2, %0				\n\t"
 		"movco.l	%0, @%1				\n\t"
 		"bf		1b				\n\t"
-		: "=&z" (tmp), "=r" (a)
-		: "1" (a), "r" (mask)
+		: "=&z" (tmp)
+		: "r" (a), "r" (mask)
 		: "t", "memory"
 	);
 }
 
-static inline void clear_bit(int nr, volatile void * addr)
+static inline void clear_bit(int nr, volatile void *addr)
 {
 	int	mask;
 	volatile unsigned int *a = addr;
@@ -34,16 +34,16 @@ static inline void clear_bit(int nr, volatile void * addr)
 	__asm__ __volatile__ (
 		"1:						\n\t"
 		"movli.l	@%1, %0	! clear_bit		\n\t"
-		"and		%3, %0				\n\t"
+		"and		%2, %0				\n\t"
 		"movco.l	%0, @%1				\n\t"
 		"bf		1b				\n\t"
-		: "=&z" (tmp), "=r" (a)
-		: "1" (a), "r" (~mask)
+		: "=&z" (tmp)
+		: "r" (a), "r" (~mask)
 		: "t", "memory"
 	);
 }
 
-static inline void change_bit(int nr, volatile void * addr)
+static inline void change_bit(int nr, volatile void *addr)
 {
 	int	mask;
 	volatile unsigned int *a = addr;
@@ -55,16 +55,16 @@ static inline void change_bit(int nr, volatile void * addr)
 	__asm__ __volatile__ (
 		"1:						\n\t"
 		"movli.l	@%1, %0	! change_bit		\n\t"
-		"xor		%3, %0				\n\t"
+		"xor		%2, %0				\n\t"
 		"movco.l	%0, @%1				\n\t"
 		"bf		1b				\n\t"
-		: "=&z" (tmp), "=r" (a)
-		: "1" (a), "r" (mask)
+		: "=&z" (tmp)
+		: "r" (a), "r" (mask)
 		: "t", "memory"
 	);
 }
 
-static inline int test_and_set_bit(int nr, volatile void * addr)
+static inline int test_and_set_bit(int nr, volatile void *addr)
 {
 	int	mask, retval;
 	volatile unsigned int *a = addr;
@@ -75,21 +75,21 @@ static inline int test_and_set_bit(int nr, volatile void * addr)
 
 	__asm__ __volatile__ (
 		"1:						\n\t"
-		"movli.l	@%1, %0	! test_and_set_bit	\n\t"
-		"mov		%0, %2				\n\t"
-		"or		%4, %0				\n\t"
-		"movco.l	%0, @%1				\n\t"
+		"movli.l	@%2, %0	! test_and_set_bit	\n\t"
+		"mov		%0, %1				\n\t"
+		"or		%3, %0				\n\t"
+		"movco.l	%0, @%2				\n\t"
 		"bf		1b				\n\t"
-		"and		%4, %2				\n\t"
-		: "=&z" (tmp), "=r" (a), "=&r" (retval)
-		: "1" (a), "r" (mask)
+		"and		%3, %1				\n\t"
+		: "=&z" (tmp), "=&r" (retval)
+		: "r" (a), "r" (mask)
 		: "t", "memory"
 	);
 
 	return retval != 0;
 }
 
-static inline int test_and_clear_bit(int nr, volatile void * addr)
+static inline int test_and_clear_bit(int nr, volatile void *addr)
 {
 	int	mask, retval;
 	volatile unsigned int *a = addr;
@@ -100,22 +100,22 @@ static inline int test_and_clear_bit(int nr, volatile void * addr)
 
 	__asm__ __volatile__ (
 		"1:						\n\t"
-		"movli.l	@%1, %0	! test_and_clear_bit	\n\t"
-		"mov		%0, %2				\n\t"
-		"and		%5, %0				\n\t"
-		"movco.l	%0, @%1				\n\t"
+		"movli.l	@%2, %0	! test_and_clear_bit	\n\t"
+		"mov		%0, %1				\n\t"
+		"and		%4, %0				\n\t"
+		"movco.l	%0, @%2				\n\t"
 		"bf		1b				\n\t"
-		"and		%4, %2				\n\t"
+		"and		%3, %1				\n\t"
 		"synco						\n\t"
-		: "=&z" (tmp), "=r" (a), "=&r" (retval)
-		: "1" (a), "r" (mask), "r" (~mask)
+		: "=&z" (tmp), "=&r" (retval)
+		: "r" (a), "r" (mask), "r" (~mask)
 		: "t", "memory"
 	);
 
 	return retval != 0;
 }
 
-static inline int test_and_change_bit(int nr, volatile void * addr)
+static inline int test_and_change_bit(int nr, volatile void *addr)
 {
 	int	mask, retval;
 	volatile unsigned int *a = addr;
@@ -126,15 +126,15 @@ static inline int test_and_change_bit(int nr, volatile void * addr)
 
 	__asm__ __volatile__ (
 		"1:						\n\t"
-		"movli.l	@%1, %0	! test_and_change_bit	\n\t"
-		"mov		%0, %2				\n\t"
-		"xor		%4, %0				\n\t"
-		"movco.l	%0, @%1				\n\t"
+		"movli.l	@%2, %0	! test_and_change_bit	\n\t"
+		"mov		%0, %1				\n\t"
+		"xor		%3, %0				\n\t"
+		"movco.l	%0, @%2				\n\t"
 		"bf		1b				\n\t"
-		"and		%4, %2				\n\t"
+		"and		%3, %1				\n\t"
 		"synco						\n\t"
-		: "=&z" (tmp), "=r" (a), "=&r" (retval)
-		: "1" (a), "r" (mask)
+		: "=&z" (tmp), "=&r" (retval)
+		: "r" (a), "r" (mask)
 		: "t", "memory"
 	);
 
diff --git a/arch/sh/include/asm/cmpxchg-llsc.h b/arch/sh/include/asm/cmpxchg-llsc.h
index aee3bf2..0fac3da 100644
--- a/arch/sh/include/asm/cmpxchg-llsc.h
+++ b/arch/sh/include/asm/cmpxchg-llsc.h
@@ -8,14 +8,14 @@ static inline unsigned long xchg_u32(volatile u32 *m, unsigned long val)
 
 	__asm__ __volatile__ (
 		"1:					\n\t"
-		"movli.l	@%1, %0	! xchg_u32	\n\t"
-		"mov		%0, %2			\n\t"
-		"mov		%4, %0			\n\t"
-		"movco.l	%0, @%1			\n\t"
+		"movli.l	@%2, %0	! xchg_u32	\n\t"
+		"mov		%0, %1			\n\t"
+		"mov		%3, %0			\n\t"
+		"movco.l	%0, @%2			\n\t"
 		"bf		1b			\n\t"
 		"synco					\n\t"
-		: "=&z"(tmp), "=r" (m), "=&r" (retval)
-		: "1" (m), "r" (val)
+		: "=&z"(tmp), "=&r" (retval)
+		: "r" (m), "r" (val)
 		: "t", "memory"
 	);
 
@@ -29,14 +29,14 @@ static inline unsigned long xchg_u8(volatile u8 *m, unsigned long val)
 
 	__asm__ __volatile__ (
 		"1:					\n\t"
-		"movli.l	@%1, %0	! xchg_u8	\n\t"
-		"mov		%0, %2			\n\t"
-		"mov		%4, %0			\n\t"
-		"movco.l	%0, @%1			\n\t"
+		"movli.l	@%2, %0	! xchg_u8	\n\t"
+		"mov		%0, %1			\n\t"
+		"mov		%3, %0			\n\t"
+		"movco.l	%0, @%2			\n\t"
 		"bf		1b			\n\t"
 		"synco					\n\t"
-		: "=&z"(tmp), "=r" (m), "=&r" (retval)
-		: "1" (m), "r" (val & 0xff)
+		: "=&z"(tmp), "=&r" (retval)
+		: "r" (m), "r" (val & 0xff)
 		: "t", "memory"
 	);
 
@@ -51,17 +51,17 @@ __cmpxchg_u32(volatile int *m, unsigned long old, unsigned long new)
 
 	__asm__ __volatile__ (
 		"1:						\n\t"
-		"movli.l	@%1, %0	! __cmpxchg_u32		\n\t"
-		"mov		%0, %2				\n\t"
-		"cmp/eq		%2, %4				\n\t"
+		"movli.l	@%2, %0	! __cmpxchg_u32		\n\t"
+		"mov		%0, %1				\n\t"
+		"cmp/eq		%1, %3				\n\t"
 		"bf		2f				\n\t"
-		"mov		%5, %0				\n\t"
+		"mov		%3, %0				\n\t"
 		"2:						\n\t"
-		"movco.l	%0, @%1				\n\t"
+		"movco.l	%0, @%2				\n\t"
 		"bf		1b				\n\t"
 		"synco						\n\t"
-		: "=&z" (tmp), "=r" (m), "=&r" (retval)
-		: "1" (m), "r" (old), "r" (new)
+		: "=&z" (tmp), "=&r" (retval)
+		: "r" (m), "r" (old), "r" (new)
 		: "t", "memory"
 	);
 
-- 
1.5.6.3

