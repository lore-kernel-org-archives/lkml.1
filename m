Return-Path: <linux-kernel-owner+w=401wt.eu-S1754417AbZG0U1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417AbZG0U1y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 16:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751484AbZG0U1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 16:27:53 -0400
Received: from smtp102.sbc.mail.gq1.yahoo.com ([67.195.15.61]:35786 "HELO
	smtp102.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751364AbZG0U1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 16:27:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=egOi2dBf8uOUmsCNMhj3e97zRCeC1R0zdbmn6TE8wdA4/pvTTyw79iNV8i2VF2HkAV3wtktLc3eweinG8W0caR2tq33T6xrTPql7qBtqSQxRYx+fdWh+6rN/qzZmGFd8AfhJ2E8rhpVgZ9UUlV6ag1dvB+tAdJuJQQK7j59t+D4=  ;
X-Yahoo-SMTP: HIlLYKCswBDnjrunw3O.NnLyvismjGf1HBYfVTvuneM-
X-YMail-OSG: MsDnqFEVM1lLZewHlqAfWRdH5Biq0cf.CDvAPdkA9gdGVlQlmhxk4AgbGhKy2Tn.YsOV6XEb1dBsoV2_rfqK0R5JTcdJYNHtuzh_nIzOk67jA3uSHjAG.WJLE3yuo0G7Zh8AFb84vQyeIOlj.lQxjBT65J4E_fhpAKOmBmYB1eFjtQ3YIVFbPaHqh.D3xT5qPqc5HYjlFBAJKGiIWnWChGJ.rofxf_5ZCyCJyctT2rj46j_9.05tqc7LcrURyKdJkYLvSaDhnu_Atb4K2otBhdNdnN6fINV3dU4W1fHKJM.OnZwHqFo6MvALyvQj_g--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 10/22] gpio: Add WM831X GPIO driver
Date: Mon, 27 Jul 2009 13:27:51 -0700
User-Agent: KMail/1.9.10
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
References: <20090727134527.GA12849@rakim.wolfsonmicro.main> <1248702372-29534-10-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1248702372-29534-10-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907271327.51674.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 July 2009, Mark Brown wrote:
> Add support for the GPIO pins on the WM831x. No direct support is
> currently supplied for configuring non-gpiolib functionality such
> as pull configuration and alternate functions, soft configuration
> of these will be provided in a future patch.
> 
> Currently use of these pins as interrupts is not supported due to
> the ongoing issues with generic irq not support interrupt controllers
> on interrupt driven buses. Users can directly request the interrupts
> with the wm831x-specific APIs currently provided if required.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: David Brownell <dbrownell@users.sourceforge.net>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

> ---
>  drivers/gpio/Kconfig            |    7 +
>  drivers/gpio/Makefile           |    1 +
>  drivers/gpio/wm831x-gpio.c      |  252 +++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/wm831x/gpio.h |   55 +++++++++
>  4 files changed, 315 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/gpio/wm831x-gpio.c
>  create mode 100644 include/linux/mfd/wm831x/gpio.h
> 
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index 96dda81..6b4c484 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -155,6 +155,13 @@ config GPIO_TWL4030
>  	  Say yes here to access the GPIO signals of various multi-function
>  	  power management chips from Texas Instruments.
>  
> +config GPIO_WM831X
> +	tristate "WM831x GPIOs"
> +	depends on MFD_WM831X
> +	help
> +	  Say yes here to access the GPIO signals of WM831x power management
> +	  chips from Wolfson Microelectronics.
> +
>  comment "PCI GPIO expanders:"
>  
>  config GPIO_BT8XX
> diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
> index 9244c6f..ea7c745 100644
> --- a/drivers/gpio/Makefile
> +++ b/drivers/gpio/Makefile
> @@ -14,3 +14,4 @@ obj-$(CONFIG_GPIO_TWL4030)	+= twl4030-gpio.o
>  obj-$(CONFIG_GPIO_XILINX)	+= xilinx_gpio.o
>  obj-$(CONFIG_GPIO_BT8XX)	+= bt8xxgpio.o
>  obj-$(CONFIG_GPIO_VR41XX)	+= vr41xx_giu.o
> +obj-$(CONFIG_GPIO_WM831X)	+= wm831x-gpio.o
> diff --git a/drivers/gpio/wm831x-gpio.c b/drivers/gpio/wm831x-gpio.c
> new file mode 100644
> index 0000000..f9c09a5
> --- /dev/null
> +++ b/drivers/gpio/wm831x-gpio.c
> @@ -0,0 +1,252 @@
> +/*
> + * wm831x-gpio.c  --  gpiolib support for Wolfson WM831x PMICs
> + *
> + * Copyright 2009 Wolfson Microelectronics PLC.
> + *
> + * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
> + *
> + *  This program is free software; you can redistribute  it and/or modify it
> + *  under  the terms of  the GNU General  Public License as published by the
> + *  Free Software Foundation;  either version 2 of the  License, or (at your
> + *  option) any later version.
> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/gpio.h>
> +#include <linux/mfd/core.h>
> +#include <linux/platform_device.h>
> +#include <linux/seq_file.h>
> +
> +#include <linux/mfd/wm831x/core.h>
> +#include <linux/mfd/wm831x/pdata.h>
> +#include <linux/mfd/wm831x/gpio.h>
> +
> +#define WM831X_GPIO_MAX 16
> +
> +struct wm831x_gpio {
> +	struct wm831x *wm831x;
> +	struct gpio_chip gpio_chip;
> +};
> +
> +static inline struct wm831x_gpio *to_wm831x_gpio(struct gpio_chip *chip)
> +{
> +	return container_of(chip, struct wm831x_gpio, gpio_chip);
> +}
> +
> +static int wm831x_gpio_direction_in(struct gpio_chip *chip, unsigned offset)
> +{
> +	struct wm831x_gpio *wm831x_gpio = to_wm831x_gpio(chip);
> +	struct wm831x *wm831x = wm831x_gpio->wm831x;
> +
> +	return wm831x_set_bits(wm831x, WM831X_GPIO1_CONTROL + offset,
> +			       WM831X_GPN_DIR | WM831X_GPN_TRI,
> +			       WM831X_GPN_DIR);
> +}
> +
> +static int wm831x_gpio_get(struct gpio_chip *chip, unsigned offset)
> +{
> +	struct wm831x_gpio *wm831x_gpio = to_wm831x_gpio(chip);
> +	struct wm831x *wm831x = wm831x_gpio->wm831x;
> +	int ret;
> +
> +	ret = wm831x_reg_read(wm831x, WM831X_GPIO_LEVEL);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (ret & 1 << offset)
> +		return 1;
> +	else
> +		return 0;
> +}
> +
> +static int wm831x_gpio_direction_out(struct gpio_chip *chip,
> +				     unsigned offset, int value)
> +{
> +	struct wm831x_gpio *wm831x_gpio = to_wm831x_gpio(chip);
> +	struct wm831x *wm831x = wm831x_gpio->wm831x;
> +
> +	return wm831x_set_bits(wm831x, WM831X_GPIO1_CONTROL + offset,
> +			       WM831X_GPN_DIR | WM831X_GPN_TRI, 0);
> +}
> +
> +static void wm831x_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
> +{
> +	struct wm831x_gpio *wm831x_gpio = to_wm831x_gpio(chip);
> +	struct wm831x *wm831x = wm831x_gpio->wm831x;
> +
> +	wm831x_set_bits(wm831x, WM831X_GPIO_LEVEL, 1 << offset,
> +			value << offset);
> +}
> +
> +#ifdef CONFIG_DEBUG_FS
> +static void wm831x_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
> +{
> +	struct wm831x_gpio *wm831x_gpio = to_wm831x_gpio(chip);
> +	struct wm831x *wm831x = wm831x_gpio->wm831x;
> +	int i;
> +
> +	for (i = 0; i < chip->ngpio; i++) {
> +		int gpio = i + chip->base;
> +		int reg;
> +		const char *label, *pull, *powerdomain;
> +
> +		/* We report the GPIO even if it's not requested since
> +		 * we're also reporting things like alternate
> +		 * functions which apply even when the GPIO is not in
> +		 * use as a GPIO.
> +		 */
> +		label = gpiochip_is_requested(chip, i);
> +		if (!label)
> +			label = "Unrequested";
> +
> +		seq_printf(s, " gpio-%-3d (%-20.20s) ", gpio, label);
> +
> +		reg = wm831x_reg_read(wm831x, WM831X_GPIO1_CONTROL + i);
> +		if (reg < 0) {
> +			dev_err(wm831x->dev,
> +				"GPIO control %d read failed: %d\n",
> +				gpio, reg);
> +			seq_printf(s, "\n");
> +			continue;
> +		}
> +
> +		switch (reg & WM831X_GPN_PULL_MASK) {
> +		case WM831X_GPIO_PULL_NONE:
> +			pull = "nopull";
> +			break;
> +		case WM831X_GPIO_PULL_DOWN:
> +			pull = "pulldown";
> +			break;
> +		case WM831X_GPIO_PULL_UP:
> +			pull = "pullup";
> +		default:
> +			pull = "INVALID PULL";
> +			break;
> +		}
> +
> +		switch (i + 1) {
> +		case 1 ... 3:
> +		case 7 ... 9:
> +			if (reg & WM831X_GPN_PWR_DOM)
> +				powerdomain = "VPMIC";
> +			else
> +				powerdomain = "DBVDD";
> +			break;
> +
> +		case 4 ... 6:
> +		case 10 ... 12:
> +			if (reg & WM831X_GPN_PWR_DOM)
> +				powerdomain = "SYSVDD";
> +			else
> +				powerdomain = "DBVDD";
> +			break;
> +
> +		case 13 ... 16:
> +			powerdomain = "TPVDD";
> +			break;
> +
> +		default:
> +			BUG();
> +			break;
> +		}
> +
> +		seq_printf(s, " %s %s %s %s%s\n"
> +			   "                                  %s%s (0x%4x)\n",
> +			   reg & WM831X_GPN_DIR ? "in" : "out",
> +			   wm831x_gpio_get(chip, i) ? "high" : "low",
> +			   pull,
> +			   powerdomain,
> +			   reg & WM831X_GPN_POL ? " inverted" : "",
> +			   reg & WM831X_GPN_OD ? "open-drain" : "CMOS",
> +			   reg & WM831X_GPN_TRI ? " tristated" : "",
> +			   reg);
> +	}
> +}
> +#else
> +#define wm831x_gpio_dbg_show NULL
> +#endif
> +
> +static struct gpio_chip template_chip = {
> +	.label			= "wm831x",
> +	.owner			= THIS_MODULE,
> +	.direction_input	= wm831x_gpio_direction_in,
> +	.get			= wm831x_gpio_get,
> +	.direction_output	= wm831x_gpio_direction_out,
> +	.set			= wm831x_gpio_set,
> +	.dbg_show		= wm831x_gpio_dbg_show,
> +	.can_sleep		= 1,
> +};
> +
> +static int __devinit wm831x_gpio_probe(struct platform_device *pdev)
> +{
> +	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
> +	struct wm831x_pdata *pdata = wm831x->dev->platform_data;
> +	struct wm831x_gpio *wm831x_gpio;
> +	int ret;
> +
> +	wm831x_gpio = kzalloc(sizeof(*wm831x_gpio), GFP_KERNEL);
> +	if (wm831x_gpio == NULL)
> +		return -ENOMEM;
> +
> +	wm831x_gpio->wm831x = wm831x;
> +	wm831x_gpio->gpio_chip = template_chip;
> +	wm831x_gpio->gpio_chip.ngpio = WM831X_GPIO_MAX;
> +	wm831x_gpio->gpio_chip.dev = &pdev->dev;
> +	if (pdata && pdata->gpio_base)
> +		wm831x_gpio->gpio_chip.base = pdata->gpio_base;
> +	else
> +		wm831x_gpio->gpio_chip.base = -1;
> +
> +	ret = gpiochip_add(&wm831x_gpio->gpio_chip);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "Could not register gpiochip, %d\n",
> +			ret);
> +		goto err;
> +	}
> +
> +	platform_set_drvdata(pdev, wm831x_gpio);
> +
> +	return ret;
> +
> +err:
> +	kfree(wm831x_gpio);
> +	return ret;
> +}
> +
> +static int __devexit wm831x_gpio_remove(struct platform_device *pdev)
> +{
> +	struct wm831x_gpio *wm831x_gpio = platform_get_drvdata(pdev);
> +	int ret;
> +
> +	ret = gpiochip_remove(&wm831x_gpio->gpio_chip);
> +	if (ret == 0)
> +		kfree(wm831x_gpio);
> +
> +	return ret;
> +}
> +
> +static struct platform_driver wm831x_gpio_driver = {
> +	.driver.name	= "wm831x-gpio",
> +	.driver.owner	= THIS_MODULE,
> +	.probe		= wm831x_gpio_probe,
> +	.remove		= __devexit_p(wm831x_gpio_remove),
> +};
> +
> +static int __init wm831x_gpio_init(void)
> +{
> +	return platform_driver_register(&wm831x_gpio_driver);
> +}
> +subsys_initcall(wm831x_gpio_init);
> +
> +static void __exit wm831x_gpio_exit(void)
> +{
> +	platform_driver_unregister(&wm831x_gpio_driver);
> +}
> +module_exit(wm831x_gpio_exit);
> +
> +MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com>");
> +MODULE_DESCRIPTION("GPIO interface for WM831x PMICs");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:wm831x-gpio");
> diff --git a/include/linux/mfd/wm831x/gpio.h b/include/linux/mfd/wm831x/gpio.h
> new file mode 100644
> index 0000000..2835614
> --- /dev/null
> +++ b/include/linux/mfd/wm831x/gpio.h
> @@ -0,0 +1,55 @@
> +/*
> + * include/linux/mfd/wm831x/gpio.h -- GPIO for WM831x
> + *
> + * Copyright 2009 Wolfson Microelectronics PLC.
> + *
> + * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
> + *
> + *  This program is free software; you can redistribute  it and/or modify it
> + *  under  the terms of  the GNU General  Public License as published by the
> + *  Free Software Foundation;  either version 2 of the  License, or (at your
> + *  option) any later version.
> + *
> + */
> +
> +#ifndef __MFD_WM831X_GPIO_H__
> +#define __MFD_WM831X_GPIO_H__
> +
> +/*
> + * R16440-16455 (0x4038-0x4047) - GPIOx Control
> + */
> +#define WM831X_GPN_DIR                          0x8000  /* GPN_DIR */
> +#define WM831X_GPN_DIR_MASK                     0x8000  /* GPN_DIR */
> +#define WM831X_GPN_DIR_SHIFT                        15  /* GPN_DIR */
> +#define WM831X_GPN_DIR_WIDTH                         1  /* GPN_DIR */
> +#define WM831X_GPN_PULL_MASK                    0x6000  /* GPN_PULL - [14:13] */
> +#define WM831X_GPN_PULL_SHIFT                       13  /* GPN_PULL - [14:13] */
> +#define WM831X_GPN_PULL_WIDTH                        2  /* GPN_PULL - [14:13] */
> +#define WM831X_GPN_INT_MODE                     0x1000  /* GPN_INT_MODE */
> +#define WM831X_GPN_INT_MODE_MASK                0x1000  /* GPN_INT_MODE */
> +#define WM831X_GPN_INT_MODE_SHIFT                   12  /* GPN_INT_MODE */
> +#define WM831X_GPN_INT_MODE_WIDTH                    1  /* GPN_INT_MODE */
> +#define WM831X_GPN_PWR_DOM                      0x0800  /* GPN_PWR_DOM */
> +#define WM831X_GPN_PWR_DOM_MASK                 0x0800  /* GPN_PWR_DOM */
> +#define WM831X_GPN_PWR_DOM_SHIFT                    11  /* GPN_PWR_DOM */
> +#define WM831X_GPN_PWR_DOM_WIDTH                     1  /* GPN_PWR_DOM */
> +#define WM831X_GPN_POL                          0x0400  /* GPN_POL */
> +#define WM831X_GPN_POL_MASK                     0x0400  /* GPN_POL */
> +#define WM831X_GPN_POL_SHIFT                        10  /* GPN_POL */
> +#define WM831X_GPN_POL_WIDTH                         1  /* GPN_POL */
> +#define WM831X_GPN_OD                           0x0200  /* GPN_OD */
> +#define WM831X_GPN_OD_MASK                      0x0200  /* GPN_OD */
> +#define WM831X_GPN_OD_SHIFT                          9  /* GPN_OD */
> +#define WM831X_GPN_OD_WIDTH                          1  /* GPN_OD */
> +#define WM831X_GPN_TRI                          0x0080  /* GPN_TRI */
> +#define WM831X_GPN_TRI_MASK                     0x0080  /* GPN_TRI */
> +#define WM831X_GPN_TRI_SHIFT                         7  /* GPN_TRI */
> +#define WM831X_GPN_TRI_WIDTH                         1  /* GPN_TRI */
> +#define WM831X_GPN_FN_MASK                      0x000F  /* GPN_FN - [3:0] */
> +#define WM831X_GPN_FN_SHIFT                          0  /* GPN_FN - [3:0] */
> +#define WM831X_GPN_FN_WIDTH                          4  /* GPN_FN - [3:0] */
> +
> +#define WM831X_GPIO_PULL_NONE (0 << WM831X_GPN_PULL_SHIFT)
> +#define WM831X_GPIO_PULL_DOWN (1 << WM831X_GPN_PULL_SHIFT)
> +#define WM831X_GPIO_PULL_UP   (2 << WM831X_GPN_PULL_SHIFT)
> +#endif
> -- 
> 1.6.3.3
> 
> 


