Return-Path: <linux-kernel-owner+w=401wt.eu-S1754364AbZHCIjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364AbZHCIjs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 04:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753441AbZHCIjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 04:39:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35950 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbZHCIjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 04:39:46 -0400
Subject: Re: [RFC] Make AGP work with IOMMU
From: David Woodhouse <dwmw2@infradead.org>
To: Zhenyu Wang <zhenyuw@linux.intel.com>
Cc: Dave Airlie <airlied@gmail.com>, Keir Fraser <kier.fraser@eu.citrix.com>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
       Joerg Roedel <joerg.roedel@amd.com>
In-Reply-To: <20090803065030.GA32461@zhen-devel.sh.intel.com>
References: <1248707041.6100.35.camel@macbook.infradead.org>
	 <21d7e9970907282328l4a44b9a2of4500c5c84a3586b@mail.gmail.com>
	 <1248851712.19733.214.camel@macbook.infradead.org>
	 <21d7e9970907290143q6778511cvda1c6b915f61654a@mail.gmail.com>
	 <1248860205.19733.238.camel@macbook.infradead.org>
	 <20090803065030.GA32461@zhen-devel.sh.intel.com>
Content-Type: text/plain
Date: Mon, 03 Aug 2009 09:39:40 +0100
Message-Id: <1249288780.7341.4.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-03 at 14:50 +0800, Zhenyu Wang wrote:
> 
> The commits on that tree looks fine to me. Thanks David! 
> I've also done some testing on G45 here, I've also seen the write
> faults before graphics device init or after dma unmap pages. I tried
> to look it up in my memo, which turns out one message like this should
> be a BIOS bug that doesn't initialize the GTT table correctly. But I'm
> quite sure about it now, better to ask our chipset people to verify if
> this problem has been fixed or not.

Thanks. I've rebased the tree so that it isn't based on my other iommu
changes, which are largely irrelevant. Since the drm-2.6.git tree as
advertised in MAINTAINERS seems to be a pristine 2.6.29-rc2, I've done
it based on 2.6.31-rc5 instead.

Dave, please pull from
	git://git.infradead.org/~dwmw2/iommu-agp.git

David Woodhouse (6):
      agp: Switch mask_memory() method to take address argument again, not page
      agp: tidy up handling of scratch pages w.r.t. DMA API
      agp: Switch agp_{un,}map_page() to take struct page * argument
      intel-agp: Move repeated sglist free into separate function
      intel-agp: fix sglist allocation to avoid vmalloc()
      agp: kill phys_to_gart() and gart_to_phys()

Zhenyu Wang (2):
      agp: Add generic support for graphics dma remapping
      intel_agp: Use PCI DMA API correctly on chipsets new enough to have IOMMU

 arch/alpha/include/asm/agp.h    |    4 -
 arch/ia64/include/asm/agp.h     |    4 -
 arch/parisc/include/asm/agp.h   |    4 -
 arch/powerpc/include/asm/agp.h  |    4 -
 arch/sparc/include/asm/agp.h    |    4 -
 arch/x86/include/asm/agp.h      |    4 -
 drivers/char/agp/agp.h          |   15 ++--
 drivers/char/agp/ali-agp.c      |    4 +-
 drivers/char/agp/amd-k7-agp.c   |   10 ++-
 drivers/char/agp/amd64-agp.c    |    7 +-
 drivers/char/agp/ati-agp.c      |    7 +-
 drivers/char/agp/backend.c      |   32 ++++++-
 drivers/char/agp/efficeon-agp.c |    4 +-
 drivers/char/agp/generic.c      |   20 ++++-
 drivers/char/agp/hp-agp.c       |    8 +-
 drivers/char/agp/i460-agp.c     |   17 +---
 drivers/char/agp/intel-agp.c    |  167 +++++++++++++++++++++++++++++++++++----
 drivers/char/agp/nvidia-agp.c   |    2 +-
 drivers/char/agp/parisc-agp.c   |   12 +---
 drivers/char/agp/sgi-agp.c      |    8 +-
 drivers/char/agp/sworks-agp.c   |   10 ++-
 drivers/char/agp/uninorth-agp.c |    2 +-
 include/linux/agp_backend.h     |    5 +-
 23 files changed, 247 insertions(+), 107 deletions(-)

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

