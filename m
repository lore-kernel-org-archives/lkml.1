Return-Path: <linux-kernel-owner+w=401wt.eu-S1755163AbYHTL3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbYHTL3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 07:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbYHTL3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 07:29:21 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:29376 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbYHTL3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 07:29:20 -0400
X-BigFish: VPS-47(z523l34c9jz146fK1432R98dR1447R1805M179dR936fQzz10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0K5WD8B-03-CKN-01
Date: Wed, 20 Aug 2008 13:28:59 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, mingo@redhat.com,
       tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, muli@il.ibm.com
Subject: Re: [PATCH] dma-coherent: export dma_[alloc|release]_from_coherent methods
Message-ID: <20080820112858.GY14993@amd.com>
References: <1219156366-32498-1-git-send-email-joerg.roedel@amd.com> <20080820094612.GA28492@elte.hu> <20080820101811.GA31841@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080820101811.GA31841@elte.hu>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 20 Aug 2008 11:28:59.0195 (UTC) FILETIME=[F06150B0:01C902B7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2008 at 12:18:11PM +0200, Ingo Molnar wrote:
> 
> From ed0a6445788eed1fa836442730d8fe8ab1086629 Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Wed, 20 Aug 2008 12:16:09 +0200
> Subject: [PATCH] dma-coherent: export dma_[alloc|release]_from_coherent methods
> 
> fixes modular builds:
> 
>   ERROR: "dma_alloc_from_coherent" [sound/core/snd-page-alloc.ko] undefined!
>   ERROR: "dma_release_from_coherent" [sound/core/snd-page-alloc.ko] undefined!
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/dma-coherent.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/dma-coherent.c b/kernel/dma-coherent.c
> index c1d4d5b..f013a0c 100644
> --- a/kernel/dma-coherent.c
> +++ b/kernel/dma-coherent.c
> @@ -124,6 +124,7 @@ int dma_alloc_from_coherent(struct device *dev, ssize_t size,
>  	}
>  	return (mem != NULL);
>  }
> +EXPORT_SYMBOL(dma_alloc_from_coherent);
>  
>  /**
>   * dma_release_from_coherent() - try to free the memory allocated from per-device coherent memory pool
> @@ -151,3 +152,4 @@ int dma_release_from_coherent(struct device *dev, int order, void *vaddr)
>  	}
>  	return 0;
>  }
> +EXPORT_SYMBOL(dma_release_from_coherent);

Hmm, weird. I should have found this with the allmodconfig build test.
Anyway, thanks for the fix.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

