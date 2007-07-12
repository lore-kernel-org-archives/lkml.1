Return-Path: <linux-kernel-owner+w=401wt.eu-S1762669AbXGLJqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762669AbXGLJqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 05:46:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755796AbXGLJpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 05:45:55 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:53082 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292AbXGLJpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 05:45:54 -0400
Date: Thu, 12 Jul 2007 13:46:06 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Hugh Dickins <hugh@veritas.com>
Cc: Bob Tracy <rct@gherkin.frus.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.22-rc6 bad page error
Message-ID: <20070712134606.A10012@jurassic.park.msu.ru>
References: <20070709185324.387ACDBA1@gherkin.frus.com> <Pine.LNX.4.64.0707102120550.7594@blonde.wat.veritas.com> <20070711170245.A1148@jurassic.park.msu.ru> <Pine.LNX.4.64.0707111743580.22786@blonde.wat.veritas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
In-Reply-To: <Pine.LNX.4.64.0707111743580.22786@blonde.wat.veritas.com>; from hugh@veritas.com on Wed, Jul 11, 2007 at 06:07:59PM +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2007 at 06:07:59PM +0100, Hugh Dickins wrote:
> > +	gfp &= ~GFP_DMA;
> 
> The canonical form for this masking, even on arches without HIGHMEM,
> appears to be:
> 	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM);
> But I guess that won't make any actual difference.

As far as I can see, none of 64-bit architectures masks the HIGHMEM
(or any other) bits. It's just not obvious because most of their
"alloc_coherent" routines are hidden in iommu_ops or something like that.

> > +	return __pci_alloc_consistent(dev, size, dma, GFP_ATOMIC);
> 
> I was going to ask you why that needs to be GFP_ATOMIC on Alpha.
> But find you're following the example of asm-generic and others.
> So really should be asking Sparc how it gets away with GFP_KERNEL.

According to DMA-mapping.txt GFP_ATOMIC is mandatory for
pci_alloc_consistent() since it can be called from interrupt context.
So sparc code is probably incorrect...

Ivan.
