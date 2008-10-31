Return-Path: <linux-kernel-owner+w=401wt.eu-S1752484AbYJaRgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484AbYJaRgk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 13:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750822AbYJaRgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 13:36:32 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:3332 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbYJaRgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 13:36:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JLGU00AqZpiJVQfZSGnHV9uFLAVK7ioQxM46Mh127I1hF9lmZFhx85dhCWNWTX2RsW
         Dnx2q47xHejZGVuu39eers0MNfKbvPwWBhqyMynR4SuNjcUnBDDBv3AQL9Rv686Ep4hQ
         BrAU9lZlmJaUJp2V836k4V08x8uf1jYkc/Z4U=
Date: Fri, 31 Oct 2008 20:30:10 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix compile breakage caused by
	2ae111cdd8d83ebf9de72e36e68a8c84b6ebbeea
Message-ID: <20081031173010.GA20803@localhost>
References: <1225400664.19324.16.camel@localhost.localdomain> <20081030220653.GK30303@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081030220653.GK30303@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Thu, Oct 30, 2008 at 11:06:53PM +0100]
| 
| * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
| 
| > >From bd011c0cc51ce1fbab95403a570a8b47ad6ba500 Mon Sep 17 00:00:00 2001
| > From: James Bottomley <James.Bottomley@HansenPartnership.com>
| > Date: Wed, 29 Oct 2008 11:19:49 -0500
| > Subject: [VOYAGER] x86: Fix subarch compile breakage
| > 
| > commit 2ae111cdd8d83ebf9de72e36e68a8c84b6ebbeea
| > Author: Cyrill Gorcunov <gorcunov@gmail.com>
| > Date:   Mon Aug 11 18:34:08 2008 +0400
| > 
| >     x86: apic interrupts - move assignments to irqinit_32.c, v2
| > 
| > Wrongly moved irq2 setup out of the mach-default/setup.c file.  This
| > causes a breakage on voyager which needs its own version.  Fix by
| > moving it back again.
| > 
| > Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
| > ---
| >  arch/x86/kernel/irqinit_32.c  |   12 ------------
| >  arch/x86/mach-default/setup.c |   12 ++++++++++++
| >  2 files changed, 12 insertions(+), 12 deletions(-)
| > 
| > diff --git a/arch/x86/kernel/irqinit_32.c b/arch/x86/kernel/irqinit_32.c
| > index 845aa98..3928784 100644
| > --- a/arch/x86/kernel/irqinit_32.c
| > +++ b/arch/x86/kernel/irqinit_32.c
| > @@ -81,15 +81,6 @@ void __init init_ISA_irqs (void)
| >  	}
| >  }
| >  
| > -/*
| > - * IRQ2 is cascade interrupt to second interrupt controller
| > - */
| > -static struct irqaction irq2 = {
| > -	.handler = no_action,
| > -	.mask = CPU_MASK_NONE,
| > -	.name = "cascade",
| > -};
| > -
| >  DEFINE_PER_CPU(vector_irq_t, vector_irq) = {
| >  	[0 ... IRQ0_VECTOR - 1] = -1,
| >  	[IRQ0_VECTOR] = 0,
| > @@ -167,9 +158,6 @@ void __init native_init_IRQ(void)
| >  	alloc_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
| >  #endif
| >  
| > -	if (!acpi_ioapic)
| > -		setup_irq(2, &irq2);
| > -
| >  	/* setup after call gates are initialised (usually add in
| >  	 * the architecture specific gates)
| >  	 */
| > diff --git a/arch/x86/mach-default/setup.c b/arch/x86/mach-default/setup.c
| > index 37b9ae4..53b4202 100644
| > --- a/arch/x86/mach-default/setup.c
| > +++ b/arch/x86/mach-default/setup.c
| > @@ -38,6 +38,15 @@ void __init pre_intr_init_hook(void)
| >  	init_ISA_irqs();
| >  }
| >  
| > +/*
| > + * IRQ2 is cascade interrupt to second interrupt controller
| > + */
| > +static struct irqaction irq2 = {
| > +	.handler = no_action,
| > +	.mask = CPU_MASK_NONE,
| > +	.name = "cascade",
| > +};
| > +
| >  /**
| >   * intr_init_hook - post gate setup interrupt initialisation
| >   *
| > @@ -53,6 +62,9 @@ void __init intr_init_hook(void)
| >  		if (x86_quirks->arch_intr_init())
| >  			return;
| >  	}
| > +	if (!acpi_ioapic)
| > +		setup_irq(2, &irq2);
| > +
| >  }
| 
| hm, this change looks backwards (doubly so ;-).
| 
| Is the build problem caused by the lack of the acpi_ioapic flag on 
| Voyager?
| 
| 	Ingo
| 

James, how about to use x86_quirks->arch_intr_init() for this?
Wouldn't it be more convenient?

(I was trying to reproduce this bug -- so I fetched latest tip/master
 since there a lot of your fixes already should be

	commit dda51106620c328b50007c259b9ef8cea2b7c3d2
	Merge: 3391961... a376f30...
	Author: Ingo Molnar <mingo@elte.hu>
	Date:   Fri Oct 31 11:03:54 2008 +0100

	    Merge branch 'x86/cleanups'

but eventually I've got build-bug-storm and gave up :-)

		- Cyrill -
