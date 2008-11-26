Return-Path: <linux-kernel-owner+w=401wt.eu-S1753335AbYKZAX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbYKZAX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 19:23:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbYKZAXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 19:23:19 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:38869 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbYKZAXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 19:23:19 -0500
Date: Tue, 25 Nov 2008 19:23:17 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: linux-kernel@vger.kernel.org
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/3] ftrace: use code patching for ftrace return tracer
In-Reply-To: <20081125223457.162461633@goodmis.org>
Message-ID: <alpine.DEB.1.10.0811251922030.26424@gandalf.stny.rr.com>
References: <20081125223421.795046329@goodmis.org> <20081125223457.162461633@goodmis.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 25 Nov 2008, Steven Rostedt wrote:

> From: Steven Rostedt <rostedt@goodmis.org>
>  int __init ftrace_dyn_arch_init(void *data)
>  {
>  	extern const unsigned char ftrace_test_p6nop[];
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index 7854d87..73147eb 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -117,6 +117,11 @@ extern void ftrace_call(void);
>  extern void mcount_call(void);
>  #ifdef CONFIG_FUNCTION_RET_TRACER
>  extern void ftrace_return_caller(void);
> +extern int ftrace_enable_ftrace_return_caller(void);
> +extern int ftrace_disable_ftrace_return_caller(void);
> +#else
> +static inline int ftrace_enable_ftrace_return_caller(void) { }
> +static inline int ftrace_disable_ftrace_return_caller(void) { }
>  #endif
>  

This is what I get for not testing the off case :-p

The above should be:

+static inline int ftrace_enable_ftrace_return_caller(void) { return 0; }
+static inline int ftrace_disable_ftrace_return_caller(void) { return 0; }

I'll fix and push again.

-- Steve

