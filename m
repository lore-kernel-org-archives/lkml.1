Return-Path: <linux-kernel-owner+w=401wt.eu-S1751650AbYJRRux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650AbYJRRux (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 13:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750979AbYJRRun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 13:50:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53593 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbYJRRum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 13:50:42 -0400
Date: Sat, 18 Oct 2008 19:50:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "Luck, Tony" <tony.luck@intel.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "ltt-dev@lists.casi.polymtl.ca" <ltt-dev@lists.casi.polymtl.ca>,
       Michael Davidson <md@google.com>
Subject: Re: [RFC patch 15/15] LTTng timestamp x86
Message-ID: <20081018175005.GA2211@elte.hu>
References: <20081017012835.GA30195@Krystal> <57C9024A16AD2D4C97DC78E552063EA3532D455F@orsmsx505.amr.corp.intel.com> <20081017172515.GA9639@goodmis.org> <57C9024A16AD2D4C97DC78E552063EA3533458AC@orsmsx505.amr.corp.intel.com> <20081017184215.GB9874@Krystal> <57C9024A16AD2D4C97DC78E552063EA35334594F@orsmsx505.amr.corp.intel.com> <20081017202313.GA13597@Krystal> <57C9024A16AD2D4C97DC78E552063EA353345B9B@orsmsx505.amr.corp.intel.com> <20081018170118.GA22243@Krystal> <alpine.LFD.2.00.0810181011310.3438@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0810181011310.3438@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> And if you make all these linear interpolations be per-CPU (so you 
> have per-CPU offsets and frequencies) you never _ever_ need to touch 
> any shared data at all, and you know you can scale basically 
> perfectly.
> 
> Your linear interpolations may not be _perfect_, but you'll be able to 
> get them pretty damn near. In fact, even if the TSC's aren't 
> synchronized at all, if they are at least _individually_ stable (just 
> running at slightly different frequencies because they are in 
> different clock domains, and/or at different start points), you can 
> basically perfect the precision over time.

there's been code submitted by Michael Davidson recently that looked 
interesting, which turns the TSC into such an entity:

    http://lkml.org/lkml/2008/9/25/451

The periodic synchronization uses the hpet, but it thus allows lockless 
and globally correct readouts of the TSC .

And that would match the long term goal as well: the hw should do this 
all automatically. So perhaps we should have a trace_clock() after all, 
independent of sched_clock(), and derived straight from RDTSC.

The approach as propoed has a couple of practical problems, but if we 
could be one RDTSC+multiplication away from a pretty good timestamp that 
would be rather useful, very fast and very robust ...

	Ingo
