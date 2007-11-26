Return-Path: <linux-kernel-owner+w=401wt.eu-S1754243AbXKZKCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243AbXKZKCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 05:02:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbXKZKB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 05:01:59 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:21493 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbXKZKB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 05:01:58 -0500
X-IronPort-AV: i="4.21,466,1188792000"; 
   d="scan'208"; a="44193277:sNHT25014262"
Subject: [PATCH] [libata] Return proper ATA INT status in pata_bf54x driver.
From: sonic zhang <sonic.adi@gmail.com>
To: Linux IDE <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Jeff Garzik <jeff@garzik.org>
Content-Type: text/plain
Date: Mon, 26 Nov 2007 17:50:56 +0800
Message-Id: <1196070656.15520.4.camel@eight.analog.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

INT status can be OR.


Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>

---
 drivers/ata/pata_bf54x.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/pata_bf54x.c b/drivers/ata/pata_bf54x.c
index b5e3842..81db405 100644
--- a/drivers/ata/pata_bf54x.c
+++ b/drivers/ata/pata_bf54x.c
@@ -1145,13 +1145,13 @@ static unsigned char bfin_bmdma_status(s
 	unsigned short int_status = ATAPI_GET_INT_STATUS(base);
 
 	if (ATAPI_GET_STATUS(base) & (MULTI_XFER_ON|ULTRA_XFER_ON)) {
-		host_stat = ATA_DMA_ACTIVE;
+		host_stat |= ATA_DMA_ACTIVE;
 	}
 	if (int_status & (MULTI_DONE_INT|UDMAIN_DONE_INT|UDMAOUT_DONE_INT)) {
-		host_stat = ATA_DMA_INTR;
+		host_stat |= ATA_DMA_INTR;
 	}
 	if (int_status & (MULTI_TERM_INT|UDMAIN_TERM_INT|UDMAOUT_TERM_INT)) {
-		host_stat = ATA_DMA_ERR;
+		host_stat |= ATA_DMA_ERR;
 	}
 
 	return host_stat;
-- 
1.4.3.4


