Return-Path: <linux-kernel-owner+w=401wt.eu-S1760427AbXEVUPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760427AbXEVUPg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 16:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757147AbXEVUPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 16:15:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55143 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756996AbXEVUP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 16:15:29 -0400
Date: Tue, 22 May 2007 22:15:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Chris Friesen <cfriesen@nortel.com>
Cc: William Lee Irwin III <wli@holomorphy.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] CFS scheduler, -v12
Message-ID: <20070522201518.GC6113@elte.hu>
References: <20070513153853.GA19846@elte.hu> <464A6698.3080400@bigpond.net.au> <20070516063625.GA9058@elte.hu> <464CE8FD.4070205@bigpond.net.au> <20070518071325.GB28702@elte.hu> <464DA61A.4040406@bigpond.net.au> <b647ffbd0705190627x4ff15f3cw19bc292e47257287@mail.gmail.com> <20070521082926.GH19966@holomorphy.com> <20070521085703.GA18755@elte.hu> <46531EF6.3020204@nortel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46531EF6.3020204@nortel.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Chris Friesen <cfriesen@nortel.com> wrote:

> Ingo Molnar wrote:
> 
> >CFS is fair even on SMP. Consider for example the worst-case 
> >3-tasks-on-2-CPUs workload on a 2-CPU box:
> >
> >  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
> > 2658 mingo     20   0  1580  248  200 R   67  0.0   0:56.30 loop
> > 2656 mingo     20   0  1580  252  200 R   66  0.0   0:55.55 loop
> > 2657 mingo     20   0  1576  248  200 R   66  0.0   0:55.24 loop
> >
> >66% of CPU time for each task. The 'TIME+' column shows a 2% spread 
> >between the slowest and the fastest loop after just 1 minute of runtime 
> >(and the spread gets narrower with time).
> 
> Is there a way in CFS to tune the amount of time over which the load 
> balancer is fair?  (Of course there would be some overhead involved.)

it should be fair pretty fast (see the 10 seconds run of massive_intr) - 
so it's not 1 minute (if you were worried about that).

	Ingo
