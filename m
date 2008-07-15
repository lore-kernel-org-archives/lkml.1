Return-Path: <linux-kernel-owner+w=401wt.eu-S1761637AbYGOP1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761637AbYGOP1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 11:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756560AbYGOPZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 11:25:12 -0400
Received: from multi.imgtec.com ([194.200.65.239]:64052 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754364AbYGOPY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 11:24:59 -0400
From: Will Newton <will.newton@imgtec.com>
To: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org, leoli@freescale.com, tanya.jiang@freescale.com,
       gregkh@suse.de, Will Newton <will.newton@gmail.com>
Subject: [PATCH 10/11] fsl_usb2_udc: Add a wmb before priming endpoint.
Date: Tue, 15 Jul 2008 16:24:49 +0100
Message-Id: <1216135490-21656-11-git-send-email-will.newton@imgtec.com>
X-Mailer: git-send-email 1.5.5.2
In-Reply-To: <1216135490-21656-10-git-send-email-will.newton@imgtec.com>
References: <1216135490-21656-1-git-send-email-will.newton@imgtec.com>
 <1216135490-21656-2-git-send-email-will.newton@imgtec.com>
 <1216135490-21656-3-git-send-email-will.newton@imgtec.com>
 <1216135490-21656-4-git-send-email-will.newton@imgtec.com>
 <1216135490-21656-5-git-send-email-will.newton@imgtec.com>
 <1216135490-21656-6-git-send-email-will.newton@imgtec.com>
 <1216135490-21656-7-git-send-email-will.newton@imgtec.com>
 <1216135490-21656-8-git-send-email-will.newton@imgtec.com>
 <1216135490-21656-9-git-send-email-will.newton@imgtec.com>
 <1216135490-21656-10-git-send-email-will.newton@imgtec.com>
X-OriginalArrivalTime: 15 Jul 2008 15:24:53.0511 (UTC) FILETIME=[EE238970:01C8E68E]
X-SEF-Processed: 6_0_1_111__2008_07_15_16_24_55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Newton <will.newton@gmail.com>

Add a wmb to fsl_queue_td before priming the endpoint. This ensures that the
modifications to the QH are seen by the hardware.

Added comment as suggested by Felipe Balbi.

Signed-off-by: Will Newton <will.newton@gmail.com>
---
 drivers/usb/gadget/fsl_usb2_udc.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/gadget/fsl_usb2_udc.c b/drivers/usb/gadget/fsl_usb2_udc.c
index 81cba99..15b7cea 100644
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

