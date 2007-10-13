Return-Path: <linux-kernel-owner+w=401wt.eu-S1759129AbXJMJWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759129AbXJMJWS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 05:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753337AbXJMJWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 05:22:06 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43691 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbXJMJWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 05:22:05 -0400
Subject: Re: [PATCH] sched: high-res preemption tick
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1192265717.27435.44.camel@twins>
References: <1192222309.5897.3.camel@lappy>
	 <1192259938.7369.4.camel@Homer.simpson.net>
	 <1192265717.27435.44.camel@twins>
Content-Type: text/plain
Date: Sat, 13 Oct 2007 11:17:52 +0200
Message-Id: <1192267072.5897.5.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-10-13 at 10:55 +0200, Peter Zijlstra wrote:
> On Sat, 2007-10-13 at 09:18 +0200, Mike Galbraith wrote:
> > On Fri, 2007-10-12 at 22:51 +0200, Peter Zijlstra wrote:
> > > Subject: sched: high-res preemption tick
> > > 
> > > Use HR-timers (when available) to deliver an accurate preemption tick.
> > 
> > This patch further reduced iperf context switching, and boosted
> > throughput.
> > 
> > iperf -c localhost -P 10 -t 300
> > 
> > Previously reported numbers
> > 
> > 2.6.23-smp
> > [SUM]  0.0-300.0 sec    153 GBytes  4.39 Gbits/sec
> > [SUM]  0.0-300.1 sec    148 GBytes  4.23 Gbits/sec
> > [SUM]  0.0-300.0 sec    152 GBytes  4.36 Gbits/sec
> > 
> > 2.6.23-smp-d (sched-devel)
> > [SUM]  0.0-300.0 sec    173 GBytes  4.96 Gbits/sec
> > [SUM]  0.0-300.1 sec    173 GBytes  4.96 Gbits/sec
> > [SUM]  0.0-300.0 sec    172 GBytes  4.93 Gbits/sec
> > 
> > Numbers from fresh pull today
> > 
> > 2.6.23-smp-d-hrt
> > (re-enable PREEMPT_RESTRICT)
> 
> Ah, but HRTICK is not compatible with PREEMPT_RESTRICT, it will be
> similar to !WAKEUP_PREEMPT.

(I do plan to fix that eventually, just need to do it)

Also, this seems to suggest iperf would like SCHED_BATCH.

> > [SUM]  0.0-300.1 sec    181 GBytes  5.19 Gbits/sec
> > [SUM]  0.0-300.0 sec    182 GBytes  5.22 Gbits/sec
> > [SUM]  0.0-300.1 sec    182 GBytes  5.22 Gbits/sec
> > 
> > 2.6.23-smp-d
> > [SUM]  0.0-300.1 sec    174 GBytes  4.97 Gbits/sec
> > [SUM]  0.0-300.1 sec    173 GBytes  4.95 Gbits/sec
> > [SUM]  0.0-300.1 sec    173 GBytes  4.96 Gbits/sec
> > 
> > 

