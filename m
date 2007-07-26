Return-Path: <linux-kernel-owner+w=401wt.eu-S1761356AbXGZDbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761356AbXGZDbi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 23:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756970AbXGZDb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 23:31:27 -0400
Received: from qsrv03ps.mx.bigpond.com ([144.140.82.183]:25110 "EHLO
	qsrv03ps.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756550AbXGZDbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 23:31:25 -0400
Message-ID: <46A7F7BE.1030100@bigpond.net.au>
Date: Thu, 26 Jul 2007 11:24:14 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 2.0.0.4 (X11/20070613)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Gregory Haskins <ghaskins@novell.com>, jim.houston@ccur.com,
       joe.korty@ccur.com, rostedt@goodmis.org, tglx@linutronix.de,
       dwalker@mvista.com, David Bahi <DBahi@novell.com>,
       Moiz Kohari <MKohari@novell.com>, Sven Dietrich <SDietrich@novell.com>,
       dsaxena@plexity.net, williams@redhat.com, abogani@texware.it,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Minor errors in 2.6.23-rc1-rt2 series
References: <4695E5BB0200005A0002763E@mcclure.wal.novell.com> <20070712130958.GB17494@elte.hu>
In-Reply-To: <20070712130958.GB17494@elte.hu>
Content-Type: multipart/mixed;
 boundary="------------050100050505060704070002"
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta06ps.mx.bigpond.com from [124.177.164.224] using ID pwil3058@bigpond.net.au at Thu, 26 Jul 2007 01:24:57 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050100050505060704070002
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

I've just been reviewing these patches and have spotted a couple of
errors that look like they were caused by fuzz during the patch process.

A patch that corrects the errors is attached.

Cheers
Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
 -- Ambrose Bierce


--------------050100050505060704070002
Content-Type: text/plain;
 name="fix-fuzz-related-errors"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fix-fuzz-related-errors"

diff -r e02fd64426b9 arch/i386/boot/compressed/Makefile
--- a/arch/i386/boot/compressed/Makefile	Thu Jul 26 10:33:58 2007 +1000
+++ b/arch/i386/boot/compressed/Makefile	Thu Jul 26 11:17:35 2007 +1000
@@ -9,10 +9,9 @@ EXTRA_AFLAGS	:= -traditional
 EXTRA_AFLAGS	:= -traditional
 
 LDFLAGS_vmlinux := -T
-CFLAGS := -m32 -D__KERNEL__ -Iinclude -O2  -fno-strict-aliasing
 hostprogs-y	:= relocs
 
-CFLAGS  := -m32 -D__KERNEL__ $(LINUX_INCLUDE) -O2 \
+CFLAGS  := -m32 -D__KERNEL__ $(LINUX_INCLUDE) -Iinclude -O2 \
 	   -fno-strict-aliasing -fPIC \
 	   $(call cc-option,-ffreestanding) \
 	   $(call cc-option,-fno-stack-protector)
diff -r e02fd64426b9 arch/i386/kernel/smp.c
--- a/arch/i386/kernel/smp.c	Thu Jul 26 10:33:58 2007 +1000
+++ b/arch/i386/kernel/smp.c	Thu Jul 26 11:17:35 2007 +1000
@@ -651,7 +651,6 @@ fastcall notrace void smp_reschedule_int
 fastcall notrace void smp_reschedule_interrupt(struct pt_regs *regs)
 {
 	trace_special(regs->eip, 0, 0);
-	trace_special(regs->eip, 0, 0);
 	ack_APIC_irq();
 	set_tsk_need_resched(current);
 }
diff -r e02fd64426b9 include/asm-mips/mipsregs.h
--- a/include/asm-mips/mipsregs.h	Thu Jul 26 10:33:58 2007 +1000
+++ b/include/asm-mips/mipsregs.h	Thu Jul 26 11:17:35 2007 +1000
@@ -710,7 +710,7 @@ do {									\
 	unsigned long long __val;					\
 	unsigned long __flags;						\
 									\
-	local_irq_save(flags);					\
+	local_irq_save(__flags);					\
 	if (sel == 0)							\
 		__asm__ __volatile__(					\
 			".set\tmips64\n\t"				\

--------------050100050505060704070002--
