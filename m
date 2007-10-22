Return-Path: <linux-kernel-owner+w=401wt.eu-S1755835AbXJVShh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbXJVShh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 14:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754349AbXJVShL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 14:37:11 -0400
Received: from waste.org ([66.93.16.53]:56553 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754059AbXJVShK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 14:37:10 -0400
Date: Mon, 22 Oct 2007 13:36:56 -0500
From: Matt Mackall <mpm@selenic.com>
To: Rik van Riel <riel@redhat.com>
Cc: Roel Kluin <12o3l@tiscali.nl>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] return hidden bug
Message-ID: <20071022183656.GH17536@waste.org>
References: <471BF741.2020501@tiscali.nl> <20071021214209.1a7567d7@bree.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071021214209.1a7567d7@bree.surriel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 21, 2007 at 09:42:09PM -0400, Rik van Riel wrote:
> On Mon, 22 Oct 2007 03:05:05 +0200
> Roel Kluin <12o3l@tiscali.nl> wrote:
> 
> >     return hidden bug
> >     
> >     Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> > 
> > diff --git a/arch/alpha/kernel/pci_iommu.c
> > b/arch/alpha/kernel/pci_iommu.c index e1c4707..6a69425 100644
> > --- a/arch/alpha/kernel/pci_iommu.c
> > +++ b/arch/alpha/kernel/pci_iommu.c
> > @@ -365,8 +365,8 @@ pci_unmap_single(struct pci_dev *pdev, dma_addr_t
> > dma_addr, size_t size, printk(KERN_ERR "Bogus pci_unmap_single:
> > dma_addr %lx " " base %lx size %x\n", dma_addr, arena->dma_base,
> >  		       arena->size);
> > -		return;
> >  		BUG();
> > +		return;
> >  	}
> >  
> >  	npages = calc_npages((dma_addr & ~PAGE_MASK) + size);
> 
> BUG() will terminate the process that runs into it, so you can
> just remove the return alltogether.  If BUG() is hit, the return
> will never be reached.

Looking at the printk, I don't think this particular error ought to
forcefully kill things.

-- 
Mathematics is the supreme nostalgia of our time.
