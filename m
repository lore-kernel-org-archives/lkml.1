Return-Path: <linux-kernel-owner+w=401wt.eu-S1754231AbYLSHCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231AbYLSHCT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 02:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752374AbYLSHCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 02:02:04 -0500
Received: from gw.goop.org ([64.81.55.164]:52490 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615AbYLSHCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 02:02:03 -0500
Message-ID: <494B46E8.1000104@goop.org>
Date: Thu, 18 Dec 2008 23:02:00 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Becky Bruce <beckyb@kernel.crashing.org>
CC: Ingo Molnar <mingo@elte.hu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       xen-devel@lists.xensource.com, x86@kernel.org, ian.campbell@citrix.com,
       jbeulich@novell.com, joerg.roedel@amd.com,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 00 of 14] swiotlb/x86: lay groundwork for xen dom0 use
 of swiotlb
References: <20081216203513.GA14787@elte.hu> <20081217142637V.fujita.tomonori@lab.ntt.co.jp> <4949296F.7000701@goop.org> <20081218015705Z.fujita.tomonori@lab.ntt.co.jp> <E5300CC0-1D08-46F7-91F6-DEC36202F1DE@kernel.crashing.org> <20081218210231.GB24271@elte.hu> <3853A0F2-F817-4263-9EF9-9A0655BF95CD@kernel.crashing.org>
In-Reply-To: <3853A0F2-F817-4263-9EF9-9A0655BF95CD@kernel.crashing.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Becky Bruce wrote:
> I've taken a quick look at the series posted to the list, and they're 
> actually very similar to what I've done.  I think there are really 
> only 3 fairly minor issues that need to be resolved to make this work 
> on ppc:
>
> 1) We need to add swiotlb_map/unmap_page calls, as those are part the 
> ppc dma_mapping_ops (in fact, we don't have map/unmap_single in the 
> dma_mapping_ops struct on ppc anymore - those just call 
> map/unmap_page).  This is really just a matter of moving some code 
> around and making some minor changes, as swiotlb_map/unmap_single can 
> call swiotlb_map/unmap_page once the args have been converted.  
> There's a patch in my series that should make this pretty obvious.
>
> 2) To convert any address to/from a bus address, we also need the 
> hwdev pointer passed as an argument since ppc supports a per-device 
> offset accessed via the device ptr that is used to calculate the bus 
> address.  I'd also given my conversion functions more generic names, 
> as it seemed highly likely that these would eventually be useful 
> outside of the swiotlb code.
>
> 3) powerpc uses enum dma_data_direction for the direction argument to 
> its dma_ops, which is, from reading the kernel docs, the correct 
> argument type for the DMA API functions.  However, the iotlb/x86/ia64 
> code is currently using an int.  This causes a build warning when we 
> initialize the dma_ops struct using the swiotlb funcs.  Is there a 
> reason for the use of "int" in x86/ia64?  The Right Thing(TM) here 
> seems to be to convert those over to using the enum, and I have a big 
> patch that starts doing that, but I've probably missed some places.  I 
> could instead do some hackery on the ppc side, and leave the other 
> platforms alone, but I'd prefer to do it cleanly. Thoughts?
>
> Unfortunately, this is horrible timing for me, as starting tomorrow, 
> I'm going to be offline for a week and a half or so in podunk 
> Louisiana with essentially no net access.  I can integrate my code 
> into your tree and test on PPC as soon as I return to the real world.

Yeah, I think that's OK.  The important thing at this point is to 
determine whether the two patch sets are aligned or conflicting.  It 
sounds like they're largely aligned, and so generating a delta from my 
patches to match your needs will be relatively straightforward.

I'm trying to line all this Xen stuff up for this merge window, so I'd 
prefer to revisit it in the next dev cycle.  Did you want to get 
something into this merge window?

    J
