Return-Path: <linux-kernel-owner+w=401wt.eu-S934816AbZDBC0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934816AbZDBC0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 22:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752909AbZDBC0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 22:26:31 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:34971 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbZDBC0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 22:26:30 -0400
Date: Wed, 1 Apr 2009 22:21:57 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Ingo Molnar <mingo@elte.hu>
cc: Matthew Wilcox <matthew@wil.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tejun Heo <tj@kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com,
       Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, grundler@parisc-linux.org,
       takata@linux-m32r.org, benh@kernel.crashing.org, rth@twiddle.net,
       ink@jurassic.park.msu.ru, heiko.carstens@de.ibm.com,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH UPDATED] percpu: use dynamic percpu allocator as the
 default percpu allocator
In-Reply-To: <20090402021024.GA26446@elte.hu>
Message-ID: <alpine.DEB.1.10.0904012219300.32656@qirst.com>
References: <alpine.DEB.1.10.0903301049060.13333@qirst.com> <alpine.DEB.1.10.0903311208110.17960@qirst.com> <49D2B209.9060000@kernel.org> <alpine.DEB.1.10.0904010948120.7643@qirst.com> <20090401154913.GA31435@elte.hu> <alpine.DEB.1.10.0904011404240.29839@qirst.com>
 <20090401190113.GA734@elte.hu> <alpine.LFD.2.00.0904011235160.4130@localhost.localdomain> <20090401223241.GA28168@elte.hu> <20090401225754.GN8014@parisc-linux.org> <20090402021024.GA26446@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Apr 2009, Ingo Molnar wrote:

> Note that my argument was different though: that assumptions about
> variable correlation are very hard to track and validate, and that
> IMHO we should be using __read_mostly generously (we know _that_
> attribute with a rather high likelyhood), and we should group the
> remaining variables together, starting at a cacheline aligned
> address.

But then you decrease the density of accessed to the __read_mostly
sections. The cachelines are not hot in the caches anymore which is an
average performance reduction.

> A sub-sub argument was that perhaps we should not split .data and
> .bss variables into separate sections - it doubles the chance of
> false cacheline sharing and spreads the cacheline footprint.

False cacheline sharing is something normal that comes with the cpu
caching schemes. As long as there is no significant impact on performance
we are fine with it. Extensive measures to avoid false cacheline sharing
on unimportant variables increases the cache footprint of code.


