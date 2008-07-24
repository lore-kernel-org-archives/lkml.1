Return-Path: <linux-kernel-owner+w=401wt.eu-S1755636AbYGXN6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636AbYGXN6H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 09:58:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753678AbYGXN54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 09:57:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:65286 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbYGXN5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 09:57:55 -0400
Date: Thu, 24 Jul 2008 09:57:53 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [patch 08/17] LTTng instrumentation - kernel
In-Reply-To: <20080715222747.761260243@polymtl.ca>
Message-ID: <Pine.LNX.4.58.0807240956350.14946@gandalf.stny.rr.com>
References: <20080715222604.331269462@polymtl.ca> <20080715222747.761260243@polymtl.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, Mathieu Desnoyers wrote:
>
>  /*
>   * Low level drivers may need that to know if they can schedule in
> @@ -601,6 +603,7 @@ asmlinkage int printk(const char *fmt, .
>  	int r;
>
>  	va_start(args, fmt);
> +	trace_kernel_printk(__builtin_return_address(0));

BTW, ftrace.h has macros that let you use CALLER_ADDR0 for
__builtin_return_address. It also converts it from a pointer to a long,
but makes the code look prettier.


>  	r = vprintk(fmt, args);
>  	va_end(args);
>
> @@ -677,6 +680,9 @@ asmlinkage int vprintk(const char *fmt,
>  	raw_local_irq_save(flags);
>  	this_cpu = smp_processor_id();
>
> +	trace_kernel_vprintk(__builtin_return_address(0),
> +		printk_buf, printed_len);
> +
>  	/*
>  	 * Ouch, printk recursed into itself!
>  	 */

-- Steve

