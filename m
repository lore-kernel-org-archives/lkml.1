Return-Path: <linux-kernel-owner+w=401wt.eu-S1755653AbZEYFFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653AbZEYFFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 01:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753469AbZEYFFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 01:05:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34493 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754875AbZEYFF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 01:05:29 -0400
Date: Mon, 25 May 2009 07:05:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Pekka J Enberg <penberg@cs.helsinki.fi>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>, Alexander Viro <viro@ftp.linux.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL] scheduler fixes
Message-ID: <20090525050502.GA23032@elte.hu>
References: <alpine.LFD.2.01.0905180955550.3301@localhost.localdomain> <20090518170909.GA1623@elte.hu> <20090518190320.GA20260@elte.hu> <alpine.LFD.2.01.0905181208130.3301@localhost.localdomain> <20090518202031.GA26549@elte.hu> <alpine.LFD.2.01.0905181457320.3301@localhost.localdomain> <Pine.LNX.4.64.0905241911120.12189@melkki.cs.Helsinki.FI> <4A199327.5030503@kernel.org> <20090525025353.GA2580@elte.hu> <4A1A241D.603@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1A241D.603@zytor.com>
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
> > Would it be possible to restructure things to move kmalloc init to 
> > before IRQ init as well? We have a couple of uglinesses there too.
> > 
> > Conceptually, memory should be the first thing set up in general, in 
> > a kernel. It does not need IRQs, timers, the scheduler or any of the 
> > IO facilities and abstractions. All of them need memory though - and 
> > as Linux scales to more and more hardware via the same single image, 
> > so will we get more and more dynamic concepts like cpumask_var_t and 
> > sparse-irqs, which want to allocate very early.
> > 
> > setup_arch() is one huge function that sets up all architecture 
> > details at once - but if we split a separate setup_arch_mem() out of 
> > it, and left the rest in setup_arch (and moved it further down), we 
> > could remove much of bootmem (especially the ugly uses).
> > 
> > This might even be doable realistically, and we could thus librarize 
> > bootmem and eliminate it from x86 at least. Perhaps.
> > 
> 
> The only thing that might make sense to set up before memory might 
> be exceptions (as opposed to interrupts), but both of those should 
> be doable very very early.

Yeah. And we already have early exception handlers to help debugging 
so there's practically no dependency on memory init. (other than the 
full kernel image being executable by the CPU - so some very minimal 
memory/paging init is necessary)

	Ingo
