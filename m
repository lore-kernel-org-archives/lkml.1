Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934613Ab0CLVHn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 16:07:43 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35286 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933167Ab0CLVHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 16:07:41 -0500
Date: Fri, 12 Mar 2010 13:07:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Bill Gatliff <bgat@billgatliff.com>,
       Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] of/gpio: Implement GPIOLIB notifier hooks
Message-Id: <20100312130723.43308ccd.akpm@linux-foundation.org>
In-Reply-To: <20100205203236.GC1475@oksana.dev.rtsoft.ru>
References: <20100205203201.GA32281@oksana.dev.rtsoft.ru>
	<20100205203236.GC1475@oksana.dev.rtsoft.ru>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Feb 2010 23:32:36 +0300
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> This patch implements GPIOLIB notifier hooks, and thus makes device-enabled
> GPIO chips (i.e. the ones that have gpio_chip->dev specified) automatically
> attached to the OpenFirmware subsystem. Which means that now we can handle
> I2C and SPI GPIO chips almost* transparently.
> 
> ...
>
> +static int of_gpiochip_register_simple(struct gpio_chip *chip,
> +				       struct device_node *np)

Why is this called "register_simple" but the unregistration function
isn't called "unregister_simple"?

> +{
> +	struct of_gpio_chip *of_gc;
> +
> +	if (np->data) {
> +		WARN_ON(1);
> +		return -EBUSY;
> +	}
> +
> +	of_gc = kzalloc(sizeof(*of_gc), GFP_KERNEL);
> +	if (!of_gc)
> +		return -ENOMEM;
> +
> +	of_gc->gpio_cells = 2;
> +	of_gc->xlate = of_gpio_simple_xlate;
> +	of_gc->chip = chip;
> +	np->data = of_gc;
> +	of_node_get(np);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(of_gpiochip_register_simple);

Makes no sense to export a static symbol and to provide no declaration
of it in a .h file.  I assume the export was unintended.


My plot is somewhat lost.  Grant, could you please summarise in
easy-for-akpm-to-understand terms what your issues are with this
patchset and how you think we should proceed?

Thanks.
