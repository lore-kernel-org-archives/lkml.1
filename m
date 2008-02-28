Return-Path: <linux-kernel-owner+w=401wt.eu-S1765084AbYB1T5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765084AbYB1T5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 14:57:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932375AbYB1TwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:52:14 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:60208 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932386AbYB1TwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:52:10 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 28 Feb 2008 20:52:02 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/4] firewire: fw-sbp2: simplify some macros
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.efdb1b5f8ccb3cbd@s5r6.in-berlin.de>
Message-ID: <tkrat.19e0fec080bffe1f@s5r6.in-berlin.de>
References: <tkrat.efdb1b5f8ccb3cbd@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How hard can it be to switch on one bit? :-)

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-sbp2.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -174,9 +174,6 @@ struct sbp2_target {
 #define SBP2_ORB_NULL			0x80000000
 #define SBP2_MAX_SG_ELEMENT_LENGTH	0xf000
 
-#define SBP2_DIRECTION_TO_MEDIA		0x0
-#define SBP2_DIRECTION_FROM_MEDIA	0x1
-
 /* Unit directory keys */
 #define SBP2_CSR_UNIT_CHARACTERISTICS	0x3a
 #define SBP2_CSR_FIRMWARE_REVISION	0x3c
@@ -272,7 +269,7 @@ struct sbp2_login_response {
 #define COMMAND_ORB_PAGE_TABLE_PRESENT	((1) << 19)
 #define COMMAND_ORB_MAX_PAYLOAD(v)	((v) << 20)
 #define COMMAND_ORB_SPEED(v)		((v) << 24)
-#define COMMAND_ORB_DIRECTION(v)	((v) << 27)
+#define COMMAND_ORB_DIRECTION		((1) << 27)
 #define COMMAND_ORB_REQUEST_FORMAT(v)	((v) << 29)
 #define COMMAND_ORB_NOTIFY		((1) << 31)
 
@@ -1444,11 +1441,7 @@ static int sbp2_scsi_queuecommand(struct
 		COMMAND_ORB_NOTIFY);
 
 	if (cmd->sc_data_direction == DMA_FROM_DEVICE)
-		orb->request.misc |= cpu_to_be32(
-			COMMAND_ORB_DIRECTION(SBP2_DIRECTION_FROM_MEDIA));
-	else if (cmd->sc_data_direction == DMA_TO_DEVICE)
-		orb->request.misc |= cpu_to_be32(
-			COMMAND_ORB_DIRECTION(SBP2_DIRECTION_TO_MEDIA));
+		orb->request.misc |= cpu_to_be32(COMMAND_ORB_DIRECTION);
 
 	if (scsi_sg_count(cmd) && sbp2_map_scatterlist(orb, device, lu) < 0)
 		goto out;

-- 
Stefan Richter
-=====-==--- --=- ===--
http://arcgraph.de/sr/

