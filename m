Return-Path: <linux-kernel-owner+w=401wt.eu-S1757464AbXKWMWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464AbXKWMWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 07:22:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756209AbXKWMWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 07:22:22 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:58298 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601AbXKWMWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 07:22:21 -0500
Date: Fri, 23 Nov 2007 13:22:54 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: nohz and strange sleep latencies
Message-ID: <20071123122254.GC2055@elf.ucw.cz>
References: <20071119203152.GA1772@elf.ucw.cz> <20071119205555.GA28696@elte.hu> <20071119211142.GA1857@elf.ucw.cz> <20071120085704.GA19950@elte.hu> <20071120105458.GA1597@elf.ucw.cz> <20071120205454.GD10008@elte.hu> <alpine.LFD.0.9999.0711202345520.25057@localhost.localdomain> <20071120225246.GA24380@elte.hu> <20071122185238.GA1821@elf.ucw.cz> <alpine.LFD.0.9999.0711222121500.25057@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0711222121500.25057@localhost.localdomain>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > but perhaps somehow we miss this fact and fail to turn off the lapic 
> > > clockevents drivers?
> > 
> > Ok, I guess I'm lost. If I offline second CPU, I immediately get
> > 1000Hz timer tick... is that expected?
> 
> Hmm. No. I have no idea why this is happening.
> 
> 34196 total events, 55.083 events/sec
> echo 0 >/sys/devices/system/cpu/cpu1/online
> 36073 total events, 54.679 events/sec

Strange.

> > I'm trying to decide when system is idle (lets say that means "no user
> > task is scheduled to wakeup within 10 seconds)... I added some
> > instrumentation to nohz subsystem, but it does not behave like I'd
> > expect: even if I run "while true; do sleep .01; done" loop, I see
> > nohz preparing for 5 seconds sleep... while it seems obvious that it
> > can only be 10msec sleep, and with max_cstate=1, it works that
> > way... Plus, nte->start_pid seems to contain some random numbers :-(.
> > 
> > What am I doing wrong?
> > 
> > (Patch for illustration, I can generate full diff against vanilla,
> > but...)
> 
> Just to make sure what we are hunting: Do you have the same problem
> with an non-pavel-tainted 2.6.24-rc3 ?

The strange sleep latencies were definitely there, I'll check for
"offline cpu and get 1000 interrupts", too.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
