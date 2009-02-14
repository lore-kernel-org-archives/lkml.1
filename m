Return-Path: <linux-kernel-owner+w=401wt.eu-S1754079AbZBNW7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbZBNW7f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 17:59:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365AbZBNW7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 17:59:24 -0500
Received: from colo.lackof.org ([198.49.126.79]:44341 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752231AbZBNW7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 17:59:23 -0500
Date: Sat, 14 Feb 2009 15:59:10 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Yu Zhao <yu.zhao@intel.com>
Cc: jbarnes@virtuousgeek.org, dwmw2@infradead.org, linux-pci@vger.kernel.org,
       iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/6] ATS capability support for Intel IOMMU
Message-ID: <20090214225910.GA1515@colo.lackof.org>
References: <1234443038-15437-1-git-send-email-yu.zhao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234443038-15437-1-git-send-email-yu.zhao@intel.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 12, 2009 at 08:50:32PM +0800, Yu Zhao wrote:
> This patch series implements Address Translation Service support for
> the Intel IOMMU. ATS makes the PCI Endpoint be able to request the
> DMA address translation from the IOMMU and cache the translation in
> the Endpoint, thus alleviate IOMMU pressure and improve the hardware
> performance in the I/O virtualization environment.
> 
> 
> Changelog: v2 -> v3
>   1, throw error message if VT-d hardware detects invalid descriptor
>      on Queued Invalidation interface (David Woodhouse)
>   2, avoid using pci_find_ext_capability every time when reading ATS
>      Invalidate Queue Depth (Matthew Wilcox)
> Changelog: v1 -> v2
>   added 'static' prefix to a local LIST_HEAD (Andrew Morton)
> 
> 
> Yu Zhao (6):
>   PCI: support the ATS capability
>   VT-d: parse ATSR in DMA Remapping Reporting Structure
>   VT-d: add queue invalidation fault status support
>   VT-d: add device IOTLB invalidation support
>   VT-d: cleanup iommu_flush_iotlb_psi and flush_unmaps
>   VT-d: support the device IOTLB
> 
>  drivers/pci/dmar.c           |  230 ++++++++++++++++++++++++++++++++++++++----

Yu,
Can you please add something to Documentation/PCI/pci.txt?
New API I'm seeing are:
+extern int pci_enable_ats(struct pci_dev *dev, int ps);
+extern void pci_disable_ats(struct pci_dev *dev);
+extern int pci_ats_queue_depth(struct pci_dev *dev);

Do these also need to be EXPORT_SYMBOL_GPL() as well?
Or are drivers never expected to call the above?

thanks,
grant

>  drivers/pci/intel-iommu.c    |  135 ++++++++++++++++++++-----
>  drivers/pci/intr_remapping.c |   21 ++--
>  drivers/pci/pci.c            |   72 +++++++++++++
>  include/linux/dmar.h         |    9 ++
>  include/linux/intel-iommu.h  |   19 +++-
>  include/linux/pci.h          |   16 +++
>  include/linux/pci_regs.h     |   10 ++
>  8 files changed, 457 insertions(+), 55 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
