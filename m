Return-Path: <linux-kernel-owner+w=401wt.eu-S1756750AbYBJVDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750AbYBJVDp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 16:03:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755052AbYBJVDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 16:03:36 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39887 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754813AbYBJVDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 16:03:35 -0500
Date: Sun, 10 Feb 2008 22:03:49 +0100
From: Pavel Machek <pavel@ucw.cz>
To: David Brownell <david-b@pacbell.net>
Cc: rjw@sisk.pl, mingo@elte.hu, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] sleepy linux self-test
Message-ID: <20080210210349.GI15662@elf.ucw.cz>
References: <20080130131748.GA3796@elf.ucw.cz> <200802031321.27828.rjw@sisk.pl> <20080203131636.4100828D3E1@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <200802032229.30576.rjw@sisk.pl> <20080203224206.8FD40166811@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <20080203224831.GE2799@elf.ucw.cz> <20080203230826.C05AF9E4D0@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080203230826.C05AF9E4D0@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > The changes look good to me.
> > > 
> > > They feel unfinished to me though.  :)
> > > 
> > > Like using "jiffies" instead of a clocksource, which makes trouble
> > > since the timing covers periods with IRQs disabled.  And the test
> > > mode parameter needs work.
> >
> > Well, I'd say that timing has bigger problem, right?
> >
> > It is
> >
> > set alarm
> > 	suspend system
> > | poweroff
> > alarm expires
> > 	system resumes
> >
> > ... so you are measuring resume time + sleep time, no? 
> 
> There's no "poweroff" step when entering STR or STANDBY!
> 
> But more specifically, I avoided that issue by comparing times between
>   (a) start and end of the "suspend devices" steps;
>   (b) start and end of the "resume devices" steps.
> 
> Example output, with the relevant lines highlighted by "*":
> 
>     PM: test RTC wakeup from 'mem' suspend
>     PM: Syncing filesystems ... done.
>     PM: Preparing system for mem sleep
>     Freezing user space processes ... (elapsed 0.00 seconds) done.
>     Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
>     PM: Entering mem sleep
>     Suspending console(s)
>  *  PM: suspend devices took 0.000 seconds
>     GPIO-A may wake for 00080000
>     GPIO-C may wake for 00000008
>     GPIO-D may wake for 00000020
>     AT91: PM - wake mask 00000036, pm state 3
>     AT91: PM - no slow clock mode yet ...
>     AT91: PM - wakeup 00000002
>  *  PM: resume devices took 0.132 seconds
>     PM: Finishing wakeup.
>     Restarting tasks ... done.
> 
> The underlying clocksource has resolution of 32 KiHz, while HZ=128;
> the "suspend" more typically reports 7 msec.  And there should be a
> few more wakeup GPIOs, except I seem to not have enabled gpio_keys.
> That "wakeup 00000002" means the heavily-overloaded "system" IRQ
> woke the system ... the RTC is on that IRQ line.

Aha, that should work, yes. Sorry for noise.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
