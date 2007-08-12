Return-Path: <linux-kernel-owner+w=401wt.eu-S938176AbXHLTnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938176AbXHLTnr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 15:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936403AbXHLTni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 15:43:38 -0400
Received: from [212.12.190.34] ([212.12.190.34]:33151 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S934581AbXHLTnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 15:43:37 -0400
From: Al Boldi <a1426z@gawab.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: CFS review
Date: Sun, 12 Aug 2007 22:43:05 +0300
User-Agent: KMail/1.5
Cc: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Roman Zippel <zippel@linux-m68k.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <200708111344.42934.a1426z@gawab.com> <200708121827.36656.a1426z@gawab.com> <20070812155242.GA1977@elte.hu>
In-Reply-To: <20070812155242.GA1977@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708122243.05191.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Al Boldi <a1426z@gawab.com> wrote:
> > The thing is, this unpredictability seems to exist even at nice level
> > 0, but the smaller granularity covers it all up.  It occasionally
> > exhibits itself as hick-ups during transient heavy workload flux.  But
> > it's not easily reproducible.
>
> In general, "hickups" can be due to many, many reasons. If a task got
> indeed delayed by scheduling jitter that is provable, even if the
> behavior is hard to reproduce, by enabling CONFIG_SCHED_DEBUG=y and
> CONFIG_SCHEDSTATS=y in your kernel. First clear all the stats:
>
>   for N in /proc/*/task/*/sched; do echo 0 > $N; done
>
> then wait for the 'hickup' to happen, and once it happens capture the
> system state (after the hickup) via this script:
>
>   http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh
>
> and tell me which specific task exhibited that 'hickup' and send me the
> debug output.

Ok.

> Also, could you try the patch below as well? Thanks,

Looks ok, but I'm not sure which workload this is supposed to improve.

There is one workload that still isn't performing well; it's a web-server 
workload that spawns 1K+ client procs.  It can be emulated by using this:

  for i in `seq 1 to 3333`; do ping 10.1 -A > /dev/null & done

The problem is that consecutive runs don't give consistent results and 
sometimes stalls.  You may want to try that.


Thanks!

--
Al

