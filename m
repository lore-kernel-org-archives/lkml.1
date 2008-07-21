Return-Path: <linux-kernel-owner+w=401wt.eu-S1752782AbYGURxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbYGURxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 13:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750815AbYGURxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 13:53:16 -0400
Received: from adelie.canonical.com ([91.189.90.139]:58145 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbYGURxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 13:53:15 -0400
Subject: Re: [PATCH 4/7] nsc-ircc: Default to dongle type 9 on IBM hardware
From: Ben Collins <ben.collins@canonical.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       Samuel Ortiz <samuel@sortiz.org>
In-Reply-To: <1216618176.8411.124.camel@violet.holtmann.net>
References: <E1KKl4I-00068K-V7@swissweb.swissdisk.com>
	 <1216618176.8411.124.camel@violet.holtmann.net>
Content-Type: text/plain
Organization: Canonical
Date: Mon, 21 Jul 2008 13:40:57 -0400
Message-Id: <1216662057.7585.153.camel@cunning>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.4 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Samuel Ortiz <samuel@sortiz.org>
Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>
Signed-off-by: Ben Collins <ben.collins@canonical.com>

diff --git a/drivers/net/irda/nsc-ircc.c b/drivers/net/irda/nsc-ircc.c
index effc1ce..18d1714 100644
--- a/drivers/net/irda/nsc-ircc.c
+++ b/drivers/net/irda/nsc-ircc.c
@@ -151,8 +151,8 @@ static char *dongle_types[] = {
 static chipio_t pnp_info;
 static const struct pnp_device_id nsc_ircc_pnp_table[] = {
 	{ .id = "NSC6001", .driver_data = 0 },
-	{ .id = "IBM0071", .driver_data = 0 },
 	{ .id = "HWPC224", .driver_data = 0 },
+	{ .id = "IBM0071", .driver_data = NSC_FORCE_DONGLE_TYPE9 },
 	{ }
 };
 
@@ -930,7 +930,10 @@ static int nsc_ircc_pnp_probe(struct pnp_dev *dev, const struct pnp_device_id *i
 	pnp_info.dma = -1;
 	pnp_succeeded = 1;
 
-	/* There don't seem to be any way to get the cfg_base.
+	if (id->driver_data & NSC_FORCE_DONGLE_TYPE9)
+		dongle_id = 0x9;
+
+	/* There doesn't seem to be any way of getting the cfg_base.
 	 * On my box, cfg_base is in the PnP descriptor of the
 	 * motherboard. Oh well... Jean II */
 
diff --git a/drivers/net/irda/nsc-ircc.h b/drivers/net/irda/nsc-ircc.h
index 29398a4..71cd3c5 100644
--- a/drivers/net/irda/nsc-ircc.h
+++ b/drivers/net/irda/nsc-ircc.h
@@ -35,6 +35,9 @@
 #include <linux/types.h>
 #include <asm/io.h>
 
+/* Features for chips (set in driver_data) */
+#define NSC_FORCE_DONGLE_TYPE9	0x00000001
+
 /* DMA modes needed */
 #define DMA_TX_MODE     0x08    /* Mem to I/O, ++, demand. */
 #define DMA_RX_MODE     0x04    /* I/O to mem, ++, demand. */


