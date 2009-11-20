Return-Path: <linux-kernel-owner+w=401wt.eu-S1753184AbZKTJUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbZKTJUl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 04:20:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbZKTJUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 04:20:40 -0500
Received: from mga06.intel.com ([134.134.136.21]:2070 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751330AbZKTJUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 04:20:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,776,1249282800"; 
   d="scan'208";a="469023668"
Date: Fri, 20 Nov 2009 10:22:15 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpiolib: Implement gpio_to_irq() for wm831x
Message-ID: <20091120092214.GB3733@sortiz.org>
References: <1258392116-31973-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258392116-31973-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Mon, Nov 16, 2009 at 05:21:56PM +0000, Mark Brown wrote:
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
I'm taking this one, unless David wants to do it otherwise.

Cheers,
Samuel.


> ---
>  drivers/gpio/wm831x-gpio.c |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpio/wm831x-gpio.c b/drivers/gpio/wm831x-gpio.c
> index f5e4934..b4468b6 100644
> --- a/drivers/gpio/wm831x-gpio.c
> +++ b/drivers/gpio/wm831x-gpio.c
> @@ -22,6 +22,7 @@
>  #include <linux/mfd/wm831x/core.h>
>  #include <linux/mfd/wm831x/pdata.h>
>  #include <linux/mfd/wm831x/gpio.h>
> +#include <linux/mfd/wm831x/irq.h>
>  
>  struct wm831x_gpio {
>  	struct wm831x *wm831x;
> @@ -78,6 +79,17 @@ static void wm831x_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
>  			value << offset);
>  }
>  
> +static int wm831x_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
> +{
> +	struct wm831x_gpio *wm831x_gpio = to_wm831x_gpio(chip);
> +	struct wm831x *wm831x = wm831x_gpio->wm831x;
> +
> +	if (!wm831x->irq_base)
> +		return -EINVAL;
> +
> +	return wm831x->irq_base + WM831X_IRQ_GPIO_1 + offset;
> +}
> +
>  #ifdef CONFIG_DEBUG_FS
>  static void wm831x_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
>  {
> @@ -173,6 +185,7 @@ static struct gpio_chip template_chip = {
>  	.get			= wm831x_gpio_get,
>  	.direction_output	= wm831x_gpio_direction_out,
>  	.set			= wm831x_gpio_set,
> +	.to_irq			= wm831x_gpio_to_irq,
>  	.dbg_show		= wm831x_gpio_dbg_show,
>  	.can_sleep		= 1,
>  };
> -- 
> 1.6.5.2
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
