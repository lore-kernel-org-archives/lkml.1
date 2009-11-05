Return-Path: <linux-kernel-owner+w=401wt.eu-S1756001AbZKENE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001AbZKENE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 08:04:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755881AbZKENE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 08:04:57 -0500
Received: from khc.piap.pl ([195.187.100.11]:39045 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755870AbZKENE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 08:04:56 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Karl Hiramoto <karl@hiramoto.org>, Imre Kaloz <kaloz@openwrt.org>,
       linux-arm-kernel@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] IXP4xx: Ensure index is positive
References: <4AF08014.4000704@gmail.com> <4AF0922B.3030701@hiramoto.org>
	<m3eiofl2v8.fsf@intrepid.localdomain> <4AF0A92C.6050400@gmail.com>
Date: Thu, 05 Nov 2009 14:04:59 +0100
In-Reply-To: <4AF0A92C.6050400@gmail.com> (Roel Kluin's message of "Tue, 03
	Nov 2009 23:05:32 +0100")
Message-ID: <m33a4t5dhg.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin <roel.kluin@gmail.com> writes:

> +++ b/arch/arm/mach-ixp4xx/common.c
> @@ -117,7 +117,7 @@ int gpio_to_irq(int gpio)
>  }
>  EXPORT_SYMBOL(gpio_to_irq);
>  
> -int irq_to_gpio(int irq)
> +int irq_to_gpio(unsigned int irq)
>  {
>  	int gpio = (irq < 32) ? irq2gpio[irq] : -EINVAL;
>  
> diff --git a/arch/arm/mach-ixp4xx/include/mach/gpio.h b/arch/arm/mach-ixp4xx/include/mach/gpio.h
> index cd5aec2..a5f87de 100644
> --- a/arch/arm/mach-ixp4xx/include/mach/gpio.h
> +++ b/arch/arm/mach-ixp4xx/include/mach/gpio.h
> @@ -70,7 +70,7 @@ static inline void gpio_set_value(unsigned gpio, int value)
>  #include <asm-generic/gpio.h>			/* cansleep wrappers */
>  
>  extern int gpio_to_irq(int gpio);
> -extern int irq_to_gpio(int gpio);
> +extern int irq_to_gpio(unsigned int irq);
>  
>  #endif
>  
> diff --git a/arch/arm/mach-ixp4xx/include/mach/npe.h b/arch/arm/mach-ixp4xx/include/mach/npe.h
> index 37d0511..e320db2 100644
> --- a/arch/arm/mach-ixp4xx/include/mach/npe.h
> +++ b/arch/arm/mach-ixp4xx/include/mach/npe.h
> @@ -33,7 +33,7 @@ int npe_send_message(struct npe *npe, const void *msg, const char *what);
>  int npe_recv_message(struct npe *npe, void *msg, const char *what);
>  int npe_send_recv_message(struct npe *npe, void *msg, const char *what);
>  int npe_load_firmware(struct npe *npe, const char *name, struct device *dev);
> -struct npe *npe_request(int id);
> +struct npe *npe_request(unsigned id);
>  void npe_release(struct npe *npe);
>  
>  #endif /* __IXP4XX_NPE_H */
> diff --git a/arch/arm/mach-ixp4xx/ixp4xx_npe.c b/arch/arm/mach-ixp4xx/ixp4xx_npe.c
> index 47ac69c..e8bb257 100644
> --- a/arch/arm/mach-ixp4xx/ixp4xx_npe.c
> +++ b/arch/arm/mach-ixp4xx/ixp4xx_npe.c
> @@ -665,7 +665,7 @@ err:
>  }
>  
>  
> -struct npe *npe_request(int id)
> +struct npe *npe_request(unsigned id)

It looks good, thanks a lot.
-- 
Krzysztof Halasa
