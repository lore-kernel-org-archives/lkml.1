Return-Path: <linux-kernel-owner+w=401wt.eu-S1757466AbXLGS72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466AbXLGS72 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 13:59:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754159AbXLGS7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 13:59:20 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:64398 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbXLGS7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 13:59:19 -0500
Date: Fri, 7 Dec 2007 13:58:10 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <clameter@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: Major regression on hackbench with SLUB
In-Reply-To: <alpine.LFD.0.9999.0712071021510.12046@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.58.0712071353010.2395@gandalf.stny.rr.com>
References: <1197049846.1645.68.camel@localhost.localdomain>
 <alpine.LFD.0.9999.0712070957070.7274@woody.linux-foundation.org>
 <alpine.LFD.0.9999.0712071021510.12046@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ Note: I'm currently having problems with my email:
  http://www.domaindirect.com/network.html
  I'm in the process of setting up my own personal email server. ]


> > Can you do one run with oprofile, and see exactly where the cost is? It
> > should hopefully be pretty darn obvious, considering your timing.

I kicked off my kernel tests which will take a few hours.
I run "make -j256" (4*nr_CPUS) 10 times at SCHED_OTHER and 10 times
at SCHED_FIFO (chrt -f 10) for both SLUB and SLAB.

This is automated, so I need to wait for it to finish before I can
continue other tests.

> The biggest cost of __slab_alloc() in my profile is the "slab_lock()", but
> that may not be the one that causes problems in a 64-cpu setup, so it
> would be good to have that verified.

I'll run oprofile as soon as the kernel build test is done.

> case which can trigger on NUMA. That's another potential explanation of
> why you'd see such a *huge* slowdown (ie if the whole node-match thing
> doesn't work out, slub just never gets the fast-case at all). That said,
> the number of places that actually pass a specific node to slub is very
> limited, so I suspect it's not the node matching. But just disabling that
> test in slab_alloc() might be one thing to test.

I'll try that after the oprofile.

Thanks,

-- Steve

