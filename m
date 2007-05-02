Return-Path: <linux-kernel-owner+w=401wt.eu-S2993392AbXEBPnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993392AbXEBPnP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 11:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993393AbXEBPnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 11:43:15 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:42370 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993392AbXEBPnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 11:43:12 -0400
Date: Wed, 2 May 2007 11:38:47 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andi Kleen <ak@novell.com>
Cc: akpm@osdl.org, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH 2/6] Create asm-i386/cmpxchg.h
Message-ID: <20070502153847.GC6752@c2.user-mode-linux.org>
References: <20070501182157.GA8348@c2.user-mode-linux.org> <200705021137.48675.ak@novell.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
In-Reply-To: <200705021137.48675.ak@novell.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 02, 2007 at 11:37:48AM +0200, Andi Kleen wrote:
> Doesn't apply against the latest ff tree. Can you please regenerate,
> not losing whatever change caused it to reject?

What's the ff tree?  Is 'f' next to 'm' on your keyboard?

It depends on the tas() elimination patch, which I sent to LKML and
linux-arch yesterday, and which is attached.

Also attached is a standalone version of cmpxchg-i386 against
rc7-mm2.  no-tas applies on top of it.  Take your pick.

				Jeff

-- 
Work email - jdike at linux dot intel dot com

--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=no-tas

tas() has no users, so get rid of it.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 include/asm-alpha/system.h     |    3 ---
 include/asm-arm/system.h       |    2 --
 include/asm-arm26/system.h     |    2 --
 include/asm-blackfin/system.h  |    1 -
 include/asm-h8300/system.h     |    1 -
 include/asm-i386/system.h      |    2 --
 include/asm-m32r/system.h      |    2 --
 include/asm-m68k/system.h      |    1 -
 include/asm-m68knommu/system.h |    1 -
 include/asm-mips/system.h      |    1 -
 include/asm-powerpc/system.h   |    2 --
 include/asm-ppc/system.h       |    1 -
 include/asm-sh/system.h        |   10 ----------
 include/asm-sh64/system.h      |    2 --
 include/asm-sparc/system.h     |    1 -
 include/asm-sparc64/system.h   |    1 -
 include/asm-v850/system.h      |    1 -
 include/asm-x86_64/system.h    |    2 --
 include/asm-xtensa/system.h    |    2 --
 19 files changed, 38 deletions(-)

Index: linux-2.6.21-mm/include/asm-alpha/system.h
===================================================================
--- linux-2.6.21-mm.orig/include/asm-alpha/system.h	2007-04-26 17:33:06.000000000 -0400
+++ linux-2.6.21-mm/include/asm-alpha/system.h	2007-04-30 17:54:32.000000000 -0400
@@ -548,9 +548,6 @@ __xchg_u64_local(volatile long *m, unsig
      		sizeof(*(ptr))); \
   })
 
-#define tas(ptr) (xchg((ptr),1))
-
-
 /* 
  * Atomic compare and exchange.  Compare OLD with MEM, if identical,
  * store NEW in MEM.  Return the initial value in MEM.  Success is
Index: linux-2.6.21-mm/include/asm-arm/system.h
===================================================================
--- linux-2.6.21-mm.orig/include/asm-arm/system.h	2007-04-26 17:33:06.000000000 -0400
+++ linux-2.6.21-mm/include/asm-arm/system.h	2007-04-30 17:54:33.000000000 -0400
@@ -103,8 +103,6 @@ void hook_fault_code(int nr, int (*fn)(u
 #define xchg(ptr,x) \
 	((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
 
-#define tas(ptr) (xchg((ptr),1))
-
 extern asmlinkage void __backtrace(void);
 extern asmlinkage void c_backtrace(unsigned long fp, int pmode);
 
Index: linux-2.6.21-mm/include/asm-arm26/system.h
===================================================================
--- linux-2.6.21-mm.orig/include/asm-arm26/system.h	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-mm/include/asm-arm26/system.h	2007-04-30 17:54:33.000000000 -0400
@@ -52,8 +52,6 @@ void hook_fault_code(int nr, int (*fn)(u
 #define xchg(ptr,x) \
 	((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
 
-#define tas(ptr) (xchg((ptr),1))
-
 extern asmlinkage void __backtrace(void);
 
 #define set_cr(x)					\
Index: linux-2.6.21-mm/include/asm-blackfin/system.h
===================================================================
--- linux-2.6.21-mm.orig/include/asm-blackfin/system.h	2007-04-26 17:33:06.000000000 -0400
+++ linux-2.6.21-mm/include/asm-blackfin/system.h	2007-04-30 17:54:33.000000000 -0400
@@ -138,7 +138,6 @@ extern unsigned long irq_flags;
 #endif
 
 #define xchg(ptr,x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
-#define tas(ptr) ((void)xchg((ptr),1))
 
 struct __xchg_dummy {
 	unsigned long a[100];
Index: linux-2.6.21-mm/include/asm-h8300/system.h
===================================================================
--- linux-2.6.21-mm.orig/include/asm-h8300/system.h	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-mm/include/asm-h8300/system.h	2007-04-30 17:54:34.000000000 -0400
@@ -98,7 +98,6 @@ asmlinkage void resume(void);
 #endif
 
 #define xchg(ptr,x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
-#define tas(ptr) (xchg((ptr),1))
 
 struct __xchg_dummy { unsigned long a[100]; };
 #define __xg(x) ((volatile struct __xchg_dummy *)(x))
Index: linux-2.6.21-mm/include/asm-i386/system.h
===================================================================
--- linux-2.6.21-mm.orig/include/asm-i386/system.h	2007-04-30 12:38:17.000000000 -0400
+++ linux-2.6.21-mm/include/asm-i386/system.h	2007-04-30 18:04:43.000000000 -0400
@@ -197,8 +197,6 @@ static inline unsigned long get_limit(un
 
 #define xchg(ptr,v) ((__typeof__(*(ptr)))__xchg((unsigned long)(v),(ptr),sizeof(*(ptr))))
 
-#define tas(ptr) (xchg((ptr),1))
-
 struct __xchg_dummy { unsigned long a[100]; };
 #define __xg(x) ((struct __xchg_dummy *)(x))
 
Index: linux-2.6.21-mm/include/asm-m32r/system.h
===================================================================
--- linux-2.6.21-mm.orig/include/asm-m32r/system.h	2007-04-26 17:31:51.000000000 -0400
+++ linux-2.6.21-mm/include/asm-m32r/system.h	2007-04-30 17:54:34.000000000 -0400
@@ -122,8 +122,6 @@ static inline void local_irq_disable(voi
 #define xchg(ptr,x) \
 	((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
 
-#define tas(ptr)	(xchg((ptr),1))
-
 #ifdef CONFIG_SMP
 extern void  __xchg_called_with_bad_pointer(void);
 #endif
Index: linux-2.6.21-mm/include/asm-m68k/system.h
===================================================================
--- linux-2.6.21-mm.orig/include/asm-m68k/system.h	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-mm/include/asm-m68k/system.h	2007-04-30 17:54:34.000000000 -0400
@@ -88,7 +88,6 @@ static inline int irqs_disabled(void)
 
 
 #define xchg(ptr,x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
-#define tas(ptr) (xchg((ptr),1))
 
 struct __xchg_dummy { unsigned long a[100]; };
 #define __xg(x) ((volatile struct __xchg_dummy *)(x))
Index: linux-2.6.21-mm/include/asm-m68knommu/system.h
===================================================================
--- linux-2.6.21-mm.orig/include/asm-m68knommu/system.h	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-mm/include/asm-m68knommu/system.h	2007-04-30 17:54:34.000000000 -0400
@@ -120,7 +120,6 @@ asmlinkage void resume(void);
 #endif
 
 #define xchg(ptr,x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
-#define tas(ptr) (xchg((ptr),1))
 
 struct __xchg_dummy { unsigned long a[100]; };
 #define __xg(x) ((volatile struct __xchg_dummy *)(x))
Index: linux-2.6.21-mm/include/asm-mips/system.h
===================================================================
--- linux-2.6.21-mm.orig/include/asm-mips/system.h	2007-04-26 17:33:06.000000000 -0400
+++ linux-2.6.21-mm/include/asm-mips/system.h	2007-04-30 17:54:34.000000000 -0400
@@ -201,7 +201,6 @@ static inline unsigned long __xchg(unsig
 }
 
 #define xchg(ptr,x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
-#define tas(ptr) (xchg((ptr),1))
 
 #define __HAVE_ARCH_CMPXCHG 1
 
Index: linux-2.6.21-mm/include/asm-powerpc/system.h
===================================================================
--- linux-2.6.21-mm.orig/include/asm-powerpc/system.h	2007-04-26 17:33:06.000000000 -0400
+++ linux-2.6.21-mm/include/asm-powerpc/system.h	2007-04-30 17:54:34.000000000 -0400
@@ -334,8 +334,6 @@ __xchg_local(volatile void *ptr, unsigne
      		(unsigned long)_x_, sizeof(*(ptr))); 			     \
   })
 
-#define tas(ptr) (xchg((ptr),1))
-
 /*
  * Compare and exchange - if *p == old, set it to new,
  * and return the old value of *p.
Index: linux-2.6.21-mm/include/asm-ppc/system.h
===================================================================
--- linux-2.6.21-mm.orig/include/asm-ppc/system.h	2007-04-26 17:33:06.000000000 -0400
+++ linux-2.6.21-mm/include/asm-ppc/system.h	2007-04-30 17:54:34.000000000 -0400
@@ -169,7 +169,6 @@ xchg_u32(volatile void *p, unsigned long
 extern void __xchg_called_with_bad_pointer(void);
 
 #define xchg(ptr,x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
-#define tas(ptr) (xchg((ptr),1))
 
 static inline unsigned long __xchg(unsigned long x, volatile void *ptr, int size)
 {
Index: linux-2.6.21-mm/include/asm-sh/system.h
===================================================================
--- linux-2.6.21-mm.orig/include/asm-sh/system.h	2007-04-26 17:31:51.000000000 -0400
+++ linux-2.6.21-mm/include/asm-sh/system.h	2007-04-30 17:54:35.000000000 -0400
@@ -81,16 +81,6 @@ static inline void sched_cacheflush(void
 }
 #endif
 
-static inline unsigned long tas(volatile int *m)
-{
-	unsigned long retval;
-
-	__asm__ __volatile__ ("tas.b	@%1\n\t"
-			      "movt	%0"
-			      : "=r" (retval): "r" (m): "t", "memory");
-	return retval;
-}
-
 /*
  * A brief note on ctrl_barrier(), the control register write barrier.
  *
Index: linux-2.6.21-mm/include/asm-sh64/system.h
===================================================================
--- linux-2.6.21-mm.orig/include/asm-sh64/system.h	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-mm/include/asm-sh64/system.h	2007-04-30 17:54:35.000000000 -0400
@@ -43,8 +43,6 @@ extern struct task_struct *sh64_switch_t
 
 #define xchg(ptr,x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
 
-#define tas(ptr) (xchg((ptr), 1))
-
 extern void __xchg_called_with_bad_pointer(void);
 
 #define mb()	__asm__ __volatile__ ("synco": : :"memory")
Index: linux-2.6.21-mm/include/asm-sparc/system.h
===================================================================
--- linux-2.6.21-mm.orig/include/asm-sparc/system.h	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-mm/include/asm-sparc/system.h	2007-04-30 17:54:35.000000000 -0400
@@ -241,7 +241,6 @@ static inline unsigned long xchg_u32(__v
 }
 
 #define xchg(ptr,x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
-#define tas(ptr) (xchg((ptr),1))
 
 extern void __xchg_called_with_bad_pointer(void);
 
Index: linux-2.6.21-mm/include/asm-sparc64/system.h
===================================================================
--- linux-2.6.21-mm.orig/include/asm-sparc64/system.h	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-mm/include/asm-sparc64/system.h	2007-04-30 17:54:36.000000000 -0400
@@ -253,7 +253,6 @@ static inline unsigned long xchg64(__vol
 }
 
 #define xchg(ptr,x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
-#define tas(ptr) (xchg((ptr),1))
 
 extern void __xchg_called_with_bad_pointer(void);
 
Index: linux-2.6.21-mm/include/asm-v850/system.h
===================================================================
--- linux-2.6.21-mm.orig/include/asm-v850/system.h	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-mm/include/asm-v850/system.h	2007-04-30 17:54:36.000000000 -0400
@@ -76,7 +76,6 @@ static inline int irqs_disabled (void)
 
 #define xchg(ptr, with) \
   ((__typeof__ (*(ptr)))__xchg ((unsigned long)(with), (ptr), sizeof (*(ptr))))
-#define tas(ptr) (xchg ((ptr), 1))
 
 static inline unsigned long __xchg (unsigned long with,
 				    __volatile__ void *ptr, int size)
Index: linux-2.6.21-mm/include/asm-x86_64/system.h
===================================================================
--- linux-2.6.21-mm.orig/include/asm-x86_64/system.h	2007-04-30 12:38:17.000000000 -0400
+++ linux-2.6.21-mm/include/asm-x86_64/system.h	2007-04-30 18:04:43.000000000 -0400
@@ -126,8 +126,6 @@ static inline void sched_cacheflush(void
 
 #define xchg(ptr,v) ((__typeof__(*(ptr)))__xchg((unsigned long)(v),(ptr),sizeof(*(ptr))))
 
-#define tas(ptr) (xchg((ptr),1))
-
 #define __xg(x) ((volatile long *)(x))
 
 static inline void set_64bit(volatile unsigned long *ptr, unsigned long val)
Index: linux-2.6.21-mm/include/asm-xtensa/system.h
===================================================================
--- linux-2.6.21-mm.orig/include/asm-xtensa/system.h	2007-02-04 13:44:54.000000000 -0500
+++ linux-2.6.21-mm/include/asm-xtensa/system.h	2007-04-30 17:54:36.000000000 -0400
@@ -183,8 +183,6 @@ static inline unsigned long xchg_u32(vol
   return tmp;
 }
 
-#define tas(ptr) (xchg((ptr),1))
-
 #define xchg(ptr,x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
 
 /*

--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=cmpxchg-i386-tas

Rearrange the i386 cmpxchg code to allow atomic.h to get it without
needing to include system.h.  This kills warnings in the UML build
from atomic.h about implicit declarations of cmpxchg symbols.

The cmpxchg stuff is moved to asm-i386/cmpxchg.h, with an include left
in system.h for the benefit of generic code which expects cmpxchg
there.

Meanwhile, atomic.h includes cmpxchg.h.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 include/asm-i386/atomic.h  |    1 
 include/asm-i386/cmpxchg.h |  293 +++++++++++++++++++++++++++++++++++++++++++++
 include/asm-i386/system.h  |  289 --------------------------------------------
 3 files changed, 295 insertions(+), 288 deletions(-)

Index: linux-2.6.21-mm/include/asm-i386/atomic.h
===================================================================
--- linux-2.6.21-mm.orig/include/asm-i386/atomic.h	2007-05-02 11:33:21.000000000 -0400
+++ linux-2.6.21-mm/include/asm-i386/atomic.h	2007-05-02 11:34:05.000000000 -0400
@@ -3,6 +3,7 @@
 
 #include <linux/compiler.h>
 #include <asm/processor.h>
+#include <asm/cmpxchg.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
Index: linux-2.6.21-mm/include/asm-i386/cmpxchg.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.21-mm/include/asm-i386/cmpxchg.h	2007-05-02 11:37:10.000000000 -0400
@@ -0,0 +1,295 @@
+#ifndef __ASM_CMPXCHG_H
+#define __ASM_CMPXCHG_H
+
+#include <linux/bitops.h> /* for LOCK_PREFIX */
+
+#define xchg(ptr,v) ((__typeof__(*(ptr)))__xchg((unsigned long)(v),(ptr),sizeof(*(ptr))))
+
+#define tas(ptr) (xchg((ptr),1))
+
+struct __xchg_dummy { unsigned long a[100]; };
+#define __xg(x) ((struct __xchg_dummy *)(x))
+
+
+#ifdef CONFIG_X86_CMPXCHG64
+
+/*
+ * The semantics of XCHGCMP8B are a bit strange, this is why
+ * there is a loop and the loading of %%eax and %%edx has to
+ * be inside. This inlines well in most cases, the cached
+ * cost is around ~38 cycles. (in the future we might want
+ * to do an SIMD/3DNOW!/MMX/FPU 64-bit store here, but that
+ * might have an implicit FPU-save as a cost, so it's not
+ * clear which path to go.)
+ *
+ * cmpxchg8b must be used with the lock prefix here to allow
+ * the instruction to be executed atomically, see page 3-102
+ * of the instruction set reference 24319102.pdf. We need
+ * the reader side to see the coherent 64bit value.
+ */
+static inline void __set_64bit (unsigned long long * ptr,
+		unsigned int low, unsigned int high)
+{
+	__asm__ __volatile__ (
+		"\n1:\t"
+		"movl (%0), %%eax\n\t"
+		"movl 4(%0), %%edx\n\t"
+		"lock cmpxchg8b (%0)\n\t"
+		"jnz 1b"
+		: /* no outputs */
+		:	"D"(ptr),
+			"b"(low),
+			"c"(high)
+		:	"ax","dx","memory");
+}
+
+static inline void __set_64bit_constant (unsigned long long *ptr,
+						 unsigned long long value)
+{
+	__set_64bit(ptr,(unsigned int)(value), (unsigned int)((value)>>32ULL));
+}
+#define ll_low(x)	*(((unsigned int*)&(x))+0)
+#define ll_high(x)	*(((unsigned int*)&(x))+1)
+
+static inline void __set_64bit_var (unsigned long long *ptr,
+			 unsigned long long value)
+{
+	__set_64bit(ptr,ll_low(value), ll_high(value));
+}
+
+#define set_64bit(ptr,value) \
+(__builtin_constant_p(value) ? \
+ __set_64bit_constant(ptr, value) : \
+ __set_64bit_var(ptr, value) )
+
+#define _set_64bit(ptr,value) \
+(__builtin_constant_p(value) ? \
+ __set_64bit(ptr, (unsigned int)(value), (unsigned int)((value)>>32ULL) ) : \
+ __set_64bit(ptr, ll_low(value), ll_high(value)) )
+
+#endif
+
+/*
+ * Note: no "lock" prefix even on SMP: xchg always implies lock anyway
+ * Note 2: xchg has side effect, so that attribute volatile is necessary,
+ *	  but generally the primitive is invalid, *ptr is output argument. --ANK
+ */
+static inline unsigned long __xchg(unsigned long x, volatile void * ptr, int size)
+{
+	switch (size) {
+		case 1:
+			__asm__ __volatile__("xchgb %b0,%1"
+				:"=q" (x)
+				:"m" (*__xg(ptr)), "0" (x)
+				:"memory");
+			break;
+		case 2:
+			__asm__ __volatile__("xchgw %w0,%1"
+				:"=r" (x)
+				:"m" (*__xg(ptr)), "0" (x)
+				:"memory");
+			break;
+		case 4:
+			__asm__ __volatile__("xchgl %0,%1"
+				:"=r" (x)
+				:"m" (*__xg(ptr)), "0" (x)
+				:"memory");
+			break;
+	}
+	return x;
+}
+
+/*
+ * Atomic compare and exchange.  Compare OLD with MEM, if identical,
+ * store NEW in MEM.  Return the initial value in MEM.  Success is
+ * indicated by comparing RETURN with OLD.
+ */
+
+#ifdef CONFIG_X86_CMPXCHG
+#define __HAVE_ARCH_CMPXCHG 1
+#define cmpxchg(ptr,o,n)\
+	((__typeof__(*(ptr)))__cmpxchg((ptr),(unsigned long)(o),\
+					(unsigned long)(n),sizeof(*(ptr))))
+#define sync_cmpxchg(ptr,o,n)\
+	((__typeof__(*(ptr)))__sync_cmpxchg((ptr),(unsigned long)(o),\
+					(unsigned long)(n),sizeof(*(ptr))))
+#define cmpxchg_local(ptr,o,n)\
+	((__typeof__(*(ptr)))__cmpxchg_local((ptr),(unsigned long)(o),\
+					(unsigned long)(n),sizeof(*(ptr))))
+#endif
+
+static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
+				      unsigned long new, int size)
+{
+	unsigned long prev;
+	switch (size) {
+	case 1:
+		__asm__ __volatile__(LOCK_PREFIX "cmpxchgb %b1,%2"
+				     : "=a"(prev)
+				     : "q"(new), "m"(*__xg(ptr)), "0"(old)
+				     : "memory");
+		return prev;
+	case 2:
+		__asm__ __volatile__(LOCK_PREFIX "cmpxchgw %w1,%2"
+				     : "=a"(prev)
+				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+				     : "memory");
+		return prev;
+	case 4:
+		__asm__ __volatile__(LOCK_PREFIX "cmpxchgl %1,%2"
+				     : "=a"(prev)
+				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+				     : "memory");
+		return prev;
+	}
+	return old;
+}
+
+/*
+ * Always use locked operations when touching memory shared with a
+ * hypervisor, since the system may be SMP even if the guest kernel
+ * isn't.
+ */
+static inline unsigned long __sync_cmpxchg(volatile void *ptr,
+					    unsigned long old,
+					    unsigned long new, int size)
+{
+	unsigned long prev;
+	switch (size) {
+	case 1:
+		__asm__ __volatile__("lock; cmpxchgb %b1,%2"
+				     : "=a"(prev)
+				     : "q"(new), "m"(*__xg(ptr)), "0"(old)
+				     : "memory");
+		return prev;
+	case 2:
+		__asm__ __volatile__("lock; cmpxchgw %w1,%2"
+				     : "=a"(prev)
+				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+				     : "memory");
+		return prev;
+	case 4:
+		__asm__ __volatile__("lock; cmpxchgl %1,%2"
+				     : "=a"(prev)
+				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+				     : "memory");
+		return prev;
+	}
+	return old;
+}
+
+static inline unsigned long __cmpxchg_local(volatile void *ptr,
+			unsigned long old, unsigned long new, int size)
+{
+	unsigned long prev;
+	switch (size) {
+	case 1:
+		__asm__ __volatile__("cmpxchgb %b1,%2"
+				     : "=a"(prev)
+				     : "q"(new), "m"(*__xg(ptr)), "0"(old)
+				     : "memory");
+		return prev;
+	case 2:
+		__asm__ __volatile__("cmpxchgw %w1,%2"
+				     : "=a"(prev)
+				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+				     : "memory");
+		return prev;
+	case 4:
+		__asm__ __volatile__("cmpxchgl %1,%2"
+				     : "=a"(prev)
+				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+				     : "memory");
+		return prev;
+	}
+	return old;
+}
+
+#ifndef CONFIG_X86_CMPXCHG
+/*
+ * Building a kernel capable running on 80386. It may be necessary to
+ * simulate the cmpxchg on the 80386 CPU. For that purpose we define
+ * a function for each of the sizes we support.
+ */
+
+extern unsigned long cmpxchg_386_u8(volatile void *, u8, u8);
+extern unsigned long cmpxchg_386_u16(volatile void *, u16, u16);
+extern unsigned long cmpxchg_386_u32(volatile void *, u32, u32);
+
+static inline unsigned long cmpxchg_386(volatile void *ptr, unsigned long old,
+				      unsigned long new, int size)
+{
+	switch (size) {
+	case 1:
+		return cmpxchg_386_u8(ptr, old, new);
+	case 2:
+		return cmpxchg_386_u16(ptr, old, new);
+	case 4:
+		return cmpxchg_386_u32(ptr, old, new);
+	}
+	return old;
+}
+
+#define cmpxchg(ptr,o,n)						\
+({									\
+	__typeof__(*(ptr)) __ret;					\
+	if (likely(boot_cpu_data.x86 > 3))				\
+		__ret = __cmpxchg((ptr), (unsigned long)(o),		\
+					(unsigned long)(n), sizeof(*(ptr))); \
+	else								\
+		__ret = cmpxchg_386((ptr), (unsigned long)(o),		\
+					(unsigned long)(n), sizeof(*(ptr))); \
+	__ret;								\
+})
+#define cmpxchg_local(ptr,o,n)						\
+({									\
+	__typeof__(*(ptr)) __ret;					\
+	if (likely(boot_cpu_data.x86 > 3))				\
+		__ret = __cmpxchg_local((ptr), (unsigned long)(o),	\
+					(unsigned long)(n), sizeof(*(ptr))); \
+	else								\
+		__ret = cmpxchg_386((ptr), (unsigned long)(o),		\
+					(unsigned long)(n), sizeof(*(ptr))); \
+	__ret;								\
+})
+#endif
+
+#ifdef CONFIG_X86_CMPXCHG64
+
+static inline unsigned long long __cmpxchg64(volatile void *ptr, unsigned long long old,
+				      unsigned long long new)
+{
+	unsigned long long prev;
+	__asm__ __volatile__(LOCK_PREFIX "cmpxchg8b %3"
+			     : "=A"(prev)
+			     : "b"((unsigned long)new),
+			       "c"((unsigned long)(new >> 32)),
+			       "m"(*__xg(ptr)),
+			       "0"(old)
+			     : "memory");
+	return prev;
+}
+
+static inline unsigned long long __cmpxchg64_local(volatile void *ptr,
+			unsigned long long old, unsigned long long new)
+{
+	unsigned long long prev;
+	__asm__ __volatile__("cmpxchg8b %3"
+			     : "=A"(prev)
+			     : "b"((unsigned long)new),
+			       "c"((unsigned long)(new >> 32)),
+			       "m"(*__xg(ptr)),
+			       "0"(old)
+			     : "memory");
+	return prev;
+}
+
+#define cmpxchg64(ptr,o,n)\
+	((__typeof__(*(ptr)))__cmpxchg64((ptr),(unsigned long long)(o),\
+					(unsigned long long)(n)))
+#define cmpxchg64_local(ptr,o,n)\
+	((__typeof__(*(ptr)))__cmpxchg64_local((ptr),(unsigned long long)(o),\
+					(unsigned long long)(n)))
+#endif
+
+#endif
Index: linux-2.6.21-mm/include/asm-i386/system.h
===================================================================
--- linux-2.6.21-mm.orig/include/asm-i386/system.h	2007-05-02 11:33:21.000000000 -0400
+++ linux-2.6.21-mm/include/asm-i386/system.h	2007-05-02 11:35:35.000000000 -0400
@@ -4,7 +4,7 @@
 #include <linux/kernel.h>
 #include <asm/segment.h>
 #include <asm/cpufeature.h>
-#include <linux/bitops.h> /* for LOCK_PREFIX */
+#include <asm/cmpxchg.h>
 
 #ifdef __KERNEL__
 
@@ -195,295 +195,6 @@ static inline unsigned long get_limit(un
 
 #define nop() __asm__ __volatile__ ("nop")
 
-#define xchg(ptr,v) ((__typeof__(*(ptr)))__xchg((unsigned long)(v),(ptr),sizeof(*(ptr))))
-
-#define tas(ptr) (xchg((ptr),1))
-
-struct __xchg_dummy { unsigned long a[100]; };
-#define __xg(x) ((struct __xchg_dummy *)(x))
-
-
-#ifdef CONFIG_X86_CMPXCHG64
-
-/*
- * The semantics of XCHGCMP8B are a bit strange, this is why
- * there is a loop and the loading of %%eax and %%edx has to
- * be inside. This inlines well in most cases, the cached
- * cost is around ~38 cycles. (in the future we might want
- * to do an SIMD/3DNOW!/MMX/FPU 64-bit store here, but that
- * might have an implicit FPU-save as a cost, so it's not
- * clear which path to go.)
- *
- * cmpxchg8b must be used with the lock prefix here to allow
- * the instruction to be executed atomically, see page 3-102
- * of the instruction set reference 24319102.pdf. We need
- * the reader side to see the coherent 64bit value.
- */
-static inline void __set_64bit (unsigned long long * ptr,
-		unsigned int low, unsigned int high)
-{
-	__asm__ __volatile__ (
-		"\n1:\t"
-		"movl (%0), %%eax\n\t"
-		"movl 4(%0), %%edx\n\t"
-		"lock cmpxchg8b (%0)\n\t"
-		"jnz 1b"
-		: /* no outputs */
-		:	"D"(ptr),
-			"b"(low),
-			"c"(high)
-		:	"ax","dx","memory");
-}
-
-static inline void __set_64bit_constant (unsigned long long *ptr,
-						 unsigned long long value)
-{
-	__set_64bit(ptr,(unsigned int)(value), (unsigned int)((value)>>32ULL));
-}
-#define ll_low(x)	*(((unsigned int*)&(x))+0)
-#define ll_high(x)	*(((unsigned int*)&(x))+1)
-
-static inline void __set_64bit_var (unsigned long long *ptr,
-			 unsigned long long value)
-{
-	__set_64bit(ptr,ll_low(value), ll_high(value));
-}
-
-#define set_64bit(ptr,value) \
-(__builtin_constant_p(value) ? \
- __set_64bit_constant(ptr, value) : \
- __set_64bit_var(ptr, value) )
-
-#define _set_64bit(ptr,value) \
-(__builtin_constant_p(value) ? \
- __set_64bit(ptr, (unsigned int)(value), (unsigned int)((value)>>32ULL) ) : \
- __set_64bit(ptr, ll_low(value), ll_high(value)) )
-
-#endif
-
-/*
- * Note: no "lock" prefix even on SMP: xchg always implies lock anyway
- * Note 2: xchg has side effect, so that attribute volatile is necessary,
- *	  but generally the primitive is invalid, *ptr is output argument. --ANK
- */
-static inline unsigned long __xchg(unsigned long x, volatile void * ptr, int size)
-{
-	switch (size) {
-		case 1:
-			__asm__ __volatile__("xchgb %b0,%1"
-				:"=q" (x)
-				:"m" (*__xg(ptr)), "0" (x)
-				:"memory");
-			break;
-		case 2:
-			__asm__ __volatile__("xchgw %w0,%1"
-				:"=r" (x)
-				:"m" (*__xg(ptr)), "0" (x)
-				:"memory");
-			break;
-		case 4:
-			__asm__ __volatile__("xchgl %0,%1"
-				:"=r" (x)
-				:"m" (*__xg(ptr)), "0" (x)
-				:"memory");
-			break;
-	}
-	return x;
-}
-
-/*
- * Atomic compare and exchange.  Compare OLD with MEM, if identical,
- * store NEW in MEM.  Return the initial value in MEM.  Success is
- * indicated by comparing RETURN with OLD.
- */
-
-#ifdef CONFIG_X86_CMPXCHG
-#define __HAVE_ARCH_CMPXCHG 1
-#define cmpxchg(ptr,o,n)\
-	((__typeof__(*(ptr)))__cmpxchg((ptr),(unsigned long)(o),\
-					(unsigned long)(n),sizeof(*(ptr))))
-#define sync_cmpxchg(ptr,o,n)\
-	((__typeof__(*(ptr)))__sync_cmpxchg((ptr),(unsigned long)(o),\
-					(unsigned long)(n),sizeof(*(ptr))))
-#define cmpxchg_local(ptr,o,n)\
-	((__typeof__(*(ptr)))__cmpxchg_local((ptr),(unsigned long)(o),\
-					(unsigned long)(n),sizeof(*(ptr))))
-#endif
-
-static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
-				      unsigned long new, int size)
-{
-	unsigned long prev;
-	switch (size) {
-	case 1:
-		__asm__ __volatile__(LOCK_PREFIX "cmpxchgb %b1,%2"
-				     : "=a"(prev)
-				     : "q"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
-		return prev;
-	case 2:
-		__asm__ __volatile__(LOCK_PREFIX "cmpxchgw %w1,%2"
-				     : "=a"(prev)
-				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
-		return prev;
-	case 4:
-		__asm__ __volatile__(LOCK_PREFIX "cmpxchgl %1,%2"
-				     : "=a"(prev)
-				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
-		return prev;
-	}
-	return old;
-}
-
-/*
- * Always use locked operations when touching memory shared with a
- * hypervisor, since the system may be SMP even if the guest kernel
- * isn't.
- */
-static inline unsigned long __sync_cmpxchg(volatile void *ptr,
-					    unsigned long old,
-					    unsigned long new, int size)
-{
-	unsigned long prev;
-	switch (size) {
-	case 1:
-		__asm__ __volatile__("lock; cmpxchgb %b1,%2"
-				     : "=a"(prev)
-				     : "q"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
-		return prev;
-	case 2:
-		__asm__ __volatile__("lock; cmpxchgw %w1,%2"
-				     : "=a"(prev)
-				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
-		return prev;
-	case 4:
-		__asm__ __volatile__("lock; cmpxchgl %1,%2"
-				     : "=a"(prev)
-				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
-		return prev;
-	}
-	return old;
-}
-
-static inline unsigned long __cmpxchg_local(volatile void *ptr,
-			unsigned long old, unsigned long new, int size)
-{
-	unsigned long prev;
-	switch (size) {
-	case 1:
-		__asm__ __volatile__("cmpxchgb %b1,%2"
-				     : "=a"(prev)
-				     : "q"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
-		return prev;
-	case 2:
-		__asm__ __volatile__("cmpxchgw %w1,%2"
-				     : "=a"(prev)
-				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
-		return prev;
-	case 4:
-		__asm__ __volatile__("cmpxchgl %1,%2"
-				     : "=a"(prev)
-				     : "r"(new), "m"(*__xg(ptr)), "0"(old)
-				     : "memory");
-		return prev;
-	}
-	return old;
-}
-
-#ifndef CONFIG_X86_CMPXCHG
-/*
- * Building a kernel capable running on 80386. It may be necessary to
- * simulate the cmpxchg on the 80386 CPU. For that purpose we define
- * a function for each of the sizes we support.
- */
-
-extern unsigned long cmpxchg_386_u8(volatile void *, u8, u8);
-extern unsigned long cmpxchg_386_u16(volatile void *, u16, u16);
-extern unsigned long cmpxchg_386_u32(volatile void *, u32, u32);
-
-static inline unsigned long cmpxchg_386(volatile void *ptr, unsigned long old,
-				      unsigned long new, int size)
-{
-	switch (size) {
-	case 1:
-		return cmpxchg_386_u8(ptr, old, new);
-	case 2:
-		return cmpxchg_386_u16(ptr, old, new);
-	case 4:
-		return cmpxchg_386_u32(ptr, old, new);
-	}
-	return old;
-}
-
-#define cmpxchg(ptr,o,n)						\
-({									\
-	__typeof__(*(ptr)) __ret;					\
-	if (likely(boot_cpu_data.x86 > 3))				\
-		__ret = __cmpxchg((ptr), (unsigned long)(o),		\
-					(unsigned long)(n), sizeof(*(ptr))); \
-	else								\
-		__ret = cmpxchg_386((ptr), (unsigned long)(o),		\
-					(unsigned long)(n), sizeof(*(ptr))); \
-	__ret;								\
-})
-#define cmpxchg_local(ptr,o,n)						\
-({									\
-	__typeof__(*(ptr)) __ret;					\
-	if (likely(boot_cpu_data.x86 > 3))				\
-		__ret = __cmpxchg_local((ptr), (unsigned long)(o),	\
-					(unsigned long)(n), sizeof(*(ptr))); \
-	else								\
-		__ret = cmpxchg_386((ptr), (unsigned long)(o),		\
-					(unsigned long)(n), sizeof(*(ptr))); \
-	__ret;								\
-})
-#endif
-
-#ifdef CONFIG_X86_CMPXCHG64
-
-static inline unsigned long long __cmpxchg64(volatile void *ptr, unsigned long long old,
-				      unsigned long long new)
-{
-	unsigned long long prev;
-	__asm__ __volatile__(LOCK_PREFIX "cmpxchg8b %3"
-			     : "=A"(prev)
-			     : "b"((unsigned long)new),
-			       "c"((unsigned long)(new >> 32)),
-			       "m"(*__xg(ptr)),
-			       "0"(old)
-			     : "memory");
-	return prev;
-}
-
-static inline unsigned long long __cmpxchg64_local(volatile void *ptr,
-			unsigned long long old, unsigned long long new)
-{
-	unsigned long long prev;
-	__asm__ __volatile__("cmpxchg8b %3"
-			     : "=A"(prev)
-			     : "b"((unsigned long)new),
-			       "c"((unsigned long)(new >> 32)),
-			       "m"(*__xg(ptr)),
-			       "0"(old)
-			     : "memory");
-	return prev;
-}
-
-#define cmpxchg64(ptr,o,n)\
-	((__typeof__(*(ptr)))__cmpxchg64((ptr),(unsigned long long)(o),\
-					(unsigned long long)(n)))
-#define cmpxchg64_local(ptr,o,n)\
-	((__typeof__(*(ptr)))__cmpxchg64_local((ptr),(unsigned long long)(o),\
-					(unsigned long long)(n)))
-#endif
-    
 /*
  * Force strict CPU ordering.
  * And yes, this is required on UP too when we're talking

--HlL+5n6rz5pIUxbD--
