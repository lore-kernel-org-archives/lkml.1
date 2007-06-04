Return-Path: <linux-kernel-owner+w=401wt.eu-S1755290AbXFDOBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbXFDOBP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 10:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753609AbXFDOBC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 10:01:02 -0400
Received: from mx2.compro.net ([216.54.166.4]:39124 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753567AbXFDOBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 10:01:00 -0400
X-IronPort-AV: E=Sophos;i="4.16,380,1175486400"; 
   d="scan'208";a="411879"
Message-ID: <46641B16.9090701@compro.net>
Date: Mon, 04 Jun 2007 10:00:54 -0400
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Mark Hounschell <dmarkh@cfl.rr.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: floppy.c soft lockup
References: <20070531192256.GA88@tv-sign.ru> <465F2D96.9060502@compro.net> <20070601110058.GA83@tv-sign.ru> <466028DB.3060509@compro.net> <20070601151605.GA108@tv-sign.ru> <4660534E.6050903@cfl.rr.com> <20070601183642.GA92@tv-sign.ru> <466078FF.2080508@cfl.rr.com> <20070602123030.GA719@tv-sign.ru> <4661D698.5040009@cfl.rr.com> <20070603081417.GA81@tv-sign.ru>
In-Reply-To: <20070603081417.GA81@tv-sign.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 06/02, Mark Hounschell wrote:
>> Jun  2 16:36:11 harley kernel: ERR!! events/1 flush hang: c201dbc0
>> c201dbc0 10012 10012
>> Jun  2 16:36:11 harley kernel: CURR: 7974 7974 vrsx 93 26
>> Jun  2 16:36:11 harley kernel:     wq_barrier_func+0x0/0x8
>> Jun  2 16:36:11 harley kernel:     vmstat_update+0x0/0x24
>> Jun  2 16:36:11 harley kernel:     ----
>> Jun  2 16:36:11 harley kernel:     cache_reap+0x0/0xf4
> 
> As expected.
> 
> Note that ->nivcsw/->nvcsw doesn't change. There is no "spare time"
> on CPU 1, "vrsx" monopolizes CPU. events/1->cache_reap() was preempted
> by vrsx, it had no chance to run since then. Note that jobs == 7974
> doesn't change too. I forgot to print cwq->thread->state, but it should
> be TASK_RUNNING. It would not be possible to kill vrsx if cache_reap()
> stalled.
> 
> I don't think this is a kernel problem, vrsx breaks flush_workqueue().
> Ingo can answer authoritatively, but I think SCHED_RR/SCHED_FIFO were
> not designed to be 100% cpu-bound.
> 
> That said, I think it makes sense to get rid of flush_scheduled_work()
> in floppy.c.
> 

Oleg, thanks for your time in diagnosing this. 

As far as a 100% CPU bound task being a valid thing to do, it has been 
done for many years on SMP machines. Any kernel limitation on this 
surely must be considered a bug? 

Thanks again
Regards
Mark

