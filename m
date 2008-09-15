Return-Path: <linux-kernel-owner+w=401wt.eu-S1756660AbYIOVWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660AbYIOVWI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 17:22:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754933AbYIOVVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 17:21:55 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:39435 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754868AbYIOVVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 17:21:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=wO+9EJ3GvrowBLq19JP0SXHtjFmOAJDaAhBcpCKOzZET9S1DsvBRXqwRDwq4flgtXLtTTK1SnDItLiLtrV9HJzEtMxx8CPke4/NkAw+vk9X2nxos7vZQaAKoKW+uwAIwVTbtfb2Oyrx6ITCgP7EwkJHTnu31ptRMniYAf6wGEbg=  ;
X-YMail-OSG: zo5xMEoVM1l428KzYt8z_H0WQ2Sy_X0Digg90n3W_1q4yfsEfTH1Aut05CngbCrSV0HOKnl0FNwzhxqgVkzm2Owl6No61pFKQzgh_zK6pUbRLE_L_OCbMPh4N_NHmgc-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Uwe =?iso-8859-1?q?Kleine-K=F6nig?= 
	<ukleinek@informatik.uni-freiburg.de>
Subject: Re: [PATCH] gpio_free might sleep, arm architecture
Date: Mon, 15 Sep 2008 14:21:51 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Sascha Hauer <kernel@pengutronix.de>,
       Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>,
       Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       arm-linux-kernel@arm.linux.org.uk
References: <1216884515-12084-1-git-send-email-Uwe.Kleine-Koenig@digi.com> <1221508963-27259-1-git-send-email-ukleinek@informatik.uni-freiburg.de> <1221508963-27259-2-git-send-email-ukleinek@informatik.uni-freiburg.de>
In-Reply-To: <1221508963-27259-2-git-send-email-ukleinek@informatik.uni-freiburg.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200809151421.52581.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 September 2008, Uwe Kleine-König wrote:
> According to the documentation gpio_free should only be called from task
> context only.  To make this more explicit add a might sleep to all
> implementations.
> 
> This patch changes the gpio_free implementations for the arm
> architecture.  DaVinci is skipped on purpose to simplify the merge
> process for patches switching it over to use gpiolib as per request by
> David Brownell.
> 
> Signed-off-by: Uwe Kleine-König <ukleinek@informatik.uni-freiburg.de>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

Not dependent on anything else, FWIW (and Kevin already sent
the DaVinci patch for review) ... so IMO this is ready to
merge as soon as Russell agrees.

Consider this also an ack for the MIPS, Blackfin, and x86
arch-specific updates.  (Which are likewise ripe for merge.)

(These patches are not a 2.6.27 priority, of course...)

> Cc: David Brownell <david-b@pacbell.net>
> Cc: Andrew Victor <linux@maxim.org.za>
> Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
> Cc: Sascha Hauer <kernel@pengutronix.de>
> Cc: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
> Cc: Greg KH <greg@kroah.com>
> Cc: Kay Sievers <kay.sievers@vrfy.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> Cc: arm-linux-kernel@arm.linux.org.uk
> ---
>  arch/arm/mach-at91/include/mach/gpio.h   |    2 ++
>  arch/arm/mach-imx/include/mach/gpio.h    |    3 +++
>  arch/arm/mach-ixp4xx/include/mach/gpio.h |    3 +++
>  arch/arm/mach-ks8695/include/mach/gpio.h |    3 +++
>  arch/arm/mach-ns9xxx/gpio.c              |    2 ++
>  arch/arm/mach-orion5x/gpio.c             |    2 ++
>  6 files changed, 15 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-at91/include/mach/gpio.h b/arch/arm/mach-at91/include/mach/gpio.h
> index 76d76e2..bffa674 100644
> --- a/arch/arm/mach-at91/include/mach/gpio.h
> +++ b/arch/arm/mach-at91/include/mach/gpio.h
> @@ -13,6 +13,7 @@
>  #ifndef __ASM_ARCH_AT91RM9200_GPIO_H
>  #define __ASM_ARCH_AT91RM9200_GPIO_H
>  
> +#include <linux/kernel.h>
>  #include <asm/irq.h>
>  
>  #define PIN_BASE		NR_AIC_IRQS
> @@ -220,6 +221,7 @@ static inline int gpio_request(unsigned gpio, const char *label)
>  
>  static inline void gpio_free(unsigned gpio)
>  {
> +	might_sleep();
>  }
>  
>  extern int gpio_direction_input(unsigned gpio);
> diff --git a/arch/arm/mach-imx/include/mach/gpio.h b/arch/arm/mach-imx/include/mach/gpio.h
> index 6e3d795..502d5aa 100644
> --- a/arch/arm/mach-imx/include/mach/gpio.h
> +++ b/arch/arm/mach-imx/include/mach/gpio.h
> @@ -1,5 +1,6 @@
>  #ifndef _IMX_GPIO_H
>  
> +#include <linux/kernel.h>
>  #include <mach/imx-regs.h>
>  
>  #define IMX_GPIO_ALLOC_MODE_NORMAL	0
> @@ -63,6 +64,8 @@ static inline int gpio_request(unsigned gpio, const char *label)
>  
>  static inline void gpio_free(unsigned gpio)
>  {
> +	might_sleep();
> +
>  	imx_gpio_free(gpio);
>  }
>  
> diff --git a/arch/arm/mach-ixp4xx/include/mach/gpio.h b/arch/arm/mach-ixp4xx/include/mach/gpio.h
> index 9fbde17..cd5aec2 100644
> --- a/arch/arm/mach-ixp4xx/include/mach/gpio.h
> +++ b/arch/arm/mach-ixp4xx/include/mach/gpio.h
> @@ -25,6 +25,7 @@
>  #ifndef __ASM_ARCH_IXP4XX_GPIO_H
>  #define __ASM_ARCH_IXP4XX_GPIO_H
>  
> +#include <linux/kernel.h>
>  #include <mach/hardware.h>
>  
>  static inline int gpio_request(unsigned gpio, const char *label)
> @@ -34,6 +35,8 @@ static inline int gpio_request(unsigned gpio, const char *label)
>  
>  static inline void gpio_free(unsigned gpio)
>  {
> +	might_sleep();
> +
>  	return;
>  }
>  
> diff --git a/arch/arm/mach-ks8695/include/mach/gpio.h b/arch/arm/mach-ks8695/include/mach/gpio.h
> index 73c8416..d4af5c3 100644
> --- a/arch/arm/mach-ks8695/include/mach/gpio.h
> +++ b/arch/arm/mach-ks8695/include/mach/gpio.h
> @@ -11,6 +11,8 @@
>  #ifndef __ASM_ARCH_GPIO_H_
>  #define __ASM_ARCH_GPIO_H_
>  
> +#include <linux/kernel.h>
> +
>  #define KS8695_GPIO_0		0
>  #define KS8695_GPIO_1		1
>  #define KS8695_GPIO_2		2
> @@ -74,6 +76,7 @@ static inline int gpio_request(unsigned int pin, const char *label)
>  
>  static inline void gpio_free(unsigned int pin)
>  {
> +	might_sleep();
>  }
>  
>  #endif
> diff --git a/arch/arm/mach-ns9xxx/gpio.c b/arch/arm/mach-ns9xxx/gpio.c
> index 804c300..9e088c4 100644
> --- a/arch/arm/mach-ns9xxx/gpio.c
> +++ b/arch/arm/mach-ns9xxx/gpio.c
> @@ -12,6 +12,7 @@
>  #include <linux/init.h>
>  #include <linux/spinlock.h>
>  #include <linux/module.h>
> +#include <linux/kernel.h>
>  
>  #include <mach/gpio.h>
>  #include <mach/processor.h>
> @@ -63,6 +64,7 @@ EXPORT_SYMBOL(gpio_request);
>  
>  void gpio_free(unsigned gpio)
>  {
> +	might_sleep();
>  	clear_bit(gpio, gpiores);
>  	return;
>  }
> diff --git a/arch/arm/mach-orion5x/gpio.c b/arch/arm/mach-orion5x/gpio.c
> index cd8a16f..3bdfd0a 100644
> --- a/arch/arm/mach-orion5x/gpio.c
> +++ b/arch/arm/mach-orion5x/gpio.c
> @@ -165,6 +165,8 @@ EXPORT_SYMBOL(gpio_request);
>  
>  void gpio_free(unsigned pin)
>  {
> +	might_sleep();
> +
>  	if (pin >= GPIO_MAX || !test_bit(pin, gpio_valid)) {
>  		pr_debug("%s: invalid GPIO %d\n", __func__, pin);
>  		return;
> -- 
> 1.5.6.5
> 
> 


