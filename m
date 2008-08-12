Return-Path: <linux-kernel-owner+w=401wt.eu-S1754548AbYHLOjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbYHLOjy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 10:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753554AbYHLOjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 10:39:22 -0400
Received: from multi.imgtec.com ([194.200.65.239]:19247 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752435AbYHLOjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 10:39:20 -0400
From: Will Newton <will.newton@imgtec.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       leoli@freescale.com, Will Newton <will.newton@imgtec.com>
Subject: [PATCH 02/11] fsl_usb2_udc: Remove check for udc == NULL in dr_controller_setup.
Date: Tue, 12 Aug 2008 15:39:08 +0100
Message-Id: <1218551957-17091-3-git-send-email-will.newton@imgtec.com>
X-Mailer: git-send-email 1.5.5.2
In-Reply-To: <1218551957-17091-2-git-send-email-will.newton@imgtec.com>
References: <1218551957-17091-1-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-2-git-send-email-will.newton@imgtec.com>
X-OriginalArrivalTime: 12 Aug 2008 14:39:17.0884 (UTC) FILETIME=[3324FBC0:01C8FC89]
X-SEF-Processed: 6_0_1_111__2008_08_12_15_39_18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove check for udc == NULL in dr_controller_setup. All callers of
this function have already dereferenced udc at some point.

Signed-off-by: Will Newton <will.newton@gmail.com>
Acked-by: Li Yang <leoli@freescale.com>
---
 drivers/usb/gadget/fsl_usb2_udc.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/fsl_usb2_udc.c b/drivers/usb/gadget/fsl_usb2_udc.c
index 6a927da..47d6c92 100644
--- a/drivers/usb/gadget/fsl_usb2_udc.c
+++ b/drivers/usb/gadget/fsl_usb2_udc.c
@@ -185,10 +185,6 @@ static int dr_controller_setup(struct fsl_udc *udc)
 	unsigned long timeout;
 #define FSL_UDC_RESET_TIMEOUT 1000
 
-	/* before here, make sure dr_regs has been initialized */
-	if (!udc)
-		return -EINVAL;
-
 	/* Stop and reset the usb controller */
 	tmp = fsl_readl(&dr_regs->usbcmd);
 	tmp &= ~USB_CMD_RUN_STOP;
-- 
1.5.5.2

