Return-Path: <linux-kernel-owner+w=401wt.eu-S1756277AbXIRF6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277AbXIRF6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 01:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753651AbXIRF6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 01:58:08 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:18337 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029AbXIRF6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 01:58:07 -0400
Date: Tue, 18 Sep 2007 07:58:03 +0200
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Borislav Petkov <bbpetkov@yahoo.de>
Cc: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 0/2] unify DMA_..BIT_MASK definitions: v1
Message-ID: <20070918055803.GB4640@rhun.haifa.ibm.com>
References: <20070918042919.GA8998@gollum.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070918042919.GA8998@gollum.tnic>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2007 at 06:29:19AM +0200, Borislav Petkov wrote:
> These patches remove redundant DMA_..BIT_MASK definitions across two drivers.
> In this version of the patches, the computation of the bitmasks is done by
> the compiler.
> 
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> 
> --
> Index: 23-rc6/include/linux/dma-mapping.h
> ===================================================================
> --- 23-rc6/include/linux/dma-mapping.h.orig	2007-09-17 17:48:20.000000000 +0200
> +++ 23-rc6/include/linux/dma-mapping.h	2007-09-18 06:12:33.000000000 +0200
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
> +#define DMA_64BIT_MASK	DMA_BIT_MASK(64)

This one does not do what you mean. You need an explicit mask or a
~0ULL here.

Cheers,
Muli
