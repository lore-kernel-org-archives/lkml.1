Return-Path: <linux-kernel-owner+w=401wt.eu-S1755137AbZINCrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137AbZINCrR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 22:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755070AbZINCrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 22:47:15 -0400
Received: from mga07.intel.com ([143.182.124.22]:39018 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754908AbZINCrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 22:47:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,381,1249282800"; 
   d="scan'208";a="187186416"
From: Zhenyu Wang <zhenyuw@linux.intel.com>
To: airlied@gmail.com
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       Zhenyu Wang <zhenyuw@linux.intel.com>, Stable Team <stable@kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 2/2] drm/i915: remove restore in resume
Date: Mon, 14 Sep 2009 10:47:07 +0800
Message-Id: <1252896427-11669-2-git-send-email-zhenyuw@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1252896427-11669-1-git-send-email-zhenyuw@linux.intel.com>
References: <1252896427-11669-1-git-send-email-zhenyuw@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't need extra config restore like for intel_agp, which
might cause resume hang issue found by Alan on 845G.

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

