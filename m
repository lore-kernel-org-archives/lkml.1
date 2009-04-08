Return-Path: <linux-kernel-owner+w=401wt.eu-S932539AbZDHLzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932539AbZDHLzk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764624AbZDHLbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:31:38 -0400
Received: from mail-gx0-f160.google.com ([209.85.217.160]:33603 "EHLO
	mail-gx0-f160.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764577AbZDHLbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:31:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jzgyzqF4yIJsatgz4HIfbzRGdJQRKtxyYe9PBXDwPfRlTczmwDILz3MDbQWzTEPwlX
         FcrsuDUEBrXwHP93oSkIt41+WrImAD6DlZnVecH4Z1TOMeNA7dQFhIbgQtG4P3lJQG1k
         LJU7E2AY2o5M6WshW/Rml03dyiiUaruXwmyaw=
Date: Wed, 8 Apr 2009 13:31:30 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ftrace: Output REC->var instead of __entry->var
	for trace format
Message-ID: <20090408113129.GA6285@nowhere>
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

Nice catch!
The other patch that expands stringify to multiple args looks good too.

