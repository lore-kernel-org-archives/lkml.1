Return-Path: <linux-kernel-owner+w=401wt.eu-S1753393AbZBSBLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbZBSBLq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 20:11:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbZBSBLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 20:11:36 -0500
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:36361 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbZBSBLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 20:11:35 -0500
Message-ID: <499CB1C2.7040705@linux.vnet.ibm.com>
Date: Wed, 18 Feb 2009 22:11:30 -0300
From: Breno Leitao <leitao@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Scott.Kilau@digi.com
Subject: [PATCH linux-next] jsm: Fixing the return variable and removing the
 unused retval
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing the return variable and removing the unused retval.

As it was, the retval was never returned, so its assignments were
silly. 
Just consolidate everything to rc, and removed the unused retval
variable.

Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>

----

diff --git a/drivers/serial/jsm/jsm_driver.c b/drivers/serial/jsm/jsm_driver.c
index 92187e2..27e427a 100644
--- a/drivers/serial/jsm/jsm_driver.c
+++ b/drivers/serial/jsm/jsm_driver.c
@@ -57,7 +57,6 @@ static int jsm_probe_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	int rc = 0;
 	struct jsm_board *brd;
 	static int adapter_count = 0;
-	int retval;
 
 	rc = pci_enable_device(pdev);
 	if (rc) {
@@ -132,7 +131,7 @@ static int jsm_probe_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	rc = jsm_tty_init(brd);
 	if (rc < 0) {
 		dev_err(&pdev->dev, "Can't init tty devices (%d)\n", rc);
-		retval = -ENXIO;
+		rc = -ENXIO;
 		goto out_free_irq;
 	}
 
@@ -140,7 +139,7 @@ static int jsm_probe_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc < 0) {
 		/* XXX: leaking all resources from jsm_tty_init here! */
 		dev_err(&pdev->dev, "Can't init uart port (%d)\n", rc);
-		retval = -ENXIO;
+		rc = -ENXIO;
 		goto out_free_irq;
 	}
 
@@ -159,7 +158,7 @@ static int jsm_probe_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		/* XXX: leaking all resources from jsm_tty_init and
 		 	jsm_uart_port_init here! */
 		dev_err(&pdev->dev, "memory allocation for flipbuf failed\n");
-		retval = -ENOMEM;
+		rc = -ENOMEM;
 		goto out_free_irq;
 	}
 
