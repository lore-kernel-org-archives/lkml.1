Return-Path: <linux-kernel-owner+w=401wt.eu-S1161685AbXBOXK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161685AbXBOXK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 18:10:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161680AbXBOXK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 18:10:26 -0500
Received: from tim.rpsys.net ([194.106.48.114]:38534 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161685AbXBOXKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 18:10:22 -0500
Subject: Re: [PATCH] input: extend EV_LED
From: Richard Purdie <rpurdie@rpsys.net>
To: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: Pavel Machek <pavel@ucw.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
In-Reply-To: <freemail.20070115234756.58787@fm13.freemail.hu>
References: <freemail.20070115234756.58787@fm13.freemail.hu>
Content-Type: text/plain; charset=ISO-8859-1
Date: Thu, 15 Feb 2007 23:09:03 +0000
Message-Id: <1171580944.5839.38.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-15 at 23:47 +0100, Németh Márton wrote:
> Pavel Machek <pavel@ucw.cz> wrote:
> > > >I do not know the LED subsystem in detail, but I do not 
> > > >know any possibility to access the i8042 from different 
> > > >subsystem than the input subsystem.
> > > >
> > > >What do you think and recommend?
> > > 
> > > I think you need to use leds framework for what you are 
> > > trying to do.
> > 
> > I'm actually not sure if led framework can do that. It was
> > designed for leds on gpios, and handles blinking itself.

The led framework is generic. If you can write a function to turn it
on/off you can drive it with the LED framework.

> > But he could export two leds :-).
>
> what do you mean about two leds? The first one would be
> off/0.5Hz and the other off/1Hz?
> 
> I read in linux/Documentation/led-class.txt the following:
> 
> | Some leds can be programmed to flash in hardware. As this
> isn't a generic
> | LED device property, this should be exported as a device
> specific sysfs
> | attribute rather than part of the class if this
> functionality is required.
> 
> Does it mean that neither the input subsystem nor the led
> subsystem is designed for hardware acelerated blinking leds?
> Is there any usual way what attribute a hw accelerated
> blinking LED_MAIL should export?

This has been discussed in several places several times. The problem
with hardware accelerated flashing is that you're are often limited to
certain constraints (this case being no exception) and indicating what
these are to userspace in a generic fashion is difficult.

One way I've come up with is adds capability to the class to have LED
specific triggers and you can then expose these hardware capabilities as
an extra trigger specific to the LED.

Another proposal more specific to this use case was to have some
information behind the scenes which the software timer based trigger
could use to turn on the "hardware acceleration" if present and capable
of the requested mode. This might just need a function pointer in the
core so could be quite neat.

Nether patch exists yet.

Cheers,

Richard


