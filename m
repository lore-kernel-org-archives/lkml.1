Return-Path: <linux-kernel-owner+w=401wt.eu-S1751219AbXBROmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751219AbXBROmW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 09:42:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbXBROmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 09:42:22 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:59443 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751219AbXBROmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 09:42:21 -0500
X-Sasl-enc: x6KD4CaBLIIRN6tQLOtJqzsUmstrL+leQgU+Ujzf3GxB 1171809778
Date: Sun, 18 Feb 2007 12:42:12 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: extend EV_LED
Message-ID: <20070218144212.GA23561@khazad-dum.debian.net>
References: <freemail.20070115234756.58787@fm13.freemail.hu> <1171580944.5839.38.camel@localhost.localdomain> <20070216031219.GA2397@khazad-dum.debian.net> <1171796756.5816.20.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171796756.5816.20.camel@localhost.localdomain>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Feb 2007, Richard Purdie wrote:
> I just said that finding a way to do it generically is difficult, not
> that we shouldn't do it.

Very well, let's do it, then.

> Even if half your functionality is exposed through the class, that half
> that is standardised rather than adhoc. Having said that, you shouldn't
> need any custom attributes though.

Yes, that's my point.  Blinking is too common, it needs to be generic (and I
don't care if it is done through triggers, as long as it is generic *and*
hardware-implementation-friendly, I will use it).

> Right, but blinking is not an LED attribute but more of an action for
> the LED so what we need is an LED blink trigger. Rather than the timer
> trigger which takes a variety of options, this blink trigger could just
> take an on/off value. In the absence of hardware capability, we can
> emulate it. I like the idea of a simple blink trigger...

If you have a 2.6.20 backport of the new LED class, I could work on it when
I finish the ibm-acpi conversion to sysfs, which should take about one more
week.

> If a trigger/attribute appears for an LED, its behaviour needs to be the
> same for all LEDs. 

Agreed.

BTW: I need to have two leds that are the same device, different colors.
The code already handles this just fine (it is NOT a multicolor led), I'd
like to know how should I name the parameter?

power:green and power:yellow?

That should be done in a standard way as well.

> The enum reflects a spectrum of loosely defined frequencies, a bit like
> brightness maybe in a range 0-6. The idea is these are loose definitions
> and the driver will attempt a loose match, using any hardware blinking
> if available.

Add the following functionality, and I think I would be happy with the
interface:

1. A way for the driver to say "led access is expensive, do not enable
software blink emulation"  (maybe you already have this...)

2. A way for userspace to either know which ranges are hardware-emulated, or
to request that only hardware emulation be used.

I can live with just (1), but I think (2) would make the interface more
complete.  Keep in mind that whatever can be hardware-emulated is probably
the default way to use that led, so it is an interesting data-point for
userspace.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
