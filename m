Return-Path: <linux-kernel-owner+w=401wt.eu-S1757209AbYCKVdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209AbYCKVdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 17:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753881AbYCKVdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 17:33:04 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:56427 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbYCKVdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 17:33:02 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 11 Mar 2008 22:32:52 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: sbp2: fix for SYM13FW500 bridge (Datafab disk)
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.cd36eb4efecd7f14@s5r6.in-berlin.de>
Message-ID: <tkrat.6437b6cf5ad12894@s5r6.in-berlin.de>
References: <tkrat.cd36eb4efecd7f14@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix I/O errors due to SYM13FW500's inability to handle larger request
sizes.  Reported by Piergiorgio Sartor <piergiorgio.sartor@nexgo.de> for
firewire-sbp2 in https://bugzilla.redhat.com/show_bug.cgi?id=436879

This fix is necessary because sbp2's default request size limit has been
lifted since 2.6.25-rc1.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/sbp2.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux/drivers/ieee1394/sbp2.c
===================================================================
--- linux.orig/drivers/ieee1394/sbp2.c
+++ linux/drivers/ieee1394/sbp2.c
@@ -376,6 +376,11 @@ static const struct {
 		.model_id		= SBP2_ROM_VALUE_WILDCARD,
 		.workarounds		= SBP2_WORKAROUND_128K_MAX_TRANS,
 	},
+	/* Datafab MD2-FW2 with Symbios/LSILogic SYM13FW500 bridge */ {
+		.firmware_revision	= 0x002600,
+		.model_id		= SBP2_ROM_VALUE_WILDCARD,
+		.workarounds		= SBP2_WORKAROUND_128K_MAX_TRANS,
+	},
 	/* iPod 4th generation */ {
 		.firmware_revision	= 0x0a2700,
 		.model_id		= 0x000021,

-- 
Stefan Richter
-=====-==--- --== -=-==
http://arcgraph.de/sr/

