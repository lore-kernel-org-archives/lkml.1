Return-Path: <linux-kernel-owner+w=401wt.eu-S1757163AbZF2LNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163AbZF2LNo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 07:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbZF2LNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 07:13:36 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:41192 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbZF2LNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 07:13:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=F1A7+yDZAOPg1V1GSFOpNkpEIghbI5I6ge64nRK7x4vMSAgX26HH/YGllYjI7oI/cg
         3cTzlQ1yJkHZ290p21EltfjQjmT4npkg63+GlZZ4OhwnX9le6W2CPraPAv7xcWSlrl6P
         SRptSDWVAEazaAq18V1mLAkUDMw26tETFbRXo=
Date: Mon, 29 Jun 2009 13:13:36 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/syscall: remove redundant code
Message-ID: <20090629111334.GA6265@nowhere>
References: <4A488667.6040004@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A488667.6040004@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 05:16:23PM +0800, Xiao Guangrong wrote:
> No need to call trace_wake_up() explicitly because it's called
> in trace_current_buffer_unlock_commit().
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  kernel/trace/trace_syscalls.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> index 5e57964..dd1ce2c 100644
> --- a/kernel/trace/trace_syscalls.c
> +++ b/kernel/trace/trace_syscalls.c
> @@ -168,7 +168,6 @@ void ftrace_syscall_enter(struct pt_regs *regs)
>  	syscall_get_arguments(current, regs, 0, sys_data->nb_args, entry->args);
>  
>  	trace_current_buffer_unlock_commit(event, 0, 0);
> -	trace_wake_up();
>  }
>  
>  void ftrace_syscall_exit(struct pt_regs *regs)
> @@ -194,7 +193,6 @@ void ftrace_syscall_exit(struct pt_regs *regs)
>  	entry->ret = syscall_get_return_value(current, regs);
>  
>  	trace_current_buffer_unlock_commit(event, 0, 0);
> -	trace_wake_up();
>  }
>  
>  static int init_syscall_tracer(struct trace_array *tr)
> -- 
> 1.6.1.2
> 

Thanks,

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

