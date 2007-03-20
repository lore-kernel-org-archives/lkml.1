Return-Path: <linux-kernel-owner+w=401wt.eu-S1751073AbXCTQig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751073AbXCTQig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 12:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbXCTQig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 12:38:36 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:40548 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751073AbXCTQif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 12:38:35 -0400
Date: Tue, 20 Mar 2007 17:38:26 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Len Brown <len.brown@intel.com>
Cc: Andreas Mohr <andi@rhlx01.fht-esslingen.de>, vojtech@suse.cz,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: strange keyboard lag after suspend testing
Message-ID: <20070320163826.GA7092@elf.ucw.cz>
References: <20070320153332.GA5533@elf.ucw.cz> <20070320160006.GA14843@rhlx01.hs-esslingen.de> <20070320160338.GC5533@elf.ucw.cz> <d120d5000703200909v326ab6benc3fb85badc061018@mail.gmail.com> <20070320163113.GA5740@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070320163113.GA5740@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > >> > I was testing suspend in 2.6.21-rc4 a lot, and now... machine feels
> > >> > like someone added 50..100msec delay somewhere in keyboard
> > >> > handling. Mouse does not seem affected. /proc/interrupts seem to
> > >> > increase as they should, for both keyboard and mouse. Can someone
> > >> > reproduce it? Any ideas how to debug it?
> > >>
> > >> Probably just asking the obvious:
> > >> it's not a trivial "failed to re-configure repeat rate upon resume"
> > >> (which one could rule out by running "kbdrate" again)
> > >> but a lag in some interrupt handler or somewhere else deeper, right?
> > >
> > >No, it is not keyboard rate. Keyboard lags during normal typing,
> > >sometimes letters come in groups of two or so...
> > 
> > I might start looking at embedded controller changes and switches. If
> > ACPI misbehaves that could starve keyboard controller... But you
> > said
> 
> Mouse _seems_ okay, but I'm not sure if I'd notice lag there.
> 
> > that mouse is OK... Hmm, what happens if you load evbug and type while
> > watching syslog. Do you observe the same delays?
> 
> Hmm, seems that it only happens in X... so maybe it is some strange
> scheduling artefact?
> 
> Hmm, something is wrong here:
> 
> On console, I get expected 4-5 ticks a second. In x in gnome-terminal,
> I get this:

It gets weirder: I killed some tasks and now: (on unloaded system
running X, notice that top latency was ~1sec at 33:09).

root@amd:~# while true ; do echo -n . ; sleep .2; date; done
.Tue Mar 20 17:33:07 CET 2007
.Tue Mar 20 17:33:07 CET 2007
.Tue Mar 20 17:33:08 CET 2007
.Tue Mar 20 17:33:08 CET 2007
.Tue Mar 20 17:33:08 CET 2007
.Tue Mar 20 17:33:08 CET 2007
.Tue Mar 20 17:33:09 CET 2007
.Tue Mar 20 17:33:10 CET 2007
.Tue Mar 20 17:33:10 CET 2007
.Tue Mar 20 17:33:10 CET 2007
.Tue Mar 20 17:33:10 CET 2007
.Tue Mar 20 17:33:10 CET 2007
.Tue Mar 20 17:33:11 CET 2007
.Tue Mar 20 17:33:11 CET 2007
.Tue Mar 20 17:33:11 CET 2007
.Tue Mar 20 17:33:12 CET 2007
.Tue Mar 20 17:33:12 CET 2007

As soon as I load the cpu up with while1, machine starts to behave.

When I turn on bluetooth (USB), ACPI can no longer use C3, and machine
starts to behave. Hmm?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
