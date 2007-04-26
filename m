Return-Path: <linux-kernel-owner+w=401wt.eu-S1755174AbXDZWyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbXDZWyG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 18:54:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755176AbXDZWyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 18:54:06 -0400
Received: from mail32.syd.optusnet.com.au ([211.29.132.63]:57814 "EHLO
	mail32.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755174AbXDZWyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 18:54:04 -0400
From: Con Kolivas <kernel@kolivas.org>
To: ck@vds.kolivas.org, linux-kernel@vger.kernel.org
Subject: Re: [ck] Re: Best nice level for X with SD
Date: Fri, 27 Apr 2007 08:52:16 +1000
User-Agent: KMail/1.9.5
Cc: Martin Steigerwald <Martin@lichtvoll.de>
References: <200704241552.52552.Martin@lichtvoll.de> <200704242233.45304.Martin@lichtvoll.de> <200704262211.53393.Martin@lichtvoll.de>
In-Reply-To: <200704262211.53393.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704270852.17150.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 April 2007 06:11, Martin Steigerwald wrote:
> Am Dienstag 24 April 2007 schrieb Martin Steigerwald:
> > Hello once again,
> >
> > I now tested cfs-v5 on my ThinkPad T23 with
> >
> > martin@deepdance:~> cat /proc/version
> > Linux version 2.6.20.7-tp23-sws2-2.2.9.9-sd-0.46 (martin@deepdance)
> > (gcc-Version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #1 PREEMPT
> > Sun Apr 22 21:40:30 CEST 2007
> >
> > I had the KDE desktop + Amarok running and nothing else. But music
> > playbacks stopped for about a second every now and then. Quite
> > annoyingly often. I think thats quite similar to the mouse pointer
> > freezes I had on the T42. I did not look whether the mousepointer
> > really froze, but I can check that again.
> >
> > I then did the same naive user test than I did with sd-0.44 and
> > sd-0.46, starting building debian kernel-source package, opening lots
> > of applications - mostly KDE ones, anything I could find on my toolbar
> > from Konsole, KWrite  to Konqueror, Iceweasel ... - and then moved
> > around Amaroks window. Well I managed to completely stop music playback
> > for more than 5 seconds. Music playback completely paused. This again
> > was with nice -10 configured in CFSv5 source.
> >
> > I repeated the test with X.org reniced to 0. It got better but I still
> > managed to pause music playback for a second or so. But maybe that was
> > one of that music stops that also happen when the machine is idling
> > around. They also happen with X.org reniced to 0.
>
> Hi!
>
> Okay, this got way better with cfs-v6. I tested my way through this with
> different cfs versions and settings as guided by Ingo. We did this via
> private mail as Ingo didn't want to (ab)use the ck-patch mailinglist for
> this. But now after having ranted publically about cfs, I at least also
> write publically that things have gotten better ;-).
>
> After having a drastic sound playback regression cfs-v6-rc7 which I could
> not reproduce today, I have way better results with cfs-v6 than with
> cfs-v5. This is with 2.6.20.7, sws2 2.2.9.9 and cfs-v6.
>
> But still there were some pauses in music playback with default setting.
>
> For smooth music playback with Amarok on my T23 I had to go as low as:
>
> ---------------------------------------------------------------------
> deepdance:/proc/sys/kernel> grep ".*" sched*gran*
> sched_granularity_ns:2000000
> sched_wakeup_granularity_ns:0
> deepdance:/proc/sys/kernel> echo "1500000" >sched_granularity_ns
> deepdance:/proc/sys/kernel> grep ".*" sched*gran*
> sched_granularity_ns:1500000
> sched_wakeup_granularity_ns:0
> deepdance:/proc/sys/kernel> echo "1000000" >sched_granularity_ns
> deepdance:/proc/sys/kernel> grep ".*" sched*gran*
> sched_granularity_ns:1000000
> sched_wakeup_granularity_ns:0
> deepdance:/proc/sys/kernel> echo "500000" >sched_granularity_ns
> deepdance:/proc/sys/kernel> grep ".*" sched*gran*
> sched_granularity_ns:500000
> sched_wakeup_granularity_ns:0
> deepdance:/proc/sys/kernel> echo "250000" >sched_granularity_ns
> deepdance:/proc/sys/kernel> grep ".*" sched*gran*
> sched_granularity_ns:250000
> sched_wakeup_granularity_ns:0
> ---------------------------------------------------------------------
>
> Then music playback was working nicely when I did not interfere ;-)
>
> Even then I was able to stop audio playback for longer than a second by my
> naive user test... compiling a kernel, opening lots of apps and moving
> the Amarok window around like mad.
>
> With
>
> ---------------------------------------------------------------------
> deepdance:/proc/sys/kernel> echo "0" >sched_granularity_ns
> deepdance:/proc/sys/kernel> grep ".*" sched*gran*
> sched_granularity_ns:0
> sched_wakeup_granularity_ns:0
> ---------------------------------------------------------------------
>
> it was working nice. Subjectively on par with sd-0.46.
>
> buddabrod can you test these suggestions? I am using cfs-v6 with X11
> renicing.

Clearly there are some serious regressions for audio playback with CFS.
This is incredible effort to go to with CFS. 

> Still sd-0.46 is giving me as default what I have to configure with
> cfs-v6 ;-). And as a user I want this behavior as default, instead of
> having to fiddle with the schedular settings. Smooth music playback is a
> must as Ingo agreed already ;).

Nice to hear that SD does everything CFS strives to achieve. I'm glad I 
continued development on it so that it remains the reference for CFS to 
compare to.

> No need to continue that thread here from my side... I just wanted to
> mention that it got better. Its still Cons ck-patch list. A general
> scheduler hacking and testing list would come in handy I guess.

lkml is perfectly suited for that discussion provided everyone follows the 
convention of cc'ing everyone on their replies, and I have taken the liberty 
of cc'ing it on this thread too.

-- 
-ck
