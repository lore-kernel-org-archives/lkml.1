Return-Path: <linux-kernel-owner+w=401wt.eu-S936724AbYBVW0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936724AbYBVW0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 17:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936057AbYBVWWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 17:22:48 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2040 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935412AbYBVWWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 17:22:46 -0500
X-IronPort-AV: E=McAfee;i="5200,2160,5236"; a="775360"
Message-ID: <47BF4B32.5030808@qualcomm.com>
Date: Fri, 22 Feb 2008 14:22:42 -0800
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: markh@compro.net, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul Jackson <pj@sgi.com>
Subject: Re: [PATCH sched-devel 0/7] CPU isolation extensions
References: <47BE35B7.2070104@qualcomm.com> <1203680600.6242.20.camel@lappy>	 <47BED03A.5070707@compro.net> <1203688786.6242.27.camel@lappy>
In-Reply-To: <1203688786.6242.27.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Fri, 2008-02-22 at 08:38 -0500, Mark Hounschell wrote:
> 
>>>> List of commits
>>>>    cpuisol: Make cpu isolation configrable and export isolated map
>>>  
>>> cpu_isolated_map was a bad hack when it was introduced, I feel we should
>>> deprecate it and fully integrate the functionality into cpusets. That would
>>> give a much more flexible end-result.
>>>
>>> CPU-sets can already isolate cpus by either creating a cpu outside of any set,
>>> or a set with a single cpu not shared by any other sets.
>>>
>> Peter, what about when I am NOT using cpusets and are disabled in my config but
>> I still want to use this?
> 
> Then you enable it?
I'm with Mark on this one. For example if I have two core machine I do not need cpusets
to manage them.
Plus like I explained in prev email cpuset is higher level API. We can think of a way to
integrated them if needed.

>>>>    cpuisol: Do not schedule workqueues on the isolated CPUs
>>>  
>>> (per-cpu workqueues, the single ones are treated in the previous section)
>>>
>>> I still strongly disagree with this approach. Workqueues are passive, they
>>> don't do anything unless work is provided to them. By blindly not starting them
>>> you handicap the system and services that rely on them.
>>>
>> Have things changed since since my first bad encounter with Workqueues.
>> I am referring to this thread. 
>>
>> http://kerneltrap.org/mailarchive/linux-kernel/2007/5/29/97039 
> 
> Just means you get to fix those problems. By blindly not starting them
> you introduce others.

Please give me an example of what you have in mind.
Also if you look at the patch (which I've now posted properly) it's not just not starting them.
I also redirected all future scheduled work to non-isolated CPU. ie If work is scheduled on the
isolated CPU this work is treated as if the work queue is single threaded. As I explained before
most subsystem do not care which CPU actually gets to execute the work. Oprofile is the only
one I know of that breaks because it cannot collect the stats from the isolated CPUs. I'm thinking
of a different solution for oprofile, maybe collection samples through IPIs or something.

Max
