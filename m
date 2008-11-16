Return-Path: <linux-kernel-owner+w=401wt.eu-S1753511AbYKPPFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbYKPPFT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 10:05:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbYKPPFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 10:05:06 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34191 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbYKPPFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 10:05:06 -0500
Date: Sun, 16 Nov 2008 10:05:04 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
cc: mingo@elte.hu, akpm@linux-foundation.org, fweisbec@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix writing to trace/trace_options
In-Reply-To: <1226831883-26362-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.1.10.0811161004070.2919@gandalf.stny.rr.com>
References: <1226831883-26362-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 16 Nov 2008, Aneesh Kumar K.V wrote:

> writing to trace/trace_options use the index of the array
> to find the value of the flag. With branch tracer flag
> defined conditionally, this breaks writing to trace_options
> with branch tracer disabled.

Ug, you're right!

> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> 
> ---
>  kernel/trace/trace.c |    2 --
>  kernel/trace/trace.h |    2 --
>  2 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 004aafd..ef7fe15 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -259,9 +259,7 @@ static const char *trace_options[] = {
>  	"sched-tree",
>  	"ftrace_printk",
>  	"ftrace_preempt",
> -#ifdef CONFIG_BRANCH_TRACER
>  	"branch",

Perhaps what we need is to have this NULL if CONFIG_BRANCH_TRACER is
not set, and change the other code to skip NULL pointers.

-- Steve

> -#endif
>  	"annotate",
>  	"dump",
>  	NULL
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index b24d350..d048b63 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -481,9 +481,7 @@ enum trace_iterator_flags {
>  	TRACE_ITER_SCHED_TREE		= 0x200,
>  	TRACE_ITER_PRINTK		= 0x400,
>  	TRACE_ITER_PREEMPTONLY		= 0x800,
> -#ifdef CONFIG_BRANCH_TRACER
>  	TRACE_ITER_BRANCH		= 0x1000,
> -#endif
>  	TRACE_ITER_ANNOTATE		= 0x2000,
>  	TRACE_ITER_DUMP			= 0x4000,
>  };
> -- 
> tg: (e186e8e..) an/branch-tracer-fix.patch (depends on: an/ext4-ftrace-test.patch)
> 
> 
