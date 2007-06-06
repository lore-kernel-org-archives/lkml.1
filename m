Return-Path: <linux-kernel-owner+w=401wt.eu-S1762924AbXFFKjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762924AbXFFKjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 06:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761673AbXFFKjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 06:39:24 -0400
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:38377 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760748AbXFFKjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 06:39:22 -0400
Message-ID: <46668E4D.8060206@linux.vnet.ibm.com>
Date: Wed, 06 Jun 2007 16:07:01 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: vatsa@in.ibm.com, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] CFS scheduler, -v15
References: <20070531150908.GA23538@elte.hu> <20070606064228.GA22443@in.ibm.com> <20070606070143.GA7375@elte.hu> <20070606074317.GB3274@in.ibm.com> <b647ffbd0706060208i5666f57eoe96215b636617622@mail.gmail.com>
In-Reply-To: <b647ffbd0706060208i5666f57eoe96215b636617622@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Adamushko wrote:
> On 06/06/07, Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:
>> On Wed, Jun 06, 2007 at 09:01:43AM +0200, Ingo Molnar wrote:
>> > [...] and my tree already contains the fixes for rt task's
>> > exec_start.
>>
>> Can I have this snapshot pls? I have to deal with the same issue when
>> the current task switches groups and I was planning to fix it by
>> introducing a set_curr_task() method in fair_sched_class which
>> initializes exec_start and other fields for that task.
> 
> Hum.. what about accounting 'exec_time' and updating 'exec_start' in
> rt_sched :: dequeue_task_rt() instead (like update_curr() does it in
> dequeue_task_fair())?
> 
> This way, on RT -> NORMAL transition.. some 'delta_exec' ( between
> deactivate_task() ---> activate_task() ) will be accounted later as if
> the task was 'sched_fair_class' during this time.. which I think makes
> some sense. What do you think?
> 

Why not do it explicitly in __setscheduler() if the new policy is SCHED_NORMAL
or SCHED_BATCH. You could also add the smarts to deactivate_task()

> sched_setscheduler()
> {
> ...
>        on_rq = p->on_rq;
>        if (on_rq)
>                deactivate_task(rq, p, 0);
>        oldprio = p->prio;
>        __setscheduler(rq, p, policy, param->sched_priority);
>        if (on_rq) {
>                activate_task(rq, p, 0);
> ...
> 
> 
>> -- 
>> Regards,
>> vatsa
>>
> 


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
