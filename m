Return-Path: <linux-kernel-owner+w=401wt.eu-S1757353AbZCLVdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353AbZCLVdr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 17:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755555AbZCLVdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 17:33:35 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:46935 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212AbZCLVde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 17:33:34 -0400
Message-ID: <49B97FA8.1060504@us.ibm.com>
Date: Thu, 12 Mar 2009 14:33:28 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/futexes] futex: use current->time_slack_ns for rt tasks
 too
References: <20090312075559.9856.28822.stgit@Aeon>	 <tip-16f4993f4e9860715918efd4eeac928f8de1218b@git.kernel.org>	 <49B913DC.6040807@linux.intel.com> <1236866529.22914.3694.camel@twins>	 <alpine.LFD.2.00.0903121524370.29264@localhost.localdomain> <1236869314.22914.3697.camel@twins> <49B923C4.20901@linux.intel.com>
In-Reply-To: <49B923C4.20901@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> Peter Zijlstra wrote:
>>>> ---
>>>>
>>>> Subject: sched: adjust timer_slack_ns on scheduler policy change
>>>> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
>>>> Date: Thu Mar 12 15:01:02 CET 2009
>>>>
>>>> Ensure RT tasks have 0 timer slack.
>>>>
>>>> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>>>> ---
>>>>  kernel/sched.c |    2 ++
>>>>  1 file changed, 2 insertions(+)
>>>>
>>>> Index: linux-2.6/kernel/sched.c
>>>> ===================================================================
>>>> --- linux-2.6.orig/kernel/sched.c
>>>> +++ linux-2.6/kernel/sched.c
>>>> @@ -5511,10 +5511,12 @@ __setscheduler(struct rq *rq, struct tas
>>>>      case SCHED_NORMAL:
>>>>      case SCHED_BATCH:
>>>>      case SCHED_IDLE:
>>>> +        p->timer_slack_ns = p->default_timer_slack_ns;
>>>>          p->sched_class = &fair_sched_class;
>>>>          break;
>>>>      case SCHED_FIFO:
>>>>      case SCHED_RR:
>>>> +        p->timer_slack_ns = 0;
>>>>          p->sched_class = &rt_sched_class;
>>>>          break;
>>>>      }
>>>>
>>
>> Looking at the default_timer_slack_ns stuff, do we want something like
>> the below?
> 
> the original idea was that you had a default slack that you got from 
> exec time,
> and then something you could just tweak around yourself independently....
> 
> this would throw that out of the window.

It seems to me that changing your scheduling class from userspace would 
be reasonable justification to change the timer slack to a default value 
for that class.  Thoughts?

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
