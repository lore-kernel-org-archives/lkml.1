Return-Path: <linux-kernel-owner+w=401wt.eu-S1755241AbZC0MVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbZC0MVc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 08:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895AbZC0MVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 08:21:23 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:40624 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbZC0MVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 08:21:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=P0fsYcwGQ6EP1EMgQzJJUAARQo0MBvT5hrKJf6mrdcwnFqLKfRRjddRc5pPw/W2F+8
         MFZsmgdwbkYpH40qGjp3w/5Ilplo0ZEyhMAywRCECTa9vsXeWRGgCRK/dv3w/0mHWzyK
         xxAy7oPndOIkGubCEchLlDeqkCTfQFcBnCiPI=
Date: Fri, 27 Mar 2009 13:21:14 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: kill some magic numbers
Message-ID: <20090327122113.GD5976@nowhere>
References: <49CC7870.9000309@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49CC7870.9000309@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 27, 2009 at 02:55:44PM +0800, Li Zefan wrote:
> Impact: cleanup
> 
> Use USEC_PER_SEC and NSEC_PER_SEC instead of 1000000 and 1000000000.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/trace/trace_boot.c      |    5 +++--
>  kernel/trace/trace_mmiotrace.c |    6 ++++--
>  2 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
> index 7a30fc4..a29ef23 100644
> --- a/kernel/trace/trace_boot.c
> +++ b/kernel/trace/trace_boot.c
> @@ -9,6 +9,7 @@
>  #include <linux/debugfs.h>
>  #include <linux/ftrace.h>
>  #include <linux/kallsyms.h>
> +#include <linux/time.h>
>  
>  #include "trace.h"
>  #include "trace_output.h"
> @@ -67,7 +68,7 @@ initcall_call_print_line(struct trace_iterator *iter)
>  	trace_assign_type(field, entry);
>  	call = &field->boot_call;
>  	ts = iter->ts;
> -	nsec_rem = do_div(ts, 1000000000);
> +	nsec_rem = do_div(ts, NSEC_PER_SEC);
>  
>  	ret = trace_seq_printf(s, "[%5ld.%09ld] calling  %s @ %i\n",
>  			(unsigned long)ts, nsec_rem, call->func, call->caller);
> @@ -92,7 +93,7 @@ initcall_ret_print_line(struct trace_iterator *iter)
>  	trace_assign_type(field, entry);
>  	init_ret = &field->boot_ret;
>  	ts = iter->ts;
> -	nsec_rem = do_div(ts, 1000000000);
> +	nsec_rem = do_div(ts, NSEC_PER_SEC);
>  
>  	ret = trace_seq_printf(s, "[%5ld.%09ld] initcall %s "
>  			"returned %d after %llu msecs\n",
> diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
> index 8e37fcd..d53b45e 100644
> --- a/kernel/trace/trace_mmiotrace.c
> +++ b/kernel/trace/trace_mmiotrace.c
> @@ -9,6 +9,8 @@
>  #include <linux/kernel.h>
>  #include <linux/mmiotrace.h>
>  #include <linux/pci.h>
> +#include <linux/time.h>
> +
>  #include <asm/atomic.h>
>  
>  #include "trace.h"
> @@ -174,7 +176,7 @@ static enum print_line_t mmio_print_rw(struct trace_iterator *iter)
>  	struct mmiotrace_rw *rw;
>  	struct trace_seq *s	= &iter->seq;
>  	unsigned long long t	= ns2usecs(iter->ts);
> -	unsigned long usec_rem	= do_div(t, 1000000ULL);
> +	unsigned long usec_rem	= do_div(t, USEC_PER_SEC);
>  	unsigned secs		= (unsigned long)t;
>  	int ret = 1;
>  
> @@ -221,7 +223,7 @@ static enum print_line_t mmio_print_map(struct trace_iterator *iter)
>  	struct mmiotrace_map *m;
>  	struct trace_seq *s	= &iter->seq;
>  	unsigned long long t	= ns2usecs(iter->ts);
> -	unsigned long usec_rem	= do_div(t, 1000000ULL);
> +	unsigned long usec_rem	= do_div(t, USEC_PER_SEC);
>  	unsigned secs		= (unsigned long)t;
>  	int ret;
>  
> -- 
> 1.5.4.rc3


Thanks!

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

