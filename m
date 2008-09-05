Return-Path: <linux-kernel-owner+w=401wt.eu-S1753415AbYIEKmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbYIEKmB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 06:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbYIEKlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 06:41:52 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:43532 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbYIEKlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 06:41:51 -0400
X-BigFish: VPS-26(z1823lz1432R98dR1805M936fQzz10d3izzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0K6PXP6-03-AJT-01
Date: Fri, 5 Sep 2008 12:41:29 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH] x86: gart alloc_coherent doesn't need to check NULL device argument
Message-ID: <20080905104129.GZ3189@amd.com>
References: <1220605129-18359-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1220605129-18359-2-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1220605129-18359-3-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1220605129-18359-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1220605129-18359-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 05 Sep 2008 10:41:29.0832 (UTC) FILETIME=[F4A30680:01C90F43]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

True, thanks.

On Fri, Sep 05, 2008 at 05:58:49PM +0900, FUJITA Tomonori wrote:
> asm/dma-mapping.h guarantees that gart alloc_coherent doesn't get NULL
> device argument.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Acked-by: Joerg Roedel <joerg.roedel@amd.com>

> ---
>  arch/x86/kernel/pci-gart_64.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
> index 4d08649..0b99d4a 100644
> --- a/arch/x86/kernel/pci-gart_64.c
> +++ b/arch/x86/kernel/pci-gart_64.c
> @@ -506,9 +506,6 @@ gart_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_addr,
>  
>  	align_mask = (1UL << get_order(size)) - 1;
>  
> -	if (!dev)
> -		dev = &x86_dma_fallback_dev;
> -
>  	*dma_addr = dma_map_area(dev, __pa(vaddr), size, DMA_BIDIRECTIONAL,
>  				 align_mask);
>  	flush_gart();
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

