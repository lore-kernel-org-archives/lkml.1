Return-Path: <linux-kernel-owner+w=401wt.eu-S1757190AbZDUV75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190AbZDUV75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 17:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755660AbZDUV7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 17:59:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60919 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305AbZDUV7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 17:59:40 -0400
Date: Tue, 21 Apr 2009 17:59:39 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2/2 v3] tracing/lock: provide lock_acquired event support
 for dynamic size string
In-Reply-To: <1240117295-6873-3-git-send-email-fweisbec@gmail.com>
Message-ID: <alpine.DEB.2.00.0904211759240.10097@gandalf.stny.rr.com>
References: <1240117295-6873-1-git-send-email-fweisbec@gmail.com> <1240117295-6873-3-git-send-email-fweisbec@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 19 Apr 2009, Frederic Weisbecker wrote:

> Now that we can support the dynamic sized string, make the lock tracing
> able to use it, making it safe against modules removal and consuming
> the right amount of memory needed for each lock name
> 
> Changes in v2:
> adapt to the __ending_string() updates and the opening_string() removal.
> 
> [ Impact: protect against module removal ]
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/trace/events/lockdep.h |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/trace/events/lockdep.h b/include/trace/events/lockdep.h
> index 45e326b..3ca315c 100644
> --- a/include/trace/events/lockdep.h
> +++ b/include/trace/events/lockdep.h
> @@ -38,16 +38,16 @@ TRACE_EVENT(lock_acquired,
>  	TP_ARGS(lock, ip, waittime),
>  
>  	TP_STRUCT__entry(
> -		__field(const char *, name)
> +		__string(name, lock->name)
>  		__field(unsigned long, wait_usec)
>  		__field(unsigned long, wait_nsec_rem)
>  	),
>  	TP_fast_assign(
> -		__entry->name = lock->name;
> +		__assign_str(name, lock->name);
>  		__entry->wait_nsec_rem = do_div(waittime, NSEC_PER_USEC);
>  		__entry->wait_usec = (unsigned long) waittime;
>  	),
> -	TP_printk("%s (%lu.%03lu us)", __entry->name, __entry->wait_usec,
> +	TP_printk("%s (%lu.%03lu us)", __get_str(name), __entry->wait_usec,
>  				       __entry->wait_nsec_rem)
>  );

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

