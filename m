Return-Path: <linux-kernel-owner+w=401wt.eu-S1755939AbYKOSKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbYKOSKh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 13:10:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbYKOSK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 13:10:29 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45801 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822AbYKOSK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 13:10:28 -0500
Message-ID: <491F107E.4070702@redhat.com>
Date: Sat, 15 Nov 2008 13:10:06 -0500
From: Steven Rostedt <srostedt@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
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

The unknown reason was that my PPC64 failed to compile without it ;-) It 
was unknown because I forgot to mention that in the change log (my bad).

On Monday, I'll apply this patch and make sure that my PPC64 still compiles.

-- Steve

> We are removing it because:
>
> 1. It generates e500 kernels that don't work
> 2. its not the correct set of flags to do this
> 3. we handle this in the arch/powerpc/Makefile already
> 4. its unknown in talking to Steven why he did this
>
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

