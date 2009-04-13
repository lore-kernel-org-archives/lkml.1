Return-Path: <linux-kernel-owner+w=401wt.eu-S1752472AbZDMO2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472AbZDMO2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 10:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751701AbZDMO2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 10:28:23 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:23842 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbZDMO2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 10:28:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Sh1+dR0BQzgBvg0QmYxX3qQEOeY0Bl3+p233J5dDG4NZ7Mx+XIj7O9K76emHP0eGFo
         ED7I/z+G6bbhCLn//I5uIymdAPIEco3k5UUYxiA21KBqyYc9+HBK1sm8U4Op2YufibcR
         glJ9tLtoJan22mHI1xE5yDxnDfAVKGCTKG0SQ=
Date: Mon, 13 Apr 2009 16:28:18 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] tracing, syscalltrace: Move
	include/trace/syscall.h to include/linux/syscalltrace.h
Message-ID: <20090413142817.GD5977@nowhere>
References: <49E2B763.8060706@cn.fujitsu.com> <49E2B7BF.6000601@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E2B7BF.6000601@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 13, 2009 at 11:55:43AM +0800, Zhaolei wrote:
> Impact: refactor code, no functionality changed
> 
> Files in include/trace/ should be definition of tracepoints, and header
> file for syscall trace should put to include/linux/.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---


Same than for boot tracer change.
I'm fine with it if you prefer that the role of include/trace/* gains
more strict limitations, but I would like to know the opinion of tracing
maintainers.

Thanks,
Frederic.


>  arch/x86/kernel/ftrace.c                          |    3 +--
>  arch/x86/kernel/ptrace.c                          |    3 +--
>  include/linux/syscalls.h                          |    2 +-
>  include/{trace/syscall.h => linux/syscalltrace.h} |    0 
>  kernel/trace/trace_syscalls.c                     |    2 +-
>  5 files changed, 4 insertions(+), 6 deletions(-)
>  rename include/{trace/syscall.h => linux/syscalltrace.h} (100%)
> 
> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> index 18dfa30..63ab16e 100644
> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -17,8 +17,7 @@
>  #include <linux/sched.h>
>  #include <linux/init.h>
>  #include <linux/list.h>
> -
> -#include <trace/syscall.h>
> +#include <linux/syscalltrace.h>
>  
>  #include <asm/cacheflush.h>
>  #include <asm/ftrace.h>
> diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
> index d5252ae..25428a9 100644
> --- a/arch/x86/kernel/ptrace.c
> +++ b/arch/x86/kernel/ptrace.c
> @@ -22,6 +22,7 @@
>  #include <linux/seccomp.h>
>  #include <linux/signal.h>
>  #include <linux/workqueue.h>
> +#include <linux/syscalltrace.h>
>  
>  #include <asm/uaccess.h>
>  #include <asm/pgtable.h>
> @@ -35,8 +36,6 @@
>  #include <asm/proto.h>
>  #include <asm/ds.h>
>  
> -#include <trace/syscall.h>
> -
>  #include "tls.h"
>  
>  enum x86_regset {
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index 35bbf67..3c207e9 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -66,7 +66,7 @@ struct perf_counter_hw_event;
>  #include <asm/signal.h>
>  #include <linux/quota.h>
>  #include <linux/key.h>
> -#include <trace/syscall.h>
> +#include <linux/syscalltrace.h>
>  
>  #define __SC_DECL1(t1, a1)	t1 a1
>  #define __SC_DECL2(t2, a2, ...) t2 a2, __SC_DECL1(__VA_ARGS__)
> diff --git a/include/trace/syscall.h b/include/linux/syscalltrace.h
> similarity index 100%
> rename from include/trace/syscall.h
> rename to include/linux/syscalltrace.h
> diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> index 5e57964..ab00bc5 100644
> --- a/kernel/trace/trace_syscalls.c
> +++ b/kernel/trace/trace_syscalls.c
> @@ -1,4 +1,4 @@
> -#include <trace/syscall.h>
> +#include <linux/syscalltrace.h>
>  #include <linux/kernel.h>
>  #include <asm/syscall.h>
>  
> -- 
> 1.5.5.3
> 
> 

