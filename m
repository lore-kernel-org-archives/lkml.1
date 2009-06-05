Return-Path: <linux-kernel-owner+w=401wt.eu-S1755441AbZFEFUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbZFEFUc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 01:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751032AbZFEFUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 01:20:23 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:45207 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbZFEFUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 01:20:22 -0400
Date: Fri, 5 Jun 2009 13:20:14 +0800
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: bharata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>, kvm@vger.kernel.org,
       Linux Containers <containers@lists.linux-foundation.org>,
       Herbert Poetzl <herbert@13thfloor.at>
Subject: Re: [RFC] CPU hard limits
Message-ID: <20090605052014.GD11755@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090604053649.GA3701@in.ibm.com> <4A27BBCA.5020606@redhat.com> <20090605030309.GA3872@in.ibm.com> <4A28921C.6010802@redhat.com> <661de9470906042137u603e2997n80c270bf7f6191ad@mail.gmail.com> <4A28A2AB.3060108@redhat.com> <20090605044946.GA11755@balbir.in.ibm.com> <4A28AA25.4050206@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4A28AA25.4050206@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Avi Kivity <avi@redhat.com> [2009-06-05 08:16:21]:

> Balbir Singh wrote:
>
>    
>
>>>> How, it works out fine in my calculation
>>>>
>>>> 50 + 40 for G2 and G3, make sure that G1 gets 10%, since others are
>>>> limited to 90%
>>>> 50 + 40 for G1 and G3, make sure that G2 gets 10%, since others are
>>>> limited to 90%
>>>> 50 + 50 for G1 and G2, make sure that G3 gets 0%, since others are
>>>> limited to 100%
>>>>         
>>> It's fine in that it satisfies the guarantees, but it is deeply   
>>> suboptimal.  If I ran a cpu hog in the first group, while the other 
>>> two  were idle, it would be limited to 50% cpu.  On the other hand, 
>>> if it  consumed all 100% cpu it would still satisfy the guarantees 
>>> (as the  other groups are idle).
>>>
>>> The result is that in such a situation, wall clock time would double  
>>> even though cpu resources are available.
>>>     
>>
>> But then there is no other way to make a *guarantee*, guarantees come
>> at a cost of idling resources, no? Can you show me any other
>> combination that will provide the guarantee and without idling the
>> system for the specified guarantees?
>>   
>
> Suppose in my example cgroup 1 consumed 100% of the cpu resources and  
> cgroup 2 and 3 were completely idle.  All of the guarantees are met (if  
> cgroup 2 is idle, there's no need to give it the 10% cpu time it is  
> guaranteed).
>
> If  your only tool to achieve the guarantees is a limit system, then  
> yes, the equation yields the correct results.  But given that it yields  
> such inferior results, I think we need to look for a more involved 
> solution.
>
> I think the limits method fits cases where it is difficult to evict a  
> resource (say, disk quotas -- if you want to guarantee 10% of space to  
> cgroups 1, you must limit all others to 90%).  But for processor usage,  
> you can evict a cgroup instantly, so nothing prevents a cgroup from  
> consuming all available resources as long as others do not contend for 
> them.

Avi,

Could you look at my newer email and comment, where I've mentioned
that I see your concern and discussed a design point. We could
probably take this discussion forward from there?

-- 
	Balbir
