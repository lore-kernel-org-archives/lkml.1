Return-Path: <linux-kernel-owner+w=401wt.eu-S1754084AbYK1DxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbYK1DxQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 22:53:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbYK1Dw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 22:52:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64108 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548AbYK1Dw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 22:52:59 -0500
Date: Thu, 27 Nov 2008 22:52:56 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: walimis <walimisdev@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ftrace: improve document
In-Reply-To: <1227839561-8694-1-git-send-email-walimisdev@gmail.com>
Message-ID: <alpine.DEB.1.10.0811272251180.7113@gandalf.stny.rr.com>
References: <20081127162117.GA3467@elte.hu> <1227839561-8694-1-git-send-email-walimisdev@gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 28 Nov 2008, walimis wrote:

> Impact: add notice of using wild cards correctly
> 
> We know that we can use wild cards to set set_ftrace_filter, but there's
> problem when using such as "echo h* > /debug/tracing/set_ftrace_filter".
> If there are files named with "h" prefix in current directory, echo "h*"
> will echo these files' name to set_ftrace_filter, not "h*".
> For example:
> $cat /debug/tracing/available_filter_functions |grep ^hr |wc -l
> 23
> $ls
> $touch hraa hrdd
> $ls
> hraa  hrdd
> $echo hr* > /debug/tracing/set_ftrace_filter
> $cat /debug/tracing/set_ftrace_filter
> 
> No output in /debug/tracing/set_ftrace_filter!
> If we use '' to enclose wild cards, it works:
> 
> $ls
> hraa  hrdd
> $echo "hr*" > /debug/tracing/set_ftrace_filter
> $cat /debug/tracing/set_ftrace_filter |wc -l
> 23
> 
> This problem can lead to unexpected result if current directory has a
> lot of files.
> 
> Signed-off-by: walimis <walimisdev@gmail.com>
> Reviewed-by: Ingo Molnar <mingo@elte.hu>
> ---
>  Documentation/ftrace.txt |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/ftrace.txt b/Documentation/ftrace.txt
> index de05042..0012a4a 100644
> --- a/Documentation/ftrace.txt
> +++ b/Documentation/ftrace.txt
> @@ -1251,7 +1251,10 @@ These are the only wild cards which are supported.
>  
>    <match>*<match> will not work.
>  
> - # echo hrtimer_* > /debug/tracing/set_ftrace_filter
> +Note: you'd better to use '' to enclose wild cards, otherwise in some
> +cases you can't get the correct result.

The above sounds awkward, perhaps something like:

 Note: It is better to use quotes to enclose the wild cards, otherwise
  the shell may expand the parameters into names of files in the local
  directory.

-- Steve



> +
> + # echo 'hrtimer_*' > /debug/tracing/set_ftrace_filter
>  
>  Produces:
>  
> @@ -1306,7 +1309,7 @@ Again, now we want to append.
>   # echo sys_nanosleep > /debug/tracing/set_ftrace_filter
>   # cat /debug/tracing/set_ftrace_filter
>  sys_nanosleep
> - # echo hrtimer_* >> /debug/tracing/set_ftrace_filter
> + # echo 'hrtimer_*' >> /debug/tracing/set_ftrace_filter
>   # cat /debug/tracing/set_ftrace_filter
>  hrtimer_run_queues
>  hrtimer_run_pending
> -- 
> 1.6.0.3
> 
> 
> 
