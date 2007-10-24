Return-Path: <linux-kernel-owner+w=401wt.eu-S1754699AbXJXIco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbXJXIco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 04:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbXJXIch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 04:32:37 -0400
Received: from brick.kernel.dk ([87.55.233.238]:5399 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339AbXJXIcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 04:32:36 -0400
Date: Wed, 24 Oct 2007 10:32:33 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: kamalesh@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       apw@shadowen.org, tomof@acm.org
Subject: Re: [BUG] 2.6.23-git18 Kernel oops in sg helpers
Message-ID: <20071024083233.GG14671@kernel.dk>
References: <471E110C.20404@linux.vnet.ibm.com> <20071024074200K.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024074200K.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24 2007, FUJITA Tomonori wrote:
> On Tue, 23 Oct 2007 20:49:40 +0530
> Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> 
> > Hi,
> > 
> > Kernel oops is triggered while running fsx-linux test, followed by cpu softlock
> > over the AMD box
> > 
> > Unable to handle kernel NULL pointer dereference at 0000000000000018 RIP: 
> >  [<ffffffff8021f2f6>] gart_map_sg+0x26c/0x406
> > PGD 10185b067 PUD 10075b067 PMD 0 
> 
> Does this work?
> 
> 
> diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
> index c56e9ee..ae7e016 100644
> --- a/arch/x86/kernel/pci-gart_64.c
> +++ b/arch/x86/kernel/pci-gart_64.c
> @@ -338,7 +338,6 @@ static int __dma_map_cont(struct scatterlist *start, int nelems,
>  		
>  		BUG_ON(s != start && s->offset);
>  		if (s == start) {
> -			*sout = *s; 
>  			sout->dma_address = iommu_bus_base;
>  			sout->dma_address += iommu_page*PAGE_SIZE + s->offset;
>  			sout->dma_length = s->length;
> @@ -365,7 +364,7 @@ static inline int dma_map_cont(struct scatterlist *start, int nelems,
>  {
>  	if (!need) {
>  		BUG_ON(nelems != 1);
> -		*sout = *start;
> +		sout->dma_address = start->dma_address;
>  		sout->dma_length = start->length;
>  		return 0;
>  	}
> -- 
> 1.5.2.4

Care to write up a proper changelog?

-- 
Jens Axboe

