Return-Path: <linux-kernel-owner+w=401wt.eu-S1757891AbYD2DoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891AbYD2DoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 23:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbYD2DoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 23:44:06 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:25487 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752551AbYD2DoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 23:44:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=QTKW6DqOW054jZnivKHg145nkRw2SyDVNBHnLkxjcgVVR6y1VpRKjLSfPmiZMzNGbzV8rDGOLfZlJYi2c/wDNTcNZtIp71pkY7Vl6/gdj+c5i5p6efrySQwWf/+NqvVO50c6uS8pMXWZddEeu7uCmw2FrOoaGA/ouWDmKr4epiM=  ;
X-YMail-OSG: ELIY0NYVM1mQXu_9qBo8i8eUO7rL.X5ghcDEzUoAE391FODADuTi2oHdKCF9Gklgm6tVCi9VKwTVEwRV8ImchvYMme64k7c5ELrzVbB1XYTdbPtKjamX.HsYOeN0.7WUbUQ-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ben Nizette <bn@niasdigital.com>
Subject: Re: [patch/rfc 2.6.25-git] gpio: sysfs interface
Date: Mon, 28 Apr 2008 20:44:00 -0700
User-Agent: KMail/1.9.6
Cc: lkml <linux-kernel@vger.kernel.org>, Trent Piepho <tpiepho@freescale.com>,
       hartleys <hartleys@visionengravers.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200804281239.51729.david-b@pacbell.net> <200804281744.11564.david-b@pacbell.net> <1209434284.14631.71.camel@moss.renham>
In-Reply-To: <1209434284.14631.71.camel@moss.renham>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804282044.00706.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 April 2008, Ben Nizette wrote:
>
> Ah well we're backwards there, though now I think of it I can't think of
> a great many valid use-cases on my side.  Just for funzies I'll post on
> the avrfreaks AVR32 support forum and see how many I can actually dig
> up.

Use cases would always help clarify things.  I've seen just
enough to make me understand this is a useful feature, and
for more reasons than just "feature equality" letting us
obsolete three drivers/i2c/chips/*.c drivers and help vanish
half a dozen (at least!) out-of-tree drivers doing that.

The Gumstix user forums and wiki may help too.  ISTR they
have such a GPIO widget (maybe that's the one I saw which
supports polling?) and have shipped it for ages ... so they
will surely have some (PXA-specific) examples lurking.


> > Trent pointed out that dynamic range assignment can make trouble,
> > so I can see some help might be needed here.  Were you suggesting
> > something like a /sys/class/gpio/chips file with contents like
> > 
> > 	0-15	gpio
> > 	16-31	gpio
> > 	32-47	gpio
> > 	48-63	gpio
> > 	192-207	mpuio
> > 	208-213	tps65010
> > 
> > (Matching a stock OMAP 5912 OSK board, for what it's worth.)
> 
> Yeah that's the kind of a thing.  Would be well worth having that info
> especially for dynamically allocated chip bases.

I'd have no problem with that.  Some people surely would though;
it has more than one value in that file!  OMG, it's readable! We
can't have any of that!!  The Earth will turn in its grave!  And
Slashdot will be decorated in Pink!  Teh End Daze arrive!  :)

 
> > > > The D-space footprint is negligible, except for the sysfs resources
> > > > associated with each exported GPIO.  The additional I-space footprint
> > > > is about half of the current size of gpiolib.  No /dev node creation
> > > > involved, and no "udev" support is needed.
> > > 
> > > Which is good for simplicity but makes async notification kinda tricky.
> > 
> > Sysfs attributes are supposed to be pollable.  I've not done it,
> > but fs/sysfs/file.c::sysfs_notify() looks relevant ...
> 
> Right, that'll work.

OK.  In that case, I think I should plan to rename the "direction"
attribute as "configuration" or something a bit broader ... so that
writing "irq" (or maybe "rising", "falling", "bothedges", "poll")
would eventually configure it as an input with an IRQ handler.

Whenever someone contributes such an async notification scheme,
that is.  ;)

- Dave
