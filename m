Return-Path: <linux-kernel-owner+w=401wt.eu-S1759775AbZFZMXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759775AbZFZMXb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 08:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758971AbZFZMXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 08:23:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:53694 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758861AbZFZMXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 08:23:11 -0400
Subject: Re: [PATCH -tip] perf_counter tools: add support to set of
 multiple events in one short
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1245968914.10962.12.camel@hpdv5.satnam>
References: <1245963764.10962.2.camel@hpdv5.satnam>
	 <1245968914.10962.12.camel@hpdv5.satnam>
Content-Type: text/plain
Date: Fri, 26 Jun 2009 17:52:37 +0530
Message-Id: <1246018957.2976.1.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-26 at 03:58 +0530, Jaswinder Singh Rajput wrote:
> On Fri, 2009-06-26 at 02:32 +0530, Jaswinder Singh Rajput wrote:
> > Add support for HARDWARE and SOFTWARE events :
> >  perf stat -e all-sw-events
> >  perf stat -e sw-events
> >  perf stat -e all-hw-events
> >  perf stat -e hw-events
> > 
> > On AMD box :
> > 
> > ./perf stat -e hw-events -e all-sw-events -- ls -lR > /dev/null
> > 
> >  Performance counter stats for 'ls -lR':
> > 
> >         9977353  cycles               #    557.193 M/sec  (scaled from 21.81%)
> >         4244800  instructions         #      0.425 IPC    (scaled from 27.51%)
> >         2953188  cache-references     #    164.923 M/sec  (scaled from 89.10%)
> >           72469  cache-misses         #      4.047 M/sec  (scaled from 89.13%)
> >          775760  branches             #     43.323 M/sec  (scaled from 89.10%)
> >           57814  branch-misses        #      3.229 M/sec  (scaled from 83.34%)
> >   <not counted>  bus-cycles
> >       17.970985  cpu-clock-msecs
> >       17.906460  task-clock-msecs     #      0.955 CPUs
> >             386  page-faults          #      0.022 M/sec
> >             386  minor-faults         #      0.022 M/sec
> >               0  major-faults         #      0.000 M/sec
> >               4  context-switches     #      0.000 M/sec
> >               1  CPU-migrations       #      0.000 M/sec
> > 
> >     0.018750671  seconds time elapsed.
> > 
> > Reported-by : Ingo Molnar <mingo@elte.hu>
> > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > ---
> >  tools/perf/util/parse-events.c |   66 ++++++++++++++++++++++++++++++++++++++-
> >  1 files changed, 64 insertions(+), 2 deletions(-)
> 
> Please treat :
>  [PATCH -tip] perf_counter tools: add support to set of multiple events in one short
> as 
>  [PATCH 1/2-tip] perf_counter tools: add support to set of multiple events in one short
> 
> And here is 2/2 :
> 
> [PATCH 2/2 -tip] perf_counter tools: Add support for all CACHE events
> 
> Add support for all CACHE events :
>  perf stat -e all-cache-events
>  perf stat -e cache-events
> 
> On AMD box (<not-counted> events are not available for AMD):
> 
> ./perf stat -e all-cache-events -- ls -lR /usr/include/ > /dev/null
> 
>  Performance counter stats for 'ls -lR /usr/include/':
> 
>       246370884  L1-d$-loads           (scaled from 23.55%)
>         1074018  L1-d$-load-misses     (scaled from 23.38%)
>          150708  L1-d$-stores          (scaled from 23.57%)
>   <not counted>  L1-d$-store-misses
>          428804  L1-d$-prefetches      (scaled from 23.47%)
>          314446  L1-d$-prefetch-misses  (scaled from 23.42%)
>       252626137  L1-i$-loads           (scaled from 23.24%)
>         3985110  L1-i$-load-misses     (scaled from 23.24%)
>           93754  L1-i$-prefetches      (scaled from 23.34%)
>   <not counted>  L1-i$-prefetch-misses
>         5202314  LLC-loads             (scaled from 23.34%)
>          525467  LLC-load-misses       (scaled from 23.25%)
>         5220558  LLC-stores            (scaled from 23.21%)
>   <not counted>  LLC-store-misses
>   <not counted>  LLC-prefetches
>   <not counted>  LLC-prefetch-misses
>       251954203  dTLB-loads            (scaled from 23.70%)
>         5297550  dTLB-load-misses      (scaled from 23.96%)
>   <not counted>  dTLB-stores
>   <not counted>  dTLB-store-misses
>   <not counted>  dTLB-prefetches
>   <not counted>  dTLB-prefetch-misses
>       248561524  iTLB-loads            (scaled from 24.15%)
>            4693  iTLB-load-misses      (scaled from 24.18%)
>       106992392  branch-loads          (scaled from 23.67%)
>         5239561  branch-load-misses    (scaled from 23.43%)
> 
>     0.395946903  seconds time elapsed.
> 
> Reported-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  tools/perf/util/parse-events.c |   70 +++++++++++++++++++++++++++++++++++++---
>  1 files changed, 65 insertions(+), 5 deletions(-)
> 


If this looks OK then can I send following patches.

Thanks,
--
JSR

