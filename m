Return-Path: <linux-kernel-owner+w=401wt.eu-S1753645AbYIHLlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645AbYIHLlw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 07:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbYIHLlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 07:41:45 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:56382 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbYIHLlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 07:41:44 -0400
X-BigFish: VPS-30(zz1432R98dR1805M936fQzz10d3izzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K6VKGW-03-CUB-01
Date: Mon, 8 Sep 2008 13:41:19 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH] x86: use __GFP_NORETRY in the case of GFP_DMA with pci-nommu
Message-ID: <20080908114119.GH3189@amd.com>
References: <1220605129-18359-2-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1220605129-18359-3-git-send-email-fujita.tomonori@lab.ntt.co.jp> <20080905104305.GA3189@amd.com> <20080906211813F.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080906211813F.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 08 Sep 2008 11:41:19.0454 (UTC) FILETIME=[CF751FE0:01C911A7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 06, 2008 at 09:18:37PM +0900, FUJITA Tomonori wrote:
> On Fri, 5 Sep 2008 12:43:05 +0200
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > On Fri, Sep 05, 2008 at 05:58:48PM +0900, FUJITA Tomonori wrote:
> > > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > > ---
> > >  arch/x86/kernel/pci-nommu.c |    3 +++
> > >  1 files changed, 3 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
> > > index 526b2db..3495f88 100644
> > > --- a/arch/x86/kernel/pci-nommu.c
> > > +++ b/arch/x86/kernel/pci-nommu.c
> > > @@ -102,6 +102,9 @@ nommu_alloc_coherent(struct device *hwdev, size_t size,
> > >  	if (dma_mask == DMA_24BIT_MASK)
> > >  		gfp |= GFP_DMA;
> > >  again:
> > > +	if (gfp & GFP_DMA)
> > > +		gfp |= __GFP_NORETRY;
> > > +
> > 
> > Huh? Why that? The __GFP_NORETRY is a hint from the caller to the page
> > allocator on how aggressive it should try to allocate memory. I don't
> > think the DMA code should touch those flags unless there is a very very
> > good reason for it.
> 
> The current comment is reasonable for me:
> 
> /* Don't invoke OOM killer or retry in lower 16MB DMA zone */
> if (gfp & __GFP_DMA)
>      noretry = 1;

Ok, so please add a comment to this so we know in the future why this is
there.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

