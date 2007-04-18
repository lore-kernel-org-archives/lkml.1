Return-Path: <linux-kernel-owner+w=401wt.eu-S1753558AbXDRErF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbXDRErF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 00:47:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753618AbXDRErF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 00:47:05 -0400
Received: from cantor.suse.de ([195.135.220.2]:43810 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753558AbXDRErE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 00:47:04 -0400
Date: Wed, 18 Apr 2007 06:46:30 +0200
From: Nick Piggin <npiggin@suse.de>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070418044630.GD18452@wotan.suse.de>
References: <46240F98.3020800@bigpond.net.au> <1176776941.6222.21.camel@Homer.simpson.net> <20070417034050.GD25513@wotan.suse.de> <46244A52.4000403@bigpond.net.au> <20070417042954.GG25513@wotan.suse.de> <462467E9.4030509@bigpond.net.au> <20070417064436.GE1057@wotan.suse.de> <46247BE7.2070307@bigpond.net.au> <20070417075611.GC20026@wotan.suse.de> <4624C8C6.4090902@bigpond.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4624C8C6.4090902@bigpond.net.au>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2007 at 11:16:54PM +1000, Peter Williams wrote:
> Nick Piggin wrote:
> >I don't like the timeslice based nice in mainline. It's too nasty
> >with latencies. nicksched is far better in that regard IMO.
> >
> >But I don't know how you can assert a particular way is the best way
> >to do something.
> 
> I should have added "I may be wrong but I think that ...".
> 
> My opinion is based on a lot of experience with different types of 
> scheduler design and the observation from gathering scheduling 
> statistics while playing with these schedulers that the size of the time 
> slices we're talking about is much larger than the CPU chunks most tasks 
> use in any one go so time slice size has no real effect on most tasks 
> and the faster CPUs become the more this becomes true.

For desktop loads, maybe. But for things that are compute bound, the
cost of context switching I believe still gets worse as CPUs continue
to be able to execute more instructions per cycle, get clocked faster,
and get larger caches.


> >>In that case I'd go O(1) provided that the k factor for the O(1) wasn't 
> >>greater than O(logN)'s k factor multiplied by logMaxN.
> >
> >Yes, or even significantly greater around typical large sizes of N.
> 
> Yes.  In fact its' probably better to use the maximum number of threads 
> allowed on the system for N.  We know that value don't we?

Well we might be able to work it out by looking at the tunables or
amount of kernel memory available, but I guess it is hard to just
pick a number.

I'll try running a few more benchmarks.
