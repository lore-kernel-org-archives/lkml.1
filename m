Return-Path: <linux-kernel-owner+w=401wt.eu-S1753203AbXJVJLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbXJVJLp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 05:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbXJVJLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 05:11:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56430 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbXJVJLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 05:11:35 -0400
Date: Mon, 22 Oct 2007 11:10:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] Give kjournald a IOPRIO_CLASS_RT io priority
Message-ID: <20071022091057.GB2781@elte.hu>
References: <20071015104647.14e60bc5@laptopd505.fenrus.org> <20071015114738.6b5a25c7.akpm@linux-foundation.org> <20071015192822.GA2267@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071015192822.GA2267@kernel.dk>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jens Axboe <jens.axboe@oracle.com> wrote:

> > Seems a pretty fundamental change which could do with some careful 
> > benchmarking, methinks.
> > 
> > See, your patch amounts to "do more seeks to improve one test case". 
> > Surely other testcases will worsen.  What are they?
> 
> Yes, completely agree! I think Arjans patch makes a heap of sense, but 
> some numbers would be great to see.

Arjan gave the relevant hard numbers:

| With latencytop, I noticed that the (in memory) atime updates during a 
| kernel build had latencies of 600 msec or longer [...]
|
| With this patch, the latencies for atime updates (and similar 
| operation) go down by a factor of 3x to 4x !

atime update latencies went down by a factor of 3x-4x ...

but what bothers me even more is the large picture. Linux's development 
is still fundamentally skewed towards bandwidth (which goes up with 
hardware advances anyway), while the focus on latencies is very lacking 
(which users do care about much more and which usually does _not_ 
improve with improved hardware), so i cannot see why we shouldnt apply 
this. Reminds me of the illogical, almost superstitious resistence 
against the relatime patch. (which is not in 2.6.24 mind you - killed 
for good)

if bandwidth hurts anywhere, it will be pointed out and fixed, we've got 
like tons of bandwidth benchmarks and it's _easy_ to fix bandwidth 
problems. But _finally_ we now have desktop latency tools, hard numbers 
and patches that fix them, but what do we do ... we put up extra 
roadblocks??

so lets just goddamn apply this _trivial_ patch. This isnt an intrusive 
1000 line rewrite that is hard to revert. If it causes any bandwidth 
problems, it will be just as trivial to undo. If we do anything else we 
just stiffle the still young and very much under-represented "lets fix 
latencies that bothers people" movement. If anything we need _positive_ 
discrimination for latency related fixes (which treatment this fix does 
not need at all - all it needs is _equal_ footing with the countless 
bandwidth patches that go into the kernel all the time), otherwise it 
will never take off and become as healthy as bandwidth optimizations. 
Ok?

	Ingo
