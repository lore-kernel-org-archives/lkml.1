Return-Path: <linux-kernel-owner+w=401wt.eu-S1751934AbXBVVis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbXBVVis (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 16:38:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbXBVVir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 16:38:47 -0500
Received: from palrel12.hp.com ([156.153.255.237]:40304 "EHLO palrel12.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920AbXBVViq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 16:38:46 -0500
Date: Thu, 22 Feb 2007 15:38:45 -0600
From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
To: akpm@osdl.org, jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       gregkh@novell.com, hch@infradead.org
Subject: [Patch 2/2] cciss: add shutdown support (replaces reboot notifier)
Message-ID: <20070222213845.GA14162@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 2/2

This adds support for struct pci_driver shutdown and negates the previous NAK'ed
reboot_notifier patch. It's much easier, wish I had know about this before. Thanks to
Christoph for pointing this out.

Signed-off-by: Mike Miller <mike.miller@hp.com>
------------------------------------------------------------------------------------------
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 916aab0..1abf1f5 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3428,9 +3428,10 @@ static void __devexit cciss_remove_one(s
 	memset(flush_buf, 0, 4);
 	return_code = sendcmd(CCISS_CACHE_FLUSH, i, flush_buf, 4, 0, 0, 0, NULL,
 			      TYPE_CMD);
-	if (return_code != IO_OK) {
-		printk(KERN_WARNING "Error Flushing cache on controller %d\n",
-		       i);
+	if (return_code = IO_OK) {
+		printk(KERN_WARNING "Completed cache flush on controller %d\n", i);
+	} else {
+		printk(KERN_WARNING "Error Flushing cache on controller %d\n", i);
 	}
 	free_irq(hba[i]->intr[2], hba[i]);
 
@@ -3481,6 +3482,7 @@ static struct pci_driver cciss_pci_drive
 	.probe = cciss_init_one,
 	.remove = __devexit_p(cciss_remove_one),
 	.id_table = cciss_pci_device_id,	/* id_table */
+	.shutdown = cciss_remove_one,
 };
 
 /*
