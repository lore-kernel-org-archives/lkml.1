Return-Path: <linux-kernel-owner+w=401wt.eu-S933690AbXHXAP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933690AbXHXAP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 20:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933001AbXHXAPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 20:15:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:59386 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932219AbXHXAPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 20:15:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,302,1183359600"; 
   d="scan'208";a="287288775"
From: Shannon Nelson <shannon.nelson@intel.com>
Subject: [PATCH v2 -mm 0/7] I/OAT: Add support for DCA - Direct Cache Access
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, shannon.nelson@intel.com
Date: Thu, 23 Aug 2007 17:14:50 -0700
Message-ID: <20070824001335.16997.79665.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Here's a new rev of the IOAT DCA patches that are currently in -mm.  These
patches include updates based on feedback on the first set, as well as a
couple of other fixes we found internally.  These were originally posted
on 20-Jul-2007 - see http://marc.info/?l=linux-kernel&m=118489237427303&w=2

The following series implements support for providers and clients of
Direct Cache Access (DCA), a method for warming the cache in the correct
CPU before needing data.

ioat-new-device-ids.patch
	- add devices id's for newer Intel chipsets which support DMA and DCA
ioat-rename-source-file.patch
	- prepare for adding new functionality
ioat-dma-cleanups.patch
	- cleanup some code ugliness
ioat-split-startup-code.patch
	- split the DMA support code from the PCI startup
ioat-add-msi-msix-support.patch
	- add support for various interrupt handling schemes
ioat-add-dca-support.patch
	- add the dca driver
ioat-add-ioat-dca.patch
	- add DCA services to the ioatdma driver


 b/drivers/Kconfig                 |    2 
 b/drivers/Makefile                |    1 
 b/drivers/dca/Kconfig             |    8 
 b/drivers/dca/Makefile            |    2 
 b/drivers/dca/dca-core.c          |  168 ++++++
 b/drivers/dca/dca-sysfs.c         |   88 +++
 b/drivers/dma/Kconfig             |   60 +-
 b/drivers/dma/Makefile            |    1 
 b/drivers/dma/ioat.c              |  196 +++++++
 b/drivers/dma/ioat_dca.c          |  267 ++++++++++
 b/drivers/dma/ioat_dma.c          |  967 ++++++++++++++++++++++++++++++++++++++
 b/drivers/dma/ioatdma.h           |   30 +
 b/drivers/dma/ioatdma_hw.h        |    2 
 b/drivers/dma/ioatdma_registers.h |    6 
 b/include/linux/dca.h             |   47 +
 b/include/linux/pci_ids.h         |    2 
 drivers/dma/ioatdma.c             |  827 --------------------------------
 17 files changed, 1816 insertions(+), 858 deletions(-)


Thanks,
sln

-- 
======================================================================
Mr. Shannon Nelson                 LAN Access Division, Intel Corp.
Shannon.Nelson@intel.com                I don't speak for Intel
(503) 712-7659                    Parents can't afford to be squeamish. 
