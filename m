Return-Path: <linux-kernel-owner+w=401wt.eu-S1753944AbXDZBIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbXDZBIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 21:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754520AbXDZBIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 21:08:35 -0400
Received: from mail01.syd.optusnet.com.au ([211.29.132.182]:45924 "EHLO
	mail01.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753944AbXDZBIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 21:08:34 -0400
From: Con Kolivas <kernel@kolivas.org>
To: ck@vds.kolivas.org
Subject: Re: [ck] [REPORT] cfs-v5 vs sd-0.46
Date: Thu, 26 Apr 2007 11:06:15 +1000
User-Agent: KMail/1.9.5
Cc: Michael Gerdau <mgd@technosis.de>, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>,
       Juliusz Chroboczek <jch@pps.jussieu.fr>, Mike Galbraith <efault@gmx.de>,
       Peter Williams <pwil3058@bigpond.net.au>,
       William Lee Irwin III <wli@holomorphy.com>, Willy Tarreau <w@1wt.eu>,
       Gene Heskett <gene.heskett@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
References: <200704240938.07482.mgd@technosis.de>
In-Reply-To: <200704240938.07482.mgd@technosis.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704261106.16440.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 April 2007 17:37, Michael Gerdau wrote:
> Hi list,
>
> with cfs-v5 finally booting on my machine I have run my daily
> numbercrunching jobs on both cfs-v5 and sd-0.46, 2.6.21-v7 on
> top of a stock openSUSE 10.2 (X86_64).

Thanks for testing.

> Both cfs and sd showed very similar behavior when monitored in top.
> I'll show more or less representative excerpt from a 10 minutes
> log, delay 3sec.
>
> sd-0.46
> top - 00:14:24 up  1:17,  9 users,  load average: 4.79, 4.95, 4.80
> Tasks:   3 total,   3 running,   0 sleeping,   0 stopped,   0 zombie
> Cpu(s): 99.8%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.2%hi,  0.0%si, 
> 0.0%st Mem:   3348628k total,  1648560k used,  1700068k free,    64392k
> buffers Swap:  2097144k total,        0k used,  2097144k free,   828204k
> cached
>
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>  6671 mgd       33   0 95508  22m 3652 R  100  0.7  44:28.11 perl
>  6669 mgd       31   0 95176  22m 3652 R   50  0.7  43:50.02 perl
>  6674
>  mgd       31   0 95368  22m 3652 R   50  0.7  47:55.29 perl
>
> cfs-v5
> top - 08:07:50 up 21 min,  9 users,  load average: 4.13, 4.16, 3.23
> Tasks:   3 total,   3 running,   0 sleeping,   0 stopped,   0 zombie
> Cpu(s): 99.5%us,  0.2%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.3%si, 
> 0.0%st Mem:   3348624k total,  1193500k used,  2155124k free,    32516k
> buffers Swap:  2097144k total,        0k used,  2097144k free,   545568k
> cached
>
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>  6357 mgd       20   0 92024  19m 3652 R  100  0.6   8:54.21 perl
>  6356 mgd       20   0 91652  18m 3652 R   50  0.6  10:35.52 perl
>  6359 mgd       20   0 91700  18m 3652 R   50  0.6   8:47.32 perl
>
> What did surprise me is that cpu utilization had been spread 100/50/50
> (round robin) most of the time. I did expect 66/66/66 or so.

You have 3 tasks and only 2 cpus. The %cpu is the percentage of the cpu the 
task is currently on that it is using; it is not the percentage of 
the "overall cpu available on the machine". Since you have 3 tasks and 2 
cpus, the extra task will always be on one or the other cpu taking half of 
the cpu but never on both cpus.

> What I also don't understand is the difference in load average, sd
> constantly had higher values, the above figures are representative
> for the whole log. I don't know which is better though.

There isn't much useful to say about the load average in isolation. It may be 
meaningful or not depending on whether it just shows the timing of when the 
cpu load is determined, or whether there is more time waiting in runqueues. 
Only throughput measurements can really tell them apart.

What is important is that if all three tasks are fully cpu bound and started 
at the same time at the same nice level, that they all receive close to the 
same total cpu time overall showing some fairness is working as well. This 
should be the case no matter how many cpus you have.

-- 
-ck
