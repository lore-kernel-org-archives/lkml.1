Return-Path: <linux-kernel-owner+w=401wt.eu-S1754115AbXJ1VhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbXJ1VhU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 17:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbXJ1VhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 17:37:07 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48412 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751582AbXJ1VhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 17:37:05 -0400
Date: Sun, 28 Oct 2007 21:38:55 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Wilcox <matthew@wil.cx>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "George G. Davis" <gdavis@mvista.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC, PATCH] locks: remove posix deadlock detection
Message-ID: <20071028213855.769741b6@the-village.bc.nu>
In-Reply-To: <20071028201101.GA32359@parisc-linux.org>
References: <20071017185157.GC3785@mvista.com>
	<20071018185759.GU3785@mvista.com>
	<20071026170750.GC13033@fieldses.org>
	<20071026224707.GO13033@fieldses.org>
	<20071028173136.GA16905@fieldses.org>
	<20071028174321.GB16905@fieldses.org>
	<20071028182732.GK27248@parisc-linux.org>
	<20071028184052.49abd092@the-village.bc.nu>
	<20071028201101.GA32359@parisc-linux.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > - EDEADLK behaviour is ABI
> 
> Not in any meaningful way.

I've seen SYS5 software that relies on it so we should be careful. Again
see the 2004 discussion where the conclusion was that EDEADLK should stay
> 
> > - EDEADLK behaviour is required by SuSv3
> 
> What SuSv3 actually says is:
> 
> 	If the system detects that sleeping until a locked region is
> 	unlocked would cause a deadlock, fcntl() shall fail with an
> 	[EDEADLK] error.
> 
> It doesn't require the system to detect it, only mandate what to return
> if it does detect it.

We should be detecting at least the obvious case.

> > - We have no idea what applications may rely on this behaviour.
> 
> I've never heard of one that does.

Very scientific. I have on SYS5 though not afaik Linux

> > so we need to fix the bugs - the lock usage and the looping. At that
> > point it merely becomes a performance concern to those who use it, which
> > is the proper behaviour. If you want a faster non-checking one use
> > flock(), or add another flag that is a Linux "don't check for deadlock"
> 
> You can't fix the false EDEADLK detection without solving the halting
> problem.  Best of luck with that.

A good question to ask here would be what subset of deadlock loops on
flock does SYS5 Unix error. I also don't see why you need to solve the
halting problem

If SYSV only spots simple AB - BA deadlocks or taking the same lock twice
yourself then that ought to be sufficient for us too.
