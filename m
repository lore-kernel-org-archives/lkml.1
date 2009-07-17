Return-Path: <linux-kernel-owner+w=401wt.eu-S1752937AbZGQEo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbZGQEo2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 00:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbZGQEo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 00:44:27 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:13538 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbZGQEo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 00:44:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LN/UtP3sdKgqzqWsDnGeGwX+wrXDnSH7CcDJcNRr8VILOGB0EsDfE0PBAu/6TG8R/w
         v1cwNWdaUN8ds7t0FrNKnYR6SsuxA7zqhthCb1z+iyKgMztsTxEc0TisqX/zHlF5M3pP
         FzKiuKrsNnHEt6+F2fjVpxQNYClEKN3SMGfTY=
Date: Fri, 17 Jul 2009 00:44:19 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] tracing/events: add missing type info of dynamic
	arrays
Message-ID: <20090717044418.GD4977@nowhere>
References: <4A5E9604.2030103@cn.fujitsu.com> <4A5E962E.9020900@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A5E962E.9020900@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 10:53:34AM +0800, Li Zefan wrote:
> From: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> The format file doesn't contain enough information for
> __dynamic_array/__string. The type name is missing.
> 
> Before:
>   # cat format:
>   name: irq_handler_entry
>   ...
>           field:__data_loc name;  offset:16;      size:2;
> 
> After:
>   # cat format:
>   name: irq_handler_entry
>   ...
>           field:__data_loc char[] name;  offset:16;      size:2;
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>


Looks good to me, but I'd prefer to wait for Steve Ack, since he wasn't
sure...

Thanks.


> ---
>  include/trace/ftrace.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index 1867553..cc78943 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -120,7 +120,7 @@
>  
>  #undef __dynamic_array
>  #define __dynamic_array(type, item, len)				       \
> -	ret = trace_seq_printf(s, "\tfield:__data_loc " #item ";\t"	       \
> +	ret = trace_seq_printf(s, "\tfield:__data_loc " #type "[] " #item ";\t"\
>  			       "offset:%u;\tsize:%u;\n",		       \
>  			       (unsigned int)offsetof(typeof(field),	       \
>  					__data_loc_##item),		       \
> @@ -279,7 +279,7 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
>  
>  #undef __dynamic_array
>  #define __dynamic_array(type, item, len)				       \
> -	ret = trace_define_field(event_call, "__data_loc" "[" #type "]", #item,\
> +	ret = trace_define_field(event_call, "__data_loc " #type "[]", #item,  \
>  				offsetof(typeof(field), __data_loc_##item),    \
>  				 sizeof(field.__data_loc_##item), 0);
>  
> -- 1.6.3 

