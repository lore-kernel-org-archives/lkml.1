Return-Path: <linux-kernel-owner+w=401wt.eu-S1760287AbXGaVhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760287AbXGaVhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 17:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758875AbXGaVhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 17:37:24 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4632 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765204AbXGaVhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 17:37:21 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 61] drivers/scsi/osst.c: kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 23:37:21 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org,
       osst@riede.org
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707312337.21800.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/scsi/osst.c | 185412 -> 185361 (-51 bytes)
 drivers/scsi/osst.o | 272432 -> 272344 (-88 bytes)

 drivers/scsi/osst.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/scsi/osst.c	2007-07-26 13:07:42.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/scsi/osst.c	2007-07-31 14:14:52.000000000 +0200
@@ -5778,13 +5778,12 @@ static int osst_probe(struct device *dev
 	dev_num = i;

 	/* allocate a struct osst_tape for this device */
-	tpnt = kmalloc(sizeof(struct osst_tape), GFP_ATOMIC);
-	if (tpnt == NULL) {
+	tpnt = kzalloc(sizeof(struct osst_tape), GFP_ATOMIC);
+	if (!tpnt) {
 		write_unlock(&os_scsi_tapes_lock);
 		printk(KERN_ERR "osst :E: Can't allocate device descriptor, device not attached.\n");
 		goto out_put_disk;
 	}
-	memset(tpnt, 0, sizeof(struct osst_tape));

 	/* allocate a buffer for this device */
 	i = SDp->host->sg_tablesize;
