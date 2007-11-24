Return-Path: <linux-kernel-owner+w=401wt.eu-S1756533AbXKXXRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533AbXKXXRW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 18:17:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752938AbXKXXRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 18:17:14 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:60035 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741AbXKXXRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 18:17:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:message-id;
        b=CCrWe+GiwLK9aKVFGVw83G4t7tAkI3gxQ/zyLVQMVCiZVG7OsrdUwG4y37QSMZZR+qIDJNba1tWXebsCGl6xaS7JaM0mvofi1Ke3QFpR8VtvRfpZYoi7qFp1HofCo4T8XL3ZgFZC+q/5vQutMwsL3GCUFq+d/kB57xP3f+a3ViY=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 1/3] build system: section garbage collection - rename sections
Date: Sat, 24 Nov 2007 15:17:00 -0800
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org
References: <200709112105.34301.vda.linux@googlemail.com> <20071118230057.GA6303@uranus.ravnborg.org> <200711241514.26451.vda.linux@googlemail.com>
In-Reply-To: <200711241514.26451.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_sDLSHEtlOZs+H7n"
Message-Id: <200711241517.00164.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_sDLSHEtlOZs+H7n
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Saturday 24 November 2007 15:14, Denys Vlasenko wrote:
> 1.fixname:
>     Rename all special sections with names like .text.xxxx, .data.xxxx and
>     .rodata.xxxx to .xxxx.text/data/rodata. This makes it possible to
>     not mix up these sections with gcc-generated ones
>     when gcc -ffunction-sections -fdata-sections is used.
>     .bss.xxxx cannot be treated this way, because for section names
>     linke .xxxx.bss gcc won't create section with correct attribute.
>     Thus .bss.xxxxx sections are renamed .bss.k.xxxxx.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
-- 
vda

--Boundary-00=_sDLSHEtlOZs+H7n
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="linux-2.6-linus_git.1.fixname.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="linux-2.6-linus_git.1.fixname.patch"

diff -urpN linux-2.6.org/Documentation/mutex-design.txt linux-2.6.gc1/Documentation/mutex-design.txt
--- linux-2.6.org/Documentation/mutex-design.txt	2007-11-23 18:55:08.000000000 -0800
+++ linux-2.6.gc1/Documentation/mutex-design.txt	2007-11-23 20:55:46.000000000 -0800
@@ -66,14 +66,14 @@ of advantages of mutexes:
 
     c0377ccb <mutex_lock>:
     c0377ccb:       f0 ff 08                lock decl (%eax)
-    c0377cce:       78 0e                   js     c0377cde <.text.lock.mutex>
+    c0377cce:       78 0e                   js     c0377cde <.lock.mutex.text>
     c0377cd0:       c3                      ret
 
    the unlocking fastpath is equally tight:
 
     c0377cd1 <mutex_unlock>:
     c0377cd1:       f0 ff 00                lock incl (%eax)
-    c0377cd4:       7e 0f                   jle    c0377ce5 <.text.lock.mutex+0x7>
+    c0377cd4:       7e 0f                   jle    c0377ce5 <.lock.mutex.text+0x7>
     c0377cd6:       c3                      ret
 
  - 'struct mutex' semantics are well-defined and are enforced if
diff -urpN linux-2.6.org/arch/alpha/kernel/head.S linux-2.6.gc1/arch/alpha/kernel/head.S
--- linux-2.6.org/arch/alpha/kernel/head.S	2007-11-23 18:55:08.000000000 -0800
+++ linux-2.6.gc1/arch/alpha/kernel/head.S	2007-11-23 20:55:40.000000000 -0800
@@ -10,7 +10,7 @@
 #include <asm/system.h>
 #include <asm/asm-offsets.h>
 
-.section .text.head, "ax"
+.section .head.text, "ax"
 .globl swapper_pg_dir
 .globl _stext
 swapper_pg_dir=SWAPPER_PGD
diff -urpN linux-2.6.org/arch/alpha/kernel/init_task.c linux-2.6.gc1/arch/alpha/kernel/init_task.c
--- linux-2.6.org/arch/alpha/kernel/init_task.c	2007-11-23 18:55:08.000000000 -0800
+++ linux-2.6.gc1/arch/alpha/kernel/init_task.c	2007-11-23 20:55:53.000000000 -0800
@@ -19,5 +19,5 @@ EXPORT_SYMBOL(init_mm);
 EXPORT_SYMBOL(init_task);
 
 union thread_union init_thread_union
-	__attribute__((section(".data.init_thread")))
+	__attribute__((section(".init_thread.data")))
 	= { INIT_THREAD_INFO(init_task) };
diff -urpN linux-2.6.org/arch/alpha/kernel/vmlinux.lds.S linux-2.6.gc1/arch/alpha/kernel/vmlinux.lds.S
--- linux-2.6.org/arch/alpha/kernel/vmlinux.lds.S	2007-11-23 18:55:08.000000000 -0800
+++ linux-2.6.gc1/arch/alpha/kernel/vmlinux.lds.S	2007-11-23 20:55:55.000000000 -0800
@@ -16,7 +16,7 @@ SECTIONS
 
 	_text = .;	/* Text and read-only data */
 	.text : {
-	*(.text.head)
+	*(.head.text)
 		TEXT_TEXT
 		SCHED_TEXT
 		LOCK_TEXT
@@ -93,18 +93,18 @@ SECTIONS
 	/* Freed after init ends here */
 
 	/* Note 2 page alignment above.  */
-	.data.init_thread : {
-		*(.data.init_thread)
+	.init_thread.data : {
+		*(.init_thread.data)
 	}
 
 	. = ALIGN(PAGE_SIZE);
-	.data.page_aligned : {
-		*(.data.page_aligned)
+	.page_aligned.data : {
+		*(.page_aligned.data)
 	}
 
 	. = ALIGN(64);
-	.data.cacheline_aligned : {
-		*(.data.cacheline_aligned)
+	.cacheline_aligned.data : {
+		*(.cacheline_aligned.data)
 	}
 
 	_data = .;
diff -urpN linux-2.6.org/arch/arm/kernel/head-nommu.S linux-2.6.gc1/arch/arm/kernel/head-nommu.S
--- linux-2.6.org/arch/arm/kernel/head-nommu.S	2007-11-23 18:55:08.000000000 -0800
+++ linux-2.6.gc1/arch/arm/kernel/head-nommu.S	2007-11-23 20:55:40.000000000 -0800
@@ -33,7 +33,7 @@
  * numbers for r1.
  *
  */
-	.section ".text.head", "ax"
+	.section ".head.text", "ax"
 	.type	stext, %function
 ENTRY(stext)
 	msr	cpsr_c, #PSR_F_BIT | PSR_I_BIT | SVC_MODE @ ensure svc mode
diff -urpN linux-2.6.org/arch/arm/kernel/head.S linux-2.6.gc1/arch/arm/kernel/head.S
--- linux-2.6.org/arch/arm/kernel/head.S	2007-11-23 18:55:08.000000000 -0800
+++ linux-2.6.gc1/arch/arm/kernel/head.S	2007-11-23 20:55:40.000000000 -0800
@@ -77,7 +77,7 @@
  * crap here - that's what the boot loader (or in extreme, well justified
  * circumstances, zImage) is for.
  */
-	.section ".text.head", "ax"
+	.section ".head.text", "ax"
 	.type	stext, %function
 ENTRY(stext)
 	msr	cpsr_c, #PSR_F_BIT | PSR_I_BIT | SVC_MODE @ ensure svc mode
diff -urpN linux-2.6.org/arch/arm/kernel/init_task.c linux-2.6.gc1/arch/arm/kernel/init_task.c
--- linux-2.6.org/arch/arm/kernel/init_task.c	2007-11-23 18:55:08.000000000 -0800
+++ linux-2.6.gc1/arch/arm/kernel/init_task.c	2007-11-23 20:55:53.000000000 -0800
@@ -31,7 +31,7 @@ EXPORT_SYMBOL(init_mm);
  * The things we do for performance..
  */
 union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
+	__attribute__((__section__(".init_task.data"))) =
 		{ INIT_THREAD_INFO(init_task) };
 
 /*
diff -urpN linux-2.6.org/arch/arm/kernel/vmlinux.lds.S linux-2.6.gc1/arch/arm/kernel/vmlinux.lds.S
--- linux-2.6.org/arch/arm/kernel/vmlinux.lds.S	2007-11-23 18:55:08.000000000 -0800
+++ linux-2.6.gc1/arch/arm/kernel/vmlinux.lds.S	2007-11-23 20:55:54.000000000 -0800
@@ -23,10 +23,10 @@ SECTIONS
 #else
 	. = PAGE_OFFSET + TEXT_OFFSET;
 #endif
-	.text.head : {
+	.head.text : {
 		_stext = .;
 		_sinittext = .;
-		*(.text.head)
+		*(.head.text)
 	}
 
 	.init : {			/* Init code and data		*/
@@ -65,8 +65,8 @@ SECTIONS
 #endif
 		. = ALIGN(4096);
 		__per_cpu_start = .;
-			*(.data.percpu)
-			*(.data.percpu.shared_aligned)
+			*(.percpu.data)
+			*(.percpu.shared_aligned.data)
 		__per_cpu_end = .;
 #ifndef CONFIG_XIP_KERNEL
 		__init_begin = _stext;
@@ -124,7 +124,7 @@ SECTIONS
 		 * first, the init task union, aligned
 		 * to an 8192 byte boundary.
 		 */
-		*(.data.init_task)
+		*(.init_task.data)
 
 #ifdef CONFIG_XIP_KERNEL
 		. = ALIGN(4096);
@@ -136,7 +136,7 @@ SECTIONS
 
 		. = ALIGN(4096);
 		__nosave_begin = .;
-		*(.data.nosave)
+		*(.nosave.data)
 		. = ALIGN(4096);
 		__nosave_end = .;
 
@@ -144,7 +144,7 @@ SECTIONS
 		 * then the cacheline aligned data
 		 */
 		. = ALIGN(32);
-		*(.data.cacheline_aligned)
+		*(.cacheline_aligned.data)
 
 		/*
 		 * The exception fixup table (might need resorting at runtime)
diff -urpN linux-2.6.org/arch/arm/mm/proc-v6.S linux-2.6.gc1/arch/arm/mm/proc-v6.S
--- linux-2.6.org/arch/arm/mm/proc-v6.S	2007-11-23 18:55:08.000000000 -0800
+++ linux-2.6.gc1/arch/arm/mm/proc-v6.S	2007-11-23 20:55:45.000000000 -0800
@@ -168,7 +168,7 @@ cpu_v6_name:
 	.asciz	"ARMv6-compatible processor"
 	.align
 
-	.section ".text.init", #alloc, #execinstr
+	.section ".init.text", #alloc, #execinstr
 
 /*
  *	__v6_setup
diff -urpN linux-2.6.org/arch/arm/mm/proc-v7.S linux-2.6.gc1/arch/arm/mm/proc-v7.S
--- linux-2.6.org/arch/arm/mm/proc-v7.S	2007-11-23 18:55:08.000000000 -0800
+++ linux-2.6.gc1/arch/arm/mm/proc-v7.S	2007-11-23 20:55:45.000000000 -0800
@@ -146,7 +146,7 @@ cpu_v7_name:
 	.ascii	"ARMv7 Processor"
 	.align
 
-	.section ".text.init", #alloc, #execinstr
+	.section ".init.text", #alloc, #execinstr
 
 /*
  *	__v7_setup
diff -urpN linux-2.6.org/arch/arm/mm/tlb-v6.S linux-2.6.gc1/arch/arm/mm/tlb-v6.S
--- linux-2.6.org/arch/arm/mm/tlb-v6.S	2007-11-23 18:55:08.000000000 -0800
+++ linux-2.6.gc1/arch/arm/mm/tlb-v6.S	2007-11-23 20:55:45.000000000 -0800
@@ -87,7 +87,7 @@ ENTRY(v6wbi_flush_kern_tlb_range)
 	mcr	p15, 0, r2, c7, c5, 4		@ prefetch flush
 	mov	pc, lr
 
-	.section ".text.init", #alloc, #execinstr
+	.section ".init.text", #alloc, #execinstr
 
 	.type	v6wbi_tlb_fns, #object
 ENTRY(v6wbi_tlb_fns)
diff -urpN linux-2.6.org/arch/arm/mm/tlb-v7.S linux-2.6.gc1/arch/arm/mm/tlb-v7.S
--- linux-2.6.org/arch/arm/mm/tlb-v7.S	2007-11-23 18:55:08.000000000 -0800
+++ linux-2.6.gc1/arch/arm/mm/tlb-v7.S	2007-11-23 20:55:45.000000000 -0800
@@ -78,7 +78,7 @@ ENTRY(v7wbi_flush_kern_tlb_range)
 	isb
 	mov	pc, lr
 
-	.section ".text.init", #alloc, #execinstr
+	.section ".init.text", #alloc, #execinstr
 
 	.type	v7wbi_tlb_fns, #object
 ENTRY(v7wbi_tlb_fns)
diff -urpN linux-2.6.org/arch/avr32/kernel/init_task.c linux-2.6.gc1/arch/avr32/kernel/init_task.c
--- linux-2.6.org/arch/avr32/kernel/init_task.c	2007-11-23 18:55:08.000000000 -0800
+++ linux-2.6.gc1/arch/avr32/kernel/init_task.c	2007-11-23 20:55:53.000000000 -0800
@@ -25,7 +25,7 @@ EXPORT_SYMBOL(init_mm);
  * Initial thread structure. Must be aligned on an 8192-byte boundary.
  */
 union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
+	__attribute__((__section__(".init_task.data"))) =
 		{ INIT_THREAD_INFO(init_task) };
 
 /*
diff -urpN linux-2.6.org/arch/avr32/kernel/vmlinux.lds.S linux-2.6.gc1/arch/avr32/kernel/vmlinux.lds.S
--- linux-2.6.org/arch/avr32/kernel/vmlinux.lds.S	2007-11-23 18:55:08.000000000 -0800
+++ linux-2.6.gc1/arch/avr32/kernel/vmlinux.lds.S	2007-11-23 20:55:53.000000000 -0800
@@ -105,11 +105,11 @@ SECTIONS
 		/*
 		 * First, the init task union, aligned to an 8K boundary.
 		 */
-		*(.data.init_task)
+		*(.init_task.data)
 
 		/* Then, the cacheline aligned data */
 		. = ALIGN(L1_CACHE_BYTES);
-		*(.data.cacheline_aligned)
+		*(.cacheline_aligned.data)
 
 		/* And the rest... */
 		*(.data.rel*)
diff -urpN linux-2.6.org/arch/blackfin/kernel/init_task.c linux-2.6.gc1/arch/blackfin/kernel/init_task.c
--- linux-2.6.org/arch/blackfin/kernel/init_task.c	2007-11-23 18:55:08.000000000 -0800
+++ linux-2.6.gc1/arch/blackfin/kernel/init_task.c	2007-11-23 20:55:53.000000000 -0800
@@ -57,5 +57,5 @@ EXPORT_SYMBOL(init_task);
  * "init_task" linker map entry.
  */
 union thread_union init_thread_union
-    __attribute__ ((__section__(".data.init_task"))) = {
+    __attribute__ ((__section__(".init_task.data"))) = {
 INIT_THREAD_INFO(init_task)};
diff -urpN linux-2.6.org/arch/blackfin/kernel/vmlinux.lds.S linux-2.6.gc1/arch/blackfin/kernel/vmlinux.lds.S
--- linux-2.6.org/arch/blackfin/kernel/vmlinux.lds.S	2007-11-23 18:55:08.000000000 -0800
+++ linux-2.6.gc1/arch/blackfin/kernel/vmlinux.lds.S	2007-11-23 20:55:53.000000000 -0800
@@ -72,10 +72,10 @@ SECTIONS
 		 */
 		__sdata = .;
 		. = ALIGN(THREAD_SIZE);
-		*(.data.init_task)
+		*(.init_task.data)
 
 		. = ALIGN(32);
-		*(.data.cacheline_aligned)
+		*(.cacheline_aligned.data)
 
 		DATA_DATA
 		*(.data.*)
diff -urpN linux-2.6.org/arch/cris/arch-v10/kernel/head.S linux-2.6.gc1/arch/cris/arch-v10/kernel/head.S
--- linux-2.6.org/arch/cris/arch-v10/kernel/head.S	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/cris/arch-v10/kernel/head.S	2007-11-23 20:55:53.000000000 -0800
@@ -74,7 +74,7 @@
  * Tweak "notice" to reflect that both r8 r9 are used
  *
  * Revision 1.33  2001/05/15 06:40:05  hp
- * Put bulk of code in .text.init, data in .data.init
+ * Put bulk of code in .init.text, data in .init.data
  *
  * Revision 1.32  2001/05/15 06:18:56  hp
  * Execute review comment: s/bcc/bhs/g; s/bcs/blo/g
diff -urpN linux-2.6.org/arch/cris/arch-v10/vmlinux.lds.S linux-2.6.gc1/arch/cris/arch-v10/vmlinux.lds.S
--- linux-2.6.org/arch/cris/arch-v10/vmlinux.lds.S	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/cris/arch-v10/vmlinux.lds.S	2007-11-23 20:55:56.000000000 -0800
@@ -50,7 +50,7 @@ SECTIONS
 	_edata = . ;
 
 	. = ALIGN(8192);              /* init_task and stack, must be aligned */
-  	.data.init_task : { *(.data.init_task) }
+  	.init_task.data : { *(.init_task.data) }
 
   	. = ALIGN(8192);              /* Init code and data */
   	__init_begin = .;
@@ -112,8 +112,8 @@ SECTIONS
 
 	/* Sections to be discarded */
   	/DISCARD/ : {
-        	*(.text.exit)
-        	*(.data.exit)
+        	*(.exit.text)
+        	*(.exit.data)
 		*(.exitcall.exit)
         }
 
diff -urpN linux-2.6.org/arch/cris/arch-v32/vmlinux.lds.S linux-2.6.gc1/arch/cris/arch-v32/vmlinux.lds.S
--- linux-2.6.org/arch/cris/arch-v32/vmlinux.lds.S	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/cris/arch-v32/vmlinux.lds.S	2007-11-23 20:55:56.000000000 -0800
@@ -55,7 +55,7 @@ SECTIONS
 	_edata = . ;
 
 	. = ALIGN(8192);	/* init_task and stack, must be aligned. */
-  	.data.init_task : { *(.data.init_task) }
+  	.init_task.data : { *(.init_task.data) }
 
   	. = ALIGN(8192);	/* Init code and data. */
   	__init_begin = .;
@@ -124,8 +124,8 @@ SECTIONS
 
 	/* Sections to be discarded */
   	/DISCARD/ : {
-        	*(.text.exit)
-        	*(.data.exit)
+        	*(.exit.text)
+        	*(.exit.data)
 		*(.exitcall.exit)
         }
 
diff -urpN linux-2.6.org/arch/cris/kernel/process.c linux-2.6.gc1/arch/cris/kernel/process.c
--- linux-2.6.org/arch/cris/kernel/process.c	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/cris/kernel/process.c	2007-11-23 20:55:53.000000000 -0800
@@ -153,7 +153,7 @@ EXPORT_SYMBOL(init_mm);
  * "init_task" linker map entry..
  */
 union thread_union init_thread_union 
-	__attribute__((__section__(".data.init_task"))) =
+	__attribute__((__section__(".init_task.data"))) =
 		{ INIT_THREAD_INFO(init_task) };
 
 /*
diff -urpN linux-2.6.org/arch/frv/kernel/head-mmu-fr451.S linux-2.6.gc1/arch/frv/kernel/head-mmu-fr451.S
--- linux-2.6.org/arch/frv/kernel/head-mmu-fr451.S	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/frv/kernel/head-mmu-fr451.S	2007-11-23 20:55:45.000000000 -0800
@@ -31,7 +31,7 @@
 #define __400_LCR	0xfe000100
 #define __400_LSBR	0xfe000c00
 
-	.section	.text.init,"ax"
+	.section	.init.text,"ax"
 	.balign		4
 
 ###############################################################################
diff -urpN linux-2.6.org/arch/frv/kernel/head-uc-fr401.S linux-2.6.gc1/arch/frv/kernel/head-uc-fr401.S
--- linux-2.6.org/arch/frv/kernel/head-uc-fr401.S	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/frv/kernel/head-uc-fr401.S	2007-11-23 20:55:45.000000000 -0800
@@ -30,7 +30,7 @@
 #define __400_LCR	0xfe000100
 #define __400_LSBR	0xfe000c00
 
-	.section	.text.init,"ax"
+	.section	.init.text,"ax"
 	.balign		4
 
 ###############################################################################
diff -urpN linux-2.6.org/arch/frv/kernel/head-uc-fr451.S linux-2.6.gc1/arch/frv/kernel/head-uc-fr451.S
--- linux-2.6.org/arch/frv/kernel/head-uc-fr451.S	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/frv/kernel/head-uc-fr451.S	2007-11-23 20:55:45.000000000 -0800
@@ -30,7 +30,7 @@
 #define __400_LCR	0xfe000100
 #define __400_LSBR	0xfe000c00
 
-	.section	.text.init,"ax"
+	.section	.init.text,"ax"
 	.balign		4
 
 ###############################################################################
diff -urpN linux-2.6.org/arch/frv/kernel/head-uc-fr555.S linux-2.6.gc1/arch/frv/kernel/head-uc-fr555.S
--- linux-2.6.org/arch/frv/kernel/head-uc-fr555.S	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/frv/kernel/head-uc-fr555.S	2007-11-23 20:55:45.000000000 -0800
@@ -29,7 +29,7 @@
 #define __551_LCR	0xfeff1100
 #define __551_LSBR	0xfeff1c00
 
-	.section	.text.init,"ax"
+	.section	.init.text,"ax"
 	.balign		4
 
 ###############################################################################
diff -urpN linux-2.6.org/arch/frv/kernel/head.S linux-2.6.gc1/arch/frv/kernel/head.S
--- linux-2.6.org/arch/frv/kernel/head.S	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/frv/kernel/head.S	2007-11-23 20:55:45.000000000 -0800
@@ -27,7 +27,7 @@
 #   command line string
 #
 ###############################################################################
-	.section	.text.head,"ax"
+	.section	.head.text,"ax"
 	.balign		4
 
 	.globl		_boot, __head_reference
@@ -541,7 +541,7 @@ __head_end:
 	.size		_boot, .-_boot
 
 	# provide a point for GDB to place a break
-	.section	.text.start,"ax"
+	.section	.start.text,"ax"
 	.globl		_start
 	.balign		4
 _start:
diff -urpN linux-2.6.org/arch/frv/kernel/init_task.c linux-2.6.gc1/arch/frv/kernel/init_task.c
--- linux-2.6.org/arch/frv/kernel/init_task.c	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/frv/kernel/init_task.c	2007-11-23 20:55:53.000000000 -0800
@@ -26,7 +26,7 @@ EXPORT_SYMBOL(init_mm);
  * "init_task" linker map entry..
  */
 union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
+	__attribute__((__section__(".init_task.data"))) =
 		{ INIT_THREAD_INFO(init_task) };
 
 /*
diff -urpN linux-2.6.org/arch/frv/kernel/vmlinux.lds.S linux-2.6.gc1/arch/frv/kernel/vmlinux.lds.S
--- linux-2.6.org/arch/frv/kernel/vmlinux.lds.S	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/frv/kernel/vmlinux.lds.S	2007-11-23 20:55:57.000000000 -0800
@@ -26,7 +26,7 @@ SECTIONS
 
   _sinittext = .;
   .init.text : {
-	*(.text.head)
+	*(.head.text)
 #ifndef CONFIG_DEBUG_INFO
 	*(.init.text)
 	*(.exit.text)
@@ -71,9 +71,9 @@ SECTIONS
 
   /* put sections together that have massive alignment issues */
   . = ALIGN(THREAD_SIZE);
-  .data.init_task : {
+  .init_task.data : {
 	  /* init task record & stack */
-	  *(.data.init_task)
+	  *(.init_task.data)
   }
 
   .trap : {
@@ -87,10 +87,10 @@ SECTIONS
   }
 
   . = ALIGN(4096);
-  .data.page_aligned : { *(.data.idt) }
+  .page_aligned.data : { *(.idt.data) }
 
   . = ALIGN(L1_CACHE_BYTES);
-  .data.cacheline_aligned : { *(.data.cacheline_aligned) }
+  .cacheline_aligned.data : { *(.cacheline_aligned.data) }
 
   /* Text and read-only data */
   . = ALIGN(4);
@@ -98,7 +98,7 @@ SECTIONS
   _stext = .;
   .text : {
 	*(
-		.text.start .text.*
+		.start.text .text.*
 #ifdef CONFIG_DEBUG_INFO
 	.init.text
 	.exit.text
diff -urpN linux-2.6.org/arch/h8300/boot/compressed/head.S linux-2.6.gc1/arch/h8300/boot/compressed/head.S
--- linux-2.6.org/arch/h8300/boot/compressed/head.S	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/h8300/boot/compressed/head.S	2007-11-23 20:55:45.000000000 -0800
@@ -9,7 +9,7 @@
 
 #define SRAM_START 0xff4000
 
-	.section	.text.startup
+	.section	.startup.text
 	.global	startup
 startup:
 	mov.l	#SRAM_START+0x8000, sp
diff -urpN linux-2.6.org/arch/h8300/boot/compressed/vmlinux.lds linux-2.6.gc1/arch/h8300/boot/compressed/vmlinux.lds
--- linux-2.6.org/arch/h8300/boot/compressed/vmlinux.lds	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/h8300/boot/compressed/vmlinux.lds	2007-11-23 20:55:45.000000000 -0800
@@ -4,7 +4,7 @@ SECTIONS
         {
         __stext = . ;
 	__text = .;
-	       *(.text.startup)
+	       *(.startup.text)
 	       *(.text)
         __etext = . ;
         }
diff -urpN linux-2.6.org/arch/h8300/kernel/init_task.c linux-2.6.gc1/arch/h8300/kernel/init_task.c
--- linux-2.6.org/arch/h8300/kernel/init_task.c	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/h8300/kernel/init_task.c	2007-11-23 20:55:53.000000000 -0800
@@ -38,6 +38,6 @@ EXPORT_SYMBOL(init_task);
  * "init_task" linker map entry..
  */
 union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
+	__attribute__((__section__(".init_task.data"))) =
 		{ INIT_THREAD_INFO(init_task) };
 
diff -urpN linux-2.6.org/arch/h8300/kernel/vmlinux.lds.S linux-2.6.gc1/arch/h8300/kernel/vmlinux.lds.S
--- linux-2.6.org/arch/h8300/kernel/vmlinux.lds.S	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/h8300/kernel/vmlinux.lds.S	2007-11-23 20:55:53.000000000 -0800
@@ -101,7 +101,7 @@ SECTIONS
 	___data_start = . ;
 
 	. = ALIGN(0x2000) ;
-		*(.data.init_task)
+		*(.init_task.data)
 	. = ALIGN(0x4) ;
 		DATA_DATA
 	. = ALIGN(0x4) ;
diff -urpN linux-2.6.org/arch/ia64/kernel/Makefile linux-2.6.gc1/arch/ia64/kernel/Makefile
--- linux-2.6.org/arch/ia64/kernel/Makefile	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/ia64/kernel/Makefile	2007-11-23 22:17:55.000000000 -0800
@@ -66,7 +66,7 @@ GATECFLAGS_gate-syms.o = -r
 $(obj)/gate-syms.o: $(obj)/gate.lds $(obj)/gate.o FORCE
 	$(call if_changed,gate)
 
-# gate-data.o contains the gate DSO image as data in section .data.gate.
+# gate-data.o contains the gate DSO image as data in section .gate.data
 # We must build gate.so before we can assemble it.
 # Note: kbuild does not track this dependency due to usage of .incbin
 $(obj)/gate-data.o: $(obj)/gate.so
diff -urpN linux-2.6.org/arch/ia64/kernel/gate-data.S linux-2.6.gc1/arch/ia64/kernel/gate-data.S
--- linux-2.6.org/arch/ia64/kernel/gate-data.S	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/ia64/kernel/gate-data.S	2007-11-23 20:55:59.000000000 -0800
@@ -1,3 +1,3 @@
-	.section .data.gate, "aw"
+	.section .gate.data, "aw"
 
 	.incbin "arch/ia64/kernel/gate.so"
diff -urpN linux-2.6.org/arch/ia64/kernel/gate.S linux-2.6.gc1/arch/ia64/kernel/gate.S
--- linux-2.6.org/arch/ia64/kernel/gate.S	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/ia64/kernel/gate.S	2007-11-23 20:55:56.000000000 -0800
@@ -20,18 +20,18 @@
  * to targets outside the shared object) and to avoid multi-phase kernel builds, we
  * simply create minimalistic "patch lists" in special ELF sections.
  */
-	.section ".data.patch.fsyscall_table", "a"
+	.section ".patch.fsyscall_table.data", "a"
 	.previous
 #define LOAD_FSYSCALL_TABLE(reg)			\
 [1:]	movl reg=0;					\
-	.xdata4 ".data.patch.fsyscall_table", 1b-.
+	.xdata4 ".patch.fsyscall_table.data", 1b-.
 
-	.section ".data.patch.brl_fsys_bubble_down", "a"
+	.section ".patch.brl_fsys_bubble_down.data", "a"
 	.previous
 #define BRL_COND_FSYS_BUBBLE_DOWN(pr)			\
 [1:](pr)brl.cond.sptk 0;				\
 	;;						\
-	.xdata4 ".data.patch.brl_fsys_bubble_down", 1b-.
+	.xdata4 ".patch.brl_fsys_bubble_down.data", 1b-.
 
 GLOBAL_ENTRY(__kernel_syscall_via_break)
 	.prologue
diff -urpN linux-2.6.org/arch/ia64/kernel/gate.lds.S linux-2.6.gc1/arch/ia64/kernel/gate.lds.S
--- linux-2.6.org/arch/ia64/kernel/gate.lds.S	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/ia64/kernel/gate.lds.S	2007-11-23 20:55:56.000000000 -0800
@@ -32,21 +32,21 @@ SECTIONS
 	 */
 	. = GATE_ADDR + 0x500;
 
-	.data.patch		: {
+	.patch.data		: {
 		__start_gate_mckinley_e9_patchlist = .;
-		*(.data.patch.mckinley_e9)
+		*(.patch.mckinley_e9.data)
 		__end_gate_mckinley_e9_patchlist = .;
 
 		__start_gate_vtop_patchlist = .;
-		*(.data.patch.vtop)
+		*(.patch.vtop.data)
 		__end_gate_vtop_patchlist = .;
 
 		__start_gate_fsyscall_patchlist = .;
-		*(.data.patch.fsyscall_table)
+		*(.patch.fsyscall_table.data)
 		__end_gate_fsyscall_patchlist = .;
 
 		__start_gate_brl_fsys_bubble_down_patchlist = .;
-		*(.data.patch.brl_fsys_bubble_down)
+		*(.patch.brl_fsys_bubble_down.data)
 		__end_gate_brl_fsys_bubble_down_patchlist = .;
 	}						:readable
 
diff -urpN linux-2.6.org/arch/ia64/kernel/head.S linux-2.6.gc1/arch/ia64/kernel/head.S
--- linux-2.6.org/arch/ia64/kernel/head.S	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/ia64/kernel/head.S	2007-11-23 20:55:41.000000000 -0800
@@ -178,7 +178,7 @@ swapper_pg_dir:
 halt_msg:
 	stringz "Halting kernel\n"
 
-	.section .text.head,"ax"
+	.section .head.text,"ax"
 
 	.global start_ap
 
diff -urpN linux-2.6.org/arch/ia64/kernel/init_task.c linux-2.6.gc1/arch/ia64/kernel/init_task.c
--- linux-2.6.org/arch/ia64/kernel/init_task.c	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/ia64/kernel/init_task.c	2007-11-23 20:55:53.000000000 -0800
@@ -29,7 +29,7 @@ EXPORT_SYMBOL(init_mm);
  * Initial task structure.
  *
  * We need to make sure that this is properly aligned due to the way process stacks are
- * handled. This is done by having a special ".data.init_task" section...
+ * handled. This is done by having a special ".init_task.data" section...
  */
 #define init_thread_info	init_task_mem.s.thread_info
 
@@ -39,7 +39,7 @@ union {
 		struct thread_info thread_info;
 	} s;
 	unsigned long stack[KERNEL_STACK_SIZE/sizeof (unsigned long)];
-} init_task_mem asm ("init_task") __attribute__((section(".data.init_task"))) = {{
+} init_task_mem asm ("init_task") __attribute__((section(".init_task.data"))) = {{
 	.task =		INIT_TASK(init_task_mem.s.task),
 	.thread_info =	INIT_THREAD_INFO(init_task_mem.s.task)
 }};
diff -urpN linux-2.6.org/arch/ia64/kernel/ivt.S linux-2.6.gc1/arch/ia64/kernel/ivt.S
--- linux-2.6.org/arch/ia64/kernel/ivt.S	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/ia64/kernel/ivt.S	2007-11-23 20:55:51.000000000 -0800
@@ -75,7 +75,7 @@
 	mov r19=n;;			/* prepare to save predicates */		\
 	br.sptk.many dispatch_to_fault_handler
 
-	.section .text.ivt,"ax"
+	.section .ivt.text,"ax"
 
 	.align 32768	// align on 32KB boundary
 	.global ia64_ivt
diff -urpN linux-2.6.org/arch/ia64/kernel/vmlinux.lds.S linux-2.6.gc1/arch/ia64/kernel/vmlinux.lds.S
--- linux-2.6.org/arch/ia64/kernel/vmlinux.lds.S	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/ia64/kernel/vmlinux.lds.S	2007-11-23 20:55:59.000000000 -0800
@@ -9,7 +9,7 @@
 
 #define IVT_TEXT							\
 		VMLINUX_SYMBOL(__start_ivt_text) = .;			\
-		*(.text.ivt)						\
+		*(.ivt.text)						\
 		VMLINUX_SYMBOL(__end_ivt_text) = .;
 
 OUTPUT_FORMAT("elf64-ia64-little")
@@ -52,13 +52,13 @@ SECTIONS
 	KPROBES_TEXT
 	*(.gnu.linkonce.t*)
     }
-  .text.head : AT(ADDR(.text.head) - LOAD_OFFSET)
-	{ *(.text.head) }
+  .head.text : AT(ADDR(.head.text) - LOAD_OFFSET)
+	{ *(.head.text) }
   .text2 : AT(ADDR(.text2) - LOAD_OFFSET)
 	{ *(.text2) }
 #ifdef CONFIG_SMP
-  .text.lock : AT(ADDR(.text.lock) - LOAD_OFFSET)
-	{ *(.text.lock) }
+  .lock.text : AT(ADDR(.lock.text) - LOAD_OFFSET)
+	{ *(.lock.text) }
 #endif
   _etext = .;
 
@@ -85,10 +85,10 @@ SECTIONS
 	  __stop___mca_table = .;
 	}
 
-  .data.patch.phys_stack_reg : AT(ADDR(.data.patch.phys_stack_reg) - LOAD_OFFSET)
+  .patch.phys_stack_reg.data : AT(ADDR(.patch.phys_stack_reg.data) - LOAD_OFFSET)
 	{
 	  __start___phys_stack_reg_patchlist = .;
-	  *(.data.patch.phys_stack_reg)
+	  *(.patch.phys_stack_reg.data)
 	  __end___phys_stack_reg_patchlist = .;
 	}
 
@@ -149,17 +149,17 @@ SECTIONS
 	  __initcall_end = .;
 	}
 
-  .data.patch.vtop : AT(ADDR(.data.patch.vtop) - LOAD_OFFSET)
+  .patch.vtop.data : AT(ADDR(.patch.vtop.data) - LOAD_OFFSET)
 	{
 	  __start___vtop_patchlist = .;
-	  *(.data.patch.vtop)
+	  *(.patch.vtop.data)
 	  __end___vtop_patchlist = .;
 	}
 
-  .data.patch.mckinley_e9 : AT(ADDR(.data.patch.mckinley_e9) - LOAD_OFFSET)
+  .patch.mckinley_e9.data : AT(ADDR(.patch.mckinley_e9.data) - LOAD_OFFSET)
 	{
 	  __start___mckinley_e9_bundles = .;
-	  *(.data.patch.mckinley_e9)
+	  *(.patch.mckinley_e9.data)
 	  __end___mckinley_e9_bundles = .;
 	}
 
@@ -187,34 +187,34 @@ SECTIONS
   __init_end = .;
 
   /* The initial task and kernel stack */
-  .data.init_task : AT(ADDR(.data.init_task) - LOAD_OFFSET)
-	{ *(.data.init_task) }
+  .init_task.data : AT(ADDR(.init_task.data) - LOAD_OFFSET)
+	{ *(.init_task.data) }
 
-  .data.page_aligned : AT(ADDR(.data.page_aligned) - LOAD_OFFSET)
+  .page_aligned.data : AT(ADDR(.page_aligned.data) - LOAD_OFFSET)
         { *(__special_page_section)
 	  __start_gate_section = .;
-	  *(.data.gate)
+	  *(.gate.data)
 	  __stop_gate_section = .;
 	}
   . = ALIGN(PAGE_SIZE);		/* make sure the gate page doesn't expose
   				 * kernel data
 				 */
 
-  .data.read_mostly : AT(ADDR(.data.read_mostly) - LOAD_OFFSET)
-        { *(.data.read_mostly) }
+  .read_mostly.data : AT(ADDR(.read_mostly.data) - LOAD_OFFSET)
+        { *(.read_mostly.data) }
 
-  .data.cacheline_aligned : AT(ADDR(.data.cacheline_aligned) - LOAD_OFFSET)
-        { *(.data.cacheline_aligned) }
+  .cacheline_aligned.data : AT(ADDR(.cacheline_aligned.data) - LOAD_OFFSET)
+        { *(.cacheline_aligned.data) }
 
   /* Per-cpu data: */
   percpu : { } :percpu
   . = ALIGN(PERCPU_PAGE_SIZE);
   __phys_per_cpu_start = .;
-  .data.percpu PERCPU_ADDR : AT(__phys_per_cpu_start - LOAD_OFFSET)
+  .percpu.data PERCPU_ADDR : AT(__phys_per_cpu_start - LOAD_OFFSET)
 	{
 		__per_cpu_start = .;
-		*(.data.percpu)
-		*(.data.percpu.shared_aligned)
+		*(.percpu.data)
+		*(.percpu.shared_aligned.data)
 		__per_cpu_end = .;
 	}
   . = __phys_per_cpu_start + PERCPU_PAGE_SIZE;	/* ensure percpu data fits
diff -urpN linux-2.6.org/arch/m32r/kernel/init_task.c linux-2.6.gc1/arch/m32r/kernel/init_task.c
--- linux-2.6.org/arch/m32r/kernel/init_task.c	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/m32r/kernel/init_task.c	2007-11-23 20:55:53.000000000 -0800
@@ -27,7 +27,7 @@ EXPORT_SYMBOL(init_mm);
  * "init_task" linker map entry..
  */
 union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
+	__attribute__((__section__(".init_task.data"))) =
 		{ INIT_THREAD_INFO(init_task) };
 
 /*
diff -urpN linux-2.6.org/arch/m32r/kernel/vmlinux.lds.S linux-2.6.gc1/arch/m32r/kernel/vmlinux.lds.S
--- linux-2.6.org/arch/m32r/kernel/vmlinux.lds.S	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/m32r/kernel/vmlinux.lds.S	2007-11-23 20:55:57.000000000 -0800
@@ -56,20 +56,20 @@ SECTIONS
 
   . = ALIGN(4096);
   __nosave_begin = .;
-  .data_nosave : { *(.data.nosave) }
+  .data_nosave : { *(.nosave.data) }
   . = ALIGN(4096);
   __nosave_end = .;
 
   . = ALIGN(4096);
-  .data.page_aligned : { *(.data.idt) }
+  .page_aligned.data : { *(.idt.data) }
 
   . = ALIGN(32);
-  .data.cacheline_aligned : { *(.data.cacheline_aligned) }
+  .cacheline_aligned.data : { *(.cacheline_aligned.data) }
 
   _edata = .;			/* End of data section */
 
   . = ALIGN(8192);		/* init_task */
-  .data.init_task : { *(.data.init_task) }
+  .init_task.data : { *(.init_task.data) }
 
   /* will be freed after init */
   . = ALIGN(4096);		/* Init code and data */
diff -urpN linux-2.6.org/arch/m68k/kernel/head.S linux-2.6.gc1/arch/m68k/kernel/head.S
--- linux-2.6.org/arch/m68k/kernel/head.S	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/m68k/kernel/head.S	2007-11-23 20:55:41.000000000 -0800
@@ -577,7 +577,7 @@ func_define	putn,1
 #endif
 .endm
 
-.section ".text.head","ax"
+.section ".head.text","ax"
 ENTRY(_stext)
 /*
  * Version numbers of the bootinfo interface
diff -urpN linux-2.6.org/arch/m68k/kernel/process.c linux-2.6.gc1/arch/m68k/kernel/process.c
--- linux-2.6.org/arch/m68k/kernel/process.c	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/m68k/kernel/process.c	2007-11-23 20:55:53.000000000 -0800
@@ -50,7 +50,7 @@ struct mm_struct init_mm = INIT_MM(init_
 EXPORT_SYMBOL(init_mm);
 
 union thread_union init_thread_union
-__attribute__((section(".data.init_task"), aligned(THREAD_SIZE)))
+__attribute__((section(".init_task.data"), aligned(THREAD_SIZE)))
        = { INIT_THREAD_INFO(init_task) };
 
 /* initial task structure */
diff -urpN linux-2.6.org/arch/m68k/kernel/sun3-head.S linux-2.6.gc1/arch/m68k/kernel/sun3-head.S
--- linux-2.6.org/arch/m68k/kernel/sun3-head.S	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/m68k/kernel/sun3-head.S	2007-11-23 20:55:41.000000000 -0800
@@ -29,7 +29,7 @@ kernel_pmd_table:              .skip 0x2
 .globl kernel_pg_dir
 .equ    kernel_pg_dir,kernel_pmd_table
 
-	.section .text.head
+	.section .head.text
 ENTRY(_stext)
 ENTRY(_start)
 
diff -urpN linux-2.6.org/arch/m68k/kernel/vmlinux-std.lds linux-2.6.gc1/arch/m68k/kernel/vmlinux-std.lds
--- linux-2.6.org/arch/m68k/kernel/vmlinux-std.lds	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/m68k/kernel/vmlinux-std.lds	2007-11-23 20:55:53.000000000 -0800
@@ -11,7 +11,7 @@ SECTIONS
   . = 0x1000;
   _text = .;			/* Text and read-only data */
   .text : {
-	*(.text.head)
+	*(.head.text)
 	TEXT_TEXT
 	SCHED_TEXT
 	LOCK_TEXT
@@ -36,7 +36,7 @@ SECTIONS
   .bss : { *(.bss) }		/* BSS */
 
   . = ALIGN(16);
-  .data.cacheline_aligned : { *(.data.cacheline_aligned) } :data
+  .cacheline_aligned.data : { *(.cacheline_aligned.data) } :data
 
   _edata = .;			/* End of data section */
 
@@ -76,7 +76,7 @@ SECTIONS
   . = ALIGN(8192);
   __init_end = .;
 
-  .data.init_task : { *(.data.init_task) }	/* The initial task and kernel stack */
+  .init_task.data : { *(.init_task.data) }	/* The initial task and kernel stack */
 
   _end = . ;
 
diff -urpN linux-2.6.org/arch/m68k/kernel/vmlinux-sun3.lds linux-2.6.gc1/arch/m68k/kernel/vmlinux-sun3.lds
--- linux-2.6.org/arch/m68k/kernel/vmlinux-sun3.lds	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/m68k/kernel/vmlinux-sun3.lds	2007-11-23 20:55:53.000000000 -0800
@@ -11,7 +11,7 @@ SECTIONS
   . = 0xE002000;
   _text = .;			/* Text and read-only data */
   .text : {
-	*(.text.head)
+	*(.head.text)
 	TEXT_TEXT
 	SCHED_TEXT
 	LOCK_TEXT
@@ -68,7 +68,7 @@ __init_begin = .;
 #endif
 	. = ALIGN(8192);
 	__init_end = .;
-	.data.init.task : { *(.data.init_task) }
+	.init.task.data : { *(.init_task.data) }
 
 
   .bss : { *(.bss) }		/* BSS */
diff -urpN linux-2.6.org/arch/m68knommu/kernel/init_task.c linux-2.6.gc1/arch/m68knommu/kernel/init_task.c
--- linux-2.6.org/arch/m68knommu/kernel/init_task.c	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/m68knommu/kernel/init_task.c	2007-11-23 20:55:53.000000000 -0800
@@ -38,6 +38,6 @@ EXPORT_SYMBOL(init_task);
  * "init_task" linker map entry..
  */
 union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
+	__attribute__((__section__(".init_task.data"))) =
 		{ INIT_THREAD_INFO(init_task) };
 
diff -urpN linux-2.6.org/arch/m68knommu/kernel/vmlinux.lds.S linux-2.6.gc1/arch/m68knommu/kernel/vmlinux.lds.S
--- linux-2.6.org/arch/m68knommu/kernel/vmlinux.lds.S	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/m68knommu/kernel/vmlinux.lds.S	2007-11-23 20:55:53.000000000 -0800
@@ -55,7 +55,7 @@ SECTIONS {
 	.romvec : {
 		__rom_start = . ;
 		_romvec = .;
-		*(.data.initvect)
+		*(.initvect.data)
 	} > romvec
 #endif
 
@@ -64,7 +64,7 @@ SECTIONS {
 		_stext = . ;
 		TEXT_TEXT
 		SCHED_TEXT
-        	*(.text.lock)
+        	*(.lock.text)
 
 		. = ALIGN(16);          /* Exception table              */
 		__start___ex_table = .;
@@ -135,7 +135,7 @@ SECTIONS {
 		_sdata = . ;
 		DATA_DATA
 		. = ALIGN(8192) ;
-		*(.data.init_task)
+		*(.init_task.data)
 		_edata = . ;
 	} > DATA
 
diff -urpN linux-2.6.org/arch/m68knommu/platform/68360/head-ram.S linux-2.6.gc1/arch/m68knommu/platform/68360/head-ram.S
--- linux-2.6.org/arch/m68knommu/platform/68360/head-ram.S	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/m68knommu/platform/68360/head-ram.S	2007-11-23 20:55:53.000000000 -0800
@@ -280,7 +280,7 @@ _dprbase:
      * and then overwritten as needed.
      */
  
-.section ".data.initvect","awx"
+.section ".initvect.data","awx"
     .long   RAMEND	/* Reset: Initial Stack Pointer                 - 0.  */
     .long   _start      /* Reset: Initial Program Counter               - 1.  */
     .long   buserr      /* Bus Error                                    - 2.  */
diff -urpN linux-2.6.org/arch/m68knommu/platform/68360/head-rom.S linux-2.6.gc1/arch/m68knommu/platform/68360/head-rom.S
--- linux-2.6.org/arch/m68knommu/platform/68360/head-rom.S	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/m68knommu/platform/68360/head-rom.S	2007-11-23 20:55:53.000000000 -0800
@@ -291,7 +291,7 @@ _dprbase:
      * and then overwritten as needed.
      */
  
-.section ".data.initvect","awx"
+.section ".initvect.data","awx"
     .long   RAMEND	/* Reset: Initial Stack Pointer                 - 0.  */
     .long   _start      /* Reset: Initial Program Counter               - 1.  */
     .long   buserr      /* Bus Error                                    - 2.  */
diff -urpN linux-2.6.org/arch/mips/kernel/init_task.c linux-2.6.gc1/arch/mips/kernel/init_task.c
--- linux-2.6.org/arch/mips/kernel/init_task.c	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/mips/kernel/init_task.c	2007-11-23 20:55:53.000000000 -0800
@@ -28,7 +28,7 @@ EXPORT_SYMBOL(init_mm);
  * The things we do for performance..
  */
 union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"),
+	__attribute__((__section__(".init_task.data"),
 	               __aligned__(THREAD_SIZE))) =
 		{ INIT_THREAD_INFO(init_task) };
 
diff -urpN linux-2.6.org/arch/mips/kernel/vmlinux.lds.S linux-2.6.gc1/arch/mips/kernel/vmlinux.lds.S
--- linux-2.6.org/arch/mips/kernel/vmlinux.lds.S	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/mips/kernel/vmlinux.lds.S	2007-11-23 20:55:54.000000000 -0800
@@ -76,7 +76,7 @@ SECTIONS
 		 * object file alignment.  Using 32768
 		 */
 		. = ALIGN(_PAGE_SIZE);
-		*(.data.init_task)
+		*(.init_task.data)
 
 		DATA_DATA
 		CONSTRUCTORS
@@ -98,14 +98,14 @@ SECTIONS
 	. = ALIGN(_PAGE_SIZE);
 	.data_nosave : {
 		__nosave_begin = .;
-		*(.data.nosave)
+		*(.nosave.data)
 	}
 	. = ALIGN(_PAGE_SIZE);
 	__nosave_end = .;
 
 	. = ALIGN(32);
-	.data.cacheline_aligned : {
-		*(.data.cacheline_aligned)
+	.cacheline_aligned.data : {
+		*(.cacheline_aligned.data)
 	}
 	_edata =  .;			/* End of data section */
 
diff -urpN linux-2.6.org/arch/mips/lasat/image/head.S linux-2.6.gc1/arch/mips/lasat/image/head.S
--- linux-2.6.org/arch/mips/lasat/image/head.S	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/mips/lasat/image/head.S	2007-11-23 20:55:45.000000000 -0800
@@ -1,7 +1,7 @@
 #include <asm/lasat/head.h>
 
 	.text
-	.section .text.start, "ax"
+	.section .start.text, "ax"
 	.set noreorder
 	.set mips3
 
diff -urpN linux-2.6.org/arch/mips/lasat/image/romscript.normal linux-2.6.gc1/arch/mips/lasat/image/romscript.normal
--- linux-2.6.org/arch/mips/lasat/image/romscript.normal	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/mips/lasat/image/romscript.normal	2007-11-23 20:55:45.000000000 -0800
@@ -4,7 +4,7 @@ SECTIONS
 {
   .text :
   {
-    *(.text.start)
+    *(.start.text)
   }
 
   /* Data in ROM */
diff -urpN linux-2.6.org/arch/parisc/kernel/init_task.c linux-2.6.gc1/arch/parisc/kernel/init_task.c
--- linux-2.6.org/arch/parisc/kernel/init_task.c	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/parisc/kernel/init_task.c	2007-11-23 20:56:00.000000000 -0800
@@ -50,7 +50,7 @@ EXPORT_SYMBOL(init_mm);
  * "init_task" linker map entry..
  */
 union thread_union init_thread_union
-	__attribute__((aligned(128))) __attribute__((__section__(".data.init_task"))) =
+	__attribute__((aligned(128))) __attribute__((__section__(".init_task.data"))) =
 		{ INIT_THREAD_INFO(init_task) };
 
 #if PT_NLEVELS == 3
@@ -59,11 +59,11 @@ union thread_union init_thread_union
  * guarantee that global objects will be laid out in memory in the same order 
  * as the order of declaration, so put these in different sections and use
  * the linker script to order them. */
-pmd_t pmd0[PTRS_PER_PMD] __attribute__ ((__section__ (".data.vm0.pmd"), aligned(PAGE_SIZE)));
+pmd_t pmd0[PTRS_PER_PMD] __attribute__ ((__section__ (".vm0.pmd.data"), aligned(PAGE_SIZE)));
 #endif
 
-pgd_t swapper_pg_dir[PTRS_PER_PGD] __attribute__ ((__section__ (".data.vm0.pgd"), aligned(PAGE_SIZE)));
-pte_t pg0[PT_INITIAL * PTRS_PER_PTE] __attribute__ ((__section__ (".data.vm0.pte"), aligned(PAGE_SIZE)));
+pgd_t swapper_pg_dir[PTRS_PER_PGD] __attribute__ ((__section__ (".vm0.pgd.data"), aligned(PAGE_SIZE)));
+pte_t pg0[PT_INITIAL * PTRS_PER_PTE] __attribute__ ((__section__ (".vm0.pte.data"), aligned(PAGE_SIZE)));
 
 /*
  * Initial task structure.
diff -urpN linux-2.6.org/arch/parisc/kernel/vmlinux.lds.S linux-2.6.gc1/arch/parisc/kernel/vmlinux.lds.S
--- linux-2.6.org/arch/parisc/kernel/vmlinux.lds.S	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/parisc/kernel/vmlinux.lds.S	2007-11-23 20:56:00.000000000 -0800
@@ -53,10 +53,10 @@ SECTIONS
 		TEXT_TEXT
 		SCHED_TEXT
 		LOCK_TEXT
-		*(.text.do_softirq)
-		*(.text.sys_exit)
-		*(.text.do_sigaltstack)
-		*(.text.do_fork)
+		*(.do_softirq.text)
+		*(.sys_exit.text)
+		*(.do_sigaltstack.text)
+		*(.do_fork.text)
 		*(.text.*)
 		*(.fixup)
 		*(.lock.text)		/* out-of-line lock text */
@@ -94,8 +94,8 @@ SECTIONS
 
 	/* rarely changed data like cpu maps */
 	. = ALIGN(16);
-	.data.read_mostly : {
-		*(.data.read_mostly)
+	.read_mostly.data : {
+		*(.read_mostly.data)
 	}
 
 	. = ALIGN(L1_CACHE_BYTES);
@@ -106,14 +106,14 @@ SECTIONS
 	}
 
 	. = ALIGN(L1_CACHE_BYTES);
-	.data.cacheline_aligned : {
-		*(.data.cacheline_aligned)
+	.cacheline_aligned.data : {
+		*(.cacheline_aligned.data)
 	}
 
 	/* PA-RISC locks requires 16-byte alignment */
 	. = ALIGN(16);
-	.data.lock_aligned : {
-		*(.data.lock_aligned)
+	.lock_aligned.data : {
+		*(.lock_aligned.data)
 	}
 
 	/* nosave data is really only used for software suspend...it's here
@@ -122,7 +122,7 @@ SECTIONS
 	. = ALIGN(PAGE_SIZE);
 	__nosave_begin = .;
 	.data_nosave : {
-		*(.data.nosave)
+		*(.nosave.data)
 	}
 	. = ALIGN(PAGE_SIZE);
 	__nosave_end = .;
@@ -135,9 +135,9 @@ SECTIONS
 	/* page table entries need to be PAGE_SIZE aligned */
 	. = ALIGN(PAGE_SIZE);
 	.data.vmpages : {
-		*(.data.vm0.pmd)
-		*(.data.vm0.pgd)
-		*(.data.vm0.pte)
+		*(.vm0.pmd.data)
+		*(.vm0.pgd.data)
+		*(.vm0.pte.data)
 	}
 	.bss : {
 		*(.bss)
@@ -149,8 +149,8 @@ SECTIONS
 	/* assembler code expects init_task to be 16k aligned */
 	. = ALIGN(16384);
 	/* init_task */
-	.data.init_task : {
-		*(.data.init_task)
+	.init_task.data : {
+		*(.init_task.data)
 	}
 
 #ifdef CONFIG_64BIT
diff -urpN linux-2.6.org/arch/powerpc/kernel/head_32.S linux-2.6.gc1/arch/powerpc/kernel/head_32.S
--- linux-2.6.org/arch/powerpc/kernel/head_32.S	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/powerpc/kernel/head_32.S	2007-11-23 20:55:41.000000000 -0800
@@ -48,7 +48,7 @@
 	mtspr	SPRN_DBAT##n##L,RB;	\
 1:
 
-	.section	.text.head, "ax"
+	.section	.head.text, "ax"
 	.stabs	"arch/powerpc/kernel/",N_SO,0,0,0f
 	.stabs	"head_32.S",N_SO,0,0,0f
 0:
diff -urpN linux-2.6.org/arch/powerpc/kernel/head_40x.S linux-2.6.gc1/arch/powerpc/kernel/head_40x.S
--- linux-2.6.org/arch/powerpc/kernel/head_40x.S	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/powerpc/kernel/head_40x.S	2007-11-23 20:55:41.000000000 -0800
@@ -52,7 +52,7 @@
  *
  * This is all going to change RSN when we add bi_recs.......  -- Dan
  */
-	.section	.text.head, "ax"
+	.section	.head.text, "ax"
 _ENTRY(_stext);
 _ENTRY(_start);
 
diff -urpN linux-2.6.org/arch/powerpc/kernel/head_44x.S linux-2.6.gc1/arch/powerpc/kernel/head_44x.S
--- linux-2.6.org/arch/powerpc/kernel/head_44x.S	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/powerpc/kernel/head_44x.S	2007-11-23 20:55:41.000000000 -0800
@@ -50,7 +50,7 @@
  *   r7 - End of kernel command line string
  *
  */
-	.section	.text.head, "ax"
+	.section	.head.text, "ax"
 _ENTRY(_stext);
 _ENTRY(_start);
 	/*
diff -urpN linux-2.6.org/arch/powerpc/kernel/head_8xx.S linux-2.6.gc1/arch/powerpc/kernel/head_8xx.S
--- linux-2.6.org/arch/powerpc/kernel/head_8xx.S	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/powerpc/kernel/head_8xx.S	2007-11-23 20:55:41.000000000 -0800
@@ -38,7 +38,7 @@
 #else
 #define DO_8xx_CPU6(val, reg)
 #endif
-	.section	.text.head, "ax"
+	.section	.head.text, "ax"
 _ENTRY(_stext);
 _ENTRY(_start);
 
diff -urpN linux-2.6.org/arch/powerpc/kernel/head_fsl_booke.S linux-2.6.gc1/arch/powerpc/kernel/head_fsl_booke.S
--- linux-2.6.org/arch/powerpc/kernel/head_fsl_booke.S	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/powerpc/kernel/head_fsl_booke.S	2007-11-23 20:55:41.000000000 -0800
@@ -52,7 +52,7 @@
  *   r7 - End of kernel command line string
  *
  */
-	.section	.text.head, "ax"
+	.section	.head.text, "ax"
 _ENTRY(_stext);
 _ENTRY(_start);
 	/*
diff -urpN linux-2.6.org/arch/powerpc/kernel/init_task.c linux-2.6.gc1/arch/powerpc/kernel/init_task.c
--- linux-2.6.org/arch/powerpc/kernel/init_task.c	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/powerpc/kernel/init_task.c	2007-11-23 20:55:54.000000000 -0800
@@ -23,7 +23,7 @@ EXPORT_SYMBOL(init_mm);
  * "init_task" linker map entry..
  */
 union thread_union init_thread_union 
-	__attribute__((__section__(".data.init_task"))) =
+	__attribute__((__section__(".init_task.data"))) =
 		{ INIT_THREAD_INFO(init_task) };
 
 /*
diff -urpN linux-2.6.org/arch/powerpc/kernel/machine_kexec_64.c linux-2.6.gc1/arch/powerpc/kernel/machine_kexec_64.c
--- linux-2.6.org/arch/powerpc/kernel/machine_kexec_64.c	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/powerpc/kernel/machine_kexec_64.c	2007-11-23 20:55:54.000000000 -0800
@@ -250,7 +250,7 @@ static void kexec_prepare_cpus(void)
  * current, but that audit has not been performed.
  */
 union thread_union kexec_stack
-	__attribute__((__section__(".data.init_task"))) = { };
+	__attribute__((__section__(".init_task.data"))) = { };
 
 /* Our assembly helper, in kexec_stub.S */
 extern NORET_TYPE void kexec_sequence(void *newstack, unsigned long start,
diff -urpN linux-2.6.org/arch/powerpc/kernel/vdso.c linux-2.6.gc1/arch/powerpc/kernel/vdso.c
--- linux-2.6.org/arch/powerpc/kernel/vdso.c	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/powerpc/kernel/vdso.c	2007-11-23 20:55:55.000000000 -0800
@@ -73,7 +73,7 @@ static int vdso_ready;
 static union {
 	struct vdso_data	data;
 	u8			page[PAGE_SIZE];
-} vdso_data_store __attribute__((__section__(".data.page_aligned")));
+} vdso_data_store __attribute__((__section__(".page_aligned.data")));
 struct vdso_data *vdso_data = &vdso_data_store.data;
 
 /* Format of the patch table */
diff -urpN linux-2.6.org/arch/powerpc/kernel/vdso32/vdso32_wrapper.S linux-2.6.gc1/arch/powerpc/kernel/vdso32/vdso32_wrapper.S
--- linux-2.6.org/arch/powerpc/kernel/vdso32/vdso32_wrapper.S	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/powerpc/kernel/vdso32/vdso32_wrapper.S	2007-11-23 20:55:55.000000000 -0800
@@ -1,7 +1,7 @@
 #include <linux/init.h>
 #include <asm/page.h>
 
-	.section ".data.page_aligned"
+	.section ".page_aligned.data"
 
 	.globl vdso32_start, vdso32_end
 	.balign PAGE_SIZE
diff -urpN linux-2.6.org/arch/powerpc/kernel/vdso64/vdso64_wrapper.S linux-2.6.gc1/arch/powerpc/kernel/vdso64/vdso64_wrapper.S
--- linux-2.6.org/arch/powerpc/kernel/vdso64/vdso64_wrapper.S	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/powerpc/kernel/vdso64/vdso64_wrapper.S	2007-11-23 20:55:55.000000000 -0800
@@ -1,7 +1,7 @@
 #include <linux/init.h>
 #include <asm/page.h>
 
-	.section ".data.page_aligned"
+	.section ".page_aligned.data"
 
 	.globl vdso64_start, vdso64_end
 	.balign PAGE_SIZE
diff -urpN linux-2.6.org/arch/powerpc/kernel/vmlinux.lds.S linux-2.6.gc1/arch/powerpc/kernel/vmlinux.lds.S
--- linux-2.6.org/arch/powerpc/kernel/vmlinux.lds.S	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/powerpc/kernel/vmlinux.lds.S	2007-11-23 20:55:55.000000000 -0800
@@ -35,9 +35,9 @@ SECTIONS
 	/* Text and gots */
 	.text : {
 		ALIGN_FUNCTION();
-		*(.text.head)
+		*(.head.text)
 		_text = .;
-		*(.text .fixup .text.init.refok .exit.text.refok)
+		*(.text .fixup .init.refok.text .exit.text.refok)
 		SCHED_TEXT
 		LOCK_TEXT
 		KPROBES_TEXT
@@ -144,10 +144,10 @@ SECTIONS
 	}
 #endif
 	. = ALIGN(PAGE_SIZE);
-	.data.percpu : {
+	.percpu.data : {
 		__per_cpu_start = .;
-		*(.data.percpu)
-		*(.data.percpu.shared_aligned)
+		*(.percpu.data)
+		*(.percpu.shared_aligned.data)
 		__per_cpu_end = .;
 	}
 
@@ -205,28 +205,28 @@ SECTIONS
 #else
 	. = ALIGN(16384);
 #endif
-	.data.init_task : {
-		*(.data.init_task)
+	.init_task.data : {
+		*(.init_task.data)
 	}
 
 	. = ALIGN(PAGE_SIZE);
-	.data.page_aligned : {
-		*(.data.page_aligned)
+	.page_aligned.data : {
+		*(.page_aligned.data)
 	}
 
-	.data.cacheline_aligned : {
-		*(.data.cacheline_aligned)
+	.cacheline_aligned.data : {
+		*(.cacheline_aligned.data)
 	}
 
 	. = ALIGN(L1_CACHE_BYTES);
-	.data.read_mostly : {
-		*(.data.read_mostly)
+	.read_mostly.data : {
+		*(.read_mostly.data)
 	}
 
 	. = ALIGN(PAGE_SIZE);
 	__data_nosave : {
 		__nosave_begin = .;
-		*(.data.nosave)
+		*(.nosave.data)
 		. = ALIGN(PAGE_SIZE);
 		__nosave_end = .;
 	}
diff -urpN linux-2.6.org/arch/ppc/boot/ld.script linux-2.6.gc1/arch/ppc/boot/ld.script
--- linux-2.6.org/arch/ppc/boot/ld.script	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/ppc/boot/ld.script	2007-11-23 20:55:59.000000000 -0800
@@ -41,7 +41,7 @@ SECTIONS
   {
     *(.data)
     *(.data1)
-    *(.data.boot)
+    *(.boot.data)
     *(.sdata)
     *(.sdata2)
     *(.got.plt) *(.got)
diff -urpN linux-2.6.org/arch/ppc/boot/simple/misc-embedded.c linux-2.6.gc1/arch/ppc/boot/simple/misc-embedded.c
--- linux-2.6.org/arch/ppc/boot/simple/misc-embedded.c	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/ppc/boot/simple/misc-embedded.c	2007-11-23 20:55:59.000000000 -0800
@@ -60,7 +60,7 @@ unsigned long com_port;
 
 /* We need to make sure that this is before the images to ensure
  * that it's in a mapped location. - Tom */
-bd_t hold_resid_buf __attribute__ ((__section__ (".data.boot")));
+bd_t hold_resid_buf __attribute__ ((__section__ (".boot.data")));
 bd_t *hold_residual = &hold_resid_buf;
 
 extern unsigned long serial_init(int chan, bd_t *bp);
diff -urpN linux-2.6.org/arch/ppc/boot/simple/openbios.c linux-2.6.gc1/arch/ppc/boot/simple/openbios.c
--- linux-2.6.org/arch/ppc/boot/simple/openbios.c	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/ppc/boot/simple/openbios.c	2007-11-23 20:55:59.000000000 -0800
@@ -41,7 +41,7 @@ extern unsigned long decompress_kernel(u
 
 /* We need to make sure that this is before the images to ensure
  * that it's in a mapped location. */
-bd_t hold_resid_buf __attribute__ ((__section__ (".data.boot")));
+bd_t hold_resid_buf __attribute__ ((__section__ (".boot.data")));
 bd_t *hold_residual = &hold_resid_buf;
 
 typedef struct openbios_board_info {
diff -urpN linux-2.6.org/arch/ppc/boot/simple/pibs.c linux-2.6.gc1/arch/ppc/boot/simple/pibs.c
--- linux-2.6.org/arch/ppc/boot/simple/pibs.c	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/ppc/boot/simple/pibs.c	2007-11-23 20:55:59.000000000 -0800
@@ -16,7 +16,7 @@ extern unsigned long decompress_kernel(u
 
 /* We need to make sure that this is before the images to ensure
  * that it's in a mapped location. - Tom */
-bd_t hold_resid_buf __attribute__ ((__section__ (".data.boot")));
+bd_t hold_resid_buf __attribute__ ((__section__ (".boot.data")));
 bd_t *hold_residual = &hold_resid_buf;
 
 /* String functions lifted from lib/vsprintf.c and lib/ctype.c */
diff -urpN linux-2.6.org/arch/ppc/kernel/vmlinux.lds.S linux-2.6.gc1/arch/ppc/kernel/vmlinux.lds.S
--- linux-2.6.org/arch/ppc/kernel/vmlinux.lds.S	2007-11-23 18:55:09.000000000 -0800
+++ linux-2.6.gc1/arch/ppc/kernel/vmlinux.lds.S	2007-11-23 20:55:54.000000000 -0800
@@ -78,18 +78,18 @@ SECTIONS
 
   . = ALIGN(4096);
   __nosave_begin = .;
-  .data_nosave : { *(.data.nosave) }
+  .data_nosave : { *(.nosave.data) }
   . = ALIGN(4096);
   __nosave_end = .;
 
   . = ALIGN(32);
-  .data.cacheline_aligned : { *(.data.cacheline_aligned) }
+  .cacheline_aligned.data : { *(.cacheline_aligned.data) }
 
   _edata  =  .;
   PROVIDE (edata = .);
 
   . = ALIGN(8192);
-  .data.init_task : { *(.data.init_task) }
+  .init_task.data : { *(.init_task.data) }
 
   NOTES
 
diff -urpN linux-2.6.org/arch/s390/kernel/head.S linux-2.6.gc1/arch/s390/kernel/head.S
--- linux-2.6.org/arch/s390/kernel/head.S	2007-11-23 18:55:10.000000000 -0800
+++ linux-2.6.gc1/arch/s390/kernel/head.S	2007-11-23 20:55:41.000000000 -0800
@@ -35,7 +35,7 @@
 #define ARCH_OFFSET	0
 #endif
 
-.section ".text.head","ax"
+.section ".head.text","ax"
 #ifndef CONFIG_IPL
 	.org   0
 	.long  0x00080000,0x80000000+startup	# Just a restart PSW
diff -urpN linux-2.6.org/arch/s390/kernel/init_task.c linux-2.6.gc1/arch/s390/kernel/init_task.c
--- linux-2.6.org/arch/s390/kernel/init_task.c	2007-11-23 18:55:10.000000000 -0800
+++ linux-2.6.gc1/arch/s390/kernel/init_task.c	2007-11-23 20:55:54.000000000 -0800
@@ -32,7 +32,7 @@ EXPORT_SYMBOL(init_mm);
  * "init_task" linker map entry..
  */
 union thread_union init_thread_union 
-	__attribute__((__section__(".data.init_task"))) =
+	__attribute__((__section__(".init_task.data"))) =
 		{ INIT_THREAD_INFO(init_task) };
 
 /*
diff -urpN linux-2.6.org/arch/s390/kernel/vmlinux.lds.S linux-2.6.gc1/arch/s390/kernel/vmlinux.lds.S
--- linux-2.6.org/arch/s390/kernel/vmlinux.lds.S	2007-11-23 18:55:10.000000000 -0800
+++ linux-2.6.gc1/arch/s390/kernel/vmlinux.lds.S	2007-11-23 20:55:57.000000000 -0800
@@ -22,7 +22,7 @@ SECTIONS
 	. = 0x00000000;
 	.text : {
 	_text = .;		/* Text and read-only data */
-		*(.text.head)
+		*(.head.text)
 	TEXT_TEXT
 		SCHED_TEXT
 		LOCK_TEXT
@@ -60,30 +60,30 @@ SECTIONS
 	. = ALIGN(PAGE_SIZE);
 	.data_nosave : {
 	__nosave_begin = .;
-		*(.data.nosave)
+		*(.nosave.data)
 	}
 	. = ALIGN(PAGE_SIZE);
 	__nosave_end = .;
 
 	. = ALIGN(PAGE_SIZE);
-	.data.page_aligned : {
-		*(.data.idt)
+	.page_aligned.data : {
+		*(.idt.data)
 	}
 
 	. = ALIGN(0x100);
-	.data.cacheline_aligned : {
-		*(.data.cacheline_aligned)
+	.cacheline_aligned.data : {
+		*(.cacheline_aligned.data)
 	}
 
 	. = ALIGN(0x100);
-	.data.read_mostly : {
-		*(.data.read_mostly)
+	.read_mostly.data : {
+		*(.read_mostly.data)
 	}
 	_edata = .;		/* End of data section */
 
 	. = ALIGN(2 * PAGE_SIZE);	/* init_task */
-	.data.init_task : {
-		*(.data.init_task)
+	.init_task.data : {
+		*(.init_task.data)
 	}
 
 	/* will be freed after init */
diff -urpN linux-2.6.org/arch/sh/kernel/head.S linux-2.6.gc1/arch/sh/kernel/head.S
--- linux-2.6.org/arch/sh/kernel/head.S	2007-11-23 18:55:10.000000000 -0800
+++ linux-2.6.gc1/arch/sh/kernel/head.S	2007-11-23 20:55:41.000000000 -0800
@@ -36,7 +36,7 @@ ENTRY(empty_zero_page)
 1:
 	.skip	PAGE_SIZE - empty_zero_page - 1b
 
-	.section	.text.head, "ax"
+	.section	.head.text, "ax"
 
 /*
  * Condition at the entry of _stext:
diff -urpN linux-2.6.org/arch/sh/kernel/init_task.c linux-2.6.gc1/arch/sh/kernel/init_task.c
--- linux-2.6.org/arch/sh/kernel/init_task.c	2007-11-23 18:55:10.000000000 -0800
+++ linux-2.6.gc1/arch/sh/kernel/init_task.c	2007-11-23 20:55:54.000000000 -0800
@@ -23,7 +23,7 @@ EXPORT_SYMBOL(init_mm);
  * "init_task" linker map entry..
  */
 union thread_union init_thread_union 
-	__attribute__((__section__(".data.init_task"))) =
+	__attribute__((__section__(".init_task.data"))) =
 		{ INIT_THREAD_INFO(init_task) };
 
 /*
diff -urpN linux-2.6.org/arch/sh/kernel/irq.c linux-2.6.gc1/arch/sh/kernel/irq.c
--- linux-2.6.org/arch/sh/kernel/irq.c	2007-11-23 18:55:10.000000000 -0800
+++ linux-2.6.gc1/arch/sh/kernel/irq.c	2007-11-23 20:56:00.000000000 -0800
@@ -158,10 +158,10 @@ asmlinkage int do_IRQ(unsigned int irq, 
 
 #ifdef CONFIG_IRQSTACKS
 static char softirq_stack[NR_CPUS * THREAD_SIZE]
-		__attribute__((__section__(".bss.page_aligned")));
+		__attribute__((__section__(".bss.k.page_aligned")));
 
 static char hardirq_stack[NR_CPUS * THREAD_SIZE]
-		__attribute__((__section__(".bss.page_aligned")));
+		__attribute__((__section__(".bss.k.page_aligned")));
 
 /*
  * allocate per-cpu stacks for hardirq and for softirq processing
diff -urpN linux-2.6.org/arch/sh/kernel/vmlinux.lds.S linux-2.6.gc1/arch/sh/kernel/vmlinux.lds.S
--- linux-2.6.org/arch/sh/kernel/vmlinux.lds.S	2007-11-23 18:55:10.000000000 -0800
+++ linux-2.6.gc1/arch/sh/kernel/vmlinux.lds.S	2007-11-23 21:59:58.000000000 -0800
@@ -23,7 +23,7 @@ SECTIONS
 	} = 0
 
 	.text : {
-		*(.text.head)
+		*(.head.text)
 		TEXT_TEXT
 		SCHED_TEXT
 		LOCK_TEXT
@@ -45,19 +45,19 @@ SECTIONS
 
 	. = ALIGN(THREAD_SIZE);
 	.data : {			/* Data */
-		*(.data.init_task)
+		*(.init_task.data)
 
 		. = ALIGN(L1_CACHE_BYTES);
-		*(.data.cacheline_aligned)
+		*(.cacheline_aligned.data)
 
 		. = ALIGN(L1_CACHE_BYTES);
-		*(.data.read_mostly)
+		*(.read_mostly.data)
 
 		. = ALIGN(PAGE_SIZE);
-		*(.data.page_aligned)
+		*(.page_aligned.data)
 
 		__nosave_begin = .;
-		*(.data.nosave)
+		*(.nosave.data)
 		. = ALIGN(PAGE_SIZE);
 		__nosave_end = .;
 
@@ -115,7 +115,7 @@ SECTIONS
 	.bss : {
 		__init_end = .;
 		__bss_start = .;		/* BSS */
-		*(.bss.page_aligned)
+		*(.bss.k.page_aligned)
 		*(.bss)
 		*(COMMON)
 		. = ALIGN(4);
diff -urpN linux-2.6.org/arch/sh64/kernel/entry.S linux-2.6.gc1/arch/sh64/kernel/entry.S
--- linux-2.6.org/arch/sh64/kernel/entry.S	2007-11-23 18:55:10.000000000 -0800
+++ linux-2.6.gc1/arch/sh64/kernel/entry.S	2007-11-23 20:55:45.000000000 -0800
@@ -2036,10 +2036,10 @@ asm_uaccess_end:
 
 
 /*
- * --- .text.init Section
+ * --- .init.text Section
  */
 
-	.section	.text.init, "ax"
+	.section	.init.text, "ax"
 
 /*
  * void trap_init (void)
diff -urpN linux-2.6.org/arch/sh64/kernel/head.S linux-2.6.gc1/arch/sh64/kernel/head.S
--- linux-2.6.org/arch/sh64/kernel/head.S	2007-11-23 18:55:10.000000000 -0800
+++ linux-2.6.gc1/arch/sh64/kernel/head.S	2007-11-23 20:55:41.000000000 -0800
@@ -124,7 +124,7 @@ empty_bad_pte_table:
 fpu_in_use:	.quad	0
 
 
-	.section	.text.head, "ax"
+	.section	.head.text, "ax"
 	.balign L1_CACHE_BYTES
 /*
  * Condition at the entry of __stext:
diff -urpN linux-2.6.org/arch/sh64/kernel/init_task.c linux-2.6.gc1/arch/sh64/kernel/init_task.c
--- linux-2.6.org/arch/sh64/kernel/init_task.c	2007-11-23 18:55:10.000000000 -0800
+++ linux-2.6.gc1/arch/sh64/kernel/init_task.c	2007-11-23 20:55:54.000000000 -0800
@@ -34,7 +34,7 @@ struct pt_regs fake_swapper_regs;
  * special "init_task" linker map entry..
  */
 union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
+	__attribute__((__section__(".init_task.data"))) =
 		{ INIT_THREAD_INFO(init_task) };
 
 /*
diff -urpN linux-2.6.org/arch/sh64/kernel/vmlinux.lds.S linux-2.6.gc1/arch/sh64/kernel/vmlinux.lds.S
--- linux-2.6.org/arch/sh64/kernel/vmlinux.lds.S	2007-11-23 18:55:10.000000000 -0800
+++ linux-2.6.gc1/arch/sh64/kernel/vmlinux.lds.S	2007-11-23 20:55:55.000000000 -0800
@@ -46,7 +46,7 @@ SECTIONS
 	} = 0
 
   .text : C_PHYS(.text) {
-  	*(.text.head)
+  	*(.head.text)
 	TEXT_TEXT
 	*(.text64)
         *(.text..SHmedia32)
@@ -78,17 +78,17 @@ SECTIONS
 	}
 
   . = ALIGN(PAGE_SIZE);
-  .data.page_aligned : C_PHYS(.data.page_aligned) { *(.data.page_aligned) }
+  .page_aligned.data : C_PHYS(.page_aligned.data) { *(.page_aligned.data) }
 
   PERCPU(PAGE_SIZE)
 
   . = ALIGN(L1_CACHE_BYTES);
-  .data.cacheline_aligned : C_PHYS(.data.cacheline_aligned) { *(.data.cacheline_aligned) }
+  .cacheline_aligned.data : C_PHYS(.cacheline_aligned.data) { *(.cacheline_aligned.data) }
 
   _edata = .;			/* End of data section */
 
   . = ALIGN(THREAD_SIZE);	/* init_task: structure size aligned */
-  .data.init_task : C_PHYS(.data.init_task) { *(.data.init_task) }
+  .init_task.data : C_PHYS(.init_task.data) { *(.init_task.data) }
 
   . = ALIGN(PAGE_SIZE);		/* Init code and data */
   __init_begin = .;
diff -urpN linux-2.6.org/arch/sparc/boot/btfixupprep.c linux-2.6.gc1/arch/sparc/boot/btfixupprep.c
--- linux-2.6.org/arch/sparc/boot/btfixupprep.c	2007-11-23 18:55:10.000000000 -0800
+++ linux-2.6.gc1/arch/sparc/boot/btfixupprep.c	2007-11-23 20:55:54.000000000 -0800
@@ -171,7 +171,7 @@ main1:
 			}
 		} else if (buffer[nbase+4] != '_')
 			continue;
-		if (!strcmp (sect, ".text.exit"))
+		if (!strcmp (sect, ".exit.text"))
 			continue;
 		if (strcmp (sect, ".text") &&
 		    strcmp (sect, ".init.text") &&
@@ -325,7 +325,7 @@ main1:
 		(*rr)->next = NULL;
 	}
 	printf("! Generated by btfixupprep. Do not edit.\n\n");
-	printf("\t.section\t\".data.init\",#alloc,#write\n\t.align\t4\n\n");
+	printf("\t.section\t\".init.data\",#alloc,#write\n\t.align\t4\n\n");
 	printf("\t.global\t___btfixup_start\n___btfixup_start:\n\n");
 	for (i = 0; i < last; i++) {
 		f = array + i;
diff -urpN linux-2.6.org/arch/sparc/kernel/head.S linux-2.6.gc1/arch/sparc/kernel/head.S
--- linux-2.6.org/arch/sparc/kernel/head.S	2007-11-23 18:55:10.000000000 -0800
+++ linux-2.6.gc1/arch/sparc/kernel/head.S	2007-11-23 20:55:45.000000000 -0800
@@ -746,7 +746,7 @@ go_to_highmem:
 		 nop
 
 /* The code above should be at beginning and we have to take care about
- * short jumps, as branching to .text.init section from .text is usually
+ * short jumps, as branching to .init.text section from .text is usually
  * impossible */
 		__INIT
 /* Acquire boot time privileged register values, this will help debugging.
diff -urpN linux-2.6.org/arch/sparc/kernel/vmlinux.lds.S linux-2.6.gc1/arch/sparc/kernel/vmlinux.lds.S
--- linux-2.6.org/arch/sparc/kernel/vmlinux.lds.S	2007-11-23 18:55:10.000000000 -0800
+++ linux-2.6.gc1/arch/sparc/kernel/vmlinux.lds.S	2007-11-23 20:55:53.000000000 -0800
@@ -86,8 +86,8 @@ SECTIONS
 	. = ALIGN(PAGE_SIZE);
 	__init_end = .;
 	. = ALIGN(32);
-	.data.cacheline_aligned : {
-		*(.data.cacheline_aligned)
+	.cacheline_aligned.data : {
+		*(.cacheline_aligned.data)
 	}
 
 	__bss_start = .;
diff -urpN linux-2.6.org/arch/sparc64/kernel/head.S linux-2.6.gc1/arch/sparc64/kernel/head.S
--- linux-2.6.org/arch/sparc64/kernel/head.S	2007-11-23 18:55:10.000000000 -0800
+++ linux-2.6.gc1/arch/sparc64/kernel/head.S	2007-11-23 20:55:45.000000000 -0800
@@ -458,7 +458,7 @@ jump_to_sun4u_init:
 	jmpl    %g2 + %g0, %g0
 	 nop
 
-	.section	.text.init.refok
+	.section	.init.refok.text
 sun4u_init:
 	BRANCH_IF_SUN4V(g1, sun4v_init)
 
diff -urpN linux-2.6.org/arch/sparc64/kernel/vmlinux.lds.S linux-2.6.gc1/arch/sparc64/kernel/vmlinux.lds.S
--- linux-2.6.org/arch/sparc64/kernel/vmlinux.lds.S	2007-11-23 18:55:10.000000000 -0800
+++ linux-2.6.gc1/arch/sparc64/kernel/vmlinux.lds.S	2007-11-23 20:55:53.000000000 -0800
@@ -32,12 +32,12 @@ SECTIONS
 		*(.data1)
 	}
 	. = ALIGN(64);
-	.data.cacheline_aligned : {
-		*(.data.cacheline_aligned)
+	.cacheline_aligned.data : {
+		*(.cacheline_aligned.data)
 	}
 	. = ALIGN(64);
-	.data.read_mostly : {
-		*(.data.read_mostly)
+	.read_mostly.data : {
+		*(.read_mostly.data)
 	}
 	_edata = .;
 	PROVIDE (edata = .);
diff -urpN linux-2.6.org/arch/um/kernel/dyn.lds.S linux-2.6.gc1/arch/um/kernel/dyn.lds.S
--- linux-2.6.org/arch/um/kernel/dyn.lds.S	2007-11-23 18:55:10.000000000 -0800
+++ linux-2.6.gc1/arch/um/kernel/dyn.lds.S	2007-11-23 20:55:54.000000000 -0800
@@ -96,9 +96,9 @@ SECTIONS
   .fini_array     : { *(.fini_array) }
   .data           : {
     . = ALIGN(KERNEL_STACK_SIZE);		/* init_task */
-    *(.data.init_task)
+    *(.init_task.data)
     . = ALIGN(KERNEL_STACK_SIZE);
-    *(.data.init_irqstack)
+    *(.init_irqstack.data)
     DATA_DATA
     *(.data.* .gnu.linkonce.d.*)
     SORT(CONSTRUCTORS)
diff -urpN linux-2.6.org/arch/um/kernel/init_task.c linux-2.6.gc1/arch/um/kernel/init_task.c
--- linux-2.6.org/arch/um/kernel/init_task.c	2007-11-23 18:55:10.000000000 -0800
+++ linux-2.6.gc1/arch/um/kernel/init_task.c	2007-11-23 20:55:54.000000000 -0800
@@ -36,9 +36,9 @@ EXPORT_SYMBOL(init_task);
  */
 
 union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
+	__attribute__((__section__(".init_task.data"))) =
 		{ INIT_THREAD_INFO(init_task) };
 
 union thread_union cpu0_irqstack
-	__attribute__((__section__(".data.init_irqstack"))) =
+	__attribute__((__section__(".init_irqstack.data"))) =
 		{ INIT_THREAD_INFO(init_task) };
diff -urpN linux-2.6.org/arch/um/kernel/uml.lds.S linux-2.6.gc1/arch/um/kernel/uml.lds.S
--- linux-2.6.org/arch/um/kernel/uml.lds.S	2007-11-23 18:55:10.000000000 -0800
+++ linux-2.6.gc1/arch/um/kernel/uml.lds.S	2007-11-23 20:55:54.000000000 -0800
@@ -52,9 +52,9 @@ SECTIONS
   .data    :
   {
     . = ALIGN(KERNEL_STACK_SIZE);		/* init_task */
-    *(.data.init_task)
+    *(.init_task.data)
     . = ALIGN(KERNEL_STACK_SIZE);
-    *(.data.init_irqstack)
+    *(.init_irqstack.data)
     DATA_DATA
     *(.gnu.linkonce.d*)
     CONSTRUCTORS
diff -urpN linux-2.6.org/arch/v850/kernel/init_task.c linux-2.6.gc1/arch/v850/kernel/init_task.c
--- linux-2.6.org/arch/v850/kernel/init_task.c	2007-11-23 18:55:10.000000000 -0800
+++ linux-2.6.gc1/arch/v850/kernel/init_task.c	2007-11-23 20:55:54.000000000 -0800
@@ -45,5 +45,5 @@ EXPORT_SYMBOL(init_task);
  * "init_task" linker map entry.
  */
 union thread_union init_thread_union 
-	__attribute__((__section__(".data.init_task"))) =
+	__attribute__((__section__(".init_task.data"))) =
 		{ INIT_THREAD_INFO(init_task) };
diff -urpN linux-2.6.org/arch/v850/kernel/vmlinux.lds.S linux-2.6.gc1/arch/v850/kernel/vmlinux.lds.S
--- linux-2.6.org/arch/v850/kernel/vmlinux.lds.S	2007-11-23 18:55:10.000000000 -0800
+++ linux-2.6.gc1/arch/v850/kernel/vmlinux.lds.S	2007-11-23 20:55:56.000000000 -0800
@@ -95,8 +95,8 @@
 		TEXT_TEXT						      \
 		SCHED_TEXT						      \
 			*(.exit.text)	/* 2.5 convention */		      \
-			*(.text.exit)	/* 2.4 convention */		      \
-			*(.text.lock)					      \
+			*(.exit.text)	/* 2.4 convention */		      \
+			*(.lock.text)					      \
 			*(.exitcall.exit)				      \
 		__real_etext = . ;	/* There may be data after here.  */  \
 		RODATA_CONTENTS						      \
@@ -115,11 +115,11 @@
 		__sdata = . ;						      \
 		DATA_DATA						      \
 			*(.exit.data)	/* 2.5 convention */		      \
-			*(.data.exit)	/* 2.4 convention */		      \
+			*(.exit.data)	/* 2.4 convention */		      \
 		. = ALIGN (16) ;					      \
-		*(.data.cacheline_aligned)				      \
+		*(.cacheline_aligned.data)				      \
 		. = ALIGN (0x2000) ;					      \
-        	*(.data.init_task)					      \
+        	*(.init_task.data)					      \
 		. = ALIGN (0x2000) ;					      \
 		__edata = . ;
 
@@ -160,8 +160,8 @@
 			*(.init.text)	/* 2.5 convention */		      \
 			__einittext = .;				      \
 			*(.init.data)					      \
-			*(.text.init)	/* 2.4 convention */		      \
-			*(.data.init)					      \
+			*(.init.text)	/* 2.4 convention */		      \
+			*(.init.data)					      \
 		INITCALL_CONTENTS					      \
 		INITRAMFS_CONTENTS
 
@@ -171,7 +171,7 @@
 		. = ALIGN (4096) ;					      \
 		__init_start = . ;					      \
 			*(.init.data)	/* 2.5 convention */		      \
-			*(.data.init)	/* 2.4 convention */		      \
+			*(.init.data)	/* 2.4 convention */		      \
 		__init_end = . ;					      \
 		. = ALIGN (4096) ;
 
@@ -181,7 +181,7 @@
 			_sinittext = .;					      \
 			*(.init.text)	/* 2.5 convention */		      \
 			_einittext = .;					      \
-			*(.text.init)	/* 2.4 convention */		      \
+			*(.init.text)	/* 2.4 convention */		      \
 		INITCALL_CONTENTS					      \
 		INITRAMFS_CONTENTS
 
diff -urpN linux-2.6.org/arch/x86/boot/compressed/head_32.S linux-2.6.gc1/arch/x86/boot/compressed/head_32.S
--- linux-2.6.org/arch/x86/boot/compressed/head_32.S	2007-11-23 18:55:10.000000000 -0800
+++ linux-2.6.gc1/arch/x86/boot/compressed/head_32.S	2007-11-23 20:55:41.000000000 -0800
@@ -29,7 +29,7 @@
 #include <asm/boot.h>
 #include <asm/asm-offsets.h>
 
-.section ".text.head","ax",@progbits
+.section ".head.text","ax",@progbits
 	.globl startup_32
 
 startup_32:
diff -urpN linux-2.6.org/arch/x86/boot/compressed/head_64.S linux-2.6.gc1/arch/x86/boot/compressed/head_64.S
--- linux-2.6.org/arch/x86/boot/compressed/head_64.S	2007-11-23 18:55:10.000000000 -0800
+++ linux-2.6.gc1/arch/x86/boot/compressed/head_64.S	2007-11-23 20:55:41.000000000 -0800
@@ -31,7 +31,7 @@
 #include <asm/msr.h>
 #include <asm/asm-offsets.h>
 
-.section ".text.head"
+.section ".head.text"
 	.code32
 	.globl startup_32
 
diff -urpN linux-2.6.org/arch/x86/boot/compressed/vmlinux_32.lds linux-2.6.gc1/arch/x86/boot/compressed/vmlinux_32.lds
--- linux-2.6.org/arch/x86/boot/compressed/vmlinux_32.lds	2007-11-23 18:55:10.000000000 -0800
+++ linux-2.6.gc1/arch/x86/boot/compressed/vmlinux_32.lds	2007-11-23 20:55:58.000000000 -0800
@@ -7,13 +7,13 @@ SECTIONS
          * address 0.
 	 */
 	. =  0 	;
-	.text.head : {
+	.head.text : {
 		_head = . ;
-		*(.text.head)
+		*(.head.text)
 		_ehead = . ;
 	}
-	.data.compressed : {
-		*(.data.compressed)
+	.compressed.data : {
+		*(.compressed.data)
 	}
 	.text :	{
 		_text = .; 	/* Text */
diff -urpN linux-2.6.org/arch/x86/boot/compressed/vmlinux_32.scr linux-2.6.gc1/arch/x86/boot/compressed/vmlinux_32.scr
--- linux-2.6.org/arch/x86/boot/compressed/vmlinux_32.scr	2007-11-23 18:55:10.000000000 -0800
+++ linux-2.6.gc1/arch/x86/boot/compressed/vmlinux_32.scr	2007-11-23 20:55:58.000000000 -0800
@@ -1,6 +1,6 @@
 SECTIONS
 {
-  .data.compressed : {
+  .compressed.data : {
 	input_len = .;
 	LONG(input_data_end - input_data) input_data = .; 
 	*(.data) 
diff -urpN linux-2.6.org/arch/x86/boot/compressed/vmlinux_64.lds linux-2.6.gc1/arch/x86/boot/compressed/vmlinux_64.lds
--- linux-2.6.org/arch/x86/boot/compressed/vmlinux_64.lds	2007-11-23 18:55:10.000000000 -0800
+++ linux-2.6.gc1/arch/x86/boot/compressed/vmlinux_64.lds	2007-11-23 20:55:50.000000000 -0800
@@ -9,9 +9,9 @@ SECTIONS
 	. = 0;
 	.text :	{
 		_head = . ;
-		*(.text.head)
+		*(.head.text)
 		_ehead = . ;
-		*(.text.compressed)
+		*(.compressed.text)
 		_text = .; 	/* Text */
 		*(.text)
 		*(.text.*)
diff -urpN linux-2.6.org/arch/x86/boot/compressed/vmlinux_64.scr linux-2.6.gc1/arch/x86/boot/compressed/vmlinux_64.scr
--- linux-2.6.org/arch/x86/boot/compressed/vmlinux_64.scr	2007-11-23 18:55:10.000000000 -0800
+++ linux-2.6.gc1/arch/x86/boot/compressed/vmlinux_64.scr	2007-11-23 20:55:50.000000000 -0800
@@ -1,6 +1,6 @@
 SECTIONS
 {
-  .text.compressed : {
+  .compressed.text : {
 	input_len = .;
 	LONG(input_data_end - input_data) input_data = .;
 	*(.data)
diff -urpN linux-2.6.org/arch/x86/ia32/vsyscall-sigreturn.S linux-2.6.gc1/arch/x86/ia32/vsyscall-sigreturn.S
--- linux-2.6.org/arch/x86/ia32/vsyscall-sigreturn.S	2007-11-23 18:55:10.000000000 -0800
+++ linux-2.6.gc1/arch/x86/ia32/vsyscall-sigreturn.S	2007-11-23 20:55:49.000000000 -0800
@@ -8,7 +8,7 @@
  */
 
 	.code32
-	.section .text.sigreturn,"ax"
+	.section .sigreturn.text,"ax"
 	.balign 32
 	.globl __kernel_sigreturn
 	.type __kernel_sigreturn,@function
@@ -20,7 +20,7 @@ __kernel_sigreturn:
 .LEND_sigreturn:
 	.size __kernel_sigreturn,.-.LSTART_sigreturn
 
-	.section .text.rtsigreturn,"ax"
+	.section .rtsigreturn.text,"ax"
 	.balign 32
 	.globl __kernel_rt_sigreturn
 	.type __kernel_rt_sigreturn,@function
diff -urpN linux-2.6.org/arch/x86/ia32/vsyscall-syscall.S linux-2.6.gc1/arch/x86/ia32/vsyscall-syscall.S
--- linux-2.6.org/arch/x86/ia32/vsyscall-syscall.S	2007-11-23 18:55:10.000000000 -0800
+++ linux-2.6.gc1/arch/x86/ia32/vsyscall-syscall.S	2007-11-23 20:55:50.000000000 -0800
@@ -8,7 +8,7 @@
 
 	.code32
 	.text
-	.section .text.vsyscall,"ax"
+	.section .vsyscall.text,"ax"
 	.globl __kernel_vsyscall
 	.type __kernel_vsyscall,@function
 __kernel_vsyscall:
diff -urpN linux-2.6.org/arch/x86/ia32/vsyscall-sysenter.S linux-2.6.gc1/arch/x86/ia32/vsyscall-sysenter.S
--- linux-2.6.org/arch/x86/ia32/vsyscall-sysenter.S	2007-11-23 18:55:10.000000000 -0800
+++ linux-2.6.gc1/arch/x86/ia32/vsyscall-sysenter.S	2007-11-23 20:55:50.000000000 -0800
@@ -7,7 +7,7 @@
 
 	.code32
 	.text
-	.section .text.vsyscall,"ax"
+	.section .vsyscall.text,"ax"
 	.globl __kernel_vsyscall
 	.type __kernel_vsyscall,@function
 __kernel_vsyscall:
diff -urpN linux-2.6.org/arch/x86/ia32/vsyscall.lds linux-2.6.gc1/arch/x86/ia32/vsyscall.lds
--- linux-2.6.org/arch/x86/ia32/vsyscall.lds	2007-11-23 18:55:10.000000000 -0800
+++ linux-2.6.gc1/arch/x86/ia32/vsyscall.lds	2007-11-23 20:55:50.000000000 -0800
@@ -24,18 +24,18 @@ SECTIONS
      is insufficient, ld -shared will barf.  Just increase it here.  */
   . = VSYSCALL_BASE + 0x400;
   
-  .text.vsyscall   : { *(.text.vsyscall) } 	:text =0x90909090
+  .vsyscall.text   : { *(.vsyscall.text) } 	:text =0x90909090
 
   /* This is an 32bit object and we cannot easily get the offsets
      into the 64bit kernel. Just hardcode them here. This assumes
      that all the stubs don't need more than 0x100 bytes. */
   . = VSYSCALL_BASE + 0x500;
 
-  .text.sigreturn  : { *(.text.sigreturn) }	:text =0x90909090
+  .sigreturn.text  : { *(.sigreturn.text) }	:text =0x90909090
 
   . = VSYSCALL_BASE + 0x600;
 
-  .text.rtsigreturn : { *(.text.rtsigreturn) }   :text =0x90909090
+  .rtsigreturn.text : { *(.rtsigreturn.text) }   :text =0x90909090
 	
   .note		  : { *(.note.*) }		:text :note
   .eh_frame_hdr   : { *(.eh_frame_hdr) }	:text :eh_frame_hdr
diff -urpN linux-2.6.org/arch/x86/kernel/head_32.S linux-2.6.gc1/arch/x86/kernel/head_32.S
--- linux-2.6.org/arch/x86/kernel/head_32.S	2007-11-23 18:55:10.000000000 -0800
+++ linux-2.6.gc1/arch/x86/kernel/head_32.S	2007-11-23 20:56:00.000000000 -0800
@@ -77,7 +77,7 @@ INIT_MAP_BEYOND_END = BOOTBITMAP_SIZE + 
  * any particular GDT layout, because we load our own as soon as we
  * can.
  */
-.section .text.head,"ax",@progbits
+.section .head.text,"ax",@progbits
 ENTRY(startup_32)
 	/* check to see if KEEP_SEGMENTS flag is meaningful */
 	cmpw $0x207, BP_version(%esi)
@@ -551,7 +551,7 @@ ENTRY(_stext)
 /*
  * BSS section
  */
-.section ".bss.page_aligned","wa"
+.section ".bss.k.page_aligned","wa"
 	.align PAGE_SIZE_asm
 ENTRY(swapper_pg_dir)
 	.fill 1024,4,0
diff -urpN linux-2.6.org/arch/x86/kernel/head_64.S linux-2.6.gc1/arch/x86/kernel/head_64.S
--- linux-2.6.org/arch/x86/kernel/head_64.S	2007-11-23 18:55:10.000000000 -0800
+++ linux-2.6.gc1/arch/x86/kernel/head_64.S	2007-11-23 20:56:00.000000000 -0800
@@ -25,7 +25,7 @@
  */
 
 	.text
-	.section .text.head
+	.section .head.text
 	.code64
 	.globl startup_64
 startup_64:
@@ -378,7 +378,7 @@ ENTRY(phys_base)
  * Also sysret mandates a special GDT layout 
  */
 		 		
-	.section .data.page_aligned, "aw"
+	.section .page_aligned.data, "aw"
 	.align PAGE_SIZE
 
 /* The TLS descriptors are currently at a different place compared to i386.
@@ -410,7 +410,7 @@ gdt_end:	
 ENTRY(idt_table)
 	.skip 256 * 16
 
-	.section .bss.page_aligned, "aw", @nobits
+	.section .bss.k.page_aligned, "aw", @nobits
 	.align PAGE_SIZE
 ENTRY(empty_zero_page)
 	.skip PAGE_SIZE
diff -urpN linux-2.6.org/arch/x86/kernel/init_task.c linux-2.6.gc1/arch/x86/kernel/init_task.c
--- linux-2.6.org/arch/x86/kernel/init_task.c	2007-11-23 18:55:10.000000000 -0800
+++ linux-2.6.gc1/arch/x86/kernel/init_task.c	2007-11-23 20:55:54.000000000 -0800
@@ -25,7 +25,7 @@ EXPORT_SYMBOL(init_mm);
  * "init_task" linker map entry..
  */
 union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
+	__attribute__((__section__(".init_task.data"))) =
 		{ INIT_THREAD_INFO(init_task) };
 
 /*
@@ -39,7 +39,7 @@ EXPORT_SYMBOL(init_task);
 /*
  * per-CPU TSS segments. Threads are completely 'soft' on Linux,
  * no more per-task TSS's. The TSS size is kept cacheline-aligned
- * so they are allowed to end up in the .data.cacheline_aligned
+ * so they are allowed to end up in the .cacheline_aligned.data
  * section. Since TSS's are completely CPU-local, we want them
  * on exact cacheline boundaries, to eliminate cacheline ping-pong.
  */
diff -urpN linux-2.6.org/arch/x86/kernel/irq_32.c linux-2.6.gc1/arch/x86/kernel/irq_32.c
--- linux-2.6.org/arch/x86/kernel/irq_32.c	2007-11-23 18:55:10.000000000 -0800
+++ linux-2.6.gc1/arch/x86/kernel/irq_32.c	2007-11-23 20:56:00.000000000 -0800
@@ -148,10 +148,10 @@ fastcall unsigned int do_IRQ(struct pt_r
 #ifdef CONFIG_4KSTACKS
 
 static char softirq_stack[NR_CPUS * THREAD_SIZE]
-		__attribute__((__section__(".bss.page_aligned")));
+		__attribute__((__section__(".bss.k.page_aligned")));
 
 static char hardirq_stack[NR_CPUS * THREAD_SIZE]
-		__attribute__((__section__(".bss.page_aligned")));
+		__attribute__((__section__(".bss.k.page_aligned")));
 
 /*
  * allocate per-cpu stacks for hardirq and for softirq processing
diff -urpN linux-2.6.org/arch/x86/kernel/setup64.c linux-2.6.gc1/arch/x86/kernel/setup64.c
--- linux-2.6.org/arch/x86/kernel/setup64.c	2007-11-23 18:55:10.000000000 -0800
+++ linux-2.6.gc1/arch/x86/kernel/setup64.c	2007-11-23 20:56:00.000000000 -0800
@@ -34,7 +34,7 @@ struct x8664_pda boot_cpu_pda[NR_CPUS] _
 
 struct desc_ptr idt_descr = { 256 * 16 - 1, (unsigned long) idt_table };
 
-char boot_cpu_stack[IRQSTACKSIZE] __attribute__((section(".bss.page_aligned")));
+char boot_cpu_stack[IRQSTACKSIZE] __attribute__((section(".bss.k.page_aligned")));
 
 unsigned long __supported_pte_mask __read_mostly = ~0UL;
 static int do_not_nx __cpuinitdata = 0;
@@ -148,7 +148,7 @@ void pda_init(int cpu)
 } 
 
 char boot_exception_stacks[(N_EXCEPTION_STACKS - 1) * EXCEPTION_STKSZ + DEBUG_STKSZ]
-__attribute__((section(".bss.page_aligned")));
+__attribute__((section(".bss.k.page_aligned")));
 
 extern asmlinkage void ignore_sysret(void);
 
diff -urpN linux-2.6.org/arch/x86/kernel/traps_32.c linux-2.6.gc1/arch/x86/kernel/traps_32.c
--- linux-2.6.org/arch/x86/kernel/traps_32.c	2007-11-23 18:55:10.000000000 -0800
+++ linux-2.6.gc1/arch/x86/kernel/traps_32.c	2007-11-23 20:55:57.000000000 -0800
@@ -76,7 +76,7 @@ char ignore_fpu_irq = 0;
  * F0 0F bug workaround.. We have a special link segment
  * for this.
  */
-struct desc_struct idt_table[256] __attribute__((__section__(".data.idt"))) = { {0, 0}, };
+struct desc_struct idt_table[256] __attribute__((__section__(".idt.data"))) = { {0, 0}, };
 
 asmlinkage void divide_error(void);
 asmlinkage void debug(void);
diff -urpN linux-2.6.org/arch/x86/kernel/vmlinux_32.lds.S linux-2.6.gc1/arch/x86/kernel/vmlinux_32.lds.S
--- linux-2.6.org/arch/x86/kernel/vmlinux_32.lds.S	2007-11-23 18:55:10.000000000 -0800
+++ linux-2.6.gc1/arch/x86/kernel/vmlinux_32.lds.S	2007-11-23 21:59:58.000000000 -0800
@@ -37,9 +37,9 @@ SECTIONS
   . = LOAD_OFFSET + LOAD_PHYSICAL_ADDR;
   phys_startup_32 = startup_32 - LOAD_OFFSET;
 
-  .text.head : AT(ADDR(.text.head) - LOAD_OFFSET) {
+  .head.text : AT(ADDR(.head.text) - LOAD_OFFSET) {
   	_text = .;			/* Text and read-only data */
-	*(.text.head)
+	*(.head.text)
   } :text = 0x9090
 
   /* read-only */
@@ -83,32 +83,32 @@ SECTIONS
   . = ALIGN(4096);
   .data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
   	__nosave_begin = .;
-	*(.data.nosave)
+	*(.nosave.data)
   	. = ALIGN(4096);
   	__nosave_end = .;
   }
 
   . = ALIGN(4096);
-  .data.page_aligned : AT(ADDR(.data.page_aligned) - LOAD_OFFSET) {
-	*(.data.page_aligned)
-	*(.data.idt)
+  .page_aligned.data : AT(ADDR(.page_aligned.data) - LOAD_OFFSET) {
+	*(.page_aligned.data)
+	*(.idt.data)
   }
 
   . = ALIGN(32);
-  .data.cacheline_aligned : AT(ADDR(.data.cacheline_aligned) - LOAD_OFFSET) {
-	*(.data.cacheline_aligned)
+  .cacheline_aligned.data : AT(ADDR(.cacheline_aligned.data) - LOAD_OFFSET) {
+	*(.cacheline_aligned.data)
   }
 
   /* rarely changed data like cpu maps */
   . = ALIGN(32);
-  .data.read_mostly : AT(ADDR(.data.read_mostly) - LOAD_OFFSET) {
-	*(.data.read_mostly)
+  .read_mostly.data : AT(ADDR(.read_mostly.data) - LOAD_OFFSET) {
+	*(.read_mostly.data)
 	_edata = .;		/* End of data section */
   }
 
   . = ALIGN(THREAD_SIZE);	/* init_task */
-  .data.init_task : AT(ADDR(.data.init_task) - LOAD_OFFSET) {
-	*(.data.init_task)
+  .init_task.data : AT(ADDR(.init_task.data) - LOAD_OFFSET) {
+	*(.init_task.data)
   }
 
   /* might get freed after init */
@@ -180,10 +180,10 @@ SECTIONS
   }
 #endif
   . = ALIGN(4096);
-  .data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {
+  .percpu.data  : AT(ADDR(.percpu.data) - LOAD_OFFSET) {
 	__per_cpu_start = .;
-	*(.data.percpu)
-	*(.data.percpu.shared_aligned)
+	*(.percpu.data)
+	*(.percpu.shared_aligned.data)
 	__per_cpu_end = .;
   }
   . = ALIGN(4096);
@@ -192,7 +192,7 @@ SECTIONS
   .bss : AT(ADDR(.bss) - LOAD_OFFSET) {
 	__init_end = .;
 	__bss_start = .;		/* BSS */
-	*(.bss.page_aligned)
+	*(.bss.k.page_aligned)
 	*(.bss)
 	. = ALIGN(4);
 	__bss_stop = .;
diff -urpN linux-2.6.org/arch/x86/kernel/vmlinux_64.lds.S linux-2.6.gc1/arch/x86/kernel/vmlinux_64.lds.S
--- linux-2.6.org/arch/x86/kernel/vmlinux_64.lds.S	2007-11-23 18:55:10.000000000 -0800
+++ linux-2.6.gc1/arch/x86/kernel/vmlinux_64.lds.S	2007-11-23 21:59:58.000000000 -0800
@@ -28,7 +28,7 @@ SECTIONS
   _text = .;			/* Text and read-only data */
   .text :  AT(ADDR(.text) - LOAD_OFFSET) {
 	/* First the code that has to be first for bootstrapping */
-	*(.text.head)
+	*(.head.text)
 	_stext = .;
 	/* Then the rest */
 	TEXT_TEXT
@@ -39,7 +39,7 @@ SECTIONS
 	*(.gnu.warning)
 	} :text = 0x9090
   				/* out-of-line lock text */
-  .text.lock : AT(ADDR(.text.lock) - LOAD_OFFSET) { *(.text.lock) }
+  .lock.text : AT(ADDR(.lock.text) - LOAD_OFFSET) { *(.lock.text) }
 
   _etext = .;			/* End of text section */
 
@@ -72,17 +72,17 @@ SECTIONS
 
   . = ALIGN(PAGE_SIZE);
   . = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
-  .data.cacheline_aligned : AT(ADDR(.data.cacheline_aligned) - LOAD_OFFSET) {
-	*(.data.cacheline_aligned)
+  .cacheline_aligned.data : AT(ADDR(.cacheline_aligned.data) - LOAD_OFFSET) {
+	*(.cacheline_aligned.data)
   }
   . = ALIGN(CONFIG_X86_INTERNODE_CACHE_BYTES);
-  .data.read_mostly : AT(ADDR(.data.read_mostly) - LOAD_OFFSET) {
-  	*(.data.read_mostly)
+  .read_mostly.data : AT(ADDR(.read_mostly.data) - LOAD_OFFSET) {
+  	*(.read_mostly.data)
   }
 
 #define VSYSCALL_ADDR (-10*1024*1024)
-#define VSYSCALL_PHYS_ADDR ((LOADADDR(.data.read_mostly) + SIZEOF(.data.read_mostly) + 4095) & ~(4095))
-#define VSYSCALL_VIRT_ADDR ((ADDR(.data.read_mostly) + SIZEOF(.data.read_mostly) + 4095) & ~(4095))
+#define VSYSCALL_PHYS_ADDR ((LOADADDR(.read_mostly.data) + SIZEOF(.read_mostly.data) + 4095) & ~(4095))
+#define VSYSCALL_VIRT_ADDR ((ADDR(.read_mostly.data) + SIZEOF(.read_mostly.data) + 4095) & ~(4095))
 
 #define VLOAD_OFFSET (VSYSCALL_ADDR - VSYSCALL_PHYS_ADDR)
 #define VLOAD(x) (ADDR(x) - VLOAD_OFFSET)
@@ -131,13 +131,13 @@ SECTIONS
 #undef VVIRT
 
   . = ALIGN(8192);		/* init_task */
-  .data.init_task : AT(ADDR(.data.init_task) - LOAD_OFFSET) {
-	*(.data.init_task)
+  .init_task.data : AT(ADDR(.init_task.data) - LOAD_OFFSET) {
+	*(.init_task.data)
   }:data.init
 
   . = ALIGN(4096);
-  .data.page_aligned : AT(ADDR(.data.page_aligned) - LOAD_OFFSET) {
-	*(.data.page_aligned)
+  .page_aligned.data : AT(ADDR(.page_aligned.data) - LOAD_OFFSET) {
+	*(.page_aligned.data)
   }
 
   /* might get freed after init */
@@ -210,13 +210,13 @@ SECTIONS
 
   . = ALIGN(4096);
   __nosave_begin = .;
-  .data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) { *(.data.nosave) }
+  .data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) { *(.nosave.data) }
   . = ALIGN(4096);
   __nosave_end = .;
 
   __bss_start = .;		/* BSS */
   .bss : AT(ADDR(.bss) - LOAD_OFFSET) {
-	*(.bss.page_aligned)
+	*(.bss.k.page_aligned)
 	*(.bss)
 	}
   __bss_stop = .;
diff -urpN linux-2.6.org/arch/x86/xen/xen-head.S linux-2.6.gc1/arch/x86/xen/xen-head.S
--- linux-2.6.org/arch/x86/xen/xen-head.S	2007-11-23 18:55:10.000000000 -0800
+++ linux-2.6.gc1/arch/x86/xen/xen-head.S	2007-11-23 20:56:00.000000000 -0800
@@ -15,7 +15,7 @@ ENTRY(startup_xen)
 	jmp xen_start_kernel
 .popsection
 
-.pushsection .bss.page_aligned
+.pushsection .bss.k.page_aligned
 	.align PAGE_SIZE_asm
 ENTRY(hypercall_page)
 	.skip 0x1000
diff -urpN linux-2.6.org/arch/xtensa/kernel/head.S linux-2.6.gc1/arch/xtensa/kernel/head.S
--- linux-2.6.org/arch/xtensa/kernel/head.S	2007-11-23 18:55:10.000000000 -0800
+++ linux-2.6.gc1/arch/xtensa/kernel/head.S	2007-11-23 20:56:00.000000000 -0800
@@ -234,7 +234,7 @@ should_never_return:
  * BSS section
  */
 	
-.section ".bss.page_aligned", "w"
+.section ".bss.k.page_aligned", "w"
 ENTRY(swapper_pg_dir)
 	.fill	PAGE_SIZE, 1, 0
 ENTRY(empty_zero_page)
diff -urpN linux-2.6.org/arch/xtensa/kernel/init_task.c linux-2.6.gc1/arch/xtensa/kernel/init_task.c
--- linux-2.6.org/arch/xtensa/kernel/init_task.c	2007-11-23 18:55:10.000000000 -0800
+++ linux-2.6.gc1/arch/xtensa/kernel/init_task.c	2007-11-23 20:55:54.000000000 -0800
@@ -30,7 +30,7 @@ struct mm_struct init_mm = INIT_MM(init_
 EXPORT_SYMBOL(init_mm);
 
 union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
+	__attribute__((__section__(".init_task.data"))) =
 { INIT_THREAD_INFO(init_task) };
 
 struct task_struct init_task = INIT_TASK(init_task);
diff -urpN linux-2.6.org/arch/xtensa/kernel/vmlinux.lds.S linux-2.6.gc1/arch/xtensa/kernel/vmlinux.lds.S
--- linux-2.6.org/arch/xtensa/kernel/vmlinux.lds.S	2007-11-23 18:55:10.000000000 -0800
+++ linux-2.6.gc1/arch/xtensa/kernel/vmlinux.lds.S	2007-11-23 21:59:58.000000000 -0800
@@ -121,14 +121,14 @@ SECTIONS
     DATA_DATA
     CONSTRUCTORS
     . = ALIGN(XCHAL_ICACHE_LINESIZE);
-    *(.data.cacheline_aligned)
+    *(.cacheline_aligned.data)
   }
 
   _edata = .;
 
   /* The initial task */
   . = ALIGN(8192);
-  .data.init_task : { *(.data.init_task) }
+  .init_task.data : { *(.init_task.data) }
 
   /* Initialization code and data: */
 
@@ -255,7 +255,7 @@ SECTIONS
 
   /* BSS section */
   _bss_start = .;
-  .bss : { *(.bss.page_aligned) *(.bss) }
+  .bss : { *(.bss.k.page_aligned) *(.bss) }
   _bss_end = .;
 
   _end = .;
diff -urpN linux-2.6.org/include/asm-frv/init.h linux-2.6.gc1/include/asm-frv/init.h
--- linux-2.6.org/include/asm-frv/init.h	2007-11-23 18:55:25.000000000 -0800
+++ linux-2.6.gc1/include/asm-frv/init.h	2007-11-23 20:55:54.000000000 -0800
@@ -1,12 +1,12 @@
 #ifndef _ASM_INIT_H
 #define _ASM_INIT_H
 
-#define __init __attribute__ ((__section__ (".text.init")))
-#define __initdata __attribute__ ((__section__ (".data.init")))
+#define __init __attribute__ ((__section__ (".init.text")))
+#define __initdata __attribute__ ((__section__ (".init.data")))
 /* For assembly routines */
-#define __INIT		.section	".text.init",#alloc,#execinstr
+#define __INIT		.section	".init.text",#alloc,#execinstr
 #define __FINIT		.previous
-#define __INITDATA	.section	".data.init",#alloc,#write
+#define __INITDATA	.section	".init.data",#alloc,#write
 
 #endif
 
diff -urpN linux-2.6.org/include/asm-generic/percpu.h linux-2.6.gc1/include/asm-generic/percpu.h
--- linux-2.6.org/include/asm-generic/percpu.h	2007-11-23 18:55:25.000000000 -0800
+++ linux-2.6.gc1/include/asm-generic/percpu.h	2007-11-23 20:55:52.000000000 -0800
@@ -12,10 +12,10 @@ extern unsigned long __per_cpu_offset[NR
 
 /* Separate out the type, so (int[3], foo) works. */
 #define DEFINE_PER_CPU(type, name) \
-    __attribute__((__section__(".data.percpu"))) __typeof__(type) per_cpu__##name
+    __attribute__((__section__(".percpu.data"))) __typeof__(type) per_cpu__##name
 
 #define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		\
-    __attribute__((__section__(".data.percpu.shared_aligned"))) \
+    __attribute__((__section__(".percpu.shared_aligned.data"))) \
     __typeof__(type) per_cpu__##name				\
     ____cacheline_aligned_in_smp
 
diff -urpN linux-2.6.org/include/asm-generic/vmlinux.lds.h linux-2.6.gc1/include/asm-generic/vmlinux.lds.h
--- linux-2.6.org/include/asm-generic/vmlinux.lds.h	2007-11-23 18:55:25.000000000 -0800
+++ linux-2.6.gc1/include/asm-generic/vmlinux.lds.h	2007-11-23 20:55:54.000000000 -0800
@@ -12,7 +12,7 @@
 /* .data section */
 #define DATA_DATA							\
 	*(.data)							\
-	*(.data.init.refok)						\
+	*(.init.refok.data)						\
 	. = ALIGN(8);							\
 	VMLINUX_SYMBOL(__start___markers) = .;				\
 	*(__markers)							\
@@ -158,7 +158,7 @@
 #define TEXT_TEXT							\
 		ALIGN_FUNCTION();					\
 		*(.text)						\
-		*(.text.init.refok)					\
+		*(.init.refok.text)					\
 		*(.exit.text.refok)
 
 /* sched.text is aling to function alignment to secure we have same
@@ -258,8 +258,8 @@
 #define PERCPU(align)							\
 	. = ALIGN(align);						\
 	__per_cpu_start = .;						\
-	.data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {		\
-		*(.data.percpu)						\
-		*(.data.percpu.shared_aligned)				\
+	.percpu.data  : AT(ADDR(.percpu.data) - LOAD_OFFSET) {		\
+		*(.percpu.data)						\
+		*(.percpu.shared_aligned.data)				\
 	}								\
 	__per_cpu_end = .;
diff -urpN linux-2.6.org/include/asm-ia64/asmmacro.h linux-2.6.gc1/include/asm-ia64/asmmacro.h
--- linux-2.6.org/include/asm-ia64/asmmacro.h	2007-11-23 18:55:25.000000000 -0800
+++ linux-2.6.gc1/include/asm-ia64/asmmacro.h	2007-11-23 20:55:56.000000000 -0800
@@ -70,12 +70,12 @@ name:
  * path (ivt.S - TLB miss processing) or in places where it might not be
  * safe to use a "tpa" instruction (mca_asm.S - error recovery).
  */
-	.section ".data.patch.vtop", "a"	// declare section & section attributes
+	.section ".patch.vtop.data", "a"	// declare section & section attributes
 	.previous
 
 #define	LOAD_PHYSICAL(pr, reg, obj)		\
 [1:](pr)movl reg = obj;				\
-	.xdata4 ".data.patch.vtop", 1b-.
+	.xdata4 ".patch.vtop.data", 1b-.
 
 /*
  * For now, we always put in the McKinley E9 workaround.  On CPUs that don't need it,
@@ -84,11 +84,11 @@ name:
 #define DO_MCKINLEY_E9_WORKAROUND
 
 #ifdef DO_MCKINLEY_E9_WORKAROUND
-	.section ".data.patch.mckinley_e9", "a"
+	.section ".patch.mckinley_e9.data", "a"
 	.previous
 /* workaround for Itanium 2 Errata 9: */
 # define FSYS_RETURN					\
-	.xdata4 ".data.patch.mckinley_e9", 1f-.;	\
+	.xdata4 ".patch.mckinley_e9.data", 1f-.;	\
 1:{ .mib;						\
 	nop.m 0;					\
 	mov r16=ar.pfs;					\
@@ -107,11 +107,11 @@ name:
  * If physical stack register size is different from DEF_NUM_STACK_REG,
  * dynamically patch the kernel for correct size.
  */
-	.section ".data.patch.phys_stack_reg", "a"
+	.section ".patch.phys_stack_reg.data", "a"
 	.previous
 #define LOAD_PHYS_STACK_REG_SIZE(reg)			\
 [1:]	adds reg=IA64_NUM_PHYS_STACK_REG*8+8,r0;	\
-	.xdata4 ".data.patch.phys_stack_reg", 1b-.
+	.xdata4 ".patch.phys_stack_reg.data", 1b-.
 
 /*
  * Up until early 2004, use of .align within a function caused bad unwind info.
diff -urpN linux-2.6.org/include/asm-ia64/cache.h linux-2.6.gc1/include/asm-ia64/cache.h
--- linux-2.6.org/include/asm-ia64/cache.h	2007-11-23 18:55:25.000000000 -0800
+++ linux-2.6.gc1/include/asm-ia64/cache.h	2007-11-23 20:55:53.000000000 -0800
@@ -24,6 +24,6 @@
 # define SMP_CACHE_BYTES	(1 << 3)
 #endif
 
-#define __read_mostly __attribute__((__section__(".data.read_mostly")))
+#define __read_mostly __attribute__((__section__(".read_mostly.data")))
 
 #endif /* _ASM_IA64_CACHE_H */
diff -urpN linux-2.6.org/include/asm-ia64/percpu.h linux-2.6.gc1/include/asm-ia64/percpu.h
--- linux-2.6.org/include/asm-ia64/percpu.h	2007-11-23 18:55:25.000000000 -0800
+++ linux-2.6.gc1/include/asm-ia64/percpu.h	2007-11-23 20:55:52.000000000 -0800
@@ -26,12 +26,12 @@
 
 /* Separate out the type, so (int[3], foo) works. */
 #define DEFINE_PER_CPU(type, name)				\
-	__attribute__((__section__(".data.percpu")))		\
+	__attribute__((__section__(".percpu.data")))		\
 	__SMALL_ADDR_AREA __typeof__(type) per_cpu__##name
 
 #ifdef CONFIG_SMP
 #define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)			\
-	__attribute__((__section__(".data.percpu.shared_aligned")))	\
+	__attribute__((__section__(".percpu.shared_aligned.data")))	\
 	__SMALL_ADDR_AREA __typeof__(type) per_cpu__##name		\
 	____cacheline_aligned_in_smp
 #else
diff -urpN linux-2.6.org/include/asm-m68knommu/semaphore.h linux-2.6.gc1/include/asm-m68knommu/semaphore.h
--- linux-2.6.org/include/asm-m68knommu/semaphore.h	2007-11-23 18:55:25.000000000 -0800
+++ linux-2.6.gc1/include/asm-m68knommu/semaphore.h	2007-11-23 20:55:46.000000000 -0800
@@ -117,7 +117,7 @@ static inline int down_trylock(struct se
 		"jmi 2f\n\t"
 		"clrl %0\n"
 		"1:\n"
-		".section .text.lock,\"ax\"\n"
+		".section .lock.text,\"ax\"\n"
 		".even\n"
 		"2:\tpea 1b\n\t"
 		"jbra __down_failed_trylock\n"
diff -urpN linux-2.6.org/include/asm-parisc/cache.h linux-2.6.gc1/include/asm-parisc/cache.h
--- linux-2.6.org/include/asm-parisc/cache.h	2007-11-23 18:55:25.000000000 -0800
+++ linux-2.6.gc1/include/asm-parisc/cache.h	2007-11-23 20:55:53.000000000 -0800
@@ -28,7 +28,7 @@
 
 #define SMP_CACHE_BYTES L1_CACHE_BYTES
 
-#define __read_mostly __attribute__((__section__(".data.read_mostly")))
+#define __read_mostly __attribute__((__section__(".read_mostly.data")))
 
 void parisc_cache_init(void);	/* initializes cache-flushing */
 void disable_sr_hashing_asm(int); /* low level support for above */
diff -urpN linux-2.6.org/include/asm-parisc/system.h linux-2.6.gc1/include/asm-parisc/system.h
--- linux-2.6.org/include/asm-parisc/system.h	2007-11-23 18:55:25.000000000 -0800
+++ linux-2.6.gc1/include/asm-parisc/system.h	2007-11-23 20:55:55.000000000 -0800
@@ -174,7 +174,7 @@ static inline void set_eiem(unsigned lon
 })
 
 #ifdef CONFIG_SMP
-# define __lock_aligned __attribute__((__section__(".data.lock_aligned")))
+# define __lock_aligned __attribute__((__section__(".lock_aligned.data")))
 #endif
 
 #define arch_align_stack(x) (x)
diff -urpN linux-2.6.org/include/asm-powerpc/cache.h linux-2.6.gc1/include/asm-powerpc/cache.h
--- linux-2.6.org/include/asm-powerpc/cache.h	2007-11-23 18:55:25.000000000 -0800
+++ linux-2.6.gc1/include/asm-powerpc/cache.h	2007-11-23 20:55:53.000000000 -0800
@@ -35,7 +35,7 @@ extern struct ppc64_caches ppc64_caches;
 #endif /* __powerpc64__ && ! __ASSEMBLY__ */
 
 #if !defined(__ASSEMBLY__)
-#define __read_mostly __attribute__((__section__(".data.read_mostly")))
+#define __read_mostly __attribute__((__section__(".read_mostly.data")))
 #endif
 
 #endif /* __KERNEL__ */
diff -urpN linux-2.6.org/include/asm-powerpc/page_64.h linux-2.6.gc1/include/asm-powerpc/page_64.h
--- linux-2.6.org/include/asm-powerpc/page_64.h	2007-11-23 18:55:25.000000000 -0800
+++ linux-2.6.gc1/include/asm-powerpc/page_64.h	2007-11-23 20:55:55.000000000 -0800
@@ -158,7 +158,7 @@ do {						\
 #else
 #define __page_aligned \
 	__attribute__((__aligned__(PAGE_SIZE), \
-		__section__(".data.page_aligned")))
+		__section__(".page_aligned.data")))
 #endif
 
 #define VM_DATA_DEFAULT_FLAGS \
diff -urpN linux-2.6.org/include/asm-powerpc/percpu.h linux-2.6.gc1/include/asm-powerpc/percpu.h
--- linux-2.6.org/include/asm-powerpc/percpu.h	2007-11-23 18:55:25.000000000 -0800
+++ linux-2.6.gc1/include/asm-powerpc/percpu.h	2007-11-23 20:55:52.000000000 -0800
@@ -18,10 +18,10 @@
 
 /* Separate out the type, so (int[3], foo) works. */
 #define DEFINE_PER_CPU(type, name) \
-    __attribute__((__section__(".data.percpu"))) __typeof__(type) per_cpu__##name
+    __attribute__((__section__(".percpu.data"))) __typeof__(type) per_cpu__##name
 
 #define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		\
-    __attribute__((__section__(".data.percpu.shared_aligned"))) \
+    __attribute__((__section__(".percpu.shared_aligned.data"))) \
     __typeof__(type) per_cpu__##name				\
     ____cacheline_aligned_in_smp
 
diff -urpN linux-2.6.org/include/asm-powerpc/ppc_asm.h linux-2.6.gc1/include/asm-powerpc/ppc_asm.h
--- linux-2.6.org/include/asm-powerpc/ppc_asm.h	2007-11-23 18:55:25.000000000 -0800
+++ linux-2.6.gc1/include/asm-powerpc/ppc_asm.h	2007-11-23 20:55:45.000000000 -0800
@@ -156,7 +156,7 @@ name: \
 GLUE(.,name):
 
 #define _INIT_GLOBAL(name) \
-	.section ".text.init.refok"; \
+	.section ".init.refok.text"; \
 	.align 2 ; \
 	.globl name; \
 	.globl GLUE(.,name); \
@@ -196,7 +196,7 @@ name: \
 GLUE(.,name):
 
 #define _INIT_STATIC(name) \
-	.section ".text.init.refok"; \
+	.section ".init.refok.text"; \
 	.align 2 ; \
 	.section ".opd","aw"; \
 name: \
diff -urpN linux-2.6.org/include/asm-s390/cache.h linux-2.6.gc1/include/asm-s390/cache.h
--- linux-2.6.org/include/asm-s390/cache.h	2007-11-23 18:55:25.000000000 -0800
+++ linux-2.6.gc1/include/asm-s390/cache.h	2007-11-23 20:55:53.000000000 -0800
@@ -14,6 +14,6 @@
 #define L1_CACHE_BYTES     256
 #define L1_CACHE_SHIFT     8
 
-#define __read_mostly __attribute__((__section__(".data.read_mostly")))
+#define __read_mostly __attribute__((__section__(".read_mostly.data")))
 
 #endif
diff -urpN linux-2.6.org/include/asm-s390/percpu.h linux-2.6.gc1/include/asm-s390/percpu.h
--- linux-2.6.org/include/asm-s390/percpu.h	2007-11-23 18:55:25.000000000 -0800
+++ linux-2.6.gc1/include/asm-s390/percpu.h	2007-11-23 20:55:52.000000000 -0800
@@ -38,11 +38,11 @@ extern unsigned long __per_cpu_offset[NR
 
 /* Separate out the type, so (int[3], foo) works. */
 #define DEFINE_PER_CPU(type, name) \
-    __attribute__((__section__(".data.percpu"))) \
+    __attribute__((__section__(".percpu.data"))) \
     __typeof__(type) per_cpu__##name
 
 #define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		\
-    __attribute__((__section__(".data.percpu.shared_aligned"))) \
+    __attribute__((__section__(".percpu.shared_aligned.data"))) \
     __typeof__(type) per_cpu__##name				\
     ____cacheline_aligned_in_smp
 
diff -urpN linux-2.6.org/include/asm-sh/cache.h linux-2.6.gc1/include/asm-sh/cache.h
--- linux-2.6.org/include/asm-sh/cache.h	2007-11-23 18:55:25.000000000 -0800
+++ linux-2.6.gc1/include/asm-sh/cache.h	2007-11-23 20:55:53.000000000 -0800
@@ -19,7 +19,7 @@
 
 #define L1_CACHE_BYTES		(1 << L1_CACHE_SHIFT)
 
-#define __read_mostly __attribute__((__section__(".data.read_mostly")))
+#define __read_mostly __attribute__((__section__(".read_mostly.data")))
 
 #ifndef __ASSEMBLY__
 struct cache_info {
diff -urpN linux-2.6.org/include/asm-sh64/cache.h linux-2.6.gc1/include/asm-sh64/cache.h
--- linux-2.6.org/include/asm-sh64/cache.h	2007-11-23 18:55:25.000000000 -0800
+++ linux-2.6.gc1/include/asm-sh64/cache.h	2007-11-23 20:55:53.000000000 -0800
@@ -26,7 +26,7 @@
 #else
 #define __cacheline_aligned					\
   __attribute__((__aligned__(L1_CACHE_BYTES),			\
-		 __section__(".data.cacheline_aligned")))
+		 __section__(".cacheline_aligned.data")))
 #endif
 
 /*
diff -urpN linux-2.6.org/include/asm-sparc64/cache.h linux-2.6.gc1/include/asm-sparc64/cache.h
--- linux-2.6.org/include/asm-sparc64/cache.h	2007-11-23 18:55:25.000000000 -0800
+++ linux-2.6.gc1/include/asm-sparc64/cache.h	2007-11-23 20:55:53.000000000 -0800
@@ -13,6 +13,6 @@
 #define        SMP_CACHE_BYTES_SHIFT	6
 #define        SMP_CACHE_BYTES		(1 << SMP_CACHE_BYTES_SHIFT) /* L2 cache line size. */
 
-#define __read_mostly __attribute__((__section__(".data.read_mostly")))
+#define __read_mostly __attribute__((__section__(".read_mostly.data")))
 
 #endif
diff -urpN linux-2.6.org/include/asm-sparc64/percpu.h linux-2.6.gc1/include/asm-sparc64/percpu.h
--- linux-2.6.org/include/asm-sparc64/percpu.h	2007-11-23 18:55:25.000000000 -0800
+++ linux-2.6.gc1/include/asm-sparc64/percpu.h	2007-11-23 20:55:52.000000000 -0800
@@ -18,10 +18,10 @@ extern unsigned long __per_cpu_shift;
 
 /* Separate out the type, so (int[3], foo) works. */
 #define DEFINE_PER_CPU(type, name) \
-    __attribute__((__section__(".data.percpu"))) __typeof__(type) per_cpu__##name
+    __attribute__((__section__(".percpu.data"))) __typeof__(type) per_cpu__##name
 
 #define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		\
-    __attribute__((__section__(".data.percpu.shared_aligned"))) \
+    __attribute__((__section__(".percpu.shared_aligned.data"))) \
     __typeof__(type) per_cpu__##name				\
     ____cacheline_aligned_in_smp
 
diff -urpN linux-2.6.org/include/asm-um/common.lds.S linux-2.6.gc1/include/asm-um/common.lds.S
--- linux-2.6.org/include/asm-um/common.lds.S	2007-11-23 18:55:25.000000000 -0800
+++ linux-2.6.gc1/include/asm-um/common.lds.S	2007-11-23 20:55:52.000000000 -0800
@@ -49,9 +49,9 @@
   }
 
   . = ALIGN(32);
-  .data.percpu : {
+  .percpu.data : {
 	__per_cpu_start = . ;
-	*(.data.percpu)
+	*(.percpu.data)
 	__per_cpu_end = . ;
   }
 	
diff -urpN linux-2.6.org/include/asm-x86/cache.h linux-2.6.gc1/include/asm-x86/cache.h
--- linux-2.6.org/include/asm-x86/cache.h	2007-11-23 18:55:26.000000000 -0800
+++ linux-2.6.gc1/include/asm-x86/cache.h	2007-11-23 20:55:55.000000000 -0800
@@ -5,7 +5,7 @@
 #define L1_CACHE_SHIFT	(CONFIG_X86_L1_CACHE_SHIFT)
 #define L1_CACHE_BYTES	(1 << L1_CACHE_SHIFT)
 
-#define __read_mostly __attribute__((__section__(".data.read_mostly")))
+#define __read_mostly __attribute__((__section__(".read_mostly.data")))
 
 #ifdef CONFIG_X86_VSMP
 /* vSMP Internode cacheline shift */
@@ -13,7 +13,7 @@
 #ifdef CONFIG_SMP
 #define __cacheline_aligned_in_smp					\
 	__attribute__((__aligned__(1 << (INTERNODE_CACHE_SHIFT))))	\
-	__attribute__((__section__(".data.page_aligned")))
+	__attribute__((__section__(".page_aligned.data")))
 #endif
 #endif
 
diff -urpN linux-2.6.org/include/asm-x86/percpu_32.h linux-2.6.gc1/include/asm-x86/percpu_32.h
--- linux-2.6.org/include/asm-x86/percpu_32.h	2007-11-23 18:55:26.000000000 -0800
+++ linux-2.6.gc1/include/asm-x86/percpu_32.h	2007-11-23 20:55:52.000000000 -0800
@@ -52,10 +52,10 @@ extern unsigned long __per_cpu_offset[];
 /* Separate out the type, so (int[3], foo) works. */
 #define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu__##name
 #define DEFINE_PER_CPU(type, name) \
-    __attribute__((__section__(".data.percpu"))) __typeof__(type) per_cpu__##name
+    __attribute__((__section__(".percpu.data"))) __typeof__(type) per_cpu__##name
 
 #define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		\
-    __attribute__((__section__(".data.percpu.shared_aligned"))) \
+    __attribute__((__section__(".percpu.shared_aligned.data"))) \
     __typeof__(type) per_cpu__##name				\
     ____cacheline_aligned_in_smp
 
diff -urpN linux-2.6.org/include/asm-x86/percpu_64.h linux-2.6.gc1/include/asm-x86/percpu_64.h
--- linux-2.6.org/include/asm-x86/percpu_64.h	2007-11-23 18:55:26.000000000 -0800
+++ linux-2.6.gc1/include/asm-x86/percpu_64.h	2007-11-23 20:55:52.000000000 -0800
@@ -18,10 +18,10 @@
 
 /* Separate out the type, so (int[3], foo) works. */
 #define DEFINE_PER_CPU(type, name) \
-    __attribute__((__section__(".data.percpu"))) __typeof__(type) per_cpu__##name
+    __attribute__((__section__(".percpu.data"))) __typeof__(type) per_cpu__##name
 
 #define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		\
-    __attribute__((__section__(".data.percpu.shared_aligned"))) \
+    __attribute__((__section__(".percpu.shared_aligned.data"))) \
     __typeof__(type) per_cpu__##name				\
     ____cacheline_internodealigned_in_smp
 
diff -urpN linux-2.6.org/include/linux/cache.h linux-2.6.gc1/include/linux/cache.h
--- linux-2.6.org/include/linux/cache.h	2007-11-23 18:55:26.000000000 -0800
+++ linux-2.6.gc1/include/linux/cache.h	2007-11-23 20:55:53.000000000 -0800
@@ -31,7 +31,7 @@
 #ifndef __cacheline_aligned
 #define __cacheline_aligned					\
   __attribute__((__aligned__(SMP_CACHE_BYTES),			\
-		 __section__(".data.cacheline_aligned")))
+		 __section__(".cacheline_aligned.data")))
 #endif /* __cacheline_aligned */
 
 #ifndef __cacheline_aligned_in_smp
diff -urpN linux-2.6.org/include/linux/init.h linux-2.6.gc1/include/linux/init.h
--- linux-2.6.org/include/linux/init.h	2007-11-23 18:55:26.000000000 -0800
+++ linux-2.6.gc1/include/linux/init.h	2007-11-23 20:55:54.000000000 -0800
@@ -55,8 +55,8 @@
  * the init/exit section (code or data) is valid and will teach modpost
  * not to issue a warning.
  * The markers follow same syntax rules as __init / __initdata. */
-#define __init_refok     noinline __attribute__ ((__section__ (".text.init.refok")))
-#define __initdata_refok          __attribute__ ((__section__ (".data.init.refok")))
+#define __init_refok     noinline __attribute__ ((__section__ (".init.refok.text")))
+#define __initdata_refok          __attribute__ ((__section__ (".init.refok.data")))
 #define __exit_refok     noinline __attribute__ ((__section__ (".exit.text.refok")))
 
 #ifdef MODULE
@@ -67,10 +67,10 @@
 
 /* For assembly routines */
 #define __INIT		.section	".init.text","ax"
-#define __INIT_REFOK	.section	".text.init.refok","ax"
+#define __INIT_REFOK	.section	".init.refok.text","ax"
 #define __FINIT		.previous
 #define __INITDATA	.section	".init.data","aw"
-#define __INITDATA_REFOK .section	".data.init.refok","aw"
+#define __INITDATA_REFOK .section	".init.refok.data","aw"
 
 #ifndef __ASSEMBLY__
 /*
@@ -242,7 +242,7 @@ void __init parse_early_param(void);
 #endif
 
 /* Data marked not to be saved by software suspend */
-#define __nosavedata __attribute__ ((__section__ (".data.nosave")))
+#define __nosavedata __attribute__ ((__section__ (".nosave.data")))
 
 /* This means "can be init if no module support, otherwise module load
    may call it." */
diff -urpN linux-2.6.org/include/linux/spinlock.h linux-2.6.gc1/include/linux/spinlock.h
--- linux-2.6.org/include/linux/spinlock.h	2007-11-23 18:55:26.000000000 -0800
+++ linux-2.6.gc1/include/linux/spinlock.h	2007-11-23 20:55:46.000000000 -0800
@@ -59,7 +59,7 @@
 /*
  * Must define these before including other files, inline functions need them
  */
-#define LOCK_SECTION_NAME ".text.lock."KBUILD_BASENAME
+#define LOCK_SECTION_NAME ".lock..text"KBUILD_BASENAME
 
 #define LOCK_SECTION_START(extra)               \
         ".subsection 1\n\t"                     \
diff -urpN linux-2.6.org/kernel/module.c linux-2.6.gc1/kernel/module.c
--- linux-2.6.org/kernel/module.c	2007-11-23 18:55:26.000000000 -0800
+++ linux-2.6.gc1/kernel/module.c	2007-11-23 20:55:52.000000000 -0800
@@ -422,7 +422,7 @@ static unsigned int find_pcpusec(Elf_Ehd
 				 Elf_Shdr *sechdrs,
 				 const char *secstrings)
 {
-	return find_sec(hdr, sechdrs, secstrings, ".data.percpu");
+	return find_sec(hdr, sechdrs, secstrings, ".percpu.data");
 }
 
 static int percpu_modinit(void)
diff -urpN linux-2.6.org/scripts/mod/modpost.c linux-2.6.gc1/scripts/mod/modpost.c
--- linux-2.6.org/scripts/mod/modpost.c	2007-11-23 18:55:26.000000000 -0800
+++ linux-2.6.gc1/scripts/mod/modpost.c	2007-11-23 20:55:54.000000000 -0800
@@ -649,7 +649,7 @@ static int data_section(const char *name
  * Pattern 0:
  *   Do not warn if funtion/data are marked with __init_refok/__initdata_refok.
  *   The pattern is identified by:
- *   fromsec = .text.init.refok* | .data.init.refok*
+ *   fromsec = .init.refok.text* | .init.refok.data*
  *
  * Pattern 1:
  *   If a module parameter is declared __initdata and permissions=0
@@ -672,8 +672,8 @@ static int data_section(const char *name
  *   atsym = *driver, *_template, *_sht, *_ops, *_probe, *probe_one, *_console, *_timer
  *
  * Pattern 3:
- *   Whitelist all refereces from .text.head to .init.data
- *   Whitelist all refereces from .text.head to .init.text
+ *   Whitelist all refereces from .head.text to .init.data
+ *   Whitelist all refereces from .head.text to .init.text
  *
  * Pattern 4:
  *   Some symbols belong to init section but still it is ok to reference
@@ -717,9 +717,9 @@ static int secref_whitelist(const char *
 	};
 
 	/* Check for pattern 0 */
-	if ((strncmp(fromsec, ".text.init.refok", strlen(".text.init.refok")) == 0) ||
+	if ((strncmp(fromsec, ".init.refok.text", strlen(".init.refok.text")) == 0) ||
 	    (strncmp(fromsec, ".exit.text.refok", strlen(".exit.text.refok")) == 0) ||
-	    (strncmp(fromsec, ".data.init.refok", strlen(".data.init.refok")) == 0))
+	    (strncmp(fromsec, ".init.refok.data", strlen(".init.refok.data")) == 0))
 		return 1;
 
 	/* Check for pattern 1 */
@@ -735,7 +735,7 @@ static int secref_whitelist(const char *
 				return 1;
 
 	/* Check for pattern 3 */
-	if ((strcmp(fromsec, ".text.head") == 0) &&
+	if ((strcmp(fromsec, ".head.text") == 0) &&
 		((strcmp(tosec, ".init.data") == 0) ||
 		(strcmp(tosec, ".init.text") == 0)))
 	return 1;
@@ -1196,7 +1196,7 @@ static int init_section_ref_ok(const cha
 		"__param",
 		".data.rel.ro",		/* used by parisc64 */
 		".init",
-		".text.lock",
+		".lock.text",
 		NULL
 	};
 	/* Start of section names */

--Boundary-00=_sDLSHEtlOZs+H7n--
