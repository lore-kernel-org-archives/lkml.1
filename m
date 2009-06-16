Return-Path: <linux-kernel-owner+w=401wt.eu-S1755091AbZFPEVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091AbZFPEVg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 00:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbZFPEVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 00:21:17 -0400
Received: from tango.tkos.co.il ([62.219.50.35]:45742 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100AbZFPEVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 00:21:14 -0400
Date: Tue, 16 Jun 2009 07:20:09 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH v5] gpio: driver for PrimeCell PL061 GPIO controller
Message-ID: <20090616042008.GA2794@jasper.tkos.co.il>
References: <1244708976-22122-1-git-send-email-baruch@tkos.co.il> <200906151629.11350.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200906151629.11350.david-b@pacbell.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Thank you very much for your review.

On Mon, Jun 15, 2009 at 04:29:11PM -0700, David Brownell wrote:
> On Thursday 11 June 2009, Baruch Siach wrote:
> > +static unsigned int pl061_irq_startup(unsigned irq)
> > +{
> > +       if (gpio_request(irq_to_gpio(irq), "IRQ") == 0)
> > +               pr_warning("%s: warning: GPIO%d has not been requested\n",
> > +                               __func__, irq_to_gpio(irq));
> 
> No, that's the responsibility of whoever is setting this up.

The gpio_request() here is only for warning. It is expected to fail. Should I 
remove it? Shouldn't there be an is_gpio_requested() as part of gpiolib?

> Normally, platform setup code would request the GPIO since it's
> being dedicated to some task on the board ... and then pass the
> gpio_to_irq() value as a device resource, or maybe the GPIO itself
> (if the driver had to deal with GPIOs per se).
> 
> Also, irq_to_gpio() can be problematic in some systems; avoid it.

I use irq_to_gpio() extensively to implement the enable/disable etc. methods 
of irq_chip. Is there a way to implement them without irq_to_gpio()?

> > +
> > +       pl061_irq_enable(irq);
> > +
> > +       return 0;
> > +}
> 
> Remove that gpio_request(), and the irq_to_gpio(), and you get:
> 
> Acked-by: David Brownell <dbrownell@users.sourceforge.net>

Thanks,

Baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
