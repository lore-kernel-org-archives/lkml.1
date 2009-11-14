Return-Path: <linux-kernel-owner+w=401wt.eu-S1752183AbZKNNHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbZKNNHw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 08:07:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbZKNNHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 08:07:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687AbZKNNHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 08:07:51 -0500
Message-ID: <4AFEAB6D.60600@redhat.com>
Date: Sat, 14 Nov 2009 15:06:53 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Tejun Heo <tj@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2.6.32-rc6] sched, kvm: fix race condition involving sched_in_preempt_notifers
References: <4AFD2801.7020900@kernel.org> <20091113095516.GD1364@elte.hu>
In-Reply-To: <20091113095516.GD1364@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2009 11:55 AM, Ingo Molnar wrote:
> * Tejun Heo<tj@kernel.org>  wrote:
>
>    
>> In finish_task_switch(), fire_sched_in_preempt_notifiers() is called
>> after finish_lock_switch().  However, depending on architecture,
>> preemption can be enabled after finish_lock_switch() which breaks the
>> semantics of preempt notifiers.  Move it before finish_arch_switch().
>> This also makes in notifiers symmetric to out notifiers in terms of
>> locking - now both are called under rq lock.
>>
>>      
> I'd like to have Avi's Ack for it,

Acked-by: Avi Kivity <avi@redhat.com>

>   but we want to do sched.c changes via
> the scheduler tree.
>    

Definitely.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

