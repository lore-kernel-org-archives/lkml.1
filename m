Return-Path: <linux-kernel-owner+w=401wt.eu-S1756189AbZBZL3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbZBZL3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 06:29:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbZBZL3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 06:29:23 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37585 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbZBZL3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 06:29:22 -0500
From: Luotao Fu <l.fu@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: g.liakhovetski@gmx.de, linux-arm-kernel@lists.arm.linux.org.uk,
       Luotao Fu <l.fu@pengutronix.de>
Subject: [PATCH] ipu_idmac: fix spinlock type
Date: Thu, 26 Feb 2009 12:29:20 +0100
Message-Id: <1235647760-13286-1-git-send-email-l.fu@pengutronix.de>
X-Mailer: git-send-email 1.5.6.5
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix a probably accidently dropped reference operator while calling
spin_unlock_restore to an ipu lock.

Signed-off-by: Luotao Fu <l.fu@pengutronix.de>
---
 drivers/dma/ipu/ipu_idmac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
index 1f154d0..ae50a9d 100644
--- a/drivers/dma/ipu/ipu_idmac.c
+++ b/drivers/dma/ipu/ipu_idmac.c
@@ -729,7 +729,7 @@ static int ipu_init_channel_buffer(struct idmac_channel *ichan,
 
 	ichan->status = IPU_CHANNEL_READY;
 
-	spin_unlock_irqrestore(ipu->lock, flags);
+	spin_unlock_irqrestore(&ipu->lock, flags);
 
 	return 0;
 }
-- 
1.5.6.5

