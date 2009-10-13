Return-Path: <linux-kernel-owner+w=401wt.eu-S1760042AbZJMOmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760042AbZJMOmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 10:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbZJMOmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 10:42:50 -0400
Received: from mail.gmx.net ([213.165.64.20]:59061 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753526AbZJMOmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 10:42:49 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18qkYxT904q0V/YwfVlWdT7RVJke06sG97plqz28p
	FfTHeFRpdCPY1K
Subject: Re: [patch] perf_counter tools: remove expensive old debug code
 from perf top
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20091013133707.GA21409@elte.hu>
References: <1255438640.7173.1.camel@marge.simson.net>
	 <20091013133707.GA21409@elte.hu>
Content-Type: text/plain
Date: Tue, 13 Oct 2009 16:41:59 +0200
Message-Id: <1255444919.7042.2.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-13 at 15:37 +0200, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > perf_counter tools: remove expensive old debug code from perf top
> > 
> > Calling gettimeofday() at high frequency is painful for handicapped 
> > boxen. The spot calling gettimeofday() is old unneeded debug code, so 
> > remove it.
> 
> Thanks!
> 
> We still seem to have a performance problem. Just running perf top on a 
> 16-way box:
> 
>  Performance counter stats for 'perf top -e cycles -c 3000000':
> 
>      585.694831  task-clock-msecs         #      0.113 CPUs 
>           35163  context-switches         #      0.060 M/sec
>              17  CPU-migrations           #      0.000 M/sec
>           20355  page-faults              #      0.035 M/sec
>      1476952962  cycles                   #   2521.711 M/sec
>       730770658  instructions             #      0.495 IPC  
>        11489471  cache-references         #     19.617 M/sec
>         2055001  cache-misses             #      3.509 M/sec
> 
>     5.169518576  seconds time elapsed
> 
> that's 11% of CPU time used on a single CPU - just displaying a measly 
> 16K irqs/sec. Something's not quite right here.

I'll try to figure out why after I do some more wakeup preempt testing.

btw, something broke top annotation (again).  Module symbols still
annotate, but vmlinux symbols went south.

	-Mike

