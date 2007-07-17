Return-Path: <linux-kernel-owner+w=401wt.eu-S1752313AbXGQMXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313AbXGQMXG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 08:23:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755248AbXGQMUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 08:20:52 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:57735 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584AbXGQMUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 08:20:51 -0400
Message-Id: <20070717122322.836141090@de.ibm.com>
References: <20070717121747.591687140@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 17 Jul 2007 14:17:55 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Jan Glauber <jan.glauber@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 8/8] Fix broken logic, SIGA flags must be bitwise ORed
Content-Disposition: inline; filename=007-qdio-or.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Glauber <jan.glauber@de.ibm.com>

Signed-off-by: Jan Glauber <jan.glauber@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/qdio.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: quilt-2.6/drivers/s390/cio/qdio.c
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/qdio.c
+++ quilt-2.6/drivers/s390/cio/qdio.c
@@ -2306,8 +2306,8 @@ qdio_get_ssqd_information(struct qdio_ir
 	if (!ssqd_area) {
 	        QDIO_PRINT_WARN("Could not get memory for chsc. Using all " \
 				"SIGAs for sch x%x.\n", irq_ptr->schid.sch_no);
-		irq_ptr->qdioac = CHSC_FLAG_SIGA_INPUT_NECESSARY ||
-				  CHSC_FLAG_SIGA_OUTPUT_NECESSARY ||
+		irq_ptr->qdioac = CHSC_FLAG_SIGA_INPUT_NECESSARY |
+				  CHSC_FLAG_SIGA_OUTPUT_NECESSARY |
 				  CHSC_FLAG_SIGA_SYNC_NECESSARY; /* all flags set */
 		irq_ptr->is_qebsm = 0;
 		irq_ptr->sch_token = 0;
@@ -2328,8 +2328,8 @@ qdio_get_ssqd_information(struct qdio_ir
 		QDIO_PRINT_WARN("CHSC returned cc %i. Using all " \
 				"SIGAs for sch 0.%x.%x.\n", result,
 				irq_ptr->schid.ssid, irq_ptr->schid.sch_no);
-		qdioac = CHSC_FLAG_SIGA_INPUT_NECESSARY ||
-			CHSC_FLAG_SIGA_OUTPUT_NECESSARY ||
+		qdioac = CHSC_FLAG_SIGA_INPUT_NECESSARY |
+			CHSC_FLAG_SIGA_OUTPUT_NECESSARY |
 			CHSC_FLAG_SIGA_SYNC_NECESSARY; /* all flags set */
 		irq_ptr->is_qebsm  = 0;
 		goto out;
@@ -2340,8 +2340,8 @@ qdio_get_ssqd_information(struct qdio_ir
 				"is 0x%x. Using all SIGAs for sch 0.%x.%x.\n",
 				ssqd_area->response.code,
 				irq_ptr->schid.ssid, irq_ptr->schid.sch_no);
-		qdioac = CHSC_FLAG_SIGA_INPUT_NECESSARY ||
-			CHSC_FLAG_SIGA_OUTPUT_NECESSARY ||
+		qdioac = CHSC_FLAG_SIGA_INPUT_NECESSARY |
+			CHSC_FLAG_SIGA_OUTPUT_NECESSARY |
 			CHSC_FLAG_SIGA_SYNC_NECESSARY; /* all flags set */
 		irq_ptr->is_qebsm  = 0;
 		goto out;

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

