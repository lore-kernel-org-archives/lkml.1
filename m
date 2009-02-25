Return-Path: <linux-kernel-owner+w=401wt.eu-S1762411AbZBYQNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762411AbZBYQNw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 11:13:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754938AbZBYQNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 11:13:41 -0500
Received: from tomts16.bellnexxia.net ([209.226.175.4]:64931 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754878AbZBYQNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 11:13:41 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswEAGf4pElMQWWY/2dsb2JhbACBb9c6hBEG
Date: Wed, 25 Feb 2009 11:13:35 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Martin Bligh <mbligh@google.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/4] tracing: add DEFINE_TRACE_FMT to tracepoint.h
Message-ID: <20090225161335.GB11295@Krystal>
References: <20090225025608.956691460@goodmis.org> <20090225025753.547618424@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090225025753.547618424@goodmis.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:12:31 up 4 days,  7:46,  2 users,  load average: 0.60, 0.63,
	0.45
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> This patch creates a DEFINE_TRACE_FMT to map to DECLARE_TRACE.
> This allows for the developers to place format strings and
> args in with their tracepoint declaration. A tracer may now
> override the DEFINE_TRACE_FMT macro and use it to record
> a default format.
> 

Hi Steven,

How comes does a DEFINE_* maps to a DECLARE_* ?

Usually, DEFINE_* are meant to be put in .c files. DECLARE_* are in
headers. I don't see how the mapping you propose here can be
semantically correct ?

Mathieu

> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  include/linux/tracepoint.h |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> index 7570054..34ae464 100644
> --- a/include/linux/tracepoint.h
> +++ b/include/linux/tracepoint.h
> @@ -153,4 +153,7 @@ static inline void tracepoint_synchronize_unregister(void)
>  	synchronize_sched();
>  }
>  
> +#define DEFINE_TRACE_FMT(name, proto, args, fmt)		\
> +	DECLARE_TRACE(name, TPPROTO(proto), TPARGS(args))
> +
>  #endif
> -- 
> 1.5.6.5
> 
> -- 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
