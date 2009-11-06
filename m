Return-Path: <linux-kernel-owner+w=401wt.eu-S1759214AbZKFEJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759214AbZKFEJJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 23:09:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759160AbZKFEJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 23:09:08 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:37528 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756091AbZKFEJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 23:09:08 -0500
Subject: Re: [PATCH] intel-iommu: Obey coherent_dma_mask for alloc_coherent
 on	passthrough
From: Alex Williamson <alex.williamson@hp.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: dwmw2@infradead.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20091106123400J.fujita.tomonori@lab.ntt.co.jp>
References: <20091104225359.2720.91502.stgit@nehalem.aw>
	 <20091106114130J.fujita.tomonori@lab.ntt.co.jp>
	 <1257477592.2837.94.camel@2710p.home>
	 <20091106123400J.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Nov 2009 21:09:08 -0700
Message-ID: <1257480548.2837.121.camel@2710p.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-06 at 12:34 +0900, FUJITA Tomonori wrote:
> On Thu, 05 Nov 2009 20:19:52 -0700
> Alex Williamson <alex.williamson@hp.com> wrote:
> > On Fri, 2009-11-06 at 11:41 +0900, FUJITA Tomonori wrote:
> >
> > > This is fine for 2.6.32 but we'll cleanly fix this by using
> > > swiotlb_dma_ops later, right?
> > 
> > I'm open to suggestions.  I don't really understand why we dropped
> > swiotlb for passthrough mode in 2.6.32 to start with.  It seems like we
> > now have a couple corner cases where we have to either hope for the best
> > or effectively ignore the request to use passthrough.  Thanks,
> 
> I think that the cleanest solution is setting up swiotlb_dma_ops for
> passthrough devices (and devices not behind pci, etc). Calgary IOMMU
> does the same for years.

intel-iommu was using swiotlb for the global dma_ops when in passthrough
mode until 19943b0e (2.6.31 and earlier).  I would say the next step
would be to use per device dma_ops so we can point passthrough devices
to swiotlb, as you suggest, but that seems to work against part of what
19943b0e was trying to accomplish.

Alex

