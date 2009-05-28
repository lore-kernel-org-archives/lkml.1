Return-Path: <linux-kernel-owner+w=401wt.eu-S1756886AbZE1Rry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbZE1Rry (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 13:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754624AbZE1Rrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 13:47:46 -0400
Received: from www.tglx.de ([62.245.132.106]:45581 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754884AbZE1Rrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 13:47:45 -0400
Date: Thu, 28 May 2009 19:46:22 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Walker <dwalker@fifo99.com>
cc: Paul Mundt <lethal@linux-sh.org>, Peter Zijlstra <peterz@infradead.org>,
       Linus Walleij <linus.ml.walleij@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       John Stultz <johnstul@linux.vnet.ibm.com>
Subject: Re: [PATCH] sched: Support current clocksource handling in fallback
 sched_clock().
In-Reply-To: <1243532324.28705.75.camel@desktop>
Message-ID: <alpine.LFD.2.00.0905281943010.3397@localhost.localdomain>
References: <20090528091936.GA27545@linux-sh.org>  <1243503281.23657.80.camel@twins> <20090528110902.GA27884@linux-sh.org>  <alpine.LFD.2.00.0905281417500.3397@localhost.localdomain>  <20090528124207.GA28830@linux-sh.org> <1243515570.6600.96.camel@laptop> 
 <1243527218.28705.35.camel@desktop> <1243528329.6645.77.camel@laptop>  <20090528164011.GA30104@linux-sh.org> <1243529547.28705.43.camel@desktop>  <20090528165816.GA31688@linux-sh.org> <1243532324.28705.75.camel@desktop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 May 2009, Daniel Walker wrote:
> > I would not have mentioned it if it weren't something we already had use
> > cases for. For the SH timers alone we have 3 that can be used as
> > clocksources in any combination, excluding the differences in timer
> > channels per block. These tend to have different implications for
> > performance, power management, etc.
> > 
> > The only reason they are not modular today is because more work needs to
> > be done to handle clocksources going away, or at least there was the last
> > time we tried it.
> 
> I don't know the details of SH so I can't speak specifically to that ..
> My experience is that usually one clock gets selected as the clocksource
> for a given system , and it rarely changes.. We have a sysfs facility to
> allow a user to switch clocksources, but I doubt that's used for more
> than debugging..
> 
> Can you imagine a general case on SH where the users know enough about
> the different clocksources that they can switch between them optimally
> without an SH expert sitting next to them telling them what to do?

Paul explained already that:

> > ...  These tend to have different implications for
> > performance, power management, etc.

So the use case for this is pretty obvious. In operational state you
want something fast and easy to access (which might use more power
e.g. because it runs at a higher clock frequency). When you go into
power saving modes you switch over to a clocksource which might be
slower to access but uses less power.

And there is no user interaction at all, it's selected as part of a
power state transition from the kernel.

Thanks,

	tglx
