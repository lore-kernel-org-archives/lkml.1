Return-Path: <linux-kernel-owner+w=401wt.eu-S1754097AbZHITzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbZHITzy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 15:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754002AbZHITzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 15:55:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:23922 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbZHITzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 15:55:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=PILS+EkxbuZ7Yq5C/EkoXbXpGsL8MERw1W55StP8jZM+f0q78LSV/9DSfpGic2ob/B
         +CUI2RPvU19zL/6/2VBAhRBj/DWxTb4UPudyf9+TYRG7E4i4+5GiRX9lfSK/59I+ZKth
         LKf1V03nRWc/2QSWpOHmywn0shRR8ZOxdege8=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
       linux-scsi@vger.kernel.org
Subject: [PATCH 12/14] scsi: use printk_once
Date: Sun,  9 Aug 2009 21:54:07 +0200
Message-Id: <1249847649-11631-13-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249847649-11631-1-git-send-email-marcin.slusarz@gmail.com>
References: <1249847649-11631-1-git-send-email-marcin.slusarz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/53c700.c             |    6 +-----
 drivers/scsi/cxgb3i/cxgb3i_init.c |    7 +------
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index f5a9add..c5f4fa7 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -291,7 +291,6 @@ NCR_700_detect(struct scsi_host_template *tpnt,
 	__u8 *memory;
 	__u32 *script;
 	struct Scsi_Host *host;
-	static int banner = 0;
 	int j;
 
 	if(tpnt->sdev_attrs == NULL)
@@ -385,10 +384,7 @@ NCR_700_detect(struct scsi_host_template *tpnt,
 	else
 		hostdata->rev = (NCR_700_readb(host, CTEST7_REG)>>4) & 0x0f;
 	hostdata->fast = (NCR_700_readb(host, CTEST9_REG) == 0);
-	if (banner == 0) {
-		printk(KERN_NOTICE "53c700: Version " NCR_700_VERSION " By James.Bottomley@HansenPartnership.com\n");
-		banner = 1;
-	}
+	printk_once(KERN_NOTICE "53c700: Version " NCR_700_VERSION " By James.Bottomley@HansenPartnership.com\n");
 	printk(KERN_NOTICE "scsi%d: %s rev %d %s\n", host->host_no,
 	       hostdata->chip710 ? "53c710" :
 	       (hostdata->fast ? "53c700-66" : "53c700"),
diff --git a/drivers/scsi/cxgb3i/cxgb3i_init.c b/drivers/scsi/cxgb3i/cxgb3i_init.c
index 042d9bc..8c9285f 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_init.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_init.c
@@ -43,12 +43,7 @@ static struct cxgb3_client t3c_client = {
  */
 static void open_s3_dev(struct t3cdev *t3dev)
 {
-	static int vers_printed;
-
-	if (!vers_printed) {
-		printk(KERN_INFO "%s", version);
-		vers_printed = 1;
-	}
+	printk_once(KERN_INFO "%s", version);
 
 	cxgb3i_ddp_init(t3dev);
 	cxgb3i_sdev_add(t3dev, &t3c_client);
-- 
1.6.3.3

