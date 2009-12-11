Return-Path: <linux-kernel-owner+w=401wt.eu-S1761910AbZLKAUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761910AbZLKAUB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 19:20:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757980AbZLKAT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 19:19:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34126 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757766AbZLKAT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 19:19:58 -0500
X-Authority-Analysis: v=1.0 c=1 a=pgEMfFjABqMA:10 a=7U3hwN5JcxgA:10 a=meVymXHHAAAA:8 a=omOdbC7AAAAA:8 a=onUY2Jp8L_EgsajZC6oA:9 a=BwnfpuYNADI7v2vK2JETcNl8lEcA:4 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 04/10] tracing: __dynamic_array() also defines fields
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B1F4E92.1090608@cn.fujitsu.com>
References: <4B1F4E92.1090608@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 10 Dec 2009 19:20:03 -0500
Message-ID: <1260490803.2146.311.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-09 at 15:15 +0800, Lai Jiangshan wrote:
> dynamic array is also added to struct ftrace_event_call->fields.

Could you add to the change log which events use it. I see bprint and
print. But this change log is still lacking. It should explain what
features this fixes.

But as for the patch itself:

Acked-by: Steven Rostedt <rostedt@goodmis.org>

Thanks,

-- Steve



> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
> index 458e5bf..511bc36 100644
> --- a/kernel/trace/trace_export.c
> +++ b/kernel/trace/trace_export.c
> @@ -174,7 +174,12 @@ ftrace_format_##name(struct ftrace_event_call *unused,			\
>  		return ret;
>  
>  #undef __dynamic_array
> -#define __dynamic_array(type, item)
> +#define __dynamic_array(type, item)					\
> +	ret = trace_define_field(event_call, #type, #item,		\
> +				 offsetof(typeof(field), item),		\
> +				 0, is_signed_type(type), FILTER_OTHER);\
> +	if (ret)							\
> +		return ret;
>  
>  #undef FTRACE_ENTRY
>  #define FTRACE_ENTRY(name, struct_name, id, tstruct, print)		\
> 
> 


