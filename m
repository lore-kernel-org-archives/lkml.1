Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbYCIUmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbYCIUmy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 16:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751313AbYCIUmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 16:42:45 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:54852 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbYCIUmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 16:42:44 -0400
Message-ID: <47D44BC0.2090906@tiscali.nl>
Date: Sun, 09 Mar 2008 21:42:40 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>
CC: linux-ide@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] ATA: logical-bitwise and confusion in ahci_save_initial_config()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

logical-bitwise & confusion

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 8a49835..1b73307 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -672,7 +672,7 @@ static void ahci_save_initial_config(struct pci_dev *pdev,
 		cap &= ~HOST_CAP_NCQ;
 	}
 
-	if ((cap && HOST_CAP_PMP) && (hpriv->flags & AHCI_HFLAG_NO_PMP)) {
+	if ((cap & HOST_CAP_PMP) && (hpriv->flags & AHCI_HFLAG_NO_PMP)) {
 		dev_printk(KERN_INFO, &pdev->dev,
 			   "controller can't do PMP, turning off CAP_PMP\n");
 		cap &= ~HOST_CAP_PMP;
