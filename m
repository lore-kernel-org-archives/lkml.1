Return-Path: <linux-kernel-owner+w=401wt.eu-S1753292AbYIEKoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbYIEKoM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 06:44:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbYIEKn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 06:43:57 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:1495 "EHLO
	WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbYIEKn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 06:43:56 -0400
X-BigFish: VPS-30(zz1432R98dR1805M936fQzz10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0K6PXRX-03-ALE-01
Date: Fri, 5 Sep 2008 12:43:05 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH] x86: use __GFP_NORETRY in the case of GFP_DMA with pci-nommu
Message-ID: <20080905104305.GA3189@amd.com>
References: <1220605129-18359-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1220605129-18359-2-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1220605129-18359-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1220605129-18359-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 05 Sep 2008 10:43:06.0092 (UTC) FILETIME=[2E0322C0:01C90F44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2008 at 05:58:48PM +0900, FUJITA Tomonori wrote:
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  arch/x86/kernel/pci-nommu.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
> index 526b2db..3495f88 100644
> --- a/arch/x86/kernel/pci-nommu.c
> +++ b/arch/x86/kernel/pci-nommu.c
> @@ -102,6 +102,9 @@ nommu_alloc_coherent(struct device *hwdev, size_t size,
>  	if (dma_mask == DMA_24BIT_MASK)
>  		gfp |= GFP_DMA;
>  again:
> +	if (gfp & GFP_DMA)
> +		gfp |= __GFP_NORETRY;
> +

Huh? Why that? The __GFP_NORETRY is a hint from the caller to the page
allocator on how aggressive it should try to allocate memory. I don't
think the DMA code should touch those flags unless there is a very very
good reason for it.

>  	page = alloc_pages_node(node, gfp, get_order(size));
>  	if (!page)
>  		return NULL;
> -- 
> 1.5.4.2
> 
> 

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

