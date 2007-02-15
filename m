Return-Path: <linux-kernel-owner+w=401wt.eu-S1422706AbXBOXZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422706AbXBOXZA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 18:25:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422704AbXBOXZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 18:25:00 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:42154 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422706AbXBOXY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 18:24:59 -0500
Date: Fri, 16 Feb 2007 00:24:38 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: =?iso-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: extend EV_LED
Message-ID: <20070215232438.GB4176@elf.ucw.cz>
References: <freemail.20070115234756.58787@fm13.freemail.hu> <1171580944.5839.38.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171580944.5839.38.camel@localhost.localdomain>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > >I do not know the LED subsystem in detail, but I do not 
> > > > >know any possibility to access the i8042 from different 
> > > > >subsystem than the input subsystem.
> > > > >
> > > > >What do you think and recommend?
> > > > 
> > > > I think you need to use leds framework for what you are 
> > > > trying to do.
> > > 
> > > I'm actually not sure if led framework can do that. It was
> > > designed for leds on gpios, and handles blinking itself.
> 
> The led framework is generic. If you can write a function to turn it
> on/off you can drive it with the LED framework.

Even if that function is slow and sleeps?

> > > But he could export two leds :-).
> >
> > what do you mean about two leds? The first one would be
> > off/0.5Hz and the other off/1Hz?
> > 
> > I read in linux/Documentation/led-class.txt the following:
> > 
> > | Some leds can be programmed to flash in hardware. As this
> > isn't a generic
> > | LED device property, this should be exported as a device
> > specific sysfs
> > | attribute rather than part of the class if this
> > functionality is required.
> > 
> > Does it mean that neither the input subsystem nor the led
> > subsystem is designed for hardware acelerated blinking leds?
> > Is there any usual way what attribute a hw accelerated
> > blinking LED_MAIL should export?
> 
> This has been discussed in several places several times. The problem
> with hardware accelerated flashing is that you're are often limited to
> certain constraints (this case being no exception) and indicating what
> these are to userspace in a generic fashion is difficult.
> 
> One way I've come up with is adds capability to the class to have LED
> specific triggers and you can then expose these hardware capabilities as
> an extra trigger specific to the LED.
> 
> Another proposal more specific to this use case was to have some
> information behind the scenes which the software timer based trigger
> could use to turn on the "hardware acceleration" if present and capable
> of the requested mode. This might just need a function pointer in the
> core so could be quite neat.

I do not think we want to permit this led to run in "not accelerated"
mode. I believe i8042 accesses are pretty expensive.

> Nether patch exists yet.

Yep, interested party should create one of them :-). (And I'd prefer
the first one, due to i8042 slowness).

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
