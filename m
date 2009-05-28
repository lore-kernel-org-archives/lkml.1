Return-Path: <linux-kernel-owner+w=401wt.eu-S1759795AbZE1RyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759795AbZE1RyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 13:54:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754251AbZE1RyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 13:54:00 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:35467 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbZE1RyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 13:54:00 -0400
Date: Fri, 29 May 2009 02:53:41 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Walleij <linus.ml.walleij@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       John Stultz <johnstul@linux.vnet.ibm.com>
Subject: Re: [PATCH] sched: Support current clocksource handling in fallback sched_clock().
Message-ID: <20090528175341.GA32118@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Daniel Walker <dwalker@fifo99.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linus Walleij <linus.ml.walleij@gmail.com>,
	Ingo Molnar <mingo@elte.hu>, Andrew Victor <linux@maxim.org.za>,
	Haavard Skinnemoen <hskinnemoen@atmel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
	linux-arm-kernel@lists.arm.linux.org.uk,
	John Stultz <johnstul@linux.vnet.ibm.com>
References: <20090528110902.GA27884@linux-sh.org> <alpine.LFD.2.00.0905281417500.3397@localhost.localdomain> <20090528124207.GA28830@linux-sh.org> <1243515570.6600.96.camel@laptop> <1243527218.28705.35.camel@desktop> <1243528329.6645.77.camel@laptop> <20090528164011.GA30104@linux-sh.org> <1243529547.28705.43.camel@desktop> <20090528165816.GA31688@linux-sh.org> <1243532324.28705.75.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243532324.28705.75.camel@desktop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 10:38:44AM -0700, Daniel Walker wrote:
> On Fri, 2009-05-29 at 01:58 +0900, Paul Mundt wrote:
> > On Thu, May 28, 2009 at 09:52:27AM -0700, Daniel Walker wrote:
> > > I don't think it's an important case to consider right now ..
> > > clocksources are usually so integral to the system putting one in a
> > > module seems counterintuitive. 
> > > 
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
> 
As I already stated, yes.

We have multiple clock sources for most CPUs. These can be set up in any
sort of configuration, and there are pros and cons to using different
ones. The ones that are available can in turn be cycled between. I don't
know what exactly is difficult to understand about this.

Yes, we want to be able to use modular clocksources. The only reason we
don't right now is because some more preparatory work is needed first.
Any attempt to remove support for modular clocksources means we will just
have to add it in back later.

That and the fact there are already in-tree users using the
unregistration path suggests that there is no benefit in trying to
prevent modular clocksources in the first place. If you have no intention
to use modular clocksources, then don't.

If you have any technical concerns, then raise them, otherwise this is
pointless.
