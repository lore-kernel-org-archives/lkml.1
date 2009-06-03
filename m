Return-Path: <linux-kernel-owner+w=401wt.eu-S1754996AbZFCDgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996AbZFCDgi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 23:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753025AbZFCDga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 23:36:30 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:56587 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbZFCDg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 23:36:29 -0400
Date: Wed, 3 Jun 2009 12:36:03 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Walleij <linus.ml.walleij@gmail.com>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Stultz <johnstul@linux.vnet.ibm.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: sched_clock() clocksource handling.
Message-ID: <20090603033603.GA31488@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Daniel Walker <dwalker@fifo99.com>,
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linus Walleij <linus.ml.walleij@gmail.com>,
	Andrew Victor <linux@maxim.org.za>,
	Haavard Skinnemoen <hskinnemoen@atmel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	John Stultz <johnstul@linux.vnet.ibm.com>,
	linux-arm-kernel@lists.arm.linux.org.uk, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20090602071718.GA17710@linux-sh.org> <1243927502.23657.5619.camel@twins> <20090602073515.GB17710@linux-sh.org> <1243928495.23657.5642.camel@twins> <20090602075409.GA19294@linux-sh.org> <1243943366.6592.434.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243943366.6592.434.camel@desktop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02, 2009 at 04:49:26AM -0700, Daniel Walker wrote:
> On Tue, 2009-06-02 at 16:54 +0900, Paul Mundt wrote:
> >  unsigned long long __attribute__((weak)) sched_clock(void)
> >  {
> > -       return (unsigned long long)(jiffies - INITIAL_JIFFIES)
> > -                                       * (NSEC_PER_SEC / HZ);
> > +       unsigned long long time;
> > +       struct clocksource *clock;
> > +
> > +       rcu_read_lock();
> > +       clock = rcu_dereference(sched_clocksource);
> > +       time = cyc2ns(clock, clocksource_read(clock));
> > +       rcu_read_unlock();
> > +
> > +       return time;
> >  }
> 
> My concerns with the locking here still stand. Nothing you've said or
> done bolsters the clocksource in modules argument. I think what your
> planning for sh clocksources seems very inelegant. I would imagine a
> better solution is out there. I'd prefer if you just leave sched_clock
> alone.
> 
This is the first I've heard you mention locking concerns, and as usual
there is not enough technical content (or any, really) to go on to even
reply to this. Whether you consider my solution for sh clocksources
elegant or not is irrelevant, as I wasn't soliciting feedback, and it's a
problem that has to be dealt with regardless of whether it's a pretty one
or not.

If at such a time you wish to post something bordering on a real
technical concern, we can continue this thread of conversation, until
then I'll be sure to drop you from future versions of the patch. If you
want to hand-wave, do it somewhere else, thanks.
