Return-Path: <linux-kernel-owner+w=401wt.eu-S1752391AbZIIJR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391AbZIIJR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 05:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbZIIJR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 05:17:56 -0400
Received: from viefep18-int.chello.at ([62.179.121.38]:18136 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbZIIJR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 05:17:56 -0400
X-SourceIP: 213.93.53.227
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Nikos Chantziaras <realnc@arcor.de>
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       Jens Axboe <jens.axboe@oracle.com>, Con Kolivas <kernel@kolivas.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <4AA76FD2.1050103@arcor.de>
References: <20090906205952.GA6516@elte.hu>
	 <20090907094953.GP18599@kernel.dk> <20090907115750.GW18599@kernel.dk>
	 <20090907141458.GD24507@elte.hu> <20090907173846.GB18599@kernel.dk>
	 <20090907204458.GJ18599@kernel.dk> <20090908091304.GQ18599@kernel.dk>
	 <1252423398.7746.97.camel@twins> <20090908203409.GJ18599@kernel.dk>
	 <20090909061308.GA28109@elte.hu>
	 <1252486344.28645.18.camel@marge.simson.net>  <4AA76FD2.1050103@arcor.de>
Content-Type: text/plain
Date: Wed, 09 Sep 2009 11:17:49 +0200
Message-Id: <1252487869.7746.181.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-09 at 12:05 +0300, Nikos Chantziaras wrote:

> Thank you for mentioning min_granularity.  After:
> 
>    echo 10000000 > /proc/sys/kernel/sched_latency_ns
>    echo 2000000 > /proc/sys/kernel/sched_min_granularity_ns

You might also want to do:

     echo 2000000 > /proc/sys/kernel/sched_wakeup_granularity_ns

That affects when a newly woken task will preempt an already running
task.

> I can clearly see an improvement: animations that are supposed to be 
> fluid "skip" much less now, and in one occasion (simply moving the video 
> window around) have been eliminated completely.  However, there seems to 
> be a side effect from having CONFIG_SCHED_DEBUG enabled; things seem to 
> be generally a tad more "jerky" with that option enabled, even when not 
> even touching the latency and granularity defaults.

There's more code in the scheduler with that enabled but unless you've
got a terrible high ctx rate that really shouldn't affect things.

Anyway, you can always poke at these numbers in the code, and like Mike
did, kill sched_init_granularity().



