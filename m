Return-Path: <linux-kernel-owner+w=401wt.eu-S1764859AbZFOUA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764859AbZFOUA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 16:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbZFOUAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 16:00:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59667 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259AbZFOUAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 16:00:15 -0400
Date: Mon, 15 Jun 2009 21:59:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, efault@gmx.de,
       jeremy@goop.org, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain
	support to use NMI-safe methods
Message-ID: <20090615195954.GA19483@elte.hu>
References: <alpine.LFD.2.01.0906151007560.3305@localhost.localdomain> <20090615171845.GA7664@elte.hu> <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain> <4A369508.2090707@zytor.com> <20090615184858.GD6520@Krystal> <1245091917.6741.185.camel@laptop> <20090615185907.GF6520@Krystal> <20090615190321.GA11641@elte.hu> <20090615190759.GA12778@elte.hu> <1245093011.6741.213.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245093011.6741.213.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Mon, 2009-06-15 at 21:07 +0200, Ingo Molnar wrote:
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > > To a point where it cannot afford a simple register save/restore 
> > > > ?
> > > > 
> > > > There is "caring" and "_caring_". I am tempted to ask what NMI 
> > > > handler execution frequency you have in mind here to figure out 
> > > > if we are not trying to optimize sub-nanoseconds per minutes. ;)
> > > 
> > > I routinely run 'perf' with half a million NMIs per second or 
> > > more. ( Why wait 10 seconds for a profile you can get in 1 second? 
> > > ;-)
> > > 
> > > Granted that is over multiple CPUs - but still performance does 
> > > matter here too.
> > > 
> > > Reading cr2 is certainly fast. Writing it - dunno.
> > 
> > But one thing is sure: it is certainly going to be faster than the 
> > INVLPG(s!) we have to do with the GUP solution.
> 
> Sure, but we only pay that price when we do the callchain bit, not 
> on every NMI.

same goes for the CR2 save/restore trick - it only has to be done 
around the code where we expect to generate a #PF. I.e. in the 
call-graph bits.

	Ingo
