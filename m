Return-Path: <linux-kernel-owner+w=401wt.eu-S1757897AbZFXNjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897AbZFXNjW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 09:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbZFXNjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 09:39:13 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:37700 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbZFXNjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 09:39:12 -0400
Date: Wed, 24 Jun 2009 15:39:11 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Miroslav Lichvar <mlichvar@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT pull] ntp updates for 2.6.31
Message-ID: <20090624153911.3bd2cb15@skybase>
In-Reply-To: <20090624102915.4df3fa85@lxorguk.ukuu.org.uk>
References: <1f1b08da0906151316s7d25f8ceraa1bc967a8abe172@mail.gmail.com>
	<1f1b08da0906151641u4cd964e6vf1a61afe50cc1d90@mail.gmail.com>
	<20090616090647.GD13771@elte.hu>
	<20090616125248.GA23541@localhost>
	<1245253102.6067.94.camel@jstultz-laptop>
	<20090617172325.GA32332@localhost>
	<20090617172601.GA3493@elte.hu>
	<20090618121320.GA13025@localhost>
	<20090623095745.GC30634@elte.hu>
	<20090623131628.GA11827@localhost>
	<20090623133625.GA3026@elte.hu>
	<1245793316.3305.5.camel@localhost>
	<20090624102915.4df3fa85@lxorguk.ukuu.org.uk>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jun 2009 10:29:15 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > At some point that stops being NTP. NTP has quite a bit of userland
> > policy for filtering and managing a number of different network clocks
> > (other ntp servers, PPS sources, etc).
> >   
> > >From what you're describing (direct offset from a hardware time device  
> > used to steer the clock directly in kernel), you might want to look at
> > the STP code in s390 (stp_sync_clock).  
> 
> And also hardware distributed timing systems like those that distribute a
> clock with ethernet signals.

The STP clock synchronization works below the kernel. Usually we don't
notice the clock drift at all, the kernel has the illusion of a perfect
clock. Only if the delta is over the clock synchronization tolerance
the hardware causes a machine check. Then it becomes the job of the
operating system to deal with the clock delta. The current Linux code
applies the offset to the hardware clock (which makes the TOD clock
non-monotonic) and applies the same offset to the base value
sched_clock_base_cc to even out the effect. Then a single shot
adjustment is passed to NTP to get the system time in sync with the
hardware clock again.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

