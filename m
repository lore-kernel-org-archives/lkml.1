Return-Path: <linux-kernel-owner+w=401wt.eu-S1762227AbYFGPu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762227AbYFGPu2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 11:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbYFGPuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 11:50:21 -0400
Received: from mail00a.mail.t-online.hu ([84.2.40.5]:50681 "EHLO
	mail00a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbYFGPuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 11:50:20 -0400
Message-ID: <484AAD0B.1030407@freemail.hu>
Date: Sat, 07 Jun 2008 17:45:15 +0200
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: cleanups to nmi_watchdog variable
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail00a.mail.t-online.hu 32710; Body=3 Fuz1=3
	Fuz2=3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

Use NMI_NONE instead of 0. As the symbol NMI_DISABLED equals to -1,
the nmi_watchdog variable should also be signed.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -upr linux-2.6.26-rc5.orig/arch/x86/kernel/io_apic_32.c linux-2.6.26-rc5/arch/x86/kernel/io_apic_32.c
--- linux-2.6.26-rc5.orig/arch/x86/kernel/io_apic_32.c	2008-06-07 12:35:24.000000000 +0200
+++ linux-2.6.26-rc5/arch/x86/kernel/io_apic_32.c	2008-06-07 12:40:20.000000000 +0200
@@ -2217,7 +2217,7 @@ static inline void __init check_timer(vo

 	if (nmi_watchdog == NMI_IO_APIC) {
 		printk(KERN_WARNING "timer doesn't work through the IO-APIC - disabling NMI Watchdog!\n");
-		nmi_watchdog = 0;
+		nmi_watchdog = NMI_NONE;
 	}

 	printk(KERN_INFO "...trying to set up timer as Virtual Wire IRQ...");
diff -upr linux-2.6.26-rc5.orig/arch/x86/kernel/io_apic_64.c linux-2.6.26-rc5/arch/x86/kernel/io_apic_64.c
--- linux-2.6.26-rc5.orig/arch/x86/kernel/io_apic_64.c	2008-06-05 18:39:49.000000000 +0200
+++ linux-2.6.26-rc5/arch/x86/kernel/io_apic_64.c	2008-06-07 12:37:01.000000000 +0200
@@ -1735,7 +1735,7 @@ static inline void __init check_timer(vo

 	if (nmi_watchdog == NMI_IO_APIC) {
 		printk(KERN_WARNING "timer doesn't work through the IO-APIC - disabling NMI Watchdog!\n");
-		nmi_watchdog = 0;
+		nmi_watchdog = NMI_NONE;
 	}

 	apic_printk(APIC_VERBOSE, KERN_INFO "...trying to set up timer as Virtual Wire IRQ...");
diff -upr linux-2.6.26-rc5.orig/arch/x86/kernel/nmi_32.c linux-2.6.26-rc5/arch/x86/kernel/nmi_32.c
--- linux-2.6.26-rc5.orig/arch/x86/kernel/nmi_32.c	2008-06-05 18:39:49.000000000 +0200
+++ linux-2.6.26-rc5/arch/x86/kernel/nmi_32.c	2008-06-07 11:19:55.000000000 +0200
@@ -43,7 +43,7 @@ static cpumask_t backtrace_mask = CPU_MA
  */
 atomic_t nmi_active = ATOMIC_INIT(0);		/* oprofile uses this */

-unsigned int nmi_watchdog = NMI_DEFAULT;
+int nmi_watchdog = NMI_DEFAULT;
 static unsigned int nmi_hz = HZ;

 static DEFINE_PER_CPU(short, wd_enabled);
diff -upr linux-2.6.26-rc5.orig/arch/x86/kernel/nmi_64.c linux-2.6.26-rc5/arch/x86/kernel/nmi_64.c
--- linux-2.6.26-rc5.orig/arch/x86/kernel/nmi_64.c	2008-06-05 18:39:49.000000000 +0200
+++ linux-2.6.26-rc5/arch/x86/kernel/nmi_64.c	2008-06-07 11:20:00.000000000 +0200
@@ -43,7 +43,7 @@ static cpumask_t backtrace_mask = CPU_MA
 atomic_t nmi_active = ATOMIC_INIT(0);		/* oprofile uses this */
 static int panic_on_timeout;

-unsigned int nmi_watchdog = NMI_DEFAULT;
+int nmi_watchdog = NMI_DEFAULT;
 static unsigned int nmi_hz = HZ;

 static DEFINE_PER_CPU(short, wd_enabled);
diff -upr linux-2.6.26-rc5.orig/include/asm-x86/nmi.h linux-2.6.26-rc5/include/asm-x86/nmi.h
--- linux-2.6.26-rc5.orig/include/asm-x86/nmi.h	2008-06-05 18:40:12.000000000 +0200
+++ linux-2.6.26-rc5/include/asm-x86/nmi.h	2008-06-07 11:21:20.000000000 +0200
@@ -61,7 +61,7 @@ extern void enable_timer_nmi_watchdog(vo
 extern int nmi_watchdog_tick(struct pt_regs *regs, unsigned reason);

 extern atomic_t nmi_active;
-extern unsigned int nmi_watchdog;
+extern int nmi_watchdog;
 #define NMI_DISABLED    -1
 #define NMI_NONE	0
 #define NMI_IO_APIC	1
