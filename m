Return-Path: <linux-kernel-owner+w=401wt.eu-S1758378AbZFCO6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758378AbZFCO6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 10:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753954AbZFCO6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 10:58:14 -0400
Received: from fifo99.com ([67.223.236.141]:56958 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753587AbZFCO6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 10:58:13 -0400
Subject: Re: [PATCH] sched: sched_clock() clocksource handling.
From: Daniel Walker <dwalker@fifo99.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Walleij <linus.ml.walleij@gmail.com>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Stultz <johnstul@linux.vnet.ibm.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090603033603.GA31488@linux-sh.org>
References: <20090602071718.GA17710@linux-sh.org>
	 <1243927502.23657.5619.camel@twins> <20090602073515.GB17710@linux-sh.org>
	 <1243928495.23657.5642.camel@twins> <20090602075409.GA19294@linux-sh.org>
	 <1243943366.6592.434.camel@desktop>  <20090603033603.GA31488@linux-sh.org>
Content-Type: text/plain
Date: Wed, 03 Jun 2009 07:58:08 -0700
Message-Id: <1244041088.18985.9.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-03 at 12:36 +0900, Paul Mundt wrote:
> On Tue, Jun 02, 2009 at 04:49:26AM -0700, Daniel Walker wrote:
> > On Tue, 2009-06-02 at 16:54 +0900, Paul Mundt wrote:
> > >  unsigned long long __attribute__((weak)) sched_clock(void)
> > >  {
> > > -       return (unsigned long long)(jiffies - INITIAL_JIFFIES)
> > > -                                       * (NSEC_PER_SEC / HZ);
> > > +       unsigned long long time;
> > > +       struct clocksource *clock;
> > > +
> > > +       rcu_read_lock();
> > > +       clock = rcu_dereference(sched_clocksource);
> > > +       time = cyc2ns(clock, clocksource_read(clock));
> > > +       rcu_read_unlock();
> > > +
> > > +       return time;
> > >  }
> > 
> > My concerns with the locking here still stand. Nothing you've said or
> > done bolsters the clocksource in modules argument. I think what your
> > planning for sh clocksources seems very inelegant. I would imagine a
> > better solution is out there. I'd prefer if you just leave sched_clock
> > alone.
> > 
> This is the first I've heard you mention locking concerns, and as usual
> there is not enough technical content (or any, really) to go on to even
> reply to this. Whether you consider my solution for sh clocksources
> elegant or not is irrelevant, as I wasn't soliciting feedback, and it's a
> problem that has to be dealt with regardless of whether it's a pretty one
> or not.

I think maybe your not reading my emails .. I said there is unnessesary
locking in sched_clock, and that it's fixing a problem that doesn't
exist (i.e. clocksources in modules) .. You claim you want clocksources
in modules because you have a useful case in sh, which I consider not
very useful .. And your refusing to remove the locking, or that's how it
seems. So I'd prefer you don't submit this code any longer. I don't
think you know what your doing in this case.

This is not hand waving, and it is technical.

Daniel

