Return-Path: <linux-kernel-owner+w=401wt.eu-S1759542AbZFWP4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759542AbZFWP4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 11:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756460AbZFWP4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 11:56:09 -0400
Received: from mail.atmel.fr ([81.80.104.162]:43500 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753566AbZFWP4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 11:56:08 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-usb@vger.kernel.org, avictor.za@gmail.com
Cc: linux-kernel@vger.kernel.org, david-b@pacbell.net,
       haavard.skinnemoen@atmel.com, patrice.vilchez@atmel.com,
       linux-arm-kernel@lists.arm.linux.org.uk, nicolas.ferre@atmel.com
Subject: [PATCH 2/3 v3] at91/USB: modify OHCI driver to allow shared interrupts
Date: Tue, 23 Jun 2009 18:58:36 +0200
Message-Id: <1245776317-7134-2-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <200906190045.16496.david-b@pacbell.net>
References: <200906190045.16496.david-b@pacbell.net>
Message-Id: <3a789bc6cfd230935479336d21c497476488340f.1245775871.git.nicolas.ferre@atmel.com>
In-Reply-To: <6af1745bf0de30efbd68addd05c2670311c7743a.1245775871.git.nicolas.ferre@atmel.com>
References: <6af1745bf0de30efbd68addd05c2670311c7743a.1245775871.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At91sam9g45 series has a set of high speed USB interfaces.
The host driver is an EHCI with its companion OHCI. OHCI is
always handled by ohci-at91.c.
This wrapper is just modified to allow IRQ sharing
between two controllers.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
v2 -> v3: split patch to:
- gadget
- ohci
- ehci

 drivers/usb/host/ohci-at91.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
index bb5e6f6..7ccffcb 100644
--- a/drivers/usb/host/ohci-at91.c
+++ b/drivers/usb/host/ohci-at91.c
@@ -148,7 +148,7 @@ static int usb_hcd_at91_probe(const struct hc_driver *driver,
 	at91_start_hc(pdev);
 	ohci_hcd_init(hcd_to_ohci(hcd));
 
-	retval = usb_add_hcd(hcd, pdev->resource[1].start, IRQF_DISABLED);
+	retval = usb_add_hcd(hcd, pdev->resource[1].start, IRQF_SHARED);
 	if (retval == 0)
 		return retval;
 
-- 
1.5.3.7

