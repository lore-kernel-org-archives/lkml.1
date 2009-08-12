Return-Path: <linux-kernel-owner+w=401wt.eu-S932597AbZHLLKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597AbZHLLKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 07:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932554AbZHLLKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 07:10:22 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33644 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932553AbZHLLKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 07:10:20 -0400
Date: Wed, 12 Aug 2009 13:10:18 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-input@vger.kernel.org
Subject: Re: [PATCH 2/5] [input] add mc13783 touchscreen driver
Message-ID: <20090812111018.GC17992@pengutronix.de>
References: <1249981667-4366-1-git-send-email-s.hauer@pengutronix.de> <1249981667-4366-2-git-send-email-s.hauer@pengutronix.de> <1249981667-4366-3-git-send-email-s.hauer@pengutronix.de> <20090812024609.5EB8B526EC9@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090812024609.5EB8B526EC9@mailhub.coreip.homeip.net>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse
	6-8, 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 12:57:30 up 6 days, 22:16, 17 users,  load average: 0.07, 0.14,
	0.33
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry

On Tue, Aug 11, 2009 at 07:15:33PM -0700, Dmitry Torokhov wrote:
> Hi Sascha,
> 
> On Tue, Aug 11, 2009 at 11:07:44AM +0200, Sascha Hauer wrote:
> > This driver provides support for the touchscreen interface
> > integrated into the Freescale MC13783.
> > 
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > Cc: linux-input@vger.kernel.org
> > ---
> >  drivers/input/touchscreen/Kconfig      |   12 ++
> >  drivers/input/touchscreen/Makefile     |    1 +
> >  drivers/input/touchscreen/mc13783_ts.c |  228 ++++++++++++++++++++++++++++++++
> >  3 files changed, 241 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/input/touchscreen/mc13783_ts.c
> > 
> > diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
> > index 72e2712..7451cf0 100644
> > --- a/drivers/input/touchscreen/Kconfig
> > +++ b/drivers/input/touchscreen/Kconfig
> > @@ -413,6 +413,18 @@ config TOUCHSCREEN_USB_COMPOSITE
> >  	  To compile this driver as a module, choose M here: the
> >  	  module will be called usbtouchscreen.
> >  
> > +config TOUCHSCREEN_MC13783
> > +	tristate "Freescale MC13783 touchscreen input driver"
> > +	depends on MFD_MC13783
> > +	help
> > +	  Say Y here if you have an Freescale MC13783 PMIC on your
> > +	  board and want to use its touchscreen
> > +
> > +	  If unsure, say N.
> > +
> > +	  To compile this driver as a module, choose M here: the
> > +	  module will be called mxc_ts.
> > +
> >  config TOUCHSCREEN_USB_EGALAX
> >  	default y
> >  	bool "eGalax, eTurboTouch CT-410/510/700 device support" if EMBEDDED
> > diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
> > index 3e1c5e0..7b79598 100644
> > --- a/drivers/input/touchscreen/Makefile
> > +++ b/drivers/input/touchscreen/Makefile
> > @@ -20,6 +20,7 @@ obj-$(CONFIG_TOUCHSCREEN_INEXIO)	+= inexio.o
> >  obj-$(CONFIG_TOUCHSCREEN_MIGOR)		+= migor_ts.o
> >  obj-$(CONFIG_TOUCHSCREEN_MTOUCH)	+= mtouch.o
> >  obj-$(CONFIG_TOUCHSCREEN_MK712)		+= mk712.o
> > +obj-$(CONFIG_TOUCHSCREEN_MC13783)	+= mc13783_ts.o
> >  obj-$(CONFIG_TOUCHSCREEN_HP600)		+= hp680_ts_input.o
> >  obj-$(CONFIG_TOUCHSCREEN_HP7XX)		+= jornada720_ts.o
> >  obj-$(CONFIG_TOUCHSCREEN_HTCPEN)	+= htcpen.o
> > diff --git a/drivers/input/touchscreen/mc13783_ts.c b/drivers/input/touchscreen/mc13783_ts.c
> > new file mode 100644
> > index 0000000..9dfe280
> > --- /dev/null
> > +++ b/drivers/input/touchscreen/mc13783_ts.c
> > @@ -0,0 +1,228 @@
> > +/*
> > + * Driver for the Freescale Semiconductor MC13783 touchscreen.
> > + *
> > + * Copyright 2004-2007 Freescale Semiconductor, Inc. All Rights Reserved.
> > + * Copyright (C) 2009 Sascha Hauer, Pengutronix
> > + *
> > + * Initial development of this code was funded by
> > + * Phytec Messtechnik GmbH, http://www.phytec.de
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License
> > + * as published by the Free Software Foundation; either version 2
> > + * of the License, or (at your option) any later version.
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License along with
> > + * this program; if not, write to the Free Software Foundation, Inc., 51
> > + * Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
> > + *
> > + */
> > +
> > +#include <linux/mfd/mc13783-private.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/mfd/mc13783.h>
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/delay.h>
> > +#include <linux/input.h>
> > +#include <linux/sched.h>
> > +#include <linux/init.h>
> > +
> > +#define MC13783_TS_NAME	"mc13783-ts"
> > +
> > +struct mc13783_ts_priv {
> > +	struct input_dev *idev;
> > +	struct mc13783 *mc13783;
> > +	struct delayed_work work;
> > +	struct workqueue_struct *workq;
> > +	unsigned int sample[4];
> > +};
> > +
> > +static inline void mc13783_ts_start_conversion(struct mc13783_ts_priv *priv)
> > +{
> > +	unsigned int reg_adc0, reg_adc1;
> > +
> > +	reg_adc0 = MC13783_ADC0_ADREFEN | MC13783_ADC0_ADREFMODE
> > +			| MC13783_ADC0_TSMOD0 | MC13783_ADC0_TSMOD1
> > +			| MC13783_ADC0_ADINC1 | MC13783_ADC0_ADINC2;
> > +	reg_adc1 = MC13783_ADC1_ADEN | MC13783_ADC1_ADSEL | MC13783_ADC1_ADA22
> > +			| MC13783_ADC1_ASC | MC13783_ADC1_ADTRIGIGN;
> > +
> > +	mc13783_reg_write(priv->mc13783, MC13783_REG_ADC_0, reg_adc0);
> > +	mc13783_reg_write(priv->mc13783, MC13783_REG_ADC_1, reg_adc1);
> > +}
> 
> I do not see this function used...
> 
> > +
> > +static inline void mc13783_ts_set_irq_mode(struct mc13783_ts_priv *priv)
> > +{
> > +	unsigned int reg_adc0, reg_adc1;
> > +
> > +	reg_adc0 = MC13783_ADC0_ADREFEN | MC13783_ADC0_ADREFMODE
> > +			| MC13783_ADC0_TSMOD0;
> > +	reg_adc1 = MC13783_ADC1_ADEN | MC13783_ADC1_ADTRIGIGN;
> > +
> > +	mc13783_reg_write(priv->mc13783, MC13783_REG_ADC_0, reg_adc0);
> > +	mc13783_reg_write(priv->mc13783, MC13783_REG_ADC_1, reg_adc1);
> > +}
> 
> Nor this one...
> 
> > +
> > +#define TS_MIN 1
> > +#define TS_MAX 1000
> > +
> > +static void mc13783_ts_handler(int irq, void *data)
> > +{
> > +	struct mc13783_ts_priv *priv = data;
> > +	unsigned int sts;
> > +
> > +	mc13783_reg_read(priv->mc13783, MC13783_REG_INTERRUPT_STATUS_0, &sts);
> > +	mc13783_reg_write(priv->mc13783, MC13783_REG_INTERRUPT_STATUS_0,
> > +			sts & MC13783_INT_STAT_TSI);
> > +
> > +	if (sts & MC13783_INT_STAT_TSI)
> > +		queue_work(priv->workq, &priv->work.work);
> 
> Do not expose the innards of delayed_work, simply do:
> 
> 	queue_delayed_work(priv->workq, &priv->work, 0);

Ok

> 
> > +}
> > +
> > +static void mc13783_ts_report_sample(struct mc13783_ts_priv *priv)
> > +{
> > +	int x, y, press = 0;
> > +
> > +	x = (priv->sample[2] >> 2) & 0x3ff;
> > +	y = (priv->sample[3] >> 2) & 0x3ff;
> > +
> > +	pr_debug("mc13783_ts: x: %d y: %d\n", x, y);
> > +
> > +	if (x > TS_MIN && x < TS_MAX && y > TS_MIN && y < TS_MAX) {
> > +		press = 1;
> > +		input_report_abs(priv->idev, ABS_X, x);
> > +		input_report_abs(priv->idev, ABS_Y, y);
> > +
> > +		queue_delayed_work(priv->workq, &priv->work, HZ / 50);
> > +	}
> > +
> > +	input_report_abs(priv->idev, ABS_PRESSURE, press);
> 
> This device does not appear to privide pressure readings, use BTN_TOUCH
> alone to indicate touches instead of fake ABS_PRESSURE event. Yes, I
> know that older versions of tslib only recognize ABS_PRESSURE...

In fact no released version of tslib supports this :( Anyway, fixed.

> 
> > +	input_sync(priv->idev);
> > +}
> > +
> > +static void mc13783_ts_work(struct work_struct *work)
> > +{
> > +	struct mc13783_ts_priv *priv =
> > +		container_of(work, struct mc13783_ts_priv, work.work);
> > +	unsigned int mode = MC13783_ADC_MODE_TS;
> > +	unsigned int channel = 12;
> > +	int ret;
> > +
> > +	ret = mc13783_adc_do_conversion
> > +		(priv->mc13783, mode, channel, priv->sample);
> > +
> > +	if (!ret)
> > +		mc13783_ts_report_sample(priv);
> > +}
> > +
> > +static int __init mc13783_ts_probe(struct platform_device *pdev)
> 
> No __inits on probe() methods, they are normally __devinit.

Ok

> 
> > +{
> > +	struct mc13783_ts_priv *priv;
> > +	struct input_dev *idev;
> > +	int ret;
> > +
> > +	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> > +	if (!priv)
> > +		return -ENOMEM;
> > +
> > +	priv->mc13783 = pdev->dev.platform_data;
> > +
> > +	idev = input_allocate_device();
> > +	if (!idev) {
> > +		ret = -ENOMEM;
> > +		goto err_input_alloc;
> > +	}
> > +
> > +	priv->idev = idev;
> > +	idev->name = MC13783_TS_NAME;
> > +	idev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
> > +	idev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
> > +	idev->absbit[0] = BIT_MASK(ABS_X) | BIT_MASK(ABS_Y) |
> > +					BIT_MASK(ABS_PRESSURE);
> > +
> 
> It is usually a good idea to indicate the range of reported values with
> input_set_abs_params().

Fixed

> 
> > +	platform_set_drvdata(pdev, priv);
> > +
> > +	ret = mc13783_register_irq(priv->mc13783, MC13783_IRQ_TS,
> > +		mc13783_ts_handler, priv);
> > +	if (ret)
> > +		goto err_failed_irq;
> > +
> > +	ret = input_register_device(priv->idev);
> > +	if (ret) {
> > +		dev_err(&pdev->dev,
> > +				"register input device failed with %d\n", ret);
> > +		goto err_failed_register;
> > +	}
> > +
> > +	/* unmask the ts wakeup interrupt */
> > +	mc13783_set_bits(priv->mc13783, MC13783_REG_INTERRUPT_MASK_0,
> > +			MC13783_INT_MASK_TSM, 0);
> > +
> > +	mc13783_adc_set_ts_status(priv->mc13783, 1);
> > +
> > +	INIT_DELAYED_WORK(&priv->work, mc13783_ts_work);
> > +
> > +	priv->workq = create_singlethread_workqueue("mc13783_ts");
> 
> Do you really need a separate workqueue? Would not keventd suffice?

Yes, I do. mc13783_adc_do_conversion() runs in a workqueue aswell. With
keventd I would deadlock.

> 
> > +	queue_delayed_work(priv->workq, &priv->work, HZ / 20);
> 
> Starting of the contoller is better done in input_dev->open() method when
> there are uses as opposed to probe() method.

Ok

> 
> > +
> > +	return 0;
> > +
> > +err_failed_register:
> > +	mc13783_free_irq(priv->mc13783, MC13783_IRQ_TS);
> > +err_failed_irq:
> > +	input_free_device(priv->idev);
> > +err_input_alloc:
> > +	kfree(priv);
> > +
> > +	return ret;
> > +}
> > +
> > +static int __devexit mc13783_ts_remove(struct platform_device *pdev)
> > +{
> > +	struct mc13783_ts_priv *priv = platform_get_drvdata(pdev);
> > +
> > +	mc13783_adc_set_ts_status(priv->mc13783, 0);
> > +
> > +	mc13783_free_irq(priv->mc13783, MC13783_IRQ_TS);
> > +
> > +	cancel_delayed_work(&priv->work);
> > +	destroy_workqueue(priv->workq);
> > +
> > +	input_unregister_device(priv->idev);
> > +	input_free_device(priv->idev);
> 
> input_free_device() is verboten after unregister.

Ok

> 
> > +
> > +	kfree(priv);
> > +
> > +	return 0;
> > +}
> > +
> > +static struct platform_driver mc13783_ts_driver = {
> > +	.probe		= mc13783_ts_probe,
> > +	.remove 	= __devexit_p(mc13783_ts_remove),
> 
> Whitespace damage.

Fixed

> 
> > +	.driver		= {
> > +		.owner	= THIS_MODULE,
> > +		.name	= MC13783_TS_NAME,
> > +	},
> > +};
> > +
> > +static int __init mc13783_ts_init(void)
> > +{
> > +	return platform_driver_register(&mc13783_ts_driver);
> > +}
> > +
> > +static void __exit mc13783_ts_exit(void)
> > +{
> > +	platform_driver_unregister(&mc13783_ts_driver);
> > +}
> > +
> > +module_init(mc13783_ts_init);
> > +module_exit(mc13783_ts_exit);
> > +
> > +MODULE_DESCRIPTION("MC13783 input touchscreen driver");
> > +MODULE_AUTHOR("Sascha Hauer, <s.hauer@pengutronix.de>");
> > +MODULE_LICENSE("GPL");
> 
> MODULE_ALIAS()?

Added

Thanks for reviewing
 Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
