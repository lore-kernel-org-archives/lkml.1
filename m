Return-Path: <linux-kernel-owner+w=401wt.eu-S1757635AbXLNRdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635AbXLNRdu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 12:33:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753276AbXLNRdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 12:33:42 -0500
Received: from mga11.intel.com ([192.55.52.93]:30549 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113AbXLNRdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 12:33:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,168,1196668800"; 
   d="scan'208";a="238661091"
From: Shannon Nelson <shannon.nelson@intel.com>
Subject: [PATCH] I/OAT: fix null device in call to dev_err()
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: snakebyte@gmx.de, shannon.nelson@intel.com, maciej.sosnowski@intel.com
Date: Fri, 14 Dec 2007 17:33:26 -0800
Message-ID: <20071215013326.16456.5483.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can't use the device in a dev_err() after a kzalloc failure or after the kfree, so
simplify it to the pdev that was originally passed in.

Cc: Eric Sesterhenn <snakebyte@gmx.de>
Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
---

 drivers/dma/ioat_dma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/ioat_dma.c b/drivers/dma/ioat_dma.c
index c1c2dcc..19cd204 100644
--- a/drivers/dma/ioat_dma.c
+++ b/drivers/dma/ioat_dma.c
@@ -1351,7 +1351,7 @@ err_completion_pool:
 err_dma_pool:
 	kfree(device);
 err_kzalloc:
-	dev_err(&device->pdev->dev,
+	dev_err(&pdev->dev,
 		"Intel(R) I/OAT DMA Engine initialization failed\n");
 	return NULL;
 }

