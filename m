Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab0BLJfy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 04:35:54 -0500
Received: from sh.osrg.net ([192.16.179.4]:35901 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120Ab0BLJfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 04:35:50 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
       James Bottomley <James.Bottomley@suse.de>,
       "David S. Miller" <davem@davemloft.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Russell King <linux@arm.linux.org.uk>,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Matt Turner <mattst88@gmail.com>
Subject: [PATCH -mm 0/7] transforming the PCI DMA API into the generic device model
Date: Fri, 12 Feb 2010 18:33:25 +0900
Message-Id: <1265967212-9126-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 12 Feb 2010 18:35:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset transforms the PCI DMA API into the generic device
model. It's one of the reasons why we introduced the generic DMA API
long ago; driver writers are always able to use the generic DMA API
with any bus instead of using bus specific DMA APIs such as
pci_map_single, sbus_map_single, etc (only two bus specific APIs
exist now; pci and ssb).

Some of the PCI DMA API are already implented on the top of the
generic DMA API (include/asm-generic/pci-dma-compat.h). But there are
some exceptions. This patchset finishes the transformation.

=
 Documentation/DMA-API.txt                    |   10 ++
 arch/alpha/Kconfig                           |    1 +
 arch/alpha/include/asm/dma-mapping.h         |   79 ++++-------
 arch/alpha/include/asm/pci.h                 |  125 +----------------
 arch/alpha/kernel/pci-noop.c                 |  101 +++++--------
 arch/alpha/kernel/pci_iommu.c                |  201 ++++++++++++--------------
 arch/arm/common/it8152.c                     |   27 ----
 arch/arm/include/asm/dma-mapping.h           |    8 +
 arch/arm/mach-ixp4xx/common-pci.c            |   26 ----
 arch/arm/mach-ixp4xx/include/mach/hardware.h |    5 -
 arch/arm/mach-pxa/include/mach/hardware.h    |    1 -
 arch/powerpc/include/asm/dma-mapping.h       |    3 -
 arch/powerpc/kernel/pci-common.c             |   15 --
 arch/sparc/include/asm/dma-mapping.h         |   14 ++-
 arch/sparc/kernel/iommu.c                    |   10 --
 arch/sparc/kernel/ioport.c                   |   11 --
 drivers/pci/pci.c                            |   31 ----
 include/asm-generic/pci-dma-compat.h         |   13 ++-
 include/linux/dma-mapping.h                  |    8 +
 include/linux/pci.h                          |    2 -
 20 files changed, 214 insertions(+), 477 deletions(-)


