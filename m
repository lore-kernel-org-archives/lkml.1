Return-Path: <linux-kernel-owner+w=401wt.eu-S1759951AbZCBGxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759951AbZCBGxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 01:53:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757483AbZCBGwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 01:52:55 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53869 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757180AbZCBGwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 01:52:54 -0500
Message-ID: <49AB8246.6020809@cn.fujitsu.com>
Date: Mon, 02 Mar 2009 14:52:54 +0800
From: Wang Chen <wangchen@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: kill unused parameter of pick_next_task()
References: <49AB74CE.2000200@cn.fujitsu.com> <20090302061350.GE1771@hack.private>
In-Reply-To: <20090302061350.GE1771@hack.private>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Américo Wang said the following on 2009-3-2 14:13:
> On Mon, Mar 02, 2009 at 01:55:26PM +0800, Wang Chen wrote:
>> based on tip/sched/cleanups
>>
>> impact: no change in functionality
>>
>> Parameter "prev" seems like an unusable thing.
>>
>> Signed-off-by: Wang Chen <wangchen@cn.fujitsu.com>
>> ---
>> kernel/sched.c |    6 +++---
>> 1 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/kernel/sched.c b/kernel/sched.c
>> index 410eec4..57f8b12 100644
>> --- a/kernel/sched.c
>> +++ b/kernel/sched.c
>> @@ -4512,7 +4512,7 @@ static inline void schedule_debug(struct task_struct *prev)
>>  * Pick up the highest-prio task:
>>  */
>> static inline struct task_struct *
>> -pick_next_task(struct rq *rq, struct task_struct *prev)
>> +pick_next_task(struct rq *rq)
>> {
>> 	const struct sched_class *class;
>> 	struct task_struct *p;
>> @@ -4587,7 +4587,7 @@ need_resched_nonpreemptible:
>> 		idle_balance(cpu, rq);
>>
>> 	prev->sched_class->put_prev_task(rq, prev);
>         ^^^^^
> 
> How about this? :)
> 

need_resched_nonpreemptible is inside another function instead of pick_next_task().
Because "diff" doesn't know "asmlinkage void __sched schedule(void)".
;)

>> -	next = pick_next_task(rq, prev);
>> +	next = pick_next_task(rq);
>>
>> 	if (likely(prev != next)) {
>                    ^^^^
> 
> also here.
> 
>> 		sched_info_switch(prev, next);
>> @@ -6423,7 +6423,7 @@ static void migrate_dead_tasks(unsigned int dead_cpu)
>> 		if (!rq->nr_running)
>> 			break;
>> 		update_rq_clock(rq);
>> -		next = pick_next_task(rq, rq->curr);
>> +		next = pick_next_task(rq);
>> 		if (!next)
>> 			break;
>> 		next->sched_class->put_prev_task(rq, next);
> 
> 
> I think you should check the latest linus-git, where you can safely
> just remove the parameter 'prev'.
> 

