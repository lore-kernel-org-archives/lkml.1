Return-Path: <linux-kernel-owner+w=401wt.eu-S1753815AbZIHGz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815AbZIHGz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 02:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbZIHGz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 02:55:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47670 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467AbZIHGzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 02:55:25 -0400
Date: Tue, 8 Sep 2009 08:55:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: lookeylam <lookeylam@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: About CPU's Load Balance and CFS functions
Message-ID: <20090908065519.GC6505@elte.hu>
References: <200909071614346093582@gmail.com> <1252351192.7503.29.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252351192.7503.29.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, 2009-09-07 at 16:14 +0800, lookeylam wrote:
> > Hello:
> >          I am  not sure this  is the right maillist to ask this
> > question. I just have a try.
> >          I have a test on Dell 1950 with 8 cpus on board for testing
> > the apache by ab command. And I find that in 
> >          linux 2.6.18. The processes forked by apache are not well
> > distributed on these 8 cpus.
> >          linux 2.6.23 is a little better than 2.6.18, but still some
> > cpus are running busy and some cpus remains idle.
> >          While in  2.6.30, these 8 cpus are well used and the
> > percentage of each cpu is nearly the same. And when I 
> >          start the control group with cpuset type with
> > sched_relax_domain_level( with value 3,4,5). The result of ab is 50ms
> > better than test results without control group. 
> >         
> >          I attribute this situation to to load_balance but not CFS,
> > because CFS is just a scheduler for orgnizing the process inside one
> > cpu, while load_balance is the main character to control the process
> > and load between different cpus.
> >          But when i give out this conclusion, I confuse about the
> > differences of these three kernels of load_balance.
> >          
> >          My questions are the above conclusion  is right or not? How
> > would these situation happen and why? I read the code of the kernel
> > but I am still not sure.
> 
> load-balancing is generally considered part of the scheduler as a 
> whole, while CFS is indeed the cpu scheduler, it and the 
> load-balancer are related because they do have to work together.
> 
> Now, in the past 3+years the load-balancer has undergone 
> significant changes too -- and we're now again poking at it, .32 
> will likely have quite radical changes to the whole load balancer.
> 
> The sched_relax_domain_level knob is one that controls one of the 
> coupling mechanisms, namely wake on idle, that is, we try and push 
> newly woken tasks away to idle cpus. The level you put in there is 
> related to the sched_domain level.
> 
> Normally we don't try and push newly woken tasks too far away, 
> because that'll increase the remote access penalty for related 
> tasks, but some workloads have lots of very short running 
> unrelated tasks which do benefit from this.
> 
> Anyway, I would suggest you keep an eye out for scheduler patches 
> if you're interested in this, all the scheduler development 
> happens in -tip.

Which can be tested via:

  http://people.redhat.com/mingo/tip.git/README

	Ingo
