Return-Path: <linux-kernel-owner+w=401wt.eu-S1754198AbZIIUum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198AbZIIUum (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 16:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754098AbZIIUul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 16:50:41 -0400
Received: from brick.kernel.dk ([93.163.65.50]:60085 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754067AbZIIUul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 16:50:41 -0400
Date: Wed, 9 Sep 2009 22:50:43 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Nikos Chantziaras <realnc@arcor.de>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090909205043.GI18599@kernel.dk>
References: <20090908091304.GQ18599@kernel.dk> <1252423398.7746.97.camel@twins> <20090908203409.GJ18599@kernel.dk> <20090909061308.GA28109@elte.hu> <1252486344.28645.18.camel@marge.simson.net> <20090909091009.GR18599@kernel.dk> <20090909115429.GY18599@kernel.dk> <20090909122006.GA18599@kernel.dk> <20090909180404.GA11027@elte.hu> <4AA80C1E.2080901@arcor.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AA80C1E.2080901@arcor.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 09 2009, Nikos Chantziaras wrote:
> On 09/09/2009 09:04 PM, Ingo Molnar wrote:
>> [...]
>> * Jens Axboe<jens.axboe@oracle.com>  wrote:
>>
>>> On Wed, Sep 09 2009, Jens Axboe wrote:
>>>  [...]
>>> BFS210 runs on the laptop (dual core intel core duo). With make -j4
>>> running, I clock the following latt -c8 'sleep 10' latencies:
>>>
>>> -rc9
>>>
>>>          Max                17895 usec
>>>          Avg                 8028 usec
>>>          Stdev               5948 usec
>>>          Stdev mean           405 usec
>>>
>>>          Max                17896 usec
>>>          Avg                 4951 usec
>>>          Stdev               6278 usec
>>>          Stdev mean           427 usec
>>>
>>>          Max                17885 usec
>>>          Avg                 5526 usec
>>>          Stdev               6819 usec
>>>          Stdev mean           464 usec
>>>
>>> -rc9 + mike
>>>
>>>          Max                 6061 usec
>>>          Avg                 3797 usec
>>>          Stdev               1726 usec
>>>          Stdev mean           117 usec
>>>
>>>          Max                 5122 usec
>>>          Avg                 3958 usec
>>>          Stdev               1697 usec
>>>          Stdev mean           115 usec
>>>
>>>          Max                 6691 usec
>>>          Avg                 2130 usec
>>>          Stdev               2165 usec
>>>          Stdev mean           147 usec
>>
>> At least in my tests these latencies were mainly due to a bug in
>> latt.c - i've attached the fixed version.
>>
>> The other reason was wakeup batching. If you do this:
>>
>>     echo 0>  /proc/sys/kernel/sched_wakeup_granularity_ns
>>
>> ... then you can switch on insta-wakeups on -tip too.
>>
>> With a dual-core box and a make -j4 background job running, on
>> latest -tip i get the following latencies:
>>
>>   $ ./latt -c8 sleep 30
>>   Entries: 656 (clients=8)
>>
>>   Averages:
>>   ------------------------------
>>   	Max	      158 usec
>> 	Avg	       12 usec
>> 	Stdev	       10 usec
>
> With your version of latt.c, I get these results with 2.6-tip vs  
> 2.6.31-rc9-bfs:
>
>
> (mainline)
> Averages:
> ------------------------------
>         Max            50 usec
>         Avg            12 usec
>         Stdev           3 usec
>
>
> (BFS)
> Averages:
> ------------------------------
>         Max           474 usec
>         Avg            11 usec
>         Stdev          16 usec
>
>
> However, the interactivity problems still remain.  Does that mean it's  
> not a latency issue?

It probably just means that latt isn't a good measure of the problem.
Which isn't really too much of a surprise.

-- 
Jens Axboe

