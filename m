Return-Path: <linux-kernel-owner+w=401wt.eu-S1752340AbZK3JKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340AbZK3JKe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 04:10:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbZK3JKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 04:10:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:46500 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918AbZK3JKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 04:10:33 -0500
Message-ID: <4B138BC8.3090008@kernel.org>
Date: Mon, 30 Nov 2009 18:09:28 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2.6.32-rc6] sched, kvm: fix race condition involving sched_in_preempt_notifers
References: <4AFD2801.7020900@kernel.org> <20091113095516.GD1364@elte.hu> <4AFEAB6D.60600@redhat.com>
In-Reply-To: <4AFEAB6D.60600@redhat.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2009 10:06 PM, Avi Kivity wrote:
> On 11/13/2009 11:55 AM, Ingo Molnar wrote:
>> * Tejun Heo<tj@kernel.org>  wrote:
>>> In finish_task_switch(), fire_sched_in_preempt_notifiers() is called
>>> after finish_lock_switch().  However, depending on architecture,
>>> preemption can be enabled after finish_lock_switch() which breaks the
>>> semantics of preempt notifiers.  Move it before finish_arch_switch().
>>> This also makes in notifiers symmetric to out notifiers in terms of
>>> locking - now both are called under rq lock.
>>>
>>>      
>> I'd like to have Avi's Ack for it,
> 
> Acked-by: Avi Kivity <avi@redhat.com>
> 
>>   but we want to do sched.c changes via
>> the scheduler tree.

So, this one was a bust.  Given that the only platform which might
have been affected by the original bug is ia64 and it's very unlikely
to happen.  I think reverting this from sched/urgent would be the
right thing to do at this point if the branch is headed for another
push to Linus.  Avi, what do you think?

Thanks.

-- 
tejun
