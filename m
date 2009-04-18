Return-Path: <linux-kernel-owner+w=401wt.eu-S1758156AbZDRBcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156AbZDRBcz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 21:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbZDRBcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 21:32:42 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:26688 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbZDRBcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 21:32:41 -0400
Date: Fri, 17 Apr 2009 18:32:10 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, linux-arch@vger.kernel.org
Subject: [PATCH] kmap_types: make most arches use generic header file
Message-Id: <20090417183210.6b704b24.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010204.49E92D6E.003C:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Convert most arch-es to use asm-generic/kmap_types.h.

Move the KM_FENCE_ macro additions into asm-generic/kmap_types.h,
controlled by __WITH_KM_FENCE from each arch's kmap_types.h file.

Would be nice to be able to add custom KM_types per arch, but I
don't yet see a nice, clean way to do that.

Built on x86_64, i386, mips, sparc, alpha(tonyb), powerpc(tonyb),
and 68k(tonyb).

Note: avr32 should be able to remove KM_PTE2 (since it's not used) and then
just use the generic kmap_types.h file.  Get avr32 maintainer approval.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: linux-arch@vger.kernel.org
---
 arch/alpha/include/asm/kmap_types.h      |   24 +++---------------------
 arch/blackfin/include/asm/kmap_types.h   |   17 +----------------
 arch/cris/include/asm/kmap_types.h       |   17 +----------------
 arch/h8300/include/asm/kmap_types.h      |   17 +----------------
 arch/ia64/include/asm/kmap_types.h       |   24 +++---------------------
 arch/m68k/include/asm/kmap_types.h       |   17 +----------------
 arch/microblaze/include/asm/kmap_types.h |   25 +------------------------
 arch/mips/include/asm/kmap_types.h       |   24 +++---------------------
 arch/mn10300/include/asm/kmap_types.h    |   27 +--------------------------
 arch/parisc/include/asm/kmap_types.h     |   24 +++---------------------
 arch/s390/include/asm/kmap_types.h       |   17 +----------------
 arch/sh/include/asm/kmap_types.h         |   24 +++---------------------
 arch/sparc/include/asm/kmap_types.h      |   17 +----------------
 arch/x86/include/asm/kmap_types.h        |   23 +++--------------------
 arch/xtensa/include/asm/kmap_types.h     |   27 +--------------------------
 include/asm-generic/kmap_types.h         |   29 +++++++++++++++++++++++++++++
 include/asm-m32r/kmap_types.h            |   23 +++--------------------
 17 files changed, 59 insertions(+), 317 deletions(-)

--- linux-2.6.30-rc2-git1.orig/arch/blackfin/include/asm/kmap_types.h
+++ linux-2.6.30-rc2-git1/arch/blackfin/include/asm/kmap_types.h
@@ -1,21 +1,6 @@
 #ifndef _ASM_KMAP_TYPES_H
 #define _ASM_KMAP_TYPES_H
 
-enum km_type {
-	KM_BOUNCE_READ,
-	KM_SKB_SUNRPC_DATA,
-	KM_SKB_DATA_SOFTIRQ,
-	KM_USER0,
-	KM_USER1,
-	KM_BIO_SRC_IRQ,
-	KM_BIO_DST_IRQ,
-	KM_PTE0,
-	KM_PTE1,
-	KM_IRQ0,
-	KM_IRQ1,
-	KM_SOFTIRQ0,
-	KM_SOFTIRQ1,
-	KM_TYPE_NR
-};
+#include <asm-generic/kmap_types.h>
 
 #endif
--- linux-2.6.30-rc2-git1.orig/arch/cris/include/asm/kmap_types.h
+++ linux-2.6.30-rc2-git1/arch/cris/include/asm/kmap_types.h
@@ -5,21 +5,6 @@
  * is actually used on cris. 
  */
 
-enum km_type {
-	KM_BOUNCE_READ,
-	KM_SKB_SUNRPC_DATA,
-	KM_SKB_DATA_SOFTIRQ,
-	KM_USER0,
-	KM_USER1,
-	KM_BIO_SRC_IRQ,
-	KM_BIO_DST_IRQ,
-	KM_PTE0,
-	KM_PTE1,
-	KM_IRQ0,
-	KM_IRQ1,
-	KM_SOFTIRQ0,
-	KM_SOFTIRQ1,
-	KM_TYPE_NR
-};
+#include <asm-generic/kmap_types.h>
 
 #endif
--- linux-2.6.30-rc2-git1.orig/arch/h8300/include/asm/kmap_types.h
+++ linux-2.6.30-rc2-git1/arch/h8300/include/asm/kmap_types.h
@@ -1,21 +1,6 @@
 #ifndef _ASM_H8300_KMAP_TYPES_H
 #define _ASM_H8300_KMAP_TYPES_H
 
-enum km_type {
-	KM_BOUNCE_READ,
-	KM_SKB_SUNRPC_DATA,
-	KM_SKB_DATA_SOFTIRQ,
-	KM_USER0,
-	KM_USER1,
-	KM_BIO_SRC_IRQ,
-	KM_BIO_DST_IRQ,
-	KM_PTE0,
-	KM_PTE1,
-	KM_IRQ0,
-	KM_IRQ1,
-	KM_SOFTIRQ0,
-	KM_SOFTIRQ1,
-	KM_TYPE_NR
-};
+#include <asm-generic/kmap_types.h>
 
 #endif
--- linux-2.6.30-rc2-git1.orig/arch/m68k/include/asm/kmap_types.h
+++ linux-2.6.30-rc2-git1/arch/m68k/include/asm/kmap_types.h
@@ -1,21 +1,6 @@
 #ifndef __ASM_M68K_KMAP_TYPES_H
 #define __ASM_M68K_KMAP_TYPES_H
 
-enum km_type {
-	KM_BOUNCE_READ,
-	KM_SKB_SUNRPC_DATA,
-	KM_SKB_DATA_SOFTIRQ,
-	KM_USER0,
-	KM_USER1,
-	KM_BIO_SRC_IRQ,
-	KM_BIO_DST_IRQ,
-	KM_PTE0,
-	KM_PTE1,
-	KM_IRQ0,
-	KM_IRQ1,
-	KM_SOFTIRQ0,
-	KM_SOFTIRQ1,
-	KM_TYPE_NR
-};
+#include <asm-generic/kmap_types.h>
 
 #endif	/* __ASM_M68K_KMAP_TYPES_H */
--- linux-2.6.30-rc2-git1.orig/arch/microblaze/include/asm/kmap_types.h
+++ linux-2.6.30-rc2-git1/arch/microblaze/include/asm/kmap_types.h
@@ -1,29 +1,6 @@
-/*
- * Copyright (C) 2006 Atmark Techno, Inc.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License. See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
 #ifndef _ASM_MICROBLAZE_KMAP_TYPES_H
 #define _ASM_MICROBLAZE_KMAP_TYPES_H
 
-enum km_type {
-	KM_BOUNCE_READ,
-	KM_SKB_SUNRPC_DATA,
-	KM_SKB_DATA_SOFTIRQ,
-	KM_USER0,
-	KM_USER1,
-	KM_BIO_SRC_IRQ,
-	KM_BIO_DST_IRQ,
-	KM_PTE0,
-	KM_PTE1,
-	KM_IRQ0,
-	KM_IRQ1,
-	KM_SOFTIRQ0,
-	KM_SOFTIRQ1,
-	KM_TYPE_NR,
-};
+#include <asm-generic/kmap_types.h>
 
 #endif /* _ASM_MICROBLAZE_KMAP_TYPES_H */
--- linux-2.6.30-rc2-git1.orig/arch/mn10300/include/asm/kmap_types.h
+++ linux-2.6.30-rc2-git1/arch/mn10300/include/asm/kmap_types.h
@@ -1,31 +1,6 @@
-/* MN10300 kmap_atomic() slot IDs
- *
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
 #ifndef _ASM_KMAP_TYPES_H
 #define _ASM_KMAP_TYPES_H
 
-enum km_type {
-	KM_BOUNCE_READ,
-	KM_SKB_SUNRPC_DATA,
-	KM_SKB_DATA_SOFTIRQ,
-	KM_USER0,
-	KM_USER1,
-	KM_BIO_SRC_IRQ,
-	KM_BIO_DST_IRQ,
-	KM_PTE0,
-	KM_PTE1,
-	KM_IRQ0,
-	KM_IRQ1,
-	KM_SOFTIRQ0,
-	KM_SOFTIRQ1,
-	KM_TYPE_NR
-};
+#include <asm-generic/kmap_types.h>
 
 #endif /* _ASM_KMAP_TYPES_H */
--- linux-2.6.30-rc2-git1.orig/arch/s390/include/asm/kmap_types.h
+++ linux-2.6.30-rc2-git1/arch/s390/include/asm/kmap_types.h
@@ -2,22 +2,7 @@
 #ifndef _ASM_KMAP_TYPES_H
 #define _ASM_KMAP_TYPES_H
 
-enum km_type {
-	KM_BOUNCE_READ,
-	KM_SKB_SUNRPC_DATA,
-	KM_SKB_DATA_SOFTIRQ,
-	KM_USER0,
-	KM_USER1,
-	KM_BIO_SRC_IRQ,
-	KM_BIO_DST_IRQ,
-	KM_PTE0,
-	KM_PTE1,
-	KM_IRQ0,
-	KM_IRQ1,
-	KM_SOFTIRQ0,
-	KM_SOFTIRQ1,	
-	KM_TYPE_NR
-};
+#include <asm-generic/kmap_types.h>
 
 #endif
 #endif /* __KERNEL__ */
--- linux-2.6.30-rc2-git1.orig/arch/sparc/include/asm/kmap_types.h
+++ linux-2.6.30-rc2-git1/arch/sparc/include/asm/kmap_types.h
@@ -5,21 +5,6 @@
  * is actually used on sparc.  -DaveM
  */
 
-enum km_type {
-	KM_BOUNCE_READ,
-	KM_SKB_SUNRPC_DATA,
-	KM_SKB_DATA_SOFTIRQ,
-	KM_USER0,
-	KM_USER1,
-	KM_BIO_SRC_IRQ,
-	KM_BIO_DST_IRQ,
-	KM_PTE0,
-	KM_PTE1,
-	KM_IRQ0,
-	KM_IRQ1,
-	KM_SOFTIRQ0,
-	KM_SOFTIRQ1,
-	KM_TYPE_NR
-};
+#include <asm-generic/kmap_types.h>
 
 #endif
--- linux-2.6.30-rc2-git1.orig/arch/xtensa/include/asm/kmap_types.h
+++ linux-2.6.30-rc2-git1/arch/xtensa/include/asm/kmap_types.h
@@ -1,31 +1,6 @@
-/*
- * include/asm-xtensa/kmap_types.h
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2001 - 2005 Tensilica Inc.
- */
-
 #ifndef _XTENSA_KMAP_TYPES_H
 #define _XTENSA_KMAP_TYPES_H
 
-enum km_type {
-  KM_BOUNCE_READ,
-  KM_SKB_SUNRPC_DATA,
-  KM_SKB_DATA_SOFTIRQ,
-  KM_USER0,
-  KM_USER1,
-  KM_BIO_SRC_IRQ,
-  KM_BIO_DST_IRQ,
-  KM_PTE0,
-  KM_PTE1,
-  KM_IRQ0,
-  KM_IRQ1,
-  KM_SOFTIRQ0,
-  KM_SOFTIRQ1,
-  KM_TYPE_NR
-};
+#include <asm-generic/kmap_types.h>
 
 #endif	/* _XTENSA_KMAP_TYPES_H */
--- /dev/null
+++ linux-2.6.30-rc2-git1/include/asm-generic/kmap_types.h
@@ -0,0 +1,29 @@
+#ifndef _ASM_GENERIC_KMAP_TYPES_H
+#define _ASM_GENERIC_KMAP_TYPES_H
+
+#ifdef __WITH_KM_FENCE
+# define D(n) __KM_FENCE_##n ,
+#else
+# define D(n)
+#endif
+
+enum km_type {
+D(0)	KM_BOUNCE_READ,
+D(1)	KM_SKB_SUNRPC_DATA,
+D(2)	KM_SKB_DATA_SOFTIRQ,
+D(3)	KM_USER0,
+D(4)	KM_USER1,
+D(5)	KM_BIO_SRC_IRQ,
+D(6)	KM_BIO_DST_IRQ,
+D(7)	KM_PTE0,
+D(8)	KM_PTE1,
+D(9)	KM_IRQ0,
+D(10)	KM_IRQ1,
+D(11)	KM_SOFTIRQ0,
+D(12)	KM_SOFTIRQ1,
+D(13)	KM_TYPE_NR
+};
+
+#undef D
+
+#endif
--- linux-2.6.30-rc2-git1.orig/arch/alpha/include/asm/kmap_types.h
+++ linux-2.6.30-rc2-git1/arch/alpha/include/asm/kmap_types.h
@@ -3,30 +3,12 @@
 
 /* Dummy header just to define km_type. */
 
-
 #ifdef CONFIG_DEBUG_HIGHMEM
-# define D(n) __KM_FENCE_##n ,
-#else
-# define D(n)
+#define  __WITH_KM_FENCE
 #endif
 
-enum km_type {
-D(0)	KM_BOUNCE_READ,
-D(1)	KM_SKB_SUNRPC_DATA,
-D(2)	KM_SKB_DATA_SOFTIRQ,
-D(3)	KM_USER0,
-D(4)	KM_USER1,
-D(5)	KM_BIO_SRC_IRQ,
-D(6)	KM_BIO_DST_IRQ,
-D(7)	KM_PTE0,
-D(8)	KM_PTE1,
-D(9)	KM_IRQ0,
-D(10)	KM_IRQ1,
-D(11)	KM_SOFTIRQ0,
-D(12)	KM_SOFTIRQ1,
-D(13)	KM_TYPE_NR
-};
+#include <asm-generic/kmap_types.h>
 
-#undef D
+#undef __WITH_KM_FENCE
 
 #endif
--- linux-2.6.30-rc2-git1.orig/arch/ia64/include/asm/kmap_types.h
+++ linux-2.6.30-rc2-git1/arch/ia64/include/asm/kmap_types.h
@@ -1,30 +1,12 @@
 #ifndef _ASM_IA64_KMAP_TYPES_H
 #define _ASM_IA64_KMAP_TYPES_H
 
-
 #ifdef CONFIG_DEBUG_HIGHMEM
-# define D(n) __KM_FENCE_##n ,
-#else
-# define D(n)
+#define  __WITH_KM_FENCE
 #endif
 
-enum km_type {
-D(0)	KM_BOUNCE_READ,
-D(1)	KM_SKB_SUNRPC_DATA,
-D(2)	KM_SKB_DATA_SOFTIRQ,
-D(3)	KM_USER0,
-D(4)	KM_USER1,
-D(5)	KM_BIO_SRC_IRQ,
-D(6)	KM_BIO_DST_IRQ,
-D(7)	KM_PTE0,
-D(8)	KM_PTE1,
-D(9)	KM_IRQ0,
-D(10)	KM_IRQ1,
-D(11)	KM_SOFTIRQ0,
-D(12)	KM_SOFTIRQ1,
-D(13)	KM_TYPE_NR
-};
+#include <asm-generic/kmap_types.h>
 
-#undef D
+#undef __WITH_KM_FENCE
 
 #endif /* _ASM_IA64_KMAP_TYPES_H */
--- linux-2.6.30-rc2-git1.orig/arch/mips/include/asm/kmap_types.h
+++ linux-2.6.30-rc2-git1/arch/mips/include/asm/kmap_types.h
@@ -1,30 +1,12 @@
 #ifndef _ASM_KMAP_TYPES_H
 #define _ASM_KMAP_TYPES_H
 
-
 #ifdef CONFIG_DEBUG_HIGHMEM
-# define D(n) __KM_FENCE_##n ,
-#else
-# define D(n)
+#define  __WITH_KM_FENCE
 #endif
 
-enum km_type {
-D(0)	KM_BOUNCE_READ,
-D(1)	KM_SKB_SUNRPC_DATA,
-D(2)	KM_SKB_DATA_SOFTIRQ,
-D(3)	KM_USER0,
-D(4)	KM_USER1,
-D(5)	KM_BIO_SRC_IRQ,
-D(6)	KM_BIO_DST_IRQ,
-D(7)	KM_PTE0,
-D(8)	KM_PTE1,
-D(9)	KM_IRQ0,
-D(10)	KM_IRQ1,
-D(11)	KM_SOFTIRQ0,
-D(12)	KM_SOFTIRQ1,
-D(13)	KM_TYPE_NR
-};
+#include <asm-generic/kmap_types.h>
 
-#undef D
+#undef __WITH_KM_FENCE
 
 #endif
--- linux-2.6.30-rc2-git1.orig/arch/parisc/include/asm/kmap_types.h
+++ linux-2.6.30-rc2-git1/arch/parisc/include/asm/kmap_types.h
@@ -1,30 +1,12 @@
 #ifndef _ASM_KMAP_TYPES_H
 #define _ASM_KMAP_TYPES_H
 
-
 #ifdef CONFIG_DEBUG_HIGHMEM
-# define D(n) __KM_FENCE_##n ,
-#else
-# define D(n)
+#define  __WITH_KM_FENCE
 #endif
 
-enum km_type {
-D(0)	KM_BOUNCE_READ,
-D(1)	KM_SKB_SUNRPC_DATA,
-D(2)	KM_SKB_DATA_SOFTIRQ,
-D(3)	KM_USER0,
-D(4)	KM_USER1,
-D(5)	KM_BIO_SRC_IRQ,
-D(6)	KM_BIO_DST_IRQ,
-D(7)	KM_PTE0,
-D(8)	KM_PTE1,
-D(9)	KM_IRQ0,
-D(10)	KM_IRQ1,
-D(11)	KM_SOFTIRQ0,
-D(12)	KM_SOFTIRQ1,
-D(13)	KM_TYPE_NR
-};
+#include <asm-generic/kmap_types.h>
 
-#undef D
+#undef __WITH_KM_FENCE
 
 #endif
--- linux-2.6.30-rc2-git1.orig/arch/sh/include/asm/kmap_types.h
+++ linux-2.6.30-rc2-git1/arch/sh/include/asm/kmap_types.h
@@ -3,30 +3,12 @@
 
 /* Dummy header just to define km_type. */
 
-
 #ifdef CONFIG_DEBUG_HIGHMEM
-# define D(n) __KM_FENCE_##n ,
-#else
-# define D(n)
+#define  __WITH_KM_FENCE
 #endif
 
-enum km_type {
-D(0)	KM_BOUNCE_READ,
-D(1)	KM_SKB_SUNRPC_DATA,
-D(2)	KM_SKB_DATA_SOFTIRQ,
-D(3)	KM_USER0,
-D(4)	KM_USER1,
-D(5)	KM_BIO_SRC_IRQ,
-D(6)	KM_BIO_DST_IRQ,
-D(7)	KM_PTE0,
-D(8)	KM_PTE1,
-D(9)	KM_IRQ0,
-D(10)	KM_IRQ1,
-D(11)	KM_SOFTIRQ0,
-D(12)	KM_SOFTIRQ1,
-D(13)	KM_TYPE_NR
-};
+#include <asm-generic/kmap_types.h>
 
-#undef D
+#undef __WITH_KM_FENCE
 
 #endif
--- linux-2.6.30-rc2-git1.orig/arch/x86/include/asm/kmap_types.h
+++ linux-2.6.30-rc2-git1/arch/x86/include/asm/kmap_types.h
@@ -2,28 +2,11 @@
 #define _ASM_X86_KMAP_TYPES_H
 
 #if defined(CONFIG_X86_32) && defined(CONFIG_DEBUG_HIGHMEM)
-# define D(n) __KM_FENCE_##n ,
-#else
-# define D(n)
+#define  __WITH_KM_FENCE
 #endif
 
-enum km_type {
-D(0)	KM_BOUNCE_READ,
-D(1)	KM_SKB_SUNRPC_DATA,
-D(2)	KM_SKB_DATA_SOFTIRQ,
-D(3)	KM_USER0,
-D(4)	KM_USER1,
-D(5)	KM_BIO_SRC_IRQ,
-D(6)	KM_BIO_DST_IRQ,
-D(7)	KM_PTE0,
-D(8)	KM_PTE1,
-D(9)	KM_IRQ0,
-D(10)	KM_IRQ1,
-D(11)	KM_SOFTIRQ0,
-D(12)	KM_SOFTIRQ1,
-D(13)	KM_TYPE_NR
-};
+#include <asm-generic/kmap_types.h>
 
-#undef D
+#undef __WITH_KM_FENCE
 
 #endif /* _ASM_X86_KMAP_TYPES_H */
--- linux-2.6.30-rc2-git1.orig/include/asm-m32r/kmap_types.h
+++ linux-2.6.30-rc2-git1/include/asm-m32r/kmap_types.h
@@ -2,28 +2,11 @@
 #define __M32R_KMAP_TYPES_H
 
 #ifdef CONFIG_DEBUG_HIGHMEM
-# define D(n) __KM_FENCE_##n ,
-#else
-# define D(n)
+#define  __WITH_KM_FENCE
 #endif
 
-enum km_type {
-D(0)	KM_BOUNCE_READ,
-D(1)	KM_SKB_SUNRPC_DATA,
-D(2)	KM_SKB_DATA_SOFTIRQ,
-D(3)	KM_USER0,
-D(4)	KM_USER1,
-D(5)	KM_BIO_SRC_IRQ,
-D(6)	KM_BIO_DST_IRQ,
-D(7)	KM_PTE0,
-D(8)	KM_PTE1,
-D(9)	KM_IRQ0,
-D(10)	KM_IRQ1,
-D(11)	KM_SOFTIRQ0,
-D(12)	KM_SOFTIRQ1,
-D(13)	KM_TYPE_NR
-};
+#include <asm-generic/kmap_types.h>
 
-#undef D
+#undef __WITH_KM_FENCE
 
 #endif /* __M32R_KMAP_TYPES_H */
