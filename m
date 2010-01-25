Return-Path: <linux-kernel-owner+w=401wt.eu-S1754091Ab0AYSXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab0AYSXO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 13:23:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753939Ab0AYSXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 13:23:13 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:34640 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477Ab0AYSXN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 13:23:13 -0500
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, Tony Lindgren <tony@atomide.com>,
       Russell King <linux@arm.linux.org.uk>,
       "Zebediah C. McClure" <zmc@lurian.net>,
       Alistair Buxton <a.j.buxton@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-omap@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] omap: define _toggle_gpio_edge_triggering only for OMAP1
References: <1264280500-22878-2-git-send-email-u.kleine-koenig@pengutronix.de>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Mon, 25 Jan 2010 10:22:18 -0800
In-Reply-To: <1264280500-22878-2-git-send-email-u.kleine-koenig@pengutronix.de> ("Uwe
 =?iso-8859-1?Q?Kleine-K=F6nig=22's?= message of "Sat\, 23 Jan 2010
 22\:01\:40 +0100")
Message-ID: <87sk9u6o4l.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uwe Kleine-König <u.kleine-koenig@pengutronix.de> writes:

> The only usage of _toggle_gpio_edge_triggering is in an
> CONFIG_ARCH_OMAP1 is defined, too.
>
> This fixes a compiler warning:
>
> 	arch/arm/plat-omap/gpio.c:758: warning: '_toggle_gpio_edge_triggering' defined but not used
>
> when compiling for ARCH_OMAP2, ARCH_OMAP3 or ARCH_OMAP4.
>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Acked-by: Kevin Hilman <khilman@deeprootsystems.com>

> ---
>  arch/arm/plat-omap/gpio.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/plat-omap/gpio.c b/arch/arm/plat-omap/gpio.c
> index d17620c..d2422c7 100644
> --- a/arch/arm/plat-omap/gpio.c
> +++ b/arch/arm/plat-omap/gpio.c
> @@ -750,6 +750,7 @@ static inline void set_24xx_gpio_triggering(struct gpio_bank *bank, int gpio,
>  }
>  #endif
>  
> +#ifdef CONFIG_ARCH_OMAP1
>  /*
>   * This only applies to chips that can't do both rising and falling edge
>   * detection at once.  For all other chips, this function is a noop.
> @@ -760,11 +761,9 @@ static void _toggle_gpio_edge_triggering(struct gpio_bank *bank, int gpio)
>  	u32 l = 0;
>  
>  	switch (bank->method) {
> -#ifdef CONFIG_ARCH_OMAP1
>  	case METHOD_MPUIO:
>  		reg += OMAP_MPUIO_GPIO_INT_EDGE;
>  		break;
> -#endif
>  #ifdef CONFIG_ARCH_OMAP15XX
>  	case METHOD_GPIO_1510:
>  		reg += OMAP1510_GPIO_INT_CONTROL;
> @@ -787,6 +786,7 @@ static void _toggle_gpio_edge_triggering(struct gpio_bank *bank, int gpio)
>  
>  	__raw_writel(l, reg);
>  }
> +#endif
>  
>  static int _set_gpio_triggering(struct gpio_bank *bank, int gpio, int trigger)
>  {
> -- 
> 1.6.6
