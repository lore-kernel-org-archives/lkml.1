Return-Path: <linux-kernel-owner+w=401wt.eu-S1756854AbZCFSiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854AbZCFSiX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 13:38:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754911AbZCFSiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 13:38:04 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:38831 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162AbZCFSiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 13:38:02 -0500
Date: Fri, 6 Mar 2009 13:37:58 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       ltt-dev@lists.casi.polymtl.ca, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Martin Bligh <mbligh@google.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       mrubin@google.com, md@google.com
Subject: Re: [RFC patch 01/41] LTTng - core header
In-Reply-To: <20090305225511.579649827@polymtl.ca>
Message-ID: <alpine.DEB.2.00.0903061335520.23248@gandalf.stny.rr.com>
References: <20090305224728.947235917@polymtl.ca> <20090305225511.579649827@polymtl.ca>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 5 Mar 2009, Mathieu Desnoyers wrote:

> Contains the structures required by the builtin part of the LTTng tracer.


Also note, it is better to push the core changes needed first. This way if 
something comes up, you can make your changes to your code before it gets 
into the kernel. This has been the approach I try to use. I send out patch 
series that modify the core kernel first, see what the feed back is, get 
them accepted, before continuing with further patches.

Thanks,

-- Steve


> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> ---
>  include/linux/ltt-core.h |   47 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 47 insertions(+)
> 
> Index: linux-2.6-lttng/include/linux/ltt-core.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/include/linux/ltt-core.h	2009-03-04 13:37:26.000000000 -0500
> @@ -0,0 +1,47 @@
> +/*
> + * Copyright (C) 2005,2006 Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca)
> + *
> + * This contains the core definitions for the Linux Trace Toolkit.
> + */
> +
> +#ifndef LTT_CORE_H
> +#define LTT_CORE_H
> +
> +#include <linux/list.h>
> +#include <linux/percpu.h>
> +
> +/* ltt's root dir in debugfs */
> +#define LTT_ROOT        "ltt"
> +
> +/*
> + * All modifications of ltt_traces must be done by ltt-tracer.c, while holding
> + * the semaphore. Only reading of this information can be done elsewhere, with
> + * the RCU mechanism : the preemption must be disabled while reading the
> + * list.
> + */
> +struct ltt_traces {
> +	struct list_head setup_head;	/* Pre-allocated traces list */
> +	struct list_head head;		/* Allocated Traces list */
> +	unsigned int num_active_traces;	/* Number of active traces */
> +} ____cacheline_aligned;
> +
> +extern struct ltt_traces ltt_traces;
> +
> +/*
> + * get dentry of ltt's root dir
> + */
> +struct dentry *get_ltt_root(void);
> +
> +void put_ltt_root(void);
> +
> +/* Keep track of trap nesting inside LTT */
> +DECLARE_PER_CPU(unsigned int, ltt_nesting);
> +
> +typedef int (*ltt_run_filter_functor)(void *trace, uint16_t eID);
> +
> +extern ltt_run_filter_functor ltt_run_filter;
> +
> +extern void ltt_filter_register(ltt_run_filter_functor func);
> +extern void ltt_filter_unregister(void);
> +
> +#endif /* LTT_CORE_H */
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> 
