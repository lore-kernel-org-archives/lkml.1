Return-Path: <linux-kernel-owner+w=401wt.eu-S1758719AbYJKOsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758719AbYJKOsc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 10:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753752AbYJKOsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 10:48:21 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56177 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753785AbYJKOsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 10:48:20 -0400
Date: Sat, 11 Oct 2008 16:36:00 +0200
From: Pavel Machek <pavel@suse.cz>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: David Brownell <david-b@pacbell.net>, lkml <linux-kernel@vger.kernel.org>,
       Andrew Victor <linux@maxim.org.za>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH/RFC] hardware irq debouncing support
Message-ID: <20081011143600.GB1556@ucw.cz>
References: <200809241251.32606.david-b@pacbell.net> <200810071114.03219.david-b@pacbell.net> <20081008094849.752a29c0@hskinnemo-gx745.norway.atmel.com> <200810090234.41243.david-b@pacbell.net> <20081009123030.4c9607c1@hskinnemo-gx745.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081009123030.4c9607c1@hskinnemo-gx745.norway.atmel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Ok, so the limitations of various chips vary a lot...which means that
> > > it's difficult to predict what IRQF_DEBOUNCED actually does.
> > 
> > The specific QOS achieved is system-specific; the term for
> > that kind of mechanism is "hinting".  It's very clearly defined
> > what the hint means .. but a given system might not use it.
> 
> I know that, but is "hinting" really what drivers need?
> 
> > The madvise(2) system call is a userspace example of hinting.
> 
> That's different. Ignoring madvise() hints might hurt performance
> slightly, but it won't result in any fundamentally different behaviour.
> 
> On the other hand, lack of debouncing might cause the gpio_keys driver
> to report 1000 keypresses instead of one when the user pushes a button.
> That's much more harmful.
> 
> So if someone goes and replaces the debounce timer in gpio_keys with
> this IRQF_DEBOUNCE flag, it might work very well on hardware which
> happens to use a 30 ms debounce interval, but will break horribly on
> hardware with shorter debounce intervals.

Right. So you don't _replace_ debounce timer, you just do both timer
and IRQF_.

> > > > Why require "software debouncing" if perhaps the hardware could do
> > > > it all for you?
> > > 
> > > Because of the "perhaps" part of your sentence.
> > 
> > I'm not sure which sentence you refer too, but the first
> > "perhaps" above is yours!  :)
> 
> I mean that it's difficult to rely on hardware that "perhaps" can do
> debouncing for you. I think many drivers need to know for sure.

Why? You write code as if no debouncing exist...


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
