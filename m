Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbZAETnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbZAETnz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 14:43:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbZAETnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 14:43:45 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:50372 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbZAETno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 14:43:44 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 5 Jan 2009 20:43:23 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: ohci: change "context_stop: still active" log
 message
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.dda855ac47bf11cc@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The present message is mostly just noise.  We only need to be notified
if the "active" flag does not go off before the retry loop terminates.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-ohci.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/drivers/firewire/fw-ohci.c
===================================================================
--- linux.orig/drivers/firewire/fw-ohci.c
+++ linux/drivers/firewire/fw-ohci.c
@@ -892,11 +892,11 @@ static void context_stop(struct context 
 	for (i = 0; i < 10; i++) {
 		reg = reg_read(ctx->ohci, CONTROL_SET(ctx->regs));
 		if ((reg & CONTEXT_ACTIVE) == 0)
-			break;
+			return;
 
-		fw_notify("context_stop: still active (0x%08x)\n", reg);
 		mdelay(1);
 	}
+	fw_error("Error: DMA context still active (0x%08x)\n", reg);
 }
 
 struct driver_data {

-- 
Stefan Richter
-=====-==--= ---= --=-=
http://arcgraph.de/sr/

