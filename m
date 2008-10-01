Return-Path: <linux-kernel-owner+w=401wt.eu-S1754285AbYJATon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbYJATon (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 15:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753843AbYJATof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 15:44:35 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:61596 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728AbYJAToe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 15:44:34 -0400
Date: Wed, 1 Oct 2008 12:44:07 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: David Brownell <david-b@pacbell.net>
Cc: Samuel Ortiz <sameo@openedhand.com>, lkml <linux-kernel@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>, Felipe Balbi <felipe.balbi@nokia.com>,
       linux-omap@vger.kernel.org
Subject: Re: [PATCH 2.6.27-rc8 1/2] drivers/mfd/twl4030-core.c
Message-Id: <20081001124407.aa090ccd.randy.dunlap@oracle.com>
In-Reply-To: <200810011144.20510.david-b@pacbell.net>
References: <200810011144.20510.david-b@pacbell.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Oct 2008 11:44:19 -0700 David Brownell wrote:

>  drivers/mfd/Kconfig                |   14 
>  drivers/mfd/Makefile               |    2 
>  drivers/mfd/twl4030-core.c         | 1255 +++++++++++++++++++++++++++++++++++
>  include/linux/i2c/twl4030-gpio.h   |   76 ++
>  include/linux/i2c/twl4030-madc.h   |  134 +++
>  include/linux/i2c/twl4030-pwrirq.h |   37 +
>  include/linux/i2c/twl4030.h        |  191 +++++
>  7 files changed, 1709 insertions(+)
> 
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -50,6 +50,20 @@ config HTC_PASIC3
>  	  HTC Magician devices, respectively. Actual functionality is
>  	  handled by the leds-pasic3 and ds1wm drivers.
>  
> +config TWL4030_CORE
> +	bool "Texas Instruments TWL4030/TPS659x0 Support"
> +	depends on I2C=y && (ARCH_OMAP2 || ARCH_OMAP3)
> +	help
> +	  Say yes here if you have TWL4030 family chip on your board.
> +	  This core driver provides register access and IRQ handling
> +	  facilities, and registers devices for the various functions
> +	  so that function-specific drivers can bind to them.
> +
> +	  These multi-function chps are found on many OMAP2 and OMAP3

	                       chips

> +	  boards, providing power management, RTC, GPIO, keypad, a
> +	  high speed USB OTG transceiver, an audio codec (on most
> +	  versions) and many other features.
> +
>  config MFD_TMIO
>  	bool
>  	default n

> --- /dev/null
> +++ b/include/linux/i2c/twl4030-madc.h
> @@ -0,0 +1,134 @@
> +/*
> + * include/linux/i2c/twl4030-madc.h
> + *
> + * TWL4030 MADC module driver header
> + *
> + * Copyright (C) 2008 Nokia Corporation
> + * Mikko Ylinen <mikko.k.ylinen@nokia.com>


> +#define TWL4030_MADC_IOC_MAGIC '`'

Add that to Documentation/ioctl-number.txt (?)

---
~Randy
