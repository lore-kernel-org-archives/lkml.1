Return-Path: <linux-kernel-owner+w=401wt.eu-S1758650AbZEZVoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650AbZEZVoe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 17:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755659AbZEZVo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 17:44:27 -0400
Received: from www.tglx.de ([62.245.132.106]:43978 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754914AbZEZVo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 17:44:26 -0400
Date: Tue, 26 May 2009 23:44:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
cc: mingo@elte.hu, LKML <linux-kernel@vger.kernel.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>, kosaki.motohiro@jp.fujitsu.com,
       Steven Rostedt <rostedt@goodmis.org>, fweisbec@gmail.com
Subject: Re: [PATCH 2/3] ftrace: add tracepoint for hrtimer
In-Reply-To: <4A16764F.2040307@cn.fujitsu.com>
Message-ID: <alpine.LFD.2.00.0905262340510.1762@localhost.localdomain>
References: <4A16764F.2040307@cn.fujitsu.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 May 2009, Xiao Guangrong wrote:
> +TRACE_EVENT(hrtimer_start,
> +
> +	TP_PROTO(struct hrtimer *timer),
> +
> +	TP_ARGS(timer),
> +
> +	TP_STRUCT__entry(
> +		__field( void *,	timer		)
> +		__field( void *,	function	)
> +		__field( s64,		expires		)
> +		__field( s64,		softexpires	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->timer		= timer;
> +		__entry->function	= timer->function;
> +		__entry->expires	= ktime_to_ns(hrtimer_get_expires(timer));
> +		__entry->softexpires	= ktime_to_ns(hrtimer_get_softexpires(timer));
> +	),

  Yuck, we really do not want expensive conversions in the fast
  path. This can be done by printk or user space tools.

> @@ -1119,6 +1122,7 @@ void hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
>  {
>  	debug_hrtimer_init(timer);
>  	__hrtimer_init(timer, clock_id, mode);
> +	trace_hrtimer_init(timer, clock_id, mode);

  The comments I made about the timer.c tracepoints vs. debugobjects
  apply here as well.

Thanks,

	tglx
