Return-Path: <linux-kernel-owner+w=401wt.eu-S1756444AbZIDBnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444AbZIDBnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 21:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756097AbZIDBnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 21:43:37 -0400
Received: from mga12.intel.com ([143.182.124.36]:17024 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756089AbZIDBng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 21:43:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="183952799"
From: Zhenyu Wang <zhenyuw@linux.intel.com>
To: intel-gfx@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, Zhenyu Wang <zhenyuw@linux.intel.com>,
       Stable Team <stable@kernel.org>, Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 1/3] agp/intel: remove restore in resume
Date: Fri,  4 Sep 2009 09:43:34 +0800
Message-Id: <1252028615-13785-1-git-send-email-zhenyuw@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As early pci resume has already restored config for host
bridge and graphics device, don't need to restore it again,
which might cause problem on some chips, like 845G tested by
Alan Stern.

Cc: Stable Team <stable@kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
---
 drivers/char/agp/intel-agp.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index c585577..dee0f1f 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -2313,15 +2313,6 @@ static int agp_intel_resume(struct pci_dev *pdev)
 	struct agp_bridge_data *bridge = pci_get_drvdata(pdev);
 	int ret_val;
 
-	pci_restore_state(pdev);
-
-	/* We should restore our graphics device's config space,
-	 * as host bridge (00:00) resumes before graphics device (02:00),
-	 * then our access to its pci space can work right.
-	 */
-	if (intel_private.pcidev)
-		pci_restore_state(intel_private.pcidev);
-
 	if (bridge->driver == &intel_generic_driver)
 		intel_configure();
 	else if (bridge->driver == &intel_850_driver)
-- 
1.6.3.3

