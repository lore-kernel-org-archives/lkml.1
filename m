Return-Path: <linux-kernel-owner+w=401wt.eu-S1754252AbXDPUre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252AbXDPUre (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 16:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255AbXDPUre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 16:47:34 -0400
Received: from mx33.mail.ru ([194.67.23.194]:13802 "EHLO mx33.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753642AbXDPUrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 16:47:33 -0400
Date: Tue, 17 Apr 2007 00:43:32 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org
Subject: Re: [PATCH 2/7] [RFC] Common power driver for Linux gadgets
Message-ID: <20070416204332.GA4978@zarina>
Reply-To: cbou@mail.ru
References: <20070411232456.GB20095@zarina> <20070413135001.GD20618@zarina> <20070416201615.GB19713@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070416201615.GB19713@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2007 at 09:16:15PM +0100, Russell King wrote:
> On Fri, Apr 13, 2007 at 05:50:01PM +0400, Anton Vorontsov wrote:
> > +/*
> > + * include/linux/ioport.h does not provide flags for generic IRQ trigger
> > + * types. So, we're using "ISA PnP IRQ specific bits", and converting them.
> > + */
> > +static unsigned int get_irq_flags(struct resource *res)
> > +{
> > +	unsigned int flags = IRQF_DISABLED;
> > +
> > +	if (res->flags & IORESOURCE_IRQ_HIGHEDGE)
> > +		flags |= IRQF_TRIGGER_RISING;
> > +	if (res->flags & IORESOURCE_IRQ_LOWEDGE)
> > +		flags |= IRQF_TRIGGER_FALLING;
> > +	if (res->flags & IORESOURCE_IRQ_HIGHLEVEL)
> > +		flags |= IRQF_TRIGGER_HIGH;
> > +	if (res->flags & IORESOURCE_IRQ_LOWLEVEL)
> > +		flags |= IRQF_TRIGGER_LOW;
> > +	if (res->flags & IORESOURCE_IRQ_SHAREABLE)
> > +		flags |= IRQF_SHARED;
> > +
> > +	return flags;
> > +}
> 
> Eww.  The IORESOURCE IRQ bits are intentionally chosen to be the same as
> the IRQF bits:

> include/linux/interrupt.h:
> /*
>  * These correspond to the IORESOURCE_IRQ_* defines in

Yeah, few days ago I noticed it myself, already fixed it in my tree.
Thanks anyway.

>  * linux/ioport.h to select the interrupt line behaviour.  When
>  * requesting an interrupt without specifying a IRQF_TRIGGER, the
>  * setting should be assumed to be "as already configured", which
>  * may be as per machine or firmware initialisation.
>  */
> 
> The exception is IRQF_SHARED which should be a _driver_ choice not a
> _platform_ choice, and therefore makes no sense in your "get_irq_flags"
> definition.

Ugh, I see...

> Plus, if we ever did want to introduce such a function, it should be
> a generic thing, not specific to some random power subsystem de jour.
> 
> -- 
> Russell King
>  Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
>  maintainer of:
> 

Thanks for comments.

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.org/bd2
