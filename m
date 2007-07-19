Return-Path: <linux-kernel-owner+w=401wt.eu-S940521AbXGSRYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940521AbXGSRYr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933981AbXGSRYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:24:22 -0400
Received: from brick.kernel.dk ([80.160.20.94]:26093 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S940296AbXGSRYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:24:20 -0400
Date: Thu, 19 Jul 2007 19:24:03 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org,
       Greg KH <greg@kroah.com>, Chris Wright <chrisw@sous-sol.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Jan Glauber <jang@linux.vnet.ibm.com>, Andi Kleen <ak@suse.de>
Subject: Re: [patch] sched: implement cpu_clock(cpu) high-speed time
	source,  take #2
Message-ID: <20070719172403.GU11657@kernel.dk>
References: <469F75AF.5080000@goop.org> <20070719143528.GA8278@elte.hu> <469F793E.6030006@goop.org> <20070719145058.GA11971@elte.hu> <469F7D7A.204@goop.org> <20070719150955.GA19373@elte.hu> <469F8179.2060802@goop.org> <20070719154254.GA24225@elte.hu> <20070719154449.GA28998@elte.hu> <469F8D28.1010304@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469F8D28.1010304@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19 2007, Jeremy Fitzhardinge wrote:
> > Index: linux/block/blktrace.c
> > ===================================================================
> > --- linux.orig/block/blktrace.c
> > +++ linux/block/blktrace.c
> > @@ -41,7 +41,7 @@ static void trace_note(struct blk_trace 
> >  		const int cpu = smp_processor_id();
> >  
> >  		t->magic = BLK_IO_TRACE_MAGIC | BLK_IO_TRACE_VERSION;
> > -		t->time = sched_clock() - per_cpu(blk_trace_cpu_offset, cpu);
> > +		t->time = cpu_clock(cpu) - per_cpu(blk_trace_cpu_offset, cpu);
> >  		t->device = bt->dev;
> >  		t->action = action;
> >  		t->pid = pid;
> > @@ -159,7 +159,7 @@ void __blk_add_trace(struct blk_trace *b
> >  
> >  		t->magic = BLK_IO_TRACE_MAGIC | BLK_IO_TRACE_VERSION;
> >  		t->sequence = ++(*sequence);
> > -		t->time = sched_clock() - per_cpu(blk_trace_cpu_offset, cpu);
> > +		t->time = cpu_clock(cpu) - per_cpu(blk_trace_cpu_offset, cpu);
> >   
> 
> What's this measuring here?  Time spend in IO?  Wouldn't it be better
> off with a measurement of real monotonic time?

It's not time spent in IO, it wants a nanosecond timestamp.

-- 
Jens Axboe

