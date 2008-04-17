Return-Path: <linux-kernel-owner+w=401wt.eu-S1760860AbYDQIbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760860AbYDQIbF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 04:31:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755650AbYDQIax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 04:30:53 -0400
Received: from brick.kernel.dk ([87.55.233.238]:17243 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755611AbYDQIaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 04:30:52 -0400
Date: Thu, 17 Apr 2008 10:30:49 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Paolo Valente <paolo.valente@unimore.it>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: [RESEND][RFC] BFQ I/O Scheduler
Message-ID: <20080417083047.GV12774@kernel.dk>
References: <20080401152903.GB34860@gandalf.sssup.it> <20080416184441.GA3923@ucw.cz> <4806EACB.7040408@unimore.it> <20080417071012.GP12774@kernel.dk> <480709A2.7040606@unimore.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480709A2.7040606@unimore.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17 2008, Paolo Valente wrote:
> Jens Axboe ha scritto:
> >>Actually, in the worst case among our tests, the aggregate throughput 
> >>with 4k sectors was ~ 20 MB/s, hence the time for 4k sectors ~ 4k * 512 
> >>/ 20M = 100 ms.
> >>    
> >
> >That's not worse case, it is pretty close to BEST case. 
> Yes. 100 ms is just the worst case among our tests with 4k, but these 
> tests are limited to not much more than simultaneous sequential reads.
> >Worst case is 4k
> >of sectors, with each being a 512b IO and causing a full stroke seek.
> >For that type of workload, even a modern sata hard drive will be doing
> >500kb/sec or less. That's rougly a thousand sectors per seconds, so ~4
> >seconds worst case for 4k sectors.
> >  
> In my opinion, the time-slice approach of cfq is definitely better 
> suited than the (sector) budget approach for this type of workloads. On 
> the opposite end, the price of time-slices is unfairness towards, e.g., 
> threads doing sequential accesses. In bfq we were mainly thinking about 
> file copy, ftp, video streaming and so on. I was not able to find a good 
> solution for both types of workloads.

Which is fine, nothing wrong with a scheduler tuned for a specific
workload. High lighting the short comings are also interesting :-)

> BTW, there is also another possibility. The internal scheduler of bfq 
> may be used to schedule time-slices instead of budgets. By doing so, the 
> O(1) instead of O(N) delay/jitter would still be guaranteed (as it is 
> probably already clear, bfq is obtained from cfq by just turning slices 
> into budgets, and the Round Robin-like scheduling policy into a Weighted 
> Fair Queueuing one).

I was thinking about that too. Generally I've been opposed to doing
scheduling decisions on anything but time, since that is always
relevant. When to hand out slices and to what process, that algorithm is
really basic in CFQ and could do with an improvement.

-- 
Jens Axboe

