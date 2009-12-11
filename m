Return-Path: <linux-kernel-owner+w=401wt.eu-S1762797AbZLKX2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762797AbZLKX2r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:28:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761788AbZLKX2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:28:46 -0500
Received: from kroah.org ([198.145.64.141]:50403 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758471AbZLKX2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:28:45 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Breno=20Leit=C3=A3o?= <leitao@linux.vnet.ibm.com>,
       Scott Kilau <scottk@digi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 01/58] jsm: IRQ handlers doesn't need to have IRQ_DISABLED enabled
Date: Fri, 11 Dec 2009 15:27:45 -0800
Message-Id: <1260574122-10676-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211232805.GA10652@kroah.com>
References: <20091211232805.GA10652@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Breno Leitão <leitao@linux.vnet.ibm.com>

Currently jsm is showing the following message when loaded:

IRQ 432/JSM: IRQF_DISABLED is not guaranteed on shared IRQs

It's because the request_irq() is called using IRQF_DISABLED
and IRQF_SHARED.
Actually there is no need to use IRQF_DISABLED in this driver.

Signed-off-by: Breno Leitão <leitao@linux.vnet.ibm.com>
Cc: Scott Kilau <scottk@digi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.6.5.5

