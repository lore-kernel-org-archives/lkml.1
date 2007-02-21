Return-Path: <linux-kernel-owner+w=401wt.eu-S932125AbXBUHAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125AbXBUHAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 02:00:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932367AbXBUHAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 02:00:23 -0500
Received: from mga07.intel.com ([143.182.124.22]:23133 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932125AbXBUHAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 02:00:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,199,1170662400"; 
   d="scan'208"; a="185034035:sNHT35173145"
Date: Tue, 20 Feb 2007 22:25:09 -0800
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, npiggin@suse.de
Subject: Re: [patch 1/2] sched: fix idle load balancing in softirqd context
Message-ID: <20070220222508.A14789@unix-os.sc.intel.com>
References: <20061213231316.GA13849@elte.hu> <20061213150314.B12795@unix-os.sc.intel.com> <20061213233157.GA20470@elte.hu> <20061213151926.C12795@unix-os.sc.intel.com> <20061219201247.GA12648@elte.hu> <20061219131223.E23105@unix-os.sc.intel.com> <20070116113505.GA6294@elte.hu> <20070130135709.B32010@unix-os.sc.intel.com> <20070216180335.A8744@unix-os.sc.intel.com> <Pine.LNX.4.58.0702170940040.30133@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5.1i
In-Reply-To: <Pine.LNX.4.58.0702170940040.30133@gandalf.stny.rr.com>; from rostedt@goodmis.org on Sat, Feb 17, 2007 at 09:42:16AM -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 17, 2007 at 09:42:16AM -0500, Steven Rostedt wrote:
> On Fri, 16 Feb 2007, Siddha, Suresh B wrote:
> > -	int cpu = smp_processor_id();
> > +	int cpu = smp_processor_id(), idle_at_tick = idle_cpu(cpu);
> >  	struct rq *rq = cpu_rq(cpu);
> >
> 
> But I would recommend that the idle_at_tick should be on a separate line.

Ok.

> I'll try to look deeper at your patches tomorrow. I've also found that I'm
> having some latency problems in -rt that I think might be related to
> migration.

There is one more issue, I have observed in -rt tree.

raise_softirq_irqoff() is unconditionally doing the wakeup_softirqd()
But unless the CONFIG_PREEMPT_SOFTIRQS is configured, do_softirq()
will process the softirq's like TIMER_SOFTIRQ and SCHED_SOFTIRQ in the
process context.  So it looks like we are unnecessarily waking the
softirqd's corresponding to those softirq's.

thanks,
suresh
