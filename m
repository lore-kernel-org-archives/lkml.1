Return-Path: <linux-kernel-owner+w=401wt.eu-S1760319AbXFJQaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760319AbXFJQaa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 12:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753618AbXFJQaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 12:30:23 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43106 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbXFJQaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 12:30:23 -0400
Subject: Re: [patch-mm 21/23] x86-64 block irq balancing for timer
From: Arjan van de Ven <arjan@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <20070610092447.149863776@inhelltoy.tec.linutronix.de>
References: <20070610092437.118387863@inhelltoy.tec.linutronix.de>
	 <20070610092447.149863776@inhelltoy.tec.linutronix.de>
Content-Type: text/plain
Organization: Intel International BV
Date: Sun, 10 Jun 2007 09:29:20 -0700
Message-Id: <1181492960.2809.1.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-1.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

this isn't needed actually.. the userspace irq balancer won't balance
irq 0 anyway, and if the sysadmin has a REAL good reason to move this
himself... then why shouldn't we let him?



On Sun, 2007-06-10 at 09:44 +0000, Thomas Gleixner wrote:
> plain text document attachment
> (x86-64-clockevents-irq-balancing.patch)
> From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
> 
> Disable irq balancing on IRQ0.
> 
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Andi Kleen <ak@suse.de>
> 
> ---
>  arch/x86_64/kernel/time.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6.22-rc4-mm/arch/x86_64/kernel/time.c
> ===================================================================
> --- linux-2.6.22-rc4-mm.orig/arch/x86_64/kernel/time.c	2007-06-10 10:44:39.000000000 +0200
> +++ linux-2.6.22-rc4-mm/arch/x86_64/kernel/time.c	2007-06-10 10:44:40.000000000 +0200
> @@ -255,7 +255,7 @@ static unsigned int __init tsc_calibrate
>  
>  static struct irqaction irq0 = {
>  	.handler	= timer_interrupt,
> -	.flags		= IRQF_DISABLED | IRQF_IRQPOLL,
> +	.flags		= IRQF_DISABLED | IRQF_IRQPOLL | IRQF_NOBALANCING,
>  	.mask		= CPU_MASK_NONE,
>  	.name		= "timer"
>  };

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

