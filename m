Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbYKXWId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbYKXWId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 17:08:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbYKXWIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 17:08:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48618 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbYKXWIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 17:08:23 -0500
Date: Mon, 24 Nov 2008 17:08:21 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] tracing/function-return-tracer: Support for dynamic
 ftrace on function return tracer
In-Reply-To: <491FA94E.9090207@gmail.com>
Message-ID: <alpine.DEB.1.10.0811241707240.907@gandalf.stny.rr.com>
References: <491FA94E.9090207@gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 16 Nov 2008, Frederic Weisbecker wrote:
>  
>  static void ftrace_replace_code(int enable)
> @@ -1405,10 +1417,17 @@ int register_ftrace_function(struct ftrace_ops *ops)
>  		return -1;
>  
>  	mutex_lock(&ftrace_sysctl_lock);
> +
> +	if (ftrace_tracing_type == FTRACE_TYPE_RETURN) {
> +		ret = -EBUSY;
> +		goto out;
> +	}
> +

Why do we need to disable all new tracing functions when we do return 
tracing??

-- Steve

>  	ret = __register_ftrace_function(ops);
>  	ftrace_startup();
> -	mutex_unlock(&ftrace_sysctl_lock);
>  
> +out:
> +	mutex_unlock(&ftrace_sysctl_lock);
>  	return ret;
>  }
>  
