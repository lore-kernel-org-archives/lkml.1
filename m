Return-Path: <linux-kernel-owner+w=401wt.eu-S947014AbXHMPAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S947014AbXHMPAi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 11:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S944857AbXHMMfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 08:35:30 -0400
Received: from il.qumranet.com ([82.166.9.18]:39368 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S945411AbXHMMfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 08:35:25 -0400
Message-ID: <46C05017.3050806@qumranet.com>
Date: Mon, 13 Aug 2007 15:35:35 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Paolo Ornati <ornati@fastwebnet.it>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kvm-devel@lists.sourceforge.net
Subject: Re: WARNING: at arch/x86_64/kernel/smp.c:379 smp_call_function_single()
References: <20070810134140.2806b587@localhost>	<6bffcb0e0708100504n7fbafb5bt6a35165277dc767a@mail.gmail.com> <20070813134237.23f4b5a1@localhost>
In-Reply-To: <20070813134237.23f4b5a1@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Ornati wrote:
> On Fri, 10 Aug 2007 14:04:33 +0200
> "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com> wrote:
>
>   
>>> [  756.707601] Disabling non-boot CPUs ...
>>> [  756.712034] kvm: disabling virtualization on CPU1
>>> [  756.712037] WARNING: at arch/x86_64/kernel/smp.c:379 smp_call_function_single()
>>> [  756.712039]
>>> [  756.712039] Call Trace:
>>> [  756.712046]  [<ffffffff8021d159>] smp_call_function_single+0x119/0x120
>>> [  756.712050]  [<ffffffff80542169>] thread_return+0x1bf/0x626
>>> [  756.712054]  [<ffffffff80234b5b>] sys_sched_yield+0x2b/0x80
>>> [  756.712057]  [<ffffffff8043684b>] kvm_cpu_hotplug+0x4b/0xa0
>>> [  756.712060]  [<ffffffff80247c83>] notifier_call_chain+0x53/0x80
>>> [  756.712062]  [<ffffffff80247d09>] __raw_notifier_call_chain+0x9/0x10
>>> [  756.712065]  [<ffffffff80247d21>] raw_notifier_call_chain+0x11/0x20
>>> [  756.712068]  [<ffffffff8026184b>] take_cpu_down+0x1b/0x30
>>> [  756.712071]  [<ffffffff802699d2>] do_stop+0xd2/0x150
>>> [  756.712073]  [<ffffffff80269900>] do_stop+0x0/0x150
>>> [  756.712076]  [<ffffffff8024f84d>] kthread+0x4d/0x80
>>> [  756.712079]  [<ffffffff8020cb28>] child_rip+0xa/0x12
>>> [  756.712081]  [<ffffffff8020c23c>] restore_args+0x0/0x30
>>> [  756.712084]  [<ffffffff8024f800>] kthread+0x0/0x80
>>> [  756.712086]  [<ffffffff8020cb1e>] child_rip+0x0/0x12
>>> [  756.712087]
>>> [  756.815693] CPU 1 is now offline
>>> [  756.815697] lockdep: not fixing up alternatives.
>>> [  756.819276] CPU1 is down
>>>  
>>>       
>> Added to KR list, thanks for the report.
>>     
>
>
> I've bisected it down to this commit:
>
> cec9ad279b66793bee0b5009b7ca311060061efd
>
>     KVM: Use CPU_DYING for disabling virtualization
>     
>     Only at the CPU_DYING stage can we be sure that no user process will
>     be scheduled onto the cpu and oops when trying to use virtualization
>     extensions.
>
>   

Thanks.  I'll have a go at it.


-- 
error compiling committee.c: too many arguments to function

