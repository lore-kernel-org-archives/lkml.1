Return-Path: <linux-kernel-owner+w=401wt.eu-S1758627AbYGPXUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758627AbYGPXUR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 19:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759146AbYGPXUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 19:20:04 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:48212 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759174AbYGPXUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 19:20:03 -0400
Date: Wed, 16 Jul 2008 16:18:52 -0700 (PDT)
From: Trent Piepho <tpiepho@freescale.com>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: Anton Vorontsov <avorontsov@ru.mvista.com>
cc: Richard Purdie <rpurdie@rpsys.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Kumar Gala <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH v3] leds: implement OpenFirmare GPIO LED driver
In-Reply-To: <20080715151917.GA30607@polina.dev.rtsoft.ru>
Message-ID: <Pine.LNX.4.64.0807161546010.12709@t2.domain.actdsltmp>
References: <1216133032.5345.73.camel@dax.rpnet.com>
 <20080715151917.GA30607@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2008, Anton Vorontsov wrote:
> Despite leds-gpio and leds-openfirmware-gpio similar purposes, there
> is not much code can be shared between the two drivers (both are mostly
> driver bindings anyway).

Why can't this driver use the existing gpio-led driver?  Basically, do
something like this:

of_gpio_leds_probe(...)
{
 	gpio = of_get_gpio(np, 0);
 	label = of_get_property(np, "label", NULL);

 	struct gpio_led led = {
 		.name = label,
 		.gpio = gpio,
 	};

 	pdev = platform_device_register_simple("leds-gpio", 0, NULL, 0);
 	platform_device_add_data(pdev, &led, sizeof(led));
}
