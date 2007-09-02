Return-Path: <linux-kernel-owner+w=401wt.eu-S965688AbXIBLsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965688AbXIBLsq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 07:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965136AbXIBLsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 07:48:39 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:57751 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965152AbXIBLsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 07:48:38 -0400
Message-ID: <46DAA310.1030309@linux.vnet.ibm.com>
Date: Sun, 02 Sep 2007 17:18:32 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: travis@sgi.com, ak@suse.de, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, clameter@sgi.com
Subject: Re: [PATCH 3/6] x86: Convert cpu_sibling_map to be a per cpu variable
 (v2)
References: <20070824222654.687510000@sgi.com> <20070824222948.851896000@sgi.com> <20070831194903.5d88a007.akpm@linux-foundation.org> <46D94E2E.5030605@linux.vnet.ibm.com> <20070901091040.a55afd28.akpm@linux-foundation.org>
In-Reply-To: <20070901091040.a55afd28.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> On Sat, 01 Sep 2007 17:04:06 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
>> Andrew Morton wrote:
>>     
>>> On Fri, 24 Aug 2007 15:26:57 -0700 travis@sgi.com wrote:
>>>
>>>   
>>>       
>>>> Convert cpu_sibling_map from a static array sized by NR_CPUS to a
>>>> per_cpu variable.  This saves sizeof(cpumask_t) * NR unused cpus.
>>>> Access is mostly from startup and CPU HOTPLUG functions.
>>>>     
>>>>         
>>> ia64 allmodconfig:
>>>
>>> kernel/sched.c: In function `cpu_to_phys_group':                                                                             kernel/sched.c:5937: error: `per_cpu__cpu_sibling_map' undeclared (first use in this function)                               kernel/sched.c:5937: error: (Each undeclared identifier is reported only once
>>> kernel/sched.c:5937: error: for each function it appears in.)                                                                kernel/sched.c:5937: warning: type defaults to `int' in declaration of `type name'
>>> kernel/sched.c:5937: error: invalid type argument of `unary *'                                                               kernel/sched.c: In function `build_sched_domains':                                                                           kernel/sched.c:6172: error: `per_cpu__cpu_sibling_map' undeclared (first use in this function)                               kernel/sched.c:6172: warning: type defaults to `int' in declaration of `type name'                                           kernel/sched.c:6172: error: invalid type argument of `unary *'                                                               kernel/sched.c:6183: warning: type defaults to `int' in declaration of `type name'                                           kernel/sched.c:6183: error: invalid type argument of `unary *'                                                               
>>> -
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>
>>>
>>>   
>>>       
>> Hi Andrew,
>>
>> I get the exact build failure on ppc64 machine with 2.6.23-rc4-mm1.
>>
>>     
>
> The ia64 workaround was to disable SCHED_SMT.
>   
Hi Andrew,

Same workaround works with ppc64 also.

Thanks & Regards,
Kamalesh Babulal.
