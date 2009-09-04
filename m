Return-Path: <linux-kernel-owner+w=401wt.eu-S932631AbZIDCa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932631AbZIDCa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 22:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932582AbZIDCa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 22:30:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:26910 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932477AbZIDCax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 22:30:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,329,1249282800"; 
   d="scan'208";a="723768561"
Subject: [PATCH 05/29] ioat: kill function prototype ifdef guards
To: linux-kernel@vger.kernel.org
From: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, netdev@vger.kernel.org,
       Maciej Sosnowski <maciej.sosnowski@intel.com>
Date: Thu, 03 Sep 2009 19:30:55 -0700
Message-ID: <20090904023055.32667.92412.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20090904022733.32667.77626.stgit@dwillia2-linux.ch.intel.com>
References: <20090904022733.32667.77626.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGit/0.14.3.289.g7daff
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only .c files that utilize these protected prototypes depend on
CONFIG_INTEL_IOATDMA=y, so there is no value gained in providing empty
prototypes.

[ Impact: pure cleanup ]

Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/ioat/dma.h |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/dma/ioat/dma.h b/drivers/dma/ioat/dma.h
index c5eabae..6e27ddb 100644
--- a/drivers/dma/ioat/dma.h
+++ b/drivers/dma/ioat/dma.h
@@ -153,19 +153,10 @@ static inline void ioat_set_tcp_copy_break(struct ioatdma_device *dev)
 	#endif
 }
 
-#if defined(CONFIG_INTEL_IOATDMA) || defined(CONFIG_INTEL_IOATDMA_MODULE)
 struct ioatdma_device *ioat_dma_probe(struct pci_dev *pdev,
 				      void __iomem *iobase);
 void ioat_dma_remove(struct ioatdma_device *device);
 struct dca_provider *ioat_dca_init(struct pci_dev *pdev, void __iomem *iobase);
 struct dca_provider *ioat2_dca_init(struct pci_dev *pdev, void __iomem *iobase);
 struct dca_provider *ioat3_dca_init(struct pci_dev *pdev, void __iomem *iobase);
-#else
-#define ioat_dma_probe(pdev, iobase)    NULL
-#define ioat_dma_remove(device)         do { } while (0)
-#define ioat_dca_init(pdev, iobase)	NULL
-#define ioat2_dca_init(pdev, iobase)	NULL
-#define ioat3_dca_init(pdev, iobase)	NULL
-#endif
-
 #endif /* IOATDMA_H */

