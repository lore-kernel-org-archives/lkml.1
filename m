Return-Path: <linux-kernel-owner+w=401wt.eu-S1757644AbZBZCuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757644AbZBZCuM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 21:50:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbZBZCt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 21:49:56 -0500
Received: from mga02.intel.com ([134.134.136.20]:41220 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165AbZBZCtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 21:49:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,268,1233561600"; 
   d="scan'208";a="493180321"
Date: Thu, 26 Feb 2009 10:50:35 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "dwmw2@infradead.org" <dwmw2@infradead.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/6] ATS capability support for Intel IOMMU
Message-ID: <20090226025035.GA12973@yzhao-otc.sh.intel.com>
References: <1234443038-15437-1-git-send-email-yu.zhao@intel.com> <20090214225910.GA1515@colo.lackof.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090214225910.GA1515@colo.lackof.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 15, 2009 at 06:59:10AM +0800, Grant Grundler wrote:
> On Thu, Feb 12, 2009 at 08:50:32PM +0800, Yu Zhao wrote:
> > This patch series implements Address Translation Service support for
> > the Intel IOMMU. ATS makes the PCI Endpoint be able to request the
> > DMA address translation from the IOMMU and cache the translation in
> > the Endpoint, thus alleviate IOMMU pressure and improve the hardware
> > performance in the I/O virtualization environment.
> > 
> > 
> > Changelog: v2 -> v3
> >   1, throw error message if VT-d hardware detects invalid descriptor
> >      on Queued Invalidation interface (David Woodhouse)
> >   2, avoid using pci_find_ext_capability every time when reading ATS
> >      Invalidate Queue Depth (Matthew Wilcox)
> > Changelog: v1 -> v2
> >   added 'static' prefix to a local LIST_HEAD (Andrew Morton)
> > 
> > 
> > Yu Zhao (6):
> >   PCI: support the ATS capability
> >   VT-d: parse ATSR in DMA Remapping Reporting Structure
> >   VT-d: add queue invalidation fault status support
> >   VT-d: add device IOTLB invalidation support
> >   VT-d: cleanup iommu_flush_iotlb_psi and flush_unmaps
> >   VT-d: support the device IOTLB
> > 
> >  drivers/pci/dmar.c           |  230 ++++++++++++++++++++++++++++++++++++++----
> 
> Yu,
> Can you please add something to Documentation/PCI/pci.txt?
> New API I'm seeing are:
> +extern int pci_enable_ats(struct pci_dev *dev, int ps);
> +extern void pci_disable_ats(struct pci_dev *dev);
> +extern int pci_ats_queue_depth(struct pci_dev *dev);

Yes, I'll document these new API.

> Do these also need to be EXPORT_SYMBOL_GPL() as well?
> Or are drivers never expected to call the above?

PCI device driver shouldn't use these API, only IOMMU driver (can't be module)
would use them. Anyway it's a good idea to export them :-)

Thanks,
Yu
