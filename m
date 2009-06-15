Return-Path: <linux-kernel-owner+w=401wt.eu-S1765992AbZFOUFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765992AbZFOUFQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 16:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757560AbZFOUFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 16:05:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55531 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756815AbZFOUFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 16:05:03 -0400
Date: Mon, 15 Jun 2009 13:04:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, mingo@redhat.com,
       hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, efault@gmx.de,
       jeremy@goop.org, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain support
 to use NMI-safe methods
In-Reply-To: <20090615194344.GA12554@elte.hu>
Message-ID: <alpine.LFD.2.01.0906151302200.6276@localhost.localdomain>
References: <tip-74193ef0ecab92535c8517f082f1f50504526c9b@git.kernel.org> <alpine.LFD.2.01.0906151007560.3305@localhost.localdomain> <20090615171845.GA7664@elte.hu> <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain> <20090615180527.GB4201@Krystal>
 <alpine.LFD.2.01.0906151125320.6276@localhost.localdomain> <20090615183649.GA16999@elte.hu> <alpine.LFD.2.01.0906151152170.6276@localhost.localdomain> <20090615194344.GA12554@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 15 Jun 2009, Ingo Molnar wrote:
> 
> Well i guess it depends. For server apps it is true - syscalls are a 
> lot more dominant, MMs are long-running so any startup cost gets 
> amortized and pagefaults are avoided.
> 
> For something like a kernel build we have 7 times as many pagefaults 
> as syscalls:

Ingo - calm down.

This is not about page faults.

This is purely about taps FROM KERNEL SPACE.

Yes, for the kernel build we have 7 times as many page faults as system 
calls, BUT I BET 99.9% of them are from user mode!

The whole "open-code iret" only works for exceptions that happened in 
kernel mode. That's a _vanishingly_ small number (outside of device 
interrupts that happen during idle).

		Linus
