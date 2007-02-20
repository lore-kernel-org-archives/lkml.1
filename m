Return-Path: <linux-kernel-owner+w=401wt.eu-S1030255AbXBTQoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030255AbXBTQoI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 11:44:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030261AbXBTQoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 11:44:08 -0500
Received: from [81.2.110.250] ([81.2.110.250]:46863 "EHLO lxorguk.ukuu.org.uk"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030255AbXBTQoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 11:44:06 -0500
Date: Tue, 20 Feb 2007 17:47:37 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: jgarzik@pobox.com, akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] pata_oldpiix: Call both PIO and DMA setup functions on
 switch as they are called on set up
Message-ID: <20070220174737.143b60b7@localhost.localdomain>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Keeps the behaviour consistent and easier to understand.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-mm2/drivers/ata/pata_oldpiix.c linux-2.6.20-mm2/drivers/ata/pata_oldpiix.c
--- linux.vanilla-2.6.20-mm2/drivers/ata/pata_oldpiix.c	2007-02-20 13:37:58.000000000 +0000
+++ linux-2.6.20-mm2/drivers/ata/pata_oldpiix.c	2007-02-20 13:54:49.000000000 +0000
@@ -25,7 +25,7 @@
 #include <linux/ata.h>
 
 #define DRV_NAME	"pata_oldpiix"
-#define DRV_VERSION	"0.5.3"
+#define DRV_VERSION	"0.5.4"
 
 /**
  *	oldpiix_pre_reset		-	probe begin
@@ -209,10 +209,9 @@
 	struct ata_device *adev = qc->dev;
 
 	if (adev != ap->private_data) {
+		oldpiix_set_piomode(ap, adev);
 		if (adev->dma_mode)
 			oldpiix_set_dmamode(ap, adev);
-		else if (adev->pio_mode)
-			oldpiix_set_piomode(ap, adev);
 	}
 	return ata_qc_issue_prot(qc);
 }
