Return-Path: <linux-kernel-owner+w=401wt.eu-S1754444AbYHLOmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444AbYHLOmK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 10:42:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754108AbYHLOje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 10:39:34 -0400
Received: from multi.imgtec.com ([194.200.65.239]:20506 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753915AbYHLOjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 10:39:24 -0400
From: Will Newton <will.newton@imgtec.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       leoli@freescale.com, Will Newton <will.newton@gmail.com>
Subject: [PATCH 10/11] fsl_usb2_udc: Add a wmb before priming endpoint.
Date: Tue, 12 Aug 2008 15:39:16 +0100
Message-Id: <1218551957-17091-11-git-send-email-will.newton@imgtec.com>
X-Mailer: git-send-email 1.5.5.2
In-Reply-To: <1218551957-17091-10-git-send-email-will.newton@imgtec.com>
References: <1218551957-17091-1-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-2-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-3-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-4-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-5-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-6-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-7-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-8-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-9-git-send-email-will.newton@imgtec.com>
 <1218551957-17091-10-git-send-email-will.newton@imgtec.com>
X-OriginalArrivalTime: 12 Aug 2008 14:39:18.0540 (UTC) FILETIME=[338914C0:01C8FC89]
X-SEF-Processed: 6_0_1_111__2008_08_12_15_39_20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Newton <will.newton@gmail.com>

Add a wmb to fsl_queue_td before priming the endpoint. This ensures that the
modifications to the QH are seen by the hardware.

Added comment as suggested by Felipe Balbi.

Signed-off-by: Will Newton <will.newton@gmail.com>
Acked-by: Li Yang <leoli@freescale.com>
---
 drivers/usb/gadget/fsl_usb2_udc.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/gadget/fsl_usb2_udc.c b/drivers/usb/gadget/fsl_usb2_udc.c
index 10fafbb..79c36eb 100644
--- a/drivers/usb/gadget/fsl_usb2_udc.c
+++ b/drivers/usb/gadget/fsl_usb2_udc.c
@@ -643,6 +643,9 @@ static void fsl_queue_td(struct fsl_ep *ep, struct fsl_req *req)
 			| EP_QUEUE_HEAD_STATUS_HALT));
 	dQH->size_ioc_int_sts &= temp;
 
+	/* Ensure that updates to the QH will occure before priming. */
+	wmb();
+
 	/* Prime endpoint by writing 1 to ENDPTPRIME */
 	temp = ep_is_in(ep)
 		? (1 << (ep_index(ep) + 16))
-- 
1.5.5.2

