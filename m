Return-Path: <linux-kernel-owner+w=401wt.eu-S1758600AbZEEGxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600AbZEEGxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 02:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754777AbZEEGwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 02:52:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58790 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753841AbZEEGwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 02:52:50 -0400
Message-ID: <49FFE279.1030809@cn.fujitsu.com>
Date: Tue, 05 May 2009 14:53:45 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, fweisbec@gmail.com,
       rostedt@goodmis.org, zhaolei@cn.fujitsu.com, laijs@cn.fujitsu.com
Subject: Re: [PATCH v3] ftrace: add a tracepoint for __raise_softirq_irqoff()
References: <49FFDF9C.7040505@cn.fujitsu.com>
In-Reply-To: <49FFDF9C.7040505@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +TRACE_EVENT(irq_softirq_raise,

I think 'softirq_raise' is better.

> +
> +	TP_PROTO(unsigned int nr),
> +
> +	TP_ARGS(nr),
> +
> +	TP_STRUCT__entry(
> +		__field(	unsigned int,	nr	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->nr	= nr;
> +	),
> +
> +	TP_printk("softirq=%d action=%s is raised",
> +		__entry->nr, softirq_to_name[__entry->nr])

"softirq=%d action=%s" is sufficient.

Please see TRACE_EVENT(softirq_entry) and TRACE_EVENT(softirq_exit).


> +);
> +
>  #endif /*  _TRACE_IRQ_H */
>  
>  /* This part must be outside protection */
> diff --git a/kernel/softirq.c b/kernel/softirq.c
> index b41fb71..bd0546b 100644
> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -310,6 +310,14 @@ void irq_exit(void)
>  	preempt_enable_no_resched();
>  }
>  
> +#ifdef CONFIG_TRACEPOINTS
> +inline void __raise_softirq_irqoff(unsigned int nr)
> +{
> +	trace_irq_softirq_raise(nr);
> +	or_softirq_pending(1UL << (nr));
> +}
> +#endif
> +
>  /*
>   * This function must run with irqs disabled!
>   */

