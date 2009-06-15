Return-Path: <linux-kernel-owner+w=401wt.eu-S934773AbZFOVOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934773AbZFOVOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 17:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934821AbZFOVN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 17:13:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46215 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934816AbZFOVNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 17:13:55 -0400
Date: Mon, 15 Jun 2009 23:13:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, mingo@redhat.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, penberg@cs.helsinki.fi, vegard.nossum@gmail.com,
       efault@gmx.de, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain
	support to use NMI-safe methods
Message-ID: <20090615211319.GB27100@elte.hu>
References: <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain> <20090615180527.GB4201@Krystal> <alpine.LFD.2.01.0906151125320.6276@localhost.localdomain> <20090615183649.GA16999@elte.hu> <alpine.LFD.2.01.0906151152170.6276@localhost.localdomain> <4A36ABB5.1040109@goop.org> <alpine.LFD.2.01.0906151326170.6276@localhost.localdomain> <4A36B238.5020203@zytor.com> <20090615205911.GC24554@elte.hu> <4A36B746.4050001@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A36B746.4050001@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> Ingo Molnar wrote:
> > 
> > hm, does this really work? Using sysret there would be quite 
> > tempting. Does anyone know the rough cycle count difference between 
> > IRET and SYSRET on contemporary hardware?
> > 
> > Also, is SYSRET NMI-invariant? If yes then this would be a quite 
> > clean all-around solution: on modern hw we'd standardize on doing 
> > SYSRET from pretty much all the contexts. We'd get a nice speedup 
> > and also the NMI nested pagefaults fix.
> > 
> > Oh, compat mode. Doesnt SYSRET on Intel CPUs have the problem of not 
> > being able to switch back to 32-bit user-space?
> > 
> 
> Not sure.  SYSRET/SYSEXIT are *not* general return to userspace 
> solutions in either case; any kind of complex modes and they 
> can't.
> 
> And they are, of course, only applicable for returning to 
> userspace.  As such, I don't understand the "NMI invariant" 
> comment.

Yeah - it makes no sense for the NMI return indeed, as the target 
CS/SS is hardcoded indeed.

	Ingo
