Return-Path: <linux-kernel-owner+w=401wt.eu-S933578AbZFOTEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933578AbZFOTEO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 15:04:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765148AbZFOTDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 15:03:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40254 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754474AbZFOTDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 15:03:45 -0400
Date: Mon, 15 Jun 2009 21:03:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, efault@gmx.de,
       jeremy@goop.org, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain
	support to use NMI-safe methods
Message-ID: <20090615190321.GA11641@elte.hu>
References: <tip-74193ef0ecab92535c8517f082f1f50504526c9b@git.kernel.org> <alpine.LFD.2.01.0906151007560.3305@localhost.localdomain> <20090615171845.GA7664@elte.hu> <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain> <4A369508.2090707@zytor.com> <20090615184858.GD6520@Krystal> <1245091917.6741.185.camel@laptop> <20090615185907.GF6520@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090615185907.GF6520@Krystal>
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


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> * Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> > On Mon, 2009-06-15 at 14:48 -0400, Mathieu Desnoyers wrote:
> > > we should not care that much about the performance hit of
> > > saving/restoring the cr2 register at each nmi entry/exit.
> > 
> > But we do, perf counters very much cares about nmi performance.
> > 
> 
> To a point where it cannot afford a simple register save/restore ?
> 
> There is "caring" and "_caring_". I am tempted to ask what NMI 
> handler execution frequency you have in mind here to figure out if 
> we are not trying to optimize sub-nanoseconds per minutes. ;)

I routinely run 'perf' with half a million NMIs per second or more. 
( Why wait 10 seconds for a profile you can get in 1 second? ;-)

Granted that is over multiple CPUs - but still performance does 
matter here too.

Reading cr2 is certainly fast. Writing it - dunno.

	Ingo
