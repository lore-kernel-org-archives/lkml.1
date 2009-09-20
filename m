Return-Path: <linux-kernel-owner+w=401wt.eu-S1755635AbZITSyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635AbZITSyv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 14:54:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755596AbZITSyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 14:54:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49467 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755591AbZITSyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 14:54:49 -0400
Date: Sun, 20 Sep 2009 20:43:50 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: lkml@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] [TRIVIAL] Changes to IRQs.
In-Reply-To: <m34oqx4s0e.fsf@intrepid.localdomain>
Message-ID: <alpine.LNX.2.00.0909202042300.17028@wotan.suse.de>
References: <m34oqx4s0e.fsf@intrepid.localdomain>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="168427776-1402753400-1253472231=:17028"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--168427776-1402753400-1253472231=:17028
Content-Type: TEXT/PLAIN; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT

On Sun, 20 Sep 2009, Krzysztof Halasa wrote:

> Trivial changes to IRQs.
> 
> Signed-off-by: Krzysztof Ha³asa <khc@pm.waw.pl>
> 
> diff --git a/Documentation/DocBook/genericirq.tmpl b/Documentation/DocBook/genericirq.tmpl
> index c671a01..1448b33 100644
> --- a/Documentation/DocBook/genericirq.tmpl
> +++ b/Documentation/DocBook/genericirq.tmpl
> @@ -417,8 +417,8 @@ desc->chip->end();
>        </para>
>        <para>
>  	To make use of the split implementation, replace the call to
> -	__do_IRQ by a call to desc->chip->handle_irq() and associate
> -        the appropriate handler function to desc->chip->handle_irq().
> +	__do_IRQ by a call to desc->handle_irq() and associate
> +        the appropriate handler function to desc->handle_irq().
>  	In most cases the generic handler implementations should
>  	be sufficient.
>       </para>
> diff --git a/arch/arm/include/asm/hw_irq.h b/arch/arm/include/asm/hw_irq.h
> index 90831f6..5b4e642 100644
> --- a/arch/arm/include/asm/hw_irq.h
> +++ b/arch/arm/include/asm/hw_irq.h
> @@ -10,14 +10,6 @@ static inline void ack_bad_irq(int irq)
>  	irq_err_count++;
>  }
>  
> -/*
> - * Obsolete inline function for calling irq descriptor handlers.
> - */
> -static inline void desc_handle_irq(unsigned int irq, struct irq_desc *desc)
> -{
> -	desc->handle_irq(irq, desc);
> -}
> -
>  void set_irq_flags(unsigned int irq, unsigned int flags);
>  
>  #define IRQF_VALID	(1 << 0)
> diff --git a/arch/arm/plat-orion/gpio.c b/arch/arm/plat-orion/gpio.c
> index e814803..85f305a 100644
> --- a/arch/arm/plat-orion/gpio.c
> +++ b/arch/arm/plat-orion/gpio.c
> @@ -354,6 +354,6 @@ void orion_gpio_irq_handler(int pinoff)
>  			polarity ^= 1 << (pin & 31);
>  			writel(polarity, GPIO_IN_POL(pin));
>  		}
> -		desc_handle_irq(irq, desc);
> +		desc->handle_irq(irq, desc);
>  	}
>  }
> diff --git a/include/linux/irq.h b/include/linux/irq.h
> index cb2e77a..b0424fe 100644
> --- a/include/linux/irq.h
> +++ b/include/linux/irq.h
> @@ -281,7 +281,7 @@ extern irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action);
>  
>  /*
>   * Built-in IRQ handlers for various IRQ types,
> - * callable via desc->chip->handle_irq()
> + * callable via desc->handle_irq()
>   */
>  extern void handle_level_irq(unsigned int irq, struct irq_desc *desc);
>  extern void handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc);
> 

This doesn't really qualify for trivial queue, adding ARM addressess to CC 
(I hope I got them right after the latest flame :P) at least for the ARM 
bits.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
--168427776-1402753400-1253472231=:17028--

