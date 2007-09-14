Return-Path: <linux-kernel-owner+w=401wt.eu-S1762180AbXINAxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762180AbXINAxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 20:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755668AbXINAxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 20:53:38 -0400
Received: from mo32.po.2iij.NET ([210.128.50.17]:14657 "EHLO mo32.po.2iij.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755598AbXINAxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 20:53:37 -0400
Message-Id: <200709140053.l8E0rPb4003095@po-mbox303.hop.2iij.net>
Date: Fri, 14 Sep 2007 09:53:25 +0900
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: yoichi_yuasa@tripeaks.co.jp, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][1/2] led: add Cobalt Raq LEDs support
In-Reply-To: <1189719132.6326.164.camel@localhost.localdomain>
References: <20070913235441.5bab3d8e.yoichi_yuasa@tripeaks.co.jp>
	<1189719132.6326.164.camel@localhost.localdomain>
Organization: TriPeaks Corporation
X-Mailer: Sylpheed version 1.0.4 (GTK+ 1.2.10; i386-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Sep 2007 22:32:12 +0100
Richard Purdie <rpurdie@rpsys.net> wrote:

> On Thu, 2007-09-13 at 23:54 +0900, Yoichi Yuasa wrote:
> > Add Cobalt Raq LEDs support.
> > 
> > Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
> 
> Not the clearest patch I've ever seen or the most helpful patch
> description. The rename could probably be split from the additional new
> driver at least...

OK, I'll split it.

> > diff -pruN -X mips/Documentation/dontdiff mips-orig/drivers/leds/leds-cobalt-raq.c mips/drivers/leds/leds-cobalt-raq.c
> > --- mips-orig/drivers/leds/leds-cobalt-raq.c	1970-01-01 09:00:00.000000000 +0900
> > +++ mips/drivers/leds/leds-cobalt-raq.c	2007-09-12 12:04:34.021000750 +0900
> [...]
> > +static void raq_web_led_set(struct led_classdev *led_cdev,
> > +                            enum led_brightness brightness)
> > +{
> > +	spin_lock_irq(&raq_led_lock);
> > +
> > +	if (brightness)
> > +		led_value |= LED_WEB;
> > +	else
> > +		led_value &= ~LED_WEB;
> > +	writeb(led_value, led_port);
> > +
> > +	spin_unlock_irq(&raq_led_lock);
> > +}
> 
> The _irq spinlock variants are not safe there or in the other brightness
> set function...
> 
> +static struct led_classdev raq_web_led = {
> > +	.name		= "raq-web-led",
> > +	.brightness_set	= raq_web_led_set,
> > +};
> > +
> [...]
> > +static struct led_classdev raq_power_off_led = {
> > +	.name			= "raq-power-off-led",
> > +	.brightness_set		= raq_power_off_led_set,
> > +	.default_trigger	= "power-off",
> > +};
> 
> Do these really need "led" in the name?
> 
> What does a power-off trigger do with an LED out of interest?

It lights when the Cobalt Raq is possible to turn off power. 

> 
> > +static int __devexit cobalt_raq_led_remove(struct platform_device *pdev)
> > +{
> > +	if (led_port) {
> > +		iounmap(led_port);
> > +		led_port = NULL;
> > +	}
> > +
> > +	led_classdev_unregister(&raq_power_off_led);
> > +	led_classdev_unregister(&raq_web_led);
> > +
> > +	return 0;
> > +}
> 
> You want to unregister, then iounmap...
> 
> > +static int __init cobalt_raq_led_init(void)
> > +{
> > +	return platform_driver_register(&cobalt_raq_led_driver);
> > +}
> > +
> > +module_init(cobalt_raq_led_init);
> 
> No module_exit in one driver for any particular reason?

This driver cares power-off LED.
Therefore, this driver is not tristate.

> Some of these comments also apply to you second patch. All minor tweaks
> really though :).

Thank you for your comments.

Yoichi
