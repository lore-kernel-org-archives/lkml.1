Return-Path: <linux-kernel-owner+w=401wt.eu-S1761423AbYEPUnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761423AbYEPUnY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 16:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760589AbYEPUnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 16:43:09 -0400
Received: from saeurebad.de ([85.214.36.134]:45847 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760192AbYEPUnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 16:43:05 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/3] bootmem2 III
References: <20080509151713.939253437@saeurebad.de>
	<20080509184044.GA19109@one.firstfloor.org>
	<87lk2gtzta.fsf@saeurebad.de> <48275493.40601@firstfloor.org>
	<874p92qsvn.fsf@saeurebad.de> <20080515191210.GE21787@shadowen.org>
Date: Fri, 16 May 2008 22:42:51 +0200
In-Reply-To: <20080515191210.GE21787@shadowen.org> (Andy Whitcroft's message
	of "Thu, 15 May 2008 20:12:10 +0100")
Message-ID: <87zlqqx9o4.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

Andy Whitcroft <apw@shadowen.org> writes:

> On Tue, May 13, 2008 at 02:40:44PM +0200, Johannes Weiner wrote:
>> Hi,
>> 
>> Andi Kleen <andi@firstfloor.org> writes:
>> 
>> > Johannes Weiner wrote:
>> >
>> >>> On Fri, May 09, 2008 at 05:17:13PM +0200, Johannes Weiner wrote:
>> >>>> here is bootmem2, a memory block-oriented boot time allocator.
>> >>>>
>> >>>> Recent NUMA topologies broke the current bootmem's assumption that
>> >>>> memory nodes provide non-overlapping and contiguous ranges of pages.
>> >>> I'm still not sure that's a really good rationale for bootmem2.
>> >>> e.g. the non continuous nodes are really special cases and there tends
>> >>> to be enough memory at the beginning which is enough for boot time
>> >>> use, so for those systems it would be quite reasonably to only 
>> >>> put the continuous starts of the nodes into bootmem.
>> >> 
>> >> Hm, that would put the logic into arch-code.  I have no strong opinion
>> >> about it.
>> >
>> > In fact I suspect the current code will already work like that
>> > implicitely. The aliasing is only a problem for the new "arbitary node
>> > free_bootmem" right?
>> 
>> And that alloc_bootmem_node() can not garuantee node-locality which is
>> the much worse part, I think.
>> 
>> >>> That said the bootmem code has gotten a little crufty and a clean
>> >>> rewrite might be a good idea.
>> >> 
>> >> I agree completely.
>> >
>> > The trouble is just that bootmem is used in early boot and early boot is
>> > very subtle and getting it working over all architectures could be a
>> > challenge. Not wanting to discourage you, but it's not exactly the
>> > easiest part of the kernel to hack on.
>> 
>> Bootmem seemed pretty self-contained to me, at least in the beginning.
>> The bad thing is that I can test only the most simple configuration with
>> it.
>> 
>> I was wondering yesterday if it would be feasible to enforce
>> contiguousness for nodes.  So that arch-code does not create one pgdat
>> for each node but one for each contiguous block.  I have not yet looked
>
> That re-introduces the concept that a node is not a unit of numa locality,
> but one of memory contiguity.  The kernel pretty much assumes that a node
> exhibits memory locality.

Okay.

>> deeper into it, but I suspect that other mm code has similar problems
>> with nodes spanning other nodes.
>
> One thing we do know is that we already have systems in the wild with
> overlapping nodes.  PowerPC systems sometimes exhibit this behaviour, the
> ones I have seen have node 1 embedded within node 0.  x86_64 also enables
> this support.  This necessitated checks when initially freeing memory
> into the allocator to make sure it ended up freed into the right node.
> For non-sparsemem configurations these systems have some wasted mem_map,
> but otherwise it does work.
>
> Check out NODES_SPAN_OTHER_NODES for the code to avoid miss-placing
> memory.

Will have a better look at all this.  Thanks for the comment.

	Hannes
