Return-Path: <linux-kernel-owner+w=401wt.eu-S1754961AbZBRAda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961AbZBRAda (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 19:33:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbZBRAdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 19:33:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50230 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751479AbZBRAdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 19:33:22 -0500
Date: Tue, 17 Feb 2009 16:29:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: openwrt-devel@lists.openwrt.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcm47xx: Fix GPIO API return codes
Message-Id: <20090217162918.d88bc543.akpm@linux-foundation.org>
In-Reply-To: <200902142127.19521.mb@bu3sch.de>
References: <200902142127.19521.mb@bu3sch.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Feb 2009 21:27:19 +0100
Michael Buesch <mb@bu3sch.de> wrote:

> The GPIO API is supposed to return 0 or a negative error code,
> but the SSB GPIO functions return the bitmask of the GPIO register.
> Fix this by ignoring the bitmask and always returning 0. The SSB GPIO functions can't fail.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
> ---
> 
> Index: linux-2.6/arch/mips/include/asm/mach-bcm47xx/gpio.h
> ===================================================================
> --- linux-2.6.orig/arch/mips/include/asm/mach-bcm47xx/gpio.h	2009-01-01 19:27:06.000000000 +0100
> +++ linux-2.6/arch/mips/include/asm/mach-bcm47xx/gpio.h	2009-02-14 21:26:14.000000000 +0100
> @@ -31,24 +31,28 @@ static inline void gpio_set_value(unsign
>  
>  static inline int gpio_direction_input(unsigned gpio)
>  {
> -	return ssb_gpio_outen(&ssb_bcm47xx, 1 << gpio, 0);
> +	ssb_gpio_outen(&ssb_bcm47xx, 1 << gpio, 0);
> +	return 0;
>  }
>  
>  static inline int gpio_direction_output(unsigned gpio, int value)
>  {
> -	return ssb_gpio_outen(&ssb_bcm47xx, 1 << gpio, 1 << gpio);
> +	ssb_gpio_outen(&ssb_bcm47xx, 1 << gpio, 1 << gpio);
> +	return 0;
>  }
>  
> -static int gpio_intmask(unsigned gpio, int value)
> +static inline int gpio_intmask(unsigned gpio, int value)
>  {
> -	return ssb_gpio_intmask(&ssb_bcm47xx, 1 << gpio,
> -				value ? 1 << gpio : 0);
> +	ssb_gpio_intmask(&ssb_bcm47xx, 1 << gpio,
> +			 value ? 1 << gpio : 0);
> +	return 0;
>  }
>  
> -static int gpio_polarity(unsigned gpio, int value)
> +static inline int gpio_polarity(unsigned gpio, int value)
>  {
> -	return ssb_gpio_polarity(&ssb_bcm47xx, 1 << gpio,
> -				 value ? 1 << gpio : 0);
> +	ssb_gpio_polarity(&ssb_bcm47xx, 1 << gpio,
> +			  value ? 1 << gpio : 0);
> +	return 0;
>  }

What are the consequences of the bug which you fixed?  User-visible
runtime failures?  Something else?

Please always include this information in the changelogs - without it I
cannot make which-kernel-needs-this decisions.


