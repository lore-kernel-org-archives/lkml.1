Return-Path: <linux-kernel-owner+w=401wt.eu-S932736AbXGPJ7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932736AbXGPJ7y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 05:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764407AbXGPJt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 05:49:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44974 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764264AbXGPJtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 05:49:47 -0400
Date: Mon, 16 Jul 2007 11:49:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: Andi Kleen <ak@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc][patch 2/2] x86_64: FIFO ticket spinlocks
Message-ID: <20070716094940.GA23080@elte.hu>
References: <20070716045932.GA19914@wotan.suse.de> <20070716050134.GB19914@wotan.suse.de> <20070716092646.GA18423@elte.hu> <20070716094503.GC21464@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716094503.GC21464@wotan.suse.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <npiggin@suse.de> wrote:

> On Mon, Jul 16, 2007 at 11:26:46AM +0200, Ingo Molnar wrote:
> > 
> > * Nick Piggin <npiggin@suse.de> wrote:
> > 
> > > [...] trylock is more significantly slower, but they are relatively 
> > > rare.
> > 
> > trylock is the main thing that the spinlock debugging code uses, and 
> > SPINLOCK_DEBUG is frequently enabled by distro kernels. OTOH, the cost 
> > looks like to be +5 instructions, right? Still ...
> 
> Which trylocks do you mean? The lockbreak spinlocks use trylock, but 
> those are not used with the ticket version.

the trylocks in lib/spinlock-debug.c:

 static void __spin_lock_debug(spinlock_t *lock)
 {
 ...
                         if (__raw_spin_trylock(&lock->raw_lock))
                                 return;
 ...
 void _raw_spin_lock(spinlock_t *lock)
 {
         debug_spin_lock_before(lock);
         if (unlikely(!__raw_spin_trylock(&lock->raw_lock)))
                 __spin_lock_debug(lock);
         debug_spin_lock_after(lock);
 }

am i missing something?

	Ingo
