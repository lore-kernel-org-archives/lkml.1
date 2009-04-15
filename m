Return-Path: <linux-kernel-owner+w=401wt.eu-S1758181AbZDOG3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181AbZDOG3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 02:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755261AbZDOG2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 02:28:54 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:49588 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbZDOG2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 02:28:52 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH resend 4/8] staging: agnx, fix fail paths in probe
Date: Wed, 15 Apr 2009 08:28:43 +0200
Message-Id: <1239776927-16168-4-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <1239776927-16168-1-git-send-email-jirislaby@gmail.com>
References: <1239776927-16168-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return error on fail paths instead of 0.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/staging/agnx/pci.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/agnx/pci.c b/drivers/staging/agnx/pci.c
index 6d1b7c2..dd34b7e 100644
--- a/drivers/staging/agnx/pci.c
+++ b/drivers/staging/agnx/pci.c
@@ -470,6 +470,7 @@ static int __devinit agnx_pci_probe(struct pci_dev *pdev,
 	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) ||
 	    pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32))) {
 		dev_err(&pdev->dev, "no suitable DMA available\n");
+		err = -EIO;
 		goto err_free_reg;
 	}
 
@@ -493,11 +494,13 @@ static int __devinit agnx_pci_probe(struct pci_dev *pdev,
 /*	dev_dbg(&pdev->dev, "MEM1 mapped address is 0x%p\n", priv->ctl); */
 	if (!priv->ctl) {
 		dev_err(&pdev->dev, "can't map device memory\n");
+		err = -ENOMEM;
 		goto err_free_dev;
 	}
 	priv->data = pci_iomap(pdev, 1, 0);
 	if (!priv->data) {
 		dev_err(&pdev->dev, "can't map device memory\n");
+		err = -ENOMEM;
 		goto err_iounmap2;
 	}
 
-- 
1.6.2

