Return-Path: <linux-kernel-owner+w=401wt.eu-S1758886AbYHAUg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758886AbYHAUg3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 16:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082AbYHAUgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 16:36:20 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:62191 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbYHAUgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 16:36:20 -0400
Date: Fri, 1 Aug 2008 13:34:27 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH v2 3/2] ftrace: ftrace_printk doc moved
Message-Id: <20080801133427.51b17904.randy.dunlap@oracle.com>
In-Reply-To: <alpine.DEB.1.10.0808011411540.31922@gandalf.stny.rr.com>
References: <20080801162639.175407419@goodmis.org>
	<20080801163737.420519487@goodmis.org>
	<20080801094331.626195c8.randy.dunlap@oracle.com>
	<alpine.DEB.1.10.0808011248080.31922@gandalf.stny.rr.com>
	<20080801105255.82a6520f.randy.dunlap@oracle.com>
	<alpine.DEB.1.10.0808011411540.31922@gandalf.stny.rr.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Aug 2008 14:17:42 -0400 (EDT) Steven Rostedt wrote:

> 
> Based on Randy Dunlap's suggestion, the ftrace_printk kernel-doc belongs
> with the ftrace_printk macro that should be used. Not with the
> __ftrace_printk internal function.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  include/linux/ftrace.h |   19 ++++++++++++++++++-
>  kernel/trace/trace.c   |   16 ----------------
>  2 files changed, 18 insertions(+), 17 deletions(-)
> 
> Index: linux-tip.git/include/linux/ftrace.h
> ===================================================================
> --- linux-tip.git.orig/include/linux/ftrace.h	2008-08-01 12:20:56.000000000 -0400
> +++ linux-tip.git/include/linux/ftrace.h	2008-08-01 14:11:13.000000000 -0400
> @@ -137,7 +137,24 @@ static inline void tracer_disable(void)
>  extern void
>  ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3);
>  extern void ftrace_dump(void);
> -# define ftrace_printk(x...) __ftrace_printk(_THIS_IP_, x)
> +
> +/**
> + * ftrace_printk - printf formatting in the ftrace buffer
> + * @fmt - the printf format for printing.

    * @fmt: the printf format for printing

> + *
> + * Note: __ftrace_printk is an internal function for ftrace_printk and
> + *       the @ip is passed in via the ftrace_printk macro.
> + *
> + * This function allows a kernel developer to debug fast path sections
> + * that printk is not appropriate for. By scattering in various
> + * printk like tracing in the code, a developer can quickly see
> + * where problems are occurring.
> + *
> + * This is intended as a debugging tool for the developer only.
> + * Please reframe from leaving ftrace_printks scattered around in

             refrain

> + * your code.
> + */
> +# define ftrace_printk(fmt...) __ftrace_printk(_THIS_IP_, fmt)
>  extern int
>  __ftrace_printk(unsigned long ip, const char *fmt, ...)
>  	__attribute__ ((format (printf, 2, 3)));
> Index: linux-tip.git/kernel/trace/trace.c
> ===================================================================
> --- linux-tip.git.orig/kernel/trace/trace.c	2008-08-01 12:20:56.000000000 -0400
> +++ linux-tip.git/kernel/trace/trace.c	2008-08-01 14:10:36.000000000 -0400
> @@ -3243,22 +3243,6 @@ void ftrace_dump(void)
>  	(sizeof(struct trace_field) - offsetof(struct trace_field, print.buf))
>  #define TRACE_CONT_BUF_SIZE sizeof(struct trace_field)
>  
> -/**
> - * ftrace_printk - printf formatting in the ftrace buffer
> - * @fmt - the printf format for printing.
> - *
> - * Note: __ftrace_printk is an internal function for ftrace_printk and
> - *       the @ip is passed in via the ftrace_printk macro.
> - *
> - * This function allows a kernel developer to debug fast path sections
> - * that printk is not appropriate for. By scattering in various
> - * printk like tracing in the code, a developer can quickly see
> - * where problems are occurring.
> - *
> - * This is intended as a debugging tool for the developer only.
> - * Please reframe from leaving ftrace_printks scattered around in
> - * your code.
> - */
>  int __ftrace_printk(unsigned long ip, const char *fmt, ...)
>  {
>  	struct trace_array *tr = &global_trace;

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
