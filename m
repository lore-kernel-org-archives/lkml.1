Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298Ab0CIII7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 03:08:59 -0500
Received: from mga12.intel.com ([143.182.124.36]:18039 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751635Ab0CIII4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 03:08:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,607,1262592000"; 
   d="scan'208";a="252443498"
Date: Tue, 9 Mar 2010 09:09:54 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Paul Mundt <lethal@linux-sh.org>,
       H Hartley Sweeten <hartleys@visionengravers.com>
Subject: [PATCH] mfd: Fix sm501 requested region size
Message-ID: <20100309080952.GA16041@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We should only request for the MFD used region, not the whole thing.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/mfd/sm501.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/sm501.c b/drivers/mfd/sm501.c
index dc9ea95..497712f 100644
--- a/drivers/mfd/sm501.c
+++ b/drivers/mfd/sm501.c
@@ -1430,7 +1430,7 @@ static int __devinit sm501_plat_probe(struct platform_device *dev)
 	}
 
 	sm->regs_claim = request_mem_region(sm->io_res->start,
-					    resource_size(sm->io_res), "sm501");
+					    0x100, "sm501");
 
 	if (sm->regs_claim == NULL) {
 		dev_err(&dev->dev, "cannot claim registers\n");
@@ -1644,7 +1644,7 @@ static int __devinit sm501_pci_probe(struct pci_dev *dev,
 	sm->mem_res = &dev->resource[0];
 
 	sm->regs_claim = request_mem_region(sm->io_res->start,
-					    resource_size(sm->io_res), "sm501");
+					    0x100, "sm501");
 	if (sm->regs_claim == NULL) {
 		dev_err(&dev->dev, "cannot claim registers\n");
 		err= -EBUSY;
-- 
1.6.3.3

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
