Return-Path: <linux-kernel-owner+w=401wt.eu-S1752873AbZKJB2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873AbZKJB2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 20:28:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbZKJB2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 20:28:35 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:32081 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbZKJB2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 20:28:34 -0500
Subject: Re: [PATCH] intel-iommu: Obey coherent_dma_mask for alloc_coherent
 on passthrough
From: Alex Williamson <alex.williamson@hp.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <1257814906.25961.916.camel@macbook.infradead.org>
References: <20091104225359.2720.91502.stgit@nehalem.aw>
	 <1257814014.25961.912.camel@macbook.infradead.org>
	 <1257814906.25961.916.camel@macbook.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Nov 2009 18:28:34 -0700
Message-ID: <1257816514.2867.88.camel@2710p.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-10 at 01:01 +0000, David Woodhouse wrote:
> On Tue, 2009-11-10 at 00:46 +0000, David Woodhouse wrote:
> > 
> >         if (iommu_no_mapping(hwdev))
> > -               return paddr;
> > +               return paddr > dma_mask - size ? 0 : paddr; 
> 
> Hm, that's still wrong. If your mask is 0xffffffff and you map
> 0xfffff000 + 0x1000, that should be allowed, right? How about:
> 
> 	return paddr <= dma_mask - size + 1 ? paddr : 0;

Ok, I was going to suggest that there was probably a -1 missing from my
patch.  I'd also be surprised if you could actually get a paddr + size -
1 from a single allocation that would wrap.  Would a device even be able
to handle that for DMA?

> And is this strictly necessary as part of the patch we're discussing?

Yeah, we could probably do without it.  As for the commit comment, it's
rather scathing, but I can live with it.  Thanks,

Alex

