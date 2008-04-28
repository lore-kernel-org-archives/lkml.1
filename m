Return-Path: <linux-kernel-owner+w=401wt.eu-S932090AbYD1NGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090AbYD1NGW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 09:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934269AbYD1NFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 09:05:35 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:39822 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934264AbYD1NFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 09:05:34 -0400
Date: Mon, 28 Apr 2008 07:05:32 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Cc: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, grundler@parisc-linux.org
Subject: Re: [patch v3] doc: DMA-mapping.txt has undeclared variables [Bug 10397]
Message-ID: <20080428130532.GU14990@parisc-linux.org>
References: <987999.8753.qm@web52011.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <987999.8753.qm@web52011.mail.re2.yahoo.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 05:58:49AM -0700, Matti Linnanvuori wrote:
> From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
> 
> Consistently use pdev as the variable of type struct pci_dev *.
> Update DMA mapping documentation to use 'pdev' rather than 'dev' in 
> example code that calls routines expecting 'struct pci_device *', since 'dev' 
> might make readers think they're passing 'struct device *' parameters.
> Bug 10397.
> 
> Signed-off-by: Matti Linnanvuori <mattilinnanvuori@yahoo.com>

Acked-by: Matthew Wilcox <willy@linux.intel.com>

> -    cpu_addr = pci_alloc_consistent(dev, size, &dma_handle);
> +    cpu_addr = pci_alloc_consistent(pdev, size, &dma_handle);
>  
> -where dev is a struct pci_dev *. You should pass NULL for PCI like buses
> +where pdev is a struct pci_dev *. You should pass NULL for PCI like buses
>  where devices don't have struct pci_dev (like ISA, EISA).  This may be
>  called in interrupt context. 

The second sentence is misleading (but it's unrelated to this patch).
If you don't have a pdev, you should be using dma_alloc_coherent()
instead (see DMA-API.txt).  Want to make another patch?  ;-)

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
