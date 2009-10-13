Return-Path: <linux-kernel-owner+w=401wt.eu-S1759922AbZJMNh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759922AbZJMNh4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 09:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758243AbZJMNhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 09:37:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45858 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbZJMNhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 09:37:55 -0400
Date: Tue, 13 Oct 2009 15:37:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] perf_counter tools: remove expensive old debug code
	from perf top
Message-ID: <20091013133707.GA21409@elte.hu>
References: <1255438640.7173.1.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255438640.7173.1.camel@marge.simson.net>
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


* Mike Galbraith <efault@gmx.de> wrote:

> perf_counter tools: remove expensive old debug code from perf top
> 
> Calling gettimeofday() at high frequency is painful for handicapped 
> boxen. The spot calling gettimeofday() is old unneeded debug code, so 
> remove it.

Thanks!

We still seem to have a performance problem. Just running perf top on a 
16-way box:

 Performance counter stats for 'perf top -e cycles -c 3000000':

     585.694831  task-clock-msecs         #      0.113 CPUs 
          35163  context-switches         #      0.060 M/sec
             17  CPU-migrations           #      0.000 M/sec
          20355  page-faults              #      0.035 M/sec
     1476952962  cycles                   #   2521.711 M/sec
      730770658  instructions             #      0.495 IPC  
       11489471  cache-references         #     19.617 M/sec
        2055001  cache-misses             #      3.509 M/sec

    5.169518576  seconds time elapsed

that's 11% of CPU time used on a single CPU - just displaying a measly 
16K irqs/sec. Something's not quite right here.

	Ingo
