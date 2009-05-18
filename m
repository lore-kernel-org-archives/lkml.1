Return-Path: <linux-kernel-owner+w=401wt.eu-S1756217AbZERHwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbZERHwG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 03:52:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755871AbZERHvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 03:51:50 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:41245 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755402AbZERHvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 03:51:50 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>, Patrick McHardy <kaber@trash.net>
Subject: [PATCH] crypto: hifn_795x - fix __dev{init,exit} markings
Date: Mon, 18 May 2009 03:51:50 -0400
Message-Id: <1242633110-16344-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The remove member of the pci_driver hifn_pci_driver uses __devexit_p(),
so the remove function itself should be marked with __devexit.  And where
there be __devexit on the remove, so is there __devinit on the probe.

Similarly, the module_init/module_exit functions should be declared with
plain __init/__exit markings, not the hotplug __dev{init,exit} ones.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
CC: Evgeniy Polyakov <zbr@ioremap.net>
CC: Patrick McHardy <kaber@trash.net>
---
 drivers/crypto/hifn_795x.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 2bef086..5f753fc 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -2564,7 +2564,7 @@ static void hifn_tasklet_callback(unsigned long data)
 		hifn_process_queue(dev);
 }
 
-static int hifn_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+static int __devinit hifn_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	int err, i;
 	struct hifn_device *dev;
@@ -2696,7 +2696,7 @@ err_out_disable_pci_device:
 	return err;
 }
 
-static void hifn_remove(struct pci_dev *pdev)
+static void __devexit hifn_remove(struct pci_dev *pdev)
 {
 	int i;
 	struct hifn_device *dev;
@@ -2744,7 +2744,7 @@ static struct pci_driver hifn_pci_driver = {
 	.remove   = __devexit_p(hifn_remove),
 };
 
-static int __devinit hifn_init(void)
+static int __init hifn_init(void)
 {
 	unsigned int freq;
 	int err;
@@ -2789,7 +2789,7 @@ static int __devinit hifn_init(void)
 	return 0;
 }
 
-static void __devexit hifn_fini(void)
+static void __exit hifn_fini(void)
 {
 	pci_unregister_driver(&hifn_pci_driver);
 
-- 
1.6.3

