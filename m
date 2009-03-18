Return-Path: <linux-kernel-owner+w=401wt.eu-S1759210AbZCRW45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759210AbZCRW45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 18:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbZCRW4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 18:56:48 -0400
Received: from relay6.ptmail.sapo.pt ([212.55.154.26]:51987 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752604AbZCRW4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 18:56:48 -0400
X-AntiVirus: PTMail-AV 0.3-0.92.0
Date: Wed, 18 Mar 2009 22:54:28 +0000
From: Luis Henriques <henrix@sapo.pt>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 -tip] sched: Clean unused fields from struct rq
Message-ID: <20090318225428.GA3769@hades.domain.com>
References: <20090318225137.GA3766@hades.domain.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090318225137.GA3766@hades.domain.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 18, 2009 at 10:51:37PM +0000, Luis Henriques wrote:
> Since they are used on in statistics and are always set to zero, the following
> fields from struct rq have been removed: yld_exp_empty, yld_act_empty and
> yld_both_empty.
> 
> Both Sched Debug and SCHEDSTAT_VERSION versions has also been incremented since
> ABIs have been changed.
> 
> Signed-off-by: Luis Henriques <henrix@sapo.pt>
> ---
>  kernel/sched.c       |    3 ---
>  kernel/sched_debug.c |    5 +----
>  kernel/sched_stats.h |    7 +++----
>  3 files changed, 4 insertions(+), 11 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 8a579e2..4469034 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -646,9 +646,6 @@ struct rq {
>  	/* could above be rq->cfs_rq.exec_clock + rq->rt_rq.rt_runtime ? */
>  
>  	/* sys_sched_yield() stats */
> -	unsigned int yld_exp_empty;
> -	unsigned int yld_act_empty;
> -	unsigned int yld_both_empty;
>  	unsigned int yld_count;
>  
>  	/* schedule() stats */
> diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
> index 4daebff..467ca72 100644
> --- a/kernel/sched_debug.c
> +++ b/kernel/sched_debug.c
> @@ -286,9 +286,6 @@ static void print_cpu(struct seq_file *m, int cpu)
>  #ifdef CONFIG_SCHEDSTATS
>  #define P(n) SEQ_printf(m, "  .%-30s: %d\n", #n, rq->n);
>  
> -	P(yld_exp_empty);
> -	P(yld_act_empty);
> -	P(yld_both_empty);
>  	P(yld_count);
>  
>  	P(sched_switch);
> @@ -313,7 +310,7 @@ static int sched_debug_show(struct seq_file *m, void *v)
>  	u64 now = ktime_to_ns(ktime_get());
>  	int cpu;
>  
> -	SEQ_printf(m, "Sched Debug Version: v0.08, %s %.*s\n",
> +	SEQ_printf(m, "Sched Debug Version: v0.09, %s %.*s\n",
>  		init_utsname()->release,
>  		(int)strcspn(init_utsname()->version, " "),
>  		init_utsname()->version);
> diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
> index a8f93dd..32d2bd4 100644
> --- a/kernel/sched_stats.h
> +++ b/kernel/sched_stats.h
> @@ -4,7 +4,7 @@
>   * bump this up when changing the output format or the meaning of an existing
>   * format, so that tools can adapt (or abort)
>   */
> -#define SCHEDSTAT_VERSION 14
> +#define SCHEDSTAT_VERSION 15
>  
>  static int show_schedstat(struct seq_file *seq, void *v)
>  {
> @@ -26,9 +26,8 @@ static int show_schedstat(struct seq_file *seq, void *v)
>  
>  		/* runqueue-specific stats */
>  		seq_printf(seq,
> -		    "cpu%d %u %u %u %u %u %u %u %u %u %llu %llu %lu",
> -		    cpu, rq->yld_both_empty,
> -		    rq->yld_act_empty, rq->yld_exp_empty, rq->yld_count,
> +		    "cpu%d %u %u %u %u %u %u %llu %llu %lu",
> +		    cpu, rq->yld_count,
>  		    rq->sched_switch, rq->sched_count, rq->sched_goidle,
>  		    rq->ttwu_count, rq->ttwu_local,
>  		    rq->rq_cpu_time,
> -- 
> 1.6.2

Btw: I tried Greg schedtop with this patch and the app behaviour is as expected:

  $ ./schedtop 
  Exception: unsupported version

Regards,
-- 
Luis Henriques
