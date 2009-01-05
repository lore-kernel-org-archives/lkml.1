Return-Path: <linux-kernel-owner+w=401wt.eu-S1753615AbZAER3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbZAER3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 12:29:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbZAER3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 12:29:01 -0500
Received: from 8bytes.org ([88.198.83.132]:48395 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869AbZAER3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 12:29:01 -0500
Date: Mon, 5 Jan 2009 18:28:59 +0100
From: Joerg Roedel <joro@8bytes.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] add map_page and unmap_page to struct dma_mapping_ops
Message-ID: <20090105172859.GC14298@8bytes.org>
References: <1231166848-20149-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1231166848-20149-2-git-send-email-fujita.tomonori@lab.ntt.co.jp> <20090105172608.GB14298@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090105172608.GB14298@8bytes.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 06:26:08PM +0100, Joerg Roedel wrote:
> On Mon, Jan 05, 2009 at 11:47:21PM +0900, FUJITA Tomonori wrote:
> > This patch adds map_page and unmap_page to struct dma_mapping_ops.
> > 
> > This is a preparation of struct dma_mapping_ops unification. We use
> > map_page and unmap_page instead of map_single and unmap_single.
> > 
> > We will remove map_single and unmap_single hooks in the last patch in
> > this patchset.
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > ---
> >  arch/x86/include/asm/dma-mapping.h |    8 ++++++++
> >  1 files changed, 8 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
> > index e93265c..2f89d2e 100644
> > --- a/arch/x86/include/asm/dma-mapping.h
> > +++ b/arch/x86/include/asm/dma-mapping.h
> > @@ -8,6 +8,7 @@
> >  
> >  #include <linux/kmemcheck.h>
> >  #include <linux/scatterlist.h>
> > +#include <linux/dma-attrs.h>
> >  #include <asm/io.h>
> >  #include <asm/swiotlb.h>
> >  #include <asm-generic/dma-coherent.h>
> > @@ -51,6 +52,13 @@ struct dma_mapping_ops {
> >  	void            (*unmap_sg)(struct device *hwdev,
> >  				struct scatterlist *sg, int nents,
> >  				int direction);
> > +	dma_addr_t	(*map_page)(struct device *dev, struct page *page,
> > +				    unsigned long offset, size_t size,
> > +				    enum dma_data_direction dir,
> > +				    struct dma_attrs *attrs);
> > +	void 		(*unmap_page)(struct device *dev, dma_addr_t dma_handle,
> > +				      size_t size, enum dma_data_direction dir,
> > +				      struct dma_attrs *attrs);
> 
> Why do we need an offset into the page? The name suggests that this
> function maps a whole page so the offset should be irrelevant.

Ah, just saw it. Forget this stupid question :)

