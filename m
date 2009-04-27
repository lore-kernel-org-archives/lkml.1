Return-Path: <linux-kernel-owner+w=401wt.eu-S1758125AbZD0PJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125AbZD0PJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 11:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756907AbZD0PHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 11:07:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:65186 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203AbZD0PHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 11:07:23 -0400
Message-Id: <20090427150317.872901395@arndb.de>
References: <20090427142010.587518220@arndb.de>
User-Agent: quilt/0.46-1
Date: Mon, 27 Apr 2009 17:01:18 +0200
From: arnd@arndb.de
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, monstr@monstr.eu, linux-api@vger.kernel.org,
       linux-arch@vger.kernel.org, liqin.chen@sunplusct.com,
       Sam Ravnborg <sam@ravnborg.org>,
       Remis Lima Baima <remis.developer@googlemail.com>
Subject: [RFC 04/17] asm-generic: introduce asm/bitsperlong.h
Content-Disposition: inline; filename=0020-define-__BITS_PER_LONG-64-on-all-64-bit-architectu.patch
X-Provags-ID: V01U2FsdGVkX1/OgKEApnORnVcWGQjsnUw7N4VSj2NwqAhhuQ8
 QW653NsdQa819sIEGaAMThBEC2XoKz5aJyzaDskGIwjGGr9hZ9
 9+Ye8cV4YFemRCo9JWPXA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This provides a reliable way for asm-generic/types.h and other
files to find out if it is running on a 32 or 64 bit platform.

We cannot use CONFIG_64BIT for this in headers that are included
from user space because CONFIG symbols are not available there.
We also cannot do it inside of asm/types.h because some headers
need the word size but cannot include types.h.

The solution is to introduce a new header <asm/bitsperlong.h>
that defines both __BITS_PER_LONG for user space and
BITS_PER_LONG for usage in the kernel. The asm-generic
version falls back to 32 bit unless the architecture overrides
it, which I did for all 64 bit platforms.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Remis Lima Baima <remis.developer@googlemail.com>
---
 arch/alpha/include/asm/bitsperlong.h      |    8 	8 +	0 -	0 !
 arch/alpha/include/asm/types.h            |    3 	0 +	3 -	0 !
 arch/arm/include/asm/bitsperlong.h        |    1 	1 +	0 -	0 !
 arch/avr32/include/asm/bitsperlong.h      |    1 	1 +	0 -	0 !
 arch/blackfin/include/asm/bitsperlong.h   |    1 	1 +	0 -	0 !
 arch/cris/include/asm/bitsperlong.h       |    1 	1 +	0 -	0 !
 arch/frv/include/asm/bitsperlong.h        |    1 	1 +	0 -	0 !
 arch/h8300/include/asm/bitsperlong.h      |    1 	1 +	0 -	0 !
 arch/ia64/include/asm/bitsperlong.h       |    8 	8 +	0 -	0 !
 arch/ia64/include/asm/types.h             |    7 	0 +	7 -	0 !
 arch/m32r/include/asm/bitsperlong.h       |    1 	1 +	0 -	0 !
 arch/m68k/include/asm/bitsperlong.h       |    1 	1 +	0 -	0 !
 arch/m68knommu/include/asm/bitsperlong.h  |    1 	1 +	0 -	0 !
 arch/microblaze/include/asm/bitsperlong.h |    1 	1 +	0 -	0 !
 arch/mips/include/asm/bitsperlong.h       |    8 	8 +	0 -	0 !
 arch/mips/include/asm/types.h             |    3 	0 +	3 -	0 !
 arch/mn10300/include/asm/bitsperlong.h    |    1 	1 +	0 -	0 !
 arch/parisc/include/asm/bitsperlong.h     |   20 	20 +	0 -	0 !
 arch/parisc/include/asm/types.h           |    8 	0 +	8 -	0 !
 arch/powerpc/include/asm/bitsperlong.h    |   12 	12 +	0 -	0 !
 arch/powerpc/include/asm/types.h          |    9 	0 +	9 -	0 !
 arch/s390/include/asm/bitsperlong.h       |   13 	13 +	0 -	0 !
 arch/s390/include/asm/types.h             |    6 	0 +	6 -	0 !
 arch/sh/include/asm/bitsperlong.h         |    1 	1 +	0 -	0 !
 arch/sparc/include/asm/bitsperlong.h      |   13 	13 +	0 -	0 !
 arch/sparc/include/asm/types.h            |    4 	0 +	4 -	0 !
 arch/x86/include/asm/bitsperlong.h        |   13 	13 +	0 -	0 !
 arch/x86/include/asm/types.h              |    6 	0 +	6 -	0 !
 arch/xtensa/include/asm/bitsperlong.h     |    1 	1 +	0 -	0 !
 include/asm-generic/bitsperlong.h         |   32 	32 +	0 -	0 !
 include/asm-generic/int-l64.h             |    2 	2 +	0 -	0 !
 include/asm-generic/int-ll64.h            |    2 	2 +	0 -	0 !
 32 files changed, 144 insertions(+), 46 deletions(-)

Index: linux-2.6/arch/alpha/include/asm/types.h
===================================================================
--- linux-2.6.orig/arch/alpha/include/asm/types.h
+++ linux-2.6/arch/alpha/include/asm/types.h
@@ -25,9 +25,6 @@ typedef unsigned int umode_t;
  * These aren't exported outside the kernel to avoid name space clashes
  */
 #ifdef __KERNEL__
-
-#define BITS_PER_LONG 64
-
 #ifndef __ASSEMBLY__
 
 typedef u64 dma_addr_t;
Index: linux-2.6/arch/ia64/include/asm/types.h
===================================================================
--- linux-2.6.orig/arch/ia64/include/asm/types.h
+++ linux-2.6/arch/ia64/include/asm/types.h
@@ -19,10 +19,6 @@
 # define __IA64_UL(x)		(x)
 # define __IA64_UL_CONST(x)	x
 
-# ifdef __KERNEL__
-#  define BITS_PER_LONG 64
-# endif
-
 #else
 # define __IA64_UL(x)		((unsigned long)(x))
 # define __IA64_UL_CONST(x)	x##UL
@@ -34,10 +30,7 @@ typedef unsigned int umode_t;
  */
 # ifdef __KERNEL__
 
-#define BITS_PER_LONG 64
-
 /* DMA addresses are 64-bits wide, in general.  */
-
 typedef u64 dma_addr_t;
 
 # endif /* __KERNEL__ */
Index: linux-2.6/arch/mips/include/asm/types.h
===================================================================
--- linux-2.6.orig/arch/mips/include/asm/types.h
+++ linux-2.6/arch/mips/include/asm/types.h
@@ -31,9 +31,6 @@ typedef unsigned short umode_t;
  * These aren't exported outside the kernel to avoid name space clashes
  */
 #ifdef __KERNEL__
-
-#define BITS_PER_LONG _MIPS_SZLONG
-
 #ifndef __ASSEMBLY__
 
 #if (defined(CONFIG_HIGHMEM) && defined(CONFIG_64BIT_PHYS_ADDR)) \
Index: linux-2.6/arch/parisc/include/asm/types.h
===================================================================
--- linux-2.6.orig/arch/parisc/include/asm/types.h
+++ linux-2.6/arch/parisc/include/asm/types.h
@@ -14,14 +14,6 @@ typedef unsigned short umode_t;
  */
 #ifdef __KERNEL__
 
-#ifdef CONFIG_64BIT
-#define BITS_PER_LONG 64
-#define SHIFT_PER_LONG 6
-#else
-#define BITS_PER_LONG 32
-#define SHIFT_PER_LONG 5
-#endif
-
 #ifndef __ASSEMBLY__
 
 /* Dma addresses are 32-bits wide.  */
Index: linux-2.6/arch/powerpc/include/asm/types.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/types.h
+++ linux-2.6/arch/powerpc/include/asm/types.h
@@ -40,15 +40,6 @@ typedef struct {
 #endif /* __ASSEMBLY__ */
 
 #ifdef __KERNEL__
-/*
- * These aren't exported outside the kernel to avoid name space clashes
- */
-#ifdef __powerpc64__
-#define BITS_PER_LONG 64
-#else
-#define BITS_PER_LONG 32
-#endif
-
 #ifndef __ASSEMBLY__
 
 typedef __vector128 vector128;
Index: linux-2.6/arch/s390/include/asm/types.h
===================================================================
--- linux-2.6.orig/arch/s390/include/asm/types.h
+++ linux-2.6/arch/s390/include/asm/types.h
@@ -28,12 +28,6 @@ typedef __signed__ long saddr_t;
  */
 #ifdef __KERNEL__
 
-#ifndef __s390x__
-#define BITS_PER_LONG 32
-#else
-#define BITS_PER_LONG 64
-#endif
-
 #ifndef __ASSEMBLY__
 
 typedef u64 dma64_addr_t;
Index: linux-2.6/arch/sparc/include/asm/types.h
===================================================================
--- linux-2.6.orig/arch/sparc/include/asm/types.h
+++ linux-2.6/arch/sparc/include/asm/types.h
@@ -21,8 +21,6 @@ typedef unsigned short umode_t;
 
 #ifdef __KERNEL__
 
-#define BITS_PER_LONG 64
-
 #ifndef __ASSEMBLY__
 
 /* Dma addresses come in generic and 64-bit flavours.  */
@@ -46,8 +44,6 @@ typedef unsigned short umode_t;
 
 #ifdef __KERNEL__
 
-#define BITS_PER_LONG 32
-
 #ifndef __ASSEMBLY__
 
 typedef u32 dma_addr_t;
Index: linux-2.6/arch/x86/include/asm/types.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/types.h
+++ linux-2.6/arch/x86/include/asm/types.h
@@ -14,12 +14,6 @@ typedef unsigned short umode_t;
  */
 #ifdef __KERNEL__
 
-#ifdef CONFIG_X86_32
-# define BITS_PER_LONG 32
-#else
-# define BITS_PER_LONG 64
-#endif
-
 #ifndef __ASSEMBLY__
 
 typedef u64 dma64_addr_t;
Index: linux-2.6/arch/alpha/include/asm/bitsperlong.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/alpha/include/asm/bitsperlong.h
@@ -0,0 +1,8 @@
+#ifndef __ASM_ALPHA_BITSPERLONG_H
+#define __ASM_ALPHA_BITSPERLONG_H
+
+#define __BITS_PER_LONG 64
+
+#include <asm-generic/bitsperlong.h>
+
+#endif /* __ASM_ALPHA_BITSPERLONG_H */
Index: linux-2.6/arch/ia64/include/asm/bitsperlong.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/ia64/include/asm/bitsperlong.h
@@ -0,0 +1,8 @@
+#ifndef __ASM_IA64_BITSPERLONG_H
+#define __ASM_IA64_BITSPERLONG_H
+
+#define __BITS_PER_LONG 64
+
+#include <asm-generic/bitsperlong.h>
+
+#endif /* __ASM_IA64_BITSPERLONG_H */
Index: linux-2.6/arch/mips/include/asm/bitsperlong.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/mips/include/asm/bitsperlong.h
@@ -0,0 +1,8 @@
+#ifndef __ASM_MIPS_BITSPERLONG_H
+#define __ASM_MIPS_BITSPERLONG_H
+
+#define __BITS_PER_LONG _MIPS_SZLONG
+
+#include <asm-generic/bitsperlong.h>
+
+#endif /* __ASM_MIPS_BITSPERLONG_H */
Index: linux-2.6/arch/parisc/include/asm/bitsperlong.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/parisc/include/asm/bitsperlong.h
@@ -0,0 +1,20 @@
+#ifndef __ASM_PARISC_BITSPERLONG_H
+#define __ASM_PARISC_BITSPERLONG_H
+
+/*
+ * using CONFIG_* outside of __KERNEL__ is wrong,
+ * __LP64__ was also removed from headers, so what
+ * is the right approach on parisc?
+ *	-arnd
+ */
+#if (defined(__KERNEL__) && defined(CONFIG_64BIT)) || defined (__LP64__)
+#define __BITS_PER_LONG 64
+#define SHIFT_PER_LONG 6
+#else
+#define __BITS_PER_LONG 32
+#define SHIFT_PER_LONG 5
+#endif
+
+#include <asm-generic/bitsperlong.h>
+
+#endif /* __ASM_PARISC_BITSPERLONG_H */
Index: linux-2.6/arch/powerpc/include/asm/bitsperlong.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/powerpc/include/asm/bitsperlong.h
@@ -0,0 +1,12 @@
+#ifndef __ASM_POWERPC_BITSPERLONG_H
+#define __ASM_POWERPC_BITSPERLONG_H
+
+#if defined(__powerpc64__)
+# define __BITS_PER_LONG 64
+#else
+# define __BITS_PER_LONG 32
+#endif
+
+#include <asm-generic/bitsperlong.h>
+
+#endif /* __ASM_POWERPC_BITSPERLONG_H */
Index: linux-2.6/arch/s390/include/asm/bitsperlong.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/s390/include/asm/bitsperlong.h
@@ -0,0 +1,13 @@
+#ifndef __ASM_S390_BITSPERLONG_H
+#define __ASM_S390_BITSPERLONG_H
+
+#ifndef __s390x__
+#define __BITS_PER_LONG 32
+#else
+#define __BITS_PER_LONG 64
+#endif
+
+#include <asm-generic/bitsperlong.h>
+
+#endif /* __ASM_S390_BITSPERLONG_H */
+
Index: linux-2.6/arch/sparc/include/asm/bitsperlong.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/sparc/include/asm/bitsperlong.h
@@ -0,0 +1,13 @@
+#ifndef __ASM_ALPHA_BITSPERLONG_H
+#define __ASM_ALPHA_BITSPERLONG_H
+
+#if defined(__sparc__) && defined(__arch64__)
+#define __BITS_PER_LONG 64
+#else
+#define __BITS_PER_LONG 32
+#endif
+
+#include <asm-generic/bitsperlong.h>
+
+#endif /* __ASM_ALPHA_BITSPERLONG_H */
+
Index: linux-2.6/arch/x86/include/asm/bitsperlong.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/x86/include/asm/bitsperlong.h
@@ -0,0 +1,13 @@
+#ifndef __ASM_X86_BITSPERLONG_H
+#define __ASM_X86_BITSPERLONG_H
+
+#ifdef __x86_64__
+# define __BITS_PER_LONG 64
+#else
+# define __BITS_PER_LONG 32
+#endif
+
+#include <asm-generic/bitsperlong.h>
+
+#endif /* __ASM_X86_BITSPERLONG_H */
+
Index: linux-2.6/include/asm-generic/bitsperlong.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-generic/bitsperlong.h
@@ -0,0 +1,32 @@
+#ifndef __ASM_GENERIC_BITS_PER_LONG
+#define __ASM_GENERIC_BITS_PER_LONG
+
+/*
+ * There seems to be no way of detecting this automatically from user
+ * space, so 64 bit architectures should override this in their
+ * bitsperlong.h. In particular, an architecture that supports
+ * both 32 and 64 bit user space must not rely on CONFIG_64BIT
+ * to decide it, but rather check a compiler provided macro.
+ */
+#ifndef __BITS_PER_LONG
+#define __BITS_PER_LONG 32
+#endif
+
+#ifdef __KERNEL__
+
+#ifdef CONFIG_64BIT
+#define BITS_PER_LONG 64
+#else
+#define BITS_PER_LONG 32
+#endif /* CONFIG_64BIT */
+
+/*
+ * FIXME: The check currently breaks x86-64 build, so it's
+ * temporarily disabled. Please fix x86-64 and reenable
+ */
+#if 0 && BITS_PER_LONG != __BITS_PER_LONG
+#error Inconsistent word size. Check asm/bitsperlong.h
+#endif
+
+#endif /* __KERNEL__ */
+#endif /* __ASM_GENERIC_BITS_PER_LONG */
Index: linux-2.6/include/asm-generic/int-l64.h
===================================================================
--- linux-2.6.orig/include/asm-generic/int-l64.h
+++ linux-2.6/include/asm-generic/int-l64.h
@@ -8,6 +8,8 @@
 #ifndef _ASM_GENERIC_INT_L64_H
 #define _ASM_GENERIC_INT_L64_H
 
+#include <asm/bitsperlong.h>
+
 #ifndef __ASSEMBLY__
 /*
  * __xx is ok: it doesn't pollute the POSIX namespace. Use these in the
Index: linux-2.6/include/asm-generic/int-ll64.h
===================================================================
--- linux-2.6.orig/include/asm-generic/int-ll64.h
+++ linux-2.6/include/asm-generic/int-ll64.h
@@ -8,6 +8,8 @@
 #ifndef _ASM_GENERIC_INT_LL64_H
 #define _ASM_GENERIC_INT_LL64_H
 
+#include <asm/bitsperlong.h>
+
 #ifndef __ASSEMBLY__
 /*
  * __xx is ok: it doesn't pollute the POSIX namespace. Use these in the
Index: linux-2.6/arch/arm/include/asm/bitsperlong.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/arm/include/asm/bitsperlong.h
@@ -0,0 +1 @@
+#include <asm-generic/bitsperlong.h>
Index: linux-2.6/arch/avr32/include/asm/bitsperlong.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/avr32/include/asm/bitsperlong.h
@@ -0,0 +1 @@
+#include <asm-generic/bitsperlong.h>
Index: linux-2.6/arch/blackfin/include/asm/bitsperlong.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/blackfin/include/asm/bitsperlong.h
@@ -0,0 +1 @@
+#include <asm-generic/bitsperlong.h>
Index: linux-2.6/arch/cris/include/asm/bitsperlong.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/cris/include/asm/bitsperlong.h
@@ -0,0 +1 @@
+#include <asm-generic/bitsperlong.h>
Index: linux-2.6/arch/frv/include/asm/bitsperlong.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/frv/include/asm/bitsperlong.h
@@ -0,0 +1 @@
+#include <asm-generic/bitsperlong.h>
Index: linux-2.6/arch/h8300/include/asm/bitsperlong.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/h8300/include/asm/bitsperlong.h
@@ -0,0 +1 @@
+#include <asm-generic/bitsperlong.h>
Index: linux-2.6/arch/m32r/include/asm/bitsperlong.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/m32r/include/asm/bitsperlong.h
@@ -0,0 +1 @@
+#include <asm-generic/bitsperlong.h>
Index: linux-2.6/arch/m68k/include/asm/bitsperlong.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/m68k/include/asm/bitsperlong.h
@@ -0,0 +1 @@
+#include <asm-generic/bitsperlong.h>
Index: linux-2.6/arch/m68knommu/include/asm/bitsperlong.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/m68knommu/include/asm/bitsperlong.h
@@ -0,0 +1 @@
+#include <asm-generic/bitsperlong.h>
Index: linux-2.6/arch/microblaze/include/asm/bitsperlong.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/microblaze/include/asm/bitsperlong.h
@@ -0,0 +1 @@
+#include <asm-generic/bitsperlong.h>
Index: linux-2.6/arch/mn10300/include/asm/bitsperlong.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/mn10300/include/asm/bitsperlong.h
@@ -0,0 +1 @@
+#include <asm-generic/bitsperlong.h>
Index: linux-2.6/arch/sh/include/asm/bitsperlong.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/sh/include/asm/bitsperlong.h
@@ -0,0 +1 @@
+#include <asm-generic/bitsperlong.h>
Index: linux-2.6/arch/xtensa/include/asm/bitsperlong.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/xtensa/include/asm/bitsperlong.h
@@ -0,0 +1 @@
+#include <asm-generic/bitsperlong.h>

-- 

