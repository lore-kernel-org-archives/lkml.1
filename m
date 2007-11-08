Return-Path: <linux-kernel-owner+w=401wt.eu-S1760777AbXKHLr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760777AbXKHLr5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 06:47:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759227AbXKHLru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 06:47:50 -0500
Received: from il.qumranet.com ([82.166.9.18]:54164 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758821AbXKHLrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 06:47:49 -0500
Message-ID: <4732F728.8020707@qumranet.com>
Date: Thu, 08 Nov 2007 13:46:48 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>,
       Marin Mitov <mitov@issp.bas.bg>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: is minimum udelay() not respected in preemptible SMP kernel-2.6.23?
References: <200711071921.52330.mitov@issp.bas.bg> <20071107123045.c6d4b855.akpm@linux-foundation.org> <20071108002027.GV17536@waste.org> <200711080131.01243.ak@suse.de>
In-Reply-To: <200711080131.01243.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Thursday 08 November 2007 01:20, Matt Mackall wrote:
>   
>> On Wed, Nov 07, 2007 at 12:30:45PM -0800, Andrew Morton wrote:
>>     
>>> Ow.  Yes, from my reading delay_tsc() can return early (or after
>>> heat-death-of-the-universe) if the TSCs are offset and if preemption
>>> migrates the calling task between CPUs.
>>>
>>> I suppose a lameo fix would be to disable preemption in delay_tsc().
>>>       
>> preempt_disable is lousy documentation here. This and other cases
>> (lots of per_cpu users, IIRC) actually want a migrate_disable() which
>> is a proper subset. We can simply implement migrate_disable() as
>> preempt_disable() for now and come back later and implement a proper
>> migrate_disable() that still allows preemption (and thus avoids the
>> latency).
>>     
>
> We could actually do this right now. migrate_disable() can be just changing
> the cpu affinity of the current thread to current cpu and then restoring it 
> afterwards. That should even work from interrupt context.
>
> get_cpu() etc. could be changed to use this then too.
>
>   

What if some other thread calls sched_setaffinity() on the 
migrate_disable()d cpu?  we'd need to detect this to avoid 
migrate_enable() stomping on sched_setaffinity()'s work.


-- 
error compiling committee.c: too many arguments to function

