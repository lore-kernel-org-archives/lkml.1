Return-Path: <linux-kernel-owner+w=401wt.eu-S1757846AbZDTWlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757846AbZDTWlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 18:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756837AbZDTWlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 18:41:35 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:52429 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756354AbZDTWle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 18:41:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZEKQREc/v8Zs9v7FzJQ6lCy6prF12zS6gsC5GrtXx0ZiNdB16jTMg99EKXueZ4Z5MT
         WYqA8KrutU5/OKxqfcw/gRMah1gWtl03zsv4le9nvWDFKbivekbWXnTrMoWpRU7kdH0R
         ZK5yr0fTk4snWdPyn4dnEybeeHtXpQG/h7IBU=
Date: Tue, 21 Apr 2009 00:41:30 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] tracing: use nowakeup version of commit for
	function event trace tests
Message-ID: <20090420224129.GB5997@nowhere>
References: <20090420222257.267399830@goodmis.org> <20090420222325.267573793@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090420222325.267573793@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 06:22:59PM -0400, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> The startup tests for the event tracer also runs with the function
> tracer enabled. The "wakeup" version of the trace commit was used
> which can grab spinlocks. If a task was preempted by an NMI
> that called a function being traced, it could deadlock due to the
> function tracer trying to grab the same lock.
> 
> Thanks to Frederic Weisbecker for pointing out where the bug was.
> 
> Reported-by: Ingo Molnar <mingo@elte.hu>
> Reported-by: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---


Aah, I was about to push my version, which was the same but with
a more weird changelog :-)

Frederic.



>  kernel/trace/trace_events.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 98daf5d..672b195 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -1164,7 +1164,7 @@ function_test_events_call(unsigned long ip, unsigned long parent_ip)
>  	entry->ip			= ip;
>  	entry->parent_ip		= parent_ip;
>  
> -	trace_current_buffer_unlock_commit(event, flags, pc);
> +	trace_nowake_buffer_unlock_commit(event, flags, pc);
>  
>   out:
>  	atomic_dec(&per_cpu(test_event_disable, cpu));
> -- 
> 1.6.2.1
> 
> -- 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

