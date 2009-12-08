Return-Path: <linux-kernel-owner+w=401wt.eu-S1754603AbZLHHan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbZLHHan (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 02:30:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbZLHHam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 02:30:42 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:38798 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbZLHHal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 02:30:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WmmLAyQ8CrxX4RTanopr4xIFxeZMwrXhAmhJQ890JoTBA/lDKE6TcKcLiuelmIJcQU
         +NZ8thTJZWS5aza1HPfjGLIWGQYRud/8BsOQukTXX2ZK0Fuj0T/7fbqSL1aPdoKDctKm
         spZ96rfsprS6w/Aw0mUHdzAk9kvnv8wg+ZaS8=
Date: Tue, 8 Dec 2009 08:30:44 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/13] tracing: Extract duplicate
	ftrace_raw_init_event_foo()
Message-ID: <20091208073042.GA4989@nowhere>
References: <4B1DC476.3030700@cn.fujitsu.com> <4B1DC48C.7080603@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1DC48C.7080603@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 08, 2009 at 11:14:20AM +0800, Li Zefan wrote:
> Define ftrace_raw_init_event_foo() for each event class rather
> than for each event:
> 
>    text    data     bss     dec     hex filename
> 5355293 1961928 7103260 14420481         dc0a01 vmlinux.o.old
> 5346802 1961864 7103260 14411926         dbe896 vmlinux.o
> 
> raw_init can't be removed, because ftrace events and kprobe events
> use different raw_init callbacks. Though it's possible to totally
> remove raw_init, I choose to leave it as it is for now.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  include/linux/ftrace_event.h |    1 +
>  include/linux/syscalls.h     |    4 ++--
>  include/trace/ftrace.h       |   35 ++++-------------------------------
>  kernel/trace/trace_events.c  |   14 ++++++++++++++
>  4 files changed, 21 insertions(+), 33 deletions(-)
> 
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index 47bbdf9..cdea8a9 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -157,6 +157,7 @@ enum {
>  	FILTER_PTR_STRING,
>  };
>  
> +extern int trace_event_raw_init(struct ftrace_event_call *call);
>  extern int trace_define_common_fields(struct ftrace_event_call *call);
>  extern int trace_define_field(struct ftrace_event_call *call, const char *type,
>  			      const char *name, int offset, int size,
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index e79e2f3..55e7108 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -144,7 +144,7 @@ struct perf_event_attr;
>  		.name                   = "sys_enter"#sname,		\
>  		.system                 = "syscalls",			\
>  		.event                  = &enter_syscall_print_##sname,	\
> -		.raw_init		= init_syscall_trace,		\
> +		.raw_init		= trace_event_raw_init,		\
>  		.show_format		= syscall_enter_format,		\
>  		.define_fields		= syscall_enter_define_fields,	\
>  		.regfunc		= reg_event_syscall_enter,	\
> @@ -166,7 +166,7 @@ struct perf_event_attr;
>  		.name                   = "sys_exit"#sname,		\
>  		.system                 = "syscalls",			\
>  		.event                  = &exit_syscall_print_##sname,	\
> -		.raw_init		= init_syscall_trace,		\
> +		.raw_init		= trace_event_raw_init,		\



Nice cleanup.
BTW, init_syscall_trace is left unused now. Could you please
remove it too?

And add my Acked-by. Thanks!

