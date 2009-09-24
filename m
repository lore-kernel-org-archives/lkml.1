Return-Path: <linux-kernel-owner+w=401wt.eu-S1754384AbZIXT6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384AbZIXT6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 15:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbZIXT6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 15:58:24 -0400
Received: from e24smtp01.br.ibm.com ([32.104.18.85]:43736 "EHLO
	e24smtp01.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbZIXT6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 15:58:24 -0400
From: Breno Leitao <leitao@linux.vnet.ibm.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, scottk@digi.com
Subject: [PATCH 1/2] jsm: IRQ handlers doesn't need to have IRQ_DISABLED enabled
Date: Thu, 24 Sep 2009 16:58:22 -0300
Message-Id: <39629f59067510a052f4a493be9044a572de7f15.1253820690.git.leitao@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <cover.1253820690.git.leitao@linux.vnet.ibm.com>
References: <cover.1253820690.git.leitao@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently jsm is showing the following message when loaded:

IRQ 432/JSM: IRQF_DISABLED is not guaranteed on shared IRQs

It's because the request_irq() is called using IRQF_DISABLED
and IRQF_SHARED.
Actually there is no need to use IRQF_DISABLED in this driver.

Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
---
 drivers/serial/jsm/jsm_driver.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/jsm/jsm_driver.c b/drivers/serial/jsm/jsm_driver.c
index b3604aa..48326f7 100644
--- a/drivers/serial/jsm/jsm_driver.c
+++ b/drivers/serial/jsm/jsm_driver.c
@@ -123,7 +123,7 @@ static int __devinit jsm_probe_one(struct pci_dev *pdev, const struct pci_device
 	}
 
 	rc = request_irq(brd->irq, brd->bd_ops->intr,
-			IRQF_DISABLED|IRQF_SHARED, "JSM", brd);
+			IRQF_SHARED, "JSM", brd);
 	if (rc) {
 		printk(KERN_WARNING "Failed to hook IRQ %d\n",brd->irq);
 		goto out_iounmap;
-- 
1.6.0.4

