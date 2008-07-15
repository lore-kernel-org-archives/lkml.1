Return-Path: <linux-kernel-owner+w=401wt.eu-S1761926AbYGOP2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761926AbYGOP2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 11:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757912AbYGOPZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 11:25:16 -0400
Received: from multi.imgtec.com ([194.200.65.239]:63831 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754231AbYGOPY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 11:24:58 -0400
From: Will Newton <will.newton@imgtec.com>
To: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org, leoli@freescale.com, tanya.jiang@freescale.com,
       gregkh@suse.de, Will Newton <will.newton@gmail.com>
Subject: [PATCH 08/11] fsl_usb2_udc: Uninline udc_reset_ep_queue.
Date: Tue, 15 Jul 2008 16:24:47 +0100
Message-Id: <1216135490-21656-9-git-send-email-will.newton@imgtec.com>
X-Mailer: git-send-email 1.5.5.2
In-Reply-To: <1216135490-21656-8-git-send-email-will.newton@imgtec.com>
References: <1216135490-21656-1-git-send-email-will.newton@imgtec.com>
 <1216135490-21656-2-git-send-email-will.newton@imgtec.com>
 <1216135490-21656-3-git-send-email-will.newton@imgtec.com>
 <1216135490-21656-4-git-send-email-will.newton@imgtec.com>
 <1216135490-21656-5-git-send-email-will.newton@imgtec.com>
 <1216135490-21656-6-git-send-email-will.newton@imgtec.com>
 <1216135490-21656-7-git-send-email-will.newton@imgtec.com>
 <1216135490-21656-8-git-send-email-will.newton@imgtec.com>
X-OriginalArrivalTime: 15 Jul 2008 15:24:53.0324 (UTC) FILETIME=[EE0700C0:01C8E68E]
X-SEF-Processed: 6_0_1_111__2008_07_15_16_24_55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Newton <will.newton@gmail.com>

Uninline udc_reset_ep_queue and remove it's unused return value.

Signed-off-by: Will Newton <will.newton@gmail.com>
---
 drivers/usb/gadget/fsl_usb2_udc.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/gadget/fsl_usb2_udc.c b/drivers/usb/gadget/fsl_usb2_udc.c
index 4b452bd..a6757c9 100644
--- a/drivers/usb/gadget/fsl_usb2_udc.c
+++ b/drivers/usb/gadget/fsl_usb2_udc.c
@@ -1165,16 +1165,12 @@ static int ep0_prime_status(struct fsl_udc *udc, int direction)
 	return status;
 }
 
-static inline int udc_reset_ep_queue(struct fsl_udc *udc, u8 pipe)
+static void udc_reset_ep_queue(struct fsl_udc *udc, u8 pipe)
 {
 	struct fsl_ep *ep = get_ep_by_pipe(udc, pipe);
 
-	if (!ep->name)
-		return 0;
-
-	nuke(ep, -ESHUTDOWN);
-
-	return 0;
+	if (ep->name)
+		nuke(ep, -ESHUTDOWN);
 }
 
 /*
-- 
1.5.5.2

