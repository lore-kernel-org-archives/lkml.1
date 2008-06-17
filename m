Return-Path: <linux-kernel-owner+w=401wt.eu-S1757393AbYFQIiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbYFQIiN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 04:38:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbYFQIh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 04:37:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51059 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753910AbYFQIh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 04:37:59 -0400
Date: Tue, 17 Jun 2008 10:37:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Latest Linus git: kernel/sched.c:1216: warning: ?init_hrtick?
	defined but not used
Message-ID: <20080617083742.GA18127@elte.hu>
References: <48278762.1080508@gmail.com> <20080513132328.GB5809@elte.hu> <483B4205.1030302@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483B4205.1030302@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kevin Winchester <kjwinchester@gmail.com> wrote:

>> Subject: sched: fix defined-but-unused warning
>> From: Rabin Vincent <rabin@rab.in>
>> Date: Sun, 11 May 2008 05:55:33 +0530
>>
>> Fix this warning, which appears with !CONFIG_SMP:
>> kernel/sched.c:1216: warning: `init_hrtick' defined but not used
>>
>> Signed-off-by: Rabin Vincent <rabin@rab.in>
>> Signed-off-by: Ingo Molnar <mingo@elte.hu>
>> ---
>>  kernel/sched.c |    2 ++
>>  1 file changed, 2 insertions(+)
>>
>> Index: linux/kernel/sched.c
>> ===================================================================
>> --- linux.orig/kernel/sched.c
>> +++ linux/kernel/sched.c
>> @@ -1130,6 +1130,7 @@ static enum hrtimer_restart hrtick(struc
>>  	return HRTIMER_NORESTART;
>>  }
>>  +#ifdef CONFIG_SMP
>>  static void hotplug_hrtick_disable(int cpu)
>>  {
>>  	struct rq *rq = cpu_rq(cpu);
>> @@ -1185,6 +1186,7 @@ static void init_hrtick(void)
>>  {
>>  	hotcpu_notifier(hotplug_hrtick, 0);
>>  }
>> +#endif /* CONFIG_SMP */
>>   static void init_rq_hrtick(struct rq *rq)
>>  {
>
> Did this ever make it to a pull request?  I still see the warning with 
> latest git.

it's queued up in tip/sched-devel at the moment:

 # sched-devel: 81d41d7: sched: fix defined-but-unused warning

but you are right, we can do this in v2.6.26 - i have cherry-picked it 
over into the v2.6.26 queue of patches.

	Ingo
