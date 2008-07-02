Return-Path: <linux-kernel-owner+w=401wt.eu-S1761739AbYGAWgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761739AbYGAWgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 18:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757801AbYGAWfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 18:35:54 -0400
Received: from qb-out-0506.google.com ([72.14.204.232]:3790 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758632AbYGAWfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 18:35:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :content-type:content-transfer-encoding:message-id;
        b=EM5FQyyTStSF9UZloTQ0/7j5fQJ2e547Sszq4/kizZLNLgFST9e3X0Hxh4ZY9zECk0
         u1f2uaJlr9LVmhlkqBsCxr2k/JSNkkMXKFV4m4NPgxuLz8WGMWxOeYMt0ekFqZG/hZv9
         xCkTBDh1bHjJlzi0v+LoxTy8NNOrlWCcBv6CI=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: linux-arch@vger.kernel.org
Subject: [PATCH 7/23] make section names compatible with -ffunction-sections -fdata-sections: frv
Date: Wed, 2 Jul 2008 02:36:10 +0200
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
Message-Id: <200807020236.10743.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The purpose of this patch is to make kernel buildable
with "gcc -ffunction-sections -fdata-sections".
This patch fixes frv architecture.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda


--- 0.org/arch/frv/kernel/break.S	Wed Jul  2 00:40:40 2008
+++ 1.fixname/arch/frv/kernel/break.S	Wed Jul  2 01:04:35 2008
@@ -21,7 +21,7 @@
 #
 # the break handler has its own stack
 #
-	.section	.bss.stack
+	.section	.bss.k.stack
 	.globl		__break_user_context
 	.balign		THREAD_SIZE
 __break_stack:
@@ -63,7 +63,7 @@
 # entry point for Break Exceptions/Interrupts
 #
 ###############################################################################
-	.section	.text.break
+	.section	.break.text
 	.balign		4
 	.globl		__entry_break
 __entry_break:
--- 0.org/arch/frv/kernel/entry.S	Wed Jul  2 00:40:40 2008
+++ 1.fixname/arch/frv/kernel/entry.S	Wed Jul  2 00:59:28 2008
@@ -38,7 +38,7 @@
 
 #define nr_syscalls ((syscall_table_size)/4)
 
-	.section	.text.entry
+	.section	.entry.text
 	.balign		4
 
 .macro LEDS val
--- 0.org/arch/frv/kernel/head-mmu-fr451.S	Wed Jul  2 00:40:40 2008
+++ 1.fixname/arch/frv/kernel/head-mmu-fr451.S	Wed Jul  2 00:44:28 2008
@@ -31,7 +31,7 @@
 #define __400_LCR	0xfe000100
 #define __400_LSBR	0xfe000c00
 
-	.section	.text.init,"ax"
+	.section	.init.text,"ax"
 	.balign		4
 
 ###############################################################################
--- 0.org/arch/frv/kernel/head-uc-fr401.S	Wed Jul  2 00:40:40 2008
+++ 1.fixname/arch/frv/kernel/head-uc-fr401.S	Wed Jul  2 00:44:28 2008
@@ -30,7 +30,7 @@
 #define __400_LCR	0xfe000100
 #define __400_LSBR	0xfe000c00
 
-	.section	.text.init,"ax"
+	.section	.init.text,"ax"
 	.balign		4
 
 ###############################################################################
--- 0.org/arch/frv/kernel/head-uc-fr451.S	Wed Jul  2 00:40:40 2008
+++ 1.fixname/arch/frv/kernel/head-uc-fr451.S	Wed Jul  2 00:44:28 2008
@@ -30,7 +30,7 @@
 #define __400_LCR	0xfe000100
 #define __400_LSBR	0xfe000c00
 
-	.section	.text.init,"ax"
+	.section	.init.text,"ax"
 	.balign		4
 
 ###############################################################################
--- 0.org/arch/frv/kernel/head-uc-fr555.S	Wed Jul  2 00:40:40 2008
+++ 1.fixname/arch/frv/kernel/head-uc-fr555.S	Wed Jul  2 00:44:28 2008
@@ -29,7 +29,7 @@
 #define __551_LCR	0xfeff1100
 #define __551_LSBR	0xfeff1c00
 
-	.section	.text.init,"ax"
+	.section	.init.text,"ax"
 	.balign		4
 
 ###############################################################################
--- 0.org/arch/frv/kernel/head.S	Wed Jul  2 00:40:40 2008
+++ 1.fixname/arch/frv/kernel/head.S	Wed Jul  2 00:44:34 2008
@@ -27,7 +27,7 @@
 #   command line string
 #
 ###############################################################################
-	.section	.text.head,"ax"
+	.section	.head.text,"ax"
 	.balign		4
 
 	.globl		_boot, __head_reference
@@ -541,7 +541,7 @@
 	.size		_boot, .-_boot
 
 	# provide a point for GDB to place a break
-	.section	.text.start,"ax"
+	.section	.start.text,"ax"
 	.globl		_start
 	.balign		4
 _start:
--- 0.org/arch/frv/kernel/init_task.c	Wed Jul  2 00:40:40 2008
+++ 1.fixname/arch/frv/kernel/init_task.c	Wed Jul  2 00:45:57 2008
@@ -25,7 +25,7 @@
  * "init_task" linker map entry..
  */
 union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
+	__attribute__((__section__(".init_task.data"))) =
 		{ INIT_THREAD_INFO(init_task) };
 
 /*
--- 0.org/arch/frv/kernel/vmlinux.lds.S	Wed Jul  2 00:40:40 2008
+++ 1.fixname/arch/frv/kernel/vmlinux.lds.S	Wed Jul  2 01:04:35 2008
@@ -26,7 +26,7 @@
 
   _sinittext = .;
   .init.text : {
-	*(.text.head)
+	*(.head.text)
 #ifndef CONFIG_DEBUG_INFO
 	INIT_TEXT
 	EXIT_TEXT
@@ -71,13 +71,13 @@
 
   /* put sections together that have massive alignment issues */
   . = ALIGN(THREAD_SIZE);
-  .data.init_task : {
+  .init_task.data : {
 	  /* init task record & stack */
-	  *(.data.init_task)
+	  *(.init_task.data)
   }
 
   . = ALIGN(L1_CACHE_BYTES);
-  .data.cacheline_aligned : { *(.data.cacheline_aligned) }
+  .cacheline_aligned.data : { *(.cacheline_aligned.data) }
 
   .trap : {
 	/* trap table management - read entry-table.S before modifying */
@@ -94,10 +94,10 @@
   _text = .;
   _stext = .;
   .text : {
-	*(.text.start)
-	*(.text.entry)
-	*(.text.break)
-	*(.text.tlbmiss)
+	*(.start.text)
+	*(.entry.text)
+	*(.break.text)
+	*(.tlbmiss.text)
 	TEXT_TEXT
 	SCHED_TEXT
 	LOCK_TEXT
@@ -152,7 +152,7 @@
 
   .sbss		: { *(.sbss .sbss.*) }
   .bss		: { *(.bss .bss.*) }
-  .bss.stack	: { *(.bss) }
+  .bss.k.stack	: { *(.bss) }
 
   __bss_stop = .;
   _end = . ;
--- 0.org/arch/frv/mm/tlb-miss.S	Wed Jul  2 00:40:40 2008
+++ 1.fixname/arch/frv/mm/tlb-miss.S	Wed Jul  2 00:59:40 2008
@@ -16,7 +16,7 @@
 #include <asm/highmem.h>
 #include <asm/spr-regs.h>
 
-	.section	.text.tlbmiss
+	.section	.tlbmiss.text
 	.balign		4
 
 	.globl		__entry_insn_mmu_miss
