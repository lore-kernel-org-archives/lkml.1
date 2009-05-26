Return-Path: <linux-kernel-owner+w=401wt.eu-S1757482AbZEZTVD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbZEZTVD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 15:21:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756205AbZEZTUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 15:20:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64907 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756195AbZEZTUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 15:20:54 -0400
Date: Tue, 26 May 2009 15:20:55 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.30-rcX] Some ftrace debug option is consuming memory?
In-Reply-To: <200905250533.n4P5XGx6042820@www262.sakura.ne.jp>
Message-ID: <alpine.DEB.2.00.0905261518550.26705@gandalf.stny.rr.com>
References: <200905250533.n4P5XGx6042820@www262.sakura.ne.jp>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 25 May 2009, Tetsuo Handa wrote:

> I was running a VM with 1024MB of RAM.
> 
> I changed it to 512MB of RAM, and now I'm experiencing out of memory error.

How many virtual CPUs do you have configured?

> 
> [    2.815999] scsi: ***** BusLogic SCSI Driver Version 2.1.16 of 18 July 2002 *****
> [    2.818347] scsi: Copyright 1995-1998 by Leonard N. Zubkoff <lnz@dandelion.com>
> [    2.822849] Kernel panic - not syncing: Out of memory and no killable processes...

> 
> 2.6.29.4 can boot with 512MB of RAM.
> 2.6.30-rc1 and later cannot boot with 512MB of RAM if some debug options are
> enabled.

Did 29.4 have tracing enabled and still worked?

> 
> It seems to me that some debug option is consuming a lot of memory (enough to
> trigger BusLogic driver's initialization failure).
> 
> Config which can boot with 512MB of RAM is at http://I-love.SAKURA.ne.jp/tmp/config-2.6.30-rc7-ok
> 
> Config which cannot boot with 512MB of RAM is at http://I-love.SAKURA.ne.jp/tmp/config-2.6.30-rc7-ng
> 
> $ diff config-2.6.30-rc7-ok config-2.6.30-rc7-ng
> 4c4
> < # Mon May 25 12:33:54 2009
> ---
> > # Mon May 25 13:28:39 2009
> 1519a1520,1521
> > CONFIG_NOP_TRACER=y
> > CONFIG_HAVE_FTRACE_NMI_ENTER=y
> 1525a1528,1531
> > CONFIG_TRACER_MAX_TRACE=y
> > CONFIG_RING_BUFFER=y
> > CONFIG_FTRACE_NMI_ENTER=y
> > CONFIG_TRACING=y
> 1531,1535c1537,1542
> < # CONFIG_FUNCTION_TRACER is not set


> < # CONFIG_IRQSOFF_TRACER is not set
> < # CONFIG_SYSPROF_TRACER is not set
> < # CONFIG_SCHED_TRACER is not set

Can you also disable the above three and see if you still see problems?

Thanks,

-- Steve




> < # CONFIG_CONTEXT_SWITCH_TRACER is not set
> ---
> > CONFIG_FUNCTION_TRACER=y
> > CONFIG_FUNCTION_GRAPH_TRACER=y
> > CONFIG_IRQSOFF_TRACER=y
> > CONFIG_SYSPROF_TRACER=y
> > CONFIG_SCHED_TRACER=y
> > CONFIG_CONTEXT_SWITCH_TRACER=y
> 1538,1541c1545,1551
> < # CONFIG_BOOT_TRACER is not set
> < # CONFIG_TRACE_BRANCH_PROFILING is not set
> < # CONFIG_POWER_TRACER is not set
> < # CONFIG_STACK_TRACER is not set
> ---
> > CONFIG_BOOT_TRACER=y
> > CONFIG_TRACE_BRANCH_PROFILING=y
> > CONFIG_PROFILE_ALL_BRANCHES=y
> > CONFIG_TRACING_BRANCHES=y
> > CONFIG_BRANCH_TRACER=y
> > CONFIG_POWER_TRACER=y
> > CONFIG_STACK_TRACER=y
> 1544a1555,1557
> > CONFIG_DYNAMIC_FTRACE=y
> > CONFIG_FTRACE_MCOUNT_RECORD=y
> > # CONFIG_FTRACE_STARTUP_TEST is not set
> 1695c1708
> < # CONFIG_BINARY_PRINTF is not set
> ---
> > CONFIG_BINARY_PRINTF=y
> 
> Regards.
> 
