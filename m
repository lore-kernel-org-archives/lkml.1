Return-Path: <linux-kernel-owner+w=401wt.eu-S932373AbZJFMhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932373AbZJFMhh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 08:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932266AbZJFMhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 08:37:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54222 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932261AbZJFMhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 08:37:36 -0400
Date: Tue, 6 Oct 2009 13:36:58 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
Cc: Mike Frysinger <vapier@gentoo.org>, Samuel Ortiz <sameo@linux.intel.com>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH v3] mfd: ADP5520 Multifunction LCD Backlight and
 KeypadInput Device Driver
Message-ID: <20091006123658.GA31079@rakim.wolfsonmicro.main>
References: <1253682664-27040-1-git-send-email-vapier@gentoo.org>
 <1254815071-15822-1-git-send-email-vapier@gentoo.org>
 <20091006115543.GH27168@sirena.org.uk>
 <8A42379416420646B9BFAC9682273B6D0E3F4348@limkexm3.ad.analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8A42379416420646B9BFAC9682273B6D0E3F4348@limkexm3.ad.analog.com>
X-Cookie: Absence makes the heart go wander.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 01:23:52PM +0100, Hennerich, Michael wrote:
> >From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]

> >This notifier stuff looks an awful lot like an interrupt controller
> >driver.  Now that it's possible to implement support for an I2C/SPI
> >driven interrupt controller it'd be good to use that rather than having
> >a custom API if that's possible.

> Honestly this notifier chain is a clean approach and serves its purpose
> here pretty well.
> IMHO it's much more preferable than pretending there is a virtual GPIO
> that doesn't exist and a MFD subdev could request.

I'm not sure what the association with virtual gpios is?  This is all
separate to gpiolib except in that it would mean that a gpio driver for
the device would be able to export these interrupts to its clients.

> >> +	u8 led_on_time;

> >I don't know exactly what the on_time option does but if it controls
> >hardware-implemented blinking there's actually a callback function the

> Yes its hardware controlled blinking. I noticed the leds timer trigger
> driver.
> People can still use it - the downside with the hardware assisted
> blinking is that all LEDs share the same on_time. So I decided against
> using the callback.

Ah, if it affects all LEDs then it isn't suitable for the callback at
all.
