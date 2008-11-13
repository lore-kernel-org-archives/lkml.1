Return-Path: <linux-kernel-owner+w=401wt.eu-S1753298AbYKMCis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbYKMCis (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 21:38:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750956AbYKMCij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 21:38:39 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58419 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750924AbYKMCij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 21:38:39 -0500
Date: Wed, 12 Nov 2008 18:37:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Pekka Paalanen <pq@iki.fi>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/1] ftrace: do not update max buffer with no users
Message-Id: <20081112183745.07af124d.akpm@linux-foundation.org>
In-Reply-To: <20081113013247.974941878@goodmis.org>
References: <20081113013041.086583690@goodmis.org>
	<20081113013247.974941878@goodmis.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2008 20:30:42 -0500 Steven Rostedt <rostedt@goodmis.org> wrote:

> Impact: only use max latency buffer when a user is configured
> 
> Pekka reported a bug with the resizing of the buffers when only the
> MMIO tracer was configured. The issue was, to save memory, the max
> latency trace buffer was only initialized if a tracer that uses it
> is configured in.
> 
> What happened was that the max latency buffer was never initialized
> when only the MMIO tracer was configurued. The MMIO tracer does not
> use the max tracer, which kept it from being initialized. But the
> resize code still tried to resize the max latency buffers, but because
> they were never allocated, the resize code was passed a NULL pointer.
> 
> This patch puts all of the max_tr (max tracer buffer) inside the
> TRACER_MAX_TRACE config, to prevent any more errors in its use when
> not configured.
> 
> +#ifdef CONFIG_TRACER_MAX_TRACE
> +#endif /* CONFIG_TRACER_MAX_TRACE */
> +#ifdef CONFIG_TRACER_MAX_TRACE
> +#endif
> +#ifdef CONFIG_TRACER_MAX_TRACE
> +#endif
> +#ifdef CONFIG_TRACER_MAX_TRACE
> +#endif
> +#ifdef CONFIG_TRACER_MAX_TRACE
> +#endif
> +#ifdef CONFIG_TRACER_MAX_TRACE
> +#endif
> +#ifdef CONFIG_TRACER_MAX_TRACE
> +#endif

hey.


This sort of thing:

+#ifdef CONFIG_TRACER_MAX_TRACE
 	if (current_trace && current_trace->print_max)
 		iter->tr = &max_tr;
 	else
+#endif
 		iter->tr = inode->i_private;

is particularly regrettable.
