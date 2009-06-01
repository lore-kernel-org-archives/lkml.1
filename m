Return-Path: <linux-kernel-owner+w=401wt.eu-S1757959AbZFANMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959AbZFANMB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 09:12:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755767AbZFANLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 09:11:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:46962 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbZFANLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 09:11:53 -0400
Date: Mon, 1 Jun 2009 09:11:52 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Li Zefan <lizf@cn.fujitsu.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] tracing/events: put TP_fast_assign into braces
In-Reply-To: <4A2384B1.90100@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0906010911370.14994@gandalf.stny.rr.com>
References: <4A2384B1.90100@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Mon, 1 Jun 2009, Li Zefan wrote:

> Currently TP_fast_assin has a limitation that we can't define local
> variables in it.
> 
> Here's one use case when we introduce __dynamic_array():
> 
> TP_fast_assign(
> 	type *p = __get_dynamic_array(item);
> 
> 	foo(p);
> 	bar(p);
> ),
> 
> [ Impact: allow defining local variables in TP_fast_assign ]
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Thanks Li,

I'll pull it in.

-- Steve

> ---
>  include/trace/ftrace.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index 9276ec4..ee92682 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -471,7 +471,7 @@ static void ftrace_raw_event_##call(proto)				\
>  		return;							\
>  	entry	= ring_buffer_event_data(event);			\
>  									\
> -	assign;								\
> +	{ assign; }							\
>  									\
>  	if (!filter_current_check_discard(event_call, entry, event))	\
>  		trace_nowake_buffer_unlock_commit(event, irq_flags, pc); \
> -- 
> 1.5.4.rc3
> 
> 
> 
