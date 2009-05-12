Return-Path: <linux-kernel-owner+w=401wt.eu-S1756782AbZELQQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbZELQQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 12:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754167AbZELQQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 12:16:05 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:51596 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148AbZELQQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 12:16:04 -0400
Date: Tue, 12 May 2009 09:15:47 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [Patch] RCU trace: use scnprintf instead of snprintf
Message-ID: <20090512161547.GD6768@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090512100504.6008.52782.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090512100504.6008.52782.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 06:04:15AM -0400, Amerigo Wang wrote:
> 
> snprintf can return more than the size of buffer, this case
> is not expected here, obviously. Use scnprintf instead.

Good catch!!!  I would welcome a simlarly careful review of the tracing
for the other RCU variants.

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: WANG Cong <amwang@redhat.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> ---
> diff --git a/kernel/rcupreempt_trace.c b/kernel/rcupreempt_trace.c
> index 7c2665c..4ea4300 100644
> --- a/kernel/rcupreempt_trace.c
> +++ b/kernel/rcupreempt_trace.c
> @@ -234,11 +234,11 @@ static ssize_t rcuctrs_read(struct file *filp, char __user *buffer,
> 
>  	mutex_lock(&rcupreempt_trace_mutex);
> 
> -	cnt += snprintf(&rcupreempt_trace_buf[cnt], RCUPREEMPT_TRACE_BUF_SIZE,
> +	cnt += scnprintf(&rcupreempt_trace_buf[cnt], RCUPREEMPT_TRACE_BUF_SIZE,
>  				"CPU last cur F M\n");
>  	for_each_online_cpu(cpu) {
>  		long *flipctr = rcupreempt_flipctr(cpu);
> -		cnt += snprintf(&rcupreempt_trace_buf[cnt],
> +		cnt += scnprintf(&rcupreempt_trace_buf[cnt],
>  				RCUPREEMPT_TRACE_BUF_SIZE - cnt,
>  					"%3d %4ld %3ld %d %d\n",
>  			       cpu,
> @@ -247,12 +247,12 @@ static ssize_t rcuctrs_read(struct file *filp, char __user *buffer,
>  			       rcupreempt_flip_flag(cpu),
>  			       rcupreempt_mb_flag(cpu));
>  	}
> -	cnt += snprintf(&rcupreempt_trace_buf[cnt],
> +	cnt += scnprintf(&rcupreempt_trace_buf[cnt],
>  			RCUPREEMPT_TRACE_BUF_SIZE - cnt,
>  			"ggp = %ld, state = %s\n",
>  			rcu_batches_completed(),
>  			rcupreempt_try_flip_state_name());
> -	cnt += snprintf(&rcupreempt_trace_buf[cnt],
> +	cnt += scnprintf(&rcupreempt_trace_buf[cnt],
>  			RCUPREEMPT_TRACE_BUF_SIZE - cnt,
>  			"\n");
>  	bcount = simple_read_from_buffer(buffer, count, ppos,
