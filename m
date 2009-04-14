Return-Path: <linux-kernel-owner+w=401wt.eu-S1753794AbZDNCiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbZDNCiJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 22:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbZDNChz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 22:37:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56082 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbZDNChy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 22:37:54 -0400
Date: Mon, 13 Apr 2009 22:37:52 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com, tglx@linutronix.de, mingo@elte.hu
cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/core] tracing/infrastructure: separate event tracer
 from event support
In-Reply-To: <tip-5f77a88b3f8268b11940b51d2e03d26a663ceb90@git.kernel.org>
Message-ID: <alpine.DEB.2.00.0904132236290.3041@gandalf.stny.rr.com>
References: <1239178441.10295.34.camel@tropicana> <tip-5f77a88b3f8268b11940b51d2e03d26a663ceb90@git.kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ug, this change is pretty meaningless with the new event tracing patches 
that I'm trying to finish.

On Mon, 13 Apr 2009, tip-bot for Tom Zanussi wrote:

> Commit-ID:  5f77a88b3f8268b11940b51d2e03d26a663ceb90
> Gitweb:     http://git.kernel.org/tip/5f77a88b3f8268b11940b51d2e03d26a663ceb90
> Author:     Tom Zanussi <tzanussi@gmail.com>
> AuthorDate: Wed, 8 Apr 2009 03:14:01 -0500
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Tue, 14 Apr 2009 00:00:55 +0200
> 
> tracing/infrastructure: separate event tracer from event support
> 
> Add a new config option, CONFIG_EVENT_TRACING that gets selected
> when CONFIG_TRACING is selected and adds everything needed by the stuff
> in trace_export - basically all the event tracing support needed by e.g.
> bprint, minus the actual events, which are only included if
> CONFIG_EVENT_TRACER is selected.
> 
> So CONFIG_EVENT_TRACER can be used to turn on or off the generated events
> (what I think of as the 'event tracer'), while CONFIG_EVENT_TRACING turns
> on or off the base event tracing support used by both the event tracer and
> the other things such as bprint that can't be configured out.
> 
> Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: fweisbec@gmail.com
> LKML-Reference: <1239178441.10295.34.camel@tropicana>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  include/asm-generic/vmlinux.lds.h |    2 +-
>  kernel/trace/Kconfig              |    4 ++++
>  kernel/trace/Makefile             |    6 +++---
>  3 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index 7fa660f..7e9b1e9 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -61,7 +61,7 @@
>  #define BRANCH_PROFILE()
>  #endif
>  
> -#ifdef CONFIG_EVENT_TRACER
> +#ifdef CONFIG_EVENT_TRACING
>  #define FTRACE_EVENTS()	VMLINUX_SYMBOL(__start_ftrace_events) = .;	\
>  			*(_ftrace_events)				\
>  			VMLINUX_SYMBOL(__stop_ftrace_events) = .;
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index 23b96eb..644606e 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -48,6 +48,9 @@ config FTRACE_NMI_ENTER
>         depends on HAVE_FTRACE_NMI_ENTER
>         default y
>  
> +config EVENT_TRACING
> +	bool
> +
>  config TRACING
>  	bool
>  	select DEBUG_FS
> @@ -56,6 +59,7 @@ config TRACING
>  	select TRACEPOINTS
>  	select NOP_TRACER
>  	select BINARY_PRINTF
> +	select EVENT_TRACING
>  
>  #
>  # Minimum requirements an architecture has to meet for us to
> diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
> index 2630f51..3ad367e 100644
> --- a/kernel/trace/Makefile
> +++ b/kernel/trace/Makefile
> @@ -40,11 +40,11 @@ obj-$(CONFIG_POWER_TRACER) += trace_power.o
>  obj-$(CONFIG_KMEMTRACE) += kmemtrace.o
>  obj-$(CONFIG_WORKQUEUE_TRACER) += trace_workqueue.o
>  obj-$(CONFIG_BLK_DEV_IO_TRACE)	+= blktrace.o
> -obj-$(CONFIG_EVENT_TRACER) += trace_events.o
> +obj-$(CONFIG_EVENT_TRACING) += trace_events.o
>  obj-$(CONFIG_EVENT_TRACER) += events.o

The only thing left that uses EVENT_TRACER no longer exists :-/

-- Steve

> -obj-$(CONFIG_EVENT_TRACER) += trace_export.o
> +obj-$(CONFIG_EVENT_TRACING) += trace_export.o
>  obj-$(CONFIG_FTRACE_SYSCALLS) += trace_syscalls.o
>  obj-$(CONFIG_EVENT_PROFILE) += trace_event_profile.o
> -obj-$(CONFIG_EVENT_TRACER) += trace_events_filter.o
> +obj-$(CONFIG_EVENT_TRACING) += trace_events_filter.o
>  
>  libftrace-y := ftrace.o
> 
