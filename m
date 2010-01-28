Return-Path: <linux-kernel-owner+w=401wt.eu-S1754914Ab0A1Wjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab0A1Wjd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 17:39:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750801Ab0A1Wjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 17:39:33 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37411 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754246Ab0A1Wjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 17:39:32 -0500
Message-ID: <4B621213.2010805@austin.ibm.com>
Date: Thu, 28 Jan 2010 16:39:15 -0600
From: Joel Schopp <jschopp@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, ego@in.ibm.com,
       linuxppc-dev@lists.ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/2] powerpc: implement arch_scale_smt_power for Power7
References: <1264017638.5717.121.camel@jschopp-laptop>	 <1264017847.5717.132.camel@jschopp-laptop>	 <1264548495.12239.56.camel@jschopp-laptop> <1264553577.3601.144.camel@pasglop>
In-Reply-To: <1264553577.3601.144.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>
> What about an early exit if !cpu_has_feature(CPU_FTR_SMT) ? That would
> de-facto compile it out for 32-bit CPU platforms that don't support SMT
> at all and avoid some overhead on POWER3,4,970...
>   
If the SD_SHARE_CPUPOWER flag isn't set for the sched domain this 
function isn't called.  So an extra check here is wasteful.
>   
>> +	unsigned long weight = cpumask_weight(sibling_map);
>> +	unsigned long smt_gain = sd->smt_gain;
>> +
>> +	if (cpu_has_feature(CPU_FTR_ASYNC_SMT4) && weight == 4) {
>>     
>
> So that will only handle the case where all 4 threads are online right ?
> There is no provision for the case where the user play tricks like
> offlining thread, in which case it will stop trying to "push down"
> processes right ? Not a big deal per-se I suppose, just something to be
> aware of.
>   
I've tested it with manually offlined threads and it behaves as I'd like 
it to.
> Also, can you add a comment as to why this is done in the code itself ?
> above the if (cpu_has_feature(...)) statement.
>   
OK. v3 coming soon with the comment.
