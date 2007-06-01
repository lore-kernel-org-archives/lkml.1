Return-Path: <linux-kernel-owner+w=401wt.eu-S1759177AbXFAHRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759177AbXFAHRT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 03:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756095AbXFAHRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 03:17:11 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:10228 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756154AbXFAHRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 03:17:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=mTDzNir1tFv0QrkWC9RjwKu/kU+MtTWPuWHvZg6AFH+cO9/OTzpTQ5in82PruqADPnQnuXjIUT9JBa4G0QiGXyX4o6FukMC49ShziZQBTXSm8/Omr9nsBTEP1cJxM3UQ4PTfP//y8rZpKsQdf8WjJOWsxT9IKOEqPzJhNtIjnyk=
Message-ID: <465FC7E7.7080804@gmail.com>
Date: Fri, 01 Jun 2007 15:16:55 +0800
From: Li Yu <raise.sail@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v14
References: <20070523120616.GA23407@elte.hu> <4658F1D6.3070706@gmail.com> <20070529061544.GA28523@elte.hu> <20070529080738.GA28657@elte.hu> <465E992C.4020601@gmail.com> <20070531095337.GA8104@elte.hu>
In-Reply-To: <20070531095337.GA8104@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Li Yu <raise.sail@gmail.com> wrote:
>
>   
>> static void distribute_fair_add(struct rq *rq, s64 delta)
>> {
>>    struct task_struct *curr = rq->curr;
>>    s64 delta_fair = 0;
>>
>>    if (!(sysctl_sched_load_smoothing & 32))
>>        return;
>>
>>    if (rq->nr_running) {
>>        delta_fair = div64_s(delta, rq->nr_running);
>>        /*
>>         * The currently running task's next wait_runtime value does
>>         * not depend on the fair_clock, so fix it up explicitly:
>>         */
>>        add_wait_runtime(rq, curr, -delta_fair);
>>        rq->fair_clock -= delta_fair;
>>    }
>> }
>>
>> See this line:
>>
>>        delta_fair = div64_s(delta, rq->nr_running);
>>
>> Ingo, should we be replace "rq->nr_running" with "rq->raw_load_weight" 
>> here?
>>     
>
> that would break the code. The handling of sleep periods is basically 
> heuristics and using nr_running here appears to be 'good enough' in 
> practice.
>
>   
Thanks,  I am wrong at seeing the delta variable is represented by 
virtual time unit. if the code does as I said, the delta_fair may be too 
small to meanless.

Also, I have want to know what's real meaning of     

    add_wait_runtime(rq, curr, delta_mine - delta_exec);

in update_curr(), IMHO, it should be

    add_wait_runtime(rq, curr, delta_mine - delta_fair);

Is this just another heuristics? or my opinion is wrong again? :-)

Good luck.

- Li Yu





