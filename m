Return-Path: <linux-kernel-owner+w=401wt.eu-S1751822Ab0AZA2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822Ab0AZA2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 19:28:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751299Ab0AZA2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 19:28:47 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:51876 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab0AZA2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 19:28:46 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/QoqYUFnl5XrgiIJZuQ3Rc
Date: Mon, 25 Jan 2010 16:28:32 -0800
From: Tony Lindgren <tony@atomide.com>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       linux-arm-kernel@lists.infradead.org,
       Russell King <linux@arm.linux.org.uk>,
       "Zebediah C. McClure" <zmc@lurian.net>,
       Alistair Buxton <a.j.buxton@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-omap@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] omap: define _toggle_gpio_edge_triggering only for
 OMAP1
Message-ID: <20100126002832.GD2879@atomide.com>
References: <1264280500-22878-2-git-send-email-u.kleine-koenig@pengutronix.de>
 <87sk9u6o4l.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87sk9u6o4l.fsf@deeprootsystems.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kevin Hilman <khilman@deeprootsystems.com> [100125 10:20]:
> Uwe Kleine-König <u.kleine-koenig@pengutronix.de> writes:
> 
> > The only usage of _toggle_gpio_edge_triggering is in an
> > CONFIG_ARCH_OMAP1 is defined, too.
> >
> > This fixes a compiler warning:
> >
> > 	arch/arm/plat-omap/gpio.c:758: warning: '_toggle_gpio_edge_triggering' defined but not used
> >
> > when compiling for ARCH_OMAP2, ARCH_OMAP3 or ARCH_OMAP4.
> >
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> 
> Acked-by: Kevin Hilman <khilman@deeprootsystems.com>

Ack, I'll add this into omap-fixes for the -rc cycle.

Regards,

Tony
 
> > ---
> >  arch/arm/plat-omap/gpio.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm/plat-omap/gpio.c b/arch/arm/plat-omap/gpio.c
> > index d17620c..d2422c7 100644
> > --- a/arch/arm/plat-omap/gpio.c
> > +++ b/arch/arm/plat-omap/gpio.c
> > @@ -750,6 +750,7 @@ static inline void set_24xx_gpio_triggering(struct gpio_bank *bank, int gpio,
> >  }
> >  #endif
> >  
> > +#ifdef CONFIG_ARCH_OMAP1
> >  /*
> >   * This only applies to chips that can't do both rising and falling edge
> >   * detection at once.  For all other chips, this function is a noop.
> > @@ -760,11 +761,9 @@ static void _toggle_gpio_edge_triggering(struct gpio_bank *bank, int gpio)
> >  	u32 l = 0;
> >  
> >  	switch (bank->method) {
> > -#ifdef CONFIG_ARCH_OMAP1
> >  	case METHOD_MPUIO:
> >  		reg += OMAP_MPUIO_GPIO_INT_EDGE;
> >  		break;
> > -#endif
> >  #ifdef CONFIG_ARCH_OMAP15XX
> >  	case METHOD_GPIO_1510:
> >  		reg += OMAP1510_GPIO_INT_CONTROL;
> > @@ -787,6 +786,7 @@ static void _toggle_gpio_edge_triggering(struct gpio_bank *bank, int gpio)
> >  
> >  	__raw_writel(l, reg);
> >  }
> > +#endif
> >  
> >  static int _set_gpio_triggering(struct gpio_bank *bank, int gpio, int trigger)
> >  {
> > -- 
> > 1.6.6
