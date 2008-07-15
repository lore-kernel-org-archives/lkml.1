Return-Path: <linux-kernel-owner+w=401wt.eu-S1759468AbYGOP0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759468AbYGOP0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 11:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754799AbYGOPZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 11:25:00 -0400
Received: from multi.imgtec.com ([194.200.65.239]:64052 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754079AbYGOPY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 11:24:57 -0400
From: Will Newton <will.newton@imgtec.com>
To: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org, leoli@freescale.com, tanya.jiang@freescale.com,
       gregkh@suse.de, Will Newton <will.newton@gmail.com>
Subject: [PATCH 06/11] fsl_usb2_udc: Initialize spinlock earlier.
Date: Tue, 15 Jul 2008 16:24:45 +0100
Message-Id: <1216135490-21656-7-git-send-email-will.newton@imgtec.com>
X-Mailer: git-send-email 1.5.5.2
In-Reply-To: <1216135490-21656-6-git-send-email-will.newton@imgtec.com>
References: <1216135490-21656-1-git-send-email-will.newton@imgtec.com>
 <1216135490-21656-2-git-send-email-will.newton@imgtec.com>
 <1216135490-21656-3-git-send-email-will.newton@imgtec.com>
 <1216135490-21656-4-git-send-email-will.newton@imgtec.com>
 <1216135490-21656-5-git-send-email-will.newton@imgtec.com>
 <1216135490-21656-6-git-send-email-will.newton@imgtec.com>
X-OriginalArrivalTime: 15 Jul 2008 15:24:53.0136 (UTC) FILETIME=[EDEA5100:01C8E68E]
X-SEF-Processed: 6_0_1_111__2008_07_15_16_24_55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Newton <will.newton@gmail.com>

Move spinlock initialization earlier so we can turn shared irq handler
debugging on safely.

Signed-off-by: Will Newton <will.newton@gmail.com>
---
 drivers/usb/gadget/fsl_usb2_udc.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/fsl_usb2_udc.c b/drivers/usb/gadget/fsl_usb2_udc.c
index 130a59d..e7bdec0 100644
--- a/drivers/usb/gadget/fsl_usb2_udc.c
+++ b/drivers/usb/gadget/fsl_usb2_udc.c
@@ -2190,7 +2190,6 @@ static int __init struct_udc_setup(struct fsl_udc *udc,
 	udc->usb_state = USB_STATE_POWERED;
 	udc->ep0_dir = 0;
 	udc->remote_wakeup = 0;	/* default to 0 on reset */
-	spin_lock_init(&udc->lock);
 
 	return 0;
 }
@@ -2252,6 +2251,9 @@ static int __init fsl_udc_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	spin_lock_init(&udc_controller->lock);
+	udc_controller->stopped = 1;
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
 		kfree(udc_controller);
-- 
1.5.5.2

