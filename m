Return-Path: <linux-kernel-owner+w=401wt.eu-S1758731AbZBZDJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758731AbZBZDJ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 22:09:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752883AbZBZDJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 22:09:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59843 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123AbZBZDJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 22:09:45 -0500
Date: Thu, 26 Feb 2009 04:09:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, vegard.nossum@gmail.com, stable@kernel.org,
       akpm@linux-foundation.org, npiggin@suse.de, penberg@cs.helsinki.fi
Subject: Re: [PATCH] v4 Teach RCU that idle task is not quiscent state at
	boot
Message-ID: <20090226030933.GD7526@elte.hu>
References: <20090223161611.GA9563@linux.vnet.ibm.com> <20090223204332.GA19861@linux.vnet.ibm.com> <20090225002937.GA23733@linux.vnet.ibm.com> <20090225141945.GA28455@linux.vnet.ibm.com> <20090225160024.GB12732@elte.hu> <20090225170825.GC6797@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090225170825.GC6797@linux.vnet.ibm.com>
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


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> OK, alternatives...
> 
> o	Reverse the roles of the idle and init threads during startup,
> 	so that there is initially no idle thread.
> 
> 	However, there appears to be a fair amount of code that assumes
> 	that there is always an idle thread.
> 
> o	As above, but create both the init and idle threads early so
> 	that there always is an idle thread that happens not to be
> 	running during boot.
> 
> 	This would work, but seems to me to be uglier than the flag.
> 
> o	Stop using idle_cpu() in rcu_check_callbacks(), instead keeping
> 	a per-CPU "cpu_is_idle" variable that is set upon entry to the
> 	various idle() loops and cleared upon exit.  It would be OK to
> 	take interrupts while "cpu_is_idle" is set.
> 
> 	The disadvantage here is that there are quite a few idle loops,
> 	and it would be necessary to change them all.  Missing one or
> 	two could result in indefinite grace periods on the affected
> 	systems.
> 
> o	Drop idle as a quiescent state, as is already the case for
> 	rcupreempt.
> 
> 	This would result in indefinite grace-period delays for
> 	rcuclassic, but would actually work for rcutree.  Except that
> 	it would cause rcutree to IPI each and every idle CPU for
> 	every grace period if !CONFIG_NO_HZ.  I expect that this
> 	overhead would far exceed that of the extra flag check in
> 	rcu_check_callbacks().
> 
> So I still like the flag check.  Any alternatives that I am missing?

Indeed none of the alternatives looks particularly appealing, so 
i concur. Thanks Paul for analyzing it so thoroughly!

	Ingo
