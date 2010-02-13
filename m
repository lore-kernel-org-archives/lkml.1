Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445Ab0BMKjA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 05:39:00 -0500
Received: from casper.infradead.org ([85.118.1.10]:57192 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab0BMKi6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 05:38:58 -0500
Subject: Re: [PATCH 2/2][RFC] tracing: Add extract out softirq names used
 by irq trace events
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Christoph Hellwig <hch@lst.de>, Wu Fengguang <fengguang.wu@intel.com>
In-Reply-To: <20100212191037.283998401@goodmis.org>
References: <20100212190907.954438555@goodmis.org>
	 <20100212191037.283998401@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 13 Feb 2010 11:39:09 +0100
Message-ID: <1266057549.557.59605.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-12 at 14:09 -0500, Steven Rostedt wrote:
> plain text document attachment (irq-events.patch)
> The irq trace events that map the softirq vectors to strings
> shows up in the format files as names. To allow binary parsers to
> be able to convert these names to their actual numbers, this patch
> extracts those enums.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> ---
>  include/trace/events/irq.h |   11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> Index: linux-trace.git/include/trace/events/irq.h
> ===================================================================
> --- linux-trace.git.orig/include/trace/events/irq.h	2010-02-12 13:29:44.000000000 -0500
> +++ linux-trace.git/include/trace/events/irq.h	2010-02-12 13:33:20.000000000 -0500
> @@ -7,6 +7,17 @@
>  #include <linux/tracepoint.h>
>  #include <linux/interrupt.h>
>  
> +EXTRACT_TRACE_SYMBOL(HI_SOFTIRQ);
> +EXTRACT_TRACE_SYMBOL(TIMER_SOFTIRQ);
> +EXTRACT_TRACE_SYMBOL(NET_TX_SOFTIRQ);
> +EXTRACT_TRACE_SYMBOL(NET_RX_SOFTIRQ);
> +EXTRACT_TRACE_SYMBOL(BLOCK_SOFTIRQ);
> +EXTRACT_TRACE_SYMBOL(BLOCK_IOPOLL_SOFTIRQ);
> +EXTRACT_TRACE_SYMBOL(TASKLET_SOFTIRQ);
> +EXTRACT_TRACE_SYMBOL(SCHED_SOFTIRQ);
> +EXTRACT_TRACE_SYMBOL(HRTIMER_SOFTIRQ);
> +EXTRACT_TRACE_SYMBOL(RCU_SOFTIRQ);
> +

Still sucks you have to explicitly iterate them all, and far away from
the actual definition site too, its just asking to get out of whack with
reality.
