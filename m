Return-Path: <linux-kernel-owner+w=401wt.eu-S1754969AbYKLUfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969AbYKLUfK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 15:35:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbYKLUe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 15:34:57 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:10794 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbYKLUe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 15:34:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=uBAjORniTDyrCZ39s6vNzMf2CXMKX8NH/ZUESdq48w+JGOKTOZDzDzlDG7jI9ZcyyS
         m7GYJ4QhgR+sjXKtD2SZr3H0/T44ykq8I2nDcuhN34hEKqDPyBX36z2A3GH7tztnRLr+
         RglDPd1V5GVAUiN31KXb6U/mns3ws1GRDyGDE=
Message-ID: <8db1092f0811121234p3be15e29n5fd684e387977dab@mail.gmail.com>
Date: Wed, 12 Nov 2008 21:34:54 +0100
From: "Maciej Rutecki" <maciej.rutecki@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [Linux 2.6.28-rc4] BUG: using smp_processor_id() in preemptible [00000000] code: suspend_to_disk/2934
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "lenb@kernel.org" <lenb@kernel.org>,
       linux-acpi@vger.kernel.org
In-Reply-To: <20081112192128.GA17667@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8db1092f0811121030t1977b3bbu8340b582694d1e65@mail.gmail.com>
	 <alpine.LFD.2.00.0811121046360.3468@nehalem.linux-foundation.org>
	 <20081112192128.GA17667@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/12 Ingo Molnar <mingo@elte.hu>:

>
> i've queued up the fix below in tip/sched/urgent - Maciej, could you
> please test it? I've build and boot tested it.
>

Suspend to disk works OK now. Thanks.

Tested-by: Maciej Rutecki <maciej.rutecki@gmail.com>
>
> Reported-by: Maciej Rutecki <maciej.rutecki@gmail.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/sched.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 3bafbe3..c94baf2 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -5870,6 +5870,8 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
>        struct rq *rq = cpu_rq(cpu);
>        unsigned long flags;
>
> +       spin_lock_irqsave(&rq->lock, flags);
> +
>        __sched_fork(idle);
>        idle->se.exec_start = sched_clock();
>
> @@ -5877,7 +5879,6 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
>        idle->cpus_allowed = cpumask_of_cpu(cpu);
>        __set_task_cpu(idle, cpu);
>
> -       spin_lock_irqsave(&rq->lock, flags);
>        rq->curr = rq->idle = idle;
>  #if defined(CONFIG_SMP) && defined(__ARCH_WANT_UNLOCKED_CTXSW)
>        idle->oncpu = 1;
>
>

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
