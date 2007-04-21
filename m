Return-Path: <linux-kernel-owner+w=401wt.eu-S1752440AbXDUQNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440AbXDUQNr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 12:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbXDUQNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 12:13:47 -0400
Received: from 1wt.eu ([62.212.114.60]:2104 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440AbXDUQNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 12:13:47 -0400
Date: Sat, 21 Apr 2007 18:12:08 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Con Kolivas <kernel@kolivas.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Message-ID: <20070421161208.GB7840@1wt.eu>
References: <20070420140457.GA14017@elte.hu> <20070421121235.GA2044@1wt.eu> <200704220155.20856.kernel@kolivas.org> <20070421160008.GA28783@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070421160008.GA28783@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 21, 2007 at 06:00:08PM +0200, Ingo Molnar wrote:
> 
> * Con Kolivas <kernel@kolivas.org> wrote:
> 
> > >   Feels even better, mouse movements are very smooth even under high 
> > >   load. I noticed that X gets reniced to -19 with this scheduler. 
> > >   I've not looked at the code yet but this looked suspicious to me. 
> > >   I've reniced it to 0 and it did not change any behaviour. Still 
> > >   very good.
> > 
> > Looks like this code does it:
> > 
> > +int sysctl_sched_privileged_nice_level __read_mostly = -19;
> 
> correct. Note that Willy reniced X back to 0 so it had no relevance on 
> his test.

Anyway, my X was mostly unused (below 1% CPU), which was my intent when
replacing glxgears by ocbench. We have not settled yet about how to handle
the special case for X. Let's at least try to get the best schedulers without
this problem, then see how to make them behave the best taking X into account.

> Also note that i pointed this change out in the -v4 CFS 
> announcement:
> 
> || Changes since -v3:
> ||
> ||  - usability fix: automatic renicing of kernel threads such as 
> ||    keventd, OOM tasks and tasks doing privileged hardware access
> ||    (such as Xorg).
> 
> i've attached it below in a standalone form, feel free to put it into 
> SD! :)

Con, I think it could be a good idea since you recommend to renice X with
SD. Most of the problem users are facing with renicing X is that they need
to change their configs or scripts. If the kernel can reliably detect X and
handle it differently, why not do it ?

It makes me think that this hint might be used to set some flags in the task
struct in order to apply different processing than just renicing. It is indeed
possible that nice is not the best solution and that something else would be
even better (eg: longer timeslices, but not changing priority in the queues).
Just an idea anyway.

OK, back to work ;-)
Willy

