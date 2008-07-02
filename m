Return-Path: <linux-kernel-owner+w=401wt.eu-S1761808AbYGAWei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761808AbYGAWei (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 18:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757265AbYGAWeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 18:34:14 -0400
Received: from qb-out-0506.google.com ([72.14.204.234]:6995 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756581AbYGAWeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 18:34:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :content-type:content-transfer-encoding:message-id;
        b=flLaMInNh9a4DZ6ZKzLIih/46yHOC1+V5OYZ6YxE8mZ5aH35hr7H2EJ39ySOY88Udx
         nKguBu8hcblcTthFR0rNuxdvS2RhDNMIqmdrCSXhuzp+hOvxr9vD8sa3jKzRc7zJgOaN
         XX8PsS3R/Xh0aBBnOtA4AW5H/aRQyMoVEil98=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: linux-arch@vger.kernel.org
Subject: [PATCH 3/23] make section names compatible with -ffunction-sections -fdata-sections: arm
Date: Wed, 2 Jul 2008 02:34:26 +0200
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
Message-Id: <200807020234.26755.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The purpose of this patch is to make kernel buildable
with "gcc -ffunction-sections -fdata-sections".
This patch fixes arm architecture.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda


--- 0.org/arch/arm/kernel/head-nommu.S	Wed Jul  2 00:40:39 2008
+++ 1.fixname/arch/arm/kernel/head-nommu.S	Wed Jul  2 00:44:22 2008
@@ -33,7 +33,7 @@
  * numbers for r1.
  *
  */
-	.section ".text.head", "ax"
+	.section ".head.text", "ax"
 	.type	stext, %function
 ENTRY(stext)
 	msr	cpsr_c, #PSR_F_BIT | PSR_I_BIT | SVC_MODE @ ensure svc mode
--- 0.org/arch/arm/kernel/head.S	Wed Jul  2 00:40:39 2008
+++ 1.fixname/arch/arm/kernel/head.S	Wed Jul  2 00:44:22 2008
@@ -74,7 +74,7 @@
  * crap here - that's what the boot loader (or in extreme, well justified
  * circumstances, zImage) is for.
  */
-	.section ".text.head", "ax"
+	.section ".head.text", "ax"
 	.type	stext, %function
 ENTRY(stext)
 	msr	cpsr_c, #PSR_F_BIT | PSR_I_BIT | SVC_MODE @ ensure svc mode
--- 0.org/arch/arm/kernel/init_task.c	Wed Jul  2 00:40:39 2008
+++ 1.fixname/arch/arm/kernel/init_task.c	Wed Jul  2 00:45:57 2008
@@ -30,7 +30,7 @@
  * The things we do for performance..
  */
 union thread_union init_thread_union
-	__attribute__((__section__(".data.init_task"))) =
+	__attribute__((__section__(".init_task.data"))) =
 		{ INIT_THREAD_INFO(init_task) };
 
 /*
--- 0.org/arch/arm/kernel/vmlinux.lds.S	Wed Jul  2 00:40:39 2008
+++ 1.fixname/arch/arm/kernel/vmlinux.lds.S	Wed Jul  2 00:46:03 2008
@@ -23,10 +23,10 @@
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
@@ -65,8 +65,8 @@
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
@@ -125,7 +125,7 @@
 		 * first, the init task union, aligned
 		 * to an 8192 byte boundary.
 		 */
-		*(.data.init_task)
+		*(.init_task.data)
 
 #ifdef CONFIG_XIP_KERNEL
 		. = ALIGN(4096);
@@ -137,7 +137,7 @@
 
 		. = ALIGN(4096);
 		__nosave_begin = .;
-		*(.data.nosave)
+		*(.nosave.data)
 		. = ALIGN(4096);
 		__nosave_end = .;
 
@@ -145,7 +145,7 @@
 		 * then the cacheline aligned data
 		 */
 		. = ALIGN(32);
-		*(.data.cacheline_aligned)
+		*(.cacheline_aligned.data)
 
 		/*
 		 * The exception fixup table (might need resorting at runtime)
--- 0.org/arch/arm/mm/proc-v6.S	Wed Jul  2 00:40:40 2008
+++ 1.fixname/arch/arm/mm/proc-v6.S	Wed Jul  2 00:44:28 2008
@@ -164,7 +164,7 @@
 	.asciz	"ARMv6-compatible processor"
 	.align
 
-	.section ".text.init", #alloc, #execinstr
+	.section ".init.text", #alloc, #execinstr
 
 /*
  *	__v6_setup
--- 0.org/arch/arm/mm/proc-v7.S	Wed Jul  2 00:40:40 2008
+++ 1.fixname/arch/arm/mm/proc-v7.S	Wed Jul  2 00:44:28 2008
@@ -146,7 +146,7 @@
 	.ascii	"ARMv7 Processor"
 	.align
 
-	.section ".text.init", #alloc, #execinstr
+	.section ".init.text", #alloc, #execinstr
 
 /*
  *	__v7_setup
--- 0.org/arch/arm/mm/tlb-v6.S	Wed Jul  2 00:40:40 2008
+++ 1.fixname/arch/arm/mm/tlb-v6.S	Wed Jul  2 00:44:28 2008
@@ -87,7 +87,7 @@
 	mcr	p15, 0, r2, c7, c5, 4		@ prefetch flush
 	mov	pc, lr
 
-	.section ".text.init", #alloc, #execinstr
+	.section ".init.text", #alloc, #execinstr
 
 	.type	v6wbi_tlb_fns, #object
 ENTRY(v6wbi_tlb_fns)
--- 0.org/arch/arm/mm/tlb-v7.S	Wed Jul  2 00:40:40 2008
+++ 1.fixname/arch/arm/mm/tlb-v7.S	Wed Jul  2 00:44:28 2008
@@ -78,7 +78,7 @@
 	isb
 	mov	pc, lr
 
-	.section ".text.init", #alloc, #execinstr
+	.section ".init.text", #alloc, #execinstr
 
 	.type	v7wbi_tlb_fns, #object
 ENTRY(v7wbi_tlb_fns)
