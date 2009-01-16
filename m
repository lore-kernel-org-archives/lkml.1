Return-Path: <linux-kernel-owner+w=401wt.eu-S936430AbZAPSBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936430AbZAPSBw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 13:01:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761089AbZAPSBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 13:01:43 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:46761 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754302AbZAPSBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 13:01:42 -0500
Message-ID: <4970CB6F.9000301@linux.vnet.ibm.com>
Date: Fri, 16 Jan 2009 10:01:19 -0800
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Paul Mackerras <paulus@samba.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       "David S. Miller" <davem@davemloft.net>,
       perfctr-devel@lists.sourceforge.net, maynardj@us.ibm.com
Subject: Re: [patch] Performance Counters for Linux, v4
References: <20081214212829.GA9435@elte.hu> <18758.18810.350923.806445@cargo.ozlabs.ibm.com> <1229437341.7025.11.camel@twins> <18760.13407.568536.198724@cargo.ozlabs.ibm.com> <87ljuf1s75.fsf@basil.nowhere.org>
In-Reply-To: <87ljuf1s75.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Paul Mackerras <paulus@samba.org> writes:
>> The perf counter subsystem will, in Ingo's design, naturally try to
>> schedule as many counters and groups on as it can.  Given a list of
>> counters/groups, it could start with the first and keep on trying to
>> add counters or groups while it can, essentially trying all possible
>> combinations until it either fills up all the hardware counters or
>> exhausts the possible combinations.  If it moves all the
>> counters/groups that do fit on up to the head of the list, and then
>> rotates them to the back of the list when the timeslice expires, that
>> would probably be OK.  In fact the computation about what set of
>> counters/groups to put on should be done when adding/removing a
>> counter/group and when the timeslice expires, rather than at context
>> switch time.  (I'm talking about the list of part-time counters/groups
>> here, of course.)
> 
> One issue is that PMU counts can cover more than one CPU. One example
> for this are the Uncore events on Nehalem (which cover a whole socket)
> or when you are in AnyThreads monitoring mode (then you get events
> from both SMT siblings in a core)
> 
> With that you would need to examine other CPU's state at context switch
> time. Probably not a good idea for scalability.
> 
> -Andi
> 

Over time, it seems clear that we will see multi-core processor designs 
with increasingly large uncore/nest facilities, so this could become 
more and more of an issue.

- Corey

Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain
Beaverton, OR
503-578-3507
cjashfor@us.ibm.com

