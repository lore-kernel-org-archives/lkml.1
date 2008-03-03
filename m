Return-Path: <linux-kernel-owner+w=401wt.eu-S1759046AbYCCAKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759046AbYCCAKU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 19:10:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754873AbYCCAKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 19:10:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33150 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbYCCAKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 19:10:03 -0500
Date: Sun, 2 Mar 2008 16:09:51 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 1/2] Add C99-style constructor macros for specific-sized integers
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Arch Mailing List <linux-arch@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>
Message-ID: <4a8566f54ff84f498c5c0c0340076c296b1840e6@tazenda.hos.anvin.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although it is fully legal and correct C to write something like:

	 (u64)0x123456789abcdef

.. gcc will issue a warning on 32-bit systems that 0x123456789abcdef
is too big for an "int", and that it has been transparently promoted,
even though it is obvious that that is what the user intended in the
first place.  C99 has macros of the form [U]INT#_C() to construct
numbers of an arbitrary size; this patch creates analogous macros for
the kernel s# and u# types.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 include/asm-alpha/types.h    |    9 +++++++++
 include/asm-arm/types.h      |    9 +++++++++
 include/asm-avr32/types.h    |    9 +++++++++
 include/asm-blackfin/types.h |    9 +++++++++
 include/asm-cris/types.h     |    9 +++++++++
 include/asm-frv/types.h      |    9 +++++++++
 include/asm-h8300/types.h    |    9 +++++++++
 include/asm-ia64/types.h     |    9 +++++++++
 include/asm-m32r/types.h     |    9 +++++++++
 include/asm-m68k/types.h     |    9 +++++++++
 include/asm-mips/types.h     |   11 +++++++++++
 include/asm-mn10300/types.h  |    9 +++++++++
 include/asm-parisc/types.h   |    9 +++++++++
 include/asm-powerpc/types.h  |   11 +++++++++++
 include/asm-s390/types.h     |   11 +++++++++++
 include/asm-sh/types.h       |    9 +++++++++
 include/asm-sparc/types.h    |    9 +++++++++
 include/asm-sparc64/types.h  |    9 +++++++++
 include/asm-v850/types.h     |    9 +++++++++
 include/asm-x86/types.h      |    9 +++++++++
 include/asm-xtensa/types.h   |    8 ++++++++
 21 files changed, 194 insertions(+), 0 deletions(-)

diff --git a/include/asm-alpha/types.h b/include/asm-alpha/types.h
index f571613..76bc008 100644
--- a/include/asm-alpha/types.h
+++ b/include/asm-alpha/types.h
@@ -53,6 +53,15 @@ typedef unsigned int u32;
 typedef signed long s64;
 typedef unsigned long u64;
 
+#define S8_C(x)	 x
+#define U8_C(x)  x ## U
+#define S16_C(x) x
+#define U16_C(x) x ## U
+#define S32_C(x) x
+#define U32_C(x) x ## U
+#define S64_C(x) x ## L
+#define U64_C(x) x ## UL
+
 typedef u64 dma_addr_t;
 typedef u64 dma64_addr_t;
 
diff --git a/include/asm-arm/types.h b/include/asm-arm/types.h
index 3141451..d55e0bf 100644
--- a/include/asm-arm/types.h
+++ b/include/asm-arm/types.h
@@ -47,6 +47,15 @@ typedef unsigned int u32;
 typedef signed long long s64;
 typedef unsigned long long u64;
 
+#define S8_C(x)	 x
+#define U8_C(x)  x ## U
+#define S16_C(x) x
+#define U16_C(x) x ## U
+#define S32_C(x) x
+#define U32_C(x) x ## U
+#define S64_C(x) x ## LL
+#define U64_C(x) x ## ULL
+
 /* Dma addresses are 32-bits wide.  */
 
 typedef u32 dma_addr_t;
diff --git a/include/asm-avr32/types.h b/include/asm-avr32/types.h
index 8999a38..f8d9c8a 100644
--- a/include/asm-avr32/types.h
+++ b/include/asm-avr32/types.h
@@ -53,6 +53,15 @@ typedef unsigned int u32;
 typedef signed long long s64;
 typedef unsigned long long u64;
 
+#define S8_C(x)	 x
+#define U8_C(x)  x ## U
+#define S16_C(x) x
+#define U16_C(x) x ## U
+#define S32_C(x) x
+#define U32_C(x) x ## U
+#define S64_C(x) x ## LL
+#define U64_C(x) x ## ULL
+
 /* Dma addresses are 32-bits wide.  */
 
 typedef u32 dma_addr_t;
diff --git a/include/asm-blackfin/types.h b/include/asm-blackfin/types.h
index 9785a6d..57803a9 100644
--- a/include/asm-blackfin/types.h
+++ b/include/asm-blackfin/types.h
@@ -54,6 +54,15 @@ typedef unsigned int u32;
 typedef signed long long s64;
 typedef unsigned long long u64;
 
+#define S8_C(x)	 x
+#define U8_C(x)  x ## U
+#define S16_C(x) x
+#define U16_C(x) x ## U
+#define S32_C(x) x
+#define U32_C(x) x ## U
+#define S64_C(x) x ## LL
+#define U64_C(x) x ## ULL
+
 /* Dma addresses are 32-bits wide.  */
 
 typedef u32 dma_addr_t;
diff --git a/include/asm-cris/types.h b/include/asm-cris/types.h
index 5a21c42..5e730f1 100644
--- a/include/asm-cris/types.h
+++ b/include/asm-cris/types.h
@@ -47,6 +47,15 @@ typedef unsigned int u32;
 typedef signed long long s64;
 typedef unsigned long long u64;
 
+#define S8_C(x)	 x
+#define U8_C(x)  x ## U
+#define S16_C(x) x
+#define U16_C(x) x ## U
+#define S32_C(x) x
+#define U32_C(x) x ## U
+#define S64_C(x) x ## LL
+#define U64_C(x) x ## ULL
+
 /* Dma addresses are 32-bits wide, just like our other addresses.  */
  
 typedef u32 dma_addr_t;
diff --git a/include/asm-frv/types.h b/include/asm-frv/types.h
index 767e5ed..e903c37 100644
--- a/include/asm-frv/types.h
+++ b/include/asm-frv/types.h
@@ -59,6 +59,15 @@ typedef unsigned int u32;
 typedef signed long long s64;
 typedef unsigned long long u64;
 
+#define S8_C(x)	 x
+#define U8_C(x)  x ## U
+#define S16_C(x) x
+#define U16_C(x) x ## U
+#define S32_C(x) x
+#define U32_C(x) x ## U
+#define S64_C(x) x ## LL
+#define U64_C(x) x ## ULL
+
 /* Dma addresses are 32-bits wide.  */
 
 typedef u32 dma_addr_t;
diff --git a/include/asm-h8300/types.h b/include/asm-h8300/types.h
index 56566e2..6344ded 100644
--- a/include/asm-h8300/types.h
+++ b/include/asm-h8300/types.h
@@ -49,6 +49,15 @@ typedef unsigned int u32;
 typedef signed long long s64;
 typedef unsigned long long u64;
 
+#define S8_C(x)	 x
+#define U8_C(x)  x ## U
+#define S16_C(x) x
+#define U16_C(x) x ## U
+#define S32_C(x) x
+#define U32_C(x) x ## U
+#define S64_C(x) x ## LL
+#define U64_C(x) x ## ULL
+
 #define BITS_PER_LONG 32
 
 /* Dma addresses are 32-bits wide.  */
diff --git a/include/asm-ia64/types.h b/include/asm-ia64/types.h
index 902850d..0932c78 100644
--- a/include/asm-ia64/types.h
+++ b/include/asm-ia64/types.h
@@ -61,6 +61,15 @@ typedef __u32 u32;
 typedef __s64 s64;
 typedef __u64 u64;
 
+#define S8_C(x)	 x
+#define U8_C(x)  x ## U
+#define S16_C(x) x
+#define U16_C(x) x ## U
+#define S32_C(x) x
+#define U32_C(x) x ## U
+#define S64_C(x) x ## L
+#define U64_C(x) x ## UL
+
 #define BITS_PER_LONG 64
 
 /* DMA addresses are 64-bits wide, in general.  */
diff --git a/include/asm-m32r/types.h b/include/asm-m32r/types.h
index b64c166..785b6d9 100644
--- a/include/asm-m32r/types.h
+++ b/include/asm-m32r/types.h
@@ -46,6 +46,15 @@ typedef unsigned int u32;
 typedef signed long long s64;
 typedef unsigned long long u64;
 
+#define S8_C(x)	 x
+#define U8_C(x)  x ## U
+#define S16_C(x) x
+#define U16_C(x) x ## U
+#define S32_C(x) x
+#define U32_C(x) x ## U
+#define S64_C(x) x ## LL
+#define U64_C(x) x ## ULL
+
 /* DMA addresses are 32-bits wide.  */
 
 typedef u32 dma_addr_t;
diff --git a/include/asm-m68k/types.h b/include/asm-m68k/types.h
index c35c09d..ffb57a1 100644
--- a/include/asm-m68k/types.h
+++ b/include/asm-m68k/types.h
@@ -55,6 +55,15 @@ typedef unsigned int u32;
 typedef signed long long s64;
 typedef unsigned long long u64;
 
+#define S8_C(x)	 x
+#define U8_C(x)  x ## U
+#define S16_C(x) x
+#define U16_C(x) x ## U
+#define S32_C(x) x
+#define U32_C(x) x ## U
+#define S64_C(x) x ## LL
+#define U64_C(x) x ## ULL
+
 /* DMA addresses are always 32-bits wide */
 
 typedef u32 dma_addr_t;
diff --git a/include/asm-mips/types.h b/include/asm-mips/types.h
index 2dd147f..2f00706 100644
--- a/include/asm-mips/types.h
+++ b/include/asm-mips/types.h
@@ -62,16 +62,27 @@ typedef unsigned short u16;
 typedef __signed int s32;
 typedef unsigned int u32;
 
+#define S8_C(x)	 x
+#define U8_C(x)  x ## U
+#define S16_C(x) x
+#define U16_C(x) x ## U
+#define S32_C(x) x
+#define U32_C(x) x ## U
+
 #if (_MIPS_SZLONG == 64)
 
 typedef __signed__ long s64;
 typedef unsigned long u64;
+#define S64_C(x) x ## L
+#define U64_C(x) x ## UL
 
 #else
 
 #if defined(__GNUC__) && !defined(__STRICT_ANSI__)
 typedef __signed__ long long s64;
 typedef unsigned long long u64;
+#define S64_C(x) x ## LL
+#define U64_C(x) x ## ULL
 #endif
 
 #endif
diff --git a/include/asm-mn10300/types.h b/include/asm-mn10300/types.h
index d40ea76..7f6c2f0 100644
--- a/include/asm-mn10300/types.h
+++ b/include/asm-mn10300/types.h
@@ -57,6 +57,15 @@ typedef unsigned int u32;
 typedef signed long long s64;
 typedef unsigned long long u64;
 
+#define S8_C(x)	 x
+#define U8_C(x)  x ## U
+#define S16_C(x) x
+#define U16_C(x) x ## U
+#define S32_C(x) x
+#define U32_C(x) x ## U
+#define S64_C(x) x ## LL
+#define U64_C(x) x ## ULL
+
 /* Dma addresses are 32-bits wide.  */
 typedef u32 dma_addr_t;
 
diff --git a/include/asm-parisc/types.h b/include/asm-parisc/types.h
index 56c8480..08787e0 100644
--- a/include/asm-parisc/types.h
+++ b/include/asm-parisc/types.h
@@ -53,6 +53,15 @@ typedef unsigned int u32;
 typedef signed long long s64;
 typedef unsigned long long u64;
 
+#define S8_C(x)	 x
+#define U8_C(x)  x ## U
+#define S16_C(x) x
+#define U16_C(x) x ## U
+#define S32_C(x) x
+#define U32_C(x) x ## U
+#define S64_C(x) x ## LL
+#define U64_C(x) x ## ULL
+
 /* Dma addresses are 32-bits wide.  */
 
 typedef u32 dma_addr_t;
diff --git a/include/asm-powerpc/types.h b/include/asm-powerpc/types.h
index 903fd19..7c42717 100644
--- a/include/asm-powerpc/types.h
+++ b/include/asm-powerpc/types.h
@@ -74,12 +74,23 @@ typedef unsigned short u16;
 typedef signed int s32;
 typedef unsigned int u32;
 
+#define S8_C(x)	 x
+#define U8_C(x)  x ## U
+#define S16_C(x) x
+#define U16_C(x) x ## U
+#define S32_C(x) x
+#define U32_C(x) x ## U
+
 #ifdef __powerpc64__
 typedef signed long s64;
 typedef unsigned long u64;
+#define S64_C(x) x ## L
+#define U64_C(x) x ## UL
 #else
 typedef signed long long s64;
 typedef unsigned long long u64;
+#define S64_C(x) x ## LL
+#define U64_C(x) x ## ULL
 #endif
 
 typedef __vector128 vector128;
diff --git a/include/asm-s390/types.h b/include/asm-s390/types.h
index 2c5879a..48f771b 100644
--- a/include/asm-s390/types.h
+++ b/include/asm-s390/types.h
@@ -68,12 +68,23 @@ typedef unsigned short u16;
 typedef signed int s32;
 typedef unsigned int u32;
 
+#define S8_C(x)	 x
+#define U8_C(x)  x ## U
+#define S16_C(x) x
+#define U16_C(x) x ## U
+#define S32_C(x) x
+#define U32_C(x) x ## U
+
 #ifndef __s390x__
 typedef signed long long s64;
 typedef unsigned long long u64;
+#define S64_C(x) x ## LL
+#define U64_C(x) x ## ULL
 #else /* __s390x__ */
 typedef signed long s64;
 typedef unsigned  long u64;
+#define S64_C(x) x ## L
+#define U64_C(x) x ## UL
 #endif /* __s390x__ */
 
 typedef u32 dma_addr_t;
diff --git a/include/asm-sh/types.h b/include/asm-sh/types.h
index a6e1d41..5f674e9 100644
--- a/include/asm-sh/types.h
+++ b/include/asm-sh/types.h
@@ -48,6 +48,15 @@ typedef unsigned int u32;
 typedef __signed__ long long s64;
 typedef unsigned long long u64;
 
+#define S8_C(x)	 x
+#define U8_C(x)  x ## U
+#define S16_C(x) x
+#define U16_C(x) x ## U
+#define S32_C(x) x
+#define U32_C(x) x ## U
+#define S64_C(x) x ## LL
+#define U64_C(x) x ## ULL
+
 /* Dma addresses are 32-bits wide.  */
 
 typedef u32 dma_addr_t;
diff --git a/include/asm-sparc/types.h b/include/asm-sparc/types.h
index 42fc6ed..b77b145 100644
--- a/include/asm-sparc/types.h
+++ b/include/asm-sparc/types.h
@@ -51,6 +51,15 @@ typedef unsigned int u32;
 typedef __signed__ long long s64;
 typedef unsigned long long u64;
 
+#define S8_C(x)	 x
+#define U8_C(x)  x ## U
+#define S16_C(x) x
+#define U16_C(x) x ## U
+#define S32_C(x) x
+#define U32_C(x) x ## U
+#define S64_C(x) x ## LL
+#define U64_C(x) x ## ULL
+
 typedef u32 dma_addr_t;
 typedef u32 dma64_addr_t;
 
diff --git a/include/asm-sparc64/types.h b/include/asm-sparc64/types.h
index d0ee7f1..6c0f4ce 100644
--- a/include/asm-sparc64/types.h
+++ b/include/asm-sparc64/types.h
@@ -51,6 +51,15 @@ typedef unsigned int u32;
 typedef __signed__ long s64;
 typedef unsigned long u64;
 
+#define S8_C(x)	 x
+#define U8_C(x)  x ## U
+#define S16_C(x) x
+#define U16_C(x) x ## U
+#define S32_C(x) x
+#define U32_C(x) x ## U
+#define S64_C(x) x ## L
+#define U64_C(x) x ## UL
+
 /* Dma addresses come in generic and 64-bit flavours.  */
 
 typedef u32 dma_addr_t;
diff --git a/include/asm-v850/types.h b/include/asm-v850/types.h
index 284bda8..6f406f7 100644
--- a/include/asm-v850/types.h
+++ b/include/asm-v850/types.h
@@ -55,6 +55,15 @@ typedef unsigned int u32;
 typedef signed long long s64;
 typedef unsigned long long u64;
 
+#define S8_C(x)	 x
+#define U8_C(x)  x ## U
+#define S16_C(x) x
+#define U16_C(x) x ## U
+#define S32_C(x) x
+#define U32_C(x) x ## U
+#define S64_C(x) x ## LL
+#define U64_C(x) x ## ULL
+
 /* Dma addresses are 32-bits wide.  */
 
 typedef u32 dma_addr_t;
diff --git a/include/asm-x86/types.h b/include/asm-x86/types.h
index 63733f3..089c9cd 100644
--- a/include/asm-x86/types.h
+++ b/include/asm-x86/types.h
@@ -56,6 +56,15 @@ typedef unsigned int u32;
 typedef signed long long s64;
 typedef unsigned long long u64;
 
+#define S8_C(x)	 x
+#define U8_C(x)  x ## U
+#define S16_C(x) x
+#define U16_C(x) x ## U
+#define S32_C(x) x
+#define U32_C(x) x ## U
+#define S64_C(x) x ## LL
+#define U64_C(x) x ## ULL
+
 typedef u64 dma64_addr_t;
 #if defined(CONFIG_X86_64) || defined(CONFIG_HIGHMEM64G)
 /* DMA addresses come in 32-bit and 64-bit flavours. */
diff --git a/include/asm-xtensa/types.h b/include/asm-xtensa/types.h
index b27d841..7e402e6 100644
--- a/include/asm-xtensa/types.h
+++ b/include/asm-xtensa/types.h
@@ -60,6 +60,14 @@ typedef unsigned int u32;
 typedef __signed__ long long s64;
 typedef unsigned long long u64;
 
+#define S8_C(x)	 x
+#define U8_C(x)  x ## U
+#define S16_C(x) x
+#define U16_C(x) x ## U
+#define S32_C(x) x
+#define U32_C(x) x ## U
+#define S64_C(x) x ## LL
+#define U64_C(x) x ## ULL
 
 #define BITS_PER_LONG 32
 
-- 
1.5.4.1

