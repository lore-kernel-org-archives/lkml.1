Return-Path: <linux-kernel-owner+w=401wt.eu-S1758057AbZDOG31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057AbZDOG31 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 02:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753665AbZDOG2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 02:28:53 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:49589 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbZDOG2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 02:28:52 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH resend 3/8] staging: agnx, remove memlens from probe
Date: Wed, 15 Apr 2009 08:28:42 +0200
Message-Id: <1239776927-16168-3-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <1239776927-16168-1-git-send-email-jirislaby@gmail.com>
References: <1239776927-16168-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass 0 to pci_iomap instead. It will cope with that per se.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/staging/agnx/pci.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/agnx/pci.c b/drivers/staging/agnx/pci.c
index bf55ee9..6d1b7c2 100644
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

