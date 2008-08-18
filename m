Return-Path: <linux-kernel-owner+w=401wt.eu-S1755638AbYHRSCD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638AbYHRSCD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 14:02:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbYHRSBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:01:54 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48637 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040AbYHRSBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:01:53 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5363"; a="5632484"
Message-ID: <48A9B906.7090201@qualcomm.com>
Date: Mon, 18 Aug 2008 11:01:42 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Peter Zijlstra <peterz@infradead.org>,
       "Torvalds, Linus" <torvalds@linux-foundation.org>,
       Stefani Seibold <stefani@seibold.net>, linux-kernel@vger.kernel.org,
       mingo@redhat.com
Subject: Re: SCHED_FIFO and SCHED_RR broken by cfs
References: <1218880552.11912.9.camel@matrix> <200808182124.17359.nickpiggin@yahoo.com.au> <1219060315.10800.338.camel@twins> <200808182214.08942.nickpiggin@yahoo.com.au>
In-Reply-To: <200808182214.08942.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Monday 18 August 2008 21:51, Peter Zijlstra wrote:
>> On Mon, 2008-08-18 at 21:24 +1000, Nick Piggin wrote:
>>> Really, you think the enterprise distros will willingly break POSIX
>>> and their own backwards compatiblity by default? I wouldn't have
>>> thought so, but anyway I guess they are free to make that choice, so
>>> where's the problem?
>> I'm not seeing why you're making such a big fuss over this - IMO its not
>> such a significant breakage. Esp since very few realtime apps will
>> require such large amounts of time to ever run into the throttle.
>>
>> If their usage is 95%+ cpu they must have magic WCET estamates - or like
>> in this case, be a benchmark app which IMHO just abuses the real-time
>> class.
> 
> Note that this certainly does not have to be the case. It is perfectly
> valid to dynamically scale the work performed according to the amount
> of CPU time available but still be sensitive to latency.
> 
> video decoding would be a really simple example. But you can't just
> "know" how all RT apps are coded and think this is no problem.
> 
> 
>> It's like running your real-time code on a 5% slower cpu - if it runs
>> correctly on the 5% slower cpu, it will run correctly here too.
> 
> Aside from the latency issue which makes this statement incorrect...
> If the code does not run correctly on a 5% slower CPU, it will break.
> How is that OK?
> 
> You might expect many systems would include at least a 5% margin of
> error, but if the kernel takes 5%, then that's 5% of the safety
> margin gone, so while the app might "work", it might no longer
> meet requirements.
> 
> 
>> Note that correctness from a RT pov is making your deadline.
> 
> Correctness from the kernel's POV is implementing APIs as advertised,
> and just as importantly, not changing them. We can argue about how RT
> apps work, but there is no argument that the kernel has broken
> backwards compatibility and standards.

Just wanted to mention that I'm with Nick on this one. I pointed this 
(ie POSIX breakage) out as soon as the change went in. I do have a valid 
  (which some people disagree with ;-)) workload that uses 100% of the 
CPU. So my unit-tests caught this right away.

Anyway, "RT bandwidth throttling" has been in and enabled be default 
since 2.6.25. So I'm not sure if it makes sense to revert the default at 
this point.
If we do change the default maybe we can add a CONFIG_ option for this 
so that it can be compiled out completely.

Max




