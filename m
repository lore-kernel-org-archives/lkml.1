Return-Path: <linux-kernel-owner+w=401wt.eu-S934055AbXGQPI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934055AbXGQPI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 11:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbXGQPIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 11:08:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40153 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192AbXGQPIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 11:08:14 -0400
Date: Tue, 17 Jul 2007 17:08:12 +0200
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <ak@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc][patch 2/2] x86_64: FIFO ticket spinlocks
Message-ID: <20070717150812.GC19092@wotan.suse.de>
References: <20070716045932.GA19914@wotan.suse.de> <20070716050134.GB19914@wotan.suse.de> <200707171625.42235.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707171625.42235.ak@suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2007 at 04:25:42PM +0200, Andi Kleen wrote:
> 
> 
> When you revamp everything I guess it would make the locks
> easier to read to just put them into a .S file? They're
> out of line anyways.

It is a bit tricky because of the way kernel/spinlock.c uses
the the inline asm (that, and unlocks are inlined), and some
of the debugging code.

Also, I'm not exactly sure what is the best way to clean up
spinlocks, if it is even possible. I'm afraid to touch it
more than I have to :)

> 
> In general they look ok.
> 
> >  
> >  static inline void __raw_spin_unlock(raw_spinlock_t *lock)
> >  {
> > -	asm volatile("movl $1,%0" :"=m" (lock->slock) :: "memory");
> > +	__asm__ __volatile__(
> 
> Minor nit: please don't use these underlined keywords. They just look
> ugly and asm volatile works as well.

OK, I like that better too. I didn't even realise I changed this
because it is mechanical to do the __. That's good to know and I'll
change my habit now.
