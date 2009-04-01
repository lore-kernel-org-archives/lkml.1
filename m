Return-Path: <linux-kernel-owner+w=401wt.eu-S936052AbZDAXad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936052AbZDAXad (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 19:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935681AbZDAXZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 19:25:33 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:46149 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935124AbZDAXZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 19:25:29 -0400
Message-ID: <49D3F7E4.7010308@linux.vnet.ibm.com>
Date: Wed, 01 Apr 2009 16:25:24 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/15] perf_counter: provide generic callchain bits
References: <20090330170701.856843742@chello.nl> <20090330171024.254266860@chello.nl> <18897.46177.528910.51044@cargo.ozlabs.ibm.com> <1238481552.28248.1384.camel@twins> <49D1C544.7020403@linux.vnet.ibm.com> <18897.56973.324304.995540@cargo.ozlabs.ibm.com> <1238508032.8530.278.camel@twins> <18898.58399.957182.181124@drongo.ozlabs.ibm.com> <1238572744.8530.2541.camel@twins>
In-Reply-To: <1238572744.8530.2541.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Wed, 2009-04-01 at 14:48 +1100, Paul Mackerras wrote:
>> Peter Zijlstra writes:
>>
>>> That still has the record and read things separate, but as one unified
>>> overflow output.
>> I take it PERF_EVENT_OVERFLOW refers to counter overflow, not ring
>> buffer overflow?  That had me confused for a bit, so more explicit
>> naming, or at least some comments, would be good.
> 
> Ah, yes, I see how that can confuse. PERF_EVENT_COUNTER_OVERFLOW then?
> 
> I was thinking about doing splice() support and that could also generate
> actual event overflow events ;-)
> 
>>>  /*
>>> + * Bits that can be set in hw_event.record_type to request information
>>> + * in the overflow packets.
>>> + */
>>> +enum perf_counter_record_format {
>>> +	PERF_RECORD_IP		= 1U << 0,
>>> +	PERF_RECORD_TID		= 1U << 1,
>>> +	PERF_RECORD_GROUP	= 1U << 2,
>>> +	PERF_RECORD_CALLCHAIN	= 1U << 3,
>>> +};
>> [snip]
>>>  enum perf_event_type {
>>>  
>>> -	PERF_EVENT_GROUP	= 1,
>>> -
>>> -	PERF_EVENT_MMAP		= 2,
>>> -	PERF_EVENT_MUNMAP	= 3,
>>> +	PERF_EVENT_MMAP		= 1,
>>> +	PERF_EVENT_MUNMAP	= 2,
>>>  
>>>  	PERF_EVENT_OVERFLOW	= 1UL << 31,
>>>  	__PERF_EVENT_IP		= 1UL << 30,
>>>  	__PERF_EVENT_TID	= 1UL << 29,
>>> -	__PERF_EVENT_CALLCHAIN  = 1UL << 28,
>>> +	__PERF_EVENT_GROUP	= 1UL << 28,
>>> +	__PERF_EVENT_CALLCHAIN  = 1UL << 27,
>> Could we use the same value (and even the same name) for
>> PERF_RECORD_IP/__PERF_EVENT_IP, PERF_RECORD_TID/__PERF_EVENT_TID,
>> etc.?
> 
> I suppose we could.
> 
>> Also, I haven't looked at the callchain stuff much, but does the
>> callchain info contain a recognizable end delimiter?  At present the
>> callchain comes last, but if we add more output elements they'll
>> presumably go after it, so working out where the callchain ends may
>> become tricky if we're not careful.
> 
> It writes:
> 
> struct callchain_event {
> 	u64 nr
> 	u64 ips[nr]
> };

Looking at the current version of perf_counter.h in the -tip tree, this 
struct definition is not visible to userspace (it's in the #ifdef KERNEL 
section).

- Corey

