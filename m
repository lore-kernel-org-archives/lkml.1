Return-Path: <linux-kernel-owner+w=401wt.eu-S1756090AbZESOyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbZESOyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 10:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755507AbZESOxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 10:53:47 -0400
Received: from d112a2.x-mailer.de ([212.162.53.4]:47073 "EHLO
	d112a2.x-mailer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755423AbZESOxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 10:53:46 -0400
Message-Id: <7ba7ca462a998d8cfc4486ca6fe0940e90a20ff9.1242739648.git.kkeil@pingi.linux-pingi.de>
In-Reply-To: <cover.1242739648.git.kkeil@pingi.linux-pingi.de>
References: <cover.1242739648.git.kkeil@pingi.linux-pingi.de>
Subject: [PATCH 06/19] Fix hfcmulti's PCI IRQ bug during init
From: Karsten Keil <keil@b1-systems.de>
To: linux-kernel@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       i4ldeveloper@listserv.isdn4linux.de
Date: Tue, 19 May 2009 15:58:26 +0200
X-Info: valid message
X-Info: original Date
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Eversberg <andreas@eversberg.eu>

Not all devices have a hc->pci_dev.

Signed-off-by: Andreas Eversberg <andreas@eversberg.eu>
Signed-off-by: Karsten Keil <keil@b1-systems.de>
---
 drivers/isdn/hardware/mISDN/hfcmulti.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index 9bd85ae..2fbcb92 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -5348,7 +5348,7 @@ hfcmulti_init(struct hm_map *m, struct pci_dev *pdev,
 		hc->iclock = mISDN_register_clock("HFCMulti", 0, clockctl, hc);
 
 	/* initialize hardware */
-	hc->irq = m->irq;
+	hc->irq = (m->irq) ? : hc->pci_dev->irq;
 	ret_err = init_card(hc);
 	if (ret_err) {
 		printk(KERN_ERR "init card returns %d\n", ret_err);
@@ -5549,7 +5549,6 @@ hfcmulti_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		    "Please contact the driver maintainer for support.\n");
 		return -ENODEV;
 	}
-	m->irq = pdev->irq;
 	ret = hfcmulti_init(m, pdev, ent);
 	if (ret)
 		return ret;
-- 
1.6.0.2

