Return-Path: <linux-kernel-owner+w=401wt.eu-S1759448AbYEMMlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759448AbYEMMlM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 08:41:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751606AbYEMMk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 08:40:58 -0400
Received: from saeurebad.de ([85.214.36.134]:53700 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299AbYEMMk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 08:40:57 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/3] bootmem2 III
References: <20080509151713.939253437@saeurebad.de>
	<20080509184044.GA19109@one.firstfloor.org>
	<87lk2gtzta.fsf@saeurebad.de> <48275493.40601@firstfloor.org>
Date: Tue, 13 May 2008 14:40:44 +0200
In-Reply-To: <48275493.40601@firstfloor.org> (Andi Kleen's message of "Sun, 11
	May 2008 22:18:27 +0200")
Message-ID: <874p92qsvn.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Andi Kleen <andi@firstfloor.org> writes:

> Johannes Weiner wrote:
>
>>> On Fri, May 09, 2008 at 05:17:13PM +0200, Johannes Weiner wrote:
>>>> here is bootmem2, a memory block-oriented boot time allocator.
>>>>
>>>> Recent NUMA topologies broke the current bootmem's assumption that
>>>> memory nodes provide non-overlapping and contiguous ranges of pages.
>>> I'm still not sure that's a really good rationale for bootmem2.
>>> e.g. the non continuous nodes are really special cases and there tends
>>> to be enough memory at the beginning which is enough for boot time
>>> use, so for those systems it would be quite reasonably to only 
>>> put the continuous starts of the nodes into bootmem.
>> 
>> Hm, that would put the logic into arch-code.  I have no strong opinion
>> about it.
>
> In fact I suspect the current code will already work like that
> implicitely. The aliasing is only a problem for the new "arbitary node
> free_bootmem" right?

And that alloc_bootmem_node() can not garuantee node-locality which is
the much worse part, I think.

>>> That said the bootmem code has gotten a little crufty and a clean
>>> rewrite might be a good idea.
>> 
>> I agree completely.
>
> The trouble is just that bootmem is used in early boot and early boot is
> very subtle and getting it working over all architectures could be a
> challenge. Not wanting to discourage you, but it's not exactly the
> easiest part of the kernel to hack on.

Bootmem seemed pretty self-contained to me, at least in the beginning.
The bad thing is that I can test only the most simple configuration with
it.

I was wondering yesterday if it would be feasible to enforce
contiguousness for nodes.  So that arch-code does not create one pgdat
for each node but one for each contiguous block.  I have not yet looked
deeper into it, but I suspect that other mm code has similar problems
with nodes spanning other nodes.

	Hannes
