Return-Path: <linux-kernel-owner+w=401wt.eu-S1759430AbYGBWEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759430AbYGBWEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 18:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753805AbYGBWEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 18:04:11 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53230 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078AbYGBWEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 18:04:10 -0400
Date: Wed, 2 Jul 2008 23:03:56 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ben Dooks <ben-linux@fluff.org>, Marek Va??ut <marek.vasut@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] PalmTX initial support
Message-ID: <20080702220356.GE19143@flint.arm.linux.org.uk>
References: <200807022232.47294.marek.vasut@gmail.com> <20080702204110.GA22107@fluff.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080702204110.GA22107@fluff.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2008 at 09:41:10PM +0100, Ben Dooks wrote:
> hmm, why isn't the pxa sdmmc driver doing something about the
> detection for the cards?

Because there's no standard way to detect MMC cards on PXA hardware.

> > +/******************************************************************************
> > + * GPIO keys
> > + ******************************************************************************/
> > +#ifdef CONFIG_KEYBOARD_GPIO
> > +static struct gpio_keys_button palmtx_pxa_buttons[] = {
> > +	{KEY_F8, GPIO_NR_PALMTX_HOTSYNC_BUTTON_N, 1, "HotSync Button" },
> > +};
> 
> I've never seen the pooint of #ifdefs for platform data, just bung
> the lot in, it is always possible to build and an insert a new driver
> module to support this after building the zImage.

And this initialiser should be using named initialisers.

> > +static struct generic_bl_info palmtx_bl_info = {
> > +	.max_intensity		= PALMTX_MAX_INTENSITY,
> > +	.default_intensity	= PALMTX_MAX_INTENSITY,
> > +	.set_bl_intensity	= palmtx_set_bl_intensity,
> > +	.limit_mask		= PALMTX_LIMIT_MASK,
> > +};
> 
> go and have a look at the new pwm stuff.

It's found in the 'pxa' branch of my git tree.  See the website for a link
to it.

> > +static void palmtx_irda_transceiver_mode(struct device *dev, int mode)
> > +{
> > +	unsigned long flags;
> > +
> > +	local_irq_save(flags);
> > +
> > +	if (mode & IR_SIRMODE)
> > +		printk(KERN_INFO "IrDA: setting mode to SIR\n");
> > +	else if (mode & IR_FIRMODE)
> > +		printk(KERN_INFO "IrDA: setting mode to FIR\n");

Are these useful?

> > +
> > +	if (mode & IR_OFF) {
> > +		printk(KERN_INFO "IrDA: turning transceiver OFF\n");

Ditto.

> > +		gpio_set_value(GPIO_NR_PALMTX_IR_DISABLE, 1);
> > +	} else {
> > +		printk(KERN_INFO "IrDA: turning transceiver ON\n");

Ditto.

> > +		gpio_set_value(GPIO_NR_PALMTX_IR_DISABLE, 0);
> > +		gpio_set_value(GPIO47_ICPTXD_MD, 1);
> > +		mdelay(30);
> > +		gpio_set_value(GPIO47_ICPTXD_MD, 0);

Don't you have to configure GPIO47 as a GPIO to change its state?
Since you don't, and I assume you've tested this, I think you've
proven that you can delete the fiddling with GPIO47.

> > +/******************************************************************************
> > + * AC97
> > + ******************************************************************************/
> > +static struct platform_device palmtx_ac97 = {
> > +	.name	= "pxa2xx-ac97",
> > +	.id	= 0,
> > +};

There's an AC97 device now in the pxa branch.
