Return-Path: <linux-kernel-owner+w=401wt.eu-S1757192AbZE0BJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192AbZE0BJt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 21:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754599AbZE0BJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 21:09:41 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:48689 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbZE0BJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 21:09:40 -0400
Subject: Re: [PATCH] sched: Support current clocksource handling in
 fallback sched_clock().
From: john stultz <johnstul@us.ibm.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Walleij <linus.ml.walleij@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <20090527002615.GA8845@linux-sh.org>
References: <20090526061532.GD9188@linux-sh.org>
	 <63386a3d0905260731m655bfee3q82a6f52d71fa3cef@mail.gmail.com>
	 <1243348681.23657.14.camel@twins>
	 <alpine.LFD.2.00.0905262209160.1762@localhost.localdomain>
	 <20090526230855.GA27218@linux-sh.org> <1243380303.3275.40.camel@localhost>
	 <20090526234425.GB6295@linux-sh.org> <1243383730.3275.53.camel@localhost>
	 <20090527002615.GA8845@linux-sh.org>
Content-Type: text/plain
Date: Tue, 26 May 2009 18:09:38 -0700
Message-Id: <1243386578.3275.58.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-27 at 09:26 +0900, Paul Mundt wrote:
> On Tue, May 26, 2009 at 05:22:10PM -0700, john stultz wrote:
> > On Wed, 2009-05-27 at 08:44 +0900, Paul Mundt wrote:
> > > What would you recommend instead? We do not want to spin here, and if we
> > > are in the middle of changing clocksources and returning jiffies anyways,
> > > then this same issue pops up in the current sched_clock() implementation
> > > regardless of whether we are testing for lock contention or not.
> > > Likewise, even if we were to spin, the same situation exists if the new
> > > clocksource does not have the _SCHED_CLOCK bit set and we have to fall
> > > back on jiffies anyways, doesn't it?
> > > 
> > > Put another way, and unless I'm missing something obvious, if we ignore
> > > my changes to sched_clock(), how is your concern not applicable to case
> > > where we are changing clocksources and using generic sched_clock() as it
> > > is today?
> > 
> > Well, Thomas' point that locking isn't necessary, as sched_clock()
> > doesn't have to be correct, is probably right. 
> > 
> > So, I think a get_sched_clocksource() interface would be ideal (if we
> > want to get academic at a later date, the pointer could be atomically
> > updated, and we'd keep it valid for some time via an rcu like method).
> > 
> > Additionally, you can set the jiffies clocksource as a _SCHED_CLOCK
> > clocksource and drop the jiffies fallback code completely.
> > 
> I thought about that initially as well, but in the case of the jiffies
> clocksource, that won't handle INITIAL_JIFFIES, which we want to subtract
> to make printk times sane.

Fair point, but that shouldn't be a big issue, we can fix that in the
jiffies clocksource read() implementation.

thanks
-john


