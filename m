Return-Path: <linux-kernel-owner+w=401wt.eu-S1759241AbZFBJAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759241AbZFBJAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 05:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882AbZFBJAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 05:00:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:33733 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570AbZFBJAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 05:00:12 -0400
Subject: Re: [PATCH] U300 sched_clock implementation
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, mingo@elte.hu,
       linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <63386a3d0906010046k3b86d70av3e290fc26c2934f5@mail.gmail.com>
References: <63386a3d0905112337p2d426481o5f9bf9b9489cc57e@mail.gmail.com>
	 <63386a3d0905231446h245bb4a9gec111f68a74a44e4@mail.gmail.com>
	 <1243151839.26820.642.camel@twins>
	 <63386a3d0905250513q6ca56eeepcf7bebe46c447fb4@mail.gmail.com>
	 <1243256510.26820.679.camel@twins>
	 <63386a3d0906010046k3b86d70av3e290fc26c2934f5@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 02 Jun 2009 11:00:12 +0200
Message-Id: <1243933212.23657.5726.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-01 at 09:46 +0200, Linus Walleij wrote:
> 2009/5/25 Peter Zijlstra <peterz@infradead.org>:
> > On Mon, 2009-05-25 at 14:13 +0200, Linus Walleij wrote:
> >> 2009/5/24 Peter Zijlstra <peterz@infradead.org>:
> >>
> >> > On Sat, 2009-05-23 at 23:46 +0200, Linus Walleij wrote:
> >> >
> >> >> This overrides the global sched_clock() symbol in the Linux
> >> >> scheduler with a local implementation which takes advantage of
> >> >> the timesource in U300 giving a scheduling resolution of 1us. The
> >> >> solution is the same as found in the OMAP2 core code.
> >> >
> >> > We assume sched_clock() to return time in ns (e-9) resolution.
> >>
> >> Yep okay and in this case:
> >>
> >> >> +       ret = (unsigned long long) u300_get_cycles();
> >> >> +       ret = (ret * clocksource_u300_1mhz.mult_orig) >>
> >> >> +               clocksource_u300_1mhz.shift;
> >> >> +       return ret;
> >>
> >> (mult_orig >> shift) == 1000
> >
> > Ah, ok -- missed that little detail ;-)
> >
> >> So for each cycle in cyclecount register we return 1000 * cycles
> >> i.e 1000ns.
> >>
> >> If it looks nicer we can of course simply:
> >> return (unsigned long long) u300_get_cycles * 1000;
> >>
> >> But the question here is whether this resolution is enough for
> >> sched_clock() or if it is irrelevant to override sched_clock()
> >> if it cannot schedule with better precision than 1000 ns.
> >
> > No anything better than jiffies is good, 1us certainly is worth the
> > trouble.
> 
> Can I interpret this as Acked-by: Peter Zijlstra <peterz@infradead.org> ?

I think its best if we continue with the patch Paul Mundt has been
proposing.
