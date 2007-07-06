Return-Path: <linux-kernel-owner+w=401wt.eu-S1761981AbXGFKtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761981AbXGFKtS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 06:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755300AbXGFKtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 06:49:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:53536 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753993AbXGFKtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 06:49:09 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 10/10] Scheduler profiling - Use immediate values
References: <20070703164046.645090494@polymtl.ca>
	<20070703164516.377240547@polymtl.ca>
	<20070703181151.GB5800@martell.zuzino.mipt.ru>
	<20070703185748.GA4047@Krystal>
	<20070705132120.8edbc1f3.akpm@linux-foundation.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 06 Jul 2007 13:44:33 +0200
In-Reply-To: <20070705132120.8edbc1f3.akpm@linux-foundation.org>
Message-ID: <p73vecx21um.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> Is that 48 cycles measured when the target of the read is in L1 cache, as
> it would be in any situation which we actually care about?  I guess so...

The normal situation is big database or other bloated software runs; clears 
all the dcaches, then enters kernel. Kernel has a cache miss on all its data.
But icache access is faster because the CPU prefetches.

We've had cases like this -- e.g. the additional dcache line
accesses that were added by the new time code in vgettimeofday()
were visible in macro benchmarks.

Also cache misses in this situation tend to be much more than 48 cycles
(even an K8 with integrated memory controller with fastest DIMMs is 
slower than that)  Mathieu probably measured an L2 miss, not a load from RAM.
Load from RAM can be hundreds of ns in the worst case.

I think the optimization is a good idea, although i dislike it
that it is complicated for the dynamic markers. If it was just
static it would be much simpler.

-Andi
