Return-Path: <linux-kernel-owner+w=401wt.eu-S935621AbZDITvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935621AbZDITvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 15:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761603AbZDITvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 15:51:06 -0400
Received: from sh.osrg.net ([192.16.179.4]:38508 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760941AbZDITvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 15:51:05 -0400
Date: Fri, 10 Apr 2009 04:50:10 +0900
To: jeremy@goop.org
Cc: fujita.tomonori@lab.ntt.co.jp, galak@kernel.crashing.org,
       hch@infradead.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       ian.campbell@citrix.com, beckyb@kernel.crashing.org
Subject: Re: [PATCH 4/7] swiotlb: Allow arch override of
 address_needs_mapping
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <49DE4A37.3080702@goop.org>
References: <49DD3C9C.7060101@goop.org>
	<20090410033357S.fujita.tomonori@lab.ntt.co.jp>
	<49DE4A37.3080702@goop.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090410045039G.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 10 Apr 2009 04:50:12 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 09 Apr 2009 12:19:19 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> FUJITA Tomonori wrote:
> >> Well, Becky's patches also added the hwdev argument to them, so 
> >> presumably the powerpc implementation needs that (different 
> >> devices/buses have differing views of physical memory, I guess).
> >>     
> >
> > Until I see the ppc specific swiotlb patchset, I'm not sure but I
> > think that we can remove phys_to_bus in swiotlb.
> >   
> 
> Kumar's comment was: "For our SoC chips we don't need any mapping 
> between phys & bus.  However something like PCI does have a mapping (a 
> simple offset)."
> 
> Kumar, could a single system have different phys<->bus mappings on a 
> single system, or could it differ from device to device (or bus to bus)?
> 
> > Even if we need phys_to_bus, we can remove the rest of __weak tricks
> > for only dom0. And we can make phys_to_bus arch-specific. Then we
> > don't need any __weak tricks in swiotlb (and x86's swiotlb). dom0
> > support adds many hacks to swiotlb.
> >   
> 
> Well, we'd still need a way to do hook the swiotlb_alloc(_boot) 
> allocation.  At the moment its effectively arch-specific because x86 
> only uses swiotlb_alloc_boot(), and ia64 only uses swiotlb_alloc().  One 

Hmm, I think that ia64 use swiotlb_alloc_boot too.

ia64 uses swiotlb in two ways; using only swiotlb, using swiotlb and
hw iommu. The latter is similar what x86 Calgary does.

