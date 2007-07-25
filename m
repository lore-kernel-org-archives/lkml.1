Return-Path: <linux-kernel-owner+w=401wt.eu-S1763079AbXGYKsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763079AbXGYKsd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 06:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756961AbXGYKs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 06:48:26 -0400
Received: from gate.crashing.org ([63.228.1.57]:59848 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755639AbXGYKs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 06:48:26 -0400
Subject: Re: [patch] mm: reduce pagetable-freeing latencies
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>
In-Reply-To: <20070725102608.GB9045@one.firstfloor.org>
References: <20070724083855.GA858@elte.hu>
	 <20070724015441.8604d85d.akpm@linux-foundation.org>
	 <1185270045.5439.249.camel@localhost.localdomain>
	 <p73abtmt2y7.fsf@bingen.suse.de>
	 <1185312559.5439.276.camel@localhost.localdomain>
	 <1185345850.8197.64.camel@twins> <20070725094605.GA9045@one.firstfloor.org>
	 <1185358093.5439.325.camel@localhost.localdomain>
	 <20070725102608.GB9045@one.firstfloor.org>
Content-Type: text/plain
Date: Wed, 25 Jul 2007 20:46:53 +1000
Message-Id: <1185360414.5439.335.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-25 at 12:26 +0200, Andi Kleen wrote:
> > Plan is fixed array or 4 or maybe 8 entries (pointers), that shouldn't
> > be -too- bad. The code path I'm a bit worried about is
> 
> Yep.
> 
> > unmap_mapping_ranges() which goes into zapping page tables from deep
> > within filesystems.
> 
> Your aim is to conserve stack space? 
> The worst case has to work without overflow anyways, so using VLAs don't 
> help you. Just allocate the largest size you can safely afford.
> 
> This is also easier to test; if it is too large it is better when
> the overflow triggers always.
> 
> They are more useful in user space with larger stacks when you don't 
> know the maximum size.

In fact, i discussed with peter and I think the best is to only have one
entry in the stack mmu_gather structure. If we fail to allocate a page
to batch entries, we flush that one and steal it :-) Then we have a page
to gather more.

I'll give that a go tomorrow, I got delayed by some stupid HW issues
today.

Cheers,
Ben.


