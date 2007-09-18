Return-Path: <linux-kernel-owner+w=401wt.eu-S1758633AbXIRGfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633AbXIRGfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 02:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756833AbXIRGfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 02:35:31 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41512 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756725AbXIRGfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 02:35:30 -0400
Date: Tue, 18 Sep 2007 12:08:21 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Borislav Petkov <bbpetkov@yahoo.de>
cc: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
       Muli Ben-Yehuda <muli@il.ibm.com>
Subject: Re: [PATCH 0/2] unify DMA_..BIT_MASK definitions: v2
In-Reply-To: <20070918061609.GA15940@gollum.tnic>
Message-ID: <alpine.LFD.0.999.0709181204030.14771@enigma.security.iitk.ac.in>
References: <20070918061609.GA15940@gollum.tnic>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 18 Sep 2007, Borislav Petkov wrote:

> These patches remove redundant DMA_..BIT_MASK definitions across
> two drivers. In this version of the patches, the computation
> of the majority of the bitmasks is done by the compiler.
> 
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: Muli Ben-Yehuda <muli@il.ibm.com>

Just a friendly note to whoever (Jeremy?) picks up these patches --
kindly fold all three into a single git commit. No point introducing
new compile warnings to the kernel build process for no good reason
(and some archs do set -Werror in their top level Makefiles, even).


> ---
>  23-rc6/include/linux/dma-mapping.h |   23 +++++++++++++----------
>  1 file changed, 13 insertions(+), 10 deletions(-)
> 
> Index: b/23-rc6/include/linux/dma-mapping.h
> ===================================================================
> --- a/23-rc6/include/linux/dma-mapping.h	2007-09-17 17:48:20.000000000 +0200
> +++ b/23-rc6/include/linux/dma-mapping.h	2007-09-18 08:11:19.000000000 +0200
      ^^^^^^^^^

And whoever picks these up is gonna have trouble applying them too.

Borislav, care to have another shot at this ?

Thanks,
Satyam


> @@ -13,16 +13,19 @@
>  	DMA_NONE = 3,
>  };
>  
> -#define DMA_64BIT_MASK	0xffffffffffffffffULL
> -#define DMA_48BIT_MASK	0x0000ffffffffffffULL
> -#define DMA_40BIT_MASK	0x000000ffffffffffULL
> -#define DMA_39BIT_MASK	0x0000007fffffffffULL
> -#define DMA_32BIT_MASK	0x00000000ffffffffULL
> -#define DMA_31BIT_MASK	0x000000007fffffffULL
> -#define DMA_30BIT_MASK	0x000000003fffffffULL
> -#define DMA_29BIT_MASK	0x000000001fffffffULL
> -#define DMA_28BIT_MASK	0x000000000fffffffULL
> -#define DMA_24BIT_MASK	0x0000000000ffffffULL
> +#define DMA_BIT_MASK(n)	((1ULL<<(n))-1)
> +
> +#define DMA_64BIT_MASK	~0ULL
> +#define DMA_48BIT_MASK	DMA_BIT_MASK(48)
> +#define DMA_40BIT_MASK	DMA_BIT_MASK(40)
> +#define DMA_39BIT_MASK	DMA_BIT_MASK(39)
> +#define DMA_35BIT_MASK	DMA_BIT_MASK(35)
> +#define DMA_32BIT_MASK	DMA_BIT_MASK(32)
> +#define DMA_31BIT_MASK	DMA_BIT_MASK(31)
> +#define DMA_30BIT_MASK	DMA_BIT_MASK(30)
> +#define DMA_29BIT_MASK	DMA_BIT_MASK(29)
> +#define DMA_28BIT_MASK	DMA_BIT_MASK(28)
> +#define DMA_24BIT_MASK	DMA_BIT_MASK(24)
>  
>  static inline int valid_dma_direction(int dma_direction)
>  {
