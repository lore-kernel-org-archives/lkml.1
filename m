Return-Path: <linux-kernel-owner+w=401wt.eu-S1757350AbYC1DUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350AbYC1DUA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 23:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752563AbYC1DTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 23:19:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54764 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751542AbYC1DTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 23:19:50 -0400
Date: Thu, 27 Mar 2008 20:18:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: akepner@sgi.com
Cc: Tony Luck <tony.luck@intel.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jes Sorensen <jes@sgi.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Grant Grundler <grundler@parisc-linux.org>,
       Michael Ellerman <michael@ellerman.id.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3 v5] dma: add dma_*map*_attrs() interfaces
Message-Id: <20080327201843.4f5f983b.akpm@linux-foundation.org>
In-Reply-To: <20080320010709.GN1843@sgi.com>
References: <20080320010709.GN1843@sgi.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Mar 2008 18:07:09 -0700 akepner@sgi.com wrote:

> 
> Introduce new interfaces, dma_*map*_attrs(), for passing 
> architecture-specific attributes when memory is mapped and 
> unmapped for DMA. Give the interfaces default implementations 
> which ignore attributes. Also introduce the dma_{set|get}_attr() 
> interfaces for setting and retrieving individual attributes. Define 
> one attribute, DMA_ATTR_WRITE_BARRIER, in anticipation of its use 
> by ia64/sn. Select whether architectures implement arch-specific 
> versions of the dma_*map*_attrs() interfaces via HAVE_DMA_ATTRS in 
> Kconfig.

alpha allmodconfig:


In file included from include/asm/pci.h:7,
                 from include/linux/pci.h:953,
                 from include/asm/core_mcpcia.h:9,
                 from include/asm/io.h:226,
                 from arch/alpha/kernel/asm-offsets.c:11:
include/linux/dma-mapping.h: In function 'dma_map_single_attrs':
include/linux/dma-mapping.h:157: error: implicit declaration of function 'pci_map_single'
include/linux/dma-mapping.h:157: error: implicit declaration of function 'alpha_gendev_to_pci'
include/linux/dma-mapping.h: In function 'dma_unmap_single_attrs':
include/linux/dma-mapping.h:165: error: implicit declaration of function 'pci_unmap_single'
include/linux/dma-mapping.h:165: warning: 'return' with a value, in function returning void
include/linux/dma-mapping.h: In function 'dma_map_sg_attrs':
include/linux/dma-mapping.h:172: error: implicit declaration of function 'pci_map_sg'
include/linux/dma-mapping.h: In function 'dma_unmap_sg_attrs':
include/linux/dma-mapping.h:180: error: implicit declaration of function 'pci_unmap_sg'
include/linux/dma-mapping.h:180: warning: 'return' with a value, in function returning void
In file included from include/linux/pci.h:953,
                 from include/asm/core_mcpcia.h:9,
                 from include/asm/io.h:226,
                 from arch/alpha/kernel/asm-offsets.c:11:


We're in include hell, I think.  alpha defined CONFIG_HAS_DMA, so it has
already included asm/dma-mapping.h, which defines pci_map_single().  But I
suspect that the compiler skipped that inclusion because it was recursive. 
Or something.

I will point you at http://userweb.kernel.org/~akpm/cross-compilers/ and
run away, sorry.

