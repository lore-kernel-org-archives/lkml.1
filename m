Return-Path: <linux-kernel-owner+w=401wt.eu-S1756127AbZJ0C0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127AbZJ0C0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 22:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbZJ0C0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 22:26:38 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:35384 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039AbZJ0C0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 22:26:37 -0400
Subject: Re: [PATCH 1/5] dma: create dma_generic_alloc/free_coherent()
From: Alex Williamson <alex.williamson@hp.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: dwmw2@infradead.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
In-Reply-To: <20091027005748.GB17085@linux-sh.org>
References: <20091026232401.9646.90540.stgit@nehalem.aw>
	 <20091026232458.9646.36818.stgit@nehalem.aw>
	 <20091027005748.GB17085@linux-sh.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Oct 2009 20:26:39 -0600
Message-ID: <1256610399.19177.3.camel@2710p.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-27 at 09:57 +0900, Paul Mundt wrote:
> On Mon, Oct 26, 2009 at 05:24:58PM -0600, Alex Williamson wrote:
> > Move dma_generic_alloc_coherent() out of x86 code and create
> > corresponding dma_generic_free_coherent() for symmetry.  These
> > can then be used by IOMMU drivers attempting to implement
> > passthrough mode.
> > 
> Except that dma_generic_alloc_coherent() is only "generic" for platforms
> with consistent DMA. Everyone else will need a cacheflush and potentially
> a remap. It's not even obvious from looking at the consistent DMA
> platforms that they'll be able to use it out of the box due to expecting
> something other than page_address(), which all suggests that this is
> better off remaining an x86-only routine.
> 
> This is also making changes to the DMA-API without any documentation
> updates and without consulting with any other architecture people.

Ok, thanks for the feedback.  Let's forget this patch and I'll see how
amenable David is to doing something within intel-iommu since it only
supports platforms with consistent DMA.  Thanks,

Alex

