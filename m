Return-Path: <linux-kernel-owner+w=401wt.eu-S1764141AbZEHTJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764141AbZEHTJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 15:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755001AbZEHTIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 15:08:51 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39386 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754813AbZEHTIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 15:08:50 -0400
Message-ID: <4A04833B.1010209@garzik.org>
Date: Fri, 08 May 2009 15:08:43 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, viro@zeniv.linux.org.uk,
       Andrew Morton <akpm@linux-foundation.org>, roland@redhat.com
Subject: Re: [PATCH 1/2] kernel/{sched,smp}.c: fix static decl prior to	struct
 declaration
References: <20090508184838.GA11157@havoc.gtf.org> <20090508190409.GA12130@elte.hu>
In-Reply-To: <20090508190409.GA12130@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeff Garzik <jeff@garzik.org> wrote:
> 
>> According to C99 6.9.2p3, any declaration "static struct foo my_foo;"
>> must follow the definition of struct foo.
>>
>> Apparently, gcc's lack of warning is a bug.
>>
>> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> 
> good spotting, i'll apply this fix, but:
> 
>>   */
>>  struct task_group root_task_group;
>>  
>> -#ifdef CONFIG_FAIR_GROUP_SCHED
>> -/* Default task group's sched entity on each cpu */
>> -static DEFINE_PER_CPU(struct sched_entity, init_sched_entity);
>> -/* Default task group's cfs_rq on each cpu */
>> -static DEFINE_PER_CPU(struct cfs_rq, init_cfs_rq) ____cacheline_aligned_in_smp;
>> -#endif /* CONFIG_FAIR_GROUP_SCHED */
>> -
>> -#ifdef CONFIG_RT_GROUP_SCHED
>> -static DEFINE_PER_CPU(struct sched_rt_entity, init_sched_rt_entity);
>> -static DEFINE_PER_CPU(struct rt_rq, init_rt_rq) ____cacheline_aligned_in_smp;
>> -#endif /* CONFIG_RT_GROUP_SCHED */
>> -#else /* !CONFIG_USER_SCHED */
>> -#define root_task_group init_task_group
>> -#endif /* CONFIG_USER_SCHED */
>> -
>>  /* task_group_lock serializes add/remove of task groups and also changes to
> 
> This block has a visible imbalance of preprocessor directives - 
> there's a #else you moved, without moving the outermost #ifdef. My 
> guess is that this will go down in a fireball with 
> CONFIG_GROUP_SCHED disabled?

It seems you are correct, I missed it in my 'allmodconfig' and 'jeffs hw 
config' builds.

Are you fixing this up, or should I regen the patch?

	Jeff



