Return-Path: <linux-kernel-owner+w=401wt.eu-S1754489AbYIHMCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbYIHMCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 08:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754364AbYIHMCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 08:02:35 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:25709 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344AbYIHMCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 08:02:34 -0400
X-BigFish: VPS-27(zz1432R98dR1805M936fQ853kzz10d3izzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K6VLFT-03-DIK-01
Date: Mon, 8 Sep 2008 14:02:18 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, tony.luck@intel.com,
       linux-ia64@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 5/5] swiotlb: remove GFP_DMA hack in swiotlb_alloc_coherent
Message-ID: <20080908120218.GM3189@amd.com>
References: <1220865014-1169-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1220865014-1169-2-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1220865014-1169-3-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1220865014-1169-4-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1220865014-1169-5-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1220865014-1169-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1220865014-1169-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 08 Sep 2008 12:02:18.0197 (UTC) FILETIME=[BDBA1050:01C911AA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2008 at 06:10:14PM +0900, FUJITA Tomonori wrote:
> The callers are supposed to set up the gfp flags appropriately.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Acked-by: Joerg Roedel <joerg.roedel@amd.com>

> ---
>  lib/swiotlb.c |    7 -------
>  1 files changed, 0 insertions(+), 7 deletions(-)
> 
> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> index 977edbd..3066ffe 100644
> --- a/lib/swiotlb.c
> +++ b/lib/swiotlb.c
> @@ -467,13 +467,6 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
>  	void *ret;
>  	int order = get_order(size);
>  
> -	/*
> -	 * XXX fix me: the DMA API should pass us an explicit DMA mask
> -	 * instead, or use ZONE_DMA32 (ia64 overloads ZONE_DMA to be a ~32
> -	 * bit range instead of a 16MB one).
> -	 */
> -	flags |= GFP_DMA;
> -
>  	ret = (void *)__get_free_pages(flags, order);
>  	if (ret && address_needs_mapping(hwdev, virt_to_bus(ret))) {
>  		/*
> -- 
> 1.5.5.GIT
> 
> 

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

