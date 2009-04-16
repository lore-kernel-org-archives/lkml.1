Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbZDPB1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbZDPB1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 21:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbZDPB1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 21:27:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55639 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbZDPB1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 21:27:04 -0400
Message-ID: <49E6887D.6030400@cn.fujitsu.com>
Date: Thu, 16 Apr 2009 09:23:09 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: fix off-by-one bug in balance_tasks()
References: <49E54B2A.9060100@cn.fujitsu.com> <1239795719.22720.2231.camel@laptop>
In-Reply-To: <1239795719.22720.2231.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 2009-4-15 19:41 Peter Zijlstra wrote:
> On Wed, 2009-04-15 at 10:49 +0800, Miao Xie wrote:
>> If the load that need be moved equals the half weight of a task, I think
>> it is unnecessary to move this task. Or this task will be moved back and
>> forth.
> 
> That's actually desirable. Consider the 3 tasks on 2 cpus statically
> infeasible scenario. There you'd want the tasks to bounce around a bit
> in order to provide fairness.

I see. Thanks for your explanation.

Miao Xie
> 
>> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
>> ---
>>  kernel/sched.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/kernel/sched.c b/kernel/sched.c
>> index 5724508..44926c8 100644
>> --- a/kernel/sched.c
>> +++ b/kernel/sched.c
>> @@ -3085,7 +3085,7 @@ next:
>>  	if (!p || loops++ > sysctl_sched_nr_migrate)
>>  		goto out;
>>  
>> -	if ((p->se.load.weight >> 1) > rem_load_move ||
>> +	if ((p->se.load.weight >> 1) >= rem_load_move ||
>>  	    !can_migrate_task(p, busiest, this_cpu, sd, idle, &pinned)) {
>>  		p = iterator->next(iterator->arg);
>>  		goto next;
> 
> 
> 
> 


