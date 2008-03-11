Return-Path: <linux-kernel-owner+w=401wt.eu-S1755490AbYCKVcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbYCKVcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 17:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbYCKVcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 17:32:16 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:56396 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbYCKVcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 17:32:15 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 11 Mar 2008 22:32:03 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: fw-sbp2: fix for SYM13FW500 bridge (Datafab disk)
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.cd36eb4efecd7f14@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix I/O errors due to SYM13FW500's inability to handle larger request
sizes.  Reported by Piergiorgio Sartor <piergiorgio.sartor@nexgo.de> in
https://bugzilla.redhat.com/show_bug.cgi?id=436879

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-sbp2.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -327,6 +327,11 @@ static const struct {
 		.model			= ~0,
 		.workarounds		= SBP2_WORKAROUND_128K_MAX_TRANS,
 	},
+	/* Datafab MD2-FW2 with Symbios/LSILogic SYM13FW500 bridge */ {
+		.firmware_revision	= 0x002600,
+		.model			= ~0,
+		.workarounds		= SBP2_WORKAROUND_128K_MAX_TRANS,
+	},
 
 	/*
 	 * There are iPods (2nd gen, 3rd gen) with model_id == 0, but

-- 
Stefan Richter
-=====-==--- --== -=-==
http://arcgraph.de/sr/

