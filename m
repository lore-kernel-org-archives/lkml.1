Return-Path: <linux-kernel-owner+w=401wt.eu-S1760694AbZFJRH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760694AbZFJRH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 13:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756702AbZFJRHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 13:07:14 -0400
Received: from exprod6og112.obsmtp.com ([64.18.1.29]:42591 "HELO
	exprod6og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754998AbZFJRHN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 13:07:13 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH] gpiolib: add gpio_request/free_irq
Date: Wed, 10 Jun 2009 13:07:12 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901917356@mi8nycmail19.Mi8.com>
In-Reply-To: <200906091756.11839.david-b@pacbell.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] gpiolib: add gpio_request/free_irq
Thread-Index: AcnpZkgHPaDE2V9rT1GFKGuDE0tGzAAg/iEg
References: <200906051151.05779.hartleys@visionengravers.com> <200906052219.47888.david-b@pacbell.net> <BD79186B4FD85F4B8E60E381CAEE19090191701F@mi8nycmail19.Mi8.com> <200906091756.11839.david-b@pacbell.net>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "David Brownell" <david-b@pacbell.net>
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 10 Jun 2009 17:07:13.0668 (UTC) FILETIME=[E646A440:01C9E9ED]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 09, 2009 5:56 PM, David Brownell wrote:
> On Tuesday 09 June 2009, H Hartley Sweeten wrote:
> > On Friday, June 05, 2009 10:20 PM, David Brownell wrote:
> > > On Friday 05 June 2009, H Hartley Sweeten wrote:
> > > Add support functions to gpiolib to request/free gpio irqs.
> > > 
> > > I'm not keen on this.
> > > 
> > >  - At best it's a convenience layer ... for something that's
> > >    not the least bit awkward to do otherwise.
> > 
> > 		... deletia ...
> > 
> > >  - Coupling it to gpiolib sort of defeats the point of saying
> > >    that gpiolib is just an *implementation* of the interface.
> > >    Where's the code to run for non-gpiolib platforms?
> > > 
> 
> There are three kinds of config to be concerned with:
> 
>  - Platform doesn't support the GPIO calls at all.  In those
>    cases, drivers using <linux/gpio.h> get NOP stubs; you have
>    this case covered.
> 
>  - Platforms supporting the calls but not using gpiolib.
>    That's the case I pointed out -- you don't handle it.
> 

Ah.. Missed that point. I assume this is when GENERIC_GPIO=y
but GPIOLIB (ARCH_REQUIRE_GPIOLIB?) is not defined. Correct?

I'll continue looking it over to see if there is clean way to handle
that case.

>  - Platforms supporting the calls with gpiolib.  This is the
>    other case you handle.


> > >  - Since it implicitly couples gpio_request() to a flavor of
> > >    request_irq(), it precludes sharing those IRQs.
> > > 
> > 
> > Can't the IRQ be shared by passing IRQF_SHARED as one of the flags?
> 
> Only one of them will be able to gpio_request(), so it
> doesn't matter at all what you say to request_irq().

But the gpio_request() is for a given gpio, which can only be requested
once.  The request_irq() call is using the irq value returned by
gpio_to_irq() which could return the same irq number for multiple irq's,
wouldn't these then get shared as long as the IRQF_SHARED flag is set?

> > > Basically, board setup can know that the GPIO is being used
> > > as an IRQ, and do the request()/direction_input() before it
> > > passes gpio_to_irq() to the driver. That's worked in every
> > > case I've happened across so far...
> > 
> > I agree it works as-is right now.  I just thought this would be a
> > convenient wrapper to handle a common setup step.  If it's overkill
> > or not appropriate to add to gpiolib please disregard the patch.

Thanks for your comments,
Hartley
