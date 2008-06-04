Return-Path: <linux-kernel-owner+w=401wt.eu-S1759243AbYFDLU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759243AbYFDLU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 07:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752226AbYFDLUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 07:20:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50709 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475AbYFDLUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 07:20:17 -0400
Date: Wed, 4 Jun 2008 13:19:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #10638] sysbench+mysql(oltp, readonly) 30% regression
	with 2.6.26-rc1
Message-ID: <20080604111951.GA5507@elte.hu>
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik> <7wuznNhcUqC.A.IMB.TtBMIB@albercik> <1211131278.6463.7.camel@lappy.programming.kicks-ass.net> <1211135856.6463.22.camel@lappy.programming.kicks-ass.net> <1211160283.3177.134.camel@ymzhang> <1211176540.8292.3.camel@twins> <1211179767.3177.166.camel@ymzhang> <20080530094541.GA32508@elte.hu> <1212382657.3177.319.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212382657.3177.319.camel@ymzhang>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:

> 
> On Fri, 2008-05-30 at 11:45 +0200, Ingo Molnar wrote:
> > Yanmin,
> > 
> > could you please check whether the performance regressions you 
> > noticed are now fixed in upstream -git? [make sure merge 
> > a7f75d3bed28 is included]
> > 
> > i believe most of the regressions to 2.6.25 you found should be 
> > addressed - if not, please let me know which one is still hurting.
>
> Most regressions are fixed.

great - thanks for the exhaustive testing! In fact there should be nice 
speedups in most of the categories as well ;-)

out of the 5 issues, only one is inconclusive:

> On 16-thread tulsa machine, hackbench result becomes 34 seconds. 
> 2.6.26-rc2's result is 40 seconds and 2.6.26-rc1's is 30 seconds. So 
> there is much improvement. On another Montvale machine(supporting 
> multi-threading, but I don't turn on it in BIOS), hackbench has the 
> similiar behavior.

okay, that's "hackbench 100", which creates a swarm of 2000 runnable 
tasks and which is extremely sensitive to wakeup preemption details. It 
is a volanomark work-alike, so if volanomark itself works fine (which it 
does appear, from your other numbers) and this one regresses a bit, i'm 
not sure there's anything fundamental to be worried about.

Quite likely you'll get more stable results if you run it all batched 
(which such workload really should):

 schedtool -B -e hackbench 100

right?

the 16-thread tulsa machine, how is it laid out physically: 2 sockets, 4 
cores per socket, 2 threads per core?

	Ingo
