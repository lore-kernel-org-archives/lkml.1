Return-Path: <linux-kernel-owner+w=401wt.eu-S1758659AbYEEQE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758659AbYEEQE4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 12:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbYEEQEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 12:04:48 -0400
Received: from relay2.sgi.com ([192.48.171.30]:52381 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754546AbYEEQEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 12:04:47 -0400
Date: Mon, 5 May 2008 11:04:43 -0500
From: Robin Holt <holt@sgi.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@saeurebad.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: [rfc][patch 0/3] bootmem2: a memory block-oriented boot time
	allocator
Message-ID: <20080505160443.GG19717@sgi.com>
References: <20080505095938.326928514@symbol.fehenstaub.lan> <alpine.LFD.1.10.0805050820000.32269@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805050820000.32269@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 08:23:34AM -0700, Linus Torvalds wrote:
> 
> 
> On Mon, 5 May 2008, Johannes Weiner wrote:
> > 
> > here is a bootmem allocator replacement that uses one bitmap for all
> > available pages and works with a model of contiguous memory blocks
> > that reside on nodes instead of nodes only as the current allocator
> > does.
> 
> Won't this have problems with huge non-contiguous areas?
> 
> Some setups have traditionally had node memory separated in physical space 
> by the high bits of the memory address, and using a single bitmap for such 
> things would potentially be basically impossible - even with a single bit 
> per page, the "span" of possible pages is potentially just too high, even 
> if the nodes themselves don't have tons of memory, because the memory is 
> just very spread out - and allocating the initial bitmap may not work 
> reliably.
> 
> Now, admittedly I don't know if we even support that kind of thing or if 
> people really do things that way any more, so maybe it's not an issue.

SGI sn2 architecture does.  Each DIMM bank is allocated a 16GB range
of physical addresses.  There are up to four banks per node.  The node
number is stuck into higher portions of the address, giving a gap between
nodes of 256GB.  With a potential of 1024 nodes, you would have a very
large array.

Additionally on our upcoming UV systems, there will potentially be a
hole between the bulk of memory and a small amount addressable at the
high end of the address range (slightly short of 16TB) with the typical
gap being on the order of 15TB.

Thanks,
Robin Holt
