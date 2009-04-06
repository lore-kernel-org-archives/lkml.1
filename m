Return-Path: <linux-kernel-owner+w=401wt.eu-S1758793AbZDFPkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793AbZDFPkf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 11:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756865AbZDFPf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 11:35:59 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57001 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756855AbZDFPf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 11:35:58 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 20/27] jsm: Fix the return variable and removing the unused
	retval.
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 06 Apr 2009 17:34:27 +0100
Message-ID: <20090406163423.12934.82148.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090406162959.12934.97904.stgit@t61.ukuu.org.uk>
References: <20090406162959.12934.97904.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Breno Leitao <leitao@linux.vnet.ibm.com>

As it was, the retval was never returned, so its assignments were silly.
Just consolidate everything to rc, and remove the unused retval variable.

Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Alan Cox <alan@etchedpixels.co.uk>
---

 drivers/serial/jsm/jsm_driver.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)


diff --git a/drivers/serial/jsm/jsm_driver.c b/drivers/serial/jsm/jsm_driver.c
index 576aafb..d2d32a1 100644
--- a/drivers/serial/jsm/jsm_driver.c
+++ b/drivers/serial/jsm/jsm_driver.c
@@ -57,7 +57,6 @@ static int __devinit jsm_probe_one(struct pci_dev *pdev, const struct pci_device
 	int rc = 0;
 	struct jsm_board *brd;
 	static int adapter_count = 0;
-	int retval;
 
 	rc = pci_enable_device(pdev);
 	if (rc) {
@@ -134,7 +133,7 @@ static int __devinit jsm_probe_one(struct pci_dev *pdev, const struct pci_device
 	rc = jsm_tty_init(brd);
 	if (rc < 0) {
 		dev_err(&pdev->dev, "Can't init tty devices (%d)\n", rc);
-		retval = -ENXIO;
+		rc = -ENXIO;
 		goto out_free_irq;
 	}
 
@@ -142,7 +141,7 @@ static int __devinit jsm_probe_one(struct pci_dev *pdev, const struct pci_device
 	if (rc < 0) {
 		/* XXX: leaking all resources from jsm_tty_init here! */
 		dev_err(&pdev->dev, "Can't init uart port (%d)\n", rc);
-		retval = -ENXIO;
+		rc = -ENXIO;
 		goto out_free_irq;
 	}
 
@@ -161,7 +160,7 @@ static int __devinit jsm_probe_one(struct pci_dev *pdev, const struct pci_device
 		/* XXX: leaking all resources from jsm_tty_init and
 		 	jsm_uart_port_init here! */
 		dev_err(&pdev->dev, "memory allocation for flipbuf failed\n");
-		retval = -ENOMEM;
+		rc = -ENOMEM;
 		goto out_free_irq;
 	}
 

