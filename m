Return-Path: <linux-kernel-owner+w=401wt.eu-S1762176AbXKTUC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762176AbXKTUC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 15:02:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758854AbXKTUCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 15:02:45 -0500
Received: from rtr.ca ([76.10.145.34]:2865 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761946AbXKTUCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 15:02:44 -0500
Message-ID: <47433D63.5080806@rtr.ca>
Date: Tue, 20 Nov 2007 15:02:43 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: CONFIG_IRQBALANCE for 64-bit x86 ?
References: <47425EA5.7000607@rtr.ca>	<200711201837.39664.nickpiggin@yahoo.com.au>	<20071120064747.2a8036cd@laptopd505.fenrus.org>	<200711210243.46944.nickpiggin@yahoo.com.au> <20071120110726.4cc2995e@laptopd505.fenrus.org>
In-Reply-To: <20071120110726.4cc2995e@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Wed, 21 Nov 2007 02:43:46 +1100
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
>> On Wednesday 21 November 2007 01:47, Arjan van de Ven wrote:
>>> On Tue, 20 Nov 2007 18:37:39 +1100
>>>
>>> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
>>>>> actually.... no. IRQ balancing is not a "fast" decision; every
>>>>> time you
>>>> I didn't say anything of the sort. But IRQ load could still
>>>> fluctuate a lot more rapidly than we'd like to wake up the
>>>> irqbalancer.
>>> irq load fluctuates by definition. but acting on it faster isn't the
>>> right thing.
>> Of course it is, if you want to effectively use your resources.
>> Imagine if the task balancer only polled once every 10s.
> 
> but unlike the task balancer, moving an irq is really expensive.
> (at least for networking and a few other similar systems)
> ANd no it's not just the cache bouncing, it's the entire reassembly of
> multiple packets etc etc that gets really messy.
> 
> 
>>> I assume you've read what/how irqbalance does; good luck convincing
>>> people that that kind of policy belongs in the kernel.
>> Lots of code to get topology and device information.
> 
> yes this would go away in the kernel
> 
>> Some constants
>> that make assumptions about the machine it is running on and may or
>> may not agree with what the task scheduler is trying to do.
> 
>> Some
>> classification stuff which makes guesses about how a particular bit of
> 
> you misunderstood this; the classification stuff is there to spread
> different irqs of similar class (say networking) over multiple
> cores/packages. Doing this is a system resource balancing proposition
> not just a cpu time one. 
> 
> You may think this spreading based on classification is a mistake, but
> it's based on the following observation: 
> 1) servers with multiple network cards serving internet traffic out
> really need to load balance their loads; this is for various per-cpu
> resource reasons (such as per cpu memory pools) to be evenly used. It
> also makes sure that under network spikes on both interfaces, the
> response is sane
> 2) servers with multiple IO devices need this to be spread out, just
> think of oracle etc.
> 
> for both you could argue "but we could balance this based on actual
> observed load in some way", but you can only do that if you rebalance
> at a relatively high frequency, which you really don't want to do for
> networking and probably even storage.
> 
> We used to rebalance this frequently in the 2.4-early kernels based on
> a patch from Ingo. Turned out to be a really really bad idea;
> performance really tanked.
> 
>> hardware or device driver wants to be balanced. Hacks to poll
>> hotplugging and topology changes.
> 
> "hacks" as in "rescan".. so falls under the topology code and would
> indeed be changed to hook into hotplug inside the kernel; just
> different complexity.
> 
>> I'm still convinced. Who isn't?
> 
> I know you can do SOME sort of balancing in the kernel. But please
> describe the algorithm you would use; I started out with the same
> thought but when it got down to the algorithm to me at least it became
> clear "we really don't want this complexity in kernel mode".
..

Well, for my dualCore notebook, dualCore MythTV box, and QuadCore desktop,
the behaviour of the existing, working, 32-bit kernel IRQBALANCE code
outperforms the userspace utility.

Mostly, I suspect, due to it's much faster response to changing conditions.
That's something the external one could try to match, but at present it
seems tuned specifically for high-traffic network servers, not for the
average notebook or desktop.

Cheers
