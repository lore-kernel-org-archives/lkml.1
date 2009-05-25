Return-Path: <linux-kernel-owner+w=401wt.eu-S1758152AbZEYF0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152AbZEYF0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 01:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbZEYF0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 01:26:11 -0400
Received: from gate.crashing.org ([63.228.1.57]:54101 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393AbZEYF0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 01:26:11 -0400
Subject: Re: [GIT PULL] scheduler fixes
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Pekka J Enberg <penberg@cs.helsinki.fi>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeff Garzik <jgarzik@pobox.com>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20090525025353.GA2580@elte.hu>
References: <alpine.LFD.2.01.0905180850110.3301@localhost.localdomain>
	 <20090518164921.GA6903@elte.hu>
	 <alpine.LFD.2.01.0905180955550.3301@localhost.localdomain>
	 <20090518170909.GA1623@elte.hu> <20090518190320.GA20260@elte.hu>
	 <alpine.LFD.2.01.0905181208130.3301@localhost.localdomain>
	 <20090518202031.GA26549@elte.hu>
	 <alpine.LFD.2.01.0905181457320.3301@localhost.localdomain>
	 <Pine.LNX.4.64.0905241911120.12189@melkki.cs.Helsinki.FI>
	 <4A199327.5030503@kernel.org>  <20090525025353.GA2580@elte.hu>
Content-Type: text/plain
Date: Mon, 25 May 2009 15:19:03 +1000
Message-Id: <1243228743.24376.30.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-25 at 04:53 +0200, Ingo Molnar wrote:
> 
> Would it be possible to restructure things to move kmalloc init to 
> before IRQ init as well? We have a couple of uglinesses there too.

Amen :-)

> Conceptually, memory should be the first thing set up in general, in 
> a kernel. It does not need IRQs, timers, the scheduler or any of the 
> IO facilities and abstractions. All of them need memory though - and 
> as Linux scales to more and more hardware via the same single image, 
> so will we get more and more dynamic concepts like cpumask_var_t and 
> sparse-irqs, which want to allocate very early.
> 
> setup_arch() is one huge function that sets up all architecture 
> details at once - but if we split a separate setup_arch_mem() out of 
> it, and left the rest in setup_arch (and moved it further down), we 
> could remove much of bootmem (especially the ugly uses).
> 
> This might even be doable realistically, and we could thus librarize 
> bootmem and eliminate it from x86 at least. Perhaps.

Yup, see my earlier email. Archs like x86 and powerpc already have a low
level allocator they can use to allocate the mem_map etc... so bootmem
really becomes redundant.

Cheers
Ben.


