Return-Path: <linux-kernel-owner+w=401wt.eu-S1754208AbYEZJMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbYEZJMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 05:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbYEZJMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 05:12:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40698 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298AbYEZJMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 05:12:08 -0400
Date: Mon, 26 May 2008 11:11:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Pekka Paalanen <pq@iki.fi>
Subject: Re: [PATCH] kmemcheck: SMP support
Message-ID: <20080526091155.GE13529@elte.hu>
References: <20080523141759.GA1833@damson.getinternet.no> <20080523150622.GA9782@elte.hu> <19f34abd0805230830o3af93956h8152de3f6e350a09@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0805230830o3af93956h8152de3f6e350a09@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> On Fri, May 23, 2008 at 5:06 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > Vegard, wanna have a look at introducing per CPU kernel pagetables? I
> > tried that once in the past and it wasnt too horrible. (the patches are
> > gone though) We could do it before bringing other CPUs online, i.e. much
> > of the really yucky boot time pagetable juggling phase would be over
> > already. Hm?
> 
> Ingo.
> 
> It really doesn't matter how easy it was for you.
> 
> You're one of the x86 maintainers.
> 
> And I think you're forgetting how hard these things are for a newbie. 
> I don't even know which one comes first of pmds and puds.

hey i kept mixing that up myself, until i had to fix a bug in it once.

> Per-cpu page tables sounds about on the same scale of as, say, 
> rewriting the VM or some other major subsystem. Epic!

just to make sure: this is an optional "would be really cool" thing. It 
does not impact the mergability of kmemcheck in any way. [ It impacts 
the _usability_ of it :-) ]

> I'm glad to hear from you, though.
> 
> Pekka suggested that per-cpu page tables might help NUMA systems too. 
> Does that sound right to you? Would anybody else benefit from having 
> per-CPU page tables? If not, I have a hard time believing it will ever 
> get merged.

i tried to implement it once for 4G:4G split kernel. My early results 
indicated that especially on PAE there was a significant SMP speedup 
from it. I have not gone down that path so i dont know it for sure, but 
perhaps it was because the CPU sets the accessed bit in kernel PTEs and 
dirties those cachelines which creates overhead on SMP. That happened 
even if there was no kernel pagetable remapping activities. (That was 
many years ago and newer CPUs might be better at it though.)

> (Oh. mmio-trace might. But that's also a hacking tool and doesn't 
> really count.)

even if mmiotrace were just a hacking too (but mmiotrace is a system 
diagnostics tool as well), that could still be a strong reason to do it.

	Ingo
