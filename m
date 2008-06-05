Return-Path: <linux-kernel-owner+w=401wt.eu-S1763382AbYFECjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763382AbYFECjL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 22:39:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756215AbYFECiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 22:38:55 -0400
Received: from mga06.intel.com ([134.134.136.21]:60564 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755875AbYFECiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 22:38:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,592,1204531200"; 
   d="scan'208";a="288402013"
Subject: Re: [Bug #10638] sysbench+mysql(oltp, readonly) 30% regression
	with 2.6.26-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20080604111951.GA5507@elte.hu>
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik>
	 <7wuznNhcUqC.A.IMB.TtBMIB@albercik>
	 <1211131278.6463.7.camel@lappy.programming.kicks-ass.net>
	 <1211135856.6463.22.camel@lappy.programming.kicks-ass.net>
	 <1211160283.3177.134.camel@ymzhang> <1211176540.8292.3.camel@twins>
	 <1211179767.3177.166.camel@ymzhang> <20080530094541.GA32508@elte.hu>
	 <1212382657.3177.319.camel@ymzhang>  <20080604111951.GA5507@elte.hu>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 05 Jun 2008 10:34:24 +0800
Message-Id: <1212633264.6473.13.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-06-04 at 13:19 +0200, Ingo Molnar wrote:
> * Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> 
> > 
> > On Fri, 2008-05-30 at 11:45 +0200, Ingo Molnar wrote:
> > > Yanmin,
> > > 
> > > could you please check whether the performance regressions you 
> > > noticed are now fixed in upstream -git? [make sure merge 
> > > a7f75d3bed28 is included]
> > > 
> > > i believe most of the regressions to 2.6.25 you found should be 
> > > addressed - if not, please let me know which one is still hurting.
> >
> > Most regressions are fixed.
> 
> great - thanks for the exhaustive testing! In fact there should be nice 
> speedups in most of the categories as well ;-)
> 
> out of the 5 issues, only one is inconclusive:
> 
> > On 16-thread tulsa machine, hackbench result becomes 34 seconds. 
> > 2.6.26-rc2's result is 40 seconds and 2.6.26-rc1's is 30 seconds. So 
> > there is much improvement. On another Montvale machine(supporting 
> > multi-threading, but I don't turn on it in BIOS), hackbench has the 
> > similiar behavior.
> 
> okay, that's "hackbench 100", which creates a swarm of 2000 runnable 
> tasks and which is extremely sensitive to wakeup preemption details. It 
> is a volanomark work-alike, so if volanomark itself works fine (which it 
> does appear, from your other numbers) and this one regresses a bit, i'm 
> not sure there's anything fundamental to be worried about.
One difference between volanoMark and hackbench is cpu context switch.
cpu context switch looks stable when I run volanoMark, but dones't look
stable with hackbench.

running queue is another difference. With volanoMark, running queue is quite stable.
With hackbench, running queue keeps decreasing, sometimes quickly, sometimes slowly.

> 
> Quite likely you'll get more stable results if you run it all batched 
> (which such workload really should):
> 
>  schedtool -B -e hackbench 100
I tested it by #hackbench process 2000 with/without schedtool.

If I don't kill most background processes (services), the result is still not stable.
If I kill ﻿background processes, the fluctuation is within 0.5 seconds
with or without schedtool. It looks like -B makes the result a little better, but
very little about 1 second.

> 
> right?
> 
> the 16-thread tulsa machine, how is it laid out physically: 2 sockets, 4 
> cores per socket, 2 threads per core?
4 sockets, 2 cores per socket, 2 threads per core.


