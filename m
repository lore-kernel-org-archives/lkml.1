Return-Path: <linux-kernel-owner+w=401wt.eu-S1757161AbZCLPOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757161AbZCLPOp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 11:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755624AbZCLPOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 11:14:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:64023 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571AbZCLPOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 11:14:36 -0400
Date: Thu, 12 Mar 2009 11:14:32 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>, Pierre Ossman <drzeus@drzeus.cx>,
       Pekka Paalanen <pq@iki.fi>, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/4] tracing: keep ring buffer to minimum size till
 used
In-Reply-To: <20090312150100.GB5270@nowhere>
Message-ID: <alpine.DEB.2.00.0903121111170.3062@gandalf.stny.rr.com>
References: <20090312023720.144716747@goodmis.org> <20090312023936.000182747@goodmis.org> <20090312150100.GB5270@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 12 Mar 2009, Frederic Weisbecker wrote:
> >  
> > +static int tracing_resize_ring_buffer(unsigned long size)
> > +{
> > +	int ret;
> > +
> > +	/*
> > +	 * If kernel or user changes the size of the ring buffer
> > +	 * it get completed.
> > +	 */
> 
> Indeed :-)

That's my imitation of Shakespeare ;-)

> 
> I just wonder about one thing.
> Sometimes I use trace_printk to trace some events that come on bootup.
> The only solution I see that could avoid me this minimum size would be
> to use ftrace=nop that I sometimes use to avoid ftrace selftests.

"Give that man a cigar!" Yep, you hit the jackpot!  I was anticipating
this question and you even gave the same answer I would. That is to
use "ftrace=nop" on the command line ;-)

> 
> I guess that few developers will be aware of this trick so may be
> it could be worth it to explain it on the ftrace documentation and
> on kernel.h (though a simple ftrace_printk as a parameter would be
> more obvious, or ftrace=printk).

Any ftrace=foobar would work. Even if foobar was not a tracer. So using 
ftrace=foobar literally, would work.

> 
> Anyway this patch is a very good thing, especially on embeeded systems.

Thanks,

-- Steve
