Return-Path: <linux-kernel-owner+w=401wt.eu-S1755997AbZBZKOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbZBZKOw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 05:14:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755545AbZBZKOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 05:14:03 -0500
Received: from mga01.intel.com ([192.55.52.88]:57832 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755495AbZBZKOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 05:14:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,270,1233561600"; 
   d="scan'208";a="434322909"
From: Maciej Sosnowski <maciej.sosnowski@intel.com>
Subject: [PATCH 5/7] I/OAT: set tcp_dma_copybreak to 256k for I/OAT ver.3
To: dan.j.williams@intel.com
Cc: snakebyte@gmx.de, shannon.nelson@intel.com, jeffrey.t.krisher@intel.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date: Thu, 26 Feb 2009 11:05:17 +0100
Message-ID: <20090226100515.3615.70407.stgit@linux.site>
In-Reply-To: <20090226100327.3615.21419.stgit@linux.site>
References: <20090226100327.3615.21419.stgit@linux.site>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Upcoming server platforms from Intel based on the Nehalem performance
have significantly improved CPU based copy performance.
However, the DMA engine can still be effective at higher I/O sizes
for TCP traffic and at this time copybreak
should be set to 256k for TCP traffic only.

Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
Acked-by: Jeff Kirsher <jeffrey.t.krisher@intel.com>
---

 drivers/dma/ioatdma.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/ioatdma.h b/drivers/dma/ioatdma.h
index a3306d0..dcf8db5 100644
--- a/drivers/dma/ioatdma.h
+++ b/drivers/dma/ioatdma.h
@@ -135,12 +135,14 @@ static inline void ioat_set_tcp_copy_bre
 	#ifdef CONFIG_NET_DMA
 	switch (dev->version) {
 	case IOAT_VER_1_2:
-	case IOAT_VER_3_0:
 		sysctl_tcp_dma_copybreak = 4096;
 		break;
 	case IOAT_VER_2_0:
 		sysctl_tcp_dma_copybreak = 2048;
 		break;
+	case IOAT_VER_3_0:
+		sysctl_tcp_dma_copybreak = 262144;
+		break;
 	}
 	#endif
 }

