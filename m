Return-Path: <linux-kernel-owner+w=401wt.eu-S1753873AbZI3UdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbZI3UdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 16:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbZI3UdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 16:33:24 -0400
Received: from mail.tpi.com ([70.99.223.143]:3119 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074AbZI3UdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 16:33:23 -0400
To: jesse.brandeburg@intel.com
Subject: [PATCH] e1000e: Fix PCIE error message
Cc: bruce.w.allan@intel.com, e1000-devel@lists.sourceforge.net,
       jeffrey.t.kirsher@intel.com, john.ronciak@intel.com,
       linux-kernel@vger.kernel.org, peter.p.waskiewicz.jr@intel.com
Message-Id: <20090930203322.E7963F88DD@sepang.rtg.net>
Date: Wed, 30 Sep 2009 14:33:22 -0600 (MDT)
From: timg@tpi.com (Tim Gardner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From bfafcd3a39e13c3f6cedf9cc8eff2efdc9af7271 Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Wed, 30 Sep 2009 14:30:08 -0600
Subject: [PATCH] e1000e: Fix PCIE error message

BugLink: http://bugs.launchpad.net/bugs/436370

The error returned by pci_enable_pcie_error_reporting() is ignored, so
print a notice instead of an error. Users tends to freak out
when they see messages like this.

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Cc: stable@kernel.org
---
 drivers/net/e1000e/netdev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/e1000e/netdev.c b/drivers/net/e1000e/netdev.c
index 16c193a..69a761a 100644
--- a/drivers/net/e1000e/netdev.c
+++ b/drivers/net/e1000e/netdev.c
@@ -4984,7 +4984,7 @@ static int __devinit e1000_probe(struct pci_dev *pdev,
 	/* AER (Advanced Error Reporting) hooks */
 	err = pci_enable_pcie_error_reporting(pdev);
 	if (err) {
-		dev_err(&pdev->dev, "pci_enable_pcie_error_reporting failed "
+		dev_notice(&pdev->dev, "pci_enable_pcie_error_reporting failed "
 		        "0x%x\n", err);
 		/* non-fatal, continue */
 	}
-- 
1.6.2.4

