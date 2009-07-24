Return-Path: <linux-kernel-owner+w=401wt.eu-S1751866AbZGXAfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866AbZGXAfL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 20:35:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbZGXAfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 20:35:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57743 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbZGXAfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 20:35:09 -0400
Date: Thu, 23 Jul 2009 20:35:09 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Li Zefan <lizf@cn.fujitsu.com>
cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip 1/2] function-graph: fix the output of
 set_graph_function
In-Reply-To: <4A66D004.7020205@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0907232034510.8469@gandalf.stny.rr.com>
References: <4A66D004.7020205@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 22 Jul 2009, Li Zefan wrote:

> It always shows "ftrace_graph_funcs":
> 
>  # echo 'sys_open' > set_graph_function
>  # cat set_graph_function
>  ftrace_graph_funcs

Nice fix. Hmm, this probably should go into 31.

-- Steve

> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/trace/ftrace.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 24e3ff5..c6c0c07 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -2505,7 +2505,7 @@ static int g_show(struct seq_file *m, void *v)
>  		return 0;
>  	}
>  
> -	seq_printf(m, "%pf\n", v);
> +	seq_printf(m, "%pf\n", (void *)*ptr);
>  
>  	return 0;
>  }
> -- 
> 1.6.3
> 
> 
