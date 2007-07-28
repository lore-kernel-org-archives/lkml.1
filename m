Return-Path: <linux-kernel-owner+w=401wt.eu-S1752707AbXG1ES5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbXG1ES5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 00:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824AbXG1ESt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 00:18:49 -0400
Received: from [212.12.190.38] ([212.12.190.38]:33274 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750896AbXG1ESr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 00:18:47 -0400
From: Al Boldi <a1426z@gawab.com>
To: Chris Snook <csnook@redhat.com>
Subject: Re: swap-prefetch:  A smart way to make good use of idle resources (was: updatedb)
Date: Sat, 28 Jul 2007 07:18:31 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <200707272243.02336.a1426z@gawab.com> <46AAA25E.7040301@redhat.com>
In-Reply-To: <46AAA25E.7040301@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707280718.31272.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Snook wrote:
> Al Boldi wrote:
> > IMHO, what everybody agrees on, is that swap-prefetch has a positive
> > effect in some cases, and nobody can prove an adverse effect (excluding
> > power consumption).  The reason for this positive effect is also crystal
> > clear: It prefetches from swap on idle into free memory, ie: it doesn't
> > force anybody out, and they are the first to be dropped without further
> > swap-out, which sounds really smart.
> >
> > Conclusion:  Either prove swap-prefetch is broken, or get this merged
> > quick.
>
> If you can't prove why it helps and doesn't hurt, then it's a hack, by
> definition.

Ok, slow down: swap-prefetch isn't a hack.  It's a kernel-thread that adds 
swap-prefetch functionality to the kernel.

> With swap prefetch, we're only optimizing the case when the box isn't
> loaded and there's RAM free, but we're not optimizing the case when the
> box is heavily loaded and we need for RAM to be free.

Exactly, swap-prefetch is very specific, and that's why it's so successful:  
It does one thing, and it does that very well.

> I'm inclined to view swap prefetch as a successful scientific experiment,
> and use that data to inform a more reasoned engineering effort.  If we can
> design something intelligent which happens to behave more or less like
> swap prefetch does under the circumstances where swap prefetch helps, and
> does something else smart under the circumstances where swap prefetch
> makes no discernable difference, it'll be a much bigger improvement.

Well, a swapless OS would really be the ultimate, but that's another thread 
entirely (see thread: '[RFC] VM: I have a dream...')

Don't mistake swap-prefetch as trying to additionally fix swap-in slowdown, 
and if it did, then that would be a hack, but it doesn't.

Instead, understand that swap-prefetch is viable even if all swapper issues 
have been solved, because swapping implies pages being swapped in when 
needed, and swap-prefetch smartly uses idle time to do so.

> Because we cannot prove why the existing patch helps, we cannot say what
> impact it will have when things like virtualization and solid state drives
> radically change the coefficients of the equation we have not solved. 
> Providing a sysctl to turn off a misbehaving feature is a poor substitute
> for doing it right the first time, and leaving it off by default will
> ensure that it only gets used by the handful of people who know enough to
> rebuild with the patch anyway.

But we do know why it helps: a proc eats memory, then page-cache, then swaps 
others out, and then dies to free its memory, and now swap-prefetch comes in 
if the system is idle.  Sounds really smart.

While many people may definitely benefit, others may just want to turn it 
off.  No harm done.


Thanks!

--
Al
