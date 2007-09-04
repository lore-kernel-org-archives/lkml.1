Return-Path: <linux-kernel-owner+w=401wt.eu-S1754433AbXIDK7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433AbXIDK7j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 06:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753002AbXIDK7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 06:59:31 -0400
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:44282 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751225AbXIDK7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 06:59:30 -0400
Date: Tue, 4 Sep 2007 13:00:50 +0200
From: aherrman@arcor.de
To: benh@kernel.crashing.org, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] radeonfb: use PCI device Id in hex for name string
Message-ID: <20070904110050.GH7320@devil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

.. instead of potentially using nonprintable characters.

I guess the former (odd) concatenation was used to construct name strings
that match the  "*_ATI_RADEON_??" macros in include/linux/pci_ids.h

The PCI Id in hex is much more convenient to use. E.g. it can easily be
verified against "lspci -nn" output.

Signed-off-by: Andreas Herrmann <aherrman@arcor.de>
---
 drivers/video/aty/radeon_base.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/video/aty/radeon_base.c b/drivers/video/aty/radeon_base.c
index 71b0c17..e6229b4 100644
--- a/drivers/video/aty/radeon_base.c
+++ b/drivers/video/aty/radeon_base.c
@@ -2184,9 +2184,8 @@ static int __devinit radeonfb_pci_register (struct pci_dev *pdev,
 	rinfo->lvds_timer.function = radeon_lvds_timer_func;
 	rinfo->lvds_timer.data = (unsigned long)rinfo;
 
-	strcpy(rinfo->name, "ATI Radeon XX ");
-	rinfo->name[11] = ent->device >> 8;
-	rinfo->name[12] = ent->device & 0xFF;
+	snprintf(rinfo->name, sizeof(rinfo->name),
+		 "ATI Radeon %x", ent->device & 0xffff);
 	rinfo->family = ent->driver_data & CHIP_FAMILY_MASK;
 	rinfo->chipset = pdev->device;
 	rinfo->has_CRTC2 = (ent->driver_data & CHIP_HAS_CRTC2) != 0;
-- 
1.5.3



