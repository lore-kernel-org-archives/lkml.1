Return-Path: <linux-kernel-owner+w=401wt.eu-S1755275AbZKHUZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275AbZKHUZr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 15:25:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755257AbZKHUZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 15:25:46 -0500
Received: from [190.108.161.231] ([190.108.161.231]:40534 "EHLO
	localhost.localdomain" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755217AbZKHUZo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 15:25:44 -0500
Subject: [PATCH 05/20] scsi/aha1740: No longer use Scsi_Cmd typedef
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 08 Nov 2009 17:17:07 -0300
Message-ID: <1257711427.4759.111.camel@dbueso-pc>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change Scsi_Cmnd for struct scsi_cmnd.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>

---
 drivers/scsi/aha1740.c |    8 ++++----
 drivers/scsi/aha1740.h |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
index 5381357..3dd722a 100644
--- a/drivers/scsi/aha1740.c
+++ b/drivers/scsi/aha1740.c
@@ -226,11 +226,11 @@ static int aha1740_test_port(unsigned int base)
 static irqreturn_t aha1740_intr_handle(int irq, void *dev_id)
 {
 	struct Scsi_Host *host = (struct Scsi_Host *) dev_id;
-        void (*my_done)(Scsi_Cmnd *);
+        void (*my_done)(struct scsi_cmnd *);
 	int errstatus, adapstat;
 	int number_serviced;
 	struct ecb *ecbptr;
-	Scsi_Cmnd *SCtmp;
+	struct scsi_cmnd *SCtmp;
 	unsigned int base;
 	unsigned long flags;
 	int handled = 0;
@@ -330,7 +330,7 @@ static irqreturn_t aha1740_intr_handle(int irq, void *dev_id)
 	return IRQ_RETVAL(handled);
 }
 
-static int aha1740_queuecommand(Scsi_Cmnd * SCpnt, void (*done)(Scsi_Cmnd *))
+static int aha1740_queuecommand(struct scsi_cmnd * SCpnt, void (*done)(struct scsi_cmnd *))
 {
 	unchar direction;
 	unchar *cmd = (unchar *) SCpnt->cmnd;
@@ -537,7 +537,7 @@ static int aha1740_biosparam(struct scsi_device *sdev,
 	return 0;
 }
 
-static int aha1740_eh_abort_handler (Scsi_Cmnd *dummy)
+static int aha1740_eh_abort_handler (struct scsi_cmnd *dummy)
 {
 /*
  * From Alan Cox :
diff --git a/drivers/scsi/aha1740.h b/drivers/scsi/aha1740.h
index af23fd6..1a3fdf7 100644
--- a/drivers/scsi/aha1740.h
+++ b/drivers/scsi/aha1740.h
@@ -134,8 +134,8 @@ struct ecb {			/* Enhanced Control Block 6.1 */
 /* Hardware defined portion ends here, rest is driver defined */
 	u8 sense[MAX_SENSE];	/* Sense area */
 	u8 status[MAX_STATUS];	/* Status area */
-	Scsi_Cmnd *SCpnt;	/* Link to the SCSI Command Block */
-	void (*done) (Scsi_Cmnd *);	/* Completion Function */
+	struct scsi_cmnd *SCpnt;	/* Link to the SCSI Command Block */
+	void (*done) (struct scsi_cmnd *);	/* Completion Function */
 };
 
 #define	AHA1740CMD_NOP	 0x00	/* No OP */




