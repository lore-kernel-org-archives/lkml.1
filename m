Return-Path: <linux-kernel-owner+w=401wt.eu-S1756647AbYJGBXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647AbYJGBXo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 21:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754311AbYJGBXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 21:23:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:36361 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754279AbYJGBXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 21:23:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,370,1220252400"; 
   d="asc'?scan'208";a="344744756"
Subject: [PATCH -mm -v4] Separate atomic_t declaration from asm/atomic.h
	into asm/atomic_def.h
From: Huang Ying <ying.huang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wxLKEAHaD85VEYFaUAk0"
Date: Tue, 07 Oct 2008 09:23:28 +0800
Message-Id: <1223342608.5872.28.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-wxLKEAHaD85VEYFaUAk0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

From: Huang Ying <ying.huang@intel.com>

asm/atomic.h contains both declaration and implementation of atomic_t.  So
there are some implementation related files included in asm/atomic.h.  And
atomic_t is a typedef.  Combination of above makes it impossible to use
atomic_t in files included by atomic.h.  Such as atomic_t can not be used
in linux/kernel.h on i386, because it is included by asm/atomic.h.

It is reasonable to separate declaration from implementation.  So a new
file atomic_types.h is added for every architecture to accommodate the
declaration of atomic_t.

Includes fixes from Andrew Moton.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Reviewed-by: Ingo Molnar <mingo@elte.hu>

---

 arch/alpha/include/asm/atomic.h           |   10 +---------
 arch/alpha/include/asm/atomic_types.h     |   13 +++++++++++++
 arch/arm/include/asm/atomic.h             |    3 +--
 arch/arm/include/asm/atomic_types.h       |    6 ++++++
 arch/avr32/include/asm/atomic.h           |    2 +-
 arch/avr32/include/asm/atomic_types.h     |    6 ++++++
 arch/blackfin/include/asm/atomic.h        |    4 +---
 arch/blackfin/include/asm/atomic_types.h  |    8 ++++++++
 arch/h8300/include/asm/atomic.h           |    3 ++-
 arch/h8300/include/asm/atomic_types.h     |    6 ++++++
 arch/ia64/include/asm/atomic.h            |    8 +-------
 arch/ia64/include/asm/atomic_types.h      |   11 +++++++++++
 arch/m68knommu/include/asm/atomic.h       |    2 +-
 arch/m68knommu/include/asm/atomic_types.h |    6 ++++++
 arch/mips/include/asm/atomic.h            |    3 +--
 arch/mips/include/asm/atomic_types.h      |    6 ++++++
 arch/powerpc/include/asm/atomic.h         |    2 +-
 arch/powerpc/include/asm/atomic_types.h   |    6 ++++++
 arch/s390/include/asm/atomic.h            |    4 +---
 arch/s390/include/asm/atomic_types.h      |    8 ++++++++
 arch/sh/include/asm/atomic.h              |    2 +-
 arch/sh/include/asm/atomic_types.h        |    8 ++++++++
 arch/sparc/include/asm/atomic_32.h        |    4 ++--
 arch/sparc/include/asm/atomic_64.h        |    2 +-
 arch/sparc/include/asm/atomic_types.h     |    8 ++++++++
 include/asm-cris/atomic.h                 |    3 +--
 include/asm-cris/atomic_types.h           |    6 ++++++
 include/asm-frv/atomic.h                  |    5 +----
 include/asm-frv/atomic_types.h            |    8 ++++++++
 include/asm-m32r/atomic.h                 |    8 +-------
 include/asm-m32r/atomic_types.h           |   11 +++++++++++
 include/asm-m68k/atomic.h                 |    2 +-
 include/asm-m68k/atomic_types.h           |    6 ++++++
 include/asm-mn10300/atomic.h              |   11 ++---------
 include/asm-mn10300/atomic_types.h        |   13 +++++++++++++
 include/asm-um/atomic_types.h             |    6 ++++++
 include/asm-x86/atomic_32.h               |   10 +---------
 include/asm-x86/atomic_64.h               |   10 +---------
 include/asm-x86/atomic_types.h            |   13 +++++++++++++
 include/asm-xtensa/atomic.h               |    3 +--
 include/asm-xtensa/atomic_types.h         |    6 ++++++
 41 files changed, 185 insertions(+), 77 deletions(-)

--- a/arch/alpha/include/asm/atomic.h
+++ b/arch/alpha/include/asm/atomic.h
@@ -3,6 +3,7 @@
=20
 #include <asm/barrier.h>
 #include <asm/system.h>
+#include <asm/atomic_types.h>
=20
 /*
  * Atomic operations that C can't guarantee us.  Useful for
@@ -12,15 +13,6 @@
  * than regular operations.
  */
=20
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
=20
--- a/arch/arm/include/asm/atomic.h
+++ b/arch/arm/include/asm/atomic.h
@@ -13,8 +13,7 @@
=20
 #include <linux/compiler.h>
 #include <asm/system.h>
-
-typedef struct { volatile int counter; } atomic_t;
+#include <asm/atomic_types.h>
=20
 #define ATOMIC_INIT(i)	{ (i) }
=20
--- a/arch/avr32/include/asm/atomic.h
+++ b/arch/avr32/include/asm/atomic.h
@@ -15,8 +15,8 @@
 #define __ASM_AVR32_ATOMIC_H
=20
 #include <asm/system.h>
+#include <asm/atomic_types.h>
=20
-typedef struct { volatile int counter; } atomic_t;
 #define ATOMIC_INIT(i)  { (i) }
=20
 #define atomic_read(v)		((v)->counter)
--- a/arch/blackfin/include/asm/atomic.h
+++ b/arch/blackfin/include/asm/atomic.h
@@ -2,6 +2,7 @@
 #define __ARCH_BLACKFIN_ATOMIC__
=20
 #include <asm/system.h>	/* local_irq_XXX() */
+#include <asm/atomic_types.h>
=20
 /*
  * Atomic operations that C can't guarantee us.  Useful for
@@ -13,9 +14,6 @@
  * Tony Kou (tonyko@lineo.ca)   Lineo Inc.   2001
  */
=20
-typedef struct {
-	int counter;
-} atomic_t;
 #define ATOMIC_INIT(i)	{ (i) }
=20
 #define atomic_read(v)		((v)->counter)
--- a/arch/h8300/include/asm/atomic.h
+++ b/arch/h8300/include/asm/atomic.h
@@ -1,12 +1,13 @@
 #ifndef __ARCH_H8300_ATOMIC__
 #define __ARCH_H8300_ATOMIC__
=20
+#include <asm/atomic_types.h>
+
 /*
  * Atomic operations that C can't guarantee us.  Useful for
  * resource counting etc..
  */
=20
-typedef struct { int counter; } atomic_t;
 #define ATOMIC_INIT(i)	{ (i) }
=20
 #define atomic_read(v)		((v)->counter)
--- a/arch/ia64/include/asm/atomic.h
+++ b/arch/ia64/include/asm/atomic.h
@@ -16,13 +16,7 @@
=20
 #include <asm/intrinsics.h>
 #include <asm/system.h>
-
-/*
- * On IA-64, counter must always be volatile to ensure that that the
- * memory accesses are ordered.
- */
-typedef struct { volatile __s32 counter; } atomic_t;
-typedef struct { volatile __s64 counter; } atomic64_t;
+#include <asm/atomic_types.h>
=20
 #define ATOMIC_INIT(i)		((atomic_t) { (i) })
 #define ATOMIC64_INIT(i)	((atomic64_t) { (i) })
--- a/arch/m68knommu/include/asm/atomic.h
+++ b/arch/m68knommu/include/asm/atomic.h
@@ -2,6 +2,7 @@
 #define __ARCH_M68KNOMMU_ATOMIC__
=20
 #include <asm/system.h>
+#include <asm/atomic_types.h>
=20
 /*
  * Atomic operations that C can't guarantee us.  Useful for
@@ -12,7 +13,6 @@
  * We do not have SMP m68k systems, so we don't have to deal with that.
  */
=20
-typedef struct { int counter; } atomic_t;
 #define ATOMIC_INIT(i)	{ (i) }
=20
 #define atomic_read(v)		((v)->counter)
--- a/arch/mips/include/asm/atomic.h
+++ b/arch/mips/include/asm/atomic.h
@@ -19,8 +19,7 @@
 #include <asm/cpu-features.h>
 #include <asm/war.h>
 #include <asm/system.h>
-
-typedef struct { volatile int counter; } atomic_t;
+#include <asm/atomic_types.h>
=20
 #define ATOMIC_INIT(i)    { (i) }
=20
--- a/arch/powerpc/include/asm/atomic.h
+++ b/arch/powerpc/include/asm/atomic.h
@@ -5,7 +5,7 @@
  * PowerPC atomic operations
  */
=20
-typedef struct { int counter; } atomic_t;
+#include <asm/atomic_types.h>
=20
 #ifdef __KERNEL__
 #include <linux/compiler.h>
--- a/arch/s390/include/asm/atomic.h
+++ b/arch/s390/include/asm/atomic.h
@@ -2,6 +2,7 @@
 #define __ARCH_S390_ATOMIC__
=20
 #include <linux/compiler.h>
+#include <asm/atomic_types.h>
=20
 /*
  *  include/asm-s390/atomic.h
@@ -23,9 +24,6 @@
  * S390 uses 'Compare And Swap' for atomicity in SMP enviroment
  */
=20
-typedef struct {
-	int counter;
-} __attribute__ ((aligned (4))) atomic_t;
 #define ATOMIC_INIT(i)  { (i) }
=20
 #ifdef __KERNEL__
--- /dev/null
+++ b/arch/alpha/include/asm/atomic_types.h
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
+++ b/arch/arm/include/asm/atomic_types.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_ARM_ATOMIC_DEF_H
+#define __ASM_ARM_ATOMIC_DEF_H
+
+typedef struct { volatile int counter; } atomic_t;
+
+#endif
--- /dev/null
+++ b/arch/avr32/include/asm/atomic_types.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_AVR32_ATOMIC_DEF_H
+#define __ASM_AVR32_ATOMIC_DEF_H
+
+typedef struct { volatile int counter; } atomic_t;
+
+#endif
--- /dev/null
+++ b/arch/blackfin/include/asm/atomic_types.h
@@ -0,0 +1,8 @@
+#ifndef __ARCH_BLACKFIN_ATOMIC_DEF__
+#define __ARCH_BLACKFIN_ATOMIC_DEF__
+
+typedef struct {
+	int counter;
+} atomic_t;
+
+#endif
--- a/include/asm-cris/atomic.h
+++ b/include/asm-cris/atomic.h
@@ -7,14 +7,13 @@
=20
 #include <asm/system.h>
 #include <asm/arch/atomic.h>
+#include <asm/atomic_types.h>
=20
 /*
  * Atomic operations that C can't guarantee us.  Useful for
  * resource counting etc..
  */
=20
-typedef struct { volatile int counter; } atomic_t;
-
 #define ATOMIC_INIT(i)  { (i) }
=20
 #define atomic_read(v) ((v)->counter)
--- /dev/null
+++ b/include/asm-cris/atomic_types.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_CRIS_ATOMIC_DEF__
+#define __ASM_CRIS_ATOMIC_DEF__
+
+typedef struct { volatile int counter; } atomic_t;
+
+#endif
--- a/include/asm-frv/atomic.h
+++ b/include/asm-frv/atomic.h
@@ -17,6 +17,7 @@
 #include <linux/types.h>
 #include <asm/spr-regs.h>
 #include <asm/system.h>
+#include <asm/atomic_types.h>
=20
 #ifdef CONFIG_SMP
 #error not SMP safe
@@ -35,10 +36,6 @@
 #define smp_mb__before_atomic_inc()	barrier()
 #define smp_mb__after_atomic_inc()	barrier()
=20
-typedef struct {
-	int counter;
-} atomic_t;
-
 #define ATOMIC_INIT(i)		{ (i) }
 #define atomic_read(v)		((v)->counter)
 #define atomic_set(v, i)	(((v)->counter) =3D (i))
--- /dev/null
+++ b/include/asm-frv/atomic_types.h
@@ -0,0 +1,8 @@
+#ifndef _ASM_ATOMIC_DEF_H
+#define _ASM_ATOMIC_DEF_H
+
+typedef struct {
+	int counter;
+} atomic_t;
+
+#endif
--- /dev/null
+++ b/arch/h8300/include/asm/atomic_types.h
@@ -0,0 +1,6 @@
+#ifndef __ARCH_H8300_ATOMIC_DEF__
+#define __ARCH_H8300_ATOMIC_DEF__
+
+typedef struct { int counter; } atomic_t;
+
+#endif
--- /dev/null
+++ b/arch/ia64/include/asm/atomic_types.h
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
--- a/include/asm-m32r/atomic.h
+++ b/include/asm-m32r/atomic.h
@@ -11,19 +11,13 @@
=20
 #include <asm/assembler.h>
 #include <asm/system.h>
+#include <asm/atomic_types.h>
=20
 /*
  * Atomic operations that C can't guarantee us.  Useful for
  * resource counting etc..
  */
=20
-/*
- * Make sure gcc doesn't try to be clever and move things around
- * on us. We need to use _exactly_ the address the user gave us,
- * not some alias that contains the same information.
- */
-typedef struct { volatile int counter; } atomic_t;
-
 #define ATOMIC_INIT(i)	{ (i) }
=20
 /**
--- /dev/null
+++ b/include/asm-m32r/atomic_types.h
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
--- a/include/asm-m68k/atomic.h
+++ b/include/asm-m68k/atomic.h
@@ -3,6 +3,7 @@
=20
=20
 #include <asm/system.h>
+#include <asm/atomic_types.h>
=20
 /*
  * Atomic operations that C can't guarantee us.  Useful for
@@ -13,7 +14,6 @@
  * We do not have SMP m68k systems, so we don't have to deal with that.
  */
=20
-typedef struct { int counter; } atomic_t;
 #define ATOMIC_INIT(i)	{ (i) }
=20
 #define atomic_read(v)		((v)->counter)
--- /dev/null
+++ b/include/asm-m68k/atomic_types.h
@@ -0,0 +1,6 @@
+#ifndef __ARCH_M68K_ATOMIC_DEF__
+#define __ARCH_M68K_ATOMIC_DEF__
+
+typedef struct { int counter; } atomic_t;
+
+#endif
--- /dev/null
+++ b/arch/m68knommu/include/asm/atomic_types.h
@@ -0,0 +1,6 @@
+#ifndef __ARCH_M68KNOMMU_ATOMIC_DEF__
+#define __ARCH_M68KNOMMU_ATOMIC_DEF__
+
+typedef struct { int counter; } atomic_t;
+
+#endif
--- /dev/null
+++ b/arch/mips/include/asm/atomic_types.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_ATOMIC_DEF_H
+#define _ASM_ATOMIC_DEF_H
+
+typedef struct { volatile int counter; } atomic_t;
+
+#endif
--- a/include/asm-mn10300/atomic.h
+++ b/include/asm-mn10300/atomic.h
@@ -11,6 +11,8 @@
 #ifndef _ASM_ATOMIC_H
 #define _ASM_ATOMIC_H
=20
+#include <asm/atomic_types.h>
+
 #ifdef CONFIG_SMP
 #error not SMP safe
 #endif
@@ -20,15 +22,6 @@
  * resource counting etc..
  */
=20
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
=20
 #ifdef __KERNEL__
--- /dev/null
+++ b/include/asm-mn10300/atomic_types.h
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
--- /dev/null
+++ b/arch/powerpc/include/asm/atomic_types.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_POWERPC_ATOMIC_DEF_H_
+#define _ASM_POWERPC_ATOMIC_DEF_H_
+
+typedef struct { int counter; } atomic_t;
+
+#endif
--- /dev/null
+++ b/arch/s390/include/asm/atomic_types.h
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
+++ b/include/asm-um/atomic_types.h
@@ -0,0 +1,6 @@
+#ifndef __UM_ATOMIC_DEF_H
+#define __UM_ATOMIC_DEF_H
+
+#include "asm/arch/atomic_types.h"
+
+#endif
--- a/include/asm-x86/atomic_32.h
+++ b/include/asm-x86/atomic_32.h
@@ -4,21 +4,13 @@
 #include <linux/compiler.h>
 #include <asm/processor.h>
 #include <asm/cmpxchg.h>
+#include <asm/atomic_types.h>
=20
 /*
  * Atomic operations that C can't guarantee us.  Useful for
  * resource counting etc..
  */
=20
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
=20
 /**
--- a/include/asm-x86/atomic_64.h
+++ b/include/asm-x86/atomic_64.h
@@ -3,6 +3,7 @@
=20
 #include <asm/alternative.h>
 #include <asm/cmpxchg.h>
+#include <asm/atomic_types.h>
=20
 /* atomic_t should be 32 bit signed type */
=20
@@ -11,15 +12,6 @@
  * resource counting etc..
  */
=20
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
=20
 /**
--- /dev/null
+++ b/include/asm-x86/atomic_types.h
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
--- a/include/asm-xtensa/atomic.h
+++ b/include/asm-xtensa/atomic.h
@@ -14,8 +14,7 @@
 #define _XTENSA_ATOMIC_H
=20
 #include <linux/stringify.h>
-
-typedef struct { volatile int counter; } atomic_t;
+#include <asm/atomic_types.h>
=20
 #ifdef __KERNEL__
 #include <asm/processor.h>
--- /dev/null
+++ b/include/asm-xtensa/atomic_types.h
@@ -0,0 +1,6 @@
+#ifndef _XTENSA_ATOMIC_DEF_H
+#define _XTENSA_ATOMIC_DEF_H
+
+typedef struct { volatile int counter; } atomic_t;
+
+#endif
--- a/arch/sparc/include/asm/atomic_32.h
+++ b/arch/sparc/include/asm/atomic_32.h
@@ -13,10 +13,10 @@
=20
 #include <linux/types.h>
=20
-typedef struct { volatile int counter; } atomic_t;
-
 #ifdef __KERNEL__
=20
+#include <asm/atomic_types.h>
+
 #define ATOMIC_INIT(i)  { (i) }
=20
 extern int __atomic_add_return(int, atomic_t *);
--- a/arch/sparc/include/asm/atomic_64.h
+++ b/arch/sparc/include/asm/atomic_64.h
@@ -9,8 +9,8 @@
=20
 #include <linux/types.h>
 #include <asm/system.h>
+#include <asm/atomic_types.h>
=20
-typedef struct { volatile int counter; } atomic_t;
 typedef struct { volatile __s64 counter; } atomic64_t;
=20
 #define ATOMIC_INIT(i)		{ (i) }
--- /dev/null
+++ b/arch/sparc/include/asm/atomic_types.h
@@ -0,0 +1,8 @@
+#ifndef _ATOMIC_DEF_H
+#define _ATOMIC_DEF_H
+
+typedef struct {
+	volatile int counter;
+} atomic_t;
+
+#endif
--- a/arch/sh/include/asm/atomic.h
+++ b/arch/sh/include/asm/atomic.h
@@ -7,7 +7,7 @@
  *
  */
=20
-typedef struct { volatile int counter; } atomic_t;
+#include <asm/atomic_types.h>
=20
 #define ATOMIC_INIT(i)	( (atomic_t) { (i) } )
=20
--- /dev/null
+++ b/arch/sh/include/asm/atomic_types.h
@@ -0,0 +1,8 @@
+#ifndef _ASM_IA64_ATOMIC_DEF_H
+#define _ASM_IA64_ATOMIC_DEF_H
+
+typedef struct {
+	volatile int counter;
+} atomic_t;
+
+#endif


--=-wxLKEAHaD85VEYFaUAk0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjqugcACgkQKhFGF+eHlphIxwCgnjPn2GGGW6NhPqxYkvD1vlSM
IW4AoIOgfJDl84ZB9hmqPwBnsFwtBKPW
=lGnH
-----END PGP SIGNATURE-----

--=-wxLKEAHaD85VEYFaUAk0--

