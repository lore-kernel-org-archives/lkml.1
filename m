Return-Path: <linux-kernel-owner+w=401wt.eu-S1758426AbYIASb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758426AbYIASb4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 14:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751465AbYIASbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 14:31:48 -0400
Received: from www.tglx.de ([62.245.132.106]:37144 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289AbYIASbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 14:31:48 -0400
Date: Mon, 1 Sep 2008 20:31:07 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
cc: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alok Kataria <akataria@vmware.com>, Michael Buesch <mb@bu3sch.de>
Subject: Re: Regression in 2.6.27 caused by commit bfc0f59
In-Reply-To: <48BC2A03.9000104@lwfinger.net>
Message-ID: <alpine.LFD.1.10.0809012018000.3243@apollo.tec.linutronix.de>
References: <48BB2116.1060904@lwfinger.net> <alpine.LFD.1.10.0809011311210.3243@apollo.tec.linutronix.de> <48BC2A03.9000104@lwfinger.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Sep 2008, Larry Finger wrote:
> Thomas Gleixner wrote:
> > > The critical differences in the dmesg output between the "good" and "bad"
> > > results indicate a factor of 2 difference in the clock speed, and are
> > > shown
> > > below:
> > 
> > > +Clocksource tsc unstable (delta = 500037272 ns)
> > 
> > > -Clocksource tsc unstable (delta = 83950402 ns)
> > 
> > In both cases the TSC is ahead of the pm_timer, which looks like the
> > pm_timer is behaving strange.
> > 
> > Can you please disable the pm_timer (in the kernel config,
> > unfortunately there is no command line option for that) for a test and
> > provide the relevant output of demsg ?
> 
> It took a while to figure out how to kill the pm_timer. I finally did it by
> changing the default to no rather than yes. I also reset the bisection and
> compiled a full -rc4 kernel.
> 
> What I hope is the relevant output of dmesg is below. The clock rate is
> correctly determined, and the b43legacy errors are gone.

Hmm. Haven't seen that before, but if confirms what I guessed from
your previous dmesg information. I wonder why you did not observe
strange behaviour with older kernel versions. I don't mean the
b43legacy errors, which might be caused by the wrong calibrated TSC,
but those even should show strange behaviour vs. time.

Can you please provide the output of an older "working" kernel version
from:

# cat /sys/devices/system/clocksource/clocksource0/current_clocksource

after the TSC was set to unstable. It should say acpi_pm.

If that's the case please run
 
# time sleep 60

on a shell and provide the output and verify it against a knwn to be
halfways correct stopwatch.

Then do the same on the current mainline with pm_timer
disabled. current clocksource should be either jiffies or tsc.

Thanks,

	tglx
