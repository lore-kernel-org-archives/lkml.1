Return-Path: <linux-kernel-owner+w=401wt.eu-S1751572AbZINJXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572AbZINJXK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 05:23:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbZINJXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 05:23:09 -0400
Received: from gir.skynet.ie ([193.1.99.77]:35021 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947AbZINJXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 05:23:08 -0400
Date: Mon, 14 Sep 2009 10:23:14 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org
Subject: [git pull] AGP tree for merging
Message-ID: <alpine.DEB.2.00.0909141022300.30595@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'agp-next' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/agp-2.6.git agp-next

This contains mainly a bunch of patches from dwmw2 to bring AGPs
use of the PCI DMA up to modern standards for use with IOMMUs.

Dave.

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
 drivers/char/agp/generic.c      |   20 +++-
 drivers/char/agp/hp-agp.c       |    8 +-
 drivers/char/agp/i460-agp.c     |   17 +---
 drivers/char/agp/intel-agp.c    |  182 +++++++++++++++++++++++++++++++++-----
 drivers/char/agp/nvidia-agp.c   |    2 +-
 drivers/char/agp/parisc-agp.c   |   12 +--
 drivers/char/agp/sgi-agp.c      |    8 +-
 drivers/char/agp/sworks-agp.c   |   10 ++-
 drivers/char/agp/uninorth-agp.c |    4 +-
 include/linux/agp_backend.h     |    5 +-
 23 files changed, 254 insertions(+), 117 deletions(-)

commit 121264827656f5f06328b17983c796af17dc5949
Author: Zhenyu Wang <zhenyuw@linux.intel.com>
Date:   Mon Sep 14 10:47:06 2009 +0800

    agp/intel: remove restore in resume
    
    As early pci resume has already restored config for host
    bridge and graphics device, don't need to restore it again,
    This removes an original order hack for graphics device restore.
    
    This fixed the resume hang issue found by Alan Stern on 845G,
    caused by extra config restore on graphics device.
    
    Cc: Stable Team <stable@kernel.org>
    Cc: Alan Stern <stern@rowland.harvard.edu>
    Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 5e8d6b8bf94f1ffcb7e3c31b73284c20f297f191
Author: David Woodhouse <dwmw2@infradead.org>
Date:   Thu Aug 6 20:20:43 2009 +1000

    agp: fix uninorth build
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 94aa9b9ab09922cfd3bf52806f3ede9cde1ce300
Merge: b7f3158 ba3139f
Author: Dave Airlie <airlied@linux.ie>
Date:   Wed Aug 5 17:28:35 2009 +1000

    Merge git://git.infradead.org/~dwmw2/iommu-agp into agp-next

commit ba3139f2577eee24479db73b8dfc7d78eaf4c486
Author: David Woodhouse <David.Woodhouse@intel.com>
Date:   Wed Aug 5 08:12:40 2009 +0100

    intel-agp: Set dma mask for i915
    
    If DMAR is configured in but absent, we really do want to make sure that
    the dma mask is set appropriately. Otherwise we get mapping failures on
    highmem. Spotted by Zhenyu Wang.
    
    Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

commit b7f315842830d67081642248a3757c713b6b6684
Merge: 90bc1a6 6a12235
Author: Dave Airlie <airlied@linux.ie>
Date:   Wed Aug 5 10:16:57 2009 +1000

    Merge git://git.infradead.org/~dwmw2/iommu-agp into agp-next

commit 6a12235c7d2d75c7d94b9afcaaecd422ff845ce0
Author: David Woodhouse <David.Woodhouse@intel.com>
Date:   Wed Jul 29 10:25:58 2009 +0100

    agp: kill phys_to_gart() and gart_to_phys()
    
    There seems to be no reason for these -- they're a 1:1 mapping on all
    platforms.
    
    Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

commit f692775d7e0a22477143cd884e45c955448ac7d2
Author: David Woodhouse <David.Woodhouse@intel.com>
Date:   Wed Jul 29 09:28:45 2009 +0100

    intel-agp: fix sglist allocation to avoid vmalloc()
    
    Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

commit 91b8e3056bf9107b688eb076c9b804171364db71
Author: David Woodhouse <David.Woodhouse@intel.com>
Date:   Wed Jul 29 08:49:12 2009 +0100

    intel-agp: Move repeated sglist free into separate function
    
    Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

commit c2980d8c2961113f24863f70d8ad016f55224c81
Author: David Woodhouse <David.Woodhouse@intel.com>
Date:   Wed Jul 29 08:39:26 2009 +0100

    agp: Switch agp_{un,}map_page() to take struct page * argument
    
    Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

commit 56ec4c1e72865c6d99f643b6574e6e074c3e8823
Author: David Woodhouse <David.Woodhouse@intel.com>
Date:   Mon Jul 27 16:44:32 2009 +0100

    agp: tidy up handling of scratch pages w.r.t. DMA API
    
    Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

commit 176616814d700f19914d8509d9f65dec51a6ebf7
Author: Zhenyu Wang <zhenyu.z.wang@intel.com>
Date:   Mon Jul 27 12:59:57 2009 +0100

    intel_agp: Use PCI DMA API correctly on chipsets new enough to have IOMMU
    
    When graphics dma remapping engine is active, we must fill
    gart table with dma address from dmar engine, as now graphics
    device access to graphics memory must go through dma remapping
    table to get real physical address.
    
    Add this support to all drivers which use intel_i915_insert_entries()
    
    Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
    Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

commit ff663cf8705bea101d5f73cf471855c85242575e
Author: Zhenyu Wang <zhenyu.z.wang@intel.com>
Date:   Thu Jul 23 17:25:49 2009 +0100

    agp: Add generic support for graphics dma remapping
    
    New driver hooks for support graphics memory dma remapping
    are introduced in this patch. It makes generic code can
    tell if current device needs dma remapping, then call driver
    provided interfaces for mapping and unmapping. Change has
    also been made to handle scratch_page in remapping case.
    
    Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
    Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

commit 2a4ceb6d3e6a566cb4a9dc8f974177f031d27cd7
Author: David Woodhouse <David.Woodhouse@intel.com>
Date:   Mon Jul 27 10:27:29 2009 +0100

    agp: Switch mask_memory() method to take address argument again, not page
    
    In commit 07613ba2 ("agp: switch AGP to use page array instead of
    unsigned long array") we switched the mask_memory() method to take a
    'struct page *' instead of an address. This is painful, because in some
    cases it has to be an IOMMU-mapped virtual bus address (in fact,
    shouldn't it _always_ be a dma_addr_t returned from pci_map_xxx(), and
    we just happen to get lucky most of the time?)
    
    Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
