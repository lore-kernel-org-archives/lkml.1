Return-Path: <linux-kernel-owner+w=401wt.eu-S1753898AbYKKVK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbYKKVK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 16:10:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbYKKVKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 16:10:19 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41445 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbYKKVKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 16:10:18 -0500
Date: Tue, 11 Nov 2008 16:10:16 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Masami Hiramatsu <mhiramat@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, David Miller <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: [PATCH 6/7] module: Add MODULE_STATE_LIVE notify
In-Reply-To: <4919F1B9.3060300@redhat.com>
Message-ID: <alpine.DEB.1.10.0811111608410.3275@gandalf.stny.rr.com>
References: <4919F1B9.3060300@redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 11 Nov 2008, Masami Hiramatsu wrote:

> Add a module notifier call which notifies that the state of a module changes
> from MODULE_STATE_COMING to MODULE_STATE_LIVE.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> ---
>  kernel/module.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Steven, Ananth told me that this patch might also help to solve
> cmpxchg problem.

I'm assuming you are talking about the infamous e1000e ftrace cmpxchg
corruption bug?

In anycase, ftrace has already solved those issues, and does not use 
cmpxchg anymore.

Thanks anyway,

-- Steve


> 
> Index: 2.6.28-rc4/kernel/module.c
> ===================================================================
> --- 2.6.28-rc4.orig/kernel/module.c
> +++ 2.6.28-rc4/kernel/module.c
> @@ -2346,6 +2346,8 @@ sys_init_module(void __user *umod,
>  	/* Now it's a first class citizen!  Wake up anyone waiting for it. */
>  	mod->state = MODULE_STATE_LIVE;
>  	wake_up(&module_wq);
> +	blocking_notifier_call_chain(&module_notify_list,
> +				     MODULE_STATE_LIVE, mod);
> 
>  	mutex_lock(&module_mutex);
>  	/* Drop initial reference. */
> 
> -- 
> Masami Hiramatsu
> 
> Software Engineer
> Hitachi Computer Products (America) Inc.
> Software Solutions Division
> 
> e-mail: mhiramat@redhat.com
> 
> 
> 
