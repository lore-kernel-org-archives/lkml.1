Return-Path: <linux-kernel-owner+w=401wt.eu-S1753841AbZFEGDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbZFEGDs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 02:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750813AbZFEGDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 02:03:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45182 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701AbZFEGDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 02:03:38 -0400
Message-ID: <4A28B4CE.4010004@redhat.com>
Date: Fri, 05 Jun 2009 09:01:50 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: bharata@linux.vnet.ibm.com
CC: Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>, kvm@vger.kernel.org,
       Linux Containers <containers@lists.linux-foundation.org>,
       Herbert Poetzl <herbert@13thfloor.at>
Subject: Re: [RFC] CPU hard limits
References: <20090604053649.GA3701@in.ibm.com> <4A27BBCA.5020606@redhat.com> <20090605030309.GA3872@in.ibm.com> <4A28921C.6010802@redhat.com> <661de9470906042137u603e2997n80c270bf7f6191ad@mail.gmail.com> <4A28A2AB.3060108@redhat.com> <20090605044946.GA11755@balbir.in.ibm.com> <20090605051050.GB11755@balbir.in.ibm.com> <4A28AB67.7040800@redhat.com> <20090605052755.GE11755@balbir.in.ibm.com> <20090605053159.GB3872@in.ibm.com>
In-Reply-To: <20090605053159.GB3872@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bharata B Rao wrote:
> On Fri, Jun 05, 2009 at 01:27:55PM +0800, Balbir Singh wrote:
>   
>> * Avi Kivity <avi@redhat.com> [2009-06-05 08:21:43]:
>>
>>     
>>> Balbir Singh wrote:
>>>       
>>>>> But then there is no other way to make a *guarantee*, guarantees come
>>>>> at a cost of idling resources, no? Can you show me any other
>>>>> combination that will provide the guarantee and without idling the
>>>>> system for the specified guarantees?
>>>>>     
>>>>>           
>>>> OK, I see part of your concern, but I think we could do some
>>>> optimizations during design. For example if all groups have reached
>>>> their hard-limit and the system is idle, should we do start a new hard
>>>> limit interval and restart, so that idleness can be removed. Would
>>>> that be an acceptable design point?
>>>>         
>>> I think so.  Given guarantees G1..Gn (0 <= Gi <= 1; sum(Gi) <= 1), and a  
>>> cpu hog running in each group, how would the algorithm divide resources?
>>>
>>>       
>> As per the matrix calculation, but as soon as we reach an idle point,
>> we redistribute the b/w and start a new quantum so to speak, where all
>> groups are charged up to their hard limits.
>>     
>
> But could there be client models where you are required to strictly
> adhere to the limit within the bandwidth and not provide more (by advancing
> the bandwidth period) in the presence of idle cycles ?
>   

That's the limit part.  I'd like to be able to specify limits and 
guarantees on the same host and for the same groups; I don't think that 
works when you advance the bandwidth period.

I think we need to treat guarantees as first-class goals, not something 
derived from limits (in fact I think guarantees are more useful as they 
can be used to provide SLAs).

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

