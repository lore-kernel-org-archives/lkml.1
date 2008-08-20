Return-Path: <linux-kernel-owner+w=401wt.eu-S1757363AbYHTBnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363AbYHTBnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 21:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757047AbYHTBn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 21:43:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:25036 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757029AbYHTBn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 21:43:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,238,1217833200"; 
   d="scan'208";a="327565758"
Subject: [PATCH -mm -v2 1/2] Separate atomic_t declaration from
	asm/atomic.h into asm/atomic_def.h
From: Huang Ying <ying.huang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Wed, 20 Aug 2008 09:42:57 +0800
Message-Id: <1219196577.5663.128.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

asm/atomic.h contains both declaration and implementation of
atomic_t. So there are some implementation related files included in
asm/atomic.h. And atomic_t is a typedef. Combination of above makes it
impossible to use atomic_t in files included by atomic.h. Such as
atomic_t can not be used in linux/kernel.h on i386, because it is
included by asm/atomic.h.

>From the perspective of engineering, it is reasonable to separate
declaration from implementation. So a new file atomic_def.h is added
for every architecture to accommodate the declaration of atomic_t.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 include/asm-alpha/atomic.h         |   10 +---------
 include/asm-alpha/atomic_def.h     |   13 +++++++++++++
 include/asm-arm/atomic.h           |    3 +--
 include/asm-arm/atomic_def.h       |    6 ++++++
 include/asm-avr32/atomic.h         |    2 +-
 include/asm-avr32/atomic_def.h     |    6 ++++++
 include/asm-blackfin/atomic.h      |    4 +---
 include/asm-blackfin/atomic_def.h  |    8 ++++++++
 include/asm-cris/atomic.h          |    3 +--
 include/asm-cris/atomic_def.h      |    6 ++++++
 include/asm-frv/atomic.h           |    5 +----
 include/asm-frv/atomic_def.h       |    8 ++++++++
 include/asm-h8300/atomic.h         |    3 ++-
 include/asm-h8300/atomic_def.h     |    6 ++++++
 include/asm-ia64/atomic.h          |    8 +-------
 include/asm-ia64/atomic_def.h      |   11 +++++++++++
 include/asm-m32r/atomic.h          |    8 +-------
 include/asm-m32r/atomic_def.h      |   11 +++++++++++
 include/asm-m68k/atomic.h          |    2 +-
 include/asm-m68k/atomic_def.h      |    6 ++++++
 include/asm-m68knommu/atomic.h     |    2 +-
 include/asm-m68knommu/atomic_def.h |    6 ++++++
 include/asm-mips/atomic.h          |    3 +--
 include/asm-mips/atomic_def.h      |    6 ++++++
 include/asm-mn10300/atomic.h       |   11 ++---------
 include/asm-mn10300/atomic_def.h   |   13 +++++++++++++
 include/asm-powerpc/atomic.h       |    2 +-
 include/asm-powerpc/atomic_def.h   |    6 ++++++
 include/asm-s390/atomic.h          |    4 +---
 include/asm-s390/atomic_def.h      |    8 ++++++++
 include/asm-um/atomic_def.h        |    6 ++++++
 include/asm-x86/atomic_32.h        |   10 +---------
 include/asm-x86/atomic_64.h        |   10 +---------
 include/asm-x86/atomic_def.h       |   13 +++++++++++++
 include/asm-xtensa/atomic.h        |    3 +--
 include/asm-xtensa/atomic_def.h    |    6 ++++++
 36 files changed, 165 insertions(+), 73 deletions(-)

--- a/include/asm-x86/atomic_32.h
+++ b/include/asm-x86/atomic_32.h
@@ -4,21 +4,13 @@
 #include <linux/compiler.h>
 #include <asm/processor.h>
 #include <asm/cmpxchg.h>
+#include <asm/atomic_def.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
  * resource counting etc..
  */
 
-/*
- * Make sure gcc doesn't try to be clever and move things around
- * on us. We need to use _exactly_ the address the user gave us,
- * not some alias that contains the same information.
- */
-typedef struct {
-	int counter;
-} atomic_t;
-
 #define ATOMIC_INIT(i)	{ (i) }
 
 /**
--- a/include/asm-x86/atomic_64.h
+++ b/include/asm-x86/atomic_64.h
@@ -3,6 +3,7 @@
 
 #include <asm/alternative.h>
 #include <asm/cmpxchg.h>
+#include <asm/atomic_def.h>
 
 /* atomic_t should be 32 bit signed type */
 
@@ -11,15 +12,6 @@
  * resource counting etc..
  */
 
-/*
- * Make sure gcc doesn't try to be clever and move things around
- * on us. We need to use _exactly_ the address the user gave us,
- * not some alias that contains the same information.
- */
-typedef struct {
-	int counter;
-} atomic_t;
-
 #define ATOMIC_INIT(i)	{ (i) }
 
 /**
--- a/include/asm-alpha/atomic.h
+++ b/include/asm-alpha/atomic.h
@@ -3,6 +3,7 @@
 
 #include <asm/barrier.h>
 #include <asm/system.h>
+#include <asm/atomic_def.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
@@ -12,15 +13,6 @@
  * than regular operations.
  */
 
-
-/*
- * Counter is volatile to make sure gcc doesn't try to be clever
- * and move things around on us. We need to use _exactly_ the address
- * the user gave us, not some alias that contains the same information.
- */
-typedef struct { volatile int counter; } atomic_t;
-typedef struct { volatile long counter; } atomic64_t;
-
 #define ATOMIC_INIT(i)		( (atomic_t) { (i) } )
 #define ATOMIC64_INIT(i)	( (atomic64_t) { (i) } )
 
--- /dev/null
+++ b/include/asm-alpha/atomic_def.h
@@ -0,0 +1,13 @@
+#ifndef _ALPHA_ATOMIC_DEF_H
+#define _ALPHA_ATOMIC_DEF_H
+
+
+/*
+ * Counter is volatile to make sure gcc doesn't try to be clever
+ * and move things around on us. We need to use _exactly_ the address
+ * the user gave us, not some alias that contains the same information.
+ */
+typedef struct { volatile int counter; } atomic_t;
+typedef struct { volatile long counter; } atomic64_t;
+
+#endif
--- /dev/null
+++ b/include/asm-x86/atomic_def.h
@@ -0,0 +1,13 @@
+#ifndef __ARCH_X86_ATOMIC_DEF__
+#define __ARCH_X86_ATOMIC_DEF__
+
+/*
+ * Make sure gcc doesn't try to be clever and move things around
+ * on us. We need to use _exactly_ the address the user gave us,
+ * not some alias that contains the same information.
+ */
+typedef struct {
+	int counter;
+} atomic_t;
+
+#endif
--- a/include/asm-arm/atomic.h
+++ b/include/asm-arm/atomic.h
@@ -13,8 +13,7 @@
 
 #include <linux/compiler.h>
 #include <asm/system.h>
-
-typedef struct { volatile int counter; } atomic_t;
+#include <asm/atomic_def.h>
 
 #define ATOMIC_INIT(i)	{ (i) }
 
--- /dev/null
+++ b/include/asm-arm/atomic_def.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_ARM_ATOMIC_DEF_H
+#define __ASM_ARM_ATOMIC_DEF_H
+
+typedef struct { volatile int counter; } atomic_t;
+
+#endif
--- /dev/null
+++ b/include/asm-avr32/atomic_def.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_AVR32_ATOMIC_DEF_H
+#define __ASM_AVR32_ATOMIC_DEF_H
+
+typedef struct { volatile int counter; } atomic_t;
+
+#endif
--- a/include/asm-avr32/atomic.h
+++ b/include/asm-avr32/atomic.h
@@ -15,8 +15,8 @@
 #define __ASM_AVR32_ATOMIC_H
 
 #include <asm/system.h>
+#include <asm/atomic_def.h>
 
-typedef struct { volatile int counter; } atomic_t;
 #define ATOMIC_INIT(i)  { (i) }
 
 #define atomic_read(v)		((v)->counter)
--- /dev/null
+++ b/include/asm-blackfin/atomic_def.h
@@ -0,0 +1,8 @@
+#ifndef __ARCH_BLACKFIN_ATOMIC_DEF__
+#define __ARCH_BLACKFIN_ATOMIC_DEF__
+
+typedef struct {
+	int counter;
+} atomic_t;
+
+#endif
--- a/include/asm-blackfin/atomic.h
+++ b/include/asm-blackfin/atomic.h
@@ -2,6 +2,7 @@
 #define __ARCH_BLACKFIN_ATOMIC__
 
 #include <asm/system.h>	/* local_irq_XXX() */
+#include <asm/atomic_def.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
@@ -13,9 +14,6 @@
  * Tony Kou (tonyko@lineo.ca)   Lineo Inc.   2001
  */
 
-typedef struct {
-	int counter;
-} atomic_t;
 #define ATOMIC_INIT(i)	{ (i) }
 
 #define atomic_read(v)		((v)->counter)
--- a/include/asm-cris/atomic.h
+++ b/include/asm-cris/atomic.h
@@ -7,14 +7,13 @@
 
 #include <asm/system.h>
 #include <asm/arch/atomic.h>
+#include <asm/atomic_def.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
  * resource counting etc..
  */
 
-typedef struct { volatile int counter; } atomic_t;
-
 #define ATOMIC_INIT(i)  { (i) }
 
 #define atomic_read(v) ((v)->counter)
--- /dev/null
+++ b/include/asm-cris/atomic_def.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_CRIS_ATOMIC_DEF__
+#define __ASM_CRIS_ATOMIC_DEF__
+
+typedef struct { volatile int counter; } atomic_t;
+
+#endif
--- /dev/null
+++ b/include/asm-frv/atomic_def.h
@@ -0,0 +1,8 @@
+#ifndef _ASM_ATOMIC_DEF_H
+#define _ASM_ATOMIC_DEF_H
+
+typedef struct {
+	int counter;
+} atomic_t;
+
+#endif
--- a/include/asm-frv/atomic.h
+++ b/include/asm-frv/atomic.h
@@ -17,6 +17,7 @@
 #include <linux/types.h>
 #include <asm/spr-regs.h>
 #include <asm/system.h>
+#include <asm/atomic_def.h>
 
 #ifdef CONFIG_SMP
 #error not SMP safe
@@ -35,10 +36,6 @@
 #define smp_mb__before_atomic_inc()	barrier()
 #define smp_mb__after_atomic_inc()	barrier()
 
-typedef struct {
-	int counter;
-} atomic_t;
-
 #define ATOMIC_INIT(i)		{ (i) }
 #define atomic_read(v)		((v)->counter)
 #define atomic_set(v, i)	(((v)->counter) = (i))
--- /dev/null
+++ b/include/asm-h8300/atomic_def.h
@@ -0,0 +1,6 @@
+#ifndef __ARCH_H8300_ATOMIC_DEF__
+#define __ARCH_H8300_ATOMIC_DEF__
+
+typedef struct { int counter; } atomic_t;
+
+#endif
--- a/include/asm-h8300/atomic.h
+++ b/include/asm-h8300/atomic.h
@@ -1,12 +1,13 @@
 #ifndef __ARCH_H8300_ATOMIC__
 #define __ARCH_H8300_ATOMIC__
 
+#include <asm/atomic_def.h>
+
 /*
  * Atomic operations that C can't guarantee us.  Useful for
  * resource counting etc..
  */
 
-typedef struct { int counter; } atomic_t;
 #define ATOMIC_INIT(i)	{ (i) }
 
 #define atomic_read(v)		((v)->counter)
--- a/include/asm-ia64/atomic.h
+++ b/include/asm-ia64/atomic.h
@@ -16,13 +16,7 @@
 
 #include <asm/intrinsics.h>
 #include <asm/system.h>
-
-/*
- * On IA-64, counter must always be volatile to ensure that that the
- * memory accesses are ordered.
- */
-typedef struct { volatile __s32 counter; } atomic_t;
-typedef struct { volatile __s64 counter; } atomic64_t;
+#include <asm/atomic_def.h>
 
 #define ATOMIC_INIT(i)		((atomic_t) { (i) })
 #define ATOMIC64_INIT(i)	((atomic64_t) { (i) })
--- /dev/null
+++ b/include/asm-m32r/atomic_def.h
@@ -0,0 +1,11 @@
+#ifndef _ASM_M32R_ATOMIC_DEF_H
+#define _ASM_M32R_ATOMIC_DEF_H
+
+/*
+ * Make sure gcc doesn't try to be clever and move things around
+ * on us. We need to use _exactly_ the address the user gave us,
+ * not some alias that contains the same information.
+ */
+typedef struct { volatile int counter; } atomic_t;
+
+#endif
--- a/include/asm-m32r/atomic.h
+++ b/include/asm-m32r/atomic.h
@@ -11,19 +11,13 @@
 
 #include <asm/assembler.h>
 #include <asm/system.h>
+#include <asm/atomic_def.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
  * resource counting etc..
  */
 
-/*
- * Make sure gcc doesn't try to be clever and move things around
- * on us. We need to use _exactly_ the address the user gave us,
- * not some alias that contains the same information.
- */
-typedef struct { volatile int counter; } atomic_t;
-
 #define ATOMIC_INIT(i)	{ (i) }
 
 /**
--- /dev/null
+++ b/include/asm-m68k/atomic_def.h
@@ -0,0 +1,6 @@
+#ifndef __ARCH_M68K_ATOMIC_DEF__
+#define __ARCH_M68K_ATOMIC_DEF__
+
+typedef struct { int counter; } atomic_t;
+
+#endif
--- a/include/asm-m68k/atomic.h
+++ b/include/asm-m68k/atomic.h
@@ -3,6 +3,7 @@
 
 
 #include <asm/system.h>
+#include <asm/atomic_def.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
@@ -13,7 +14,6 @@
  * We do not have SMP m68k systems, so we don't have to deal with that.
  */
 
-typedef struct { int counter; } atomic_t;
 #define ATOMIC_INIT(i)	{ (i) }
 
 #define atomic_read(v)		((v)->counter)
--- /dev/null
+++ b/include/asm-m68knommu/atomic_def.h
@@ -0,0 +1,6 @@
+#ifndef __ARCH_M68KNOMMU_ATOMIC_DEF__
+#define __ARCH_M68KNOMMU_ATOMIC_DEF__
+
+typedef struct { int counter; } atomic_t;
+
+#endif
--- a/include/asm-m68knommu/atomic.h
+++ b/include/asm-m68knommu/atomic.h
@@ -2,6 +2,7 @@
 #define __ARCH_M68KNOMMU_ATOMIC__
 
 #include <asm/system.h>
+#include <asm/atomic_def.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
@@ -12,7 +13,6 @@
  * We do not have SMP m68k systems, so we don't have to deal with that.
  */
 
-typedef struct { int counter; } atomic_t;
 #define ATOMIC_INIT(i)	{ (i) }
 
 #define atomic_read(v)		((v)->counter)
--- /dev/null
+++ b/include/asm-mips/atomic_def.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_ATOMIC_DEF_H
+#define _ASM_ATOMIC_DEF_H
+
+typedef struct { volatile int counter; } atomic_t;
+
+#endif
--- a/include/asm-mips/atomic.h
+++ b/include/asm-mips/atomic.h
@@ -19,8 +19,7 @@
 #include <asm/cpu-features.h>
 #include <asm/war.h>
 #include <asm/system.h>
-
-typedef struct { volatile int counter; } atomic_t;
+#include <asm/atomic_def.h>
 
 #define ATOMIC_INIT(i)    { (i) }
 
--- /dev/null
+++ b/include/asm-mn10300/atomic_def.h
@@ -0,0 +1,13 @@
+#ifndef _ASM_ATOMIC_DEF_H
+#define _ASM_ATOMIC_DEF_H
+
+/*
+ * Make sure gcc doesn't try to be clever and move things around
+ * on us. We need to use _exactly_ the address the user gave us,
+ * not some alias that contains the same information.
+ */
+typedef struct {
+	int	counter;
+} atomic_t;
+
+#endif
--- a/include/asm-mn10300/atomic.h
+++ b/include/asm-mn10300/atomic.h
@@ -11,6 +11,8 @@
 #ifndef _ASM_ATOMIC_H
 #define _ASM_ATOMIC_H
 
+#include <asm/atomic_def.h>
+
 #ifdef CONFIG_SMP
 #error not SMP safe
 #endif
@@ -20,15 +22,6 @@
  * resource counting etc..
  */
 
-/*
- * Make sure gcc doesn't try to be clever and move things around
- * on us. We need to use _exactly_ the address the user gave us,
- * not some alias that contains the same information.
- */
-typedef struct {
-	int	counter;
-} atomic_t;
-
 #define ATOMIC_INIT(i)	{ (i) }
 
 #ifdef __KERNEL__
--- /dev/null
+++ b/include/asm-powerpc/atomic_def.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_POWERPC_ATOMIC_DEF_H_
+#define _ASM_POWERPC_ATOMIC_DEF_H_
+
+typedef struct { int counter; } atomic_t;
+
+#endif
--- a/include/asm-powerpc/atomic.h
+++ b/include/asm-powerpc/atomic.h
@@ -5,7 +5,7 @@
  * PowerPC atomic operations
  */
 
-typedef struct { int counter; } atomic_t;
+#include <asm/atomic_def.h>
 
 #ifdef __KERNEL__
 #include <linux/compiler.h>
--- a/include/asm-s390/atomic.h
+++ b/include/asm-s390/atomic.h
@@ -2,6 +2,7 @@
 #define __ARCH_S390_ATOMIC__
 
 #include <linux/compiler.h>
+#include <asm/atomic_def.h>
 
 /*
  *  include/asm-s390/atomic.h
@@ -23,9 +24,6 @@
  * S390 uses 'Compare And Swap' for atomicity in SMP enviroment
  */
 
-typedef struct {
-	int counter;
-} __attribute__ ((aligned (4))) atomic_t;
 #define ATOMIC_INIT(i)  { (i) }
 
 #ifdef __KERNEL__
--- /dev/null
+++ b/include/asm-s390/atomic_def.h
@@ -0,0 +1,8 @@
+#ifndef __ARCH_S390_ATOMIC_DEF__
+#define __ARCH_S390_ATOMIC_DEF__
+
+typedef struct {
+	int counter;
+} __attribute__ ((aligned (4))) atomic_t;
+
+#endif
--- /dev/null
+++ b/include/asm-um/atomic_def.h
@@ -0,0 +1,6 @@
+#ifndef __UM_ATOMIC_DEF_H
+#define __UM_ATOMIC_DEF_H
+
+#include "asm/arch/atomic_def.h"
+
+#endif
--- /dev/null
+++ b/include/asm-xtensa/atomic_def.h
@@ -0,0 +1,6 @@
+#ifndef _XTENSA_ATOMIC_DEF_H
+#define _XTENSA_ATOMIC_DEF_H
+
+typedef struct { volatile int counter; } atomic_t;
+
+#endif
--- a/include/asm-xtensa/atomic.h
+++ b/include/asm-xtensa/atomic.h
@@ -14,8 +14,7 @@
 #define _XTENSA_ATOMIC_H
 
 #include <linux/stringify.h>
-
-typedef struct { volatile int counter; } atomic_t;
+#include <asm/atomic_def.h>
 
 #ifdef __KERNEL__
 #include <asm/processor.h>
--- /dev/null
+++ b/include/asm-ia64/atomic_def.h
@@ -0,0 +1,11 @@
+#ifndef _ASM_IA64_ATOMIC_DEF_H
+#define _ASM_IA64_ATOMIC_DEF_H
+
+/*
+ * On IA-64, counter must always be volatile to ensure that that the
+ * memory accesses are ordered.
+ */
+typedef struct { volatile __s32 counter; } atomic_t;
+typedef struct { volatile __s64 counter; } atomic64_t;
+
+#endif


