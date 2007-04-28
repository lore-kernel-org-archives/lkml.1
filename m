Return-Path: <linux-kernel-owner+w=401wt.eu-S1163473AbXD1SXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163473AbXD1SXm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163475AbXD1SXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 14:23:42 -0400
Received: from havoc.gtf.org ([69.61.125.42]:40054 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163473AbXD1SXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 14:23:41 -0400
Date: Sat, 28 Apr 2007 14:23:40 -0400
From: Jeff Garzik <jeff@garzik.org>
To: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] SCSI: use irq_handler_t where appropriate
Message-ID: <20070428182340.GA17508@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jeff Garzik <jeff@garzik.org>

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 39ecd0d..ccdf57e 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -499,7 +499,7 @@ struct adapter_ops
 	int  (*adapter_check_health)(struct aac_dev *dev);
 	/* Transport operations */
 	int  (*adapter_ioremap)(struct aac_dev * dev, u32 size);
-	irqreturn_t (*adapter_intr)(int irq, void *dev_id);
+	irq_handler_t adapter_intr;
 	/* Packet operations */
 	int  (*adapter_deliver)(struct fib * fib);
 	int  (*adapter_bounds)(struct aac_dev * dev, struct scsi_cmnd * cmd, u64 lba);
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 280aa23..e3c77d7 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1632,7 +1632,7 @@ struct qla_init_msix_entry {
 	uint16_t entry;
 	uint16_t index;
 	const char *name;
-	irqreturn_t (*handler)(int, void *);
+	irq_handler_t handler;
 };
 
 static struct qla_init_msix_entry imsix_entries[QLA_MSIX_ENTRIES] = {
