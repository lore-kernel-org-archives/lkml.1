Return-Path: <linux-kernel-owner+w=401wt.eu-S1753700AbYJ1KLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700AbYJ1KLw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 06:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbYJ1KLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 06:11:42 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:34432 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752277AbYJ1KLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 06:11:41 -0400
Date: Tue, 28 Oct 2008 10:11:06 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: Matthias Kaehlcke <matthias@kaehlcke.net>, kernel@wantstofly.org,
       rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] ep93xx: fix OHCI DMA mask
Message-ID: <20081028101106.GB6099@fluff.org.uk>
References: <20081028081950.GA2930@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081028081950.GA2930@traven>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2008 at 09:19:50AM +0100, Matthias Kaehlcke wrote:
> ep93xx: Fix OHCI DMA mask
> 
> Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>

Did this really have to go to so many people? akpm probably doesn't
need to know of this directly, Russell reads linux-arm-kernel so isn't
really a necessary CC: in this and you missed out the linux-usb list.

> --
> 
> --- linux-2.6.27.org/arch/arm/mach-ep93xx/core.c	2008-10-10 00:13:53.000000000 +0200
> +++ linux-2.6.27/arch/arm/mach-ep93xx/core.c	2008-10-28 08:05:53.000000000 +0100
> @@ -26,6 +26,7 @@
>  #include <linux/serial_core.h>
>  #include <linux/device.h>
>  #include <linux/mm.h>
> +#include <linux/dma-mapping.h>
>  #include <linux/time.h>
>  #include <linux/timex.h>
>  #include <linux/delay.h>
> @@ -450,12 +451,13 @@
>  	},
>  };
>  
> +
>  static struct platform_device ep93xx_ohci_device = {
>  	.name		= "ep93xx-ohci",
>  	.id		= -1,
>  	.dev		= {
> -		.dma_mask		= (void *)0xffffffff,
> -		.coherent_dma_mask	= 0xffffffff,
> +		.dma_mask		= &ep93xx_ohci_device.dev.coherent_dma_mask,
> +		.coherent_dma_mask	= DMA_BIT_MASK(32),
>  	},
>  	.num_resources	= ARRAY_SIZE(ep93xx_ohci_resources),
>  	.resource	= ep93xx_ohci_resources,
> 
> -- 
> Matthias Kaehlcke
> Embedded Linux Engineer
> Barcelona
> 
>             You can chain me, you can torture me, you can even
>           destroy this body, but you will never imprison my mind
>                             (Mahatma Gandhi)
>                                                                  .''`.
>     using free software / Debian GNU/Linux | http://debian.org  : :'  :
>                                                                 `. `'`
> gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
