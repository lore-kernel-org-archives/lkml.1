Return-Path: <linux-kernel-owner+w=401wt.eu-S1760167AbYGRCwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760167AbYGRCwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 22:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbYGRCwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 22:52:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:45764 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbYGRCwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 22:52:15 -0400
Date: Thu, 17 Jul 2008 22:52:13 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git pull] tracing fixes
In-Reply-To: <20080717173210.GA12828@elte.hu>
Message-ID: <Pine.LNX.4.58.0807172249230.22792@gandalf.stny.rr.com>
References: <20080717173210.GA12828@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 17 Jul 2008, Ingo Molnar wrote:
>
> Ingo Molnar (4):
>       ftrace: fix merge buglet
>       ftrace: fix lockup with MAXSMP
>       ftrace: do not trace scheduler functions
>       ftrace: do not trace library functions
>

[...]
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -11,8 +11,6 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o profile.o \
>  	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
>  	    notifier.o ksysfs.o pm_qos_params.o sched_clock.o
>
> -CFLAGS_REMOVE_sched.o = -mno-spe
> -
>  ifdef CONFIG_FTRACE
>  # Do not trace debug files and internal ftrace files
>  CFLAGS_REMOVE_lockdep.o = -pg
> @@ -21,6 +19,7 @@ CFLAGS_REMOVE_mutex-debug.o = -pg
>  CFLAGS_REMOVE_rtmutex-debug.o = -pg
>  CFLAGS_REMOVE_cgroup-debug.o = -pg
>  CFLAGS_REMOVE_sched_clock.o = -pg
> +CFLAGS_REMOVE_sched.o = -mno-spe -pg
>  endif
>

Ingo,

Why not trace the scheduler functions? I found a lot of useful information
from seeing what functions are being called (namely the latencies caused
by the fair scheduler balancing). Not being able to trace sched.c seems to
keep a lot of useful data from being accessed.

also, is the '-mno-spe' save when ftrace is not configured?

-- Steve

