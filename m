Return-Path: <linux-kernel-owner+w=401wt.eu-S1754451AbZFDLff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451AbZFDLff (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 07:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753648AbZFDLfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 07:35:25 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:17783 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbZFDLfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 07:35:24 -0400
Date: Thu, 4 Jun 2009 13:35:15 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: Add missing __devexit_p()
Message-ID: <20090604133515.030697ea@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The remove function uses __devexit, so the .remove assignment needs
__devexit_p() to fix a build error with hotplug disabled.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
Inspired from recent similar fixes from Mike Frysinger.

 drivers/staging/altpciechdma/altpciechdma.c |    2 +-
 drivers/staging/slicoss/slicoss.c           |    2 +-
 drivers/staging/sxg/sxg.c                   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.30-rc8.orig/drivers/staging/altpciechdma/altpciechdma.c	2009-06-04 12:49:27.000000000 +0200
+++ linux-2.6.30-rc8/drivers/staging/altpciechdma/altpciechdma.c	2009-06-04 12:52:47.000000000 +0200
@@ -1151,7 +1151,7 @@ static struct pci_driver pci_driver = {
 	.name = DRV_NAME,
 	.id_table = ids,
 	.probe = probe,
-	.remove = remove,
+	.remove = __devexit_p(remove),
 	/* resume, suspend are optional */
 };
 
--- linux-2.6.30-rc8.orig/drivers/staging/slicoss/slicoss.c	2009-04-22 09:51:03.000000000 +0200
+++ linux-2.6.30-rc8/drivers/staging/slicoss/slicoss.c	2009-06-04 12:52:26.000000000 +0200
@@ -4049,7 +4049,7 @@ static struct pci_driver slic_driver = {
 	.name = DRV_NAME,
 	.id_table = slic_pci_tbl,
 	.probe = slic_entry_probe,
-	.remove = slic_entry_remove,
+	.remove = __devexit_p(slic_entry_remove),
 };
 
 static int __init slic_module_init(void)
--- linux-2.6.30-rc8.orig/drivers/staging/sxg/sxg.c	2009-04-22 09:51:03.000000000 +0200
+++ linux-2.6.30-rc8/drivers/staging/sxg/sxg.c	2009-06-04 12:52:12.000000000 +0200
@@ -4516,7 +4516,7 @@ static struct pci_driver sxg_driver = {
 	.name = sxg_driver_name,
 	.id_table = sxg_pci_tbl,
 	.probe = sxg_entry_probe,
-	.remove = sxg_entry_remove,
+	.remove = __devexit_p(sxg_entry_remove),
 #if SXG_POWER_MANAGEMENT_ENABLED
 	.suspend = sxgpm_suspend,
 	.resume = sxgpm_resume,


-- 
Jean Delvare
