Return-Path: <linux-kernel-owner+w=401wt.eu-S1758617AbYKWNgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617AbYKWNgg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 08:36:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756725AbYKWNg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 08:36:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53689 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756292AbYKWNg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 08:36:26 -0500
Date: Sun, 23 Nov 2008 14:36:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dimitri Sivanich <sivanich@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 2/2 v3] SGI RTC: add generic timer system interrupt
Message-ID: <20081123133604.GI1178@elte.hu>
References: <20081023163041.GA14574@sgi.com> <20081119212202.GA3377@sgi.com> <20081119212350.GB3377@sgi.com> <20081119212631.GC3377@sgi.com> <20081120151208.f7892050.akpm@linux-foundation.org> <4925F095.40107@zytor.com> <20081121171537.GA12370@sgi.com> <4926FD58.7000406@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4926FD58.7000406@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> Dimitri Sivanich wrote:
> > 
> > There are basically two issues with using 'normal IRQs' in cases like this:
> > 
> > - Using normal IRQs would mean we would have an IRQ per cpu.  The current
> >   hard coded maximum, NR_IRQS, is 4352 (NR_VECTORS + (32 * MAX_IO_APICS)).
> >   On machines with large numbers of cpus and an irq per cpu for each desired
> >   interrupt, that's a lot of IRQs.  In addition, the GRU, will need 2 such
> >   IRQs per cpu.  On 4096 cpu systems, you've already used up more than the
> >   limit just for that.  Until some sort of infrastructure change takes place
> >   that would potentially allow this to be dynamically increased, such as
> >   Yinghai Lu's "sparse_irq aka dyn_irq v14" patch, this problem will exist.
> >   
> >   Furthermore, the actual runtime limit, nr_irqs, is set to 96 by
> >   probe_nr_irqs for our configuration.  This is because that code assumes all
> >   vectors are io-apic vectors, not cpu centric vectors like the ones I'm
> >   talking about.  With the current, scheme, even on a 128 cpu system, I'm out
> >   of IRQs immediately.
> > 
> > - The current infrastructure for requesting vector/IRQ combinations doesn't
> >   allow one to request an interrupt priority higher than i/o device interrupt
> >   priorities.  Clock event (high resolution timer) code should run at higher
> >   interrupt priority.
> 
> Okay, so it is a hack pending us taking care of issues in the 
> current code.  #1 we're obviously working on, #2 I need to think 
> some more about but shouldn't be too hard to fix -- if real, it also 
> affects other interrupt-driven clock sources.
> 
> I'm OK with this being a temporary hack, but I want it to be 
> recognized as such and cleaned up as soon as possible.

okay.

Dimitri, looks like there are no blocker issues - John's clocksource 
comments need to be addressed and then we should be green to go for 
having this applied.

	Ingo
