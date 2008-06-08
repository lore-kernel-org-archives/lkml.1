Return-Path: <linux-kernel-owner+w=401wt.eu-S1757853AbYFHP5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853AbYFHP5R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 11:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754721AbYFHP5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 11:57:06 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:61788 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661AbYFHP5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 11:57:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=IixYuvjFiIhGu8ovwXf+tGKtrIrvKqga9kjC3sz2PL3wM5JzaUQNKAG/U3A5NHU24+
         GQ2/UspLpMGZ5QFOIBLzWzRWlObEy3ec8TUGLWlINxO2D7z7IIx3Nc3DKnyug4AxpdHo
         wgNDqn8H9twacZU1nZeqLWb5wacVuSV0c0qyA=
Date: Sun, 8 Jun 2008 19:56:49 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: nm127@freemail.hu
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: cleanups to nmi_watchdog variable
Message-ID: <20080608155649.GC7020@cvg>
References: <484AAD0B.1030407@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <484AAD0B.1030407@freemail.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


| From: Márton Németh <nm127@freemail.hu>
| 
| Use NMI_NONE instead of 0. As the symbol NMI_DISABLED equals to -1,
| the nmi_watchdog variable should also be signed.
| 
| Signed-off-by: Márton Németh <nm127@freemail.hu>
| ---
| diff -upr linux-2.6.26-rc5.orig/arch/x86/kernel/io_apic_32.c linux-2.6.26-rc5/arch/x86/kernel/io_apic_32.c
| --- linux-2.6.26-rc5.orig/arch/x86/kernel/io_apic_32.c	2008-06-07 12:35:24.000000000 +0200
| +++ linux-2.6.26-rc5/arch/x86/kernel/io_apic_32.c	2008-06-07 12:40:20.000000000 +0200
| @@ -2217,7 +2217,7 @@ static inline void __init check_timer(vo
| 
|  	if (nmi_watchdog == NMI_IO_APIC) {
|  		printk(KERN_WARNING "timer doesn't work through the IO-APIC - disabling NMI Watchdog!\n");
| -		nmi_watchdog = 0;
| +		nmi_watchdog = NMI_NONE;
|  	}
| 
|  	printk(KERN_INFO "...trying to set up timer as Virtual Wire IRQ...");
| diff -upr linux-2.6.26-rc5.orig/arch/x86/kernel/io_apic_64.c linux-2.6.26-rc5/arch/x86/kernel/io_apic_64.c
| --- linux-2.6.26-rc5.orig/arch/x86/kernel/io_apic_64.c	2008-06-05 18:39:49.000000000 +0200
| +++ linux-2.6.26-rc5/arch/x86/kernel/io_apic_64.c	2008-06-07 12:37:01.000000000 +0200
| @@ -1735,7 +1735,7 @@ static inline void __init check_timer(vo
| 
|  	if (nmi_watchdog == NMI_IO_APIC) {
|  		printk(KERN_WARNING "timer doesn't work through the IO-APIC - disabling NMI Watchdog!\n");
| -		nmi_watchdog = 0;
| +		nmi_watchdog = NMI_NONE;
|  	}
| 
|  	apic_printk(APIC_VERBOSE, KERN_INFO "...trying to set up timer as Virtual Wire IRQ...");
| diff -upr linux-2.6.26-rc5.orig/arch/x86/kernel/nmi_32.c linux-2.6.26-rc5/arch/x86/kernel/nmi_32.c
| --- linux-2.6.26-rc5.orig/arch/x86/kernel/nmi_32.c	2008-06-05 18:39:49.000000000 +0200
| +++ linux-2.6.26-rc5/arch/x86/kernel/nmi_32.c	2008-06-07 11:19:55.000000000 +0200
| @@ -43,7 +43,7 @@ static cpumask_t backtrace_mask = CPU_MA
|   */
|  atomic_t nmi_active = ATOMIC_INIT(0);		/* oprofile uses this */
| 
| -unsigned int nmi_watchdog = NMI_DEFAULT;
| +int nmi_watchdog = NMI_DEFAULT;
|  static unsigned int nmi_hz = HZ;
| 
|  static DEFINE_PER_CPU(short, wd_enabled);
| diff -upr linux-2.6.26-rc5.orig/arch/x86/kernel/nmi_64.c linux-2.6.26-rc5/arch/x86/kernel/nmi_64.c
| --- linux-2.6.26-rc5.orig/arch/x86/kernel/nmi_64.c	2008-06-05 18:39:49.000000000 +0200
| +++ linux-2.6.26-rc5/arch/x86/kernel/nmi_64.c	2008-06-07 11:20:00.000000000 +0200
| @@ -43,7 +43,7 @@ static cpumask_t backtrace_mask = CPU_MA
|  atomic_t nmi_active = ATOMIC_INIT(0);		/* oprofile uses this */
|  static int panic_on_timeout;
| 
| -unsigned int nmi_watchdog = NMI_DEFAULT;
| +int nmi_watchdog = NMI_DEFAULT;
|  static unsigned int nmi_hz = HZ;
| 
|  static DEFINE_PER_CPU(short, wd_enabled);
| diff -upr linux-2.6.26-rc5.orig/include/asm-x86/nmi.h linux-2.6.26-rc5/include/asm-x86/nmi.h
| --- linux-2.6.26-rc5.orig/include/asm-x86/nmi.h	2008-06-05 18:40:12.000000000 +0200
| +++ linux-2.6.26-rc5/include/asm-x86/nmi.h	2008-06-07 11:21:20.000000000 +0200
| @@ -61,7 +61,7 @@ extern void enable_timer_nmi_watchdog(vo
|  extern int nmi_watchdog_tick(struct pt_regs *regs, unsigned reason);
| 
|  extern atomic_t nmi_active;
| -extern unsigned int nmi_watchdog;
| +extern int nmi_watchdog;
|  #define NMI_DISABLED    -1
|  #define NMI_NONE	0
|  #define NMI_IO_APIC	1
| 

We should leave nmi_watchdog as unsigned. The only snippet which
could be reviewed as controversy point  - is touch_nmi_watchdog()
where we just test nmi_watchdog for being greater than 0. Actually
there NMI_NONE should be used instead. But frankly some additional
simplification is needed.

		- Cyrill -
