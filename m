Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab0CCQGd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 11:06:33 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:49163 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695Ab0CCQGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 11:06:31 -0500
X-Authority-Analysis: v=1.0 c=1 a=JmiDjSKT-SYA:10 a=7U3hwN5JcxgA:10 a=y3nEGyS_QmGolIyZiwcA:9 a=RQvQhO2qMEUEkMWswbgA:7 a=u1BePbFJrU2Xmg_x_Q56J7opEPIA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC][PATCH 2/3] perf: Take a hot regs snapshot for trace
 events
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <1267599302-2886-3-git-send-regression-fweisbec@gmail.com>
References: <1267599302-2886-1-git-send-regression-fweisbec@gmail.com>
	 <1267599302-2886-3-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 03 Mar 2010 11:06:27 -0500
Message-ID: <1267632387.10871.59.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-03 at 07:55 +0100, Frederic Weisbecker wrote:

> +/*
>   * Output
>   */
>  static bool perf_output_space(struct perf_mmap_data *data, unsigned long tail,
> @@ -4337,6 +4347,8 @@ static const struct pmu perf_ops_task_clock = {
>  void perf_tp_event(int event_id, u64 addr, u64 count, void *record,
>  			  int entry_size)
>  {
> +	struct pt_regs regs;
> +
>  	struct perf_raw_record raw = {
>  		.size = entry_size,
>  		.data = record,
> @@ -4347,14 +4359,11 @@ void perf_tp_event(int event_id, u64 addr, u64 count, void *record,
>  		.raw = &raw,
>  	};
>  
> -	struct pt_regs *regs = get_irq_regs();
> -
> -	if (!regs)
> -		regs = task_pt_regs(current);
> +	PERF_SAVE_REGS(&regs);
>  
>  	/* Trace events already protected against recursion */
>  	do_perf_sw_event(PERF_TYPE_TRACEPOINT, event_id, count, 1,
> -				&data, regs);
> +				&data, &regs);

Off-topic: Why is the above a perf sw event? Couldn't that also be a
normal TRACE_EVENT()?

-- Steve

>  }
>  EXPORT_SYMBOL_GPL(perf_tp_event);
>  


