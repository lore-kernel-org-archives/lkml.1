Return-Path: <linux-kernel-owner+w=401wt.eu-S1752255AbZFEEuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbZFEEuG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 00:50:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750876AbZFEEtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 00:49:51 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:41361 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783AbZFEEtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 00:49:51 -0400
Date: Fri, 5 Jun 2009 12:49:46 +0800
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
Message-ID: <20090605044946.GA11755@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090604053649.GA3701@in.ibm.com> <4A27BBCA.5020606@redhat.com> <20090605030309.GA3872@in.ibm.com> <4A28921C.6010802@redhat.com> <661de9470906042137u603e2997n80c270bf7f6191ad@mail.gmail.com> <4A28A2AB.3060108@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4A28A2AB.3060108@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Avi Kivity <avi@redhat.com> [2009-06-05 07:44:27]:

> Balbir Singh wrote:
>> On Fri, Jun 5, 2009 at 11:33 AM, Avi Kivity <avi@redhat.com> wrote:
>>   
>>> Bharata B Rao wrote:
>>>     
>>>>> Another way is to place the 8 groups in a container group, and limit
>>>>>  that to 80%. But that doesn't work if I want to provide guarantees to
>>>>>  several groups.
>>>>>
>>>>>         
>>>> Hmm why not ? Reduce the guarantee of the container group and provide
>>>> the same to additional groups ?
>>>>
>>>>       
>>> This method produces suboptimal results:
>>>
>>> $ cgroup-limits 10 10 0
>>> [50.0, 50.0, 40.0]
>>>
>>> I want to provide two 10% guaranteed groups and one best-effort group.
>>>  Using the limits method, no group can now use more than 50% of the
>>> resources.  However, having the first group use 90% of the resources does
>>> not violate any guarantees, but it not allowed by the solution.
>>>
>>>     
>>
>> How, it works out fine in my calculation
>>
>> 50 + 40 for G2 and G3, make sure that G1 gets 10%, since others are
>> limited to 90%
>> 50 + 40 for G1 and G3, make sure that G2 gets 10%, since others are
>> limited to 90%
>> 50 + 50 for G1 and G2, make sure that G3 gets 0%, since others are
>> limited to 100%
>>   
>
> It's fine in that it satisfies the guarantees, but it is deeply  
> suboptimal.  If I ran a cpu hog in the first group, while the other two  
> were idle, it would be limited to 50% cpu.  On the other hand, if it  
> consumed all 100% cpu it would still satisfy the guarantees (as the  
> other groups are idle).
>
> The result is that in such a situation, wall clock time would double  
> even though cpu resources are available.

But then there is no other way to make a *guarantee*, guarantees come
at a cost of idling resources, no? Can you show me any other
combination that will provide the guarantee and without idling the
system for the specified guarantees?


>> Now if we really have zeros, I would recommend using
>>
>> cgroup-limits 10 10 and you'll see that you'll get 90, 90 as output.
>>
>> Adding zeros to the calcuation is not recommended. Does that help?
>
> What do you mean, it is not recommended? I have two groups which need at  
> least 10% and one which does not need any guarantee, how do I express it?
>
Ignore this part of my comment

> In any case, changing the zero to 1% does not materially change the results.

True.

-- 
	Balbir
