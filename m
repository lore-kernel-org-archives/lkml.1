Return-Path: <linux-kernel-owner+w=401wt.eu-S1756110AbZBZKNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110AbZBZKNn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 05:13:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277AbZBZKNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 05:13:22 -0500
Received: from mga01.intel.com ([192.55.52.88]:37880 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755869AbZBZKNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 05:13:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,270,1233561600"; 
   d="scan'208";a="434322811"
From: Maciej Sosnowski <maciej.sosnowski@intel.com>
Subject: [PATCH 2/7] I/OAT: do not set DCACTRL_CMPL_WRITE_ENABLE for I/OAT
	ver.3
To: dan.j.williams@intel.com
Cc: snakebyte@gmx.de, shannon.nelson@intel.com, jeffrey.t.krisher@intel.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date: Thu, 26 Feb 2009 11:04:38 +0100
Message-ID: <20090226100431.3615.8093.stgit@linux.site>
In-Reply-To: <20090226100327.3615.21419.stgit@linux.site>
References: <20090226100327.3615.21419.stgit@linux.site>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Flag DCACTRL_CMPL_WRITE_ENABLE is valid only for I/OAT ver.2
so it should not be set for I/OAT ver.3.

Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
Acked-by: Jeff Kirsher <jeffrey.t.krisher@intel.com>
---

 drivers/dma/ioat_dma.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/ioat_dma.c b/drivers/dma/ioat_dma.c
index b3759c4..879f4a0 100644
--- a/drivers/dma/ioat_dma.c
+++ b/drivers/dma/ioat_dma.c
@@ -189,11 +189,13 @@ #endif
 		ioat_chan->xfercap = xfercap;
 		ioat_chan->desccount = 0;
 		INIT_DELAYED_WORK(&ioat_chan->work, ioat_dma_chan_reset_part2);
-		if (ioat_chan->device->version != IOAT_VER_1_2) {
-			writel(IOAT_DCACTRL_CMPL_WRITE_ENABLE
-					| IOAT_DMA_DCA_ANY_CPU,
-				ioat_chan->reg_base + IOAT_DCACTRL_OFFSET);
-		}
+		if (ioat_chan->device->version == IOAT_VER_2_0)
+			writel(IOAT_DCACTRL_CMPL_WRITE_ENABLE |
+			       IOAT_DMA_DCA_ANY_CPU,
+			       ioat_chan->reg_base + IOAT_DCACTRL_OFFSET);
+		else if (ioat_chan->device->version == IOAT_VER_3_0)
+			writel(IOAT_DMA_DCA_ANY_CPU,
+			       ioat_chan->reg_base + IOAT_DCACTRL_OFFSET);
 		spin_lock_init(&ioat_chan->cleanup_lock);
 		spin_lock_init(&ioat_chan->desc_lock);
 		INIT_LIST_HEAD(&ioat_chan->free_desc);

