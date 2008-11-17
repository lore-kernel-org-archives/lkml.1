Return-Path: <linux-kernel-owner+w=401wt.eu-S1752816AbYKQUxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbYKQUxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 15:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbYKQUxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 15:53:03 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59558 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620AbYKQUxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 15:53:01 -0500
Message-ID: <4921D973.7010208@redhat.com>
Date: Mon, 17 Nov 2008 15:52:03 -0500
From: Steven Rostedt <srostedt@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH][for 2.6.28] Remove -mno-spe flags as they dont belong
References: <1226772154-6109-1-git-send-email-galak@kernel.crashing.org>
In-Reply-To: <1226772154-6109-1-git-send-email-galak@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala wrote:
> For some unknown reason at Steven Rostedt added in disabling of the SPE
> instruction generation for e500 based PPC cores in commit
> 6ec562328fda585be2d7f472cfac99d3b44d362a.
>
> We are removing it because:
>
> 1. It generates e500 kernels that don't work
> 2. its not the correct set of flags to do this
> 3. we handle this in the arch/powerpc/Makefile already
> 4. its unknown in talking to Steven why he did this
>
>   

I just tested this change on both my PPC64 and my 32bit Powerbook.

Tested-and-Acked-by: Steven Rostedt <srostedt@redhat.com>

-- Steve

> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
> ---
>  kernel/Makefile |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/Makefile b/kernel/Makefile
> index 9a3ec66..19fad00 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -11,8 +11,6 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o \
>  	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
>  	    notifier.o ksysfs.o pm_qos_params.o sched_clock.o
>  
> -CFLAGS_REMOVE_sched.o = -mno-spe
> -
>  ifdef CONFIG_FUNCTION_TRACER
>  # Do not trace debug files and internal ftrace files
>  CFLAGS_REMOVE_lockdep.o = -pg
> @@ -21,7 +19,7 @@ CFLAGS_REMOVE_mutex-debug.o = -pg
>  CFLAGS_REMOVE_rtmutex-debug.o = -pg
>  CFLAGS_REMOVE_cgroup-debug.o = -pg
>  CFLAGS_REMOVE_sched_clock.o = -pg
> -CFLAGS_REMOVE_sched.o = -mno-spe -pg
> +CFLAGS_REMOVE_sched.o = -pg
>  endif
>  
>  obj-$(CONFIG_FREEZER) += freezer.o
>   

