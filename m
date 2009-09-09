Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbZIIUMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbZIIUMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 16:12:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753850AbZIIUMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 16:12:14 -0400
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:57981 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752612AbZIIUMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 16:12:13 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-06.arcor-online.net 4702B39A826
Message-ID: <4AA80C1E.2080901@arcor.de>
Date: Wed, 09 Sep 2009 23:12:14 +0300
From: Nikos Chantziaras <realnc@arcor.de>
Organization: Lucas Barks
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090826 Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
References: <20090907173846.GB18599@kernel.dk> <20090907204458.GJ18599@kernel.dk> <20090908091304.GQ18599@kernel.dk> <1252423398.7746.97.camel@twins> <20090908203409.GJ18599@kernel.dk> <20090909061308.GA28109@elte.hu> <1252486344.28645.18.camel@marge.simson.net> <20090909091009.GR18599@kernel.dk> <20090909115429.GY18599@kernel.dk> <20090909122006.GA18599@kernel.dk> <20090909180404.GA11027@elte.hu>
In-Reply-To: <20090909180404.GA11027@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2009 09:04 PM, Ingo Molnar wrote:
> [...]
> * Jens Axboe<jens.axboe@oracle.com>  wrote:
>
>> On Wed, Sep 09 2009, Jens Axboe wrote:
>>  [...]
>> BFS210 runs on the laptop (dual core intel core duo). With make -j4
>> running, I clock the following latt -c8 'sleep 10' latencies:
>>
>> -rc9
>>
>>          Max                17895 usec
>>          Avg                 8028 usec
>>          Stdev               5948 usec
>>          Stdev mean           405 usec
>>
>>          Max                17896 usec
>>          Avg                 4951 usec
>>          Stdev               6278 usec
>>          Stdev mean           427 usec
>>
>>          Max                17885 usec
>>          Avg                 5526 usec
>>          Stdev               6819 usec
>>          Stdev mean           464 usec
>>
>> -rc9 + mike
>>
>>          Max                 6061 usec
>>          Avg                 3797 usec
>>          Stdev               1726 usec
>>          Stdev mean           117 usec
>>
>>          Max                 5122 usec
>>          Avg                 3958 usec
>>          Stdev               1697 usec
>>          Stdev mean           115 usec
>>
>>          Max                 6691 usec
>>          Avg                 2130 usec
>>          Stdev               2165 usec
>>          Stdev mean           147 usec
>
> At least in my tests these latencies were mainly due to a bug in
> latt.c - i've attached the fixed version.
>
> The other reason was wakeup batching. If you do this:
>
>     echo 0>  /proc/sys/kernel/sched_wakeup_granularity_ns
>
> ... then you can switch on insta-wakeups on -tip too.
>
> With a dual-core box and a make -j4 background job running, on
> latest -tip i get the following latencies:
>
>   $ ./latt -c8 sleep 30
>   Entries: 656 (clients=8)
>
>   Averages:
>   ------------------------------
>   	Max	      158 usec
> 	Avg	       12 usec
> 	Stdev	       10 usec

With your version of latt.c, I get these results with 2.6-tip vs 
2.6.31-rc9-bfs:


(mainline)
Averages:
------------------------------
         Max            50 usec
         Avg            12 usec
         Stdev           3 usec


(BFS)
Averages:
------------------------------
         Max           474 usec
         Avg            11 usec
         Stdev          16 usec


However, the interactivity problems still remain.  Does that mean it's 
not a latency issue?
