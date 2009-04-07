Return-Path: <linux-kernel-owner+w=401wt.eu-S1758548AbZDGQ2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758548AbZDGQ2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 12:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758189AbZDGQ2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 12:28:05 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:59433 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757716AbZDGQ2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 12:28:03 -0400
Message-ID: <49DB7F09.8050900@linux.vnet.ibm.com>
Date: Tue, 07 Apr 2009 09:27:53 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] perf_counter: add more context information
References: <20090402091158.291810516@chello.nl> <20090402091319.493101305@chello.nl> <1238763023.798.27.camel@twins> <49D654AB.4030207@linux.vnet.ibm.com>  <1239015668.798.4243.camel@twins> <1239016035.798.4254.camel@twins>  <49DA4FA0.6090902@linux.vnet.ibm.com> <1239044818.798.4775.camel@twins>  <49DA6324.9080801@linux.vnet.ibm.com> <1239050799.4557.24.camel@laptop>  <49DA70F0.3020108@linux.vnet.ibm.com> <1239052864.4557.62.camel@laptop>  <49DA7526.2080504@linux.vnet.ibm.com> <1239088274.798.5524.camel@twins>
In-Reply-To: <1239088274.798.5524.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2009-04-06 at 14:33 -0700, Corey Ashford wrote:
>> Peter Zijlstra wrote:
>>> On Mon, 2009-04-06 at 14:15 -0700, Corey Ashford wrote:
>>>> Peter Zijlstra wrote:
>>>>> On Mon, 2009-04-06 at 13:16 -0700, Corey Ashford wrote:
>>>>>
>>>>>>>> One downside of this approach is that you if you specify "no header" 
>>>>>>>> (currently not possible, but maybe later?), you will not be able to get 
>>>>>>>> the level bits.
>>>>>>> Would this be desirable? 
>>>>>> I think it would.  For one use case I'm working on right now, simple 
>>>>>> profiling, all I need are ip's.  If I could omit the header, that would 
>>>>>> reduce the frequency of sigio's by a factor of three, and make it faster 
>>>>>> to read up the ip's when the SIGIO's occur.
>>>>> Self-profiling?
>>>>>
>>>>> So you're interested in getting the smallest possible record size, that
>>>>> would still be 2 u64, right? Otherwise you don't get the IP context that
>>>>> started this.
>>>>>
>>>>>
>>>> Self-profiling mainly, yes.  PAPI specs an ability for remote monitoring 
>>>> of processes and threads, but I think it's only partially implemented.
>>>>
>>>> So when you are talking about IP context, you mean pid/tid?
>>> Ah, we called it level before, the hv/kernel/user thing. For remote
>>> profiling you'd want to have the mmap thing too.
>> Oh I see.  In PAPI, the user specifies the range(s) of addresses he's 
>> interested in profiling (any sampled IP's outside the requested ranges 
>> are discarded), and so as long as the kernel space IP's don't overlap 
>> with user space IP's, we should be fine.
> 
> Ah, while this would be true for most 'sane' architectures, Paul was
> right in pointing out that this is not true for all architectures -- and
> we should therefore not rely on address range alone.
> 
> You could of course use: hw_event.exclude_{hv,kernel} = 1 to ensure you
> only get userspace thingies I suppose (but then you have no way of
> telling how many you missed I guess).

That's a good point.  PAPI's profiling API doesn't have a way for the 
caller to distinguish which address spaces (user/kernel/hv) he wants to 
profile.  It does have a way to designate which levels to ignore, but if 
you enable them all, you cannot specify the profiling address ranges 
pertaining to each.  That may be something I could propose adding to 
PAPI.  I suspect it would be pretty rarely used, though.

- Corey

