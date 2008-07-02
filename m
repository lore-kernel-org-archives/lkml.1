Return-Path: <linux-kernel-owner+w=401wt.eu-S1762190AbYGAWin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762190AbYGAWin (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 18:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762539AbYGAWiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 18:38:19 -0400
Received: from qb-out-0506.google.com ([72.14.204.230]:18145 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762512AbYGAWiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 18:38:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :content-type:content-transfer-encoding:message-id;
        b=BVnzGG28JrXAYIojKijmzm4rnFhxI/b9XIWehh5DkYLsGvqlvwjAWKc3tarEOCdDwh
         ONldvIKoJ/hm+sP34jAWkarS36nkmYsfm8XJOhxYznYOuOWg10eczRNYo9pVn8zqf3Lc
         +WIonaB+Je76dYQ2whBq+2HMFm7YIcN72xZ6k=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: linux-arch@vger.kernel.org
Subject: [PATCH 12/23] make section names compatible with -ffunction-sections -fdata-sections: m68k
Date: Wed, 2 Jul 2008 02:38:21 +0200
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
Message-Id: <200807020238.21228.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The purpose of this patch is to make kernel buildable
with "gcc -ffunction-sections -fdata-sections".
This patch fixes m68k architecture.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda


--- 0.org/arch/m68k/kernel/head.S	Wed Jul  2 00:40:40 2008
+++ 1.fixname/arch/m68k/kernel/head.S	Wed Jul  2 00:44:22 2008
@@ -577,7 +577,7 @@
 #endif
 .endm
 
-.section ".text.head","ax"
+.section ".head.text","ax"
 ENTRY(_stext)
 /*
  * Version numbers of the bootinfo interface
--- 0.org/arch/m68k/kernel/process.c	Wed Jul  2 00:40:40 2008
+++ 1.fixname/arch/m68k/kernel/process.c	Wed Jul  2 00:45:57 2008
@@ -48,7 +48,7 @@
 EXPORT_SYMBOL(init_mm);
 
 union thread_union init_thread_union
-__attribute__((section(".data.init_task"), aligned(THREAD_SIZE)))
+__attribute__((section(".init_task.data"), aligned(THREAD_SIZE)))
        = { INIT_THREAD_INFO(init_task) };
 
 /* initial task structure */
--- 0.org/arch/m68k/kernel/sun3-head.S	Wed Jul  2 00:40:40 2008
+++ 1.fixname/arch/m68k/kernel/sun3-head.S	Wed Jul  2 00:44:22 2008
@@ -29,7 +29,7 @@
 .globl kernel_pg_dir
 .equ    kernel_pg_dir,kernel_pmd_table
 
-	.section .text.head
+	.section .head.text
 ENTRY(_stext)
 ENTRY(_start)
 
--- 0.org/arch/m68k/kernel/vmlinux-std.lds	Wed Jul  2 00:40:40 2008
+++ 1.fixname/arch/m68k/kernel/vmlinux-std.lds	Wed Jul  2 00:45:57 2008
@@ -11,7 +11,7 @@
   . = 0x1000;
   _text = .;			/* Text and read-only data */
   .text : {
-	*(.text.head)
+	*(.head.text)
 	TEXT_TEXT
 	SCHED_TEXT
 	LOCK_TEXT
@@ -36,7 +36,7 @@
   .bss : { *(.bss) }		/* BSS */
 
   . = ALIGN(16);
-  .data.cacheline_aligned : { *(.data.cacheline_aligned) } :data
+  .cacheline_aligned.data : { *(.cacheline_aligned.data) } :data
 
   _edata = .;			/* End of data section */
 
@@ -76,7 +76,7 @@
   . = ALIGN(8192);
   __init_end = .;
 
-  .data.init_task : { *(.data.init_task) }	/* The initial task and kernel stack */
+  .init_task.data : { *(.init_task.data) }	/* The initial task and kernel stack */
 
   _end = . ;
 
--- 0.org/arch/m68k/kernel/vmlinux-sun3.lds	Wed Jul  2 00:40:40 2008
+++ 1.fixname/arch/m68k/kernel/vmlinux-sun3.lds	Wed Jul  2 00:45:57 2008
@@ -11,7 +11,7 @@
   . = 0xE002000;
   _text = .;			/* Text and read-only data */
   .text : {
-	*(.text.head)
+	*(.head.text)
 	TEXT_TEXT
 	SCHED_TEXT
 	LOCK_TEXT
@@ -68,7 +68,7 @@
 #endif
 	. = ALIGN(8192);
 	__init_end = .;
-	.data.init.task : { *(.data.init_task) }
+	.init.task.data : { *(.init_task.data) }
 
 
   .bss : { *(.bss) }		/* BSS */
--- 0.org/arch/m68knommu/kernel/init_task.c	Wed Jul  2 00:40:40 2008
+++ 1.fixname/arch/m68knommu/kernel/init_task.c	Wed Jul  2 00:45:57 2008
@@ -37,6 +37,6 @@
  * "init_task" linker map entry..
  */
 union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
+	__attribute__((__section__(".init_task.data"))) =
 		{ INIT_THREAD_INFO(init_task) };
 
--- 0.org/arch/m68knommu/kernel/vmlinux.lds.S	Wed Jul  2 00:40:40 2008
+++ 1.fixname/arch/m68knommu/kernel/vmlinux.lds.S	Wed Jul  2 00:45:57 2008
@@ -55,7 +55,7 @@
 	.romvec : {
 		__rom_start = . ;
 		_romvec = .;
-		*(.data.initvect)
+		*(.initvect.data)
 	} > romvec
 #endif
 
@@ -65,7 +65,7 @@
 		TEXT_TEXT
 		SCHED_TEXT
 		LOCK_TEXT
-        	*(.text.lock)
+        	*(.lock.text)
 
 		. = ALIGN(16);          /* Exception table              */
 		__start___ex_table = .;
@@ -147,7 +147,7 @@
 		_sdata = . ;
 		DATA_DATA
 		. = ALIGN(8192) ;
-		*(.data.init_task)
+		*(.init_task.data)
 		_edata = . ;
 	} > DATA
 
--- 0.org/arch/m68knommu/platform/68360/head-ram.S	Wed Jul  2 00:40:40 2008
+++ 1.fixname/arch/m68knommu/platform/68360/head-ram.S	Wed Jul  2 00:45:57 2008
@@ -280,7 +280,7 @@
      * and then overwritten as needed.
      */
  
-.section ".data.initvect","awx"
+.section ".initvect.data","awx"
     .long   RAMEND	/* Reset: Initial Stack Pointer                 - 0.  */
     .long   _start      /* Reset: Initial Program Counter               - 1.  */
     .long   buserr      /* Bus Error                                    - 2.  */
--- 0.org/arch/m68knommu/platform/68360/head-rom.S	Wed Jul  2 00:40:40 2008
+++ 1.fixname/arch/m68knommu/platform/68360/head-rom.S	Wed Jul  2 00:45:57 2008
@@ -291,7 +291,7 @@
      * and then overwritten as needed.
      */
  
-.section ".data.initvect","awx"
+.section ".initvect.data","awx"
     .long   RAMEND	/* Reset: Initial Stack Pointer                 - 0.  */
     .long   _start      /* Reset: Initial Program Counter               - 1.  */
     .long   buserr      /* Bus Error                                    - 2.  */
