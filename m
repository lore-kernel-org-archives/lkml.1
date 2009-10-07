Return-Path: <linux-kernel-owner+w=401wt.eu-S934181AbZJGIv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934181AbZJGIv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934146AbZJGIv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:51:27 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:9270 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934121AbZJGIv0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:51:26 -0400
X-IronPort-AV: E=Sophos;i="4.44,518,1249272000"; 
   d="scan'208";a="7277509"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v3] mfd: ADP5520 Multifunction LCD Backlight and KeypadInput Device Driver
Date: Wed, 7 Oct 2009 09:50:43 +0100
Message-ID: <8A42379416420646B9BFAC9682273B6D0E3F4CEE@limkexm3.ad.analog.com>
In-Reply-To: <20091006160549.GA8881@rakim.wolfsonmicro.main>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [PATCH v3] mfd: ADP5520 Multifunction LCD Backlight and KeypadInput Device Driver
thread-index: AcpGnuTO4EkaRpUwSIOgs532m6xe+gAidTIw
References: <1253682664-27040-1-git-send-email-vapier@gentoo.org> <1254815071-15822-1-git-send-email-vapier@gentoo.org> <20091006115543.GH27168@sirena.org.uk> <8A42379416420646B9BFAC9682273B6D0E3F4348@limkexm3.ad.analog.com> <20091006123658.GA31079@rakim.wolfsonmicro.main> <8A42379416420646B9BFAC9682273B6D0E3F4420@limkexm3.ad.analog.com> <20091006135836.GA3926@rakim.wolfsonmicro.main> <8A42379416420646B9BFAC9682273B6D0E3F46A7@limkexm3.ad.analog.com> <20091006144805.GA10987@rakim.wolfsonmicro.main> <8A42379416420646B9BFAC9682273B6D0E3F4769@limkexm3.ad.analog.com> <20091006160549.GA8881@rakim.wolfsonmicro.main>
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: "Mark Brown" <broonie@opensource.wolfsonmicro.com>
CC: "Mike Frysinger" <vapier@gentoo.org>,
       "Samuel Ortiz" <sameo@linux.intel.com>,
       <uclinux-dist-devel@blackfin.uclinux.org>,
       <linux-kernel@vger.kernel.org>, "Bryan Wu" <cooloney@kernel.org>
X-OriginalArrivalTime: 07 Oct 2009 08:50:45.0748 (UTC) FILETIME=[42730340:01CA472B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
>On Tue, Oct 06, 2009 at 04:05:45PM +0100, Hennerich, Michael wrote:
>> >From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
>
>> >According to the datasheet the GPIOs, light sensor and regulator can
>> >also generate interrupts?
>
>> Right - I know - but none of the subdevs are currently using this
>> functionality.
>
>You weren't very clear on the difference between the current state of
>the drivers and the capabilities of the chip there.

As you said there are chip internal interrupt sources for I/Os, keypad
presses and releases, ambient light sensor comparator states, and
overvoltage conditions.
The current state of the driver uses only interrupts for the keypad.
I think you agree that its common practice to only implement
functionality for chip features that are typically used.
There are exactly 8 GP signals which are muxed with Keypad and GPIO. In
case you use a 4x4 Keypad there is no GPIO left.
In case you use a 3x4 Keypad there is exactly 1 GPIO that can be exposed
to the gpiolib.

In one of your earlier posts you mentioned: "register an irq_chip for
the interrupt controller on it.  Support for doing this on I2C devices
was added at pretty much the same time as the IRQ_ONESHOT support."

Can you point me to what exactly was added to support this on I2C/SPI
devices? 

-Michael
