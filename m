Return-Path: <linux-kernel-owner+w=401wt.eu-S1760133AbZEHKwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760133AbZEHKwu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 06:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752814AbZEHKwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 06:52:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:51259 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbZEHKwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 06:52:41 -0400
Date: Fri, 8 May 2009 06:52:39 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/4] ring-buffer: add total count in
 ring-buffer-benchmark
In-Reply-To: <20090507215258.6227128c.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.0905080650130.28378@gandalf.stny.rr.com>
References: <20090508043250.372421144@goodmis.org> <20090508043331.493337344@goodmis.org> <20090507215258.6227128c.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 7 May 2009, Andrew Morton wrote:

> On Fri, 08 May 2009 00:32:53 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > --- a/kernel/trace/ring_buffer_benchmark.c
> > +++ b/kernel/trace/ring_buffer_benchmark.c
> > @@ -285,6 +285,17 @@ static void ring_buffer_producer(void)
> >  		avg = 1000000 / hit;
> >  		pr_info("%ld ns per entry\n", avg);
> >  	}
> > +
> > +
> 
> s/\n\n/\n/

My pinky must hae been itchy, and hit the enter twice.

> 
> > +	if (missed) {
> > +		if (time)
> > +			missed /= (long)time;
> > +
> > +		pr_info("Total iterations per millisec: %ld\n", hit + missed);
> > +
> > +		avg = 1000000 / (hit + missed);
> 
> s/1000000/USEC_PER_SEC/?

Heh, after I sent out the patch, I noticed that number, and thought to 
myself, "oh no, akpm is going to commont on that" ;-)

> 
> Hopefully we can't have hit+missed==0.
> 
> They're counters and hence should have unsigned types.
> 
> But even unsigned up-counters can add to zero if wrapping occurs.

Eigad! I never thought about an overflow to zero. Will fix.

Thanks!

-- Steve

> 
> 
> > +		pr_info("%ld ns per entry\n", avg);
> > +	}
> >  }
> 
