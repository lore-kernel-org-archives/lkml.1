Return-Path: <linux-kernel-owner+w=401wt.eu-S1759349AbZFWOea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759349AbZFWOea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 10:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758608AbZFWOeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 10:34:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54016 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757924AbZFWOeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 10:34:12 -0400
Date: Tue, 23 Jun 2009 16:33:23 +0200
From: Miroslav Lichvar <mlichvar@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT pull] ntp updates for 2.6.31
Message-ID: <20090623143323.GA13932@localhost>
References: <1f1b08da0906151641u4cd964e6vf1a61afe50cc1d90@mail.gmail.com> <20090616090647.GD13771@elte.hu> <20090616125248.GA23541@localhost> <1245253102.6067.94.camel@jstultz-laptop> <20090617172325.GA32332@localhost> <20090617172601.GA3493@elte.hu> <20090618121320.GA13025@localhost> <20090623095745.GC30634@elte.hu> <20090623131628.GA11827@localhost> <20090623133625.GA3026@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623133625.GA3026@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 03:36:25PM +0200, Ingo Molnar wrote:
> > I think John's tests were done on LAN and in an environment with 
> > sudden temperature changes. This is the case where frequency 
> > variations strongly dominate the noise and faster PLL performs 
> > better.
> 
> I'd also expect this to be quite similar to most everyday Linux 
> uses.

I'd say that most users keep the default distribution configs, i.e.
syncing over internet to servers from pool.ntp.org. The network jitter
is in hundreds of microseconds or even miliseconds and the temperature
changes are dominated by the noise.

> > Other NTP clients don't have to use the PLL interface. For 
> > example, chrony uses only the SINGLESHOT mode and sets the 
> > frequency directly. It has an adaptive model using linear 
> > regression, it converges really fast and in my tests performs 
> > better than NTP.
> 
> That's good. Could this be integrated into the kernel, for even 
> better results?

The code is quite complex with possibly lot of room for improvement.
I think it's better to keep it in userspace. There are two things that
would help chrony on kernel side though. Supporting nanosecond offset
in the SINGLESHOT mode and updating the reported offset with every
adjtimex call, not only once per second, so chrony would know exactly
how much of the offset was already applied.

> > I'm not very familiar with the PPS API, is there something wrong 
> > with it?
> 
> The PPS patches i've seen just export IRQ timestamps to user-space.
> 
> That is not very robust in my opinion when it comes to do time 
> approximations - to get quick, low-latency action and precise 
> measurements it's best to keep the critical path as short as 
> possible, and within a single source code repository: i.e. within 
> the kernel.

That's what kernel PPS discipline does, it will be probably included
later. Its performance is an order or two better than the PLL/FLL
discipline.

-- 
Miroslav Lichvar
