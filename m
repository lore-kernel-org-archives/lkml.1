Return-Path: <linux-kernel-owner+w=401wt.eu-S1760961AbXKUQRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760961AbXKUQRN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 11:17:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758966AbXKUQQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 11:16:46 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47357 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757707AbXKUQQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 11:16:43 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/9] AOUT: Move STACK_TOP[_MAX] to asm/processor.h
	[2.6.24-rc3-mm1]
To: akpm@linux-foundation.org
Cc: dhowells@redhat.com, linux-am33-list@redhat.com,
       linux-kernel@vger.kernel.org
Date: Wed, 21 Nov 2007 16:16:32 +0000
Message-ID: <20071121161632.1097.9556.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move STACK_TOP[_MAX] out of asm/a.out.h and into asm/processor.h as they're
required whether or not A.OUT format is available.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/asm-alpha/a.out.h          |    8 +-------
 include/asm-alpha/processor.h      |    5 +++++
 include/asm-arm/a.out.h            |    6 ------
 include/asm-arm/processor.h        |    6 ++++++
 include/asm-avr32/a.out.h          |    7 -------
 include/asm-avr32/processor.h      |    5 +++++
 include/asm-blackfin/a.out.h       |    6 ------
 include/asm-blackfin/processor.h   |    4 ++++
 include/asm-cris/a.out.h           |    6 ------
 include/asm-cris/processor.h       |    3 +++
 include/asm-h8300/a.out.h          |    7 -------
 include/asm-h8300/processor.h      |    5 +++++
 include/asm-ia64/a.out.h           |    3 ---
 include/asm-m32r/a.out.h           |    7 -------
 include/asm-m32r/processor.h       |    5 +++++
 include/asm-m68k/a.out.h           |    7 -------
 include/asm-m68k/processor.h       |    5 +++++
 include/asm-mips/a.out.h           |   13 -------------
 include/asm-mips/processor.h       |    7 +++++++
 include/asm-parisc/a.out.h         |   10 ----------
 include/asm-parisc/processor.h     |   10 ++++++++++
 include/asm-powerpc/a.out.h        |   19 -------------------
 include/asm-powerpc/processor.h    |   19 +++++++++++++++++++
 include/asm-s390/a.out.h           |    7 -------
 include/asm-s390/processor.h       |    7 +++++++
 include/asm-sh/a.out.h             |    7 -------
 include/asm-sh/processor.h         |    7 +++++++
 include/asm-sh64/a.out.h           |    7 -------
 include/asm-sparc/a.out.h          |    9 ---------
 include/asm-sparc/processor.h      |    4 ++++
 include/asm-sparc64/a.out.h        |   12 ------------
 include/asm-sparc64/processor.h    |   12 ++++++++++++
 include/asm-sparc64/user.h         |    2 +-
 include/asm-um/a.out.h             |   13 -------------
 include/asm-um/processor-generic.h |    8 ++++++++
 include/asm-x86/a.out.h            |   10 ----------
 include/asm-x86/processor_32.h     |    2 ++
 include/asm-x86/processor_64.h     |    2 ++
 include/asm-xtensa/a.out.h         |    5 -----
 include/asm-xtensa/processor.h     |    2 ++
 40 files changed, 120 insertions(+), 169 deletions(-)

diff --git a/include/asm-alpha/a.out.h b/include/asm-alpha/a.out.h
index e43cf61..02ce847 100644
--- a/include/asm-alpha/a.out.h
+++ b/include/asm-alpha/a.out.h
@@ -98,11 +98,5 @@ struct exec
 	set_personality (((BFPM->sh_bang || EX.ah.entry < 0x100000000L \
 			   ? ADDR_LIMIT_32BIT : 0) | PER_OSF4))
 
-#define STACK_TOP \
-  (current->personality & ADDR_LIMIT_32BIT ? 0x80000000 : 0x00120000000UL)
-
-#define STACK_TOP_MAX	0x00120000000UL
-
-#endif
-
+#endif /* __KERNEL__ */
 #endif /* __A_OUT_GNU_H__ */
diff --git a/include/asm-alpha/processor.h b/include/asm-alpha/processor.h
index 425b7b6..94afe58 100644
--- a/include/asm-alpha/processor.h
+++ b/include/asm-alpha/processor.h
@@ -20,6 +20,11 @@
  */
 #define TASK_SIZE (0x40000000000UL)
 
+#define STACK_TOP \
+  (current->personality & ADDR_LIMIT_32BIT ? 0x80000000 : 0x00120000000UL)
+
+#define STACK_TOP_MAX	0x00120000000UL
+
 /* This decides where the kernel will search for a free chunk of vm
  * space during mmap's.
  */
diff --git a/include/asm-arm/a.out.h b/include/asm-arm/a.out.h
index d7165e8..79489fd 100644
--- a/include/asm-arm/a.out.h
+++ b/include/asm-arm/a.out.h
@@ -27,12 +27,6 @@ struct exec
 
 #define M_ARM 103
 
-#ifdef __KERNEL__
-#define STACK_TOP	((current->personality == PER_LINUX_32BIT) ? \
-			 TASK_SIZE : TASK_SIZE_26)
-#define STACK_TOP_MAX	TASK_SIZE
-#endif
-
 #ifndef LIBRARY_START_TEXT
 #define LIBRARY_START_TEXT	(0x00c00000)
 #endif
diff --git a/include/asm-arm/processor.h b/include/asm-arm/processor.h
index 1bbf161..bd8029e 100644
--- a/include/asm-arm/processor.h
+++ b/include/asm-arm/processor.h
@@ -22,6 +22,12 @@
 #include <asm/ptrace.h>
 #include <asm/types.h>
 
+#ifdef __KERNEL__
+#define STACK_TOP	((current->personality == PER_LINUX_32BIT) ? \
+			 TASK_SIZE : TASK_SIZE_26)
+#define STACK_TOP_MAX	TASK_SIZE
+#endif
+
 union debug_insn {
 	u32	arm;
 	u16	thumb;
diff --git a/include/asm-avr32/a.out.h b/include/asm-avr32/a.out.h
index 9f398ab..e46375a 100644
--- a/include/asm-avr32/a.out.h
+++ b/include/asm-avr32/a.out.h
@@ -17,11 +17,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-
-#define STACK_TOP	TASK_SIZE
-#define STACK_TOP_MAX	STACK_TOP
-
-#endif
-
 #endif /* __ASM_AVR32_A_OUT_H */
diff --git a/include/asm-avr32/processor.h b/include/asm-avr32/processor.h
index 6a64833..545520e 100644
--- a/include/asm-avr32/processor.h
+++ b/include/asm-avr32/processor.h
@@ -13,6 +13,11 @@
 
 #define TASK_SIZE	0x80000000
 
+#ifdef __KERNEL__
+#define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
+#endif
+
 #ifndef __ASSEMBLY__
 
 static inline void *current_text_addr(void)
diff --git a/include/asm-blackfin/a.out.h b/include/asm-blackfin/a.out.h
index d37a684..6c3d652 100644
--- a/include/asm-blackfin/a.out.h
+++ b/include/asm-blackfin/a.out.h
@@ -16,10 +16,4 @@ struct exec {
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-
-#define STACK_TOP	TASK_SIZE
-
-#endif
-
 #endif				/* __BFIN_A_OUT_H__ */
diff --git a/include/asm-blackfin/processor.h b/include/asm-blackfin/processor.h
index c571e95..1033e5c 100644
--- a/include/asm-blackfin/processor.h
+++ b/include/asm-blackfin/processor.h
@@ -30,6 +30,10 @@ static inline void wrusp(unsigned long usp)
 extern unsigned long memory_end;
 #define TASK_SIZE	(memory_end)
 
+#ifdef __KERNEL__
+#define STACK_TOP	TASK_SIZE
+#endif
+
 #define TASK_UNMAPPED_BASE	0
 
 struct thread_struct {
diff --git a/include/asm-cris/a.out.h b/include/asm-cris/a.out.h
index 919b34a..c82e9f9 100644
--- a/include/asm-cris/a.out.h
+++ b/include/asm-cris/a.out.h
@@ -6,11 +6,6 @@
  * wants to know about a.out even if there is no interpreter available...
  */
 
-/* grabbed from the intel stuff  */   
-#define STACK_TOP TASK_SIZE
-#define STACK_TOP_MAX	STACK_TOP
-
-
 struct exec
 {
   unsigned long a_info;		/* Use macros N_MAGIC, etc for access */
@@ -28,5 +23,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-
 #endif
diff --git a/include/asm-cris/processor.h b/include/asm-cris/processor.h
index 568da1d..cdc0c1d 100644
--- a/include/asm-cris/processor.h
+++ b/include/asm-cris/processor.h
@@ -17,6 +17,9 @@
 
 struct task_struct;
 
+#define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
+
 /* This decides where the kernel will search for a free chunk of vm
  * space during mmap's.
  */
diff --git a/include/asm-h8300/a.out.h b/include/asm-h8300/a.out.h
index aa5d227..ded780f 100644
--- a/include/asm-h8300/a.out.h
+++ b/include/asm-h8300/a.out.h
@@ -17,11 +17,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-
-#define STACK_TOP	TASK_SIZE
-#define STACK_TOP_MAX	STACK_TOP
-
-#endif
-
 #endif /* __H8300_A_OUT_H__ */
diff --git a/include/asm-h8300/processor.h b/include/asm-h8300/processor.h
index 49fc886..69e8a34 100644
--- a/include/asm-h8300/processor.h
+++ b/include/asm-h8300/processor.h
@@ -39,6 +39,11 @@ static inline void wrusp(unsigned long usp) {
  */
 #define TASK_SIZE	(0xFFFFFFFFUL)
 
+#ifdef __KERNEL__
+#define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
+#endif
+
 /*
  * This decides where the kernel will search for a free chunk of vm
  * space during mmap's. We won't be using it
diff --git a/include/asm-ia64/a.out.h b/include/asm-ia64/a.out.h
index 7293ac1..193dcfb 100644
--- a/include/asm-ia64/a.out.h
+++ b/include/asm-ia64/a.out.h
@@ -29,7 +29,4 @@ struct exec {
 #define N_SYMSIZE(x)	0
 #define N_TXTOFF(x)	0
 
-#ifdef __KERNEL__
-#include <asm/ustack.h>
-#endif
 #endif /* _ASM_IA64_A_OUT_H */
diff --git a/include/asm-m32r/a.out.h b/include/asm-m32r/a.out.h
index 6a1b5d4..ab150f5 100644
--- a/include/asm-m32r/a.out.h
+++ b/include/asm-m32r/a.out.h
@@ -17,11 +17,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-
-#define STACK_TOP	TASK_SIZE
-#define STACK_TOP_MAX	STACK_TOP
-
-#endif
-
 #endif /* _ASM_M32R_A_OUT_H */
diff --git a/include/asm-m32r/processor.h b/include/asm-m32r/processor.h
index 32755bf..1a997fc 100644
--- a/include/asm-m32r/processor.h
+++ b/include/asm-m32r/processor.h
@@ -60,6 +60,11 @@ extern struct cpuinfo_m32r cpu_data[];
 #define TASK_SIZE  (0x00400000UL)
 #endif
 
+#ifdef __KERNEL__
+#define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
+#endif
+
 /* This decides where the kernel will search for a free chunk of vm
  * space during mmap's.
  */
diff --git a/include/asm-m68k/a.out.h b/include/asm-m68k/a.out.h
index 6fc86a2..3885fe4 100644
--- a/include/asm-m68k/a.out.h
+++ b/include/asm-m68k/a.out.h
@@ -17,11 +17,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-
-#define STACK_TOP	TASK_SIZE
-#define STACK_TOP_MAX	STACK_TOP
-
-#endif
-
 #endif /* __M68K_A_OUT_H__ */
diff --git a/include/asm-m68k/processor.h b/include/asm-m68k/processor.h
index 4453ec3..1f61ef5 100644
--- a/include/asm-m68k/processor.h
+++ b/include/asm-m68k/processor.h
@@ -41,6 +41,11 @@ static inline void wrusp(unsigned long usp)
 #define TASK_SIZE	(0x0E000000UL)
 #endif
 
+#ifdef __KERNEL__
+#define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
+#endif
+
 /* This decides where the kernel will search for a free chunk of vm
  * space during mmap's.
  */
diff --git a/include/asm-mips/a.out.h b/include/asm-mips/a.out.h
index bf55a5b..cad8371 100644
--- a/include/asm-mips/a.out.h
+++ b/include/asm-mips/a.out.h
@@ -32,17 +32,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-
-#ifdef CONFIG_32BIT
-#define STACK_TOP	TASK_SIZE
-#endif
-#ifdef CONFIG_64BIT
-#define STACK_TOP	\
-      (test_thread_flag(TIF_32BIT_ADDR) ? TASK_SIZE32 : TASK_SIZE)
-#endif
-#define STACK_TOP_MAX	TASK_SIZE
-
-#endif
-
 #endif /* _ASM_A_OUT_H */
diff --git a/include/asm-mips/processor.h b/include/asm-mips/processor.h
index 36f42de..58cbac5 100644
--- a/include/asm-mips/processor.h
+++ b/include/asm-mips/processor.h
@@ -39,6 +39,7 @@ extern unsigned int vced_count, vcei_count;
  * so don't change it unless you know what you are doing.
  */
 #define TASK_SIZE	0x7fff8000UL
+#define STACK_TOP	TASK_SIZE
 
 /*
  * This decides where the kernel will search for a free chunk of vm
@@ -57,6 +58,8 @@ extern unsigned int vced_count, vcei_count;
  */
 #define TASK_SIZE32	0x7fff8000UL
 #define TASK_SIZE	0x10000000000UL
+#define STACK_TOP	\
+      (test_thread_flag(TIF_32BIT_ADDR) ? TASK_SIZE32 : TASK_SIZE)
 
 /*
  * This decides where the kernel will search for a free chunk of vm
@@ -69,6 +72,10 @@ extern unsigned int vced_count, vcei_count;
 	(test_tsk_thread_flag(tsk, TIF_32BIT_ADDR) ? TASK_SIZE32 : TASK_SIZE)
 #endif
 
+#ifdef __KERNEL__
+#define STACK_TOP_MAX	TASK_SIZE
+#endif
+
 #define NUM_FPU_REGS	32
 
 typedef __u64 fpureg_t;
diff --git a/include/asm-parisc/a.out.h b/include/asm-parisc/a.out.h
index 23e2c90..eb04e34 100644
--- a/include/asm-parisc/a.out.h
+++ b/include/asm-parisc/a.out.h
@@ -17,14 +17,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-
-/* XXX: STACK_TOP actually should be STACK_BOTTOM for parisc.
- * prumpf */
-
-#define STACK_TOP	TASK_SIZE
-#define STACK_TOP_MAX	DEFAULT_TASK_SIZE
-
-#endif
-
 #endif /* __A_OUT_GNU_H__ */
diff --git a/include/asm-parisc/processor.h b/include/asm-parisc/processor.h
index 3bb06e8..3c9d348 100644
--- a/include/asm-parisc/processor.h
+++ b/include/asm-parisc/processor.h
@@ -47,6 +47,16 @@
 #define DEFAULT_MAP_BASE	DEFAULT_MAP_BASE32
 #endif
 
+#ifdef __KERNEL__
+
+/* XXX: STACK_TOP actually should be STACK_BOTTOM for parisc.
+ * prumpf */
+
+#define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	DEFAULT_TASK_SIZE
+
+#endif
+
 #ifndef __ASSEMBLY__
 
 /*
diff --git a/include/asm-powerpc/a.out.h b/include/asm-powerpc/a.out.h
index 5c5ea83..89cead6 100644
--- a/include/asm-powerpc/a.out.h
+++ b/include/asm-powerpc/a.out.h
@@ -17,23 +17,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-#ifdef __powerpc64__
-
-#define STACK_TOP_USER64 TASK_SIZE_USER64
-#define STACK_TOP_USER32 TASK_SIZE_USER32
-
-#define STACK_TOP (test_thread_flag(TIF_32BIT) ? \
-		   STACK_TOP_USER32 : STACK_TOP_USER64)
-
-#define STACK_TOP_MAX STACK_TOP_USER64
-
-#else /* __powerpc64__ */
-
-#define STACK_TOP TASK_SIZE
-#define STACK_TOP_MAX	STACK_TOP
-
-#endif /* __powerpc64__ */
-#endif /* __KERNEL__ */
-
 #endif /* _ASM_POWERPC_A_OUT_H */
diff --git a/include/asm-powerpc/processor.h b/include/asm-powerpc/processor.h
index 1f4765d..fd98ca9 100644
--- a/include/asm-powerpc/processor.h
+++ b/include/asm-powerpc/processor.h
@@ -113,6 +113,25 @@ extern struct task_struct *last_task_used_spe;
 		TASK_UNMAPPED_BASE_USER32 : TASK_UNMAPPED_BASE_USER64 )
 #endif
 
+#ifdef __KERNEL__
+#ifdef __powerpc64__
+
+#define STACK_TOP_USER64 TASK_SIZE_USER64
+#define STACK_TOP_USER32 TASK_SIZE_USER32
+
+#define STACK_TOP (test_thread_flag(TIF_32BIT) ? \
+		   STACK_TOP_USER32 : STACK_TOP_USER64)
+
+#define STACK_TOP_MAX STACK_TOP_USER64
+
+#else /* __powerpc64__ */
+
+#define STACK_TOP TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
+
+#endif /* __powerpc64__ */
+#endif /* __KERNEL__ */
+
 typedef struct {
 	unsigned long seg;
 } mm_segment_t;
diff --git a/include/asm-s390/a.out.h b/include/asm-s390/a.out.h
index 46158dc..8d6bd9c 100644
--- a/include/asm-s390/a.out.h
+++ b/include/asm-s390/a.out.h
@@ -29,11 +29,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-
-#define STACK_TOP	TASK_SIZE
-#define STACK_TOP_MAX	DEFAULT_TASK_SIZE
-
-#endif
-
 #endif /* __A_OUT_GNU_H__ */
diff --git a/include/asm-s390/processor.h b/include/asm-s390/processor.h
index eaa2de1..8f8545a 100644
--- a/include/asm-s390/processor.h
+++ b/include/asm-s390/processor.h
@@ -81,6 +81,13 @@ extern struct task_struct *last_task_used_math;
 
 #endif /* __s390x__ */
 
+#ifdef __KERNEL__
+
+#define STACK_TOP		TASK_SIZE
+#define STACK_TOP_MAX		DEFAULT_TASK_SIZE
+
+#endif
+
 #define HAVE_ARCH_PICK_MMAP_LAYOUT
 
 typedef struct {
diff --git a/include/asm-sh/a.out.h b/include/asm-sh/a.out.h
index 685d0f6..1f93130 100644
--- a/include/asm-sh/a.out.h
+++ b/include/asm-sh/a.out.h
@@ -17,11 +17,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-
-#define STACK_TOP	TASK_SIZE
-#define STACK_TOP_MAX	STACK_TOP
-
-#endif
-
 #endif /* __ASM_SH_A_OUT_H */
diff --git a/include/asm-sh/processor.h b/include/asm-sh/processor.h
index fda6848..a6e197e 100644
--- a/include/asm-sh/processor.h
+++ b/include/asm-sh/processor.h
@@ -85,6 +85,13 @@ extern struct sh_cpuinfo cpu_data[];
  */
 #define TASK_SIZE	0x7c000000UL
 
+#ifdef __KERNEL__
+
+#define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
+
+#endif
+
 /* This decides where the kernel will search for a free chunk of vm
  * space during mmap's.
  */
diff --git a/include/asm-sh64/a.out.h b/include/asm-sh64/a.out.h
index 237ee4e..c55b85b 100644
--- a/include/asm-sh64/a.out.h
+++ b/include/asm-sh64/a.out.h
@@ -28,11 +28,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-
-#define STACK_TOP	TASK_SIZE
-#define STACK_TOP_MAX	STACK_TOP
-
-#endif
-
 #endif /* __ASM_SH64_A_OUT_H */
diff --git a/include/asm-sparc/a.out.h b/include/asm-sparc/a.out.h
index 917e042..744cfe6 100644
--- a/include/asm-sparc/a.out.h
+++ b/include/asm-sparc/a.out.h
@@ -87,13 +87,4 @@ struct relocation_info /* used when header.a_machtype == M_SPARC */
 
 #define N_RELOCATION_INFO_DECLARED 1
 
-#ifdef __KERNEL__
-
-#include <asm/page.h>
-
-#define STACK_TOP	(PAGE_OFFSET - PAGE_SIZE)
-#define STACK_TOP_MAX	STACK_TOP
-
-#endif /* __KERNEL__ */
-
 #endif /* __SPARC_A_OUT_H__ */
diff --git a/include/asm-sparc/processor.h b/include/asm-sparc/processor.h
index 6fbb3f0..40b1e41 100644
--- a/include/asm-sparc/processor.h
+++ b/include/asm-sparc/processor.h
@@ -33,6 +33,10 @@
  * we can make our access_ok test faster
  */
 #define TASK_SIZE	PAGE_OFFSET
+#ifdef __KERNEL__
+#define STACK_TOP	(PAGE_OFFSET - PAGE_SIZE)
+#define STACK_TOP_MAX	STACK_TOP
+#endif /* __KERNEL__ */
 
 struct task_struct;
 
diff --git a/include/asm-sparc64/a.out.h b/include/asm-sparc64/a.out.h
index 902e07f..53c95bd 100644
--- a/include/asm-sparc64/a.out.h
+++ b/include/asm-sparc64/a.out.h
@@ -93,18 +93,6 @@ struct relocation_info /* used when header.a_machtype == M_SPARC */
 
 #define N_RELOCATION_INFO_DECLARED 1
 
-#ifdef __KERNEL__
-
-#define STACK_TOP32	((1UL << 32UL) - PAGE_SIZE)
-#define STACK_TOP64	(0x0000080000000000UL - (1UL << 32UL))
-
-#define STACK_TOP (test_thread_flag(TIF_32BIT) ? \
-		   STACK_TOP32 : STACK_TOP64)
-
-#define STACK_TOP_MAX STACK_TOP64
-
-#endif
-
 #endif /* !(__ASSEMBLY__) */
 
 #endif /* !(__SPARC64_A_OUT_H__) */
diff --git a/include/asm-sparc64/processor.h b/include/asm-sparc64/processor.h
index 66dd2fa..48e7496 100644
--- a/include/asm-sparc64/processor.h
+++ b/include/asm-sparc64/processor.h
@@ -36,7 +36,19 @@
 #else
 #define VPTE_SIZE	(1 << (VA_BITS - PAGE_SHIFT + 3))
 #endif
+
 #define TASK_SIZE	((unsigned long)-VPTE_SIZE)
+#ifdef __KERNEL__
+
+#define STACK_TOP32	((1UL << 32UL) - PAGE_SIZE)
+#define STACK_TOP64	(0x0000080000000000UL - (1UL << 32UL))
+
+#define STACK_TOP	(test_thread_flag(TIF_32BIT) ? \
+			 STACK_TOP32 : STACK_TOP64)
+
+#define STACK_TOP_MAX	STACK_TOP64
+
+#endif
 
 #ifndef __ASSEMBLY__
 
diff --git a/include/asm-sparc64/user.h b/include/asm-sparc64/user.h
index fce4e85..02b1389 100644
--- a/include/asm-sparc64/user.h
+++ b/include/asm-sparc64/user.h
@@ -8,7 +8,7 @@
 #ifndef _SPARC64_USER_H
 #define _SPARC64_USER_H
 
-#include <asm/a.out.h>
+#include <linux/a.out.h>
 struct sunos_regs {
 	unsigned int psr, pc, npc, y;
 	unsigned int regs[15];
diff --git a/include/asm-um/a.out.h b/include/asm-um/a.out.h
index 9281dd8..754181e 100644
--- a/include/asm-um/a.out.h
+++ b/include/asm-um/a.out.h
@@ -8,17 +8,4 @@
 
 #include "asm/arch/a.out.h"
 
-#undef STACK_TOP
-#undef STACK_TOP_MAX
-
-extern unsigned long stacksizelim;
-
-extern unsigned long host_task_size;
-
-#define STACK_ROOM (stacksizelim)
-
-#define STACK_TOP task_size
-
-#define STACK_TOP_MAX STACK_TOP
-
 #endif
diff --git a/include/asm-um/processor-generic.h b/include/asm-um/processor-generic.h
index 35ab6a2..7b0994b 100644
--- a/include/asm-um/processor-generic.h
+++ b/include/asm-um/processor-generic.h
@@ -95,9 +95,17 @@ static inline void mm_copy_segments(struct mm_struct *from_mm,
  * User space process size: 3GB (default).
  */
 extern unsigned long task_size;
+extern unsigned long stacksizelim;
+extern unsigned long host_task_size;
 
 #define TASK_SIZE	(task_size)
 
+#undef STACK_TOP
+#undef STACK_TOP_MAX
+#define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
+#define STACK_ROOM	(stacksizelim)
+
 /* This decides where the kernel will search for a free chunk of vm
  * space during mmap's.
  */
diff --git a/include/asm-x86/a.out.h b/include/asm-x86/a.out.h
index a62443e..4684f97 100644
--- a/include/asm-x86/a.out.h
+++ b/include/asm-x86/a.out.h
@@ -17,14 +17,4 @@ struct exec
 #define N_DRSIZE(a)	((a).a_drsize)
 #define N_SYMSIZE(a)	((a).a_syms)
 
-#ifdef __KERNEL__
-# include <linux/thread_info.h>
-# define STACK_TOP	TASK_SIZE
-# ifdef CONFIG_X86_32
-#  define STACK_TOP_MAX	STACK_TOP
-# else
-#  define STACK_TOP_MAX	TASK_SIZE64
-# endif
-#endif
-
 #endif /* _ASM_X86_A_OUT_H */
diff --git a/include/asm-x86/processor_32.h b/include/asm-x86/processor_32.h
index 3b51a18..a24b4bd 100644
--- a/include/asm-x86/processor_32.h
+++ b/include/asm-x86/processor_32.h
@@ -212,6 +212,8 @@ extern int bootloader_type;
  * User space process size: 3GB (default).
  */
 #define TASK_SIZE	(PAGE_OFFSET)
+#define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
 
 /* This decides where the kernel will search for a free chunk of vm
  * space during mmap's.
diff --git a/include/asm-x86/processor_64.h b/include/asm-x86/processor_64.h
index 2ae8ceb..bf8695d 100644
--- a/include/asm-x86/processor_64.h
+++ b/include/asm-x86/processor_64.h
@@ -147,6 +147,8 @@ static inline void clear_in_cr4 (unsigned long mask)
 #define TASK_SIZE_OF(child) 	((test_tsk_thread_flag(child, TIF_IA32)) ? IA32_PAGE_OFFSET : TASK_SIZE64)
 
 #define TASK_UNMAPPED_BASE	PAGE_ALIGN(TASK_SIZE/3)
+#define STACK_TOP		TASK_SIZE
+#define STACK_TOP_MAX		TASK_SIZE64
 
 /*
  * Size of io_bitmap.
diff --git a/include/asm-xtensa/a.out.h b/include/asm-xtensa/a.out.h
index 05a2f67..fdf1370 100644
--- a/include/asm-xtensa/a.out.h
+++ b/include/asm-xtensa/a.out.h
@@ -14,11 +14,6 @@
 #ifndef _XTENSA_A_OUT_H
 #define _XTENSA_A_OUT_H
 
-/* Note: the kernel needs the a.out definitions, even if only ELF is used. */
-
-#define STACK_TOP	TASK_SIZE
-#define STACK_TOP_MAX	STACK_TOP
-
 struct exec
 {
   unsigned long a_info;
diff --git a/include/asm-xtensa/processor.h b/include/asm-xtensa/processor.h
index 35145bc..96408f4 100644
--- a/include/asm-xtensa/processor.h
+++ b/include/asm-xtensa/processor.h
@@ -34,6 +34,8 @@
  */
 
 #define TASK_SIZE	__XTENSA_UL_CONST(0x40000000)
+#define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
 
 /*
  * General exception cause assigned to debug exceptions. Debug exceptions go

