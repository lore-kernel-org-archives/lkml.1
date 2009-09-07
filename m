Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbZIGN7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbZIGN7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 09:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753297AbZIGN7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 09:59:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40969 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753264AbZIGN7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 09:59:35 -0400
Date: Mon, 7 Sep 2009 15:59:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Markus =?unknown-8bit?Q?T=F6rnqvist?= <mjt@nysv.org>
Cc: Frans Pop <elendil@planet.nl>, kernel@kolivas.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de
Subject: Re: [quad core results] BFS vs. mainline scheduler benchmarks and
	measurements
Message-ID: <20090907135926.GA24507@elte.hu>
References: <20090906205952.GA6516@elte.hu> <200909070405.23936.elendil@planet.nl> <20090907121613.GA32097@elte.hu> <20090907131905.GP28624@nysv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090907131905.GP28624@nysv.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Markus T?rnqvist <mjt@nysv.org> wrote:

> Please Cc me as I'm not a subscriber.
> 
> On Mon, Sep 07, 2009 at 02:16:13PM +0200, Ingo Molnar wrote:
> >
> >Con posted single-socket quad comparisons/graphs so to make it 100% 
> >apples to apples i re-tested with a single-socket (non-NUMA) quad as 
> >well, and have uploaded the new graphs/results to:
> >
> >  kernel build performance on quad:
> >     http://redhat.com/~mingo/misc/bfs-vs-tip-kbuild-quad.jpg
> [...]
> >
> >It shows similar curves and behavior to the 8-core results i posted 
> >- BFS is slower than mainline in virtually every measurement. The 
> >ratios are different for different parts of the graphs - but the 
> >trend is similar.
> 
> Dude, not cool.
> 
> 1. Quad HT is not the same as a 4-core desktop, you're doing it with 8 cores

No, it's 4 cores. HyperThreading adds two 'siblings' per core, which 
are not 'cores'.

> 2. You just proved BFS is better on the job_count == core_count case, as BFS
>    says it is, if you look at the graph

I pointed that out too. I think the graphs speak for themselves:

     http://redhat.com/~mingo/misc/bfs-vs-tip-kbuild-quad.jpg
     http://redhat.com/~mingo/misc/bfs-vs-tip-kbuild.jpg

> 3. You're comparing an old version of BFS against an unreleased dev kernel

bfs-208 was 1 day old (and it is a 500K+ kernel patch) when i tested 
it against the 2 days old sched-devel tree. Btw., i initially 
measured 205 as well and spent one more day on acquiring and 
analyzing the 208 results.

There's bfs-209 out there today. These tests take 8+ hours to 
complete and validate. I'll re-test BFS in the future too, and as i 
said it in the first mail i'll test it on a .31 base as well once 
BFS has been ported to it:

> > It's on a .31-rc8 base while BFS is on a .30 base - will be able 
> > to test BFS on a .31 base as well once you release it. (but it 
> > doesnt matter much to the results - there werent any heavy core 
> > kernel changes impacting these workloads.)

> Also, you said on http://article.gmane.org/gmane.linux.kernel/886319
> "I also tried to configure the kernel in a BFS friendly way, i used 
> HZ=1000 as recommended, turned off all debug options, etc. The 
> kernel config i used can be found here:
> http://redhat.com/~mingo/misc/config
> "
> 
> Quickly looking at the conf you have
> CONFIG_HZ_250=y
> CONFIG_PREEMPT_NONE=y
> # CONFIG_PREEMPT_VOLUNTARY is not set
> # CONFIG_PREEMPT is not set

Indeed. HZ does not seem to matter according to what i see in my 
measurements. Can you measure such sensitivity?

> CONFIG_ARCH_WANT_FRAME_POINTERS=y
> CONFIG_FRAME_POINTER=y
> 
> And other DEBUG.

These are the defaults and they dont make a measurable difference to 
these results. What other debug options do you mean and do they make 
a difference?

	Ingo
