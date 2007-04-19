Return-Path: <linux-kernel-owner+w=401wt.eu-S1031097AbXDSD2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031097AbXDSD2W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 23:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031101AbXDSD2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 23:28:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58154 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031097AbXDSD2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 23:28:21 -0400
Date: Thu, 19 Apr 2007 05:28:17 +0200
From: Nick Piggin <npiggin@suse.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andy Whitcroft <apw@shadowen.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Steve Fox <drfickle@us.ibm.com>,
       Nishanth Aravamudan <nacc@us.ibm.com>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070419032817.GB487@wotan.suse.de>
References: <20070413202100.GA9957@elte.hu> <20070418095334.GA26525@elte.hu> <20070418121304.GA878@wotan.suse.de> <200704182249.46200.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704182249.46200.kernel@kolivas.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2007 at 10:49:45PM +1000, Con Kolivas wrote:
> On Wednesday 18 April 2007 22:13, Nick Piggin wrote:
> >
> > The kernel compile (make -j8 on 4 thread system) is doing 1800 total
> > context switches per second (450/s per runqueue) for cfs, and 670
> > for mainline. Going up to 20ms granularity for cfs brings the context
> > switch numbers similar, but user time is still a % or so higher. I'd
> > be more worried about compute heavy threads which naturally don't do
> > much context switching.
> 
> While kernel compiles are nice and easy to do I've seen enough criticism of 
> them in the past to wonder about their usefulness as a standard benchmark on 
> their own.

Actually it is a real workload for most kernel developers including you
no doubt :)

The criticism's of kernbench for the kernel are probably fair in that
kernel compiles don't exercise a lot of kernel functionality (page
allocator and fault paths mostly, IIRC). However as far as I'm concerned,
they're great for testing the CPU scheduler, because it doesn't actually
matter whether you're running in userspace or kernel space for a context
switch to blow your caches. The results are quite stable.

You could actually make up a benchmark that hurts a whole lot more from
context switching, but I figure that kernbench is a real world thing
that shows it up quite well.


> > Some other numbers on the same system
> > Hackbench:	2.6.21-rc7	cfs-v2 1ms[*]	nicksched
> > 10 groups: Time: 1.332		0.743		0.607
> > 20 groups: Time: 1.197		1.100		1.241
> > 30 groups: Time: 1.754		2.376		1.834
> > 40 groups: Time: 3.451		2.227		2.503
> > 50 groups: Time: 3.726		3.399		3.220
> > 60 groups: Time: 3.548		4.567		3.668
> > 70 groups: Time: 4.206		4.905		4.314
> > 80 groups: Time: 4.551		6.324		4.879
> > 90 groups: Time: 7.904		6.962		5.335
> > 100 groups: Time: 7.293		7.799		5.857
> > 110 groups: Time: 10.595	8.728		6.517
> > 120 groups: Time: 7.543		9.304		7.082
> > 130 groups: Time: 8.269		10.639		8.007
> > 140 groups: Time: 11.867	8.250		8.302
> > 150 groups: Time: 14.852	8.656		8.662
> > 160 groups: Time: 9.648		9.313		9.541
> 
> Hackbench even more so. A prolonged discussion with Rusty Russell on this 
> issue he suggested hackbench was more a pass/fail benchmark to ensure there 
> was no starvation scenario that never ended, and very little value should be 
> placed on the actual results returned from it.

Yeah, cfs seems to do a little worse than nicksched here, but I
include the numbers not because I think that is significant, but to
show mainline's poor characteristics.
