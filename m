Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbYIKAUD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbYIKAUD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 20:20:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbYIKATx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 20:19:53 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:23665 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbYIKATw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 20:19:52 -0400
Message-ID: <48C86427.7060508@ct.jp.nec.com>
Date: Wed, 10 Sep 2008 17:19:51 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: ronne@list.ru, mingo@elte.hu
Cc: rml@tech9.net, linux-kernel@vger.kernel.org
Subject: Re: deadlock in setting schedule parameters
References: <48C838F9.1050607@list.ru> <48C85F93.9020602@ct.jp.nec.com>
In-Reply-To: <48C85F93.9020602@ct.jp.nec.com>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hiroshi Shimamoto wrote:
> Andrei Gusev wrote:
>> Hello!
>>
>> I played witch scheduler settings. After doing something like:
>> echo -n 1000000 >sched_rt_period_us
>>
>> command is looked. I found in kernel.log
>> Sep 11 00:39:34 zaratustra
>> Sep 11 00:39:34 zaratustra Pid: 4495, comm: bash Tainted: G        W 
>> (2.6.26.3 #12)
>> Sep 11 00:39:34 zaratustra EIP: 0060:[<c0213fc7>] EFLAGS: 00210246 CPU: 0
>> Sep 11 00:39:34 zaratustra EIP is at div64_u64+0x57/0x80
>> Sep 11 00:39:34 zaratustra EAX: 0000389f EBX: 00000000 ECX: 00000000 
>> EDX: 00000000
>> Sep 11 00:39:34 zaratustra ESI: d9800000 EDI: d9800000 EBP: 0000389f 
>> ESP: ea7a6edc
>> Sep 11 00:39:34 zaratustra DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
>> Sep 11 00:39:34 zaratustra Process bash (pid: 4495, ti=ea7a6000 
>> task=ea744000 task.ti=ea7a6000)
>> Sep 11 00:39:34 zaratustra Stack: 00000000 000003e8 d9800000 0000389f 
>> c0119042 00000000 00000000 00000001
>> Sep 11 00:39:34 zaratustra 00000000 00000000 ea7a6f54 00010000 00000000 
>> c04d2e80 00000001 000e7ef0
>> Sep 11 00:39:34 zaratustra c01191a3 00000000 00000000 ea7a6fa0 00000001 
>> ffffffff c04d2e80 ea5b2480
>> Sep 11 00:39:34 zaratustra Call Trace:
>> Sep 11 00:39:34 zaratustra [<c0119042>] __rt_schedulable+0x52/0x130
>> Sep 11 00:39:34 zaratustra [<c01191a3>] sched_rt_handler+0x83/0x120
>> Sep 11 00:39:34 zaratustra [<c01a76a6>] proc_sys_call_handler+0xb6/0xd0
>> Sep 11 00:39:34 zaratustra [<c01a76c0>] proc_sys_write+0x0/0x20
>> Sep 11 00:39:34 zaratustra [<c01a76d9>] proc_sys_write+0x19/0x20
>> Sep 11 00:39:34 zaratustra [<c016cc68>] vfs_write+0xa8/0x140
>> Sep 11 00:39:34 zaratustra [<c016cdd1>] sys_write+0x41/0x80
>> Sep 11 00:39:34 zaratustra [<c0103051>] sysenter_past_esp+0x6a/0x91
>> Sep 11 00:39:34 zaratustra =======================
>> Sep 11 00:39:34 zaratustra Code: c8 41 0f ad f3 d3 ee f6 c1 20 0f 45 de 
>> 31 f6 0f ad ef d3 ed f6 c1 20 0f 45 fd 0f 45 ee 31 c9 39 eb 89 fe 89 ea 
>> 77 08 89 e8 31 d2 <f7> f3 89 c1 89 f0 8b 7c 24 08 f7 f3 8b 74 24 04 89 
>> ca 8b 1c 24
>> Sep 11 00:39:34 zaratustra EIP: [<c0213fc7>] div64_u64+0x57/0x80 SS:ESP 
>> 0068:ea7a6edc
>> Sep 11 00:39:34 zaratustra ---[ end trace 4eaa2a86a8e2da22 ]---
> 
> Hi,
> 
> I'm not sure this patch really addresses the issue.
> But the kernel locks after changing sysctl_sched_rt_period=0.
> 
> This patch is against -tip.
> I think it's needed to -stable too.
> -------->
> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> Subject: [PATCH] sched: do not allow sysctl_sched_rt_period=0
> 
> sysctl_sched_rt_period=0 makes exception at to_ratio().

Oops, this description is probably not correct.
I got NMI LOCKUP message after sysctl_sched_rt_period=0.

thanks,
Hiroshi Shimamoto

> 
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> ---
>  kernel/sched.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 8f4af55..32d56d6 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -8971,6 +8971,9 @@ static int sched_rt_global_constraints(void)
>  	u64 rt_runtime, rt_period;
>  	int ret = 0;
>  
> +	if (sysctl_sched_rt_period <= 0)
> +		return -EINVAL;
> +
>  	rt_period = ktime_to_ns(tg->rt_bandwidth.rt_period);
>  	rt_runtime = tg->rt_bandwidth.rt_runtime;
>  
> @@ -8988,6 +8991,9 @@ static int sched_rt_global_constraints(void)
>  	unsigned long flags;
>  	int i;
>  
> +	if (sysctl_sched_rt_period <= 0)
> +		return -EINVAL;
> +
>  	spin_lock_irqsave(&def_rt_bandwidth.rt_runtime_lock, flags);
>  	for_each_possible_cpu(i) {
>  		struct rt_rq *rt_rq = &cpu_rq(i)->rt;

