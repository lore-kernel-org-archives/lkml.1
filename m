Return-Path: <linux-kernel-owner+w=401wt.eu-S1756171AbXJNGee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbXJNGee (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 02:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751645AbXJNGe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 02:34:27 -0400
Received: from mail.gmx.net ([213.165.64.20]:48602 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751188AbXJNGe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 02:34:26 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18wRH1ZWhIweFCQTi8SUnmctEsGffHiwmwsqi1/z3
	0zrbKZJ6Fzx9zc
Subject: Re: [PATCH] sched: high-res preemption tick
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1192317228.5625.8.camel@lappy>
References: <1192222309.5897.3.camel@lappy>
	 <1192259938.7369.4.camel@Homer.simpson.net>
	 <1192265717.27435.44.camel@twins>  <1192267072.5897.5.camel@lappy>
	 <1192317228.5625.8.camel@lappy>
Content-Type: text/plain
Date: Sun, 14 Oct 2007 08:34:20 +0200
Message-Id: <1192343660.7594.19.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-10-14 at 01:13 +0200, Peter Zijlstra wrote:
> On Sat, 2007-10-13 at 11:17 +0200, Peter Zijlstra wrote:
> 
> > > Ah, but HRTICK is not compatible with PREEMPT_RESTRICT, it will be
> > > similar to !WAKEUP_PREEMPT.
> > 
> > (I do plan to fix that eventually, just need to do it)
> 
> I guess something like this ought to do, but its a tad late so I'm quite
> sure :-)

2.6.23-smp-d-hrt + restrict fix patch
[SUM]  0.0-300.1 sec    176 GBytes  5.03 Gbits/sec
[SUM]  0.0-300.1 sec    175 GBytes  5.02 Gbits/sec
[SUM]  0.0-300.1 sec    176 GBytes  5.05 Gbits/sec

Context switches are further reduced (across the board) over
PREEMPT_RESTRICT, dropping from ~7-8k to ~2.5k with this test, vs ~950
for SCHED_BATCH and ~50k with this tree and no restriction.  Throughput
is ~96% of SCHED_BATCH, vs ~55% with no restriction.  I see no
interactivity regressions.

	-Mike

