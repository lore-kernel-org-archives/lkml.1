Return-Path: <linux-kernel-owner+w=401wt.eu-S1755335AbYHLOlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbYHLOlu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 10:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754117AbYHLOjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 10:39:32 -0400
Received: from multi.imgtec.com ([194.200.65.239]:46465 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752435AbYHLOjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 10:39:24 -0400
From: Will Newton <will.newton@imgtec.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       leoli@freescale.com, Will Newton <will.newton@gmail.com>
Subject: [PATCH 08/11] fsl_usb2_udc: Uninline udc_reset_ep_queue.
Date: Tue, 12 Aug 2008 15:39:14 +0100
Message-Id: <1218551957-17091-9-git-send-email-will.newton@imgtec.com>
X-Mailer: git-send-email 1.5.5.2
In-Reply-To: <1218551957-17091-8-git-send-email-will.newton@imgtec.com>
References: <1218551957-17091-1-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-2-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-3-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-4-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-5-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-6-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-7-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-8-git-send-email-will.newton@imgtec.com>
X-OriginalArrivalTime: 12 Aug 2008 14:39:18.0384 (UTC) FILETIME=[33714700:01C8FC89]
X-SEF-Processed: 6_0_1_111__2008_08_12_15_39_20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Newton <will.newton@gmail.com>

Uninline udc_reset_ep_queue and remove it's unused return value.

Signed-off-by: Will Newton <will.newton@gmail.com>
Acked-by: Li Yang <leoli@freescale.com>
---
 drivers/usb/gadget/fsl_usb2_udc.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/gadget/fsl_usb2_udc.c b/drivers/usb/gadget/fsl_usb2_udc.c
index 92323c4..45ae982 100644
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

