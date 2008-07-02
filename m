Return-Path: <linux-kernel-owner+w=401wt.eu-S1763130AbYGAWl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763130AbYGAWl0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 18:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757609AbYGAWlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 18:41:10 -0400
Received: from qb-out-0506.google.com ([72.14.204.228]:18988 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757158AbYGAWlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 18:41:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :content-type:content-transfer-encoding:message-id;
        b=HBWt//MMCAI37K/uqC257KrUAG9IHybPilCp46TlGQ72Axo25cBkQBUCE7urwJCGrt
         6CUe+tVuqReeaOC5jpp3JCJKLo0f8IqSeMq3gDiwYW9UDxxRB32TEBrZtVByh600moGZ
         J2QeBnJtIoHjq3BARaTvMBMXiBscZ7cfPZmoo=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: linux-arch@vger.kernel.org
Subject: [PATCH 18/23] make section names compatible with -ffunction-sections -fdata-sections: sh
Date: Wed, 2 Jul 2008 02:41:07 +0200
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
Message-Id: <200807020241.07340.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The purpose of this patch is to make kernel buildable
with "gcc -ffunction-sections -fdata-sections".
This patch fixes sh architecture.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda


--- 0.org/arch/sh/kernel/cpu/sh5/entry.S	Wed Jul  2 00:40:42 2008
+++ 1.fixname/arch/sh/kernel/cpu/sh5/entry.S	Wed Jul  2 00:44:28 2008
@@ -2063,10 +2063,10 @@
 
 
 /*
- * --- .text.init Section
+ * --- .init.text Section
  */
 
-	.section	.text.init, "ax"
+	.section	.init.text, "ax"
 
 /*
  * void trap_init (void)
--- 0.org/arch/sh/kernel/head_32.S	Wed Jul  2 00:40:42 2008
+++ 1.fixname/arch/sh/kernel/head_32.S	Wed Jul  2 00:44:22 2008
@@ -40,7 +40,7 @@
 1:
 	.skip	PAGE_SIZE - empty_zero_page - 1b
 
-	.section	.text.head, "ax"
+	.section	.head.text, "ax"
 
 /*
  * Condition at the entry of _stext:
--- 0.org/arch/sh/kernel/head_64.S	Wed Jul  2 00:40:42 2008
+++ 1.fixname/arch/sh/kernel/head_64.S	Wed Jul  2 00:44:22 2008
@@ -110,7 +110,7 @@
 fpu_in_use:	.quad	0
 
 
-	.section	.text.head, "ax"
+	.section	.head.text, "ax"
 	.balign L1_CACHE_BYTES
 /*
  * Condition at the entry of __stext:
--- 0.org/arch/sh/kernel/init_task.c	Wed Jul  2 00:40:42 2008
+++ 1.fixname/arch/sh/kernel/init_task.c	Wed Jul  2 00:45:57 2008
@@ -22,7 +22,7 @@
  * "init_task" linker map entry..
  */
 union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
+	__attribute__((__section__(".init_task.data"))) =
 		{ INIT_THREAD_INFO(init_task) };
 
 /*
--- 0.org/arch/sh/kernel/irq.c	Wed Jul  2 00:40:42 2008
+++ 1.fixname/arch/sh/kernel/irq.c	Wed Jul  2 00:47:00 2008
@@ -158,10 +158,10 @@
 
 #ifdef CONFIG_IRQSTACKS
 static char softirq_stack[NR_CPUS * THREAD_SIZE]
-		__attribute__((__section__(".bss.page_aligned")));
+		__attribute__((__section__(".bss.k.page_aligned")));
 
 static char hardirq_stack[NR_CPUS * THREAD_SIZE]
-		__attribute__((__section__(".bss.page_aligned")));
+		__attribute__((__section__(".bss.k.page_aligned")));
 
 /*
  * allocate per-cpu stacks for hardirq and for softirq processing
--- 0.org/arch/sh/kernel/vmlinux_32.lds.S	Wed Jul  2 00:40:42 2008
+++ 1.fixname/arch/sh/kernel/vmlinux_32.lds.S	Wed Jul  2 00:47:00 2008
@@ -28,7 +28,7 @@
 	} = 0
 
 	.text : {
-		*(.text.head)
+		*(.head.text)
 		TEXT_TEXT
 		SCHED_TEXT
 		LOCK_TEXT
@@ -59,19 +59,19 @@
 
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
 
@@ -129,7 +129,7 @@
 	.bss : {
 		__init_end = .;
 		__bss_start = .;		/* BSS */
-		*(.bss.page_aligned)
+		*(.bss.k.page_aligned)
 		*(.bss)
 		*(COMMON)
 		. = ALIGN(4);
--- 0.org/arch/sh/kernel/vmlinux_64.lds.S	Wed Jul  2 00:40:42 2008
+++ 1.fixname/arch/sh/kernel/vmlinux_64.lds.S	Wed Jul  2 00:47:00 2008
@@ -42,7 +42,7 @@
 	} = 0
 
 	.text : C_PHYS(.text) {
-		*(.text.head)
+		*(.head.text)
 		TEXT_TEXT
 		*(.text64)
 		*(.text..SHmedia32)
@@ -71,19 +71,19 @@
 
 	. = ALIGN(THREAD_SIZE);
 	.data : C_PHYS(.data) {			/* Data */
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
 
@@ -141,7 +141,7 @@
 	.bss : C_PHYS(.bss) {
 		__init_end = .;
 		__bss_start = .;		/* BSS */
-		*(.bss.page_aligned)
+		*(.bss.k.page_aligned)
 		*(.bss)
 		*(COMMON)
 		. = ALIGN(4);
--- 0.org/include/asm-sh/cache.h	Wed Jul  2 00:40:50 2008
+++ 1.fixname/include/asm-sh/cache.h	Wed Jul  2 00:45:45 2008
@@ -14,7 +14,7 @@
 
 #define L1_CACHE_BYTES		(1 << L1_CACHE_SHIFT)
 
-#define __read_mostly __attribute__((__section__(".data.read_mostly")))
+#define __read_mostly __attribute__((__section__(".read_mostly.data")))
 
 #ifndef __ASSEMBLY__
 struct cache_info {
