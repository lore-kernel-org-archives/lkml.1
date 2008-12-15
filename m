Return-Path: <linux-kernel-owner+w=401wt.eu-S1755856AbYLOWdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbYLOWdI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 17:33:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751619AbYLOWc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 17:32:56 -0500
Received: from zrtps0kn.nortel.com ([47.140.192.55]:53161 "EHLO
	zrtps0kn.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbYLOWcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 17:32:55 -0500
Message-ID: <4946DAEE.3050402@nortel.com>
Date: Mon, 15 Dec 2008 16:32:14 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: eranian@gmail.com
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Vince Weaver <vince@deater.net>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch] Performance Counters for Linux, v3
References: <20081211155230.GA4230@elte.hu>	 <Pine.LNX.4.64.0812111247510.22556@pianoman.cluster.toy>	 <1229070345.12883.12.camel@twins>	 <7c86c4470812120059s7f8e64a6h91ebeadbf938858d@mail.gmail.com>	 <1229073834.12883.41.camel@twins>	 <7c86c4470812120942x607a74f7w9f823adecbd73b85@mail.gmail.com>	 <7c86c4470812121001i765d663bq6db3080b633a1eef@mail.gmail.com>	 <4942BF69.4030402@nortel.com> <7c86c4470812150650t3b96d571nba14be2028fa9d0c@mail.gmail.com>
In-Reply-To: <7c86c4470812150650t3b96d571nba14be2028fa9d0c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Dec 2008 22:32:19.0076 (UTC) FILETIME=[FD49F440:01C95F04]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stephane eranian wrote:
> On Fri, Dec 12, 2008 at 8:45 PM, Chris Friesen <cfriesen@nortel.com> wrote:
> 
>>stephane eranian wrote:
>>
>>
>>>What happens in the following test case:
>>>
>>>  - 2-way system (cpu0, cpu1)
>>>
>>>  - on cpu0, two processes P1, P2, each self-monitoring and counting event
>>>E1.
>>>    Event E1 can only be measured on counter C1.
>>>
>>>  - on cpu1, there is a cpu-wide session, monitoring event E1, thus using
>>>C1
>>>
>>>  - the scheduler decides to migrate P1 onto CPU1. You now have a
>>>conflict on C1.
>>>
>>>How is this managed?
>>
>>Prevent the load balancer from moving P1 onto cpu1?
>>
> 
> You don't want to do that.
> 
> There was a reason why the scheduler decided to move the task.
> Now, because of monitoring you would change the behavior of the task
> and scheduler.
> Monitoring should be unintrusive. You want the task/scheduler to
> behave as if no monitoring
> was present otherwise what is it you are actually measuring?

In a scenario where the system physically cannot gather the desired data 
without influencing the behaviour of the program, I see two options:

1) limit the behaviour of the system to ensure that we can gather the 
performance monitoring data as specified

2) limit the performance monitoring to minimize any influence on the 
program, and report the fact that performance monitoring was limited.

You've indicated that you don't want option 1, so I assume that you 
prefer option 2.  In the above scenario, how would _you_ handle it?


Chris

