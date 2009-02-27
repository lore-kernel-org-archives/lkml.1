Return-Path: <linux-kernel-owner+w=401wt.eu-S1760471AbZB0Uiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760471AbZB0Uiy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 15:38:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760505AbZB0Ugd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 15:36:33 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59686 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760479AbZB0Ugc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 15:36:32 -0500
Date: Fri, 27 Feb 2009 15:36:28 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Luis Henriques <henrix@sapo.pt>
cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] tracing: remove unused code
In-Reply-To: <20090227202923.GA3826@hades.domain.com>
Message-ID: <alpine.DEB.2.00.0902271535440.13395@gandalf.stny.rr.com>
References: <20090227202923.GA3826@hades.domain.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks Luis,

But before I remove this code, I want to move it to be activated by 
tracing options. The irqsoff tracer (and other latency tracers) are pretty 
useless without it.

-- Steve


On Fri, 27 Feb 2009, Luis Henriques wrote:

> struct file_operations tracing_lt_fops and tracing_lt_open are not used
> anywhere.  These are legacy from the /debug/tracing/latency_trace, which has
> been removed in commit 886b5b73d71e4027d7dc6c14f5f7ab102201ea6b
> 
> Signed-off-by: Luis Henriques <henrix@sapo.pt>
> ---
>  kernel/trace/trace.c |   22 ----------------------
>  1 files changed, 0 insertions(+), 22 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 5db7485..04306a1 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -1822,21 +1822,6 @@ static int tracing_open(struct inode *inode, struct file *file)
>  	return ret;
>  }
>  
> -static int tracing_lt_open(struct inode *inode, struct file *file)
> -{
> -	struct trace_iterator *iter;
> -	int ret = 0;
> -
> -	iter = __tracing_open(inode, file);
> -
> -	if (IS_ERR(iter))
> -		ret = PTR_ERR(iter);
> -	else
> -		iter->iter_flags |= TRACE_FILE_LAT_FMT;
> -
> -	return ret;
> -}
> -
>  
>  static void *
>  t_next(struct seq_file *m, void *v, loff_t *pos)
> @@ -1916,13 +1901,6 @@ static struct file_operations tracing_fops = {
>  	.release	= tracing_release,
>  };
>  
> -static struct file_operations tracing_lt_fops = {
> -	.open		= tracing_lt_open,
> -	.read		= seq_read,
> -	.llseek		= seq_lseek,
> -	.release	= tracing_release,
> -};
> -
>  static struct file_operations show_traces_fops = {
>  	.open		= show_traces_open,
>  	.read		= seq_read,
> -- 
> 1.6.1.3
> 
> 
