Return-Path: <linux-kernel-owner+w=401wt.eu-S1757652AbZJGKHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652AbZJGKHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 06:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756950AbZJGKHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 06:07:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39508 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756289AbZJGKHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 06:07:16 -0400
Date: Wed, 7 Oct 2009 11:06:38 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
Cc: Mike Frysinger <vapier@gentoo.org>, Samuel Ortiz <sameo@linux.intel.com>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH v3] mfd: ADP5520 Multifunction LCD Backlight and
 KeypadInput Device Driver
Message-ID: <20091007100638.GB3169@rakim.wolfsonmicro.main>
References: <20091006115543.GH27168@sirena.org.uk>
 <8A42379416420646B9BFAC9682273B6D0E3F4348@limkexm3.ad.analog.com>
 <20091006123658.GA31079@rakim.wolfsonmicro.main>
 <8A42379416420646B9BFAC9682273B6D0E3F4420@limkexm3.ad.analog.com>
 <20091006135836.GA3926@rakim.wolfsonmicro.main>
 <8A42379416420646B9BFAC9682273B6D0E3F46A7@limkexm3.ad.analog.com>
 <20091006144805.GA10987@rakim.wolfsonmicro.main>
 <8A42379416420646B9BFAC9682273B6D0E3F4769@limkexm3.ad.analog.com>
 <20091006160549.GA8881@rakim.wolfsonmicro.main>
 <8A42379416420646B9BFAC9682273B6D0E3F4CEE@limkexm3.ad.analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8A42379416420646B9BFAC9682273B6D0E3F4CEE@limkexm3.ad.analog.com>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07, 2009 at 09:50:43AM +0100, Hennerich, Michael wrote:

> As you said there are chip internal interrupt sources for I/Os, keypad
> presses and releases, ambient light sensor comparator states, and
> overvoltage conditions.
> The current state of the driver uses only interrupts for the keypad.
> I think you agree that its common practice to only implement
> functionality for chip features that are typically used.

Yes, but equally well it's good to avoid future issues as the driver is
enhanced.  To be honest the main thing that made me notice when reading
the patch was the use of the blocking notifier pattern to implement the
interrupt infrastructure, mostly since it doesn't look like an IRQ
driver and the naming hides the fat that that's what it is.

I think I forgot to mention it previously but there's some work on
getting a standard ALS interface in the kernel too.  I'd really expect
the GPIOs to end up being used as GPIOs in some designs as well.

> In one of your earlier posts you mentioned: "register an irq_chip for
> the interrupt controller on it.  Support for doing this on I2C devices
> was added at pretty much the same time as the IRQ_ONESHOT support."

> Can you point me to what exactly was added to support this on I2C/SPI
> devices? 

These commits (which were merged during the merge window):

4dbc9ca genirq: Do not mask oneshot edge type interrupts
399b5da genirq: Support nested threaded irq handling
70aedd2 genirq: Add buslock support

There may be some other fixup patches afterwards too, but the buslock
and nested threaded handers are the key ones.
