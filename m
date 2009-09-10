Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbZIJBsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbZIJBsL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 21:48:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbZIJBsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 21:48:10 -0400
Received: from mail-ew0-f217.google.com ([209.85.219.217]:44520 "EHLO
	mail-ew0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbZIJBsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 21:48:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jRn/KywSaFyd+pzKLyCKQUJ/aUfzysU2F0BSdfdeOeMCfJ57s3EgSAod0WgGkViTt9
         XdG9r78BlbzywS/RUJgQ/A/yCcGIab35Ja0Ga39FEYiqz0XPXcMi6v16bpaQSK9J+HHY
         tI5w5UoT/RKxKh3VgxALil9Yne4wAFxnGpmuI=
Date: Thu, 10 Sep 2009 03:48:10 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ksym_tracer: Remove KSYM_SELFTEST_ENTRY
Message-ID: <20090910014808.GB8450@nowhere>
References: <4AA857D8.9020906@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AA857D8.9020906@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10, 2009 at 09:35:20AM +0800, Li Zefan wrote:
> The macro used to be used in both trace_selftest.c and
> trace_ksym.c, but no longer, so remove it from header file.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>



Steve, I should better take this one. I'm currently working
on the breakpoint tree and I prepare a pull request so I can
bring it inside.

Thanks.


> ---
>  kernel/trace/trace.h          |    1 -
>  kernel/trace/trace_selftest.c |    2 +-
>  2 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 76ed0db..e6b1c73 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -202,7 +202,6 @@ struct syscall_trace_exit {
>  	unsigned long		ret;
>  };
>  
> -#define KSYM_SELFTEST_ENTRY "ksym_selftest_dummy"
>  extern int process_new_ksym_entry(char *ksymname, int op, unsigned long addr);
>  
>  struct ksym_trace_entry {
> diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
> index 7179c12..a006f00 100644
> --- a/kernel/trace/trace_selftest.c
> +++ b/kernel/trace/trace_selftest.c
> @@ -828,7 +828,7 @@ trace_selftest_startup_ksym(struct tracer *trace, struct trace_array *tr)
>  
>  	ksym_selftest_dummy = 0;
>  	/* Register the read-write tracing request */
> -	ret = process_new_ksym_entry(KSYM_SELFTEST_ENTRY, HW_BREAKPOINT_RW,
> +	ret = process_new_ksym_entry("ksym_selftest_dummy", HW_BREAKPOINT_RW,
>  					(unsigned long)(&ksym_selftest_dummy));
>  
>  	if (ret < 0) {
> -- 
> 1.6.3

