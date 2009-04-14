Return-Path: <linux-kernel-owner+w=401wt.eu-S1756193AbZDNVvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbZDNVvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 17:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753466AbZDNVvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 17:51:12 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:42224 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbZDNVvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 17:51:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TEVa63oxo3dGryENlWmOx0uMaXv6SgAUPHGnqQf2r4nD2CxPDeXRpk3z+qBgtYyYMp
         4k7dreO1dYrDBb4yLIMfrFO6JXt9/urcwrvPfSLVHpospIhiYvRJiMYTJPAZ7mquIQtg
         vNOJpd7ZBTOoDDbB0J7tTAP3017KoEkdrOGus=
Date: Tue, 14 Apr 2009 23:51:03 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@elastic.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>, Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH 1/8] tracing: consolidate trace and trace_event headers
Message-ID: <20090414215102.GG5968@nowhere>
References: <20090414172337.280621613@goodmis.org> <20090414172640.556670154@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090414172640.556670154@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 01:23:38PM -0400, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Impact: clean up
> 
> Neil Horman (et. al.) criticized the way the trace events were broken up
> into two files. The reason for that was that ftrace needed to separate out
> the declarations from where the #include <linux/tracepoint.h> was used.
> It then dawned on me that the tracepoint.h header only needs to define the
> TRACE_EVENT macro if it is not already defined.
> 
> The solution is simply to test if TRACE_EVENT is defined, and if it is not
> then the linux/tracepoint.h header can define it. This change consolidates
> all the <traces>.h and <traces>_event_types.h into the <traces>.h file.
> 
> Reported-by: Neil Horman <nhorman@tuxdriver.com>
> Reported-by: Theodore Tso <tytso@mit.edu>
> Reported-by: Jiaying Zhang <jiayingz@google.com>
> Cc: Zhaolei <zhaolei@cn.fujitsu.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Jason Baron <jbaron@redhat.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/linux/tracepoint.h          |    9 +-
>  include/trace/irq.h                 |   51 +++++-
>  include/trace/irq_event_types.h     |   55 ------
>  include/trace/kmem.h                |  189 +++++++++++++++++++-
>  include/trace/lockdep.h             |   52 +++++-
>  include/trace/lockdep_event_types.h |   57 ------
>  include/trace/sched.h               |  333 ++++++++++++++++++++++++++++++++++-
>  include/trace/sched_event_types.h   |  337 -----------------------------------
>  include/trace/skb.h                 |   36 ++++-
>  include/trace/skb_event_types.h     |   38 ----
>  include/trace/trace_event_types.h   |    7 -
>  kernel/trace/events.c               |    1 +
>  kernel/trace/trace_events_stage_1.h |    4 +-
>  kernel/trace/trace_events_stage_2.h |    8 +-
>  kernel/trace/trace_events_stage_3.h |    4 +-
>  15 files changed, 663 insertions(+), 518 deletions(-)
>  delete mode 100644 include/trace/irq_event_types.h
>  delete mode 100644 include/trace/lockdep_event_types.h
>  delete mode 100644 include/trace/sched_event_types.h
>  delete mode 100644 include/trace/skb_event_types.h
>  delete mode 100644 include/trace/trace_event_types.h



I don't know if you use git-format-patch without -M or
something else specific to git pull request. But it looks
like the renames are not detected here, so it's a bit
hard to know what have been actually happened or deleted
in the end result.

Thanks,
Frederic.


 
> diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> index d35a7ee..4353f3f 100644
> --- a/include/linux/tracepoint.h
> +++ b/include/linux/tracepoint.h
> @@ -31,6 +31,8 @@ struct tracepoint {
>  					 * Keep in sync with vmlinux.lds.h.
>  					 */
>  
> +#ifndef DECLARE_TRACE
> +
>  #define TP_PROTO(args...)	args
>  #define TP_ARGS(args...)		args
>  
> @@ -114,6 +116,7 @@ static inline void tracepoint_update_probe_range(struct tracepoint *begin,
>  	struct tracepoint *end)
>  { }
>  #endif /* CONFIG_TRACEPOINTS */
> +#endif /* DECLARE_TRACE */
>  
>  /*
>   * Connect a probe to a tracepoint.
> @@ -154,10 +157,13 @@ static inline void tracepoint_synchronize_unregister(void)
>  }
>  
>  #define PARAMS(args...) args
> +
> +#ifndef TRACE_FORMAT
>  #define TRACE_FORMAT(name, proto, args, fmt)		\
>  	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
> +#endif
>  
> -
> +#ifndef TRACE_EVENT
>  /*
>   * For use with the TRACE_EVENT macro:
>   *
> @@ -262,5 +268,6 @@ static inline void tracepoint_synchronize_unregister(void)
>  
>  #define TRACE_EVENT(name, proto, args, struct, assign, print)	\
>  	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
> +#endif
>  
>  #endif
> diff --git a/include/trace/irq.h b/include/trace/irq.h
> index ff5d449..04ab4c6 100644
> --- a/include/trace/irq.h
> +++ b/include/trace/irq.h
> @@ -1,9 +1,54 @@
> -#ifndef _TRACE_IRQ_H
> +#if !defined(_TRACE_IRQ_H) || defined(TRACE_HEADER_MULTI_READ)
>  #define _TRACE_IRQ_H
>  
> -#include <linux/interrupt.h>
>  #include <linux/tracepoint.h>
> +#include <linux/interrupt.h>
> +
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM irq
> +
> +/*
> + * Tracepoint for entry of interrupt handler:
> + */
> +TRACE_FORMAT(irq_handler_entry,
> +	TP_PROTO(int irq, struct irqaction *action),
> +	TP_ARGS(irq, action),
> +	TP_FMT("irq=%d handler=%s", irq, action->name)
> +	);
> +
> +/*
> + * Tracepoint for return of an interrupt handler:
> + */
> +TRACE_EVENT(irq_handler_exit,
> +
> +	TP_PROTO(int irq, struct irqaction *action, int ret),
> +
> +	TP_ARGS(irq, action, ret),
> +
> +	TP_STRUCT__entry(
> +		__field(	int,	irq	)
> +		__field(	int,	ret	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->irq	= irq;
> +		__entry->ret	= ret;
> +	),
> +
> +	TP_printk("irq=%d return=%s",
> +		  __entry->irq, __entry->ret ? "handled" : "unhandled")
> +);
> +
> +TRACE_FORMAT(softirq_entry,
> +	TP_PROTO(struct softirq_action *h, struct softirq_action *vec),
> +	TP_ARGS(h, vec),
> +	TP_FMT("softirq=%d action=%s", (int)(h - vec), softirq_to_name[h-vec])
> +	);
>  
> -#include <trace/irq_event_types.h>
> +TRACE_FORMAT(softirq_exit,
> +	TP_PROTO(struct softirq_action *h, struct softirq_action *vec),
> +	TP_ARGS(h, vec),
> +	TP_FMT("softirq=%d action=%s", (int)(h - vec), softirq_to_name[h-vec])
> +	);
>  
>  #endif
> diff --git a/include/trace/irq_event_types.h b/include/trace/irq_event_types.h
> deleted file mode 100644
> index 85964eb..0000000
> --- a/include/trace/irq_event_types.h
> +++ /dev/null
> @@ -1,55 +0,0 @@
> -
> -/* use <trace/irq.h> instead */
> -#ifndef TRACE_FORMAT
> -# error Do not include this file directly.
> -# error Unless you know what you are doing.
> -#endif
> -
> -#undef TRACE_SYSTEM
> -#define TRACE_SYSTEM irq
> -
> -/*
> - * Tracepoint for entry of interrupt handler:
> - */
> -TRACE_FORMAT(irq_handler_entry,
> -	TP_PROTO(int irq, struct irqaction *action),
> -	TP_ARGS(irq, action),
> -	TP_FMT("irq=%d handler=%s", irq, action->name)
> -	);
> -
> -/*
> - * Tracepoint for return of an interrupt handler:
> - */
> -TRACE_EVENT(irq_handler_exit,
> -
> -	TP_PROTO(int irq, struct irqaction *action, int ret),
> -
> -	TP_ARGS(irq, action, ret),
> -
> -	TP_STRUCT__entry(
> -		__field(	int,	irq	)
> -		__field(	int,	ret	)
> -	),
> -
> -	TP_fast_assign(
> -		__entry->irq	= irq;
> -		__entry->ret	= ret;
> -	),
> -
> -	TP_printk("irq=%d return=%s",
> -		  __entry->irq, __entry->ret ? "handled" : "unhandled")
> -);
> -
> -TRACE_FORMAT(softirq_entry,
> -	TP_PROTO(struct softirq_action *h, struct softirq_action *vec),
> -	TP_ARGS(h, vec),
> -	TP_FMT("softirq=%d action=%s", (int)(h - vec), softirq_to_name[h-vec])
> -	);
> -
> -TRACE_FORMAT(softirq_exit,
> -	TP_PROTO(struct softirq_action *h, struct softirq_action *vec),
> -	TP_ARGS(h, vec),
> -	TP_FMT("softirq=%d action=%s", (int)(h - vec), softirq_to_name[h-vec])
> -	);
> -
> -#undef TRACE_SYSTEM
> diff --git a/include/trace/kmem.h b/include/trace/kmem.h
> index 46efc24..d7d1218 100644
> --- a/include/trace/kmem.h
> +++ b/include/trace/kmem.h
> @@ -1,9 +1,192 @@
> -#ifndef _TRACE_KMEM_H
> +#if !defined(_TRACE_KMEM_H) || defined(TRACE_HEADER_MULTI_READ)
>  #define _TRACE_KMEM_H
>  
>  #include <linux/types.h>
>  #include <linux/tracepoint.h>
>  
> -#include <trace/kmem_event_types.h>
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM kmem
>  
> -#endif /* _TRACE_KMEM_H */
> +TRACE_EVENT(kmalloc,
> +
> +	TP_PROTO(unsigned long call_site,
> +		 const void *ptr,
> +		 size_t bytes_req,
> +		 size_t bytes_alloc,
> +		 gfp_t gfp_flags),
> +
> +	TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags),
> +
> +	TP_STRUCT__entry(
> +		__field(	unsigned long,	call_site	)
> +		__field(	const void *,	ptr		)
> +		__field(	size_t,		bytes_req	)
> +		__field(	size_t,		bytes_alloc	)
> +		__field(	gfp_t,		gfp_flags	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->call_site	= call_site;
> +		__entry->ptr		= ptr;
> +		__entry->bytes_req	= bytes_req;
> +		__entry->bytes_alloc	= bytes_alloc;
> +		__entry->gfp_flags	= gfp_flags;
> +	),
> +
> +	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%08x",
> +		__entry->call_site,
> +		__entry->ptr,
> +		__entry->bytes_req,
> +		__entry->bytes_alloc,
> +		__entry->gfp_flags)
> +);
> +
> +TRACE_EVENT(kmem_cache_alloc,
> +
> +	TP_PROTO(unsigned long call_site,
> +		 const void *ptr,
> +		 size_t bytes_req,
> +		 size_t bytes_alloc,
> +		 gfp_t gfp_flags),
> +
> +	TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags),
> +
> +	TP_STRUCT__entry(
> +		__field(	unsigned long,	call_site	)
> +		__field(	const void *,	ptr		)
> +		__field(	size_t,		bytes_req	)
> +		__field(	size_t,		bytes_alloc	)
> +		__field(	gfp_t,		gfp_flags	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->call_site	= call_site;
> +		__entry->ptr		= ptr;
> +		__entry->bytes_req	= bytes_req;
> +		__entry->bytes_alloc	= bytes_alloc;
> +		__entry->gfp_flags	= gfp_flags;
> +	),
> +
> +	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%08x",
> +		__entry->call_site,
> +		__entry->ptr,
> +		__entry->bytes_req,
> +		__entry->bytes_alloc,
> +		__entry->gfp_flags)
> +);
> +
> +TRACE_EVENT(kmalloc_node,
> +
> +	TP_PROTO(unsigned long call_site,
> +		 const void *ptr,
> +		 size_t bytes_req,
> +		 size_t bytes_alloc,
> +		 gfp_t gfp_flags,
> +		 int node),
> +
> +	TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node),
> +
> +	TP_STRUCT__entry(
> +		__field(	unsigned long,	call_site	)
> +		__field(	const void *,	ptr		)
> +		__field(	size_t,		bytes_req	)
> +		__field(	size_t,		bytes_alloc	)
> +		__field(	gfp_t,		gfp_flags	)
> +		__field(	int,		node		)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->call_site	= call_site;
> +		__entry->ptr		= ptr;
> +		__entry->bytes_req	= bytes_req;
> +		__entry->bytes_alloc	= bytes_alloc;
> +		__entry->gfp_flags	= gfp_flags;
> +		__entry->node		= node;
> +	),
> +
> +	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%08x node=%d",
> +		__entry->call_site,
> +		__entry->ptr,
> +		__entry->bytes_req,
> +		__entry->bytes_alloc,
> +		__entry->gfp_flags,
> +		__entry->node)
> +);
> +
> +TRACE_EVENT(kmem_cache_alloc_node,
> +
> +	TP_PROTO(unsigned long call_site,
> +		 const void *ptr,
> +		 size_t bytes_req,
> +		 size_t bytes_alloc,
> +		 gfp_t gfp_flags,
> +		 int node),
> +
> +	TP_ARGS(call_site, ptr, bytes_req, bytes_alloc, gfp_flags, node),
> +
> +	TP_STRUCT__entry(
> +		__field(	unsigned long,	call_site	)
> +		__field(	const void *,	ptr		)
> +		__field(	size_t,		bytes_req	)
> +		__field(	size_t,		bytes_alloc	)
> +		__field(	gfp_t,		gfp_flags	)
> +		__field(	int,		node		)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->call_site	= call_site;
> +		__entry->ptr		= ptr;
> +		__entry->bytes_req	= bytes_req;
> +		__entry->bytes_alloc	= bytes_alloc;
> +		__entry->gfp_flags	= gfp_flags;
> +		__entry->node		= node;
> +	),
> +
> +	TP_printk("call_site=%lx ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%08x node=%d",
> +		__entry->call_site,
> +		__entry->ptr,
> +		__entry->bytes_req,
> +		__entry->bytes_alloc,
> +		__entry->gfp_flags,
> +		__entry->node)
> +);
> +
> +TRACE_EVENT(kfree,
> +
> +	TP_PROTO(unsigned long call_site, const void *ptr),
> +
> +	TP_ARGS(call_site, ptr),
> +
> +	TP_STRUCT__entry(
> +		__field(	unsigned long,	call_site	)
> +		__field(	const void *,	ptr		)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->call_site	= call_site;
> +		__entry->ptr		= ptr;
> +	),
> +
> +	TP_printk("call_site=%lx ptr=%p", __entry->call_site, __entry->ptr)
> +);
> +
> +TRACE_EVENT(kmem_cache_free,
> +
> +	TP_PROTO(unsigned long call_site, const void *ptr),
> +
> +	TP_ARGS(call_site, ptr),
> +
> +	TP_STRUCT__entry(
> +		__field(	unsigned long,	call_site	)
> +		__field(	const void *,	ptr		)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->call_site	= call_site;
> +		__entry->ptr		= ptr;
> +	),
> +
> +	TP_printk("call_site=%lx ptr=%p", __entry->call_site, __entry->ptr)
> +);
> +
> +#endif
> diff --git a/include/trace/lockdep.h b/include/trace/lockdep.h
> index 5ca67df..8ee7900 100644
> --- a/include/trace/lockdep.h
> +++ b/include/trace/lockdep.h
> @@ -1,9 +1,57 @@
> -#ifndef _TRACE_LOCKDEP_H
> +#if !defined(_TRACE_LOCKDEP_H) || defined(TRACE_HEADER_MULTI_READ)
>  #define _TRACE_LOCKDEP_H
>  
>  #include <linux/lockdep.h>
>  #include <linux/tracepoint.h>
>  
> -#include <trace/lockdep_event_types.h>
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM lock
> +
> +#ifdef CONFIG_LOCKDEP
> +
> +TRACE_FORMAT(lock_acquire,
> +	TP_PROTO(struct lockdep_map *lock, unsigned int subclass,
> +		int trylock, int read, int check,
> +		struct lockdep_map *next_lock, unsigned long ip),
> +	TP_ARGS(lock, subclass, trylock, read, check, next_lock, ip),
> +	TP_FMT("%s%s%s", trylock ? "try " : "",
> +		read ? "read " : "", lock->name)
> +	);
> +
> +TRACE_FORMAT(lock_release,
> +	TP_PROTO(struct lockdep_map *lock, int nested, unsigned long ip),
> +	TP_ARGS(lock, nested, ip),
> +	TP_FMT("%s", lock->name)
> +	);
> +
> +#ifdef CONFIG_LOCK_STAT
> +
> +TRACE_FORMAT(lock_contended,
> +	TP_PROTO(struct lockdep_map *lock, unsigned long ip),
> +	TP_ARGS(lock, ip),
> +	TP_FMT("%s", lock->name)
> +	);
> +
> +TRACE_EVENT(lock_acquired,
> +	TP_PROTO(struct lockdep_map *lock, unsigned long ip, s64 waittime),
> +
> +	TP_ARGS(lock, ip, waittime),
> +
> +	TP_STRUCT__entry(
> +		__field(const char *, name)
> +		__field(unsigned long, wait_usec)
> +		__field(unsigned long, wait_nsec_rem)
> +	),
> +	TP_fast_assign(
> +		__entry->name = lock->name;
> +		__entry->wait_nsec_rem = do_div(waittime, NSEC_PER_USEC);
> +		__entry->wait_usec = (unsigned long) waittime;
> +	),
> +	TP_printk("%s (%lu.%03lu us)", __entry->name, __entry->wait_usec,
> +				       __entry->wait_nsec_rem)
> +);
>  
>  #endif
> +#endif
> +
> +#endif /* _TRACE_LOCKDEP_H */
> diff --git a/include/trace/lockdep_event_types.h b/include/trace/lockdep_event_types.h
> deleted file mode 100644
> index 863f1e4..0000000
> --- a/include/trace/lockdep_event_types.h
> +++ /dev/null
> @@ -1,57 +0,0 @@
> -
> -#ifndef TRACE_FORMAT
> -# error Do not include this file directly.
> -# error Unless you know what you are doing.
> -#endif
> -
> -#undef TRACE_SYSTEM
> -#define TRACE_SYSTEM lock
> -
> -#ifdef CONFIG_LOCKDEP
> -
> -TRACE_FORMAT(lock_acquire,
> -	TP_PROTO(struct lockdep_map *lock, unsigned int subclass,
> -		int trylock, int read, int check,
> -		struct lockdep_map *next_lock, unsigned long ip),
> -	TP_ARGS(lock, subclass, trylock, read, check, next_lock, ip),
> -	TP_FMT("%s%s%s", trylock ? "try " : "",
> -		read ? "read " : "", lock->name)
> -	);
> -
> -TRACE_FORMAT(lock_release,
> -	TP_PROTO(struct lockdep_map *lock, int nested, unsigned long ip),
> -	TP_ARGS(lock, nested, ip),
> -	TP_FMT("%s", lock->name)
> -	);
> -
> -#ifdef CONFIG_LOCK_STAT
> -
> -TRACE_FORMAT(lock_contended,
> -	TP_PROTO(struct lockdep_map *lock, unsigned long ip),
> -	TP_ARGS(lock, ip),
> -	TP_FMT("%s", lock->name)
> -	);
> -
> -TRACE_EVENT(lock_acquired,
> -	TP_PROTO(struct lockdep_map *lock, unsigned long ip, s64 waittime),
> -
> -	TP_ARGS(lock, ip, waittime),
> -
> -	TP_STRUCT__entry(
> -		__field(const char *, name)
> -		__field(unsigned long, wait_usec)
> -		__field(unsigned long, wait_nsec_rem)
> -	),
> -	TP_fast_assign(
> -		__entry->name = lock->name;
> -		__entry->wait_nsec_rem = do_div(waittime, NSEC_PER_USEC);
> -		__entry->wait_usec = (unsigned long) waittime;
> -	),
> -	TP_printk("%s (%lu.%03lu us)", __entry->name, __entry->wait_usec,
> -				       __entry->wait_nsec_rem)
> -);
> -
> -#endif
> -#endif
> -
> -#undef TRACE_SYSTEM
> diff --git a/include/trace/sched.h b/include/trace/sched.h
> index 4e372a1..5b1cf4a 100644
> --- a/include/trace/sched.h
> +++ b/include/trace/sched.h
> @@ -1,9 +1,336 @@
> -#ifndef _TRACE_SCHED_H
> +#if !defined(_TRACE_SCHED_H) || defined(TRACE_HEADER_MULTI_READ)
>  #define _TRACE_SCHED_H
>  
>  #include <linux/sched.h>
>  #include <linux/tracepoint.h>
>  
> -#include <trace/sched_event_types.h>
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM sched
>  
> -#endif
> +/*
> + * Tracepoint for calling kthread_stop, performed to end a kthread:
> + */
> +TRACE_EVENT(sched_kthread_stop,
> +
> +	TP_PROTO(struct task_struct *t),
> +
> +	TP_ARGS(t),
> +
> +	TP_STRUCT__entry(
> +		__array(	char,	comm,	TASK_COMM_LEN	)
> +		__field(	pid_t,	pid			)
> +	),
> +
> +	TP_fast_assign(
> +		memcpy(__entry->comm, t->comm, TASK_COMM_LEN);
> +		__entry->pid	= t->pid;
> +	),
> +
> +	TP_printk("task %s:%d", __entry->comm, __entry->pid)
> +);
> +
> +/*
> + * Tracepoint for the return value of the kthread stopping:
> + */
> +TRACE_EVENT(sched_kthread_stop_ret,
> +
> +	TP_PROTO(int ret),
> +
> +	TP_ARGS(ret),
> +
> +	TP_STRUCT__entry(
> +		__field(	int,	ret	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->ret	= ret;
> +	),
> +
> +	TP_printk("ret %d", __entry->ret)
> +);
> +
> +/*
> + * Tracepoint for waiting on task to unschedule:
> + *
> + * (NOTE: the 'rq' argument is not used by generic trace events,
> + *        but used by the latency tracer plugin. )
> + */
> +TRACE_EVENT(sched_wait_task,
> +
> +	TP_PROTO(struct rq *rq, struct task_struct *p),
> +
> +	TP_ARGS(rq, p),
> +
> +	TP_STRUCT__entry(
> +		__array(	char,	comm,	TASK_COMM_LEN	)
> +		__field(	pid_t,	pid			)
> +		__field(	int,	prio			)
> +	),
> +
> +	TP_fast_assign(
> +		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
> +		__entry->pid	= p->pid;
> +		__entry->prio	= p->prio;
> +	),
> +
> +	TP_printk("task %s:%d [%d]",
> +		  __entry->comm, __entry->pid, __entry->prio)
> +);
> +
> +/*
> + * Tracepoint for waking up a task:
> + *
> + * (NOTE: the 'rq' argument is not used by generic trace events,
> + *        but used by the latency tracer plugin. )
> + */
> +TRACE_EVENT(sched_wakeup,
> +
> +	TP_PROTO(struct rq *rq, struct task_struct *p, int success),
> +
> +	TP_ARGS(rq, p, success),
> +
> +	TP_STRUCT__entry(
> +		__array(	char,	comm,	TASK_COMM_LEN	)
> +		__field(	pid_t,	pid			)
> +		__field(	int,	prio			)
> +		__field(	int,	success			)
> +	),
> +
> +	TP_fast_assign(
> +		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
> +		__entry->pid		= p->pid;
> +		__entry->prio		= p->prio;
> +		__entry->success	= success;
> +	),
> +
> +	TP_printk("task %s:%d [%d] success=%d",
> +		  __entry->comm, __entry->pid, __entry->prio,
> +		  __entry->success)
> +);
> +
> +/*
> + * Tracepoint for waking up a new task:
> + *
> + * (NOTE: the 'rq' argument is not used by generic trace events,
> + *        but used by the latency tracer plugin. )
> + */
> +TRACE_EVENT(sched_wakeup_new,
> +
> +	TP_PROTO(struct rq *rq, struct task_struct *p, int success),
> +
> +	TP_ARGS(rq, p, success),
> +
> +	TP_STRUCT__entry(
> +		__array(	char,	comm,	TASK_COMM_LEN	)
> +		__field(	pid_t,	pid			)
> +		__field(	int,	prio			)
> +		__field(	int,	success			)
> +	),
> +
> +	TP_fast_assign(
> +		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
> +		__entry->pid		= p->pid;
> +		__entry->prio		= p->prio;
> +		__entry->success	= success;
> +	),
> +
> +	TP_printk("task %s:%d [%d] success=%d",
> +		  __entry->comm, __entry->pid, __entry->prio,
> +		  __entry->success)
> +);
> +
> +/*
> + * Tracepoint for task switches, performed by the scheduler:
> + *
> + * (NOTE: the 'rq' argument is not used by generic trace events,
> + *        but used by the latency tracer plugin. )
> + */
> +TRACE_EVENT(sched_switch,
> +
> +	TP_PROTO(struct rq *rq, struct task_struct *prev,
> +		 struct task_struct *next),
> +
> +	TP_ARGS(rq, prev, next),
> +
> +	TP_STRUCT__entry(
> +		__array(	char,	prev_comm,	TASK_COMM_LEN	)
> +		__field(	pid_t,	prev_pid			)
> +		__field(	int,	prev_prio			)
> +		__array(	char,	next_comm,	TASK_COMM_LEN	)
> +		__field(	pid_t,	next_pid			)
> +		__field(	int,	next_prio			)
> +	),
> +
> +	TP_fast_assign(
> +		memcpy(__entry->next_comm, next->comm, TASK_COMM_LEN);
> +		__entry->prev_pid	= prev->pid;
> +		__entry->prev_prio	= prev->prio;
> +		memcpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
> +		__entry->next_pid	= next->pid;
> +		__entry->next_prio	= next->prio;
> +	),
> +
> +	TP_printk("task %s:%d [%d] ==> %s:%d [%d]",
> +		__entry->prev_comm, __entry->prev_pid, __entry->prev_prio,
> +		__entry->next_comm, __entry->next_pid, __entry->next_prio)
> +);
> +
> +/*
> + * Tracepoint for a task being migrated:
> + */
> +TRACE_EVENT(sched_migrate_task,
> +
> +	TP_PROTO(struct task_struct *p, int orig_cpu, int dest_cpu),
> +
> +	TP_ARGS(p, orig_cpu, dest_cpu),
> +
> +	TP_STRUCT__entry(
> +		__array(	char,	comm,	TASK_COMM_LEN	)
> +		__field(	pid_t,	pid			)
> +		__field(	int,	prio			)
> +		__field(	int,	orig_cpu		)
> +		__field(	int,	dest_cpu		)
> +	),
> +
> +	TP_fast_assign(
> +		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
> +		__entry->pid		= p->pid;
> +		__entry->prio		= p->prio;
> +		__entry->orig_cpu	= orig_cpu;
> +		__entry->dest_cpu	= dest_cpu;
> +	),
> +
> +	TP_printk("task %s:%d [%d] from: %d  to: %d",
> +		  __entry->comm, __entry->pid, __entry->prio,
> +		  __entry->orig_cpu, __entry->dest_cpu)
> +);
> +
> +/*
> + * Tracepoint for freeing a task:
> + */
> +TRACE_EVENT(sched_process_free,
> +
> +	TP_PROTO(struct task_struct *p),
> +
> +	TP_ARGS(p),
> +
> +	TP_STRUCT__entry(
> +		__array(	char,	comm,	TASK_COMM_LEN	)
> +		__field(	pid_t,	pid			)
> +		__field(	int,	prio			)
> +	),
> +
> +	TP_fast_assign(
> +		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
> +		__entry->pid		= p->pid;
> +		__entry->prio		= p->prio;
> +	),
> +
> +	TP_printk("task %s:%d [%d]",
> +		  __entry->comm, __entry->pid, __entry->prio)
> +);
> +
> +/*
> + * Tracepoint for a task exiting:
> + */
> +TRACE_EVENT(sched_process_exit,
> +
> +	TP_PROTO(struct task_struct *p),
> +
> +	TP_ARGS(p),
> +
> +	TP_STRUCT__entry(
> +		__array(	char,	comm,	TASK_COMM_LEN	)
> +		__field(	pid_t,	pid			)
> +		__field(	int,	prio			)
> +	),
> +
> +	TP_fast_assign(
> +		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
> +		__entry->pid		= p->pid;
> +		__entry->prio		= p->prio;
> +	),
> +
> +	TP_printk("task %s:%d [%d]",
> +		  __entry->comm, __entry->pid, __entry->prio)
> +);
> +
> +/*
> + * Tracepoint for a waiting task:
> + */
> +TRACE_EVENT(sched_process_wait,
> +
> +	TP_PROTO(struct pid *pid),
> +
> +	TP_ARGS(pid),
> +
> +	TP_STRUCT__entry(
> +		__array(	char,	comm,	TASK_COMM_LEN	)
> +		__field(	pid_t,	pid			)
> +		__field(	int,	prio			)
> +	),
> +
> +	TP_fast_assign(
> +		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
> +		__entry->pid		= pid_nr(pid);
> +		__entry->prio		= current->prio;
> +	),
> +
> +	TP_printk("task %s:%d [%d]",
> +		  __entry->comm, __entry->pid, __entry->prio)
> +);
> +
> +/*
> + * Tracepoint for do_fork:
> + */
> +TRACE_EVENT(sched_process_fork,
> +
> +	TP_PROTO(struct task_struct *parent, struct task_struct *child),
> +
> +	TP_ARGS(parent, child),
> +
> +	TP_STRUCT__entry(
> +		__array(	char,	parent_comm,	TASK_COMM_LEN	)
> +		__field(	pid_t,	parent_pid			)
> +		__array(	char,	child_comm,	TASK_COMM_LEN	)
> +		__field(	pid_t,	child_pid			)
> +	),
> +
> +	TP_fast_assign(
> +		memcpy(__entry->parent_comm, parent->comm, TASK_COMM_LEN);
> +		__entry->parent_pid	= parent->pid;
> +		memcpy(__entry->child_comm, child->comm, TASK_COMM_LEN);
> +		__entry->child_pid	= child->pid;
> +	),
> +
> +	TP_printk("parent %s:%d  child %s:%d",
> +		__entry->parent_comm, __entry->parent_pid,
> +		__entry->child_comm, __entry->child_pid)
> +);
> +
> +/*
> + * Tracepoint for sending a signal:
> + */
> +TRACE_EVENT(sched_signal_send,
> +
> +	TP_PROTO(int sig, struct task_struct *p),
> +
> +	TP_ARGS(sig, p),
> +
> +	TP_STRUCT__entry(
> +		__field(	int,	sig			)
> +		__array(	char,	comm,	TASK_COMM_LEN	)
> +		__field(	pid_t,	pid			)
> +	),
> +
> +	TP_fast_assign(
> +		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
> +		__entry->pid	= p->pid;
> +		__entry->sig	= sig;
> +	),
> +
> +	TP_printk("sig: %d  task %s:%d",
> +		  __entry->sig, __entry->comm, __entry->pid)
> +);
> +
> +#endif /* _TRACE_SCHED_H */
> diff --git a/include/trace/sched_event_types.h b/include/trace/sched_event_types.h
> deleted file mode 100644
> index 63547dc..0000000
> --- a/include/trace/sched_event_types.h
> +++ /dev/null
> @@ -1,337 +0,0 @@
> -
> -/* use <trace/sched.h> instead */
> -#ifndef TRACE_EVENT
> -# error Do not include this file directly.
> -# error Unless you know what you are doing.
> -#endif
> -
> -#undef TRACE_SYSTEM
> -#define TRACE_SYSTEM sched
> -
> -/*
> - * Tracepoint for calling kthread_stop, performed to end a kthread:
> - */
> -TRACE_EVENT(sched_kthread_stop,
> -
> -	TP_PROTO(struct task_struct *t),
> -
> -	TP_ARGS(t),
> -
> -	TP_STRUCT__entry(
> -		__array(	char,	comm,	TASK_COMM_LEN	)
> -		__field(	pid_t,	pid			)
> -	),
> -
> -	TP_fast_assign(
> -		memcpy(__entry->comm, t->comm, TASK_COMM_LEN);
> -		__entry->pid	= t->pid;
> -	),
> -
> -	TP_printk("task %s:%d", __entry->comm, __entry->pid)
> -);
> -
> -/*
> - * Tracepoint for the return value of the kthread stopping:
> - */
> -TRACE_EVENT(sched_kthread_stop_ret,
> -
> -	TP_PROTO(int ret),
> -
> -	TP_ARGS(ret),
> -
> -	TP_STRUCT__entry(
> -		__field(	int,	ret	)
> -	),
> -
> -	TP_fast_assign(
> -		__entry->ret	= ret;
> -	),
> -
> -	TP_printk("ret %d", __entry->ret)
> -);
> -
> -/*
> - * Tracepoint for waiting on task to unschedule:
> - *
> - * (NOTE: the 'rq' argument is not used by generic trace events,
> - *        but used by the latency tracer plugin. )
> - */
> -TRACE_EVENT(sched_wait_task,
> -
> -	TP_PROTO(struct rq *rq, struct task_struct *p),
> -
> -	TP_ARGS(rq, p),
> -
> -	TP_STRUCT__entry(
> -		__array(	char,	comm,	TASK_COMM_LEN	)
> -		__field(	pid_t,	pid			)
> -		__field(	int,	prio			)
> -	),
> -
> -	TP_fast_assign(
> -		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
> -		__entry->pid	= p->pid;
> -		__entry->prio	= p->prio;
> -	),
> -
> -	TP_printk("task %s:%d [%d]",
> -		  __entry->comm, __entry->pid, __entry->prio)
> -);
> -
> -/*
> - * Tracepoint for waking up a task:
> - *
> - * (NOTE: the 'rq' argument is not used by generic trace events,
> - *        but used by the latency tracer plugin. )
> - */
> -TRACE_EVENT(sched_wakeup,
> -
> -	TP_PROTO(struct rq *rq, struct task_struct *p, int success),
> -
> -	TP_ARGS(rq, p, success),
> -
> -	TP_STRUCT__entry(
> -		__array(	char,	comm,	TASK_COMM_LEN	)
> -		__field(	pid_t,	pid			)
> -		__field(	int,	prio			)
> -		__field(	int,	success			)
> -	),
> -
> -	TP_fast_assign(
> -		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
> -		__entry->pid		= p->pid;
> -		__entry->prio		= p->prio;
> -		__entry->success	= success;
> -	),
> -
> -	TP_printk("task %s:%d [%d] success=%d",
> -		  __entry->comm, __entry->pid, __entry->prio,
> -		  __entry->success)
> -);
> -
> -/*
> - * Tracepoint for waking up a new task:
> - *
> - * (NOTE: the 'rq' argument is not used by generic trace events,
> - *        but used by the latency tracer plugin. )
> - */
> -TRACE_EVENT(sched_wakeup_new,
> -
> -	TP_PROTO(struct rq *rq, struct task_struct *p, int success),
> -
> -	TP_ARGS(rq, p, success),
> -
> -	TP_STRUCT__entry(
> -		__array(	char,	comm,	TASK_COMM_LEN	)
> -		__field(	pid_t,	pid			)
> -		__field(	int,	prio			)
> -		__field(	int,	success			)
> -	),
> -
> -	TP_fast_assign(
> -		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
> -		__entry->pid		= p->pid;
> -		__entry->prio		= p->prio;
> -		__entry->success	= success;
> -	),
> -
> -	TP_printk("task %s:%d [%d] success=%d",
> -		  __entry->comm, __entry->pid, __entry->prio,
> -		  __entry->success)
> -);
> -
> -/*
> - * Tracepoint for task switches, performed by the scheduler:
> - *
> - * (NOTE: the 'rq' argument is not used by generic trace events,
> - *        but used by the latency tracer plugin. )
> - */
> -TRACE_EVENT(sched_switch,
> -
> -	TP_PROTO(struct rq *rq, struct task_struct *prev,
> -		 struct task_struct *next),
> -
> -	TP_ARGS(rq, prev, next),
> -
> -	TP_STRUCT__entry(
> -		__array(	char,	prev_comm,	TASK_COMM_LEN	)
> -		__field(	pid_t,	prev_pid			)
> -		__field(	int,	prev_prio			)
> -		__array(	char,	next_comm,	TASK_COMM_LEN	)
> -		__field(	pid_t,	next_pid			)
> -		__field(	int,	next_prio			)
> -	),
> -
> -	TP_fast_assign(
> -		memcpy(__entry->next_comm, next->comm, TASK_COMM_LEN);
> -		__entry->prev_pid	= prev->pid;
> -		__entry->prev_prio	= prev->prio;
> -		memcpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
> -		__entry->next_pid	= next->pid;
> -		__entry->next_prio	= next->prio;
> -	),
> -
> -	TP_printk("task %s:%d [%d] ==> %s:%d [%d]",
> -		__entry->prev_comm, __entry->prev_pid, __entry->prev_prio,
> -		__entry->next_comm, __entry->next_pid, __entry->next_prio)
> -);
> -
> -/*
> - * Tracepoint for a task being migrated:
> - */
> -TRACE_EVENT(sched_migrate_task,
> -
> -	TP_PROTO(struct task_struct *p, int orig_cpu, int dest_cpu),
> -
> -	TP_ARGS(p, orig_cpu, dest_cpu),
> -
> -	TP_STRUCT__entry(
> -		__array(	char,	comm,	TASK_COMM_LEN	)
> -		__field(	pid_t,	pid			)
> -		__field(	int,	prio			)
> -		__field(	int,	orig_cpu		)
> -		__field(	int,	dest_cpu		)
> -	),
> -
> -	TP_fast_assign(
> -		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
> -		__entry->pid		= p->pid;
> -		__entry->prio		= p->prio;
> -		__entry->orig_cpu	= orig_cpu;
> -		__entry->dest_cpu	= dest_cpu;
> -	),
> -
> -	TP_printk("task %s:%d [%d] from: %d  to: %d",
> -		  __entry->comm, __entry->pid, __entry->prio,
> -		  __entry->orig_cpu, __entry->dest_cpu)
> -);
> -
> -/*
> - * Tracepoint for freeing a task:
> - */
> -TRACE_EVENT(sched_process_free,
> -
> -	TP_PROTO(struct task_struct *p),
> -
> -	TP_ARGS(p),
> -
> -	TP_STRUCT__entry(
> -		__array(	char,	comm,	TASK_COMM_LEN	)
> -		__field(	pid_t,	pid			)
> -		__field(	int,	prio			)
> -	),
> -
> -	TP_fast_assign(
> -		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
> -		__entry->pid		= p->pid;
> -		__entry->prio		= p->prio;
> -	),
> -
> -	TP_printk("task %s:%d [%d]",
> -		  __entry->comm, __entry->pid, __entry->prio)
> -);
> -
> -/*
> - * Tracepoint for a task exiting:
> - */
> -TRACE_EVENT(sched_process_exit,
> -
> -	TP_PROTO(struct task_struct *p),
> -
> -	TP_ARGS(p),
> -
> -	TP_STRUCT__entry(
> -		__array(	char,	comm,	TASK_COMM_LEN	)
> -		__field(	pid_t,	pid			)
> -		__field(	int,	prio			)
> -	),
> -
> -	TP_fast_assign(
> -		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
> -		__entry->pid		= p->pid;
> -		__entry->prio		= p->prio;
> -	),
> -
> -	TP_printk("task %s:%d [%d]",
> -		  __entry->comm, __entry->pid, __entry->prio)
> -);
> -
> -/*
> - * Tracepoint for a waiting task:
> - */
> -TRACE_EVENT(sched_process_wait,
> -
> -	TP_PROTO(struct pid *pid),
> -
> -	TP_ARGS(pid),
> -
> -	TP_STRUCT__entry(
> -		__array(	char,	comm,	TASK_COMM_LEN	)
> -		__field(	pid_t,	pid			)
> -		__field(	int,	prio			)
> -	),
> -
> -	TP_fast_assign(
> -		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
> -		__entry->pid		= pid_nr(pid);
> -		__entry->prio		= current->prio;
> -	),
> -
> -	TP_printk("task %s:%d [%d]",
> -		  __entry->comm, __entry->pid, __entry->prio)
> -);
> -
> -/*
> - * Tracepoint for do_fork:
> - */
> -TRACE_EVENT(sched_process_fork,
> -
> -	TP_PROTO(struct task_struct *parent, struct task_struct *child),
> -
> -	TP_ARGS(parent, child),
> -
> -	TP_STRUCT__entry(
> -		__array(	char,	parent_comm,	TASK_COMM_LEN	)
> -		__field(	pid_t,	parent_pid			)
> -		__array(	char,	child_comm,	TASK_COMM_LEN	)
> -		__field(	pid_t,	child_pid			)
> -	),
> -
> -	TP_fast_assign(
> -		memcpy(__entry->parent_comm, parent->comm, TASK_COMM_LEN);
> -		__entry->parent_pid	= parent->pid;
> -		memcpy(__entry->child_comm, child->comm, TASK_COMM_LEN);
> -		__entry->child_pid	= child->pid;
> -	),
> -
> -	TP_printk("parent %s:%d  child %s:%d",
> -		__entry->parent_comm, __entry->parent_pid,
> -		__entry->child_comm, __entry->child_pid)
> -);
> -
> -/*
> - * Tracepoint for sending a signal:
> - */
> -TRACE_EVENT(sched_signal_send,
> -
> -	TP_PROTO(int sig, struct task_struct *p),
> -
> -	TP_ARGS(sig, p),
> -
> -	TP_STRUCT__entry(
> -		__field(	int,	sig			)
> -		__array(	char,	comm,	TASK_COMM_LEN	)
> -		__field(	pid_t,	pid			)
> -	),
> -
> -	TP_fast_assign(
> -		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
> -		__entry->pid	= p->pid;
> -		__entry->sig	= sig;
> -	),
> -
> -	TP_printk("sig: %d  task %s:%d",
> -		  __entry->sig, __entry->comm, __entry->pid)
> -);
> -
> -#undef TRACE_SYSTEM
> diff --git a/include/trace/skb.h b/include/trace/skb.h
> index d2de717..e6fd281 100644
> --- a/include/trace/skb.h
> +++ b/include/trace/skb.h
> @@ -1,9 +1,37 @@
> -#ifndef _TRACE_SKB_H_
> -#define _TRACE_SKB_H_
> +#if !defined(_TRACE_SKB_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_SKB_H
>  
>  #include <linux/skbuff.h>
>  #include <linux/tracepoint.h>
>  
> -#include <trace/skb_event_types.h>
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM skb
>  
> -#endif
> +/*
> + * Tracepoint for free an sk_buff:
> + */
> +TRACE_EVENT(kfree_skb,
> +
> +	TP_PROTO(struct sk_buff *skb, void *location),
> +
> +	TP_ARGS(skb, location),
> +
> +	TP_STRUCT__entry(
> +		__field(	void *,		skbaddr		)
> +		__field(	unsigned short,	protocol	)
> +		__field(	void *,		location	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->skbaddr = skb;
> +		if (skb) {
> +			__entry->protocol = ntohs(skb->protocol);
> +		}
> +		__entry->location = location;
> +	),
> +
> +	TP_printk("skbaddr=%p protocol=%u location=%p",
> +		__entry->skbaddr, __entry->protocol, __entry->location)
> +);
> +
> +#endif /* _TRACE_SKB_H */
> diff --git a/include/trace/skb_event_types.h b/include/trace/skb_event_types.h
> deleted file mode 100644
> index 4a1c504..0000000
> --- a/include/trace/skb_event_types.h
> +++ /dev/null
> @@ -1,38 +0,0 @@
> -
> -/* use <trace/skb.h> instead */
> -#ifndef TRACE_EVENT
> -# error Do not include this file directly.
> -# error Unless you know what you are doing.
> -#endif
> -
> -#undef TRACE_SYSTEM
> -#define TRACE_SYSTEM skb
> -
> -/*
> - * Tracepoint for free an sk_buff:
> - */
> -TRACE_EVENT(kfree_skb,
> -
> -	TP_PROTO(struct sk_buff *skb, void *location),
> -
> -	TP_ARGS(skb, location),
> -
> -	TP_STRUCT__entry(
> -		__field(	void *,		skbaddr		)
> -		__field(	unsigned short,	protocol	)
> -		__field(	void *,		location	)
> -	),
> -
> -	TP_fast_assign(
> -		__entry->skbaddr = skb;
> -		if (skb) {
> -			__entry->protocol = ntohs(skb->protocol);
> -		}
> -		__entry->location = location;
> -	),
> -
> -	TP_printk("skbaddr=%p protocol=%u location=%p",
> -		__entry->skbaddr, __entry->protocol, __entry->location)
> -);
> -
> -#undef TRACE_SYSTEM
> diff --git a/include/trace/trace_event_types.h b/include/trace/trace_event_types.h
> deleted file mode 100644
> index 552a50e..0000000
> --- a/include/trace/trace_event_types.h
> +++ /dev/null
> @@ -1,7 +0,0 @@
> -/* trace/<type>_event_types.h here */
> -
> -#include <trace/sched_event_types.h>
> -#include <trace/irq_event_types.h>
> -#include <trace/lockdep_event_types.h>
> -#include <trace/skb_event_types.h>
> -#include <trace/kmem_event_types.h>
> diff --git a/kernel/trace/events.c b/kernel/trace/events.c
> index 246f2aa..5a35a91 100644
> --- a/kernel/trace/events.c
> +++ b/kernel/trace/events.c
> @@ -8,6 +8,7 @@
>  
>  #include "trace_output.h"
>  
> +#define TRACE_HEADER_MULTI_READ
>  #include "trace_events_stage_1.h"
>  #include "trace_events_stage_2.h"
>  #include "trace_events_stage_3.h"
> diff --git a/kernel/trace/trace_events_stage_1.h b/kernel/trace/trace_events_stage_1.h
> index 38985f9..475f46a 100644
> --- a/kernel/trace/trace_events_stage_1.h
> +++ b/kernel/trace/trace_events_stage_1.h
> @@ -1,7 +1,7 @@
>  /*
>   * Stage 1 of the trace events.
>   *
> - * Override the macros in <trace/trace_event_types.h> to include the following:
> + * Override the macros in <trace/trace_events.h> to include the following:
>   *
>   * struct ftrace_raw_<call> {
>   *	struct trace_entry		ent;
> @@ -36,4 +36,4 @@
>  	};							\
>  	static struct ftrace_event_call event_##name
>  
> -#include <trace/trace_event_types.h>
> +#include <trace/trace_events.h>
> diff --git a/kernel/trace/trace_events_stage_2.h b/kernel/trace/trace_events_stage_2.h
> index 59cfd7d..aa4a67a 100644
> --- a/kernel/trace/trace_events_stage_2.h
> +++ b/kernel/trace/trace_events_stage_2.h
> @@ -1,7 +1,7 @@
>  /*
>   * Stage 2 of the trace events.
>   *
> - * Override the macros in <trace/trace_event_types.h> to include the following:
> + * Override the macros in <trace/trace_events.h> to include the following:
>   *
>   * enum print_line_t
>   * ftrace_raw_output_<call>(struct trace_iterator *iter, int flags)
> @@ -64,7 +64,7 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
>  	return TRACE_TYPE_HANDLED;					\
>  }
>  	
> -#include <trace/trace_event_types.h>
> +#include <trace/trace_events.h>
>  
>  /*
>   * Setup the showing format of trace point.
> @@ -128,7 +128,7 @@ ftrace_format_##call(struct trace_seq *s)				\
>  	return ret;							\
>  }
>  
> -#include <trace/trace_event_types.h>
> +#include <trace/trace_events.h>
>  
>  #undef __field
>  #define __field(type, item)						\
> @@ -167,4 +167,4 @@ ftrace_define_fields_##call(void)					\
>  	return ret;							\
>  }
>  
> -#include <trace/trace_event_types.h>
> +#include <trace/trace_events.h>
> diff --git a/kernel/trace/trace_events_stage_3.h b/kernel/trace/trace_events_stage_3.h
> index 5bb1b7f..45c04e1 100644
> --- a/kernel/trace/trace_events_stage_3.h
> +++ b/kernel/trace/trace_events_stage_3.h
> @@ -1,7 +1,7 @@
>  /*
>   * Stage 3 of the trace events.
>   *
> - * Override the macros in <trace/trace_event_types.h> to include the following:
> + * Override the macros in <trace/trace_events.h> to include the following:
>   *
>   * static void ftrace_event_<call>(proto)
>   * {
> @@ -272,7 +272,7 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
>  	_TRACE_PROFILE_INIT(call)					\
>  }
>  
> -#include <trace/trace_event_types.h>
> +#include <trace/trace_events.h>
>  
>  #undef _TRACE_PROFILE
>  #undef _TRACE_PROFILE_INIT
> -- 
> 1.6.2.1
> 
> -- 

