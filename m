Return-Path: <linux-kernel-owner+w=401wt.eu-S932300AbZEAOyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300AbZEAOyc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 10:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761141AbZEAOm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 10:42:57 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:54902 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762047AbZEAOmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 10:42:53 -0400
Subject: [RFC][PATCH 32/35] Move users to asm-generic/ptemap.h
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Fri, 01 May 2009 07:42:51 -0700
References: <20090501144201.D31EF417@kernel>
In-Reply-To: <20090501144201.D31EF417@kernel>
Message-Id: <20090501144251.62441D55@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Now that we have everyone using pte_offset_kernel(),
we can plainy see that almost all the users are
exactly the same.

This takes all of those users and moves them over to
using asm-generic/ptemap.h instead.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/arch/alpha/include/asm/ptemap.h   |   10 ------
 linux-2.6.git-dave/arch/arm/include/asm/ptemap.h     |   10 ------
 linux-2.6.git-dave/arch/avr32/include/asm/ptemap.h   |   10 ------
 linux-2.6.git-dave/arch/cris/include/asm/ptemap.h    |   10 ------
 linux-2.6.git-dave/arch/frv/include/asm/ptemap.h     |    5 ---
 linux-2.6.git-dave/arch/ia64/include/asm/ptemap.h    |   10 ------
 linux-2.6.git-dave/arch/m32r/include/asm/ptemap.h    |   10 ------
 linux-2.6.git-dave/arch/m68k/include/asm/ptemap.h    |    5 ---
 linux-2.6.git-dave/arch/mips/include/asm/ptemap.h    |   10 ------
 linux-2.6.git-dave/arch/mn10300/include/asm/ptemap.h |   10 ------
 linux-2.6.git-dave/arch/parisc/include/asm/ptemap.h  |   13 --------
 linux-2.6.git-dave/arch/powerpc/include/asm/ptemap.h |    5 ---
 linux-2.6.git-dave/arch/s390/include/asm/ptemap.h    |   10 ------
 linux-2.6.git-dave/arch/sh/include/asm/ptemap.h      |   10 ------
 linux-2.6.git-dave/arch/sparc/include/asm/ptemap.h   |   30 -------------------
 linux-2.6.git-dave/arch/um/include/asm/ptemap.h      |   10 ------
 linux-2.6.git-dave/arch/x86/include/asm/ptemap.h     |    5 ---
 linux-2.6.git-dave/arch/xtensa/include/asm/ptemap.h  |   11 ------
 linux-2.6.git-dave/include/asm-generic/ptemap.h      |    9 +++++
 19 files changed, 27 insertions(+), 166 deletions(-)

diff -puN arch/alpha/include/asm/ptemap.h~asm-generic-ptemap-h arch/alpha/include/asm/ptemap.h
--- linux-2.6.git/arch/alpha/include/asm/ptemap.h~asm-generic-ptemap-h	2009-04-30 15:11:11.000000000 -0700
+++ linux-2.6.git-dave/arch/alpha/include/asm/ptemap.h	2009-04-30 15:11:11.000000000 -0700
@@ -1,9 +1 @@
-#ifndef _ALPHA_ASM_PTEMAP_H
-#define _ALPHA_ASM_PTEMAP_H
-
-#define pte_offset_map(dir,addr)	pte_offset_kernel((dir),(addr))
-#define pte_offset_map_nested(dir,addr)	pte_offset_kernel((dir),(addr))
-#define pte_unmap(pte)			do { } while (0)
-#define pte_unmap_nested(pte)		do { } while (0)
-
-#endif /* _ALPHA_ASM_PTEMAP_H */
+#include <asm-generic/ptemap.h>
diff -puN arch/arm/include/asm/ptemap.h~asm-generic-ptemap-h arch/arm/include/asm/ptemap.h
--- linux-2.6.git/arch/arm/include/asm/ptemap.h~asm-generic-ptemap-h	2009-04-30 15:11:11.000000000 -0700
+++ linux-2.6.git-dave/arch/arm/include/asm/ptemap.h	2009-04-30 15:11:11.000000000 -0700
@@ -1,9 +1 @@
-#ifndef _ARM_ASM_PTEMAP_H
-#define _ARM_ASM_PTEMAP_H
-
-#define pte_offset_map(dir,addr)	pte_offset_kernel(dir,addr)
-#define pte_offset_map_nested(dir,addr)	pte_offset_kernel(dir,addr)
-#define pte_unmap(pte)		do { } while (0)
-#define pte_unmap_nested(pte)	do { } while (0)
-
-#endif /* _ARM_ASM_PTEMAP_H */
+#include <asm-generic/ptemap.h>
diff -puN arch/avr32/include/asm/ptemap.h~asm-generic-ptemap-h arch/avr32/include/asm/ptemap.h
--- linux-2.6.git/arch/avr32/include/asm/ptemap.h~asm-generic-ptemap-h	2009-04-30 15:11:11.000000000 -0700
+++ linux-2.6.git-dave/arch/avr32/include/asm/ptemap.h	2009-04-30 15:11:11.000000000 -0700
@@ -1,9 +1 @@
-#ifndef _AVR32_ASM_PTEMAP_H
-#define _AVR32_ASM_PTEMAP_H
-
-#define pte_offset_map(dir, address) pte_offset_kernel(dir, address)
-#define pte_offset_map_nested(dir, address) pte_offset_kernel(dir, address)
-#define pte_unmap(pte)		do { } while (0)
-#define pte_unmap_nested(pte)	do { } while (0)
-
-#endif /* _AVR32_ASM_PTEMAP_H */
+#include <asm-generic/ptemap.h>
diff -puN arch/cris/include/asm/ptemap.h~asm-generic-ptemap-h arch/cris/include/asm/ptemap.h
--- linux-2.6.git/arch/cris/include/asm/ptemap.h~asm-generic-ptemap-h	2009-04-30 15:11:11.000000000 -0700
+++ linux-2.6.git-dave/arch/cris/include/asm/ptemap.h	2009-04-30 15:11:11.000000000 -0700
@@ -1,9 +1 @@
-#ifndef _CRIS_ASM_PTEMAP_H
-#define _CRIS_ASM_PTEMAP_H
-
-#define pte_offset_map(dir, address) pte_offset_kernel(dir, address)
-#define pte_offset_map_nested(dir, address) pte_offset_kernel(dir, address)
-#define pte_unmap(pte) do { } while (0)
-#define pte_unmap_nested(pte) do { } while (0)
-
-#endif /* _CRIS_ASM_PTEMAP_H */
+#include <asm-generic/ptemap.h>
diff -puN arch/frv/include/asm/ptemap.h~asm-generic-ptemap-h arch/frv/include/asm/ptemap.h
--- linux-2.6.git/arch/frv/include/asm/ptemap.h~asm-generic-ptemap-h	2009-04-30 15:11:11.000000000 -0700
+++ linux-2.6.git-dave/arch/frv/include/asm/ptemap.h	2009-04-30 15:11:11.000000000 -0700
@@ -9,10 +9,7 @@
 #define pte_unmap(pte) kunmap_atomic(pte, KM_PTE0)
 #define pte_unmap_nested(pte) kunmap_atomic((pte), KM_PTE1)
 #else
-#define pte_offset_map(dir, address)	pte_offset_kernel(dir, address)
-#define pte_offset_map_nested(dir, address)	pte_offset_kernel(dir, address)
-#define pte_unmap(pte) do { } while (0)
-#define pte_unmap_nested(pte) do { } while (0)
+#include <asm-generic/ptemap.h>
 #endif
 
 #endif /* _FRV_ASM_PTEMAP_H */
diff -puN arch/ia64/include/asm/ptemap.h~asm-generic-ptemap-h arch/ia64/include/asm/ptemap.h
--- linux-2.6.git/arch/ia64/include/asm/ptemap.h~asm-generic-ptemap-h	2009-04-30 15:11:11.000000000 -0700
+++ linux-2.6.git-dave/arch/ia64/include/asm/ptemap.h	2009-04-30 15:11:11.000000000 -0700
@@ -1,9 +1 @@
-#ifndef _IA64_ASM_PTEMAP_H
-#define _IA64_ASM_PTEMAP_H
-
-#define pte_offset_map(dir,addr)	pte_offset_kernel(dir, addr)
-#define pte_offset_map_nested(dir,addr)	pte_offset_map(dir, addr)
-#define pte_unmap(pte)			do { } while (0)
-#define pte_unmap_nested(pte)		do { } while (0)
-
-#endif /* _IA64_ASM_PTEMAP_H */
+#include <asm-generic/ptemap.h>
diff -puN arch/m32r/include/asm/ptemap.h~asm-generic-ptemap-h arch/m32r/include/asm/ptemap.h
--- linux-2.6.git/arch/m32r/include/asm/ptemap.h~asm-generic-ptemap-h	2009-04-30 15:11:11.000000000 -0700
+++ linux-2.6.git-dave/arch/m32r/include/asm/ptemap.h	2009-04-30 15:11:11.000000000 -0700
@@ -1,9 +1 @@
-#ifndef _M32R_ASM_PTEMAP_H
-#define _M32R_ASM_PTEMAP_H
-
-#define pte_offset_map(dir, address)	pte_offset_kernel(dir, address)
-#define pte_offset_map_nested(dir, address)	pte_offset_kernel(dir, address)
-#define pte_unmap(pte)		do { } while (0)
-#define pte_unmap_nested(pte)	do { } while (0)
-
-#endif /* _M32R_ASM_PTEMAP_H */
+#include <asm-generic/ptemap.h>
diff -puN arch/m68k/include/asm/ptemap.h~asm-generic-ptemap-h arch/m68k/include/asm/ptemap.h
--- linux-2.6.git/arch/m68k/include/asm/ptemap.h~asm-generic-ptemap-h	2009-04-30 15:11:11.000000000 -0700
+++ linux-2.6.git-dave/arch/m68k/include/asm/ptemap.h	2009-04-30 15:11:11.000000000 -0700
@@ -12,10 +12,7 @@
 
 #else /* !CONFIG_SUN3, Motorola */
 
-#define pte_offset_map(pmdp,address) pte_offset_kernel(pmdp, address)
-#define pte_offset_map_nested(pmdp, address) pte_offset_kernel(pmdp, address)
-#define pte_unmap(pte)		((void)0)
-#define pte_unmap_nested(pte)	((void)0)
+#include <asm-generic/ptemap.h>
 
 #endif /* CONFIG_SUN3 */
 
diff -puN arch/mips/include/asm/ptemap.h~asm-generic-ptemap-h arch/mips/include/asm/ptemap.h
--- linux-2.6.git/arch/mips/include/asm/ptemap.h~asm-generic-ptemap-h	2009-04-30 15:11:11.000000000 -0700
+++ linux-2.6.git-dave/arch/mips/include/asm/ptemap.h	2009-04-30 15:11:11.000000000 -0700
@@ -1,9 +1 @@
-#ifndef _MIPS_ASM_PTEMAP_H
-#define _MIPS_ASM_PTEMAP_H
-
-#define pte_offset_map(dir, address) pte_offset_kernel(dir, address)
-#define pte_offset_map_nested(dir, address) pte_offset_kernel(dir, address)
-#define pte_unmap(pte) ((void)(pte))
-#define pte_unmap_nested(pte) ((void)(pte))
-
-#endif /* _MIPS_ASM_PTEMAP_H */
+#include <asm-generic/ptemap.h>
diff -puN arch/mn10300/include/asm/ptemap.h~asm-generic-ptemap-h arch/mn10300/include/asm/ptemap.h
--- linux-2.6.git/arch/mn10300/include/asm/ptemap.h~asm-generic-ptemap-h	2009-04-30 15:11:11.000000000 -0700
+++ linux-2.6.git-dave/arch/mn10300/include/asm/ptemap.h	2009-04-30 15:11:11.000000000 -0700
@@ -1,9 +1 @@
-#ifndef _MN10300_ASM_PTEMAP_H
-#define _MN10300_ASM_PTEMAP_H
-
-#define pte_offset_map(dir, address) pte_offset_kernel(dir, address)
-#define pte_offset_map_nested(dir, address) pte_offset_kernel(dir, address)
-#define pte_unmap(pte)		do {} while (0)
-#define pte_unmap_nested(pte)	do {} while (0)
-
-#endif /* _MN10300_ASM_PTEMAP_H */
+#include <asm-generic/ptemap.h>
diff -puN arch/parisc/include/asm/ptemap.h~asm-generic-ptemap-h arch/parisc/include/asm/ptemap.h
--- linux-2.6.git/arch/parisc/include/asm/ptemap.h~asm-generic-ptemap-h	2009-04-30 15:11:11.000000000 -0700
+++ linux-2.6.git-dave/arch/parisc/include/asm/ptemap.h	2009-04-30 15:11:11.000000000 -0700
@@ -1,12 +1 @@
-#ifndef _PARISC_ASM_PTEMAP_H
-#define _PARISC_ASM_PTEMAP_H
-
-#define pte_offset_map(pmd, address) pte_offset_kernel(pmd, address)
-#define pte_offset_map_nested(pmd, address) pte_offset_kernel(pmd, address)
-#define pte_unmap(pte) do { } while (0)
-#define pte_unmap_nested(pte) do { } while (0)
-
-#define pte_unmap(pte)			do { } while (0)
-#define pte_unmap_nested(pte)		do { } while (0)
-
-#endif /* _PARISC_ASM_PTEMAP_H */
+#include <asm-generic/ptemap.h>
diff -puN arch/powerpc/include/asm/ptemap.h~asm-generic-ptemap-h arch/powerpc/include/asm/ptemap.h
--- linux-2.6.git/arch/powerpc/include/asm/ptemap.h~asm-generic-ptemap-h	2009-04-30 15:11:11.000000000 -0700
+++ linux-2.6.git-dave/arch/powerpc/include/asm/ptemap.h	2009-04-30 15:11:11.000000000 -0700
@@ -13,10 +13,7 @@
 
 #else /* __powerpc64__ */
 
-#define pte_offset_map(dir,addr)	pte_offset_kernel((dir), (addr))
-#define pte_offset_map_nested(dir,addr)	pte_offset_kernel((dir), (addr))
-#define pte_unmap(pte)			do { } while(0)
-#define pte_unmap_nested(pte)		do { } while(0)
+#include <asm-generic/ptemap.h>
 
 #endif
 
diff -puN arch/s390/include/asm/ptemap.h~asm-generic-ptemap-h arch/s390/include/asm/ptemap.h
--- linux-2.6.git/arch/s390/include/asm/ptemap.h~asm-generic-ptemap-h	2009-04-30 15:11:11.000000000 -0700
+++ linux-2.6.git-dave/arch/s390/include/asm/ptemap.h	2009-04-30 15:11:11.000000000 -0700
@@ -1,9 +1 @@
-#ifndef _S390_ASM_PTEMAP_H
-#define _S390_ASM_PTEMAP_H
-
-#define pte_offset_map(pmd, address) pte_offset_kernel(pmd, address)
-#define pte_offset_map_nested(pmd, address) pte_offset_kernel(pmd, address)
-#define pte_unmap(pte) do { } while (0)
-#define pte_unmap_nested(pte) do { } while (0)
-
-#endif /* _S390_ASM_PTEMAP_H */
+#include <asm-generic/ptemap.h>
diff -puN arch/sh/include/asm/ptemap.h~asm-generic-ptemap-h arch/sh/include/asm/ptemap.h
--- linux-2.6.git/arch/sh/include/asm/ptemap.h~asm-generic-ptemap-h	2009-04-30 15:11:11.000000000 -0700
+++ linux-2.6.git-dave/arch/sh/include/asm/ptemap.h	2009-04-30 15:11:11.000000000 -0700
@@ -1,9 +1 @@
-#ifndef _SH_ASM_PTEMAP_H
-#define _SH_ASM_PTEMAP_H
-
-#define pte_offset_map(dir, address)		pte_offset_kernel(dir, address)
-#define pte_offset_map_nested(dir, address)	pte_offset_kernel(dir, address)
-#define pte_unmap(pte)		do { } while (0)
-#define pte_unmap_nested(pte)	do { } while (0)
-
-#endif /* _SH_ASM_PTEMAP_H */
+#include <asm-generic/ptemap.h>
diff -puN arch/sparc/include/asm/ptemap.h~asm-generic-ptemap-h arch/sparc/include/asm/ptemap.h
--- linux-2.6.git/arch/sparc/include/asm/ptemap.h~asm-generic-ptemap-h	2009-04-30 15:11:11.000000000 -0700
+++ linux-2.6.git-dave/arch/sparc/include/asm/ptemap.h	2009-04-30 15:11:11.000000000 -0700
@@ -1,29 +1 @@
-#ifndef _SPARC_ASM_PTEMAP_H
-#define _SPARC_ASM_PTEMAP_H
-
-#if defined(__sparc__) && defined(__arch64__)
-
-/* Certain architectures need to do special things when pte's
- * within a page table are directly modified.  Thus, the following
- * hook is made available.
- */
-
-#define pte_offset_map(dir, address) pte_offset_kernel((dir), (address))
-#define pte_offset_map_nested(dir, address) pte_offset_kernel((dir), (address))
-#define pte_unmap(pte)			do { } while (0)
-#define pte_unmap_nested(pte)		do { } while (0)
-
-#else
-
- * This shortcut works on sun4m (and sun4d) because the nocache area is static,
- * and sun4c is guaranteed to have no highmem anyway.
- */
-#define pte_offset_map(d, a)		pte_offset_kernel(d,a)
-#define pte_offset_map_nested(d, a)	pte_offset_kernel(d,a)
-
-#define pte_unmap(pte)		do{}while(0)
-#define pte_unmap_nested(pte)	do{}while(0)
-
-#endif
-
-#endif /* _SPARC_ASM_PTEMAP_H *//*
+#include <asm-generic/ptemap.h>
diff -puN arch/um/include/asm/ptemap.h~asm-generic-ptemap-h arch/um/include/asm/ptemap.h
--- linux-2.6.git/arch/um/include/asm/ptemap.h~asm-generic-ptemap-h	2009-04-30 15:11:11.000000000 -0700
+++ linux-2.6.git-dave/arch/um/include/asm/ptemap.h	2009-04-30 15:11:11.000000000 -0700
@@ -1,9 +1 @@
-#ifndef _UM_ASM_PTEMAP_H
-#define _UM_ASM_PTEMAP_H
-
-#define pte_offset_map(dir, address) pte_offset_kernel(dir, address)
-#define pte_offset_map_nested(dir, address) pte_offset_kernel(dir, address)
-#define pte_unmap(pte) do { } while (0)
-#define pte_unmap_nested(pte) do { } while (0)
-
-#endif /* _UM_ASM_PTEMAP_H */
+#include <asm-generic/ptemap.h>
diff -puN arch/x86/include/asm/ptemap.h~asm-generic-ptemap-h arch/x86/include/asm/ptemap.h
--- linux-2.6.git/arch/x86/include/asm/ptemap.h~asm-generic-ptemap-h	2009-04-30 15:11:11.000000000 -0700
+++ linux-2.6.git-dave/arch/x86/include/asm/ptemap.h	2009-04-30 15:11:11.000000000 -0700
@@ -13,10 +13,7 @@
 
 #else /* !CONFIG_HIGHPTE */
 
-#define pte_offset_map(dir, address) pte_offset_kernel((dir), (address))
-#define pte_offset_map_nested(dir, address) pte_offset_kernel((dir), (address))
-#define pte_unmap(pte) do { } while (0)
-#define pte_unmap_nested(pte) do { } while (0)
+#include <asm-generic/ptemap.h>
 
 #endif
 
diff -puN arch/xtensa/include/asm/ptemap.h~asm-generic-ptemap-h arch/xtensa/include/asm/ptemap.h
--- linux-2.6.git/arch/xtensa/include/asm/ptemap.h~asm-generic-ptemap-h	2009-04-30 15:11:11.000000000 -0700
+++ linux-2.6.git-dave/arch/xtensa/include/asm/ptemap.h	2009-04-30 15:11:11.000000000 -0700
@@ -1,10 +1 @@
-#ifndef _XTENSA_ASM_PTEMAP_H
-#define _XTENSA_ASM_PTEMAP_H
-
-#define pte_offset_map(dir,addr)	pte_offset_kernel((dir),(addr))
-#define pte_offset_map_nested(dir,addr)	pte_offset_kernel((dir),(addr))
-
-#define pte_unmap(pte)		do { } while (0)
-#define pte_unmap_nested(pte)	do { } while (0)
-
-#endif /* _XTENSA_ASM_PTEMAP_H */
+#include <asm-generic/ptemap.h>
diff -puN /dev/null include/asm-generic/ptemap.h
--- /dev/null	2008-09-02 09:40:19.000000000 -0700
+++ linux-2.6.git-dave/include/asm-generic/ptemap.h	2009-04-30 15:11:11.000000000 -0700
@@ -0,0 +1,9 @@
+#ifndef _ASM_GENERIC_PTEMAP_H
+#define _ASM_GENERIC_PTEMAP_H
+
+#define pte_offset_map(dir,addr)	pte_offset_kernel((dir),(addr))
+#define pte_offset_map_nested(dir,addr)	pte_offset_kernel((dir),(addr))
+#define pte_unmap(pte)			do { } while (0)
+#define pte_unmap_nested(pte)		do { } while (0)
+
+#endif /* _ASM_GENERIC_PTEMAP_H */
_
