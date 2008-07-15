Return-Path: <linux-kernel-owner+w=401wt.eu-S1762001AbYGOP2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762001AbYGOP2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 11:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758068AbYGOPZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 11:25:19 -0400
Received: from multi.imgtec.com ([194.200.65.239]:64052 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692AbYGOPYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 11:24:55 -0400
From: Will Newton <will.newton@imgtec.com>
To: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org, leoli@freescale.com, tanya.jiang@freescale.com,
       gregkh@suse.de, Will Newton <will.newton@gmail.com>
Subject: [PATCH 02/11] fsl_usb2_udc: Remove check for udc == NULL in dr_controller_setup.
Date: Tue, 15 Jul 2008 16:24:41 +0100
Message-Id: <1216135490-21656-3-git-send-email-will.newton@imgtec.com>
X-Mailer: git-send-email 1.5.5.2
In-Reply-To: <1216135490-21656-2-git-send-email-will.newton@imgtec.com>
References: <1216135490-21656-1-git-send-email-will.newton@imgtec.com>
 <1216135490-21656-2-git-send-email-will.newton@imgtec.com>
X-OriginalArrivalTime: 15 Jul 2008 15:24:52.0808 (UTC) FILETIME=[EDB84480:01C8E68E]
X-SEF-Processed: 6_0_1_111__2008_07_15_16_24_53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Newton <will.newton@gmail.com>

Remove check for udc == NULL in dr_controller_setup. All callers of
this function have already dereferenced udc at some point.

Signed-off-by: Will Newton <will.newton@gmail.com>
---
 drivers/usb/gadget/fsl_usb2_udc.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/fsl_usb2_udc.c b/drivers/usb/gadget/fsl_usb2_udc.c
index b2a703e..7257d0f 100644
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

