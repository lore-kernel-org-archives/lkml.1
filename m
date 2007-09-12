Return-Path: <linux-kernel-owner+w=401wt.eu-S965835AbXILAAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965835AbXILAAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 20:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964868AbXILAA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 20:00:29 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:44361 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964855AbXILAA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 20:00:27 -0400
Date: Tue, 11 Sep 2007 17:00:22 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Mel Gorman <mel@skynet.ie>, andrea@suse.de, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
In-Reply-To: <200709111617.03586.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0709111644240.29413@schroedinger.engr.sgi.com>
References: <20070911060349.993975297@sgi.com> <200709111600.18756.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0709111446080.27023@schroedinger.engr.sgi.com>
 <200709111617.03586.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2007, Nick Piggin wrote:

> > Well its seems that we have different interpretations of what was agreed
> > on. My understanding was that the large blocksize patchset was okay
> > provided that I supply an acceptable mmap implementation and put a
> > warning in.
> 
> Yes. I think we differ on our interpretations of "okay". In my interpretation,
> it is not OK to use this patch as a way to solve VM or FS or IO scalability
> issues, especially not while the alternative approaches that do _not_ have
> these problems have not been adequately compared or argued against.

We never talked about not being able to solve scalability issues with this 
patchset. The alternate approaches were discussed at the VM MiniSummit and 
at the VM/FS meeting. You organized the VM/FS summit. I know you were 
there and were arguing for your approach. That was not sufficient?

> > Well even without slab targeted reclaim: Mel's antifrag will sort the
> > dentries into separate blocks of memory and so isolate the issue.
> 
> So even after all this time you do not understand what the fundamental
> problem is with anti-frag and yet you are happy to waste both our time
> in endless flamewars telling me how wrong I am about it.

We obviously have discussed this before and the only point of asking this 
question by you seems to be to have me repeat the whole line argument 
again?

> Forgive me if I'm starting to be rude, Christoph. This is really irritating.

Sorry but I have had too much exposure to philosophy. Talk about absolutes 
like guarantees (that do not exist even for order 0 allocs) and unlikely memory 
fragmentation scenarios to show that something does not work seems to 
be getting into some metaphysical realm where there is no data anymore 
to draw any firm conclusions.

Software reliability is inherent probabilistic otherwise we would not have 
things like CRC sums and SHA1 algorithms. Its just a matter of reducing 
the failure rate sufficiently. The failure rate for lower order 
allocations (0-3) seems to have been significantly reduced in 2.6.23 
through lumpy reclaim.

If antifrag measures are not successful (likely for 2M allocs) then other 
methods (like the large page pools that you skipped when reading my post) 
will need to be used.
