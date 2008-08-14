Return-Path: <linux-kernel-owner+w=401wt.eu-S1758502AbYHNQ2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758502AbYHNQ2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 12:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbYHNQ2C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 12:28:02 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:57740 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbYHNQ2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 12:28:00 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: jgarzik@pobox.com
Cc: e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Bruce Allan <bruce.w.allan@intel.com>,
       PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
       John Ronciak <john.ronciak@intel.com>
Subject: [PATCH 1/1] NET: e100, fix iomap read
Date: Thu, 14 Aug 2008 18:27:23 +0200
Message-Id: <1218731243-32732-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were 2 omitted readb's used on an iomap space. eliminate them
by using ioread8 instead.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Bruce Allan <bruce.w.allan@intel.com>
Cc: PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>
Cc: John Ronciak <john.ronciak@intel.com>
---
 drivers/net/e100.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/e100.c b/drivers/net/e100.c
index 7fee644..d7711d8 100644
--- a/drivers/net/e100.c
+++ b/drivers/net/e100.c
@@ -1727,7 +1727,7 @@ static int e100_rx_indicate(struct nic *nic, struct rx *rx,
 		if ((le16_to_cpu(rfd->command) & cb_el) &&
 		    (RU_RUNNING == nic->ru_running))
 
-			if (readb(&nic->csr->scb.status) & rus_no_res)
+			if (ioread8(&nic->csr->scb.status) & rus_no_res)
 				nic->ru_running = RU_SUSPENDED;
 		return -ENODATA;
 	}
@@ -1750,7 +1750,7 @@ static int e100_rx_indicate(struct nic *nic, struct rx *rx,
 	if ((le16_to_cpu(rfd->command) & cb_el) &&
 	    (RU_RUNNING == nic->ru_running)) {
 
-	    if (readb(&nic->csr->scb.status) & rus_no_res)
+	    if (ioread8(&nic->csr->scb.status) & rus_no_res)
 		nic->ru_running = RU_SUSPENDED;
 	}
 
-- 
1.5.6.5

