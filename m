Return-Path: <linux-kernel-owner+w=401wt.eu-S1754314AbZLHLza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbZLHLza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 06:55:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754122AbZLHLz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 06:55:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754098AbZLHLz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 06:55:29 -0500
Message-ID: <4B1E3F33.2090004@redhat.com>
Date: Tue, 08 Dec 2009 06:57:39 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [GIT PULL] tracing/kprobes: Fix field creation's bad error handling
References: <1260263815-5167-1-git-send-regression-fweisbec@gmail.com>
In-Reply-To: <1260263815-5167-1-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> Ingo,
> 
> Please pull the tracing/fixes branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	tracing/fixes
> 
> Thanks,
> 	Frederic
> ---
> 
> Frederic Weisbecker (1):
>       tracing/kprobes: Fix field creation's bad error handling
> 
> 
>  kernel/trace/trace_kprobe.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> ---
> From 12e22dfaaee46f70762beb1982a7b86a68317b11 Mon Sep 17 00:00:00 2001
> From: Frederic Weisbecker <fweisbec@gmail.com>
> Date: Tue, 8 Dec 2009 10:00:04 +0100
> Subject: [PATCH] tracing/kprobes: Fix field creation's bad error handling
> Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>
> 
> When we define the common event fields in kprobe, we invert the error
> handling and return immediately in case of success. Then we omit
> to define specific kprobes fields (ip and nargs), and specific
> kretprobes fields (func, ret_ip, nargs). And we only define them
> when we fail to create common fields.
> 
> The most visible consequence is that we can't create filter for
> k(ret)probes specific fields.
> 
> This patch re-invert the success/error handling to fix it.
> 
> Reported-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Li Zefan <lizf@cn.fujitsu.com>

Thanks for fix that.

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>


Ingo, I think this should go to tip:urgent.

Thank you,

> ---
>  kernel/trace/trace_kprobe.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index aff5f80..ca04523 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -1114,7 +1114,7 @@ static int kprobe_event_define_fields(struct ftrace_event_call *event_call)
>  	struct trace_probe *tp = (struct trace_probe *)event_call->data;
>  
>  	ret = trace_define_common_fields(event_call);
> -	if (!ret)
> +	if (ret)
>  		return ret;
>  
>  	DEFINE_FIELD(unsigned long, ip, FIELD_STRING_IP, 0);
> @@ -1132,7 +1132,7 @@ static int kretprobe_event_define_fields(struct ftrace_event_call *event_call)
>  	struct trace_probe *tp = (struct trace_probe *)event_call->data;
>  
>  	ret = trace_define_common_fields(event_call);
> -	if (!ret)
> +	if (ret)
>  		return ret;
>  
>  	DEFINE_FIELD(unsigned long, func, FIELD_STRING_FUNC, 0);

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

