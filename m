Return-Path: <linux-kernel-owner+w=401wt.eu-S1758669AbXFSQcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669AbXFSQcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 12:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756605AbXFSQck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 12:32:40 -0400
Received: from mail.atmel.fr ([81.80.104.162]:56544 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753840AbXFSQcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 12:32:39 -0400
Message-ID: <46780522.5030109@rfo.atmel.com>
Date: Tue, 19 Jun 2007 18:32:34 +0200
From: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Organization: atmel
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>
CC: Andrew Victor <andrew@sanpeople.com>, Marc Pignat <marc.pignat@hevs.ch>,
       Hamish Guthrie <hamish@prodigi.ch>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [PATCH] mmc: at91_mci typo
Content-Type: text/plain;
	charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: 7bit
X-ESAFE-STATUS: Mail clean
X-ESAFE-DETAILS: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Typo fix in at91_mci driver : standardized the typo 
(at91_mci everywhere)

Signed-off-by: Nicolas Ferre <nicolas.ferre@rfo.atmel.com> 
---

Will not make the driver works better but will satisfy the most  
demanding typo specialists. 

 drivers/mmc/host/at91_mci.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)


Index: b/drivers/mmc/host/at91_mci.c
===================================================================
--- a/drivers/mmc/host/at91_mci.c
+++ b/drivers/mmc/host/at91_mci.c
@@ -131,7 +131,7 @@ struct at91mci_host
 /*
  * Copy from sg to a dma block - used for transfers
  */
-static inline void at91mci_sg_to_dma(struct at91mci_host *host, struct mmc_data *data)
+static inline void at91_mci_sg_to_dma(struct at91mci_host *host, struct mmc_data *data)
 {
 	unsigned int len, i, size;
 	unsigned *dmabuf = host->buffer;
@@ -180,7 +180,7 @@ static inline void at91mci_sg_to_dma(str
 /*
  * Prepare a dma read
  */
-static void at91mci_pre_dma_read(struct at91mci_host *host)
+static void at91_mci_pre_dma_read(struct at91mci_host *host)
 {
 	int i;
 	struct scatterlist *sg;
@@ -248,7 +248,7 @@ static void at91mci_pre_dma_read(struct 
 /*
  * Handle after a dma read
  */
-static void at91mci_post_dma_read(struct at91mci_host *host)
+static void at91_mci_post_dma_read(struct at91mci_host *host)
 {
 	struct mmc_command *cmd;
 	struct mmc_data *data;
@@ -299,7 +299,7 @@ static void at91mci_post_dma_read(struct
 
 	/* Is there another transfer to trigger? */
 	if (host->transfer_index < data->sg_len)
-		at91mci_pre_dma_read(host);
+		at91_mci_pre_dma_read(host);
 	else {
 		at91_mci_write(host, AT91_MCI_IER, AT91_MCI_RXBUFF);
 		at91_mci_write(host, ATMEL_PDC_PTCR, ATMEL_PDC_RXTDIS | ATMEL_PDC_TXTDIS);
@@ -464,7 +464,7 @@ static unsigned int at91_mci_send_comman
 			host->buffer = NULL;
 			host->total_length = 0;
 
-			at91mci_pre_dma_read(host);
+			at91_mci_pre_dma_read(host);
 			ier = AT91_MCI_ENDRX /* | AT91_MCI_RXBUFF */;
 		}
 		else {
@@ -476,7 +476,7 @@ static unsigned int at91_mci_send_comman
 						  host->total_length,
 						  &host->physical_address, GFP_KERNEL);
 
-			at91mci_sg_to_dma(host, data);
+			at91_mci_sg_to_dma(host, data);
 
 			pr_debug("Transmitting %d bytes\n", host->total_length);
 
@@ -506,7 +506,7 @@ static unsigned int at91_mci_send_comman
 /*
  * Wait for a command to complete
  */
-static void at91mci_process_command(struct at91mci_host *host, struct mmc_command *cmd)
+static void at91_mci_process_command(struct at91mci_host *host, struct mmc_command *cmd)
 {
 	unsigned int ier;
 
@@ -521,15 +521,15 @@ static void at91mci_process_command(stru
 /*
  * Process the next step in the request
  */
-static void at91mci_process_next(struct at91mci_host *host)
+static void at91_mci_process_next(struct at91mci_host *host)
 {
 	if (!(host->flags & FL_SENT_COMMAND)) {
 		host->flags |= FL_SENT_COMMAND;
-		at91mci_process_command(host, host->request->cmd);
+		at91_mci_process_command(host, host->request->cmd);
 	}
 	else if ((!(host->flags & FL_SENT_STOP)) && host->request->stop) {
 		host->flags |= FL_SENT_STOP;
-		at91mci_process_command(host, host->request->stop);
+		at91_mci_process_command(host, host->request->stop);
 	}
 	else
 		mmc_request_done(host->mmc, host->request);
@@ -538,7 +538,7 @@ static void at91mci_process_next(struct 
 /*
  * Handle a command that has been completed
  */
-static void at91mci_completed_command(struct at91mci_host *host)
+static void at91_mci_completed_command(struct at91mci_host *host)
 {
 	struct mmc_command *cmd = host->cmd;
 	unsigned int status;
@@ -581,7 +581,7 @@ static void at91mci_completed_command(st
 	else
 		cmd->error = MMC_ERR_NONE;
 
-	at91mci_process_next(host);
+	at91_mci_process_next(host);
 }
 
 /*
@@ -593,7 +593,7 @@ static void at91_mci_request(struct mmc_
 	host->request = mrq;
 	host->flags = 0;
 
-	at91mci_process_next(host);
+	at91_mci_process_next(host);
 }
 
 /*
@@ -706,7 +706,7 @@ static irqreturn_t at91_mci_irq(int irq,
 
 		if (int_status & AT91_MCI_ENDRX) {
 			pr_debug("Receive has ended\n");
-			at91mci_post_dma_read(host);
+			at91_mci_post_dma_read(host);
 		}
 
 		if (int_status & AT91_MCI_NOTBUSY) {
@@ -735,7 +735,7 @@ static irqreturn_t at91_mci_irq(int irq,
 	if (completed) {
 		pr_debug("Completed command\n");
 		at91_mci_write(host, AT91_MCI_IDR, 0xffffffff);
-		at91mci_completed_command(host);
+		at91_mci_completed_command(host);
 	} else
 		at91_mci_write(host, AT91_MCI_IDR, int_status);
 



