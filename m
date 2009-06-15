Return-Path: <linux-kernel-owner+w=401wt.eu-S933683AbZFOUOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933683AbZFOUOw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 16:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755660AbZFOUOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 16:14:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58202 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215AbZFOUOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 16:14:44 -0400
Message-ID: <4A36AAC4.9040305@zytor.com>
Date: Mon, 15 Jun 2009 13:10:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, penberg@cs.helsinki.fi, vegard.nossum@gmail.com,
       efault@gmx.de, jeremy@goop.org, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain	support
 to use NMI-safe methods
References: <tip-74193ef0ecab92535c8517f082f1f50504526c9b@git.kernel.org> <alpine.LFD.2.01.0906151007560.3305@localhost.localdomain> <20090615171845.GA7664@elte.hu> <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain> <20090615180527.GB4201@Krystal> <alpine.LFD.2.01.0906151125320.6276@localhost.localdomain> <20090615183649.GA16999@elte.hu> <alpine.LFD.2.01.0906151152170.6276@localhost.localdomain> <20090615194344.GA12554@elte.hu> <20090615200619.GA10632@Krystal>
In-Reply-To: <20090615200619.GA10632@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> 
> In the category "crazy ideas one should never express out loud", I could add the
> following. We could choose to save/restore the cr2 register on the local stack
> at every interrupt entry/exit, and therefore allow the page fault handler to
> execute with interrupts enabled.
> 
> I have not benchmarked the interrupt disabling overhead of the page fault
> handler handled by starting an interrupt-gated handler rather than trap-gated 
> handler, but cli/sti instructions are known to take quite a few cycles on some
> architectures. e.g. 131 cycles for the pair on P4, 23 cycles on AMD Athlon X2
> 64, 43 cycles on Intel Core2.
> 
> I am tempted to think that taking, say, ~10 cycles on the interrupt path worths
> it if we save a few tens of cycles on the page fault handler fast path.
> 

Doesn't sound all that crazy, I suspect the underlying assumption that
interrupt gates are slower than trap gates is incorrect.  Disabling
interrupts itself isn't expensive, it's the synchronization requirements.

	-hpa

