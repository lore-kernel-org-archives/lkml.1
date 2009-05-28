Return-Path: <linux-kernel-owner+w=401wt.eu-S1757796AbZE1Riw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757796AbZE1Riw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 13:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbZE1Rio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 13:38:44 -0400
Received: from fifo99.com ([67.223.236.141]:39924 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753174AbZE1Rin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 13:38:43 -0400
Subject: Re: [PATCH] sched: Support current clocksource handling in
	fallback sched_clock().
From: Daniel Walker <dwalker@fifo99.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Walleij <linus.ml.walleij@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       John Stultz <johnstul@linux.vnet.ibm.com>
In-Reply-To: <20090528165816.GA31688@linux-sh.org>
References: <20090528091936.GA27545@linux-sh.org>
	 <1243503281.23657.80.camel@twins> <20090528110902.GA27884@linux-sh.org>
	 <alpine.LFD.2.00.0905281417500.3397@localhost.localdomain>
	 <20090528124207.GA28830@linux-sh.org> <1243515570.6600.96.camel@laptop>
	 <1243527218.28705.35.camel@desktop> <1243528329.6645.77.camel@laptop>
	 <20090528164011.GA30104@linux-sh.org> <1243529547.28705.43.camel@desktop>
	 <20090528165816.GA31688@linux-sh.org>
Content-Type: text/plain
Date: Thu, 28 May 2009 10:38:44 -0700
Message-Id: <1243532324.28705.75.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-29 at 01:58 +0900, Paul Mundt wrote:
> On Thu, May 28, 2009 at 09:52:27AM -0700, Daniel Walker wrote:
> > On Fri, 2009-05-29 at 01:40 +0900, Paul Mundt wrote:
> > > On Thu, May 28, 2009 at 06:32:09PM +0200, Peter Zijlstra wrote:
> > > > On Thu, 2009-05-28 at 09:13 -0700, Daniel Walker wrote:
> > > > > On Thu, 2009-05-28 at 14:59 +0200, Peter Zijlstra wrote:
> > > > > > CPU0                           CPU1
> > > > > > 
> > > > > > clock = ACCESS_ONCE(sched_clocksource);
> > > > > > 
> > > > > >                                unload module
> > > > > >                                  clocksource_unregister()
> > > > > >                                    sched_clocksource = jiffies
> > > > > >                                  unmap data/text
> > > > > > 
> > > > > > cyc2ns(clock, clocksource_read(clock)) <--- fireworks
> > > > > > 
> > > > > > 
> > > > > 
> > > > > Do any module based clocksources even exist right now?
> > > > > clocksource_unregister only seems to be used 3 times..
> > > > 
> > > > Good point, it appears its not even exported.
> > > > 
> > > > Thomas mentioned modules, I assumed.
> > > > 
> > > The drivers/clocksource/ drivers in theory could be modular anyways.
> > > Handling this transition properly is at least one less barrier to modular
> > > clocksources, so I think it's progress regardless. I don't remember what
> > > all of the other issues were though, John probably remembers.
> > 
> > I don't think it's an important case to consider right now ..
> > clocksources are usually so integral to the system putting one in a
> > module seems counterintuitive. 
> > 
> I would not have mentioned it if it weren't something we already had use
> cases for. For the SH timers alone we have 3 that can be used as
> clocksources in any combination, excluding the differences in timer
> channels per block. These tend to have different implications for
> performance, power management, etc.
> 
> The only reason they are not modular today is because more work needs to
> be done to handle clocksources going away, or at least there was the last
> time we tried it.

I don't know the details of SH so I can't speak specifically to that ..
My experience is that usually one clock gets selected as the clocksource
for a given system , and it rarely changes.. We have a sysfs facility to
allow a user to switch clocksources, but I doubt that's used for more
than debugging..

Can you imagine a general case on SH where the users know enough about
the different clocksources that they can switch between them optimally
without an SH expert sitting next to them telling them what to do?

Daniel



