Return-Path: <linux-kernel-owner+w=401wt.eu-S1753226AbZLRNhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbZLRNhL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 08:37:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbZLRNhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 08:37:08 -0500
Received: from mail.gmx.net ([213.165.64.20]:60920 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751421AbZLRNhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 08:37:05 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/adCh+QFXacMWmVw9oKrFB/KYrKlegKR6MyHBe5d
	Nwp70tTktI0u53
Subject: Re: x264 benchmarks BFS vs CFS
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jason Garrett-Glaser <darkshikari@gmail.com>,
       Kasper Sandberg <lkml@metanurb.dk>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML Mailinglist <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20091218130642.GA17033@elte.hu>
References: <1261042383.14314.0.camel@localhost>
	 <28f2fcbc0912170242r6d93dfb1j337558a829e21a75@mail.gmail.com>
	 <20091217105316.GB26010@elte.hu> <1261047618.14314.6.camel@localhost>
	 <28f2fcbc0912171718x271520b4k5da3376b5182d88a@mail.gmail.com>
	 <20091218052344.GD417@elte.hu> <1261121405.30469.8.camel@marge.simson.net>
	 <28f2fcbc0912180211we599252v39cb94d113537eb5@mail.gmail.com>
	 <1261140546.15591.5.camel@marge.simson.net>
	 <20091218130642.GA17033@elte.hu>
Content-Type: text/plain
Date: Fri, 18 Dec 2009 14:36:53 +0100
Message-Id: <1261143413.15591.15.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-18 at 14:06 +0100, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > > I'm personally curious as to what kind of scheduler issues this results 
> > > in--I haven't done any BFS vs CFS tests with this option enabled yet.
> > 
> > I'll look for x264 source, and patch/piddle.
> 
> btw., would be nice to look at it via tools/perf/ as well:
> 
>   perf stat --repeat 3 ...
> 
> to see the basic hardware utilization (cycles/cache-misses, branch execution 
> rate, instructions, etc.) and the basic parallelism metrics, at a glance.
> 
> i suspect "perf stat -e L1-icache-loads -e L1-icache-load-misses" would give 
> us an even more detailed picture.

Almost virgin v2.6.32-10468-g020307d running 'medium'.

encoded 600 frames, 36.52 fps, 13003.54 kb/s

 Performance counter stats for './x264.sh 8' (3 runs):

   63742.218844  task-clock-msecs         #      3.870 CPUs    ( +-   0.016% )
          42593  context-switches         #      0.001 M/sec   ( +-   0.487% )
           3011  CPU-migrations           #      0.000 M/sec   ( +-   0.417% )
          12862  page-faults              #      0.000 M/sec   ( +-   0.004% )
   151734450892  cycles                   #   2380.439 M/sec   ( +-   1.947% )  (scaled from 71.44%)
   205642315207  instructions             #      1.355 IPC     ( +-   0.085% )  (scaled from 80.68%)
    16274905932  branches                 #    255.324 M/sec   ( +-   0.080% )  (scaled from 80.67%)
     1257135617  branch-misses            #      7.724 %       ( +-   0.255% )  (scaled from 80.06%)
     3116653323  cache-references         #     48.895 M/sec   ( +-   0.340% )  (scaled from 23.78%)
       50823973  cache-misses             #      0.797 M/sec   ( +-   1.400% )  (scaled from 23.76%)

   16.470164901  seconds time elapsed   ( +-   0.079% )

encoded 600 frames, 36.58 fps, 13003.54 kb/s

 Performance counter stats for './x264.sh 8' (3 runs):

   133692266953  L1-icache-loads            ( +-   0.027% )
      997371592  L1-icache-load-misses      ( +-   0.009% )

   16.407060367  seconds time elapsed   ( +-   0.036% )


