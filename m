Return-Path: <linux-kernel-owner+w=401wt.eu-S1756912AbZCLPCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912AbZCLPCF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 11:02:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754214AbZCLPBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 11:01:52 -0400
Received: from mga12.intel.com ([143.182.124.36]:17046 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753583AbZCLPBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 11:01:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,351,1233561600"; 
   d="scan'208";a="119574691"
Message-ID: <49B923C4.20901@linux.intel.com>
Date: Thu, 12 Mar 2009 08:01:24 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>, mingo@redhat.com, hpa@zytor.com,
       dvhltc@us.ibm.com, linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/futexes] futex: use current->time_slack_ns for rt tasks
 too
References: <20090312075559.9856.28822.stgit@Aeon>	 <tip-16f4993f4e9860715918efd4eeac928f8de1218b@git.kernel.org>	 <49B913DC.6040807@linux.intel.com> <1236866529.22914.3694.camel@twins>	 <alpine.LFD.2.00.0903121524370.29264@localhost.localdomain> <1236869314.22914.3697.camel@twins>
In-Reply-To: <1236869314.22914.3697.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
>>> ---
>>>
>>> Subject: sched: adjust timer_slack_ns on scheduler policy change
>>> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
>>> Date: Thu Mar 12 15:01:02 CET 2009
>>>
>>> Ensure RT tasks have 0 timer slack.
>>>
>>> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>>> ---
>>>  kernel/sched.c |    2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> Index: linux-2.6/kernel/sched.c
>>> ===================================================================
>>> --- linux-2.6.orig/kernel/sched.c
>>> +++ linux-2.6/kernel/sched.c
>>> @@ -5511,10 +5511,12 @@ __setscheduler(struct rq *rq, struct tas
>>>  	case SCHED_NORMAL:
>>>  	case SCHED_BATCH:
>>>  	case SCHED_IDLE:
>>> +		p->timer_slack_ns = p->default_timer_slack_ns;
>>>  		p->sched_class = &fair_sched_class;
>>>  		break;
>>>  	case SCHED_FIFO:
>>>  	case SCHED_RR:
>>> +		p->timer_slack_ns = 0;
>>>  		p->sched_class = &rt_sched_class;
>>>  		break;
>>>  	}
>>>
> 
> Looking at the default_timer_slack_ns stuff, do we want something like
> the below?

the original idea was that you had a default slack that you got from exec time,
and then something you could just tweak around yourself independently....

this would throw that out of the window.
