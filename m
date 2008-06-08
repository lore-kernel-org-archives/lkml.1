Return-Path: <linux-kernel-owner+w=401wt.eu-S1757193AbYFHQ3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193AbYFHQ3F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 12:29:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755467AbYFHQ2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 12:28:55 -0400
Received: from mail00a.mail.t-online.hu ([84.2.40.5]:51295 "EHLO
	mail00a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755433AbYFHQ2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 12:28:54 -0400
Message-ID: <484C078A.7090700@freemail.hu>
Date: Sun, 08 Jun 2008 18:23:38 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: cleanups to nmi_watchdog variable
References: <484AAD0B.1030407@freemail.hu> <20080608155649.GC7020@cvg>
In-Reply-To: <20080608155649.GC7020@cvg>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail00a.mail.t-online.hu 32710; Body=4 Fuz1=4
	Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> | From: Márton Németh <nm127@freemail.hu>
> | 
> | Use NMI_NONE instead of 0. As the symbol NMI_DISABLED equals to -1,
> | the nmi_watchdog variable should also be signed.
> | 
> | Signed-off-by: Márton Németh <nm127@freemail.hu>
> | ---
> | diff -upr linux-2.6.26-rc5.orig/arch/x86/kernel/io_apic_32.c linux-2.6.26-rc5/arch/x86/kernel/io_apic_32.c
> | --- linux-2.6.26-rc5.orig/arch/x86/kernel/io_apic_32.c	2008-06-07 12:35:24.000000000 +0200
> | +++ linux-2.6.26-rc5/arch/x86/kernel/io_apic_32.c	2008-06-07 12:40:20.000000000 +0200
> | @@ -2217,7 +2217,7 @@ static inline void __init check_timer(vo
> | 
> |  	if (nmi_watchdog == NMI_IO_APIC) {
> |  		printk(KERN_WARNING "timer doesn't work through the IO-APIC - disabling NMI Watchdog!\n");
> | -		nmi_watchdog = 0;
> | +		nmi_watchdog = NMI_NONE;
> |  	}
> | 
> |  	printk(KERN_INFO "...trying to set up timer as Virtual Wire IRQ...");
> | diff -upr linux-2.6.26-rc5.orig/arch/x86/kernel/io_apic_64.c linux-2.6.26-rc5/arch/x86/kernel/io_apic_64.c
> | --- linux-2.6.26-rc5.orig/arch/x86/kernel/io_apic_64.c	2008-06-05 18:39:49.000000000 +0200
> | +++ linux-2.6.26-rc5/arch/x86/kernel/io_apic_64.c	2008-06-07 12:37:01.000000000 +0200
> | @@ -1735,7 +1735,7 @@ static inline void __init check_timer(vo
> | 
> |  	if (nmi_watchdog == NMI_IO_APIC) {
> |  		printk(KERN_WARNING "timer doesn't work through the IO-APIC - disabling NMI Watchdog!\n");
> | -		nmi_watchdog = 0;
> | +		nmi_watchdog = NMI_NONE;
> |  	}
> | 
> |  	apic_printk(APIC_VERBOSE, KERN_INFO "...trying to set up timer as Virtual Wire IRQ...");
> | diff -upr linux-2.6.26-rc5.orig/arch/x86/kernel/nmi_32.c linux-2.6.26-rc5/arch/x86/kernel/nmi_32.c
> | --- linux-2.6.26-rc5.orig/arch/x86/kernel/nmi_32.c	2008-06-05 18:39:49.000000000 +0200
> | +++ linux-2.6.26-rc5/arch/x86/kernel/nmi_32.c	2008-06-07 11:19:55.000000000 +0200
> | @@ -43,7 +43,7 @@ static cpumask_t backtrace_mask = CPU_MA
> |   */
> |  atomic_t nmi_active = ATOMIC_INIT(0);		/* oprofile uses this */
> | 
> | -unsigned int nmi_watchdog = NMI_DEFAULT;
> | +int nmi_watchdog = NMI_DEFAULT;
> |  static unsigned int nmi_hz = HZ;
> | 
> |  static DEFINE_PER_CPU(short, wd_enabled);
> | diff -upr linux-2.6.26-rc5.orig/arch/x86/kernel/nmi_64.c linux-2.6.26-rc5/arch/x86/kernel/nmi_64.c
> | --- linux-2.6.26-rc5.orig/arch/x86/kernel/nmi_64.c	2008-06-05 18:39:49.000000000 +0200
> | +++ linux-2.6.26-rc5/arch/x86/kernel/nmi_64.c	2008-06-07 11:20:00.000000000 +0200
> | @@ -43,7 +43,7 @@ static cpumask_t backtrace_mask = CPU_MA
> |  atomic_t nmi_active = ATOMIC_INIT(0);		/* oprofile uses this */
> |  static int panic_on_timeout;
> | 
> | -unsigned int nmi_watchdog = NMI_DEFAULT;
> | +int nmi_watchdog = NMI_DEFAULT;
> |  static unsigned int nmi_hz = HZ;
> | 
> |  static DEFINE_PER_CPU(short, wd_enabled);
> | diff -upr linux-2.6.26-rc5.orig/include/asm-x86/nmi.h linux-2.6.26-rc5/include/asm-x86/nmi.h
> | --- linux-2.6.26-rc5.orig/include/asm-x86/nmi.h	2008-06-05 18:40:12.000000000 +0200
> | +++ linux-2.6.26-rc5/include/asm-x86/nmi.h	2008-06-07 11:21:20.000000000 +0200
> | @@ -61,7 +61,7 @@ extern void enable_timer_nmi_watchdog(vo
> |  extern int nmi_watchdog_tick(struct pt_regs *regs, unsigned reason);
> | 
> |  extern atomic_t nmi_active;
> | -extern unsigned int nmi_watchdog;
> | +extern int nmi_watchdog;
> |  #define NMI_DISABLED    -1
> |  #define NMI_NONE	0
> |  #define NMI_IO_APIC	1
> | 
> 
> We should leave nmi_watchdog as unsigned. The only snippet which
> could be reviewed as controversy point  - is touch_nmi_watchdog()
> where we just test nmi_watchdog for being greater than 0. Actually
> there NMI_NONE should be used instead. But frankly some additional
> simplification is needed.

Don't forget that the NMI_DEFAULT symbol in include/asm-x86/nmi.h also equals to
NMI_DISABLED, which is -1.

	Márton Németh

