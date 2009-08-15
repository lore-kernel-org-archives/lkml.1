Return-Path: <linux-kernel-owner+w=401wt.eu-S1752092AbZHOUBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbZHOUBc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 16:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbZHOUBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 16:01:31 -0400
Received: from www.tglx.de ([62.245.132.106]:34333 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbZHOUBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 16:01:30 -0400
Date: Sat, 15 Aug 2009 22:00:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Trilok Soni <soni.trilok@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Brian Swetland <swetland@google.com>,
       Joonyoung Shim <jy0922.shim@samsung.com>, m.szyprowski@samsung.com,
       t.fujak@samsung.com, kyungmin.park@samsung.com,
       David Brownell <david-b@pacbell.net>, Daniel Ribeiro <drwyrm@gmail.com>,
       arve@android.com, Barry Song <21cnbao@gmail.com>
Subject: Re: [RFC patch 1/3] genirq: Add oneshot support
In-Reply-To: <20090815201354.835D3526EA5@mailhub.coreip.homeip.net>
Message-ID: <alpine.LFD.2.00.0908152150370.1283@localhost.localdomain>
References: <20090815174512.491425246@linutronix.de> <20090815174537.895842412@linutronix.de> <20090815201354.835D3526EA5@mailhub.coreip.homeip.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry,

On Sat, 15 Aug 2009, Dmitry Torokhov wrote:
> Hi Thomas,
> 
> On Sat, Aug 15, 2009 at 05:48:33PM -0000, Thomas Gleixner wrote:
> >  
> >  /**
> > + *	irq_oneshot_primary_handler - Handle oneshot interrupt primary handler
> > + *	@irq:		the interrupt number
> > + *	@dev_id:	cookie to identify the device
> > + *
> > + *	For oneshot interrupts which keep the interrupt line masked
> > + *	until the threaded handler has been executed, the only
> > + *	functionality of the primary handler is to return
> > + *	IRQ_WAKE_THREAD. This is the generic implementation which
> > + *	avoids lots of duplicates all over the place
> > + */
> > +irqreturn_t irq_oneshot_primary_handler(int irq, void *dev_id)
> > +{
> > +	return IRQ_WAKE_THREAD;
> > +}
> > +EXPORT_SYMBOL_GPL(irq_oneshot_primary_handler);
> 
> This kind of handler is useful not only for users of oneshot interrupts
> but also other drivers using threaded IRQs. So maybe we should rename it
> to default_threaded_irq_handler() and instead of exporting it simply
> have it installed automatically when driver requests NULL in place of
> IRQ handler in request_threaded_irq()?

Good point. If handler == NULL and thread_fn != NULL. That's
reasonable. Will rework.
 
> Also, if IRQF_ONESHOT definition would make into mainline sooner than
> later that would be great - then I'd be able to put all the drivers that
> will end up using it into my next branch and not be concerned of
> breaking linux-next.

Hmm, the ONESHOT definition alone won't give you the testing you
want. If all involved folks agree on the patch series I can commit it
into a standalone branch which can be pulled into the development
branches of interested driver maintainers. Git will deal with that
just fine.

@Andrew: any opinion on that ?

Thanks,

	tglx
