Return-Path: <linux-kernel-owner+w=401wt.eu-S1751637AbZH0PES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637AbZH0PES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 11:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbZH0PES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 11:04:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31843 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139AbZH0PER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 11:04:17 -0400
Message-ID: <4A96A145.5080108@redhat.com>
Date: Thu, 27 Aug 2009 11:07:49 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 19/18] tracing: Restore the const qualifier for field
 names and types definition
References: <1251340337-5640-1-git-send-email-fweisbec@gmail.com> <1251344087-28719-2-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1251344087-28719-2-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> Restore the const qualifier in field's name and type parameters of
> trace_define_field that was lost while solving a conflict.
> 
> Fields names and types are defined as builtin constant strings in
> static TRACE_EVENTs. But kprobes allocates these dynamically.
> 
> That said, we still want to always pass these strings as const char *
> in trace_define_fields() to avoid any further accidental writes on
> the pointed strings.
> 
> Reported-by: Li Zefan<lizf@cn.fujitsu.com>
> Signed-off-by: Frederic Weisbecker<fweisbec@gmail.com>
> Cc: Steven Rostedt<rostedt@goodmis.org>

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

> ---
>   include/linux/ftrace_event.h  |    6 +++---
>   kernel/trace/trace_events.c   |    4 ++--
>   kernel/trace/trace_syscalls.c |    4 ++--
>   3 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index 1ab3089..73edf5a 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -148,9 +148,9 @@ enum {
>   };
> 
>   extern int trace_define_common_fields(struct ftrace_event_call *call);
> -extern int trace_define_field(struct ftrace_event_call *call, char *type,
> -			      char *name, int offset, int size, int is_signed,
> -			      int filter_type);
> +extern int trace_define_field(struct ftrace_event_call *call, const char *type,
> +			      const char *name, int offset, int size,
> +			      int is_signed, int filter_type);
>   extern int trace_add_event_call(struct ftrace_event_call *call);
>   extern void trace_remove_event_call(struct ftrace_event_call *call);
> 
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 8079bb5..197cdaa 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -27,8 +27,8 @@ DEFINE_MUTEX(event_mutex);
> 
>   LIST_HEAD(ftrace_events);
> 
> -int trace_define_field(struct ftrace_event_call *call, char *type,
> -		       char *name, int offset, int size, int is_signed,
> +int trace_define_field(struct ftrace_event_call *call, const char *type,
> +		       const char *name, int offset, int size, int is_signed,
>   		       int filter_type)
>   {
>   	struct ftrace_event_field *field;
> diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> index 5931933..a928dd0 100644
> --- a/kernel/trace/trace_syscalls.c
> +++ b/kernel/trace/trace_syscalls.c
> @@ -193,8 +193,8 @@ int syscall_enter_define_fields(struct ftrace_event_call *call)
>   		return ret;
> 
>   	for (i = 0; i<  meta->nb_args; i++) {
> -		ret = trace_define_field(call, (char *)meta->types[i],
> -					 (char *)meta->args[i], offset,
> +		ret = trace_define_field(call, meta->types[i],
> +					 meta->args[i], offset,
>   					 sizeof(unsigned long), 0,
>   					 FILTER_OTHER);
>   		offset += sizeof(unsigned long);

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

