Return-Path: <linux-kernel-owner+w=401wt.eu-S964807AbYDNSnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964807AbYDNSnk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933547AbYDNSmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:42:08 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:51079 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933289AbYDNSmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:42:06 -0400
Date: Mon, 14 Apr 2008 21:41:00 +0300
From: Adrian Bunk <bunk@kernel.org>
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC: 2.6 patch] make ata_eh_qc_retry() static
Message-ID: <20080414184100.GK6695@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global ata_eh_qc_retry() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 31 Mar 2008
- 1 Mar 2008

 drivers/ata/libata-core.c |    1 -
 drivers/ata/libata-eh.c   |    2 +-
 include/linux/libata.h    |    1 -
 3 files changed, 1 insertion(+), 3 deletions(-)

cc00162dc4939d15b078f4cc2e8827b2d70a90db foobar
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index b3d01c5..774ca30 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -7882,7 +7882,6 @@ EXPORT_SYMBOL_GPL(sata_async_notification);
 EXPORT_SYMBOL_GPL(ata_eh_freeze_port);
 EXPORT_SYMBOL_GPL(ata_eh_thaw_port);
 EXPORT_SYMBOL_GPL(ata_eh_qc_complete);
-EXPORT_SYMBOL_GPL(ata_eh_qc_retry);
 EXPORT_SYMBOL_GPL(ata_do_eh);
 EXPORT_SYMBOL_GPL(ata_irq_on);
 EXPORT_SYMBOL_GPL(ata_dev_try_classify);
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 698ce2c..90caf08 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1015,7 +1015,7 @@ void ata_eh_qc_complete(struct ata_queued_cmd *qc)
  *	scmd->retries is decremented for commands which get retried
  *	due to unrelated failures (qc->err_mask is zero).
  */
-void ata_eh_qc_retry(struct ata_queued_cmd *qc)
+static void ata_eh_qc_retry(struct ata_queued_cmd *qc)
 {
 	struct scsi_cmnd *scmd = qc->scsicmd;
 	if (!qc->err_mask && scmd->retries)
diff --git a/include/linux/libata.h b/include/linux/libata.h
index a05f600..b626f27 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1058,7 +1058,6 @@ extern void ata_eh_freeze_port(struct ata_port *ap);
 extern void ata_eh_thaw_port(struct ata_port *ap);
 
 extern void ata_eh_qc_complete(struct ata_queued_cmd *qc);
-extern void ata_eh_qc_retry(struct ata_queued_cmd *qc);
 
 extern void ata_do_eh(struct ata_port *ap, ata_prereset_fn_t prereset,
 		      ata_reset_fn_t softreset, ata_reset_fn_t hardreset,


