Return-Path: <linux-kernel-owner+w=401wt.eu-S1765366AbYCDQSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765366AbYCDQSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 11:18:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764573AbYCDQSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 11:18:21 -0500
Received: from hel.is.scarlet.be ([193.74.71.26]:35128 "EHLO hel.is.scarlet.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755716AbYCDQSU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:18:20 -0500
Date: Tue,  4 Mar 2008 17:13:55 +0100
Message-Id: <JX7RR7$3528E2939A349F65E12E3F27315EEC50@scarlet.be>
Subject: Re: [PATCH -mm 0/3] fix iommu segment boundary problems (parisc)
MIME-Version: 1.0
X-Sensitivity: 3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
From: "rubisher" <rubisher@scarlet.be>
To: "fujita\.tomonori" <fujita.tomonori@lab.ntt.co.jp>
Cc: "tomof" <tomof@acm.org>, "kyle" <kyle@mcmartin.ca>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-parisc" <linux-parisc@vger.kernel.org>, "tomof" <tomof@acm.org>,
       "kyle" <kyle@parisc-linux.org>, "matthew" <matthew@wil.cx>,
       "grundler" <grundler@parisc-linux.org>,
       "akpm" <akpm@linux-foundation.org>,
       "fujita\.tomonori" <fujita.tomonori@lab.ntt.co.jp>,
       "rubisher" <rubisher@scarlet.be>
X-XaM3-API-Version: 4.1 (B54)
X-type: 0
X-SenderIP: 57.67.177.33
X-DCC-scarlet.be-Metrics: hel; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[snip]
> > Can you try the following patch? It's on the top of the patchset.
> > 
> Good catch: now this first testing system (I mean the b2k) is up and running ;-)
> 
> I will now try the ccio_dma driver on a d380 ...
> 
Yes, it works too on a d380 boxe running a 32bit up kernel.

Btw (it was a long time ago), I also resurrect my 64 config for the b2k model
and it also works fine.

Many tx again,
    r.

> hth,
>     r.
> 
> > Thanks,
> > 
> > diff --git a/drivers/parisc/ccio-dma.c b/drivers/parisc/ccio-dma.c
> > index 2f3b364..d0855a1 100644
> > --- a/drivers/parisc/ccio-dma.c
> > +++ b/drivers/parisc/ccio-dma.c
> > @@ -366,8 +366,8 @@ ccio_alloc_range(struct ioc *ioc, struct device *dev,
> size_t size)
> >  	** ggg sacrifices another 710 to the computer gods.
> >  	*/
> >  
> > -	boundary_size = ALIGN(dma_get_seg_boundary(dev) + 1, 1 << IOVP_SHIFT);
> > -	boundary_size >>= IOVP_SHIFT;
> > +	boundary_size = ALIGN((unsigned long long)dma_get_seg_boundary(dev) + 1,
> > +			      1ULL << IOVP_SHIFT) >> IOVP_SHIFT;
> >  
> >  	if (pages_needed <= 8) {
> >  		/*
> > diff --git a/drivers/parisc/sba_iommu.c b/drivers/parisc/sba_iommu.c
> > index e834127..bdbe780 100644
> > --- a/drivers/parisc/sba_iommu.c
> > +++ b/drivers/parisc/sba_iommu.c
> > @@ -341,8 +341,8 @@ sba_search_bitmap(struct ioc *ioc, struct device *dev,
> >  	unsigned long shift;
> >  	int ret;
> >  
> > -	boundary_size = ALIGN(dma_get_seg_boundary(dev) + 1, 1 << IOVP_SHIFT);
> > -	boundary_size >>= IOVP_SHIFT;
> > +	boundary_size = ALIGN((unsigned long long)dma_get_seg_boundary(dev) + 1,
> > +			      1ULL << IOVP_SHIFT) >> IOVP_SHIFT;
> >  
> >  #if defined(ZX1_SUPPORT)
> >  	BUG_ON(ioc->ibase & ~IOVP_MASK);
> > --

---
Scarlet One, ADSL 6 Mbps + Telephone, from EUR 29,95...
http://www.scarlet.be/

