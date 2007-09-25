Return-Path: <linux-kernel-owner+w=401wt.eu-S1752497AbXIYJNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbXIYJNt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 05:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751119AbXIYJNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 05:13:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55777 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbXIYJNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 05:13:40 -0400
Date: Tue, 25 Sep 2007 11:13:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git] CFS-devel, latest code
Message-ID: <20070925091331.GA22905@elte.hu>
References: <20070924214537.GA18980@elte.hu> <1190700652.6482.7.camel@Homer.simpson.net> <1190705759.11910.10.camel@Homer.simpson.net> <1190709207.11226.6.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190709207.11226.6.camel@Homer.simpson.net>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> > sched_debug (attached) is.. strange.
> 
> Disabling CONFIG_FAIR_GROUP_SCHED fixed both.  [...]

heh. Evil plan to enable the group scheduler by default worked out as 
planned! ;-) [guess how many container users would do ... interactivity 
tests like you do??]

> [...] Latencies of up to 336ms hit me during the recompile (make -j3), 
> with nothing else running. Since reboot, latencies are, so far, very 
> very nice. [...]

'very very nice' == 'best ever' ? :-)

> [...] I'm leaving it disabled for now.

ok, i'm too seeing some sort of latency weirdness with 
CONFIG_FAIR_GROUP_SCHED enabled, _if_ there's Xorg involved which runs 
under root uid on my box - and hence gets 50% of all CPU time.

Srivatsa, any ideas? It could either be an accounting buglet (less 
likely, seems like the group scheduling bits stick to the 50% splitup 
nicely), or a preemption buglet. One potential preemption buglet would 
be for the group scheduler to not properly preempt a running task when a 
task from another uid is woken?

	Ingo
