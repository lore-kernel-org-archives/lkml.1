Return-Path: <linux-kernel-owner+w=401wt.eu-S1755233AbYHLOlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbYHLOlf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 10:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753892AbYHLOjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 10:39:31 -0400
Received: from multi.imgtec.com ([194.200.65.239]:19247 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664AbYHLOjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 10:39:23 -0400
From: Will Newton <will.newton@imgtec.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       leoli@freescale.com, Will Newton <will.newton@imgtec.com>
Subject: [PATCH 06/11] fsl_usb2_udc: Initialize spinlock earlier.
Date: Tue, 12 Aug 2008 15:39:12 +0100
Message-Id: <1218551957-17091-7-git-send-email-will.newton@imgtec.com>
X-Mailer: git-send-email 1.5.5.2
In-Reply-To: <1218551957-17091-6-git-send-email-will.newton@imgtec.com>
References: <1218551957-17091-1-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-2-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-3-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-4-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-5-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-6-git-send-email-will.newton@imgtec.com>
X-OriginalArrivalTime: 12 Aug 2008 14:39:18.0196 (UTC) FILETIME=[33549740:01C8FC89]
X-SEF-Processed: 6_0_1_111__2008_08_12_15_39_20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move spinlock initialization earlier so we can turn shared irq handler
debugging on safely.

Signed-off-by: Will Newton <will.newton@gmail.com>
Acked-by: Li Yang <leoli@freescale.com>
---
 drivers/usb/gadget/fsl_usb2_udc.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/fsl_usb2_udc.c b/drivers/usb/gadget/fsl_usb2_udc.c
index 44296c3..21f5616 100644
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

