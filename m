Return-Path: <linux-kernel-owner+w=401wt.eu-S1755720AbYIPRyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720AbYIPRyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 13:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753615AbYIPRyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 13:54:08 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45530 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbYIPRyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 13:54:07 -0400
Date: Tue, 16 Sep 2008 19:58:24 +0200
From: Andi Kleen <andi@firstfloor.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: andi@firstfloor.org, mingo@elte.hu, joerg.roedel@amd.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] fix GART to respect device's dma_mask about virtual mappings
Message-ID: <20080916175824.GF25711@one.firstfloor.org>
References: <87hc8grjuf.fsf@basil.nowhere.org> <20080916222032O.fujita.tomonori@lab.ntt.co.jp> <20080916134335.GC25711@one.firstfloor.org> <20080917021319O.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080917021319O.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Those always are handled elsewhere in the block layer (using the bounce_pfn
> > mechanism)
> 
> I don't think that the bounce guarantees that dma_alloc_coherent()
> returns an address that a device can access to.

dma_alloc_coherent() is not used for block IO data. And dma_alloc_coherent()
does handle masks > 24bit < 32bits just fine.


> I'm not familiar with what the networking does, for example, seems
> that b44 sets dev->dma_mask to DMA_30BIT_MASK and b44_start_xmit()
> does:
> 

b44 (and related designs like the bcm wireless chipset) 
has its own bouncing scheme. IT doesn't need any hacks in map_sg
 
> IOMMUs can try to return an address that the NIC can access to.

It's not worth to handle this strange case. The drivers do anyways.
These are very cheap devices which are only rarely used in systems
with >2GB and for those cases the existing bouncing setup works fine.

-Andi

-- 
ak@linux.intel.com
