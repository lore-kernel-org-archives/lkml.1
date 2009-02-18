Return-Path: <linux-kernel-owner+w=401wt.eu-S1753507AbZBRM1C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbZBRM1C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 07:27:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751096AbZBRM0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 07:26:53 -0500
Received: from rv-out-0506.google.com ([209.85.198.227]:54328 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbZBRM0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 07:26:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PExnurcb16FtV95agyTSx7nlWNdM6kQPY6WnsBf8h5+ma6uQWPTuhdi3uKSMTqGSCJ
         LncgVS9vTkMmYGhxK8zXrPcsmur7ZsAqbaWnuP0vIjL2Yb9BsMeHdh+vSAxr3a1h8qjH
         RX1pgkVU5E0MJOuNltAgXlSPPc5yUuSrKIQfI=
MIME-Version: 1.0
In-Reply-To: <20090218211657.38bf3f38.minchan.kim@barrios-desktop>
References: <20090218211657.38bf3f38.minchan.kim@barrios-desktop>
Date: Wed, 18 Feb 2009 21:26:50 +0900
Message-ID: <28c262360902180426v7ad04d83wa4a9105ddd03acd0@mail.gmail.com>
Subject: Re: [PATCH] perfcounters: clean up rotate_percpu
From: MinChan Kim <minchan.kim@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I missed one thing. so I will resend next version.

On Wed, Feb 18, 2009 at 9:16 PM, MinChan Kim <minchan.kim@gmail.com> wrote:
> Ingo implemented rotate function at 235c7fc7c500e4fd1700c4ad01b5612bcdc1b449.
> I think he want to implement rotate_percpu but he don't implement it yet.
>
> If we need not it immediately,
> It would be better to remove it until we will need it again.
>
>  Signed-off-by: MinChan Kim <minchan.kim@gmail.com>
>
> ---
>  kernel/perf_counter.c |    9 ---------
>  1 files changed, 0 insertions(+), 9 deletions(-)
>
> diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
> index ad62965..007b219 100644
> --- a/kernel/perf_counter.c
> +++ b/kernel/perf_counter.c
> @@ -972,18 +972,9 @@ void perf_counter_task_tick(struct task_struct *curr, int cpu)
>  {
>        struct perf_cpu_context *cpuctx = &per_cpu(perf_cpu_context, cpu);
>        struct perf_counter_context *ctx = &curr->perf_counter_ctx;
> -       const int rotate_percpu = 0;
>
> -       if (rotate_percpu)
> -               perf_counter_cpu_sched_out(cpuctx);
>        perf_counter_task_sched_out(curr, cpu);
> -
> -       if (rotate_percpu)
> -               rotate_ctx(&cpuctx->ctx);
>        rotate_ctx(ctx);
> -
> -       if (rotate_percpu)
> -               perf_counter_cpu_sched_in(cpuctx, cpu);
>        perf_counter_task_sched_in(curr, cpu);
>  }
>
> --
> 1.5.4.3
>
>
> --
> Kinds Regards
> MinChan Kim
>



-- 
Kinds regards,
MinChan Kim
