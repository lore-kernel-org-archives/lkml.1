Return-Path: <linux-kernel-owner+w=401wt.eu-S1754660AbZBIHVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbZBIHVR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 02:21:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbZBIHVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 02:21:00 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58415 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753925AbZBIHU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 02:20:59 -0500
Message-ID: <498FD94B.7010205@cn.fujitsu.com>
Date: Mon, 09 Feb 2009 15:20:43 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       =?UTF-8?B?RnLDqWTDqXJpYyBXZWlz?= =?UTF-8?B?YmVja2Vy?= 
	<fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] workqueue: not allow recursion run_workqueue
References: <497838F0.7020408@cn.fujitsu.com> <20090122093046.GC5891@nowhere> <20090122093649.GD24758@elte.hu> <c62985530901220306p78ea541cs28912a844297b304@mail.gmail.com> <1232622615.4890.114.camel@laptop> <498AA0F1.2030003@cn.fujitsu.com> <20090205170156.GA25517@redhat.com> <498B9055.8020407@cn.fujitsu.com> <20090206164649.GA24887@redhat.com>
In-Reply-To: <20090206164649.GA24887@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 02/06, Lai Jiangshan wrote:
>> Oleg Nesterov wrote:
>>> On 02/05, Lai Jiangshan wrote:
>>>> DEADLOCK EXAMPLE for explain my above option:
>>>>
>>>> (work_func0() and work_func1() are work callback, and they
>>>> calls flush_workqueue())
>>>>
>>>> CPU#0					CPU#1
>>>> run_workqueue()                         run_workqueue()
>>>>   work_func0()                            work_func1()
>>>>     flush_workqueue()                       flush_workqueue()
>>>>       flush_cpu_workqueue(0)                  .
>>>>       flush_cpu_workqueue(cpu#1)              flush_cpu_workqueue(cpu#0)
>>>>         waiting work_func1() in cpu#1           waiting work_func0 in cpu#0
>>>>
>>>> DEADLOCK!
>>> I am not sure. Note that when work_func0() calls run_workqueue(),
>>> it will clear cwq->current_work, so another flush_ on CPU#1 will
>>> not wait for work_func0, no?
>> cwq->current_work is changed only when
>> !list_empty(&cwq->worklist)
>> in run_workqueue().
>>
>> so cwq->current_work may not be changed.
> 
> Ah, indeed.
> 
> Thanks for correcting me!
> 
> Oleg.
> 
> 
> 
> 

Thanks,

Could you Ack these patches?

Lai.

