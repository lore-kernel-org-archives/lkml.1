Return-Path: <linux-kernel-owner+w=401wt.eu-S935148AbZDISvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935148AbZDISvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 14:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758886AbZDISvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 14:51:04 -0400
Received: from sh.osrg.net ([192.16.179.4]:43019 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758327AbZDISvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 14:51:02 -0400
Date: Fri, 10 Apr 2009 03:50:13 +0900
To: galak@kernel.crashing.org
Cc: fujita.tomonori@lab.ntt.co.jp, jeremy@goop.org, hch@infradead.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, ian.campbell@citrix.com,
       beckyb@kernel.crashing.org
Subject: Re: [PATCH 4/7] swiotlb: Allow arch override of
 address_needs_mapping
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4D1571C8-53B8-4A4E-BCE8-7267ED262189@kernel.crashing.org>
References: <49DD270A.6060506@goop.org>
	<20090409080143C.fujita.tomonori@lab.ntt.co.jp>
	<4D1571C8-53B8-4A4E-BCE8-7267ED262189@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090410035037U.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 10 Apr 2009 03:50:14 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Apr 2009 23:59:18 -0500
Kumar Gala <galak@kernel.crashing.org> wrote:

> 
> On Apr 8, 2009, at 6:01 PM, FUJITA Tomonori wrote:
> 
> >> Becky's patches of last week also added __weak annotations to
> >> swiotlb_bus_to_virt, virt_to_bus and bus_to_phys; added the hwdev
> >> parameter to swiotlb_bus_to_phys; and added a weak
> >> swiotlb_arch_address_needs_mapping.  I assume that was needed because
> >> powerpc needs non-trivial implementations for those functions.
> >
> > Hmm, what she added are wrappers of virt_to_bus and bus_to_virt. We
> > can remove these and directly use virt_to_bus and bus_to_virt.
> >
> > About __weak address_needs_mapping function, as I said, removing it
> > and using dma_map_ops is a proper solution.
> 
> Is this something you are looking at doing in the .31 timeframe?
> 
> I'm looking at the fact that we need to switch over to using struct  
> dma_map_ops on ppc.  (I'm guessing this might be the patches you  
> mentioned the other day).  If so did you add set_dma_mask() to the  
> generic dma_map_ops?

Yeah, I'll send patches to convert ppc to use dma_map_ops. In .31
timeframe, I plan to:

- add a generic dma-mapping.h and convert ia64, x86, and ppc to use it

- clean up swiotlb.

- try to convert archs supporting multiple dma ops to use dma_map_ops

- rewrite ia64 and x86 dma ops initialization


BTW, the ppc specific swiotlb patchset is available?
