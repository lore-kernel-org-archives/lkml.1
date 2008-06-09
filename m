Return-Path: <linux-kernel-owner+w=401wt.eu-S1761994AbYFIW2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761994AbYFIW2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 18:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760090AbYFIWZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 18:25:06 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:41049 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758352AbYFIWZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 18:25:01 -0400
Date: Tue, 10 Jun 2008 01:24:07 +0300
From: Adrian Bunk <bunk@kernel.org>
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/scsi/a3000.c: make 2 functions static
Message-ID: <20080609222407.GT1987@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

a3000_{detect,release}() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/scsi/a3000.c |    6 ++++--
 drivers/scsi/a3000.h |    3 ---
 2 files changed, 4 insertions(+), 5 deletions(-)

85a02587af2fff4f03fcecf3bb0f61fbe1cfadc3 diff --git a/drivers/scsi/a3000.c b/drivers/scsi/a3000.c
index 8b449d8..6970ce8 100644
--- a/drivers/scsi/a3000.c
+++ b/drivers/scsi/a3000.c
@@ -25,6 +25,8 @@
 
 static struct Scsi_Host *a3000_host = NULL;
 
+static int a3000_release(struct Scsi_Host *instance);
+
 static irqreturn_t a3000_intr (int irq, void *dummy)
 {
 	unsigned long flags;
@@ -157,7 +159,7 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
     }
 }
 
-int __init a3000_detect(struct scsi_host_template *tpnt)
+static int __init a3000_detect(struct scsi_host_template *tpnt)
 {
     wd33c93_regs regs;
 
@@ -232,7 +234,7 @@ static struct scsi_host_template driver_template = {
 
 #include "scsi_module.c"
 
-int a3000_release(struct Scsi_Host *instance)
+static int a3000_release(struct Scsi_Host *instance)
 {
     wd33c93_release();
     DMA(instance)->CNTR = 0;
diff --git a/drivers/scsi/a3000.h b/drivers/scsi/a3000.h
index 44a4ec7..c7afe16 100644
--- a/drivers/scsi/a3000.h
+++ b/drivers/scsi/a3000.h
@@ -11,9 +11,6 @@
 
 #include <linux/types.h>
 
-int a3000_detect(struct scsi_host_template *);
-int a3000_release(struct Scsi_Host *);
-
 #ifndef CMD_PER_LUN
 #define CMD_PER_LUN 2
 #endif

