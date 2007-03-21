Return-Path: <linux-kernel-owner+w=401wt.eu-S1752575AbXCUFlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbXCUFlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 01:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752357AbXCUFlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 01:41:11 -0400
Received: from holomorphy.com ([66.93.40.71]:35414 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575AbXCUFlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 01:41:09 -0400
Date: Tue, 20 Mar 2007 22:41:02 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Adam Litke <agl@us.ibm.com>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Ken Chen <kenchen@google.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] Introduce the pagetable_operations and associated helper macros.
Message-ID: <20070321054102.GF2986@holomorphy.com>
References: <20070319200502.17168.17175.stgit@localhost.localdomain> <20070319200513.17168.52238.stgit@localhost.localdomain> <4600B216.3010505@yahoo.com.au> <20070321045214.GE2986@holomorphy.com> <4600BD9F.8030609@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4600BD9F.8030609@yahoo.com.au>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
>> ISTR potential ppc64 users coming out of the woodwork for something I
>> didn't recognize the name of, but I may be confusing that with your
>> patch. I can implement additional users (and useful ones at that)
>> needing this in particular if desired.

On Wed, Mar 21, 2007 at 04:07:43PM +1100, Nick Piggin wrote:
> Yes I would be interested in seeing useful additional users of this
> that cannot use our regular virtual memory, before making it a general
> thing.
> I just don't want to see proliferation of these things, if possible.

I'm tied up elsewhere so I won't get to it in a timely fashion. Maybe
in a few weeks I can start up on the first two of the bunch.


William Lee Irwin III wrote:
>> Two fault handling methods callbacks raise an eyebrow over here at least.
>> I was vaguely hoping for unification of the fault handling callbacks.

On Wed, Mar 21, 2007 at 04:07:43PM +1100, Nick Piggin wrote:
> I don't know if it would be so clean to do that as they are at different 
> levels.
> Adam's fault is before the VM translation (and bypasses it), and mine is 
> after.

Not much of a VM translation; it's just a lookup through the software
mocked-up structures on everything save i386, x86_64, and some m68k where
they're the same thing only with hardware walkers (ISTR ia64's being
firmware a la Alpha despite the "HPW" name, though I could be wrong)
reliant on them. The drivers/etc. could just as easily use helper
functions to carry out the lookup, thereby accomplishing the
unification. There's nothing particularly fundamental about a pte
lookup. Normal arches that do software TLB refill could just as easily
consult the radix trees dangled off struct address_space or any old
data structure floating around the kernel with enough information to
translate user virtual addresses to the physical addresses they need to
fill the TLB with, and there are other kernels that literally do things
like that.

Basically, drop in to the ->fault() callback with no attempt at a pte
lookup. The drivers using the standard pagetable format can call helper
functions to do all the gruntwork surrounding that for them. Then the
more sophisticated drivers can do the necessary work by hand.

But others should really be consulted on this point. My notions in/around
this area tend to be outside the mainstream. I can anticipate that the
two ->fault() functions will look strange to people, but not what
alternatives would be most idiomatic to mainstream Linux conventions.


-- wli
