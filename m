Return-Path: <linux-kernel-owner+w=401wt.eu-S1758799AbZKYMjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799AbZKYMjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 07:39:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758746AbZKYMjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 07:39:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758740AbZKYMju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 07:39:50 -0500
Message-ID: <4B0D261F.7050300@redhat.com>
Date: Wed, 25 Nov 2009 07:42:07 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] trace_kprobes: fix memory leak
References: <4B0CEB95.2060107@cn.fujitsu.com>
In-Reply-To: <4B0CEB95.2060107@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lai,

Thank you for fixing bugs!

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

Lai Jiangshan wrote:
> 
> tp->nr_args is not set before we "goto error",
> it causes memory leak for free_trace_probe() use tp->nr_args
> to free memory of args.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index 79ce6a2..82e8583 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -704,10 +704,12 @@ static int create_trace_probe(int argc, char **argv)
>  		ret = parse_probe_arg(arg, &tp->args[i].fetch, is_return);
>  		if (ret) {
>  			pr_info("Parse error at argument%d. (%d)\n", i, ret);
> +			kfree(tp->args[i].name);
>  			goto error;
>  		}
> +
> +		tp->nr_args++;
>  	}
> -	tp->nr_args = i;
>  
>  	ret = register_trace_probe(tp);
>  	if (ret)
> 
> 

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

