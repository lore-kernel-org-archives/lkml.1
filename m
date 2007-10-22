Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbXJVBmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbXJVBmV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 21:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751032AbXJVBmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 21:42:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbXJVBmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 21:42:13 -0400
Date: Sun, 21 Oct 2007 21:42:09 -0400
From: Rik van Riel <riel@redhat.com>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] return hidden bug
Message-ID: <20071021214209.1a7567d7@bree.surriel.com>
In-Reply-To: <471BF741.2020501@tiscali.nl>
References: <471BF741.2020501@tiscali.nl>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2007 03:05:05 +0200
Roel Kluin <12o3l@tiscali.nl> wrote:

>     return hidden bug
>     
>     Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> 
> diff --git a/arch/alpha/kernel/pci_iommu.c
> b/arch/alpha/kernel/pci_iommu.c index e1c4707..6a69425 100644
> --- a/arch/alpha/kernel/pci_iommu.c
> +++ b/arch/alpha/kernel/pci_iommu.c
> @@ -365,8 +365,8 @@ pci_unmap_single(struct pci_dev *pdev, dma_addr_t
> dma_addr, size_t size, printk(KERN_ERR "Bogus pci_unmap_single:
> dma_addr %lx " " base %lx size %x\n", dma_addr, arena->dma_base,
>  		       arena->size);
> -		return;
>  		BUG();
> +		return;
>  	}
>  
>  	npages = calc_npages((dma_addr & ~PAGE_MASK) + size);

BUG() will terminate the process that runs into it, so you can
just remove the return alltogether.  If BUG() is hit, the return
will never be reached.

-- 
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan
