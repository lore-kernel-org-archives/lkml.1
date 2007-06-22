Return-Path: <linux-kernel-owner+w=401wt.eu-S1759969AbXFVWLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759969AbXFVWLc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 18:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753775AbXFVWLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 18:11:24 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:33491
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246AbXFVWLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 18:11:24 -0400
Date: Fri, 22 Jun 2007 15:09:21 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Daniel Walker <dwalker@mvista.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
In-Reply-To: <1182549202.3228.78.camel@dhcp193.mvista.com>
Message-ID: <Pine.LNX.4.64.0706221506560.14942@asgard.lang.hm>
References: <20070622040014.234651401@goodmis.org> 
 <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org> 
 <20070622204058.GA11777@elte.hu> <1182549202.3228.78.camel@dhcp193.mvista.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2007, Daniel Walker wrote:

> 
> On Fri, 2007-06-22 at 22:40 +0200, Ingo Molnar wrote:
>
>>
>>  - tasklets have certain fairness limitations. (they are executed in
>>    softirq context and thus preempt everything, even if there is some
>>    potentially more important, high-priority task waiting to be
>>    executed.)
>
> Since -rt has been executing tasklets in process context for a long
> time, I'm not sure this change would cause to many regressions. However,
> it seems like implicit dependencies on "tasklets preempt everything"
> might crop up. The other issue is if they don't "preempt
> everything" (most of the time), what default priority do we give them
> (all of the time)? It seems like Christoph's suggestion of converting
> all the tasklets individually might be a better option, to deal with
> specific pitfalls.

that would be the safe way to do it, but it will take a lot of time and a 
lot of testing.

it's probably better to try the big-bang change and only if you see 
problames go back and break things down.

remember, these changes have been in use in -rt for a while. there's 
reason to believe that they aren't going to cause drastic problems.

David Lang
