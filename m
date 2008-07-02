Return-Path: <linux-kernel-owner+w=401wt.eu-S1762618AbYGAWjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762618AbYGAWjv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 18:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759832AbYGAWjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 18:39:39 -0400
Received: from qb-out-0506.google.com ([72.14.204.227]:17527 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758571AbYGAWjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 18:39:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :content-type:content-transfer-encoding:message-id;
        b=RRyKjHRFs6j+TcFqNNSs7SnRMuyeESF7mJ4AJ8jl706TJCbsdO4F0WAgWSwED230A0
         uwhHRwR0l2/pmgHqoGXAXNm1KpZaPqxJOp8GaaWCl/J1HMVUKfG+WD+pi42r41rZyJm8
         bNZdaX57/0rJEYajZ5DE6l/gpe8a/GeTiqrJ4=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: linux-arch@vger.kernel.org
Subject: [PATCH 15/23] make section names compatible with -ffunction-sections -fdata-sections: powerpc
Date: Wed, 2 Jul 2008 02:39:36 +0200
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
Message-Id: <200807020239.36751.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The purpose of this patch is to make kernel buildable
with "gcc -ffunction-sections -fdata-sections".
This patch fixes powerpc architecture.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda


--- 0.org/arch/powerpc/kernel/head_32.S	Wed Jul  2 00:40:41 2008
+++ 1.fixname/arch/powerpc/kernel/head_32.S	Wed Jul  2 00:44:22 2008
@@ -49,7 +49,7 @@
 	mtspr	SPRN_DBAT##n##L,RB;	\
 1:
 
-	.section	.text.head, "ax"
+	.section	.head.text, "ax"
 	.stabs	"arch/powerpc/kernel/",N_SO,0,0,0f
 	.stabs	"head_32.S",N_SO,0,0,0f
 0:
--- 0.org/arch/powerpc/kernel/head_40x.S	Wed Jul  2 00:40:41 2008
+++ 1.fixname/arch/powerpc/kernel/head_40x.S	Wed Jul  2 00:44:22 2008
@@ -52,7 +52,7 @@
  *
  * This is all going to change RSN when we add bi_recs.......  -- Dan
  */
-	.section	.text.head, "ax"
+	.section	.head.text, "ax"
 _ENTRY(_stext);
 _ENTRY(_start);
 
--- 0.org/arch/powerpc/kernel/head_44x.S	Wed Jul  2 00:40:41 2008
+++ 1.fixname/arch/powerpc/kernel/head_44x.S	Wed Jul  2 00:44:22 2008
@@ -50,7 +50,7 @@
  *   r7 - End of kernel command line string
  *
  */
-	.section	.text.head, "ax"
+	.section	.head.text, "ax"
 _ENTRY(_stext);
 _ENTRY(_start);
 	/*
--- 0.org/arch/powerpc/kernel/head_8xx.S	Wed Jul  2 00:40:41 2008
+++ 1.fixname/arch/powerpc/kernel/head_8xx.S	Wed Jul  2 00:44:22 2008
@@ -38,7 +38,7 @@
 #else
 #define DO_8xx_CPU6(val, reg)
 #endif
-	.section	.text.head, "ax"
+	.section	.head.text, "ax"
 _ENTRY(_stext);
 _ENTRY(_start);
 
--- 0.org/arch/powerpc/kernel/head_fsl_booke.S	Wed Jul  2 00:40:41 2008
+++ 1.fixname/arch/powerpc/kernel/head_fsl_booke.S	Wed Jul  2 00:44:22 2008
@@ -52,7 +52,7 @@
  *   r7 - End of kernel command line string
  *
  */
-	.section	.text.head, "ax"
+	.section	.head.text, "ax"
 _ENTRY(_stext);
 _ENTRY(_start);
 	/*
--- 0.org/arch/powerpc/kernel/init_task.c	Wed Jul  2 00:40:41 2008
+++ 1.fixname/arch/powerpc/kernel/init_task.c	Wed Jul  2 00:45:57 2008
@@ -22,7 +22,7 @@
  * "init_task" linker map entry..
  */
 union thread_union init_thread_union 
-	__attribute__((__section__(".data.init_task"))) =
+	__attribute__((__section__(".init_task.data"))) =
 		{ INIT_THREAD_INFO(init_task) };
 
 /*
--- 0.org/arch/powerpc/kernel/machine_kexec_64.c	Wed Jul  2 00:40:41 2008
+++ 1.fixname/arch/powerpc/kernel/machine_kexec_64.c	Wed Jul  2 00:45:57 2008
@@ -250,7 +250,7 @@
  * current, but that audit has not been performed.
  */
 union thread_union kexec_stack
-	__attribute__((__section__(".data.init_task"))) = { };
+	__attribute__((__section__(".init_task.data"))) = { };
 
 /* Our assembly helper, in kexec_stub.S */
 extern NORET_TYPE void kexec_sequence(void *newstack, unsigned long start,
--- 0.org/arch/powerpc/kernel/vdso.c	Wed Jul  2 00:40:41 2008
+++ 1.fixname/arch/powerpc/kernel/vdso.c	Wed Jul  2 00:46:09 2008
@@ -74,7 +74,7 @@
 static union {
 	struct vdso_data	data;
 	u8			page[PAGE_SIZE];
-} vdso_data_store __attribute__((__section__(".data.page_aligned")));
+} vdso_data_store __attribute__((__section__(".page_aligned.data")));
 struct vdso_data *vdso_data = &vdso_data_store.data;
 
 /* Format of the patch table */
--- 0.org/arch/powerpc/kernel/vdso32/vdso32_wrapper.S	Wed Jul  2 00:40:41 2008
+++ 1.fixname/arch/powerpc/kernel/vdso32/vdso32_wrapper.S	Wed Jul  2 00:46:09 2008
@@ -1,7 +1,7 @@
 #include <linux/init.h>
 #include <asm/page.h>
 
-	.section ".data.page_aligned"
+	.section ".page_aligned.data"
 
 	.globl vdso32_start, vdso32_end
 	.balign PAGE_SIZE
--- 0.org/arch/powerpc/kernel/vdso64/vdso64_wrapper.S	Wed Jul  2 00:40:41 2008
+++ 1.fixname/arch/powerpc/kernel/vdso64/vdso64_wrapper.S	Wed Jul  2 00:46:09 2008
@@ -1,7 +1,7 @@
 #include <linux/init.h>
 #include <asm/page.h>
 
-	.section ".data.page_aligned"
+	.section ".page_aligned.data"
 
 	.globl vdso64_start, vdso64_end
 	.balign PAGE_SIZE
--- 0.org/arch/powerpc/kernel/vmlinux.lds.S	Wed Jul  2 00:40:41 2008
+++ 1.fixname/arch/powerpc/kernel/vmlinux.lds.S	Wed Jul  2 00:54:28 2008
@@ -33,9 +33,9 @@
 	/* Text and gots */
 	.text : AT(ADDR(.text) - LOAD_OFFSET) {
 		ALIGN_FUNCTION();
-		*(.text.head)
+		*(.head.text)
 		_text = .;
-		*(.text .fixup .text.init.refok .exit.text.refok)
+		*(.text .fixup .init.refok.text .exit.refok.text)
 		SCHED_TEXT
 		LOCK_TEXT
 		KPROBES_TEXT
@@ -144,10 +144,10 @@
 	}
 #endif
 	. = ALIGN(PAGE_SIZE);
-	.data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {
+	.percpu.data  : AT(ADDR(.percpu.data) - LOAD_OFFSET) {
 		__per_cpu_start = .;
-		*(.data.percpu)
-		*(.data.percpu.shared_aligned)
+		*(.percpu.data)
+		*(.percpu.shared_aligned.data)
 		__per_cpu_end = .;
 	}
 
@@ -204,28 +204,28 @@
 #else
 	. = ALIGN(16384);
 #endif
-	.data.init_task : AT(ADDR(.data.init_task) - LOAD_OFFSET) {
-		*(.data.init_task)
+	.init_task.data : AT(ADDR(.init_task.data) - LOAD_OFFSET) {
+		*(.init_task.data)
 	}
 
 	. = ALIGN(PAGE_SIZE);
-	.data.page_aligned : AT(ADDR(.data.page_aligned) - LOAD_OFFSET) {
-		*(.data.page_aligned)
+	.page_aligned.data : AT(ADDR(.page_aligned.data) - LOAD_OFFSET) {
+		*(.page_aligned.data)
 	}
 
-	.data.cacheline_aligned : AT(ADDR(.data.cacheline_aligned) - LOAD_OFFSET) {
-		*(.data.cacheline_aligned)
+	.cacheline_aligned.data : AT(ADDR(.cacheline_aligned.data) - LOAD_OFFSET) {
+		*(.cacheline_aligned.data)
 	}
 
 	. = ALIGN(L1_CACHE_BYTES);
-	.data.read_mostly : AT(ADDR(.data.read_mostly) - LOAD_OFFSET) {
-		*(.data.read_mostly)
+	.read_mostly.data : AT(ADDR(.read_mostly.data) - LOAD_OFFSET) {
+		*(.read_mostly.data)
 	}
 
 	. = ALIGN(PAGE_SIZE);
 	.data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
 		__nosave_begin = .;
-		*(.data.nosave)
+		*(.nosave.data)
 		. = ALIGN(PAGE_SIZE);
 		__nosave_end = .;
 	}
--- 0.org/include/asm-powerpc/cache.h	Wed Jul  2 00:40:50 2008
+++ 1.fixname/include/asm-powerpc/cache.h	Wed Jul  2 00:45:45 2008
@@ -35,7 +35,7 @@
 #endif /* __powerpc64__ && ! __ASSEMBLY__ */
 
 #if !defined(__ASSEMBLY__)
-#define __read_mostly __attribute__((__section__(".data.read_mostly")))
+#define __read_mostly __attribute__((__section__(".read_mostly.data")))
 #endif
 
 #endif /* __KERNEL__ */
--- 0.org/include/asm-powerpc/page_64.h	Wed Jul  2 00:40:50 2008
+++ 1.fixname/include/asm-powerpc/page_64.h	Wed Jul  2 00:46:09 2008
@@ -150,7 +150,7 @@
 #else
 #define __page_aligned \
 	__attribute__((__aligned__(PAGE_SIZE), \
-		__section__(".data.page_aligned")))
+		__section__(".page_aligned.data")))
 #endif
 
 #define VM_DATA_DEFAULT_FLAGS \
--- 0.org/include/asm-powerpc/ppc_asm.h	Wed Jul  2 00:40:50 2008
+++ 1.fixname/include/asm-powerpc/ppc_asm.h	Wed Jul  2 00:44:28 2008
@@ -156,7 +156,7 @@
 GLUE(.,name):
 
 #define _INIT_GLOBAL(name) \
-	.section ".text.init.refok"; \
+	.section ".init.refok.text"; \
 	.align 2 ; \
 	.globl name; \
 	.globl GLUE(.,name); \
@@ -196,7 +196,7 @@
 GLUE(.,name):
 
 #define _INIT_STATIC(name) \
-	.section ".text.init.refok"; \
+	.section ".init.refok.text"; \
 	.align 2 ; \
 	.section ".opd","aw"; \
 name: \
