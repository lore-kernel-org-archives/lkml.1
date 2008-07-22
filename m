Return-Path: <linux-kernel-owner+w=401wt.eu-S1753127AbYGVNtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbYGVNtF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 09:49:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750770AbYGVNsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 09:48:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40094 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbYGVNsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 09:48:54 -0400
Date: Tue, 22 Jul 2008 15:48:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yong Wang <yong.y.wang@linux.intel.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Zachary Amsden <zach@vmware.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] x86: APIC: Remove apic_write_around(); use alternatives
Message-ID: <20080722134832.GB21977@elte.hu>
References: <20080718224922.GB4507@linux-os.sc.intel.com> <86802c440807181551l7e6e143dy7cea8ab59f1830ed@mail.gmail.com> <20080718230012.GD4507@linux-os.sc.intel.com> <86802c440807181604y502e7deal98abfeb1ceee769d@mail.gmail.com> <20080718231828.GE4507@linux-os.sc.intel.com> <20080719214944.GC836@elte.hu> <20080719215325.GA12737@elte.hu> <20080720120811.GA16138@elte.hu> <20080721175940.GA14380@linux-os.sc.intel.com> <20080722132401.GA17165@ywang-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080722132401.GA17165@ywang-dev>
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


* Yong Wang <yong.y.wang@linux.intel.com> wrote:

> On Mon, Jul 21, 2008 at 10:59:41AM -0700, Suresh Siddha wrote:
> > Thanks Ingo. I tested tip/master and found an issue (patch attached)
> > for x2apic support. This is not because of the recent merges we had, but
> > because of something(where we still access memory based interface after
> > enabling x2apic mode) that slipped through my earlier tests.
> > 
> > Probably it is a good idea to unmap the memory mapped interface, once we switch
> > to x2apic mode. That will catch the issues much earlier. I will
> > post another patch for this.
> > 
> > Meanwhile, I will do more testing of tip/master along with addressing
> > open issues.
> > ---
> > 
> > [patch] x64, apic: use generic apic_write() for ack_APIC_irq()
> > 
> > ack_APIC_irq() is used at too many generic places (and not just during
> > irq_chip handling!) to use the native_apic_mem_write(). For ex, this will
> > break x2apic based systems.
> > 
> > Fix ack_APIC_irq() to use the generic apic_write() even for 64-bit.
> > 
> > Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> > ---
> > 
> > diff --git a/include/asm-x86/apic.h b/include/asm-x86/apic.h
> > index 300b65e..1df955f 100644
> > --- a/include/asm-x86/apic.h
> > +++ b/include/asm-x86/apic.h
> > @@ -138,11 +138,7 @@ static inline void ack_APIC_irq(void)
> >  	 */
> >  
> >  	/* Docs say use 0 for future compatibility */
> > -#ifdef CONFIG_X86_32
> >  	apic_write(APIC_EOI, 0);
> > -#else
> > -	native_apic_mem_write(APIC_EOI, 0);
> > -#endif
> >  }
> >  
> 
> ACK. I tested this patch on my x2apic capable box and it works well. 
> Without this patch, kernel built from tip/x86/x2apic cannot boot in 
> x2apic mode and all APs got stuck in smp_callin->calibrate_delay and 
> failed to boot. After applying this patch, system boots well and all 
> processors got up and running successfully.

hm, i havent received any email from Suresh since:

   Date: Fri, 18 Jul 2008 16:18:28 -0700

something's broken in the email path ...

Could you please bounce Suresh's patch to me? (the quoted one above is 
whitespace damaged due to the reply)

	Ingo

