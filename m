Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab0CEKoR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 05:44:17 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:55722 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028Ab0CEKoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 05:44:14 -0500
Message-ID: <4B90E07A.5090302@in.ibm.com>
Date: Fri, 05 Mar 2010 16:14:10 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: -next March 3: Boot failure on x86 (Oops)
References: <20100303174603.5be197ba.sfr@canb.auug.org.au> <4B8E83D4.6090507@in.ibm.com> <4B8F0CD0.1040507@kernel.org> <4B8F43DD.10002@in.ibm.com> <4B909FC5.8020800@kernel.org> <4B90A031.8090306@kernel.org>
In-Reply-To: <4B90A031.8090306@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> On 03/05/2010 03:08 PM, Tejun Heo wrote:
>   
>> Hmmm... this means that on one of the chunks, chunk->list.next was
>> NULL (BTW, the disassembly is from unlinked object, right?).  The main
>> allocation code hasn't seen much change lately.  The only changes are,
>>
>> 22b737f4c75197372d64afc6ed1bccd58c00e549 : just refactoring
>> 833af8427be4b217b5bc522f61afdbd3f1d282c2 : possible but isn't very new
>>     
>
> Can you also please try reverting the above two commits?
>
> Thanks.
>
>   
Reverting both the commits allows the machine to boot.
If i just apply 22b737f4c75197372d64afc6ed1bccd58c00e549 the
box fails to boot with following kobject related traces:

registered taskstats version 1
kobject '' (c11d5fdc): tried to add an uninitialized object, something is seriously wrong.
Pid: 1, comm: swapper Not tainted 2.6.33-autotest-next-20100305 #3
Call Trace:
 [<c03a7678>] ? printk+0xf/0x17
 [<c028766f>] kobject_add+0x28/0x49
 [<c05a1a8e>] memmap_init+0x4f/0x89
 [<c05a1a3f>] ? memmap_init+0x0/0x89
 [<c0101139>] do_one_initcall+0x4c/0x131
 [<c057b352>] kernel_init+0x127/0x1a8
 [<c057b22b>] ? kernel_init+0x0/0x1a8
 [<c0102db6>] kernel_thread_helper+0x6/0x10
------------[ cut here ]------------
WARNING: at lib/kobject.c:595 kobject_put+0x27/0x3c()
Hardware name: eserver xSeries 235 -[86717AX]-
kobject: '' (c11d5fdc): is not initialized, yet kobject_put() is being called.
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.33-autotest-next-20100305 #3
Call Trace:
 [<c012fe66>] warn_slowpath_common+0x60/0x90
 [<c012feca>] warn_slowpath_fmt+0x24/0x27
 [<c02872c6>] kobject_put+0x27/0x3c
 [<c05a1a9c>] memmap_init+0x5d/0x89
 [<c05a1a3f>] ? memmap_init+0x0/0x89
 [<c0101139>] do_one_initcall+0x4c/0x131
 [<c057b352>] kernel_init+0x127/0x1a8
 [<c057b22b>] ? kernel_init+0x0/0x1a8
 [<c0102db6>] kernel_thread_helper+0x6/0x10
---[ end trace 7b6574301a0037c2 ]---

The results are with today's next, but i think same applies to Linus
tree as well.

Thanks
-Sachin



-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

