Return-Path: <linux-kernel-owner+w=401wt.eu-S1758258AbZCWSqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758258AbZCWSqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 14:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbZCWSqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 14:46:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:49518 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbZCWSq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 14:46:29 -0400
Date: Mon, 23 Mar 2009 14:46:27 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/function-graph-tracer: don't profile branches
 on graph tracer
In-Reply-To: <1237741289-14926-1-git-send-email-fweisbec@gmail.com>
Message-ID: <alpine.DEB.2.00.0903231446020.3578@gandalf.stny.rr.com>
References: <1237741289-14926-1-git-send-email-fweisbec@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 22 Mar 2009, Frederic Weisbecker wrote:

> Impact: fix slow tracing
> 
> The core kernel tracing is protected against soft branch profiling, but
> not the x86 ftrace arch part. Let's fix it.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  arch/x86/kernel/Makefile |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> index 599e9a7..8d9b3f9 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -13,6 +13,7 @@ CFLAGS_REMOVE_rtc.o = -pg
>  CFLAGS_REMOVE_paravirt-spinlocks.o = -pg
>  CFLAGS_REMOVE_ftrace.o = -pg
>  CFLAGS_REMOVE_early_printk.o = -pg
> +CFLAGS_ftrace.o += -DDISABLE_BRANCH_PROFILING
>  endif
>  

Actually, I prefer not to do this. I do use the branch profiling on 
ftrace, to see where the hot paths are.

-- Steve

