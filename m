Return-Path: <linux-kernel-owner+w=401wt.eu-S965261AbZLQPpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965261AbZLQPpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 10:45:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965199AbZLQPpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 10:45:44 -0500
Received: from casper.infradead.org ([85.118.1.10]:45535 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965192AbZLQPpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 10:45:43 -0500
Date: Thu, 17 Dec 2009 16:47:42 +0100
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kasper Sandberg <lkml@metanurb.dk>,
       Jason Garrett-Glaser <darkshikari@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML Mailinglist <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: x264 benchmarks BFS vs CFS
Message-ID: <20091217164742.0c2e5ca1@infradead.org>
In-Reply-To: <20091217120826.GA32125@elte.hu>
References: <1261042383.14314.0.camel@localhost>
	<28f2fcbc0912170242r6d93dfb1j337558a829e21a75@mail.gmail.com>
	<20091217105316.GB26010@elte.hu>
	<1261047618.14314.6.camel@localhost>
	<20091217120826.GA32125@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Dec 2009 13:08:26 +0100
Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > not to mention that bfs does this whilst not loosing interactivity, 
> > something which cfs certainly cannot boast.
> 
> What kind of latencies are those? Arent they just compiz induced due
> to different weighting of workloads in BFS and in the upstream
> scheduler? Would you be willing to help us out pinning them down?
> 
> To move the discussion to the numeric front please send the 'perf
> sched latency' output of an affected workload.

CFS in .32 and before has one known, and now fixed latency issue.
In .32, wake_up() (which is most causes for inter thread communication
and lots of others) was trying to keep the waker and wakee on the same
logical cpu at pretty much all cost. In .33-git, Mike fixed this to,
if there's a free logical cpu sibling, or on a multicore cpu, another
core which shares the cache, to just schedule the new task on that free
cpu rather than on the current, guaranteed busy, cpu.

This change helps latency a lot, and as a result, performance for
various latency sensitive workloads... 


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
