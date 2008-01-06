Return-Path: <linux-kernel-owner+w=401wt.eu-S1755960AbYAFDPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960AbYAFDPN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 22:15:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754809AbYAFDN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 22:13:57 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57785 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740AbYAFDN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 22:13:56 -0500
Date: Sat, 5 Jan 2008 19:11:51 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, akpm@linux-foundation.org,
       heiko.carstens@de.ibm.com, olof@lixom.net, mingo@elte.hu,
       mpm@selenic.com
Subject: [patch 4/5] bugh-remove-have_arch_bug--have_arch_warn
Message-ID: <20080105191151.2a4797c7@laptopd505.fenrus.org>
In-Reply-To: <20080105190713.73745ec6@laptopd505.fenrus.org>
References: <20080105190713.73745ec6@laptopd505.fenrus.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olof Johansson <olof@lixom.net>

No need to have the HAVE_ARCH_BUG.* / HAVE_ARCH_WARN.* defines, when
the generic implementation can just use #ifndef on the macros themselves.

Signed-off-by: Olof Johansson <olof@lixom.net>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/bug.h   |    1 -
 include/asm-arm/bug.h     |    1 -
 include/asm-avr32/bug.h   |    3 ---
 include/asm-frv/bug.h     |    1 -
 include/asm-generic/bug.h |   10 +++++-----
 include/asm-ia64/bug.h    |    1 -
 include/asm-m68k/bug.h    |    1 -
 include/asm-mips/bug.h    |    4 ----
 include/asm-parisc/bug.h  |    2 --
 include/asm-powerpc/bug.h |    3 ---
 include/asm-s390/bug.h    |    2 --
 include/asm-sparc/bug.h   |    1 -
 include/asm-sparc64/bug.h |    1 -
 include/asm-v850/bug.h    |    1 -
 include/asm-x86/bug.h     |    1 -
 15 files changed, 5 insertions(+), 28 deletions(-)

Index: linux-2.6.24-rc6/include/asm-alpha/bug.h
===================================================================
--- linux-2.6.24-rc6.orig/include/asm-alpha/bug.h
+++ linux-2.6.24-rc6/include/asm-alpha/bug.h
@@ -10,7 +10,6 @@
   __asm__ __volatile__("call_pal %0  # bugchk\n\t"".long %1\n\t.8byte %2" \
 		       : : "i" (PAL_bugchk), "i"(__LINE__), "i"(__FILE__))
 
-#define HAVE_ARCH_BUG
 #endif
 
 #include <asm-generic/bug.h>
Index: linux-2.6.24-rc6/include/asm-arm/bug.h
===================================================================
--- linux-2.6.24-rc6.orig/include/asm-arm/bug.h
+++ linux-2.6.24-rc6/include/asm-arm/bug.h
@@ -16,7 +16,6 @@ extern void __bug(const char *file, int 
 
 #endif
 
-#define HAVE_ARCH_BUG
 #endif
 
 #include <asm-generic/bug.h>
Index: linux-2.6.24-rc6/include/asm-avr32/bug.h
===================================================================
--- linux-2.6.24-rc6.orig/include/asm-avr32/bug.h
+++ linux-2.6.24-rc6/include/asm-avr32/bug.h
@@ -63,9 +63,6 @@
 		unlikely(__ret_warn_on);				\
 	})
 
-#define HAVE_ARCH_BUG
-#define HAVE_ARCH_WARN_ON
-
 #endif /* CONFIG_BUG */
 
 #include <asm-generic/bug.h>
Index: linux-2.6.24-rc6/include/asm-frv/bug.h
===================================================================
--- linux-2.6.24-rc6.orig/include/asm-frv/bug.h
+++ linux-2.6.24-rc6/include/asm-frv/bug.h
@@ -32,7 +32,6 @@ do {						\
 	asm volatile("nop");			\
 } while(0)
 
-#define HAVE_ARCH_BUG
 #define BUG()					\
 do {						\
 	_debug_bug_printk();			\
Index: linux-2.6.24-rc6/include/asm-generic/bug.h
===================================================================
--- linux-2.6.24-rc6.orig/include/asm-generic/bug.h
+++ linux-2.6.24-rc6/include/asm-generic/bug.h
@@ -20,14 +20,14 @@ struct bug_entry {
 #define BUGFLAG_WARNING	(1<<0)
 #endif	/* CONFIG_GENERIC_BUG */
 
-#ifndef HAVE_ARCH_BUG
+#ifndef BUG
 #define BUG() do { \
 	printk("BUG: failure at %s:%d/%s()!\n", __FILE__, __LINE__, __FUNCTION__); \
 	panic("BUG!"); \
 } while (0)
 #endif
 
-#ifndef HAVE_ARCH_BUG_ON
+#ifndef BUG_ON
 #define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while(0)
 #endif
 
@@ -49,15 +49,15 @@ extern void warn_on_slowpath(const char 
 #endif
 
 #else /* !CONFIG_BUG */
-#ifndef HAVE_ARCH_BUG
+#ifndef BUG
 #define BUG()
 #endif
 
-#ifndef HAVE_ARCH_BUG_ON
+#ifndef BUG_ON
 #define BUG_ON(condition) do { if (condition) ; } while(0)
 #endif
 
-#ifndef HAVE_ARCH_WARN_ON
+#ifndef WARN_ON
 #define WARN_ON(condition) ({						\
 	int __ret_warn_on = !!(condition);				\
 	unlikely(__ret_warn_on);					\
Index: linux-2.6.24-rc6/include/asm-ia64/bug.h
===================================================================
--- linux-2.6.24-rc6.orig/include/asm-ia64/bug.h
+++ linux-2.6.24-rc6/include/asm-ia64/bug.h
@@ -6,7 +6,6 @@
 #define BUG() do { printk("kernel BUG at %s:%d!\n", __FILE__, __LINE__); ia64_abort(); } while (0)
 
 /* should this BUG be made generic? */
-#define HAVE_ARCH_BUG
 #endif
 
 #include <asm-generic/bug.h>
Index: linux-2.6.24-rc6/include/asm-m68k/bug.h
===================================================================
--- linux-2.6.24-rc6.orig/include/asm-m68k/bug.h
+++ linux-2.6.24-rc6/include/asm-m68k/bug.h
@@ -21,7 +21,6 @@
 } while (0)
 #endif
 
-#define HAVE_ARCH_BUG
 #endif
 
 #include <asm-generic/bug.h>
Index: linux-2.6.24-rc6/include/asm-mips/bug.h
===================================================================
--- linux-2.6.24-rc6.orig/include/asm-mips/bug.h
+++ linux-2.6.24-rc6/include/asm-mips/bug.h
@@ -12,8 +12,6 @@ do {									\
 	__asm__ __volatile__("break %0" : : "i" (BRK_BUG));		\
 } while (0)
 
-#define HAVE_ARCH_BUG
-
 #if (_MIPS_ISA > _MIPS_ISA_MIPS1)
 
 #define BUG_ON(condition)						\
@@ -22,8 +20,6 @@ do {									\
 			     : : "r" (condition), "i" (BRK_BUG));	\
 } while (0)
 
-#define HAVE_ARCH_BUG_ON
-
 #endif /* _MIPS_ISA > _MIPS_ISA_MIPS1 */
 
 #endif
Index: linux-2.6.24-rc6/include/asm-parisc/bug.h
===================================================================
--- linux-2.6.24-rc6.orig/include/asm-parisc/bug.h
+++ linux-2.6.24-rc6/include/asm-parisc/bug.h
@@ -7,8 +7,6 @@
  */
 
 #ifdef CONFIG_BUG
-#define HAVE_ARCH_BUG
-#define HAVE_ARCH_WARN_ON
 
 /* the break instruction is used as BUG() marker.  */
 #define	PARISC_BUG_BREAK_ASM	"break 0x1f, 0x1fff"
Index: linux-2.6.24-rc6/include/asm-powerpc/bug.h
===================================================================
--- linux-2.6.24-rc6.orig/include/asm-powerpc/bug.h
+++ linux-2.6.24-rc6/include/asm-powerpc/bug.h
@@ -109,9 +109,6 @@
 	unlikely(__ret_warn_on);				\
 })
 
-#define HAVE_ARCH_BUG
-#define HAVE_ARCH_BUG_ON
-#define HAVE_ARCH_WARN_ON
 #endif /* __ASSEMBLY __ */
 #endif /* CONFIG_BUG */
 
Index: linux-2.6.24-rc6/include/asm-s390/bug.h
===================================================================
--- linux-2.6.24-rc6.orig/include/asm-s390/bug.h
+++ linux-2.6.24-rc6/include/asm-s390/bug.h
@@ -61,8 +61,6 @@
 	unlikely(__ret_warn_on);			\
 })
 
-#define HAVE_ARCH_BUG
-#define HAVE_ARCH_WARN_ON
 #endif /* CONFIG_BUG */
 
 #include <asm-generic/bug.h>
Index: linux-2.6.24-rc6/include/asm-sparc/bug.h
===================================================================
--- linux-2.6.24-rc6.orig/include/asm-sparc/bug.h
+++ linux-2.6.24-rc6/include/asm-sparc/bug.h
@@ -26,7 +26,6 @@ extern void do_BUG(const char *file, int
 #define BUG()		__bug_trap()
 #endif
 
-#define HAVE_ARCH_BUG
 #endif
 
 #include <asm-generic/bug.h>
Index: linux-2.6.24-rc6/include/asm-sparc64/bug.h
===================================================================
--- linux-2.6.24-rc6.orig/include/asm-sparc64/bug.h
+++ linux-2.6.24-rc6/include/asm-sparc64/bug.h
@@ -14,7 +14,6 @@ extern void do_BUG(const char *file, int
 #define BUG()		__builtin_trap()
 #endif
 
-#define HAVE_ARCH_BUG
 #endif
 
 #include <asm-generic/bug.h>
Index: linux-2.6.24-rc6/include/asm-v850/bug.h
===================================================================
--- linux-2.6.24-rc6.orig/include/asm-v850/bug.h
+++ linux-2.6.24-rc6/include/asm-v850/bug.h
@@ -17,7 +17,6 @@
 #ifdef CONFIG_BUG
 extern void __bug (void) __attribute__ ((noreturn));
 #define BUG()		__bug()
-#define HAVE_ARCH_BUG
 #endif
 
 #include <asm-generic/bug.h>
Index: linux-2.6.24-rc6/include/asm-x86/bug.h
===================================================================
--- linux-2.6.24-rc6.orig/include/asm-x86/bug.h
+++ linux-2.6.24-rc6/include/asm-x86/bug.h
@@ -2,7 +2,6 @@
 #define _ASM_X86_BUG_H
 
 #ifdef CONFIG_BUG
-#define HAVE_ARCH_BUG
 
 #ifdef CONFIG_DEBUG_BUGVERBOSE
 


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
