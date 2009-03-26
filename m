Return-Path: <linux-kernel-owner+w=401wt.eu-S1756742AbZCZIfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742AbZCZIfu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 04:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755780AbZCZIe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 04:34:27 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:52239 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbZCZIeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 04:34:21 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 3/8] staging: agnx, remove memlens from probe
Date: Thu, 26 Mar 2009 09:34:08 +0100
Message-Id: <1238056453-25653-3-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <1238056453-25653-1-git-send-email-jirislaby@gmail.com>
References: <1238056453-25653-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass 0 to pci_iomap instead. It will cope with that per se.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/staging/agnx/pci.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/agnx/pci.c b/drivers/staging/agnx/pci.c
index f646211..f2fbd26 100644
--- a/drivers/staging/agnx/pci.c
+++ b/drivers/staging/agnx/pci.c
@@ -452,7 +452,6 @@ static int __devinit agnx_pci_probe(struct pci_dev *pdev,
 {
 	struct ieee80211_hw *dev;
 	struct agnx_priv *priv;
-	u32 mem_len0, mem_len1;
 	int err;
 	DECLARE_MAC_BUF(mac);
 
@@ -462,9 +461,6 @@ static int __devinit agnx_pci_probe(struct pci_dev *pdev,
 		return err;
 	}
 
-	mem_len0 = pci_resource_len(pdev, 0);
-	mem_len1 = pci_resource_len(pdev, 1);
-
 	err = pci_request_regions(pdev, "agnx-pci");
 	if (err) {
 		dev_err(&pdev->dev, "can't reserve PCI resources\n");
@@ -493,13 +489,13 @@ static int __devinit agnx_pci_probe(struct pci_dev *pdev,
 	spin_lock_init(&priv->lock);
 	priv->init_status = AGNX_UNINIT;
 
-	priv->ctl = pci_iomap(pdev, 0, mem_len0);
+	priv->ctl = pci_iomap(pdev, 0, 0);
 /*	dev_dbg(&pdev->dev, "MEM1 mapped address is 0x%p\n", priv->ctl); */
 	if (!priv->ctl) {
 		dev_err(&pdev->dev, "can't map device memory\n");
 		goto err_free_dev;
 	}
-	priv->data = pci_iomap(pdev, 1, mem_len1);
+	priv->data = pci_iomap(pdev, 1, 0);
 	if (!priv->data) {
 		dev_err(&pdev->dev, "can't map device memory\n");
 		goto err_iounmap2;
-- 
1.6.2

