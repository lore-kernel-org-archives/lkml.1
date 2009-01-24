Return-Path: <linux-kernel-owner+w=401wt.eu-S1759174AbZAXSnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759174AbZAXSnY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 13:43:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755080AbZAXSnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 13:43:09 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:57558 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878AbZAXSnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 13:43:07 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 24 Jan 2009 19:42:47 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/7] firewire: sbp2: define some magic numbers as macros
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.6fe4fe5b72231863@s5r6.in-berlin.de>
Message-ID: <tkrat.99a09faf4c137c20@s5r6.in-berlin.de>
References: <tkrat.6fe4fe5b72231863@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-sbp2.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -311,14 +311,16 @@ struct sbp2_command_orb {
 	dma_addr_t page_table_bus;
 };
 
+#define SBP2_ROM_VALUE_WILDCARD ~0         /* match all */
+#define SBP2_ROM_VALUE_MISSING  0xff000000 /* not present in the unit dir. */
+
 /*
  * List of devices with known bugs.
  *
  * The firmware_revision field, masked with 0xffff00, is the best
  * indicator for the type of bridge chip of a device.  It yields a few
  * false positives but this did not break correctly behaving devices
- * so far.  We use ~0 as a wildcard, since the 24 bit values we get
- * from the config rom can never match that.
+ * so far.
  */
 static const struct {
 	u32 firmware_revision;
@@ -340,22 +342,22 @@ static const struct {
 	},
 	/* Initio bridges, actually only needed for some older ones */ {
 		.firmware_revision	= 0x000200,
-		.model			= ~0,
+		.model			= SBP2_ROM_VALUE_WILDCARD,
 		.workarounds		= SBP2_WORKAROUND_INQUIRY_36,
 	},
 	/* PL-3507 bridge with Prolific firmware */ {
 		.firmware_revision	= 0x012800,
-		.model			= ~0,
+		.model			= SBP2_ROM_VALUE_WILDCARD,
 		.workarounds		= SBP2_WORKAROUND_POWER_CONDITION,
 	},
 	/* Symbios bridge */ {
 		.firmware_revision	= 0xa0b800,
-		.model			= ~0,
+		.model			= SBP2_ROM_VALUE_WILDCARD,
 		.workarounds		= SBP2_WORKAROUND_128K_MAX_TRANS,
 	},
 	/* Datafab MD2-FW2 with Symbios/LSILogic SYM13FW500 bridge */ {
 		.firmware_revision	= 0x002600,
-		.model			= ~0,
+		.model			= SBP2_ROM_VALUE_WILDCARD,
 		.workarounds		= SBP2_WORKAROUND_128K_MAX_TRANS,
 	},
 
@@ -1087,7 +1089,7 @@ static void sbp2_init_workarounds(struct
 			continue;
 
 		if (sbp2_workarounds_table[i].model != model &&
-		    sbp2_workarounds_table[i].model != ~0)
+		    sbp2_workarounds_table[i].model != SBP2_ROM_VALUE_WILDCARD)
 			continue;
 
 		w |= sbp2_workarounds_table[i].workarounds;
@@ -1137,14 +1139,13 @@ static int sbp2_probe(struct device *dev
 	fw_device_get(device);
 	fw_unit_get(unit);
 
-	/* Initialize to values that won't match anything in our table. */
-	firmware_revision = 0xff000000;
-	model = 0xff000000;
-
 	/* implicit directory ID */
 	tgt->directory_id = ((unit->directory - device->config_rom) * 4
 			     + CSR_CONFIG_ROM) & 0xffffff;
 
+	firmware_revision = SBP2_ROM_VALUE_MISSING;
+	model		  = SBP2_ROM_VALUE_MISSING;
+
 	if (sbp2_scan_unit_dir(tgt, unit->directory, &model,
 			       &firmware_revision) < 0)
 		goto fail_tgt_put;

-- 
Stefan Richter
-=====-==--= ---= ==---
http://arcgraph.de/sr/

