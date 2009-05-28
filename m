Return-Path: <linux-kernel-owner+w=401wt.eu-S1763504AbZE1RHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763504AbZE1RHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 13:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757452AbZE1RHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 13:07:41 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:55487 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757437AbZE1RHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 13:07:40 -0400
Subject: Re: [PATCH] sched: Support current clocksource handling in
 fallback sched_clock().
From: John Stultz <johnstul@us.ibm.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Daniel Walker <dwalker@fifo99.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Walleij <linus.ml.walleij@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       John Stultz <johnstul@linux.vnet.ibm.com>
In-Reply-To: <20090528164011.GA30104@linux-sh.org>
References: <20090527001543.GA8493@linux-sh.org>
	 <1243441525.28705.19.camel@desktop> <20090528091936.GA27545@linux-sh.org>
	 <1243503281.23657.80.camel@twins> <20090528110902.GA27884@linux-sh.org>
	 <alpine.LFD.2.00.0905281417500.3397@localhost.localdomain>
	 <20090528124207.GA28830@linux-sh.org> <1243515570.6600.96.camel@laptop>
	 <1243527218.28705.35.camel@desktop> <1243528329.6645.77.camel@laptop>
	 <20090528164011.GA30104@linux-sh.org>
Content-Type: text/plain
Date: Thu, 28 May 2009 10:07:05 -0700
Message-Id: <1243530425.29511.467.camel@jstultz-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-29 at 01:40 +0900, Paul Mundt wrote:
> On Thu, May 28, 2009 at 06:32:09PM +0200, Peter Zijlstra wrote:
> > On Thu, 2009-05-28 at 09:13 -0700, Daniel Walker wrote:
> > > On Thu, 2009-05-28 at 14:59 +0200, Peter Zijlstra wrote:
> > > > CPU0                           CPU1
> > > > 
> > > > clock = ACCESS_ONCE(sched_clocksource);
> > > > 
> > > >                                unload module
> > > >                                  clocksource_unregister()
> > > >                                    sched_clocksource = jiffies
> > > >                                  unmap data/text
> > > > 
> > > > cyc2ns(clock, clocksource_read(clock)) <--- fireworks
> > > > 
> > > > 
> > > 
> > > Do any module based clocksources even exist right now?
> > > clocksource_unregister only seems to be used 3 times..
> > 
> > Good point, it appears its not even exported.
> > 
> > Thomas mentioned modules, I assumed.
> > 
> The drivers/clocksource/ drivers in theory could be modular anyways.
> Handling this transition properly is at least one less barrier to modular
> clocksources, so I think it's progress regardless. I don't remember what
> all of the other issues were though, John probably remembers.

Yea. Its always been something I'd want to have as a capability, but we
haven't actually had a user of. I still think its something we should
allow, even if there aren't upstream users, as if you only have to
backport a module to an old distro kernel to get some oddball bit of
hardware working, that can be really useful.

So I think the locking fix is the way to go.

thanks
-john



