Return-Path: <linux-kernel-owner+w=401wt.eu-S1753344AbYK1G3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbYK1G3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 01:29:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbYK1G3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 01:29:03 -0500
Received: from sh.osrg.net ([192.16.179.4]:45063 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbYK1G3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 01:29:01 -0500
Date: Fri, 28 Nov 2008 15:28:20 +0900
To: Ian.Campbell@citrix.com
Cc: fujita.tomonori@lab.ntt.co.jp, jeremy@goop.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       x86@kernel.org
Subject: Re: [PATCH 18 of 38] x86: unify pci iommu setup and allow swiotlb
	to	compile for 32 bit
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1227806087.11549.44.camel@zakaz.uk.xensource.com>
References: <1227692209.9425.117.camel@zakaz.uk.xensource.com>
	<20081127124329X.fujita.tomonori@lab.ntt.co.jp>
	<1227806087.11549.44.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081128152816I.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2008 17:14:47 +0000
Ian Campbell <Ian.Campbell@citrix.com> wrote:

> On Thu, 2008-11-27 at 12:43 +0900, FUJITA Tomonori wrote: 
> > On Wed, 26 Nov 2008 09:36:49 +0000
> > Ian Campbell <Ian.Campbell@citrix.com> wrote:
> > 
> > > On Wed, 2008-11-26 at 11:53 +0900, FUJITA Tomonori wrote:
> > > > 
> > > > > +     BUG_ON(max_slots > 1UL << (BITS_PER_LONG - IO_TLB_SHIFT));
> > > > 
> > > > How can this BUG_ON happen? Using u64 for the mask is fine though.
> > > 
> > > It covers the cases where the previous code would have overflowed. It
> > > can't happen right now because although mask is 64 bits the value
> > > assigned to it is currently sizeof(unsigned long). If someone changes
> > > the type of that field then we would start seeing unexpected values.
> > 
> > If someone changes dma_get_seg_boundary to return a u64 value instead
> > of unsigned long, this BUG_ON could happen on 32bit architectures. But
> > you don't need to trigger BUG_ON for it. max_slots > 1UL <<
> > (BITS_PER_LONG - IO_TLB_SHIFT) should be fine for
> > iommu_is_span_boundary().
> > 
> > Anyway, this is minor but would it be nice to make sure that anyone
> > can easily understand the code without digging into the git log?
> > 
> > a) dropping this patch and adding some comments how the code works
> > (especially about the overflow on 32bit architectures).
> > 
> > b) removing the BUG_ON in this patch and adding some comments.
> 
> Yes, I think adding a comment to the existing code (option a) would be
> best.

Yeah, that should be fine.


> I actually have a small queue of other fixes which make swiotlb
> work properly for x86 PAE and HighMem but they are not particularly well
> baked at the moment. I'll include a patch to add a comment in that
> series.

I see.


Thanks,
