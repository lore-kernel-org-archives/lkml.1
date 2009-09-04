Return-Path: <linux-kernel-owner+w=401wt.eu-S1756529AbZIDBnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529AbZIDBnk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 21:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754820AbZIDBnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 21:43:39 -0400
Received: from mga12.intel.com ([143.182.124.36]:17024 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756097AbZIDBni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 21:43:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="183952808"
From: Zhenyu Wang <zhenyuw@linux.intel.com>
To: intel-gfx@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, Zhenyu Wang <zhenyuw@linux.intel.com>,
       Stable Team <stable@kernel.org>, Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 2/3] drm/i915: remove restore in resume
Date: Fri,  4 Sep 2009 09:43:35 +0800
Message-Id: <1252028615-13785-2-git-send-email-zhenyuw@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1252028615-13785-1-git-send-email-zhenyuw@linux.intel.com>
References: <1252028615-13785-1-git-send-email-zhenyuw@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't need extra restore like for intel_agp.

Cc: Stable Team <stable@kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
---
 drivers/gpu/drm/i915/i915_drv.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index dbe568c..e8cf18d 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -97,8 +97,6 @@ static int i915_resume(struct drm_device *dev)
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	int ret = 0;
 
-	pci_set_power_state(dev->pdev, PCI_D0);
-	pci_restore_state(dev->pdev);
 	if (pci_enable_device(dev->pdev))
 		return -1;
 	pci_set_master(dev->pdev);
-- 
1.6.3.3

