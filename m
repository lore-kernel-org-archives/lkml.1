Return-Path: <linux-kernel-owner+w=401wt.eu-S933085AbZDHLy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933085AbZDHLy2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764689AbZDHLaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:30:10 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:3563 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764678AbZDHLaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:30:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jg6pYPm6cxiAC/hvXGzrx0VsQqadfEMYR++igp8LVzrxSjutom6RnnGLDFkGFUH0Mw
         p9KZUbVxZD3n10TXXWAkMlQ4sGUE3uk1jsMWFMMQEC0cB1Zl6dGDBaKKa4N5UshDi4/R
         J1su3RDdyLZpGJo1fc8n8GvKx8Gjv8ZEJjALw=
Date: Wed, 8 Apr 2009 13:29:07 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ftrace: Output REC->var instead of __entry->var
	for trace format
Message-ID: <20090408112906.GB6005@nowhere>
References: <49DC6751.30308@cn.fujitsu.com> <49DC679D.2090901@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49DC679D.2090901@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 05:00:13PM +0800, Zhaolei wrote:
> print fmt: "irq=%d return=%s", __entry->irq, __entry->ret ? \"handled\" : \"unhandled\"
> 
> "__entry" should be convert to "REC" by __stringify() macro.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---
>  kernel/trace/trace_events_stage_2.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace_events_stage_2.h b/kernel/trace/trace_events_stage_2.h
> index 9e47c39..d694a8a 100644
> --- a/kernel/trace/trace_events_stage_2.h
> +++ b/kernel/trace/trace_events_stage_2.h
> @@ -108,10 +108,10 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
>  		return 0;
>  
>  #undef __entry
> -#define __entry "REC"
> +#define __entry REC
>  
>  #undef TP_printk
> -#define TP_printk(fmt, args...) "%s, %s\n", #fmt, #args
> +#define TP_printk(fmt, args...) "%s, %s\n", #fmt, __stringify(args)
>  
>  #undef TRACE_EVENT
>  #define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
> -- 
> 1.5.5.3
> 
> 


Ah indeed nice catch.
The patch that expands stringify to multiple args looks good too.

