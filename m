Return-Path: <linux-kernel-owner+w=401wt.eu-S1756407AbXL2HKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407AbXL2HKb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 02:10:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbXL2HKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 02:10:24 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:52497 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbXL2HKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 02:10:24 -0500
Date: Sat, 29 Dec 2007 08:10:23 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       eric miao <eric.y.miao@gmail.com>
Subject: Re: [patch 2.6.24-rc6-mm 2/9] gpiolib: add gpio provider infrastructure
Message-ID: <20071229071023.GC16569@uranus.ravnborg.org>
References: <200712281927.32575.david-b@pacbell.net> <200712281954.34704.david-b@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712281954.34704.david-b@pacbell.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David.

> +/* Warn when drivers omit gpio_request() calls -- legal but ill-advised
> + * when setting direction, and otherwise illegal.  Until board setup code
> + * and drivers use explicit requests everywhere (which won't happen when
> + * those calls have no teeth) we can't avoid autorequesting.  This nag
> + * message should motivate switching to explicit requests...
> + */
> +static void gpio_ensure_requested(struct gpio_desc *desc)
> +{
> +	if (test_and_set_bit(FLAG_REQUESTED, &desc->flags) == 0) {
> +		pr_warning("GPIO-%d autorequested\n", (int)(desc - gpio_desc));
> +#ifdef CONFIG_DEBUG_FS
> +		desc->label = "[auto]";
> +#endif
> +	}
For this an the other setters of desc->label a small helper function
would be better. The helper function could then contain the necessary
ifdef in only one place.


> --- at91.orig/include/asm-generic/gpio.h
> +++ at91/include/asm-generic/gpio.h
> +
> +extern const char *gpiochip_is_requested(struct gpio_chip *chip,
> +			unsigned offset);
> +
> +/* add/remove chips */
> +extern int gpiochip_add(struct gpio_chip *chip);
> +extern int __must_check gpiochip_remove(struct gpio_chip *chip);

The use of "extern" is not needed in .h files for function prototypes.

	Sam
