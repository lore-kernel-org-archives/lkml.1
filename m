Return-Path: <linux-kernel-owner+w=401wt.eu-S1759348AbYLDAv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759348AbYLDAv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 19:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756703AbYLDArF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 19:47:05 -0500
Received: from mga01.intel.com ([192.55.52.88]:37731 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757350AbYLDArD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 19:47:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,710,1220252400"; 
   d="scan'208";a="411263369"
Subject: [PATCH 4/4] dmaengine: bump initcall level to arch_initcall
To: linux-kernel@vger.kernel.org
From: Dan Williams <dan.j.williams@intel.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
       Maciej Sosnowski <maciej.sosnowski@intel.com>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Date: Wed, 03 Dec 2008 17:47:01 -0700
Message-ID: <20081204004701.27790.10663.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20081204004514.27790.51174.stgit@dwillia2-linux.ch.intel.com>
References: <20081204004514.27790.51174.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGit/0.14.3.289.g7daff
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are dmaengine users that would like to register dma devices at
subsys_initcall time to ensure channels are available by device_initcall
time.

Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dca/dca-core.c  |    2 +-
 drivers/dma/dmaengine.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dca/dca-core.c b/drivers/dca/dca-core.c
index d883e1b..5543384 100644
--- a/drivers/dca/dca-core.c
+++ b/drivers/dca/dca-core.c
@@ -270,6 +270,6 @@ static void __exit dca_exit(void)
 	dca_sysfs_exit();
 }
 
-subsys_initcall(dca_init);
+arch_initcall(dca_init);
 module_exit(dca_exit);
 
diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index f4a640d..5289224 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -316,7 +316,7 @@ static int __init dma_channel_table_init(void)
 
 	return err;
 }
-subsys_initcall(dma_channel_table_init);
+arch_initcall(dma_channel_table_init);
 
 /**
  * dma_find_channel - find a channel to carry out the operation
@@ -982,6 +982,6 @@ static int __init dma_bus_init(void)
 	mutex_init(&dma_list_mutex);
 	return class_register(&dma_devclass);
 }
-subsys_initcall(dma_bus_init);
+arch_initcall(dma_bus_init);
 
 

