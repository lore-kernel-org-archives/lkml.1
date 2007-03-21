Return-Path: <linux-kernel-owner+w=401wt.eu-S965345AbXCUWWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965345AbXCUWWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 18:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965363AbXCUWWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 18:22:35 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:33185 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965356AbXCUWWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 18:22:33 -0400
Date: Wed, 21 Mar 2007 23:22:16 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: Andreas Mohr <andi@rhlx01.fht-esslingen.de>, vojtech@suse.cz,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: strange keyboard lag after suspend testing
Message-ID: <20070321222216.GG6057@elf.ucw.cz>
References: <20070320163826.GA7092@elf.ucw.cz> <20070321201256.GA11560@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070321201256.GA11560@dreamland.darkstar.lan>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> > >No, it is not keyboard rate. Keyboard lags during normal typing,
> >> > >sometimes letters come in groups of two or so...
> >> > 
> >> > I might start looking at embedded controller changes and switches. If
> >> > ACPI misbehaves that could starve keyboard controller... But you
> >> > said
> >> 
> >> Mouse _seems_ okay, but I'm not sure if I'd notice lag there.
> >> 
> >> > that mouse is OK... Hmm, what happens if you load evbug and type while
> >> > watching syslog. Do you observe the same delays?
> >> 
> >> Hmm, seems that it only happens in X... so maybe it is some strange
> >> scheduling artefact?
> >> 
> >> Hmm, something is wrong here:
> >> 
> >> On console, I get expected 4-5 ticks a second. In x in gnome-terminal,
> >> I get this:
> > 
> > It gets weirder: I killed some tasks and now: (on unloaded system
> > running X, notice that top latency was ~1sec at 33:09).
> > 
> > root@amd:~# while true ; do echo -n . ; sleep .2; date; done
> > .Tue Mar 20 17:33:07 CET 2007
> > .Tue Mar 20 17:33:07 CET 2007
> > .Tue Mar 20 17:33:08 CET 2007
> > .Tue Mar 20 17:33:08 CET 2007
> > .Tue Mar 20 17:33:08 CET 2007
> > .Tue Mar 20 17:33:08 CET 2007
> > .Tue Mar 20 17:33:09 CET 2007
> > .Tue Mar 20 17:33:10 CET 2007
> > .Tue Mar 20 17:33:10 CET 2007
> > .Tue Mar 20 17:33:10 CET 2007
> > .Tue Mar 20 17:33:10 CET 2007
> > .Tue Mar 20 17:33:10 CET 2007
> > .Tue Mar 20 17:33:11 CET 2007
> > .Tue Mar 20 17:33:11 CET 2007
> > .Tue Mar 20 17:33:11 CET 2007
> > .Tue Mar 20 17:33:12 CET 2007
> > .Tue Mar 20 17:33:12 CET 2007
> > 
> > As soon as I load the cpu up with while1, machine starts to behave.
> > 
> > When I turn on bluetooth (USB), ACPI can no longer use C3, and machine
> > starts to behave. Hmm?
> 
> When the CPU is in C3 the TSC and LAPIC (IIRC) are stopped, sounds like
> the problem is here. Maybe after resume kernel fails to fall back to a
> "safe" clocksource.

Notice that problem is _not_ easily reproducible :-(. One suspend is
not enough to trigger it.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
