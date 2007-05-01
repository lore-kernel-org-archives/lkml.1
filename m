Return-Path: <linux-kernel-owner+w=401wt.eu-S1030956AbXEAS0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030956AbXEAS0L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 14:26:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030972AbXEAS0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 14:26:11 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:38462 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030956AbXEAS0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 14:26:09 -0400
Date: Tue, 1 May 2007 14:21:56 -0400
From: Jeff Dike <jdike@addtoit.com>
To: akpm@osdl.org, linux-arch@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/6] Remove tas()
Message-ID: <20070501182156.GA8342@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

tas() has no users, so get rid of it.

The blackfin piece of this clashes with mainline, so this should maybe
be merged with the blackfin port.

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
