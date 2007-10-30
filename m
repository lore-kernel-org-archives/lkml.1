Return-Path: <linux-kernel-owner+w=401wt.eu-S1756103AbXJ3VIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbXJ3VIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 17:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463AbXJ3VHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 17:07:53 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:52617 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbXJ3VHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 17:07:53 -0400
Date: Tue, 30 Oct 2007 22:08:01 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [2.6.23] IBM X41 looses time after Suspend2Disk
Message-ID: <20071030210801.GA1767@elf.ucw.cz>
References: <20071029201955.GA1955@titan.lahn.de> <20071029212414.GD3692@elf.ucw.cz> <20071029201955.GA1955@titan.lahn.de> <200710292205.11459.rjw@sisk.pl> <20071030083537.GA2797@titan.lahn.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071030083537.GA2797@titan.lahn.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2007-10-30 09:35:37, Philipp Matthias Hahn wrote:
> Hello Rafael, Pavel!
> 
> Thank you both for the fast help.
> 
> On Mon, Oct 29, 2007 at 10:05:10PM +0100, Rafael J. Wysocki wrote:
> > On Monday, 29 October 2007 21:19, Philipp Matthias Hahn wrote:
> > > I have an IBM X41 tablet pc running 2.6.23 with the following problem:
> > > Suspend2Ram work fine, but when I do a Suspend2Disk (echo disk >
> > > /sys/power/state), the notebook hangs showing the following lines:
> ...
> > >         Suspending console(s)
> > > 
> > > When I repeatedly press some keys or move the TrackPoint, the SwSusp
> > > continues and the notebook powers off.
> > > On reboot, the notebook resumes but hangs showing the following screen:
> ...
> > >         Suspending console(s)
> > > 
> > > Generating interrupts by pressing keys or moving the TrackPoints makes
> > > the resume continue. But after that, the notebook looses time, xterms
> > > don't get updated until I press a key, the beeper beeps until I press a
> > > key, etc.
> ...
> > Please try to do "echo shutdown > /sys/power/disk" before hibernation and
> > see what happens.
> 
> I'm already doing that.
> 
> > Also, is it an SMP kernel or UP?
> 
> UP.
> 
> 
> On Mon, Oct 29, 2007 at 10:24:14PM +0100, Pavel Machek wrote:
> > Yep, I seen that before. Try "nohz=off".
> 
> Okay, that seems to solve the "timer loosing time after resume" problem.
> 
> 
> But I still need to press some keys on suspend (7-12 key presses and
> releases) to unhang it. On resume not key presses are needed any
> more.

So it fixed resume but not suspend? strange. Try highres=off, too. And
maybe irqpoll?

You may want to try cpu hotplug separately...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
