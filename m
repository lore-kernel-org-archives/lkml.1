Return-Path: <linux-kernel-owner+w=401wt.eu-S1757268AbXKAKDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268AbXKAKDW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 06:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759663AbXKAKDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 06:03:01 -0400
Received: from mail.gmx.net ([213.165.64.20]:49549 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759427AbXKAKDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 06:03:00 -0400
X-Authenticated: #12956409
X-Provags-ID: V01U2FsdGVkX1+tLxhHJNGtR2AgxEEsyd66vdCOjek8J0CW0nxDaP
	SPTYary9orcxWQ
Message-ID: <4729A453.4080803@gmx.net>
Date: Thu, 01 Nov 2007 11:02:59 +0100
From: Cyrus Massoumi <cyrusm@gmx.net>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: aim7 -30% regression in 2.6.24-rc1
References: <1193391787.3019.174.camel@ymzhang>	 <20071026112307.GA30406@elte.hu> <1193624538.3019.189.camel@ymzhang>	 <1193650626.3019.198.camel@ymzhang> <1193710325.3019.203.camel@ymzhang>	 <20071030072658.GB20372@elte.hu>  <1193733390.3019.210.camel@ymzhang>	 <1193824668.3019.236.camel@ymzhang> <1193909669.3019.246.camel@ymzhang>
In-Reply-To: <1193909669.3019.246.camel@ymzhang>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zhang, Yanmin wrote:
> On Wed, 2007-10-31 at 17:57 +0800, Zhang, Yanmin wrote:
>> On Tue, 2007-10-30 at 16:36 +0800, Zhang, Yanmin wrote:
>>> On Tue, 2007-10-30 at 08:26 +0100, Ingo Molnar wrote:
>>>> * Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
>>>>
>>>>> sub-bisecting captured patch 
>>>>> 38ad464d410dadceda1563f36bdb0be7fe4c8938(sched: uniform tunings) 
>>>>> caused 20% regression of aim7.
>>>>>
>>>>> The last 10% should be also related to sched parameters, such like 
>>>>> sysctl_sched_min_granularity.
>>>> ah, interesting. Since you have CONFIG_SCHED_DEBUG enabled, could you 
>>>> please try to figure out what the best value for 
>>>> /proc/sys/kernel_sched_latency, /proc/sys/kernel_sched_nr_latency and 
>>>> /proc/sys/kernel_sched_min_granularity is?
>>>>
>>>> there's a tuning constraint for kernel_sched_nr_latency: 
>>>>
>>>> - kernel_sched_nr_latency should always be set to 
>>>>   kernel_sched_latency/kernel_sched_min_granularity. (it's not a free 
>>>>   tunable)
>>>>
>>>> i suspect a good approach would be to double the value of 
>>>> kernel_sched_latency and kernel_sched_nr_latency in each tuning 
>>>> iteration, while keeping kernel_sched_min_granularity unchanged. That 
>>>> will excercise the tuning values of the 2.6.23 kernel as well.
>>> I followed your idea to test 2.6.24-rc1. The improvement is slow.
>>> When sched_nr_latency=2560 and sched_latency_ns=640000000, the performance
>>> is still about 15% less than 2.6.23.
>> I got the aim7 30% regression on my new upgraded stoakley machine. I found
>> this mahcine is slower than the old one. Maybe BIOS has issues, or memeory(Might not
>> be dual-channel?) is slow. So I retested it on the old machine and found on the old
>> stoakley machine, the regression is about 6%, quite similiar to the regression on tigerton
>> machine.
>>
>> By sched_nr_latency=640 and sched_latency_ns=640000000 on the old stoakley machine,
>> the regression becomes about 2%. Other latency has more regression.
>>
>> On my tulsa machine, by sched_nr_latency=640 and sched_latency_ns=640000000,
>> the regression becomes less than 1% (The original regression is about 20%).
> I rerun SPECjbb by ched_nr_latency=640 and sched_latency_ns=640000000. On tigerton,
> the regression is still more than 40%. On stoakley machine, it becomes worse (26%,
> original is 9%). I will do more investigation to make sure SPECjbb regression is
> also casued by the bad default values.
> 
> We need a smarter method to calculate the best default values for the key tuning
> parameters.
> 
> One interesting is sysbench+mysql(readonly) got the same result like 2.6.22 (no
> regression). Good job!

Do you mean you couldn't reproduce the regression which was reported 
with 2.6.23 (http://lkml.org/lkml/2007/10/30/53) with 2.6.24-rc1? It 
would be nice if you could provide some numbers for 2.6.22, 2.6.23 and 
2.6.24-rc1.

> -yanmin

greetings
Cyrus

