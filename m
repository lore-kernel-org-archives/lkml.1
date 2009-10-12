Return-Path: <linux-kernel-owner+w=401wt.eu-S1756902AbZJLO1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902AbZJLO1q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 10:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756884AbZJLO1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 10:27:45 -0400
Received: from mga07.intel.com ([143.182.124.22]:12950 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756882AbZJLO1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 10:27:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,546,1249282800"; 
   d="scan'208";a="197934851"
Subject: Re: 2.6.32-rc4: Reported regressions from 2.6.31
From: David Woodhouse <dwmw2@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg Kroah-Hartman <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
In-Reply-To: <1255342738.24732.265.camel@macbook.infradead.org>
References: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera>
	 <alpine.LFD.2.01.0910111554400.3438@localhost.localdomain>
	 <1255342738.24732.265.camel@macbook.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation
Date: Mon, 12 Oct 2009 15:26:38 +0100
Message-Id: <1255357598.9111.0.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-12 at 11:19 +0100, David Woodhouse wrote:
> So the better fix is probably just to fix that problem -- move the final
> PCI quirks so they happen a little earlier. If we move them to
> fs_initcall_sync() and then move the IOMMU init to rootfs_initcall(),
> then everything ought to work, I think...

I've sent that series of patches for review. Assuming you like it,
please pull those patches and a couple of other fixes -- one cosmetic
and one serious crash fix (another BIOS workaround, in fact), from

git://git.infradead.org/~dwmw2/iommu-2.6.32.git

David Woodhouse (5):
      intel-iommu: Yet another BIOS workaround: Isoch DMAR unit with no TLB space
      Rename pci_init() to pci_apply_final_quirks(), move it to quirks.c
      Mark pci_apply_final_quirks() __init rather than __devinit
      Run pci_apply_final_quirks() sooner.
      x86: Move pci_iommu_init to rootfs_initcall()

Roland Dreier (2):
      intel-iommu: Make "Unknown DMAR structure" message more informative
      intel-iommu: Decode (and ignore) RHSA entries

 arch/x86/kernel/pci-dma.c |    2 +-
 drivers/pci/dmar.c        |   13 ++++++-
 drivers/pci/intel-iommu.c |   82 ++++++++++++++++++++++++++++++++++++++++++---
 drivers/pci/pci.c         |   13 -------
 drivers/pci/quirks.c      |   13 +++++++
 5 files changed, 103 insertions(+), 20 deletions(-)


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation


