Return-Path: <linux-kernel-owner+w=401wt.eu-S1765351AbYB1T62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765351AbYB1T62 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 14:58:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764285AbYB1TyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:54:00 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:60338 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764544AbYB1Txz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:53:55 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 28 Feb 2008 20:53:45 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 4/4] firewire: fw-sbp2: reduce log noise
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.efdb1b5f8ccb3cbd@s5r6.in-berlin.de>
Message-ID: <tkrat.e91ea76ee0e2c394@s5r6.in-berlin.de>
References: <tkrat.efdb1b5f8ccb3cbd@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The block/unblock logic is now sufficiently tested.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

To be postponed after 2.6.25.

 drivers/firewire/fw-sbp2.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -687,10 +687,8 @@ static void sbp2_conditionally_block(str
 	if (!tgt->dont_block && !lu->blocked &&
 	    lu->generation != card->generation) {
 		lu->blocked = true;
-		if (++tgt->blocked == 1) {
+		if (++tgt->blocked == 1)
 			scsi_block_requests(shost);
-			fw_notify("blocked %s\n", lu->tgt->bus_id);
-		}
 	}
 	spin_unlock_irqrestore(&card->lock, flags);
 }
@@ -717,10 +715,8 @@ static void sbp2_conditionally_unblock(s
 	}
 	spin_unlock_irqrestore(&card->lock, flags);
 
-	if (unblock) {
+	if (unblock)
 		scsi_unblock_requests(shost);
-		fw_notify("unblocked %s\n", lu->tgt->bus_id);
-	}
 }
 
 /*

-- 
Stefan Richter
-=====-==--- --=- ===--
http://arcgraph.de/sr/

