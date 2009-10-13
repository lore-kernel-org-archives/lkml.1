Return-Path: <linux-kernel-owner+w=401wt.eu-S1760044AbZJMOn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760044AbZJMOn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 10:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753756AbZJMOn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 10:43:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539AbZJMOnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 10:43:55 -0400
Date: Tue, 13 Oct 2009 11:43:12 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] perf_counter tools: remove expensive old debug code
	from perf top
Message-ID: <20091013144312.GE21809@ghostprotocols.net>
References: <1255438640.7173.1.camel@marge.simson.net> <20091013133707.GA21409@elte.hu> <1255444919.7042.2.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255444919.7042.2.camel@marge.simson.net>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Oct 13, 2009 at 04:41:59PM +0200, Mike Galbraith escreveu:
> On Tue, 2009-10-13 at 15:37 +0200, Ingo Molnar wrote:
> > * Mike Galbraith <efault@gmx.de> wrote:
> > 
> > > perf_counter tools: remove expensive old debug code from perf top
> > > 
> > > Calling gettimeofday() at high frequency is painful for handicapped 
> > > boxen. The spot calling gettimeofday() is old unneeded debug code, so 
> > > remove it.
> > 
> > Thanks!
> > 
> > We still seem to have a performance problem. Just running perf top on a 
> > 16-way box:
> > 
> >  Performance counter stats for 'perf top -e cycles -c 3000000':
> > 
> >      585.694831  task-clock-msecs         #      0.113 CPUs 
> >           35163  context-switches         #      0.060 M/sec
> >              17  CPU-migrations           #      0.000 M/sec
> >           20355  page-faults              #      0.035 M/sec
> >      1476952962  cycles                   #   2521.711 M/sec
> >       730770658  instructions             #      0.495 IPC  
> >        11489471  cache-references         #     19.617 M/sec
> >         2055001  cache-misses             #      3.509 M/sec
> > 
> >     5.169518576  seconds time elapsed
> > 
> > that's 11% of CPU time used on a single CPU - just displaying a measly 
> > 16K irqs/sec. Something's not quite right here.
> 
> I'll try to figure out why after I do some more wakeup preempt testing.
> 
> btw, something broke top annotation (again).  Module symbols still
> annotate, but vmlinux symbols went south.

I'll check this one, and I'm profiling perf top as well.

- Arnaldo
