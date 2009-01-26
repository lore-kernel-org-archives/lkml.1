Return-Path: <linux-kernel-owner+w=401wt.eu-S1754312AbZAZTOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbZAZTOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 14:14:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753942AbZAZTNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 14:13:36 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:34952 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753827AbZAZTNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 14:13:35 -0500
Message-ID: <497E0B55.4050408@linux.vnet.ibm.com>
Date: Mon, 26 Jan 2009 11:13:25 -0800
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: eranian@gmail.com, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>, Mike Galbraith <efault@gmx.de>,
       "perfmon2-devel@lists.sourceforge.net" 
	<perfmon2-devel@lists.sourceforge.net>,
       Papi <ptools-perfapi@cs.utk.edu>
Subject: Re: [announce] Performance Counters for Linux, v6
References: <20090121185021.GA8852@elte.hu> <497D0C81.5040406@linux.vnet.ibm.com> <7c86c4470901260113r4db6b15cpa0fa88ab3f8a516c@mail.gmail.com> <20090126151746.GH9128@elte.hu>
In-Reply-To: <20090126151746.GH9128@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * stephane eranian <eranian@googlemail.com> wrote:
> 
>> Hi,
>>
>> Corey brings up an interesting problem which I wanted to comment on.
>>
>> The current proposal hinges on the idea that by interpreting a single 
>> value the kernel can understand what the user wants to measure. For 
>> instance, if I pass type=0, then the kernel understands I want to 
>> measure CPU_CYCLES. Given that the number of events and their unit mask 
>> combinations can be large, the proposal also provides a "raw" mode, 
>> where the content of the type field is interpreted as the raw value to 
>> put into a register.
>>
>> This is where there is an issue because with several PMU models, 
>> including on X86, using the raw bit + 64 value is not enough to figure 
>> out what the user wants to measure. This happens when the PMU has more 
>> than counters. Thus, interpreting each raw value has the event code may 
>> be wrong. To remain on familiar territory, the Nehalem uncore PMU has an 
>> opcode matcher register, that uses a 64-bit value. On AMD64 Family 10h, 
>> you have IBS. But I could give examples on Itanium with opcode matchers, 
>> range restrictions. Corey provided other examples for Power. The API has 
>> to provide a way to express what the raw value is meant for: counter, 
>> matcher, filter...
> 
> this can be done in a number of ways (in order of increasing levels of 
> abstraction):
> 
> - the raw type is kept wide enough. Paul already requested the raw type
>   to be widened to 128 bits to express certain PowerPC features.
> 
> - or the PMU capability is expressed as a special counter type (if it's
>   useful enough) - and then either the write() method or ioctl is extended
>   to express attributes we want to set/change while a counter is running.
> 
> - or the highest level counter / hw event data type is extended with new
>   attribute field(s).
> 
> My feeling is that we generally want such hw features to start small - 
> i.e. at the raw type level initially. Then we can allow them to climb the 
> ladder, if they prove their utility in practice. We've got space reserved 
> in the ABI to allow for growth like this.
> 
> 	Ingo


Hi Ingo and Stephane,

Thanks for the replies.

I think any one of those solutions would work for Power's Instruction 
Matching Register.  If more than one register needs to be programmed, or 
the values don't fit into the 128-bit raw event types, we could use the 
"special counter" approach, I think.

I will have another look at the Power PMU description and see if there 
are other constraints that might cause us to want to go one way or the 
other, or perhaps a different way.

Regards,

- Corey

Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain
Beaverton, OR
503-578-3507
cjashfor@us.ibm.com


