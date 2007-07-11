Return-Path: <linux-kernel-owner+w=401wt.eu-S1759092AbXGKCGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759092AbXGKCGr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 22:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754284AbXGKCGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 22:06:40 -0400
Received: from ns1.suse.de ([195.135.220.2]:37407 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755229AbXGKCGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 22:06:39 -0400
Date: Wed, 11 Jul 2007 04:06:38 +0200
From: Nick Piggin <npiggin@suse.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: queued spinlock code and results
Message-ID: <20070711020638.GB27475@wotan.suse.de>
References: <20070708043228.GB22397@wotan.suse.de> <p733azz16vh.fsf@bingen.suse.de> <Pine.LNX.4.64.0707101348020.3055@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707101348020.3055@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 01:52:47PM -0700, Christoph Lameter wrote:
> On Sun, 8 Jul 2007, Andi Kleen wrote:
> 
> > I would say the main drawback of switchable and queued locks 
> > would be also that they require a larger spinlock_t thus increasing
> > cache usage
> 
> Right. Zoran Radovic has shown that queued locks are inferior 
> to other approaches. The best approach that he found in his research were 
> the HBO locks that are somewhat more intelligent form of spinlocks.
> 
> http://user.it.uu.se/~zoranr/
> http://www.it.uu.se/research/group/uart/projects/nucasynch/
> 
> Paper on the issue with measurements:
> http://www.it.uu.se/research/publications/lic/2003-008/2003-008.pdf


OK, maybe I do have my terminology wrong -- we'll call them FIFO locks
or ticket locks. The point is not to improve performance of the contended
case (although they may have slightly better contended case characteristicds),
but to improve worst case latency and improve fairness.

BTW. some advanced congestion algorithms like HBO may find these ticket
locks useful because you can see immediately how many CPUs are contending
the lock, and spinners know how many CPUs are in front of them. That info
could be fed into the spin backoff scheme.

