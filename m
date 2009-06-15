Return-Path: <linux-kernel-owner+w=401wt.eu-S1764665AbZFOSYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764665AbZFOSYd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757193AbZFOSY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:24:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34350 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754989AbZFOSYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:24:25 -0400
Date: Mon, 15 Jun 2009 20:23:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
       hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, efault@gmx.de,
       jeremy@goop.org, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain
	support to use NMI-safe methods
Message-ID: <20090615182348.GC11248@elte.hu>
References: <tip-74193ef0ecab92535c8517f082f1f50504526c9b@git.kernel.org> <alpine.LFD.2.01.0906151007560.3305@localhost.localdomain> <20090615171845.GA7664@elte.hu> <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain> <20090615180527.GB4201@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090615180527.GB4201@Krystal>
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

> Hrm, would it be possible to save the c2 register upon nmi handler 
> entry and restore it before iret instead ? This would ensure a 
> nmi-interrupted page fault handler would continue what it was 
> doing with a non-corrupted cr2 register after returning from nmi.
> 
> Plus, this involves no modification to the page fault handler fast 
> path.

I guess this kind of nesting would work too - assuming the cr2 can 
be written to robustly.

And i suspect CPU makers pull off a few tricks to stage the cr2 info 
away from the page fault entry execution asynchronously, so i'd not 
be surprised if writing to it uncovered unknown-so-far side-effects 
in CPU implementations.

If possible i wouldnt want to rely on such a narrowly possible hack 
really - any small change in CPU specs could cause problems years 
down the line.

The GUP based method is pretty generic though - and can be used on 
other architectures as well. It's not as fast as direct access 
though.

	Ingo
