Return-Path: <linux-kernel-owner+w=401wt.eu-S1756933AbZBLIWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933AbZBLIWf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 03:22:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750968AbZBLIW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 03:22:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55680 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbZBLIWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 03:22:25 -0500
Date: Thu, 12 Feb 2009 09:22:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@tglx.de>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>
Subject: Re: [patch] rt: fix ipi kfree(), introduce IPI_SOFTIRQ
Message-ID: <20090212082207.GB26838@elte.hu>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain> <20090212005032.GA4788@nowhere> <20090212021257.GB4697@nowhere> <20090212081801.GA22979@elte.hu> <20090212081923.GA26838@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090212081923.GA26838@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> ------------------>
> Subject: rt: fix ipi kfree(), introduce IPI_SOFTIRQ
> From: Ingo Molnar <mingo@elte.hu>
> Date: Thu Feb 12 09:06:11 CET 2009
> 
> in 2.6.28 generic_smp_call_function_interrupt() grew a kfree(),
> which is a rather complex, sleepable method under -rt. But the
> IPI code runs as a hardirq - which cannot run such code.
> 
> So defer this work to a softirq context instead. It still stays
> on the same CPU so the percpu IPI assumptions are upheld.

On a second thought ...

I think we could eliminate the kfree() instead, and keep the
atomicity of IPI cross-calls. Linus expressed doubts about
the IPI kmalloc()/kfree() pair we do in the generic SMP IPI
code, suggesting that it probably does not help performance
all that much - so such a change might be upstream-able as well
and would keep -rt closer to mainline.

	Ingo
