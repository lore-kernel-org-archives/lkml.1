Return-Path: <linux-kernel-owner+w=401wt.eu-S1752644AbXJVJXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbXJVJXv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 05:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750956AbXJVJXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 05:23:44 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59088 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750902AbXJVJXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 05:23:43 -0400
Date: Mon, 22 Oct 2007 02:23:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jens Axboe <jens.axboe@oracle.com>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] Give kjournald a IOPRIO_CLASS_RT io priority
Message-Id: <20071022022319.a5988afe.akpm@linux-foundation.org>
In-Reply-To: <20071022091057.GB2781@elte.hu>
References: <20071015104647.14e60bc5@laptopd505.fenrus.org>
	<20071015114738.6b5a25c7.akpm@linux-foundation.org>
	<20071015192822.GA2267@kernel.dk>
	<20071022091057.GB2781@elte.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2007 11:10:57 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > > Seems a pretty fundamental change which could do with some careful 
> > > benchmarking, methinks.
> > > 
> > > See, your patch amounts to "do more seeks to improve one test case". 
> > > Surely other testcases will worsen.  What are they?
> > 
> > Yes, completely agree! I think Arjans patch makes a heap of sense, but 
> > some numbers would be great to see.
> 
> Arjan gave the relevant hard numbers:
> 
> | With latencytop, I noticed that the (in memory) atime updates during a 
> | kernel build had latencies of 600 msec or longer [...]
> |
> | With this patch, the latencies for atime updates (and similar 
> | operation) go down by a factor of 3x to 4x !
> 
> atime update latencies went down by a factor of 3x-4x ...
> 
> but what bothers me even more is the large picture. Linux's development 
> is still fundamentally skewed towards bandwidth (which goes up with 
> hardware advances anyway), while the focus on latencies is very lacking 
> (which users do care about much more and which usually does _not_ 
> improve with improved hardware), so i cannot see why we shouldnt apply 
> this. Reminds me of the illogical, almost superstitious resistence 
> against the relatime patch. (which is not in 2.6.24 mind you - killed 
> for good)

Try `mount -o relatime' and prepare to be surprised ;)

> if bandwidth hurts anywhere, it will be pointed out and fixed, we've got 
> like tons of bandwidth benchmarks and it's _easy_ to fix bandwidth 
> problems. But _finally_ we now have desktop latency tools, hard numbers 
> and patches that fix them, but what do we do ... we put up extra 
> roadblocks??
> 
> so lets just goddamn apply this _trivial_ patch. This isnt an intrusive 
> 1000 line rewrite that is hard to revert. If it causes any bandwidth 
> problems, it will be just as trivial to undo. If we do anything else we 
> just stiffle the still young and very much under-represented "lets fix 
> latencies that bothers people" movement. If anything we need _positive_ 
> discrimination for latency related fixes (which treatment this fix does 
> not need at all - all it needs is _equal_ footing with the countless 
> bandwidth patches that go into the kernel all the time), otherwise it 
> will never take off and become as healthy as bandwidth optimizations. 
> Ok?
> 

I think the situation is that we've asked for some additional
what-can-be-hurt-by-this testing.

Yes, we could sling it out there and wait for the reports.  But often
that's a pretty painful process and regressions can be discovered too late
for us to do anything about them.

