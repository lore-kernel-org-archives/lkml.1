Return-Path: <linux-kernel-owner+w=401wt.eu-S1754683AbYLNREj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683AbYLNREj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 12:04:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbYLNREa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 12:04:30 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:59800 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387AbYLNRE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 12:04:29 -0500
Date: Sun, 14 Dec 2008 12:04:26 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/ftrace: add the printk-msg-only option
In-Reply-To: <49440A75.301@gmail.com>
Message-ID: <alpine.DEB.1.10.0812141200230.20467@gandalf.stny.rr.com>
References: <49440A75.301@gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 13 Dec 2008, Frederic Weisbecker wrote:

> Impact: display ftrace_printk messages "as is"
> 
> By default, ftrace_printk() messages find their output with some other
> informations like pid, caller, ...
> Sometimes a developer just want to have the ftrace_printk left "as is", without
> other information.
> 
> This is done by providing a default-off option called printk-msg-only.
> To enable it, just do `echo printk-msg-only > /debugfs/tracing/trace_options`
> 
> Before the patch:
> 
>            <...>-2739  [000]   145.692153: __might_sleep: I'm an ftrace_printk msg in __might_sleep
>            <...>-2739  [000]   145.692155: __might_sleep: I'm another ftrace_printk msg in __might_sleep
> 
> After the patch and the printk-msg-only option enabled:
> 
> I'm an ftrace_printk msg in __might_sleep
> I'm another ftrace_printk msg in __might_sleep
> 
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 8fd3c5a..cd4dbf2 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -287,6 +287,7 @@ static const char *trace_options[] = {
>  	"annotate",
>  	"userstacktrace",
>  	"sym-userobj",
> +	"printk-msg-only",

Hmm, I'm a bit apprehensive about this approach. We are adding a lot of 
options that I'm not sure will be used. Is this needed because you added a 
ftrace printk that you want to not have the header, or because there are 
ftrace printks that exist that you want to turn on and off. Or perhaps, 
you want to see the header sometimes and sometimes you do not?

If it is the later two, then sure we could have this option. But if it is 
the former, then we probably should have another type of ftrace_printk 
that takes an option to make another event type to tell the output not to 
print?

Oh well, I have patches in mind to clean up the output code anyway.

-- Steve
