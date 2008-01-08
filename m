Return-Path: <linux-kernel-owner+w=401wt.eu-S1755672AbYAHTP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672AbYAHTP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 14:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbYAHTPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 14:15:17 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35130 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751462AbYAHTPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 14:15:16 -0500
Date: Tue, 8 Jan 2008 20:15:20 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC] sleepy linux
Message-ID: <20080108191519.GA1690@elf.ucw.cz>
References: <20071225230731.GA29030@elf.ucw.cz> <20071230111552.GA8578@elte.hu> <20080105215123.GA21565@elf.ucw.cz> <20080108163744.GB13746@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108163744.GB13746@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> 
> > > a quick feature request: could you please make the wake-on-RTC 
> > > capability generic and add a CONFIG_DEBUG_SUSPEND_ON_RAM=y config 
> > > option (disabled by default) that does a short 1-second 
> > > suspend-to-RAM sequence upon bootup? That way we could test s2ram 
> > > automatically (which is a MUCH needed feature for automated 
> > > regression testing and automatic bisection). In addition, some sort 
> > > of 'suspend for N seconds' /sys or /dev/rtc capability would be nice 
> > > as well.
> > 
> > Hmm, are you sure it is good idea to do this from kernel? I guess this 
> > is better done from script...
> 
> i have this low-prio effort to make all self-checks automatically 
> available via 'make randconfig' as well, for all features that have no 
> natural exposure during normal bootup. So far we've got rcutorture, 
> kprobes-check, locking/lockdep-self-test and a handful of others. 
> External scripts tend to go out of sync and LTP takes way too much time 
> to finish.

Well, I can give you a three liner, and if it stops working, I'll
treat is as a regression, because userland ABI changed...?

Or you can get about 10 lines of C, no problem, but I do not think
that should be merged to Linus.

> > > btw., how far are you from having a working prototype?
> > 
> > SCSI/SATA issues stop me just now, but even if I get that to work, it 
> > will be extremely disgusting hack... and it is unclear how to do it 
> > nicely :-(.
> 
> as long as the sleep periods are within say 10-20 seconds, and our s2ram 
> cycle is fast and optimal enough, we could do this with networking 
> enabled too, without dropping/stalling TCP connections left and
> right.

I do not think TCP would survive "10 seconds sleep, 1 second up". But...

> (Perhaps if we could notify routers that they should batch packets for N 
> seconds and we could turn off PHY during that time, it would be even 
> nicer - is there any such router extension in existence?)

...yes, we should probably play with the routers.

> but if it's nothing else but a s2ram debug/stress utility, that alone 
> would be great too :-)

 I expect to stress s2ram way too much ;-).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
