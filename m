Return-Path: <linux-kernel-owner+w=401wt.eu-S932672AbXGMRXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672AbXGMRXn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 13:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbXGMRXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 13:23:36 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:4411 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123AbXGMRXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 13:23:35 -0400
Date: Fri, 13 Jul 2007 19:23:41 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Mike Galbraith <efault@gmx.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrea Arcangeli <andrea@suse.de>, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: x86 status was Re: -mm merge plans for 2.6.23
In-Reply-To: <1184302024.6709.11.camel@Homer.simpson.net>
Message-ID: <Pine.LNX.4.64.0707131728070.1817@scrub.home>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> 
 <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu> 
 <20070711211638.GE18767@one.firstfloor.org>  <20070711214649.GK14435@v2.random>
  <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org> 
 <Pine.LNX.4.64.0707130415520.1818@scrub.home> <1184302024.6709.11.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 13 Jul 2007, Mike Galbraith wrote:

> > The new scheduler does _a_lot_ of heavy 64 bit calculations without any 
> > attempt to scale that down a little...
> 
> See prio_to_weight[], prio_to_wmult[] and sysctl_sched_stat_granularity.
> Perhaps more can be done, but "without any attempt..." isn't accurate.

Calculating these values at runtime would have been completely insane, the 
alternative would be a crummy approximation, so using a lookup table is 
actually a good thing. That's not the problem.
BTW could someone please verify the prio_to_wmult table, especially [16] 
and [21] look a little off, like a digit was cut off.

While I'm at this, the 10% scaling there looks a little much (unless there 
are other changes I haven't looked at yet), the old code used more like 
5%. This would mean a prio -20 task would get 98.86% cpu time compared to 
a prio 0 task, that was previously about the difference between -20 and 
19 (and it would have previously gotten only 88.89%), now a prio -20 task 
would get 99.98% cpu time compared to a prio 19 task.
The individual levels are unfortunately not that easily comparable, but at 
the overall scale the change looks IMHO a little drastic.

bye, Roman
