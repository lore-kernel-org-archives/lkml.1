Return-Path: <linux-kernel-owner+w=401wt.eu-S1758193AbXEaQKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193AbXEaQKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 12:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbXEaQKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 12:10:11 -0400
Received: from tim.rpsys.net ([194.106.48.114]:44208 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945AbXEaQKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 12:10:09 -0400
Subject: Re: [PATCH] Support for controlling leds on xbox 360 pad.
From: Richard Purdie <rpurdie@rpsys.net>
To: Jan Kratochvil <honza@jikos.cz>
Cc: Pavel Machek <pavel@ucw.cz>, dtor@mail.ru, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LRH.0.98.0705311740520.22353@twin.jikos.cz>
References: <alpine.LRH.0.98.0705292250430.22353@twin.jikos.cz>
	 <20070531140715.GA5943@ucw.cz>
	 <alpine.LRH.0.98.0705311740520.22353@twin.jikos.cz>
Content-Type: text/plain
Date: Thu, 31 May 2007 17:09:26 +0100
Message-Id: <1180627767.5863.80.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 2007-05-31 at 17:53 +0200, Jan Kratochvil wrote:
> On Thu, 31 May 2007, Pavel Machek wrote:
> >> Led subsystem allows us to set brightness, but there is
> >> nothing like brightness on this device. So brightness is
> >> actually interpreted as the command (only values between
> >> 0 and 14 are accepted).
> >
> > Ugh, no, I do not think we want to do that.
> 
> finally! I was surprised that it took so long before someone made objection to 
> this.

:)

This hadn't gone unnoticed by me and I didn't like it either at first
however I had a look at the hardware specs and your summary below is
pretty accurate...

> I agree that interpreting brightness as command isn't nice. But what other 
> options do I have?
>   a) Do not use led subystem, and do everything on my own
>   b) Do not allow user to change state of leds on this device
>   c) Extend led subsystem to have something like command. But it is in 
> contradiction with desired simplicity of led sybsystem.

Since the commands are so device specific and no new device will be the
same, I doubt this is worth doing (or possible) in a generic way so
you're back to a).

>   d) Control leds via force feedback effect
>   e) Make 4 leds available and use brightness 0 for off and 255 for on. But only 
> one of them can be active at one time. And I'll give up some flashing effects.

If you expose 4 leds, you break the API badly as only one can be active.
That is worse than using the brightness parameter IMO.

> Well actually I don't like this options. Any suggestions? Thanks!

After consideration, I agree with your approach of using the brightness
and I don't have a better suggestion. Its not ideal but its a good
compromise since it doesn't really impose any limitations on your use of
the hardware but doesn't need a custom implementation which is the
alternative. The mode is still a kind of brightness setting if you twist
the definition a bit ;-).

Cheers,

Richard


