Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbYGXMiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbYGXMiP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 08:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757191AbYGXMh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 08:37:58 -0400
Received: from 8bytes.org ([88.198.83.132]:33846 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757141AbYGXMh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 08:37:56 -0400
Date: Thu, 24 Jul 2008 14:37:55 +0200
From: Joerg Roedel <joro@8bytes.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: prarit@redhat.com, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org, ed.pollard@ibm.com, epollard@redhat.com
Subject: Re: [PATCH]: PCI: GART iommu alignment fixes [v2]
Message-ID: <20080724123755.GP31439@8bytes.org>
References: <4887C2F7.6040506@redhat.com> <20080724074655.GM31439@8bytes.org> <488854DB.60307@redhat.com> <20080724193457S.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080724193457S.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 07:34:35PM +0900, FUJITA Tomonori wrote:
> On Thu, 24 Jul 2008 06:09:31 -0400
> Prarit Bhargava <prarit@redhat.com> wrote:
> >         skge->mem = pci_alloc_consistent(hw->pdev, skge->mem_size, 
> > &skge->dma);
> >         if (!skge->mem)
> >                 return -ENOMEM;
> > 
> >         BUG_ON(skge->dma & 7);
> > 
> >         if ((u64)skge->dma >> 32 != ((u64) skge->dma + skge->mem_size) 
> >  >> 32) {
> >                 printk(KERN_ERR PFX "pci_alloc_consistent region crosses 
> > 4G boundary\n");
> >                 err = -EINVAL;
> >                 goto free_pci_mem;
> >         }
> > 
> > 
> > If pci_alloc_consistent did the "right" thing, we should *never* see 
> > that warning message.
> 
> Well, I think that this is not releated with the pci_alloc_consistent
> alignment problem that you talk about.
> 
> I think that the driver tries to avoid 4GB boundary crossing
> problem. You can find some work to avoid this, for example:
> 
> http://www.ussg.iu.edu/hypermail/linux/kernel/0712.0/2206.html
> 
> pci_device_add() has the following code to avoid this:
> 
> pci_set_dma_seg_boundary(dev, 0xffffffff);
> 
> I suspect that the problem you talk about, alloc_consistent doesn't
> return the reqeuested size aligned memory, breaks anything.

But I think Prarit is right with this change. If the interface defines
this behavior the IOMMU drivers have to implement it. I am just
wondering that the problem never showed up before. The GART driver is a
few years old now.

Joerg

