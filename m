Return-Path: <linux-kernel-owner+w=401wt.eu-S933138AbZLGD0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933138AbZLGD0n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 22:26:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933073AbZLGD0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 22:26:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:36588 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933048AbZLGD0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 22:26:41 -0500
Message-ID: <4B1C75F3.9080808@kernel.org>
Date: Mon, 07 Dec 2009 12:26:43 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: tglx@linutronix.de, mingo@elte.hu, avi@redhat.com, efault@gmx.de,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] sched: implement try_to_wake_up_local()
References: <1259726212-30259-1-git-send-email-tj@kernel.org>	 <1259726212-30259-8-git-send-email-tj@kernel.org> <1259923487.3977.1940.camel@laptop>
In-Reply-To: <1259923487.3977.1940.camel@laptop>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/04/2009 07:44 PM, Peter Zijlstra wrote:
> On Wed, 2009-12-02 at 12:56 +0900, Tejun Heo wrote:
> 
>> +++ b/kernel/sched.c
>> @@ -2410,6 +2410,10 @@ static inline void ttwu_woken_up(struct task_struct *p, struct rq *rq,
>>  		rq->idle_stamp = 0;
>>  	}
>>  #endif
>> +	/*
>> +	 * Wake up is complete, fire wake up notifier.  This allows
>> +	 * try_to_wake_up_local() to be called from wake up notifiers.
>> +	 */
>>  	if (success)
>>  		fire_sched_notifiers(p, wakeup);
>>  }
> 
>> @@ -5437,6 +5488,11 @@ need_resched_nonpreemptible:
>>  		if (unlikely(signal_pending_state(prev->state, prev))) {
>>  			prev->state = TASK_RUNNING;
>>  		} else {
>> +			/*
>> +			 * Fire sleep notifier before changing any scheduler
>> +			 * state.  This allows try_to_wake_up_local() to be
>> +			 * called from sleep notifiers.
>> +			 */
>>  			fire_sched_notifiers(prev, sleep);
>>  			deactivate_task(rq, prev, 1);
>>  		}
> 
> These two hunks seem to belong to patch 6

Hmmm... it was intentional as, before this patch, there's no
try_to_wake_up_local() so it was strange to mention it in the comment.
I can move the comments but I don't think it's particularly better
that way.

Thanks.

-- 
tejun
