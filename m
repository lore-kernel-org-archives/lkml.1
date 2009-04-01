Return-Path: <linux-kernel-owner+w=401wt.eu-S1765197AbZDAQXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765197AbZDAQXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 12:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756716AbZDAQXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 12:23:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41195 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759460AbZDAQXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 12:23:06 -0400
Date: Wed, 1 Apr 2009 18:22:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       xemul@openvz.org, yhlu.kernel@gmail.com
Subject: Re: [patch 4/6] x86: irqinit - merge native_init_IRQ
Message-ID: <20090401162250.GA22517@elte.hu>
References: <20090329201545.470255691@openvz.org> <20090329202208.155551990@openvz.org> <20090401145328.GB6196@elte.hu> <20090401161609.GD15781@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090401161609.GD15781@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> [Ingo Molnar - Wed, Apr 01, 2009 at 04:53:28PM +0200]
> ...
> | > Index: linux-2.6.git/arch/x86/kernel/setup.c
> | > ===================================================================
> | > --- linux-2.6.git.orig/arch/x86/kernel/setup.c
> | > +++ linux-2.6.git/arch/x86/kernel/setup.c
> | > @@ -1087,3 +1087,11 @@ void __init x86_quirk_time_init(void)
> | >  	setup_irq(0, &irq0);
> | >  }
> | >  #endif /* CONFIG_X86_32 */
> | > +
> | > +#ifdef CONFIG_X86_64
> | > +void x86_quirk_pre_intr_init(void)
> | > +{
> | > +	init_ISA_irqs();
> | > +}
> | > +void x86_quirk_intr_init(void) { }
> | > +#endif
> | 
> | Hm, wouldnt it be cleaner to add it as a new quirk function vector 
> | in struct x86_quirks? See arch/x86/include/asm/setup.h.
> | 
> | 	Ingo
> | 
> 
> I just remember -- I thought about that and since 
> x86_quirk_pre_intr_init described as external BUT implemented for 
> x86-32 only I needed to indroduce new x86-64 versions for this 
> (and since I know that there no need to do anything else except 
> calling init_ISA_irqs I desided to have separate wrapper for 
> that).
> 
> And btw x86-32 already has init_ISA_irqs call and quirks are used 
> in x86-32 mode only so for 64bit it will be just a not needed 
> check. Which means - I could just use original 
> x86_quirk_pre_intr_init function which will call all I need.
> 
> Or you meant something else?

The typical solution there is to make the entry NULL in the 64-bit 
case. All the quirk handlers are conditional like this:

arch/x86/kernel/mpparse.c:      if (x86_quirks->mpc_apic_id)
arch/x86/kernel/mpparse.c:              apicid = x86_quirks->mpc_apic_id(m);

or am i missing something?

	Ingo
