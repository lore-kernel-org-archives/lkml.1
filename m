Return-Path: <linux-kernel-owner+w=401wt.eu-S1764675AbYJJVoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764675AbYJJVoc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 17:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762105AbYJJVoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 17:44:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43740 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761792AbYJJVoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 17:44:18 -0400
Date: Fri, 10 Oct 2008 14:43:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Huang Ying <ying.huang@intel.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, hpa@zytor.com,
       tglx@linutronix.de
Subject: Re: [PATCH -mm -v5] Separate atomic_t declaration from asm/atomic.h
 into asm/atomic_def.h
Message-Id: <20081010144335.65d8153b.akpm@linux-foundation.org>
In-Reply-To: <1223459070.5872.167.camel@yhuang-dev.sh.intel.com>
References: <1223459070.5872.167.camel@yhuang-dev.sh.intel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Oct 2008 17:44:30 +0800
Huang Ying <ying.huang@intel.com> wrote:

> From: Huang Ying <ying.huang@intel.com>
> 
> asm/atomic.h contains both declaration and implementation of atomic_t.  So
> there are some implementation related files included in asm/atomic.h.  And
> atomic_t is a typedef.  Combination of above makes it impossible to use
> atomic_t in files included by atomic.h.  Such as atomic_t can not be used
> in linux/kernel.h on i386, because it is included by asm/atomic.h.
> 
> It is reasonable to separate declaration from implementation.  So a new
> file atomic_types.h is added for every architecture to accommodate the
> declaration of atomic_t.
> 
> Includes fixes from Andrew Moton.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> Reviewed-by: Ingo Molnar <mingo@elte.hu>

The difference between what-i-currently-have and what-you-just-sent is
below.  It's quite large.

Can you explain this update please?


 arch/alpha/include/asm/atomic.h           |    2 +-
 arch/alpha/include/asm/atomic_types.h     |   13 +++++++++++++
 arch/arm/include/asm/atomic.h             |    2 +-
 arch/arm/include/asm/atomic_types.h       |    6 ++++++
 arch/avr32/include/asm/atomic.h           |    2 +-
 arch/avr32/include/asm/atomic_types.h     |    6 ++++++
 arch/blackfin/include/asm/atomic.h        |    2 +-
 arch/blackfin/include/asm/atomic_types.h  |    8 ++++++++
 arch/h8300/include/asm/atomic.h           |    2 +-
 arch/h8300/include/asm/atomic_types.h     |    6 ++++++
 arch/ia64/include/asm/atomic.h            |    2 +-
 arch/ia64/include/asm/atomic_types.h      |   11 +++++++++++
 arch/m68knommu/include/asm/atomic.h       |    2 +-
 arch/m68knommu/include/asm/atomic_types.h |    6 ++++++
 arch/mips/include/asm/atomic.h            |    2 +-
 arch/mips/include/asm/atomic_types.h      |    6 ++++++
 arch/powerpc/include/asm/atomic.h         |    2 +-
 arch/powerpc/include/asm/atomic_types.h   |    6 ++++++
 arch/s390/include/asm/atomic.h            |    2 +-
 arch/s390/include/asm/atomic_types.h      |    8 ++++++++
 arch/sh/include/asm/atomic.h              |    2 +-
 arch/sh/include/asm/atomic_def.h          |    8 --------
 arch/sh/include/asm/atomic_types.h        |    8 ++++++++
 arch/sparc/include/asm/atomic_32.h        |    2 +-
 arch/sparc/include/asm/atomic_64.h        |    2 +-
 arch/sparc/include/asm/atomic_def.h       |    8 --------
 arch/sparc/include/asm/atomic_types.h     |    8 ++++++++
 include/asm-alpha/atomic_def.h            |   13 -------------
 include/asm-arm/atomic_def.h              |    6 ------
 include/asm-avr32/atomic_def.h            |    6 ------
 include/asm-blackfin/atomic_def.h         |    8 --------
 include/asm-cris/atomic.h                 |    2 +-
 include/asm-cris/atomic_def.h             |    6 ------
 include/asm-cris/atomic_types.h           |    6 ++++++
 include/asm-frv/atomic.h                  |    2 +-
 include/asm-frv/atomic_def.h              |    8 --------
 include/asm-frv/atomic_types.h            |    8 ++++++++
 include/asm-h8300/atomic_def.h            |    6 ------
 include/asm-ia64/atomic_def.h             |   11 -----------
 include/asm-m32r/atomic.h                 |    2 +-
 include/asm-m32r/atomic_def.h             |   11 -----------
 include/asm-m32r/atomic_types.h           |   11 +++++++++++
 include/asm-m68k/atomic.h                 |    2 +-
 include/asm-m68k/atomic_def.h             |    6 ------
 include/asm-m68k/atomic_types.h           |    6 ++++++
 include/asm-m68knommu/atomic_def.h        |    6 ------
 include/asm-mips/atomic.h                 |    6 ------
 include/asm-mn10300/atomic.h              |    2 +-
 include/asm-mn10300/atomic_def.h          |   13 -------------
 include/asm-mn10300/atomic_types.h        |   13 +++++++++++++
 include/asm-powerpc/atomic_def.h          |    6 ------
 include/asm-s390/atomic_def.h             |    8 --------
 include/asm-um/atomic_def.h               |    6 ------
 include/asm-um/atomic_types.h             |    6 ++++++
 include/asm-x86/atomic_32.h               |    2 +-
 include/asm-x86/atomic_64.h               |    2 +-
 include/asm-x86/atomic_def.h              |   13 -------------
 include/asm-x86/atomic_types.h            |   13 +++++++++++++
 include/asm-xtensa/atomic.h               |    2 +-
 include/asm-xtensa/atomic_def.h           |    6 ------
 include/asm-xtensa/atomic_types.h         |    6 ++++++
 61 files changed, 182 insertions(+), 182 deletions(-)

diff -puN arch/alpha/include/asm/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update arch/alpha/include/asm/atomic.h
--- a/arch/alpha/include/asm/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update
+++ a/arch/alpha/include/asm/atomic.h
@@ -3,7 +3,7 @@
 
 #include <asm/barrier.h>
 #include <asm/system.h>
-#include <asm/atomic_def.h>
+#include <asm/atomic_types.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
diff -puN /dev/null arch/alpha/include/asm/atomic_types.h
--- /dev/null
+++ a/arch/alpha/include/asm/atomic_types.h
@@ -0,0 +1,13 @@
+#ifndef _ALPHA_ATOMIC_TYPES_H
+#define _ALPHA_ATOMIC_TYPES_H
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
diff -puN arch/arm/include/asm/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update arch/arm/include/asm/atomic.h
--- a/arch/arm/include/asm/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update
+++ a/arch/arm/include/asm/atomic.h
@@ -13,7 +13,7 @@
 
 #include <linux/compiler.h>
 #include <asm/system.h>
-#include <asm/atomic_def.h>
+#include <asm/atomic_types.h>
 
 #define ATOMIC_INIT(i)	{ (i) }
 
diff -puN /dev/null arch/arm/include/asm/atomic_types.h
--- /dev/null
+++ a/arch/arm/include/asm/atomic_types.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_ARM_ATOMIC_TYPES_H
+#define __ASM_ARM_ATOMIC_TYPES_H
+
+typedef struct { volatile int counter; } atomic_t;
+
+#endif
diff -puN arch/avr32/include/asm/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update arch/avr32/include/asm/atomic.h
--- a/arch/avr32/include/asm/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update
+++ a/arch/avr32/include/asm/atomic.h
@@ -15,7 +15,7 @@
 #define __ASM_AVR32_ATOMIC_H
 
 #include <asm/system.h>
-#include <asm/atomic_def.h>
+#include <asm/atomic_types.h>
 
 #define ATOMIC_INIT(i)  { (i) }
 
diff -puN /dev/null arch/avr32/include/asm/atomic_types.h
--- /dev/null
+++ a/arch/avr32/include/asm/atomic_types.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_AVR32_ATOMIC_TYPES_H
+#define __ASM_AVR32_ATOMIC_TYPES_H
+
+typedef struct { volatile int counter; } atomic_t;
+
+#endif
diff -puN arch/blackfin/include/asm/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update arch/blackfin/include/asm/atomic.h
--- a/arch/blackfin/include/asm/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update
+++ a/arch/blackfin/include/asm/atomic.h
@@ -2,7 +2,7 @@
 #define __ARCH_BLACKFIN_ATOMIC__
 
 #include <asm/system.h>	/* local_irq_XXX() */
-#include <asm/atomic_def.h>
+#include <asm/atomic_types.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
diff -puN /dev/null arch/blackfin/include/asm/atomic_types.h
--- /dev/null
+++ a/arch/blackfin/include/asm/atomic_types.h
@@ -0,0 +1,8 @@
+#ifndef __ARCH_BLACKFIN_ATOMIC_TYPES__
+#define __ARCH_BLACKFIN_ATOMIC_TYPES__
+
+typedef struct {
+	int counter;
+} atomic_t;
+
+#endif
diff -puN arch/h8300/include/asm/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update arch/h8300/include/asm/atomic.h
--- a/arch/h8300/include/asm/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update
+++ a/arch/h8300/include/asm/atomic.h
@@ -1,7 +1,7 @@
 #ifndef __ARCH_H8300_ATOMIC__
 #define __ARCH_H8300_ATOMIC__
 
-#include <asm/atomic_def.h>
+#include <asm/atomic_types.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
diff -puN /dev/null arch/h8300/include/asm/atomic_types.h
--- /dev/null
+++ a/arch/h8300/include/asm/atomic_types.h
@@ -0,0 +1,6 @@
+#ifndef __ARCH_H8300_ATOMIC_TYPES__
+#define __ARCH_H8300_ATOMIC_TYPES__
+
+typedef struct { int counter; } atomic_t;
+
+#endif
diff -puN arch/ia64/include/asm/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update arch/ia64/include/asm/atomic.h
--- a/arch/ia64/include/asm/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update
+++ a/arch/ia64/include/asm/atomic.h
@@ -16,7 +16,7 @@
 
 #include <asm/intrinsics.h>
 #include <asm/system.h>
-#include <asm/atomic_def.h>
+#include <asm/atomic_types.h>
 
 #define ATOMIC_INIT(i)		((atomic_t) { (i) })
 #define ATOMIC64_INIT(i)	((atomic64_t) { (i) })
diff -puN /dev/null arch/ia64/include/asm/atomic_types.h
--- /dev/null
+++ a/arch/ia64/include/asm/atomic_types.h
@@ -0,0 +1,11 @@
+#ifndef _ASM_IA64_ATOMIC_TYPES_H
+#define _ASM_IA64_ATOMIC_TYPES_H
+
+/*
+ * On IA-64, counter must always be volatile to ensure that that the
+ * memory accesses are ordered.
+ */
+typedef struct { volatile __s32 counter; } atomic_t;
+typedef struct { volatile __s64 counter; } atomic64_t;
+
+#endif
diff -puN arch/m68knommu/include/asm/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update arch/m68knommu/include/asm/atomic.h
--- a/arch/m68knommu/include/asm/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update
+++ a/arch/m68knommu/include/asm/atomic.h
@@ -2,7 +2,7 @@
 #define __ARCH_M68KNOMMU_ATOMIC__
 
 #include <asm/system.h>
-#include <asm/atomic_def.h>
+#include <asm/atomic_types.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
diff -puN /dev/null arch/m68knommu/include/asm/atomic_types.h
--- /dev/null
+++ a/arch/m68knommu/include/asm/atomic_types.h
@@ -0,0 +1,6 @@
+#ifndef __ARCH_M68KNOMMU_ATOMIC_TYPES__
+#define __ARCH_M68KNOMMU_ATOMIC_TYPES__
+
+typedef struct { int counter; } atomic_t;
+
+#endif
diff -puN arch/mips/include/asm/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update arch/mips/include/asm/atomic.h
--- a/arch/mips/include/asm/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update
+++ a/arch/mips/include/asm/atomic.h
@@ -19,7 +19,7 @@
 #include <asm/cpu-features.h>
 #include <asm/war.h>
 #include <asm/system.h>
-#include <asm/atomic_def.h>
+#include <asm/atomic_types.h>
 
 #define ATOMIC_INIT(i)    { (i) }
 
diff -puN /dev/null arch/mips/include/asm/atomic_types.h
--- /dev/null
+++ a/arch/mips/include/asm/atomic_types.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_ATOMIC_TYPES_H
+#define _ASM_ATOMIC_TYPES_H
+
+typedef struct { volatile int counter; } atomic_t;
+
+#endif
diff -puN arch/powerpc/include/asm/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update arch/powerpc/include/asm/atomic.h
--- a/arch/powerpc/include/asm/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update
+++ a/arch/powerpc/include/asm/atomic.h
@@ -5,7 +5,7 @@
  * PowerPC atomic operations
  */
 
-#include <asm/atomic_def.h>
+#include <asm/atomic_types.h>
 
 #ifdef __KERNEL__
 #include <linux/compiler.h>
diff -puN /dev/null arch/powerpc/include/asm/atomic_types.h
--- /dev/null
+++ a/arch/powerpc/include/asm/atomic_types.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_POWERPC_ATOMIC_TYPES_H_
+#define _ASM_POWERPC_ATOMIC_TYPES_H_
+
+typedef struct { int counter; } atomic_t;
+
+#endif
diff -puN arch/s390/include/asm/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update arch/s390/include/asm/atomic.h
--- a/arch/s390/include/asm/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update
+++ a/arch/s390/include/asm/atomic.h
@@ -2,7 +2,7 @@
 #define __ARCH_S390_ATOMIC__
 
 #include <linux/compiler.h>
-#include <asm/atomic_def.h>
+#include <asm/atomic_types.h>
 
 /*
  *  include/asm-s390/atomic.h
diff -puN /dev/null arch/s390/include/asm/atomic_types.h
--- /dev/null
+++ a/arch/s390/include/asm/atomic_types.h
@@ -0,0 +1,8 @@
+#ifndef __ARCH_S390_ATOMIC_TYPES__
+#define __ARCH_S390_ATOMIC_TYPES__
+
+typedef struct {
+	int counter;
+} __attribute__ ((aligned (4))) atomic_t;
+
+#endif
diff -puN arch/sh/include/asm/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update arch/sh/include/asm/atomic.h
--- a/arch/sh/include/asm/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update
+++ a/arch/sh/include/asm/atomic.h
@@ -7,7 +7,7 @@
  *
  */
 
-#include <asm/atomic_def.h>
+#include <asm/atomic_types.h>
 
 #define ATOMIC_INIT(i)	( (atomic_t) { (i) } )
 
diff -puN arch/sh/include/asm/atomic_def.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update /dev/null
--- a/arch/sh/include/asm/atomic_def.h
+++ /dev/null
@@ -1,8 +0,0 @@
-#ifndef _ASM_IA64_ATOMIC_DEF_H
-#define _ASM_IA64_ATOMIC_DEF_H
-
-typedef struct {
-	volatile int counter;
-} atomic_t;
-
-#endif
diff -puN /dev/null arch/sh/include/asm/atomic_types.h
--- /dev/null
+++ a/arch/sh/include/asm/atomic_types.h
@@ -0,0 +1,8 @@
+#ifndef _ASM_IA64_ATOMIC_TYPES_H
+#define _ASM_IA64_ATOMIC_TYPES_H
+
+typedef struct {
+	volatile int counter;
+} atomic_t;
+
+#endif
diff -puN arch/sparc/include/asm/atomic_32.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update arch/sparc/include/asm/atomic_32.h
--- a/arch/sparc/include/asm/atomic_32.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update
+++ a/arch/sparc/include/asm/atomic_32.h
@@ -15,7 +15,7 @@
 
 #ifdef __KERNEL__
 
-#include <asm/atomic_def.h>
+#include <asm/atomic_types.h>
 
 #define ATOMIC_INIT(i)  { (i) }
 
diff -puN arch/sparc/include/asm/atomic_64.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update arch/sparc/include/asm/atomic_64.h
--- a/arch/sparc/include/asm/atomic_64.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update
+++ a/arch/sparc/include/asm/atomic_64.h
@@ -9,7 +9,7 @@
 
 #include <linux/types.h>
 #include <asm/system.h>
-#include <asm/atomic_def.h>
+#include <asm/atomic_types.h>
 
 typedef struct { volatile __s64 counter; } atomic64_t;
 
diff -puN arch/sparc/include/asm/atomic_def.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update /dev/null
--- a/arch/sparc/include/asm/atomic_def.h
+++ /dev/null
@@ -1,8 +0,0 @@
-#ifndef _ATOMIC_DEF_H
-#define _ATOMIC_DEF_H
-
-typedef struct {
-	volatile int counter;
-} atomic_t;
-
-#endif
diff -puN /dev/null arch/sparc/include/asm/atomic_types.h
--- /dev/null
+++ a/arch/sparc/include/asm/atomic_types.h
@@ -0,0 +1,8 @@
+#ifndef _ATOMIC_TYPES_H
+#define _ATOMIC_TYPES_H
+
+typedef struct {
+	volatile int counter;
+} atomic_t;
+
+#endif
diff -puN include/asm-alpha/atomic_def.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update /dev/null
--- a/include/asm-alpha/atomic_def.h
+++ /dev/null
@@ -1,13 +0,0 @@
-#ifndef _ALPHA_ATOMIC_DEF_H
-#define _ALPHA_ATOMIC_DEF_H
-
-
-/*
- * Counter is volatile to make sure gcc doesn't try to be clever
- * and move things around on us. We need to use _exactly_ the address
- * the user gave us, not some alias that contains the same information.
- */
-typedef struct { volatile int counter; } atomic_t;
-typedef struct { volatile long counter; } atomic64_t;
-
-#endif
diff -puN include/asm-arm/atomic_def.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update /dev/null
--- a/include/asm-arm/atomic_def.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ASM_ARM_ATOMIC_DEF_H
-#define __ASM_ARM_ATOMIC_DEF_H
-
-typedef struct { volatile int counter; } atomic_t;
-
-#endif
diff -puN include/asm-avr32/atomic_def.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update /dev/null
--- a/include/asm-avr32/atomic_def.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ASM_AVR32_ATOMIC_DEF_H
-#define __ASM_AVR32_ATOMIC_DEF_H
-
-typedef struct { volatile int counter; } atomic_t;
-
-#endif
diff -puN include/asm-blackfin/atomic_def.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update /dev/null
--- a/include/asm-blackfin/atomic_def.h
+++ /dev/null
@@ -1,8 +0,0 @@
-#ifndef __ARCH_BLACKFIN_ATOMIC_DEF__
-#define __ARCH_BLACKFIN_ATOMIC_DEF__
-
-typedef struct {
-	int counter;
-} atomic_t;
-
-#endif
diff -puN include/asm-cris/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update include/asm-cris/atomic.h
--- a/include/asm-cris/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update
+++ a/include/asm-cris/atomic.h
@@ -7,7 +7,7 @@
 
 #include <asm/system.h>
 #include <asm/arch/atomic.h>
-#include <asm/atomic_def.h>
+#include <asm/atomic_types.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
diff -puN include/asm-cris/atomic_def.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update /dev/null
--- a/include/asm-cris/atomic_def.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ASM_CRIS_ATOMIC_DEF__
-#define __ASM_CRIS_ATOMIC_DEF__
-
-typedef struct { volatile int counter; } atomic_t;
-
-#endif
diff -puN /dev/null include/asm-cris/atomic_types.h
--- /dev/null
+++ a/include/asm-cris/atomic_types.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_CRIS_ATOMIC_TYPES__
+#define __ASM_CRIS_ATOMIC_TYPES__
+
+typedef struct { volatile int counter; } atomic_t;
+
+#endif
diff -puN include/asm-frv/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update include/asm-frv/atomic.h
--- a/include/asm-frv/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update
+++ a/include/asm-frv/atomic.h
@@ -17,7 +17,7 @@
 #include <linux/types.h>
 #include <asm/spr-regs.h>
 #include <asm/system.h>
-#include <asm/atomic_def.h>
+#include <asm/atomic_types.h>
 
 #ifdef CONFIG_SMP
 #error not SMP safe
diff -puN include/asm-frv/atomic_def.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update /dev/null
--- a/include/asm-frv/atomic_def.h
+++ /dev/null
@@ -1,8 +0,0 @@
-#ifndef _ASM_ATOMIC_DEF_H
-#define _ASM_ATOMIC_DEF_H
-
-typedef struct {
-	int counter;
-} atomic_t;
-
-#endif
diff -puN /dev/null include/asm-frv/atomic_types.h
--- /dev/null
+++ a/include/asm-frv/atomic_types.h
@@ -0,0 +1,8 @@
+#ifndef _ASM_ATOMIC_TYPES_H
+#define _ASM_ATOMIC_TYPES_H
+
+typedef struct {
+	int counter;
+} atomic_t;
+
+#endif
diff -puN include/asm-h8300/atomic_def.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update /dev/null
--- a/include/asm-h8300/atomic_def.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ARCH_H8300_ATOMIC_DEF__
-#define __ARCH_H8300_ATOMIC_DEF__
-
-typedef struct { int counter; } atomic_t;
-
-#endif
diff -puN include/asm-ia64/atomic_def.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update /dev/null
--- a/include/asm-ia64/atomic_def.h
+++ /dev/null
@@ -1,11 +0,0 @@
-#ifndef _ASM_IA64_ATOMIC_DEF_H
-#define _ASM_IA64_ATOMIC_DEF_H
-
-/*
- * On IA-64, counter must always be volatile to ensure that that the
- * memory accesses are ordered.
- */
-typedef struct { volatile __s32 counter; } atomic_t;
-typedef struct { volatile __s64 counter; } atomic64_t;
-
-#endif
diff -puN include/asm-m32r/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update include/asm-m32r/atomic.h
--- a/include/asm-m32r/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update
+++ a/include/asm-m32r/atomic.h
@@ -11,7 +11,7 @@
 
 #include <asm/assembler.h>
 #include <asm/system.h>
-#include <asm/atomic_def.h>
+#include <asm/atomic_types.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
diff -puN include/asm-m32r/atomic_def.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update /dev/null
--- a/include/asm-m32r/atomic_def.h
+++ /dev/null
@@ -1,11 +0,0 @@
-#ifndef _ASM_M32R_ATOMIC_DEF_H
-#define _ASM_M32R_ATOMIC_DEF_H
-
-/*
- * Make sure gcc doesn't try to be clever and move things around
- * on us. We need to use _exactly_ the address the user gave us,
- * not some alias that contains the same information.
- */
-typedef struct { volatile int counter; } atomic_t;
-
-#endif
diff -puN /dev/null include/asm-m32r/atomic_types.h
--- /dev/null
+++ a/include/asm-m32r/atomic_types.h
@@ -0,0 +1,11 @@
+#ifndef _ASM_M32R_ATOMIC_TYPES_H
+#define _ASM_M32R_ATOMIC_TYPES_H
+
+/*
+ * Make sure gcc doesn't try to be clever and move things around
+ * on us. We need to use _exactly_ the address the user gave us,
+ * not some alias that contains the same information.
+ */
+typedef struct { volatile int counter; } atomic_t;
+
+#endif
diff -puN include/asm-m68k/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update include/asm-m68k/atomic.h
--- a/include/asm-m68k/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update
+++ a/include/asm-m68k/atomic.h
@@ -3,7 +3,7 @@
 
 
 #include <asm/system.h>
-#include <asm/atomic_def.h>
+#include <asm/atomic_types.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
diff -puN include/asm-m68k/atomic_def.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update /dev/null
--- a/include/asm-m68k/atomic_def.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ARCH_M68K_ATOMIC_DEF__
-#define __ARCH_M68K_ATOMIC_DEF__
-
-typedef struct { int counter; } atomic_t;
-
-#endif
diff -puN /dev/null include/asm-m68k/atomic_types.h
--- /dev/null
+++ a/include/asm-m68k/atomic_types.h
@@ -0,0 +1,6 @@
+#ifndef __ARCH_M68K_ATOMIC_TYPES__
+#define __ARCH_M68K_ATOMIC_TYPES__
+
+typedef struct { int counter; } atomic_t;
+
+#endif
diff -puN include/asm-m68knommu/atomic_def.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update /dev/null
--- a/include/asm-m68knommu/atomic_def.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ARCH_M68KNOMMU_ATOMIC_DEF__
-#define __ARCH_M68KNOMMU_ATOMIC_DEF__
-
-typedef struct { int counter; } atomic_t;
-
-#endif
diff -puN include/asm-mips/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update /dev/null
--- a/include/asm-mips/atomic.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_ATOMIC_DEF_H
-#define _ASM_ATOMIC_DEF_H
-
-typedef struct { volatile int counter; } atomic_t;
-
-#endif
diff -puN include/asm-mn10300/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update include/asm-mn10300/atomic.h
--- a/include/asm-mn10300/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update
+++ a/include/asm-mn10300/atomic.h
@@ -11,7 +11,7 @@
 #ifndef _ASM_ATOMIC_H
 #define _ASM_ATOMIC_H
 
-#include <asm/atomic_def.h>
+#include <asm/atomic_types.h>
 
 #ifdef CONFIG_SMP
 #error not SMP safe
diff -puN include/asm-mn10300/atomic_def.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update /dev/null
--- a/include/asm-mn10300/atomic_def.h
+++ /dev/null
@@ -1,13 +0,0 @@
-#ifndef _ASM_ATOMIC_DEF_H
-#define _ASM_ATOMIC_DEF_H
-
-/*
- * Make sure gcc doesn't try to be clever and move things around
- * on us. We need to use _exactly_ the address the user gave us,
- * not some alias that contains the same information.
- */
-typedef struct {
-	int	counter;
-} atomic_t;
-
-#endif
diff -puN /dev/null include/asm-mn10300/atomic_types.h
--- /dev/null
+++ a/include/asm-mn10300/atomic_types.h
@@ -0,0 +1,13 @@
+#ifndef _ASM_ATOMIC_TYPES_H
+#define _ASM_ATOMIC_TYPES_H
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
diff -puN include/asm-powerpc/atomic_def.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update /dev/null
--- a/include/asm-powerpc/atomic_def.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_POWERPC_ATOMIC_DEF_H_
-#define _ASM_POWERPC_ATOMIC_DEF_H_
-
-typedef struct { int counter; } atomic_t;
-
-#endif
diff -puN include/asm-s390/atomic_def.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update /dev/null
--- a/include/asm-s390/atomic_def.h
+++ /dev/null
@@ -1,8 +0,0 @@
-#ifndef __ARCH_S390_ATOMIC_DEF__
-#define __ARCH_S390_ATOMIC_DEF__
-
-typedef struct {
-	int counter;
-} __attribute__ ((aligned (4))) atomic_t;
-
-#endif
diff -puN include/asm-um/atomic_def.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update /dev/null
--- a/include/asm-um/atomic_def.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __UM_ATOMIC_DEF_H
-#define __UM_ATOMIC_DEF_H
-
-#include "asm/arch/atomic_def.h"
-
-#endif
diff -puN /dev/null include/asm-um/atomic_types.h
--- /dev/null
+++ a/include/asm-um/atomic_types.h
@@ -0,0 +1,6 @@
+#ifndef __UM_ATOMIC_TYPES_H
+#define __UM_ATOMIC_TYPES_H
+
+#include "asm/arch/atomic_types.h"
+
+#endif
diff -puN include/asm-x86/atomic_32.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update include/asm-x86/atomic_32.h
--- a/include/asm-x86/atomic_32.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update
+++ a/include/asm-x86/atomic_32.h
@@ -4,7 +4,7 @@
 #include <linux/compiler.h>
 #include <asm/processor.h>
 #include <asm/cmpxchg.h>
-#include <asm/atomic_def.h>
+#include <asm/atomic_types.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
diff -puN include/asm-x86/atomic_64.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update include/asm-x86/atomic_64.h
--- a/include/asm-x86/atomic_64.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update
+++ a/include/asm-x86/atomic_64.h
@@ -3,7 +3,7 @@
 
 #include <asm/alternative.h>
 #include <asm/cmpxchg.h>
-#include <asm/atomic_def.h>
+#include <asm/atomic_types.h>
 
 /* atomic_t should be 32 bit signed type */
 
diff -puN include/asm-x86/atomic_def.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update /dev/null
--- a/include/asm-x86/atomic_def.h
+++ /dev/null
@@ -1,13 +0,0 @@
-#ifndef __ARCH_X86_ATOMIC_DEF__
-#define __ARCH_X86_ATOMIC_DEF__
-
-/*
- * Make sure gcc doesn't try to be clever and move things around
- * on us. We need to use _exactly_ the address the user gave us,
- * not some alias that contains the same information.
- */
-typedef struct {
-	int counter;
-} atomic_t;
-
-#endif
diff -puN /dev/null include/asm-x86/atomic_types.h
--- /dev/null
+++ a/include/asm-x86/atomic_types.h
@@ -0,0 +1,13 @@
+#ifndef __ARCH_X86_ATOMIC_TYPES__
+#define __ARCH_X86_ATOMIC_TYPES__
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
diff -puN include/asm-xtensa/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update include/asm-xtensa/atomic.h
--- a/include/asm-xtensa/atomic.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update
+++ a/include/asm-xtensa/atomic.h
@@ -14,7 +14,7 @@
 #define _XTENSA_ATOMIC_H
 
 #include <linux/stringify.h>
-#include <asm/atomic_def.h>
+#include <asm/atomic_types.h>
 
 #ifdef __KERNEL__
 #include <asm/processor.h>
diff -puN include/asm-xtensa/atomic_def.h~separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-update /dev/null
--- a/include/asm-xtensa/atomic_def.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _XTENSA_ATOMIC_DEF_H
-#define _XTENSA_ATOMIC_DEF_H
-
-typedef struct { volatile int counter; } atomic_t;
-
-#endif
diff -puN /dev/null include/asm-xtensa/atomic_types.h
--- /dev/null
+++ a/include/asm-xtensa/atomic_types.h
@@ -0,0 +1,6 @@
+#ifndef _XTENSA_ATOMIC_TYPES_H
+#define _XTENSA_ATOMIC_TYPES_H
+
+typedef struct { volatile int counter; } atomic_t;
+
+#endif
_

