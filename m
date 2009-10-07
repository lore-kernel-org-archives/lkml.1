Return-Path: <linux-kernel-owner+w=401wt.eu-S1757894AbZJGRbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894AbZJGRbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 13:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757591AbZJGRbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 13:31:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:4958 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757433AbZJGRbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 13:31:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,520,1249282800"; 
   d="scan'208";a="500761702"
From: Allen Kay <allen.m.kay@intel.com>
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Cc: jbarnes@virtuousgeek.org, matthew@wil.cx, chris@sous-sol.org,
       jeremy@goop.org, don.dugger@intel.com,
       Allen Kay <allen.m.kay@intel.com>
Subject: [ACS PATCH v5 2/2] adding xen dom0 checking
Date: Wed,  7 Oct 2009 10:27:51 -0700
Message-Id: <1254936471-18602-1-git-send-email-allen.m.kay@intel.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is predicated on Jeremy's patch in include/xen/xen.h.

Signed-off-by: Allen Kay <allen.m.kay@intel.com>
---
 drivers/pci/probe.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index aa98258..e9b347e 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -11,6 +11,7 @@
 #include <linux/cpumask.h>
 #include <linux/pci-aspm.h>
 #include <linux/iommu.h>
+#include <xen/xen.h>
 #include "pci.h"
 
 #define CARDBUS_LATENCY_TIMER	176	/* secondary latency timer */
@@ -1017,7 +1018,7 @@ static void pci_init_capabilities(struct pci_dev *dev)
 	pci_iov_init(dev);
 
 	/* Enable ACS P2P upstream forwarding */
-	if (iommu_found())
+	if (iommu_found() || xen_initial_domain())
 		pci_enable_acs(dev);
 }
 
-- 
1.6.0.6

