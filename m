Return-Path: <linux-kernel-owner+w=401wt.eu-S1758617AbZATIVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617AbZATIVK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 03:21:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754356AbZATIUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 03:20:55 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49819 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754175AbZATIUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 03:20:55 -0500
Message-ID: <49758937.5070300@cn.fujitsu.com>
Date: Tue, 20 Jan 2009 16:20:07 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Nick Piggin <npiggin@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
       Mike Travis <travis@sgi.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] kernel BUG at arch/x86/kernel/tlb_32.c:130!
References: <49756F44.6040801@cn.fujitsu.com> <20090120075440.GA29426@elte.hu> <20090120081759.GA30394@elte.hu>
In-Reply-To: <20090120081759.GA30394@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>> * Li Zefan <lizf@cn.fujitsu.com> wrote:
>>
>>> I was using mmotm 2009-01-16-16-18, and I ran into this BUG,
>>> the line is:
>>> 	BUG_ON(cpumask_empty(cpumask));
>>>
>>> I suspect it is caused by:
>>>
>>> commit 4595f9620cda8a1e973588e743cf5f8436dd20c6
>>> Author: Rusty Russell <rusty@rustcorp.com.au>
>>> Date:   Sat Jan 10 21:58:09 2009 -0800
>>>
>>>     x86: change flush_tlb_others to take a const struct cpumask
>>>
>>>     Impact: reduce stack usage, use new cpumask API.
>> Jaswinder reported a similar crash.
>>
>> Mike, Rusty, what's going on with this commit? Why does this code:
>>
>> +       if (cpumask_any_but(&mm->cpu_vm_mask, smp_processor_id()) < nr_cpu_ids)
>> +               flush_tlb_others(&mm->cpu_vm_mask, mm, TLB_FLUSH_ALL);
>>
>> Assume that mm->cpu_vm_mask wont change? TLB flushes go async and the 
>> MM's schedulability is not locked during that. I.e. mm->cpu_vm_mask can 
>> change under you while the TLB flush IPIs are flying around - while when 
>> the cpumask was passed on-stack this wouldnt happen.
> 
> okay, a testsystem of mine just triggered this crash too.
> 
> Li Zefan, Jaswinder, does the patch below fix it for you?
> 

I'll test it, but I have to run for several hours to confirm it, since
the bug is not easy to trigger. :)

