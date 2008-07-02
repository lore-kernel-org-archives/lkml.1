Return-Path: <linux-kernel-owner+w=401wt.eu-S1762074AbYGAWnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762074AbYGAWnB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 18:43:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762671AbYGAWmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 18:42:47 -0400
Received: from qb-out-0506.google.com ([72.14.204.226]:29013 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763179AbYGAWmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 18:42:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :content-type:content-transfer-encoding:message-id;
        b=DfCgUb/TGLbAGqnHycAI/qFCO4b1qpime5sJu0fvAKmqAGalJ8YmgPW4ML4RwlK4N0
         wNljE4/5VT5xCtOaZeDJqgmHO8Wr8E+k0KPV1SfzjBsqRw/1tEv74OlC5Du0CIr/3NbD
         g2h0jFtdCMsvnp+VdfesC4L7ALjb65dZ441V8=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: linux-arch@vger.kernel.org
Subject: [PATCH 22/23] make section names compatible with -ffunction-sections -fdata-sections: x86
Date: Wed, 2 Jul 2008 02:42:42 +0200
User-Agent: KMail/1.8.2
Cc: Russell King <rmk@arm.linux.org.uk>, David Howells <dhowells@redhat.com>,
       Ralf Baechle <ralf@linux-mips.org>,
       Lennert Buytenhek <kernel@wantstofly.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Paul Mackerras <paulus@samba.org>,
       David Woodhouse <dwmw2@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tim Bird <tim.bird@am.sony.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Dave Miller <davem@davemloft.net>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200807020242.42414.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The purpose of this patch is to make kernel buildable
with "gcc -ffunction-sections -fdata-sections".
This patch fixes x86 architecture.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda


--- 0.org/arch/x86/boot/compressed/head_32.S	Wed Jul  2 00:40:42 2008
+++ 1.fixname/arch/x86/boot/compressed/head_32.S	Wed Jul  2 00:44:22 2008
@@ -29,7 +29,7 @@
 #include <asm/boot.h>
 #include <asm/asm-offsets.h>
 
-.section ".text.head","ax",@progbits
+.section ".head.text","ax",@progbits
 	.globl startup_32
 
 startup_32:
--- 0.org/arch/x86/boot/compressed/head_64.S	Wed Jul  2 00:40:42 2008
+++ 1.fixname/arch/x86/boot/compressed/head_64.S	Wed Jul  2 00:44:22 2008
@@ -32,7 +32,7 @@
 #include <asm/msr.h>
 #include <asm/asm-offsets.h>
 
-.section ".text.head"
+.section ".head.text"
 	.code32
 	.globl startup_32
 
--- 0.org/arch/x86/boot/compressed/vmlinux_32.lds	Wed Jul  2 00:40:42 2008
+++ 1.fixname/arch/x86/boot/compressed/vmlinux_32.lds	Wed Jul  2 00:44:22 2008
@@ -7,9 +7,9 @@
 	 * address 0.
 	 */
 	. = 0;
-	.text.head : {
+	.head.text : {
 		_head = . ;
-		*(.text.head)
+		*(.head.text)
 		_ehead = . ;
 	}
 	.rodata.compressed : {
--- 0.org/arch/x86/boot/compressed/vmlinux_64.lds	Wed Jul  2 00:40:42 2008
+++ 1.fixname/arch/x86/boot/compressed/vmlinux_64.lds	Wed Jul  2 00:44:22 2008
@@ -7,9 +7,9 @@
 	 * address 0.
 	 */
 	. = 0;
-	.text.head : {
+	.head.text : {
 		_head = . ;
-		*(.text.head)
+		*(.head.text)
 		_ehead = . ;
 	}
 	.rodata.compressed : {
--- 0.org/arch/x86/kernel/acpi/wakeup_32.S	Wed Jul  2 00:40:42 2008
+++ 1.fixname/arch/x86/kernel/acpi/wakeup_32.S	Wed Jul  2 00:56:50 2008
@@ -1,4 +1,4 @@
-	.section .text.page_aligned
+	.section .page_aligned.text
 #include <linux/linkage.h>
 #include <asm/segment.h>
 #include <asm/page.h>
--- 0.org/arch/x86/kernel/head_32.S	Wed Jul  2 00:40:42 2008
+++ 1.fixname/arch/x86/kernel/head_32.S	Wed Jul  2 00:47:00 2008
@@ -81,7 +81,7 @@
  * any particular GDT layout, because we load our own as soon as we
  * can.
  */
-.section .text.head,"ax",@progbits
+.section .head.text,"ax",@progbits
 ENTRY(startup_32)
 	/* test KEEP_SEGMENTS flag to see if the bootloader is asking
 		us to not reload segments */
@@ -602,7 +602,7 @@
 /*
  * BSS section
  */
-.section ".bss.page_aligned","wa"
+.section ".bss.k.page_aligned","wa"
 	.align PAGE_SIZE_asm
 #ifdef CONFIG_X86_PAE
 swapper_pg_pmd:
@@ -619,7 +619,7 @@
  * This starts the data section.
  */
 #ifdef CONFIG_X86_PAE
-.section ".data.page_aligned","wa"
+.section ".page_aligned.data","wa"
 	/* Page-aligned for the benefit of paravirt? */
 	.align PAGE_SIZE_asm
 ENTRY(swapper_pg_dir)
--- 0.org/arch/x86/kernel/head_64.S	Wed Jul  2 00:40:42 2008
+++ 1.fixname/arch/x86/kernel/head_64.S	Wed Jul  2 00:47:00 2008
@@ -32,7 +32,7 @@
  */
 
 	.text
-	.section .text.head
+	.section .head.text
 	.code64
 	.globl startup_64
 startup_64:
@@ -416,7 +416,7 @@
  * Also sysret mandates a special GDT layout 
  */
 		 		
-	.section .data.page_aligned, "aw"
+	.section .page_aligned.data, "aw"
 	.align PAGE_SIZE
 
 /* The TLS descriptors are currently at a different place compared to i386.
@@ -448,7 +448,7 @@
 ENTRY(idt_table)
 	.skip 256 * 16
 
-	.section .bss.page_aligned, "aw", @nobits
+	.section .bss.k.page_aligned, "aw", @nobits
 	.align PAGE_SIZE
 ENTRY(empty_zero_page)
 	.skip PAGE_SIZE
--- 0.org/arch/x86/kernel/init_task.c	Wed Jul  2 00:40:42 2008
+++ 1.fixname/arch/x86/kernel/init_task.c	Wed Jul  2 00:45:57 2008
@@ -24,7 +24,7 @@
  * "init_task" linker map entry..
  */
 union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
+	__attribute__((__section__(".init_task.data"))) =
 		{ INIT_THREAD_INFO(init_task) };
 
 /*
@@ -38,7 +38,7 @@
 /*
  * per-CPU TSS segments. Threads are completely 'soft' on Linux,
  * no more per-task TSS's. The TSS size is kept cacheline-aligned
- * so they are allowed to end up in the .data.cacheline_aligned
+ * so they are allowed to end up in the .cacheline_aligned.data
  * section. Since TSS's are completely CPU-local, we want them
  * on exact cacheline boundaries, to eliminate cacheline ping-pong.
  */
--- 0.org/arch/x86/kernel/irq_32.c	Wed Jul  2 00:40:42 2008
+++ 1.fixname/arch/x86/kernel/irq_32.c	Wed Jul  2 00:47:00 2008
@@ -148,10 +148,10 @@
 #ifdef CONFIG_4KSTACKS
 
 static char softirq_stack[NR_CPUS * THREAD_SIZE]
-		__attribute__((__section__(".bss.page_aligned")));
+		__attribute__((__section__(".bss.k.page_aligned")));
 
 static char hardirq_stack[NR_CPUS * THREAD_SIZE]
-		__attribute__((__section__(".bss.page_aligned")));
+		__attribute__((__section__(".bss.k.page_aligned")));
 
 /*
  * allocate per-cpu stacks for hardirq and for softirq processing
--- 0.org/arch/x86/kernel/setup64.c	Wed Jul  2 00:40:42 2008
+++ 1.fixname/arch/x86/kernel/setup64.c	Wed Jul  2 00:47:00 2008
@@ -40,7 +40,7 @@
 
 struct desc_ptr idt_descr = { 256 * 16 - 1, (unsigned long) idt_table };
 
-char boot_cpu_stack[IRQSTACKSIZE] __attribute__((section(".bss.page_aligned")));
+char boot_cpu_stack[IRQSTACKSIZE] __attribute__((section(".bss.k.page_aligned")));
 
 unsigned long __supported_pte_mask __read_mostly = ~0UL;
 EXPORT_SYMBOL_GPL(__supported_pte_mask);
@@ -121,7 +121,7 @@
 } 
 
 char boot_exception_stacks[(N_EXCEPTION_STACKS - 1) * EXCEPTION_STKSZ + DEBUG_STKSZ]
-__attribute__((section(".bss.page_aligned")));
+__attribute__((section(".bss.k.page_aligned")));
 
 extern asmlinkage void ignore_sysret(void);
 
--- 0.org/arch/x86/kernel/traps_32.c	Wed Jul  2 00:40:42 2008
+++ 1.fixname/arch/x86/kernel/traps_32.c	Wed Jul  2 00:46:32 2008
@@ -76,7 +76,7 @@
  * for this.
  */
 gate_desc idt_table[256]
-	__attribute__((__section__(".data.idt"))) = { { { { 0, 0 } } }, };
+	__attribute__((__section__(".idt.data"))) = { { { { 0, 0 } } }, };
 
 asmlinkage void divide_error(void);
 asmlinkage void debug(void);
--- 0.org/arch/x86/kernel/vmlinux_32.lds.S	Wed Jul  2 00:40:42 2008
+++ 1.fixname/arch/x86/kernel/vmlinux_32.lds.S	Wed Jul  2 00:56:50 2008
@@ -31,15 +31,15 @@
   . = LOAD_OFFSET + LOAD_PHYSICAL_ADDR;
   phys_startup_32 = startup_32 - LOAD_OFFSET;
 
-  .text.head : AT(ADDR(.text.head) - LOAD_OFFSET) {
+  .head.text : AT(ADDR(.head.text) - LOAD_OFFSET) {
   	_text = .;			/* Text and read-only data */
-	*(.text.head)
+	*(.head.text)
   } :text = 0x9090
 
   /* read-only */
   .text : AT(ADDR(.text) - LOAD_OFFSET) {
 	. = ALIGN(PAGE_SIZE); /* not really needed, already page aligned */
-	*(.text.page_aligned)
+	*(.page_aligned.text)
 	TEXT_TEXT
 	SCHED_TEXT
 	LOCK_TEXT
@@ -79,32 +79,32 @@
   . = ALIGN(PAGE_SIZE);
   .data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
   	__nosave_begin = .;
-	*(.data.nosave)
+	*(.nosave.data)
   	. = ALIGN(PAGE_SIZE);
   	__nosave_end = .;
   }
 
   . = ALIGN(PAGE_SIZE);
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
@@ -187,10 +187,10 @@
   }
 #endif
   . = ALIGN(PAGE_SIZE);
-  .data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {
+  .percpu.data  : AT(ADDR(.percpu.data) - LOAD_OFFSET) {
 	__per_cpu_start = .;
-	*(.data.percpu)
-	*(.data.percpu.shared_aligned)
+	*(.percpu.data)
+	*(.percpu.shared_aligned.data)
 	__per_cpu_end = .;
   }
   . = ALIGN(PAGE_SIZE);
@@ -199,7 +199,7 @@
   .bss : AT(ADDR(.bss) - LOAD_OFFSET) {
 	__init_end = .;
 	__bss_start = .;		/* BSS */
-	*(.bss.page_aligned)
+	*(.bss.k.page_aligned)
 	*(.bss)
 	. = ALIGN(4);
 	__bss_stop = .;
--- 0.org/arch/x86/kernel/vmlinux_64.lds.S	Wed Jul  2 00:40:42 2008
+++ 1.fixname/arch/x86/kernel/vmlinux_64.lds.S	Wed Jul  2 00:47:00 2008
@@ -28,7 +28,7 @@
   _text = .;			/* Text and read-only data */
   .text :  AT(ADDR(.text) - LOAD_OFFSET) {
 	/* First the code that has to be first for bootstrapping */
-	*(.text.head)
+	*(.head.text)
 	_stext = .;
 	/* Then the rest */
 	TEXT_TEXT
@@ -71,17 +71,17 @@
 
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
@@ -130,13 +130,13 @@
 #undef VVIRT
 
   . = ALIGN(THREAD_SIZE);	/* init_task */
-  .data.init_task : AT(ADDR(.data.init_task) - LOAD_OFFSET) {
-	*(.data.init_task)
+  .init_task.data : AT(ADDR(.init_task.data) - LOAD_OFFSET) {
+	*(.init_task.data)
   }:data.init
 
   . = ALIGN(PAGE_SIZE);
-  .data.page_aligned : AT(ADDR(.data.page_aligned) - LOAD_OFFSET) {
-	*(.data.page_aligned)
+  .page_aligned.data : AT(ADDR(.page_aligned.data) - LOAD_OFFSET) {
+	*(.page_aligned.data)
   }
 
   /* might get freed after init */
@@ -223,13 +223,13 @@
 
   . = ALIGN(PAGE_SIZE);
   __nosave_begin = .;
-  .data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) { *(.data.nosave) }
+  .data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) { *(.nosave.data) }
   . = ALIGN(PAGE_SIZE);
   __nosave_end = .;
 
   __bss_start = .;		/* BSS */
   .bss : AT(ADDR(.bss) - LOAD_OFFSET) {
-	*(.bss.page_aligned)
+	*(.bss.k.page_aligned)
 	*(.bss)
 	}
   __bss_stop = .;
--- 0.org/arch/x86/mm/ioremap.c	Wed Jul  2 00:40:42 2008
+++ 1.fixname/arch/x86/mm/ioremap.c	Wed Jul  2 00:47:00 2008
@@ -395,7 +395,7 @@
 
 static __initdata int after_paging_init;
 static pte_t bm_pte[PAGE_SIZE/sizeof(pte_t)]
-		__section(.bss.page_aligned);
+		__section(.bss.k.page_aligned);
 
 static inline pmd_t * __init early_ioremap_pmd(unsigned long addr)
 {
--- 0.org/include/asm-x86/cache.h	Wed Jul  2 00:40:51 2008
+++ 1.fixname/include/asm-x86/cache.h	Wed Jul  2 00:46:09 2008
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
 
