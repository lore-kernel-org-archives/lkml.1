Return-Path: <linux-kernel-owner+w=401wt.eu-S1756001AbXIDXSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001AbXIDXSP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 19:18:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754568AbXIDXSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 19:18:00 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56115 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754290AbXIDXR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 19:17:59 -0400
Message-ID: <46DDE623.1090402@sgi.com>
Date: Tue, 04 Sep 2007 16:11:31 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: clameter@sgi.com, steiner@sgi.com, ak@suse.de, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, kamalesh@linux.vnet.ibm.com
Subject: Re: [PATCH 3/6] x86: Convert cpu_sibling_map to be a per cpu variable
 (v2) (fwd)
References: <Pine.LNX.4.64.0708312028400.24049@schroedinger.engr.sgi.com>	<46DDC017.4040301@sgi.com> <20070904141055.e00a60d7.akpm@linux-foundation.org>
In-Reply-To: <20070904141055.e00a60d7.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Andrew Morton wrote:
>> On Tue, 04 Sep 2007 13:29:11 -0700 Mike Travis <travis@sgi.com> wrote:

>>> ---------- Forwarded message ----------
>>> Date: Fri, 31 Aug 2007 19:49:03 -0700
>>> From: Andrew Morton <akpm@linux-foundation.org>
>>> To: travis@sgi.com
>>> Cc: Andi Kleen <ak@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
>>>     Christoph Lameter <clameter@sgi.com>
>>> Subject: Re: [PATCH 3/6] x86: Convert cpu_sibling_map to be a per cpu variable
>>>     (v2)
>>>
>>> On Fri, 24 Aug 2007 15:26:57 -0700 travis@sgi.com wrote:
>>>
>>>> Convert cpu_sibling_map from a static array sized by NR_CPUS to a
>>>> per_cpu variable.  This saves sizeof(cpumask_t) * NR unused cpus.
>>>> Access is mostly from startup and CPU HOTPLUG functions.
>>> ia64 allmodconfig:
>>>
>>> kernel/sched.c: In function `cpu_to_phys_group':                                                                             kernel/sched.c:5937: error: `per_cpu__cpu_sibling_map' undeclared (first use in this function)                               kernel/sched.c:5937: error: (Each undeclared identifier is reported only once
>>> kernel/sched.c:5937: error: for each function it appears in.)                                                                kernel/sched.c:5937: warning: type defaults to `int' in declaration of `type name'
>>> kernel/sched.c:5937: error: invalid type argument of `unary *'                                                               kernel/sched.c: In function `build_sched_domains':                                                                           kernel/sched.c:6172: error: `per_cpu__cpu_sibling_map' undeclared (first use in this function)                               kernel/sched.c:6172: warning: type defaults to `int' in declaration of `type name'                                           kernel/sched.c:6172: error: invalid type argument of `unary *'                                                               kernel/sched.c:6183: warning: type defaults to `int' in declaration of `type name'                                           kernel/sched.c:6183: error: invalid type argument of `unary *'                                                               
>> I'm thinking that the best approach would be to define a cpu_sibling_map() macro
>> to handle the cases where cpu_sibling_map is not a per_cpu variable?  Perhaps
>> something like:
>>
>> #ifdef CONFIG_SCHED_SMT
>> #ifndef cpu_sibling_map
>> #define cpu_sibling_map(cpu)    cpu_sibling_map[cpu]
>> #endif
>> #endif
>>
>> My question though, would include/linux/smp.h be the appropriate place for
>> the above define?  (That is, if the above approach is the correct one... ;-)
> 
> It'd be better to convert the unconverted architectures?

I can easily do the changes for ia64 and test them.  I don't have the capability
of testing on the powerpc.  

And are you asking for just the changes to fix the build problem, or the whole
set of the changes that were made for x86_64 and i386 in regards to converting
NR_CPU arrays to per cpu data?

Thanks,
Mike
