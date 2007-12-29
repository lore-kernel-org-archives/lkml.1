Return-Path: <linux-kernel-owner+w=401wt.eu-S1756102AbXL2G6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102AbXL2G6q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 01:58:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbXL2G6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 01:58:39 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:48339 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbXL2G6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 01:58:38 -0500
Date: Sat, 29 Dec 2007 07:58:37 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Jean Delvare <khali@linux-fr.org>, eric miao <eric.y.miao@gmail.com>
Subject: Re: [patch 2.6.24-rc6-mm 1/9] gpiolib: add drivers/gpio directory
Message-ID: <20071229065837.GB16569@uranus.ravnborg.org>
References: <200712281927.32575.david-b@pacbell.net> <200712281953.20103.david-b@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712281953.20103.david-b@pacbell.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David.

> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -5,6 +5,7 @@
>  # Rewritten to use lists instead of if-statements.
>  #
>  
> +obj-$(CONFIG_GPIO_LIB)		+= gpio/
>  obj-$(CONFIG_PCI)		+= pci/
>  obj-$(CONFIG_PARISC)		+= parisc/
>  obj-$(CONFIG_RAPIDIO)		+= rapidio/
> --- /dev/null
> +++ b/drivers/gpio/Kconfig
> @@ -0,0 +1,32 @@
> +#
> +# GPIO infrastructure and expanders
> +#
> +
> +config GPIO_LIB
> +	bool
> +	help
> +	  Platforms select gpiolib if they use this infrastructure
> +	  for all their GPIOs, usually starting with ones integrated
> +	  into SOC processors.
> +

kconfig symbols that are "select" targets should be named "HAVE_" so in
this case you could use HAVE_GPIO_LIB.
This is by convention only but introduced to make it visible that this is
a config symbol supposed to be selected.

Then on top of that the HAVE_ symbols should not have any dependencies
so we avoid that "select" selects a symbol where the dependencies are
not fulfilled.

In your case you could just use
obj-y += gpio/

in the Makefile and then there is no need to actually reference the
kconfig symbol.

> --- /dev/null
> +++ b/drivers/gpio/Makefile
> @@ -0,0 +1,6 @@
> +# gpio support: dedicated expander chips, etc
> +
> +ifeq ($(CONFIG_DEBUG_GPIO),y)
> +EXTRA_CFLAGS += -DDEBUG
> +endif

Use of EXTRA_CFLAGS are deprecated. Please use:
ccflags-$(CONFIG_DEBUG_GPIO) := -DDEBUG

	Sam
