Return-Path: <linux-kernel-owner+w=401wt.eu-S935306AbXEVWVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935306AbXEVWVb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 18:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933775AbXEVWVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 18:21:21 -0400
Received: from mail.tmr.com ([64.65.253.246]:43953 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764428AbXEVWVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 18:21:19 -0400
Message-ID: <46536D52.9010707@tmr.com>
Date: Tue, 22 May 2007 18:23:14 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Scheduling tests on IPC methods, fc6, sd0.48, cfs12
References: <464CE4AE.3030908@tmr.com> <20070521073016.GB3915@elte.hu>
In-Reply-To: <20070521073016.GB3915@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Bill Davidsen <davidsen@tmr.com> wrote:
> 
>> I have posted the results of my initial testing, measuring IPC rates 
>> using various schedulers under no load, limited nice load, and heavy 
>> load at nice 0.
>>
>> http://www.tmr.com/~davidsen/ctxbench_testing.html
> 
> nice! For this to become really representative though i'd like to ask 
> for a real workload function to be used after the task gets the 
> lock/message. The reason is that there is an inherent balancing conflict 
> in this area: should the scheduler 'spread' tasks to other CPUs or not? 
> In general, for all workloads that matter, the answer is almost always: 
> 'yes, it should'.
> 
Added to the short to-do list. Note that this was originally simply a 
check to see which IPC works best (or at all) in an o/s. It has been 
useful for some other things, and an option for work will be forthcoming.

> But in your ctxbench results the work a task performs after doing IPC is 
> not reflected (the benchmark goes about to do the next IPC - hence 
> penalizing scheduling strategies that move tasks to other CPUs) - hence 
> the bonus of a scheduler properly spreading out tasks is not measured 
> fairly. A real-life IPC workload is rarely just about messaging around 
> (a single task could do that itself) - some real workload function is 
> used. You can see this effect yourself: do a "taskset -p 01 $$" before 
> running ctxbench and you'll see the numbers improve significantly on all 
> of the schedulers.
> 
> As a solution i'd suggest to add a workload function with a 100 or 200 
> usecs (or larger) cost (as a fixed-length loop or something like that) 
> so that the 'spreading' effect/benefit gets measured fairly too.
> 
Can do.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
