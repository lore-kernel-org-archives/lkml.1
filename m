Return-Path: <linux-kernel-owner+w=401wt.eu-S1758629AbZEAAYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758629AbZEAAYF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:24:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762572AbZEAAFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:05:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34586 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759863AbZEAAFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:05:13 -0400
Date: Thu, 30 Apr 2009 17:00:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: fenghua.yu@intel.com, dwmw2@infradead.org, mingo@elte.hu,
       torvalds@linux-foundation.org, weidong.han@intel.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH] Intel IOMMU Pass Through Support
Message-Id: <20090430170034.1f8f8047.akpm@linux-foundation.org>
In-Reply-To: <49FA3650.8030307@xenotime.net>
References: <20090327212241.234500000@intel.com>
	<20090327212321.070229000@intel.com>
	<20090416001957.GA1527@linux-os.sc.intel.com>
	<20090430162905.d232be29.akpm@linux-foundation.org>
	<49FA3650.8030307@xenotime.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009 16:37:52 -0700
Randy Dunlap <rdunlap@xenotime.net> wrote:

> > 
> > arch/x86/built-in.o: In function `iommu_setup':
> > arch/x86/kernel/pci-dma.c:215: undefined reference to `iommu_pass_through'
> > arch/x86/built-in.o: In function `pci_swiotlb_init':
> > arch/x86/kernel/pci-swiotlb.c:74: undefined reference to `iommu_pass_through'
> > 
> > Because iommu_pass_through is defined in drivers/pci/intel-iommu.c and
> > 
> > # CONFIG_DMAR is not set
> > 
> > I'll need to cook up some local hack to work around that.
> > 
> 
> Patch just went to linux-next mailing list (but should have also
> gone to lkml):
> 
> http://marc.info/?l=linux-next&m=124113213400748&w=2

OK, thanks.  My linux-next feed seems to have broken.

That patch modifies 

	arch/ia64/kernel/dma-mapping.c
	arch/x86/kernel/pci-dma.c

but it would be more logical to modify

	arch/ia64/kernel/pci-dma.c
	arch/x86/kernel/pci-dma.c

is there a reason why that cannot be done?
