Return-Path: <linux-kernel-owner+w=401wt.eu-S1752789AbZIIArg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbZIIArg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 20:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbZIIArf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 20:47:35 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:56052 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbZIIAre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 20:47:34 -0400
Date: Tue, 8 Sep 2009 15:09:43 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ingo Molnar <mingo@elte.hu>, Michael Buesch <mb@bu3sch.de>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Felix Fietkau <nbd@openwrt.org>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090908130943.GA10637@linux-mips.org>
References: <20090906205952.GA6516@elte.hu> <200909071716.57722.mb@bu3sch.de> <20090907182629.GA3484@elte.hu> <20090908074825.GA11413@elte.hu> <1252403400.4950.81.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252403400.4950.81.camel@pasglop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 08, 2009 at 07:50:00PM +1000, Benjamin Herrenschmidt wrote:

> On Tue, 2009-09-08 at 09:48 +0200, Ingo Molnar wrote:
> > So either your MIPS system has some unexpected dependency on the 
> > scheduler, or there's something weird going on.
> > 
> > Mind poking on this one to figure out whether it's all repeatable 
> > and why that slowdown happens? Multiple attempts to reproduce it 
> > failed here for me.
> 
> Could it be the scheduler using constructs that don't do well on MIPS ? 

It would surprise me.

I'm wondering if BFS has properties that make it perform better on a very
low memory system; I guess the BCM74xx system will have like 32MB or 64MB
only.

> I remember at some stage we spotted an expensive multiply in there,
> maybe there's something similar, or some unaligned or non-cache friendly
> vs. the MIPS cache line size data structure, that sort of thing ...
> 
> Is this a SW loaded TLB ? Does it misses on kernel space ? That could
> also be some differences in how many pages are touched by each scheduler
> causing more TLB pressure. This will be mostly invisible on x86.

Software refilled.  No misses ever for kernel space or low-mem; think of
it as low-mem and kernel executable living in a 512MB page that is mapped
by a mechanism outside the TLB.  Vmalloc ranges are TLB mapped.  Ioremap
address ranges only if above physical address 512MB.

An emulated unaligned load/store is very expensive; one that is encoded
properly by GCC for __attribute__((packed)) is only 1 cycle and 1
instruction ( = 4 bytes) extra.

> At this stage, it will be hard to tell without some profile data I
> suppose. Maybe next week I can try on a small SW loaded TLB embedded PPC
> see if I can reproduce some of that, but no promises here.

  Ralf
