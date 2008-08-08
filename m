Return-Path: <linux-kernel-owner+w=401wt.eu-S1761254AbYHHVP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761254AbYHHVP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 17:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754239AbYHHVPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:15:50 -0400
Received: from sh.osrg.net ([192.16.179.4]:53538 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753245AbYHHVPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:15:50 -0400
Date: Sat, 9 Aug 2008 06:13:36 +0900
To: jbarnes@virtuousgeek.org
Cc: prarit@redhat.com, muli@il.ibm.com, fujita.tomonori@lab.ntt.co.jp,
       joro@8bytes.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, jakub@redhat.com
Subject: Re: [PATCH]: PCI: GART iommu alignment fixes [v2]
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <200808080915.52459.jbarnes@virtuousgeek.org>
References: <20080808071244.GB6931@il.ibm.com>
	<489C63D1.1000407@redhat.com>
	<200808080915.52459.jbarnes@virtuousgeek.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080809061348V.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2008 09:15:51 -0700
Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Friday, August 8, 2008 8:18 am Prarit Bhargava wrote:
> > --- a/include/linux/dma-mapping.h
> > +++ b/include/linux/dma-mapping.h
> > @@ -78,7 +78,7 @@ static inline unsigned int dma_set_max_seg_size(struct
> > device
> >  static inline unsigned long dma_get_seg_boundary(struct device *dev)
> >  {
> >         return dev->dma_parms ?
> > -               dev->dma_parms->segment_boundary_mask : 0xffffffff;
> > +               dev->dma_parms->segment_boundary_mask : 0xffffffffUL;
> >  }
> 
> Yeah generally you need to cast values like this when working with real 
> unsigned long values rather than ints, but this *should* still be safe 
> (barring a compiler bug).  The return type is unsigned long, so even if you 
> just return 0xffffffff the right thing should still happen...

I told Prarid that the overflow should not happen here again and
again...
