Return-Path: <linux-kernel-owner+w=401wt.eu-S1753211AbYIFMTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbYIFMTZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 08:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750883AbYIFMTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 08:19:09 -0400
Received: from sh.osrg.net ([192.16.179.4]:58237 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbYIFMTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 08:19:08 -0400
Date: Sat, 6 Sep 2008 21:18:37 +0900
To: joerg.roedel@amd.com
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@redhat.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH] x86: use __GFP_NORETRY in the case of GFP_DMA with
 pci-nommu
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080905104305.GA3189@amd.com>
References: <1220605129-18359-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1220605129-18359-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<20080905104305.GA3189@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080906211813F.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Sep 2008 12:43:05 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> On Fri, Sep 05, 2008 at 05:58:48PM +0900, FUJITA Tomonori wrote:
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > ---
> >  arch/x86/kernel/pci-nommu.c |    3 +++
> >  1 files changed, 3 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
> > index 526b2db..3495f88 100644
> > --- a/arch/x86/kernel/pci-nommu.c
> > +++ b/arch/x86/kernel/pci-nommu.c
> > @@ -102,6 +102,9 @@ nommu_alloc_coherent(struct device *hwdev, size_t size,
> >  	if (dma_mask == DMA_24BIT_MASK)
> >  		gfp |= GFP_DMA;
> >  again:
> > +	if (gfp & GFP_DMA)
> > +		gfp |= __GFP_NORETRY;
> > +
> 
> Huh? Why that? The __GFP_NORETRY is a hint from the caller to the page
> allocator on how aggressive it should try to allocate memory. I don't
> think the DMA code should touch those flags unless there is a very very
> good reason for it.

The current comment is reasonable for me:

/* Don't invoke OOM killer or retry in lower 16MB DMA zone */
if (gfp & __GFP_DMA)
     noretry = 1;
