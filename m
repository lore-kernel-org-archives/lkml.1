Return-Path: <linux-kernel-owner+w=401wt.eu-S1754023AbXKXBNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbXKXBNm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 20:13:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbXKXBNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 20:13:34 -0500
Received: from mga03.intel.com ([143.182.124.21]:9071 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655AbXKXBNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 20:13:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,459,1188802800"; 
   d="scan'208";a="325231972"
From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH] dmaengine: Correct invalid assumptions in the Kconfig text
To: akpm@linux-foundation.org
Cc: shannon.nelson@intel.com, linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Dan Williams <dan.j.williams@intel.com>
Date: Fri, 23 Nov 2007 18:12:34 -0700
Message-ID: <20071124011131.17954.28167.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haavard Skinnemoen <hskinnemoen@atmel.com>

This patch corrects recently changed (and now invalid) Kconfig
descriptions for the DMA engine framework:

 - Non-Intel(R) hardware also has DMA engines;
 - DMA is used for more than memcpy and RAID offloading.

In fact, on most platforms memcpy and RAID aren't factors, and DMA
exists so that peripherals can transfer data to/from memory while
the CPU does other work.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

This corrects a 'regression' of the Kconfig text that happened during
the 2.6.24 merge window.  Adrian was concerned that people were
needlessly turning this capability on without the requisite hardware,
but the wording is indeed misleading.

 drivers/dma/Kconfig |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 6a7d25f..c46b7c2 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -3,11 +3,13 @@
 #
 
 menuconfig DMADEVICES
-	bool "DMA Offload Engine support"
+	bool "DMA Engine support"
 	depends on (PCI && X86) || ARCH_IOP32X || ARCH_IOP33X || ARCH_IOP13XX
 	help
-	  Intel(R) offload engines enable offloading memory copies in the
-	  network stack and RAID operations in the MD driver.
+	  DMA engines can do asynchronous data transfers without
+	  involving the host CPU.  Currently, this framework can be
+	  used to offload memory copies in the network stack and
+	  RAID operations in the MD driver.
 
 if DMADEVICES
 
