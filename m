Return-Path: <linux-kernel-owner+w=401wt.eu-S1754073Ab0ASA7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab0ASA7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 19:59:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753558Ab0ASA7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 19:59:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:34041 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976Ab0ASA7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 19:59:13 -0500
Message-ID: <4B55050B.5020600@kernel.org>
Date: Tue, 19 Jan 2010 10:04:11 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: torvalds@linux-foundation.org, mingo@elte.hu, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 06/40] sched: add wakeup/sleep sched_notifiers and allow
 NULL notifier ops
References: <1263776272-382-1-git-send-email-tj@kernel.org>	 <1263776272-382-7-git-send-email-tj@kernel.org>	 <1263808633.4283.152.camel@laptop>  <4B5446A1.7070306@kernel.org> <1263818967.4283.459.camel@laptop>
In-Reply-To: <1263818967.4283.459.camel@laptop>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 19 Jan 2010 00:58:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2010 09:49 PM, Peter Zijlstra wrote:
> On Mon, 2010-01-18 at 20:31 +0900, Tejun Heo wrote:
>> On 01/18/2010 06:57 PM, Peter Zijlstra wrote:
>>> On Mon, 2010-01-18 at 09:57 +0900, Tejun Heo wrote:
>>>
>>>> @@ -2439,6 +2440,8 @@ static inline void ttwu_post_activation(struct task_struct *p, struct rq *rq,
>>>>  		rq->idle_stamp = 0;
>>>>  	}
>>>>  #endif
>>>> +	if (success)
>>>> +		fire_sched_notifiers(p, wakeup);
>>>>  }
>>>>  
>>>>  /**
>>>
>>> So why can't you call fire_sched_notifier(p, wakeup) right next to
>>> activate_task(rq, p, 1) in ttwu_activate() ?
>>
>> I was worried about calling notifier callback before notifying the
>> sched_class of the wakeup.  Conceptually, the notifier callback should
>> be called after all sched internal stuff about the wakeup finish,
>> so...
> 
> I'm thinking that we can place it next to activate_task(), if it makes
> you feel better you can place them both at the end up ttwu_activate()
> instead of in the middle.
> 
> Esp. with the callback you have it really doesn't matter.

Alright, if it's safe, there's no reason to keep it separate with an
extra branch.  I'll move it.

Thanks.

-- 
tejun
