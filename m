Return-Path: <linux-kernel-owner+w=401wt.eu-S1760281AbYGUEt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760281AbYGUEt1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 00:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbYGUEtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 00:49:17 -0400
Received: from www.swissdisk.com ([216.66.254.197]:48733 "EHLO
	swissweb.swissdisk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbYGUEtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 00:49:17 -0400
X-Greylist: delayed 3283 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Jul 2008 00:49:17 EDT
From: Matthew Garrett <mjg59@srcf.ucam.org>
Date: Sun, 20 Jul 2008 17:08:48 -0400
Subject: [PATCH 4/7] irda: Default to dongle type 9 on IBM hardware
To: linux-kernel@vger.kernel.org
In-Reply-To: <24762.90.138.930.038.1036103001.ben.collins@canonical.com>
CC: Samuel Ortiz <samuel@sortiz.org>
Message-Id: <E1KKl4I-00068K-V7@swissweb.swissdisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Samuel Ortiz <samuel@sortiz.org>
Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>
Signed-off-by: Ben Collins <ben.collins@canonical.com>
---
 drivers/net/irda/nsc-ircc.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/irda/nsc-ircc.c b/drivers/net/irda/nsc-ircc.c
index effc1ce..1ecb013 100644
--- a/drivers/net/irda/nsc-ircc.c
+++ b/drivers/net/irda/nsc-ircc.c
@@ -151,8 +151,8 @@ static char *dongle_types[] = {
 static chipio_t pnp_info;
 static const struct pnp_device_id nsc_ircc_pnp_table[] = {
 	{ .id = "NSC6001", .driver_data = 0 },
-	{ .id = "IBM0071", .driver_data = 0 },
 	{ .id = "HWPC224", .driver_data = 0 },
+	{ .id = "IBM0071", .driver_data = 1 },
 	{ }
 };
 
@@ -934,6 +934,9 @@ static int nsc_ircc_pnp_probe(struct pnp_dev *dev, const struct pnp_device_id *i
 	 * On my box, cfg_base is in the PnP descriptor of the
 	 * motherboard. Oh well... Jean II */
 
+	if (id->driver_data == 1)
+		dongle_id = 0x9;
+
 	if (pnp_port_valid(dev, 0) &&
 		!(pnp_port_flags(dev, 0) & IORESOURCE_DISABLED))
 		pnp_info.fir_base = pnp_port_start(dev, 0);
-- 
1.5.4.3

