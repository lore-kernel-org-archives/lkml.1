Return-Path: <linux-kernel-owner+w=401wt.eu-S1759241AbYGFRg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759241AbYGFRg5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756060AbYGFRes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:34:48 -0400
Received: from gv-out-0910.google.com ([216.239.58.184]:50363 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755369AbYGFRen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:34:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:date:from:to:cc:subject:content-disposition:message-id;
        b=Vvj1L+0FUG9y2gwj9Nu+nQuJH6VM6BRbpR3XMxGm4fNnhvwjxvxD5wLq89iPq8ANY5
         GwBQS/D6qqn1z3PC3Fwp/2aKdBO6CXvx8pkmVe2DxxrzvfDPTTLRCgvvifDmZnBo3RwQ
         t9gLdYC5rJHZNlCndVzm9vX9mwmpnfZjT89/o=
References: <20080706172010.559358957@bzolnier@gmail.com>
Date: Sun, 06 Jul 2008 19:20:14 +0200
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 04/50] ide: move ide_setup_pci_controller() call to ide_setup_pci_device()
Content-Disposition: inline; filename=ide-move-ide_setup_pci_controller-call-to-ide_setup_pci_device-s.patch
Message-ID: <48710231.1ade660a.3458.626e@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/setup-pci.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -487,10 +487,6 @@ static int do_ide_setup_pci_device(struc
 {
 	int pciirq, ret;
 
-	ret = ide_setup_pci_controller(dev, d, noisy);
-	if (ret < 0)
-		goto out;
-
 	/*
 	 * Can we trust the reported IRQ?
 	 */
@@ -533,6 +529,10 @@ int ide_setup_pci_device(struct pci_dev 
 	hw_regs_t hw[4], *hws[] = { NULL, NULL, NULL, NULL };
 	int ret;
 
+	ret = ide_setup_pci_controller(dev, d, 1);
+	if (ret < 0)
+		goto out;
+
 	ret = do_ide_setup_pci_device(dev, d, 1);
 
 	if (ret >= 0) {
@@ -541,7 +541,7 @@ int ide_setup_pci_device(struct pci_dev 
 
 		ret = ide_host_add(d, hws, NULL);
 	}
-
+out:
 	return ret;
 }
 EXPORT_SYMBOL_GPL(ide_setup_pci_device);
@@ -554,6 +554,10 @@ int ide_setup_pci_devices(struct pci_dev
 	hw_regs_t hw[4], *hws[] = { NULL, NULL, NULL, NULL };
 
 	for (i = 0; i < 2; i++) {
+		ret = ide_setup_pci_controller(pdev[i], d, !i);
+		if (ret < 0)
+			goto out;
+
 		ret = do_ide_setup_pci_device(pdev[i], d, !i);
 
 		/*

-- 

