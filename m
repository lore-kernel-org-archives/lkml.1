Return-Path: <linux-kernel-owner+w=401wt.eu-S965266AbXBQOmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965266AbXBQOmh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 09:42:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965267AbXBQOmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 09:42:37 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:55507 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965266AbXBQOmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 09:42:36 -0500
Date: Sat, 17 Feb 2007 09:42:16 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org, npiggin@suse.de
Subject: Re: [patch 1/2] sched: fix idle load balancing in softirqd context
In-Reply-To: <20070216180335.A8744@unix-os.sc.intel.com>
Message-ID: <Pine.LNX.4.58.0702170940040.30133@gandalf.stny.rr.com>
References: <20061211155304.A31760@unix-os.sc.intel.com> <20061213224317.GA2986@elte.hu>
 <20061213231316.GA13849@elte.hu> <20061213150314.B12795@unix-os.sc.intel.com>
 <20061213233157.GA20470@elte.hu> <20061213151926.C12795@unix-os.sc.intel.com>
 <20061219201247.GA12648@elte.hu> <20061219131223.E23105@unix-os.sc.intel.com>
 <20070116113505.GA6294@elte.hu> <20070130135709.B32010@unix-os.sc.intel.com>
 <20070216180335.A8744@unix-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 16 Feb 2007, Siddha, Suresh B wrote:

> Periodic load balancing in recent kernels happen in the softirq.
> In certain -rt configurations, these softirqs are handled in softirqd
> context. And hence the check for idle processor was always returning
> busy (as nr_running > 1).
>
> This patch captures the idle information at the tick and passes this info
> to softirq context through an element 'idle_at_tick' in rq.

I haven't had the time yet to look too detailed at this patch.

>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> ---
>

>  {
>  	unsigned long long now = sched_clock();
>  	struct task_struct *p = current;
> -	int cpu = smp_processor_id();
> +	int cpu = smp_processor_id(), idle_at_tick = idle_cpu(cpu);
>  	struct rq *rq = cpu_rq(cpu);
>

But I would recommend that the idle_at_tick should be on a separate line.

I'll try to look deeper at your patches tomorrow. I've also found that I'm
having some latency problems in -rt that I think might be related to
migration.

-- Steve

