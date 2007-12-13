Return-Path: <linux-kernel-owner+w=401wt.eu-S1762797AbXLMQXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762797AbXLMQXf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 11:23:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756313AbXLMQX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 11:23:28 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756139AbXLMQX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 11:23:27 -0500
Subject: [PATCH] Fix compiler warning noise with FORE200E driver
From: "Tom \"spot\" Callaway" <tcallawa@redhat.com>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-EwGJGx0IwCYwzVOSDedN"
Date: Thu, 13 Dec 2007 11:21:40 -0500
Message-Id: <1197562900.17945.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.3 (2.21.3-4.fc9) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-EwGJGx0IwCYwzVOSDedN
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

gcc throws these warnings with:

CONFIG_ATM_FORE200E=m
# CONFIG_ATM_FORE200E_PCA is not set

drivers/atm/fore200e.c:2695: warning: 'fore200e_pca_detect' defined but
not used
drivers/atm/fore200e.c:2748: warning: 'fore200e_pca_remove_one' defined
but not used

By moving the #ifdef CONFIG_ATM_FORE200E_PCA around those two functions,
the compiler warnings are silenced.

(btw, I'm not subscribed to lkml, so please CC me on any responses,
although this is a wholly trivial patch, so I'm not expecting any.)

Signed-off-by: Tom "spot" Callaway <tcallawa@redhat.com>


--=-EwGJGx0IwCYwzVOSDedN
Content-Disposition: attachment; filename=linux-2.6.23-fore200e-warning-fix.patch
Content-Type: text/x-patch; name=linux-2.6.23-fore200e-warning-fix.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

--- linux-2.6.23.sparc64/drivers/atm/fore200e.c.BAD	2007-12-13 10:45:57.000000000 -0500
+++ linux-2.6.23.sparc64/drivers/atm/fore200e.c	2007-12-13 10:46:23.000000000 -0500
@@ -2689,7 +2689,7 @@
     return 0;
 }
 
-
+#ifdef CONFIG_ATM_FORE200E_PCA
 static int __devinit
 fore200e_pca_detect(struct pci_dev *pci_dev, const struct pci_device_id *pci_ent)
 {
@@ -2756,7 +2756,6 @@
 }
 
 
-#ifdef CONFIG_ATM_FORE200E_PCA
 static struct pci_device_id fore200e_pca_tbl[] = {
     { PCI_VENDOR_ID_FORE, PCI_DEVICE_ID_FORE_PCA200E, PCI_ANY_ID, PCI_ANY_ID,
       0, 0, (unsigned long) &fore200e_bus[0] },

--=-EwGJGx0IwCYwzVOSDedN--

