Return-Path: <linux-kernel-owner+w=401wt.eu-S1754891AbYILORT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbYILORT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 10:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbYILORK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 10:17:10 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55707 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752685AbYILORJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 10:17:09 -0400
Message-ID: <48CA79E4.4080101@sgi.com>
Date: Fri, 12 Sep 2008 07:17:08 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jack Steiner <steiner@sgi.com>, Jes Sorensen <jes@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] cpumask: add for_each_online_cpu_mask_nr function
References: <20080909155013.455071000@polaris-admin.engr.sgi.com> <20080909155013.735125000@polaris-admin.engr.sgi.com> <200809121433.23593.rusty@rustcorp.com.au>
In-Reply-To: <200809121433.23593.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Wednesday 10 September 2008 01:50:14 Mike Travis wrote:
>>   * Add for_each_online_cpu_mask_nr() function to eliminate need for
>>     a common use of a temporary cpumask_t variable.  When the following
>>     procedure is being used:
>>
>>     funcproto(cpumask_t *mask, ...)
>>     {
>> 	cpumask_t temp;
>>
>> 	cpus_and(temp, *mask, cpu_online_map);
>> 	for_each_cpu_mask_nr(cpu, temp)
>> 		...
>>
>>     If then becomes:
>>
>>     funcproto(cpumask_t *mask, ...)
>>     {
>> 	for_each_online_cpu_mask_nr(cpu, *mask)
>> 		...
>>
>>   * Note the generic __next_cpu_and (and __next_cpu_and_nr) functions
>>     allowing AND'ing with any cpumask_t variable, not just the
>> cpu_online_map.
> 
> Good idea!  But I really dislike the _nr versions (too many names!).  Do we 
> really need them, since by definition cpus after nr_cpu_ids are never 
> online...
> 
> (And we should initialize nr_cpu_ids to NR_CPUS so even early boot works, if 
> we don't already...).
> 
> Cheers,
> Rusty.

Yes, the only reason the _nr is there is to be consistent with the
current for_each_cpu_mask{,_nr} functions.  What I'd like to do is
convert all calls to use the nr_cpu_ids and if there's some reason
to need to iterate over NR_CPUS range, then you'd use FOR_EACH_CPU_MASK.

And yes, nr_cpu_ids is init'd to NR_CPUS.

Thanks,
Mike
