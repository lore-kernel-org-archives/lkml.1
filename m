Return-Path: <linux-kernel-owner+w=401wt.eu-S1751324AbXBZSgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324AbXBZSgO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 13:36:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030402AbXBZSgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 13:36:14 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbXBZSgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 13:36:13 -0500
Date: Mon, 26 Feb 2007 13:36:11 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jgarzik@pobox.com
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20070226183611.11886.61545.sendpatchset@prarit.boston.redhat.com>
Subject: [PATCH]: Fix __devinit & __devexit declarations in de2104x driver
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Resending (originally sent 2007-02-14).

__devinit & __devexit cleanups for de2104x driver.

Fixes MODPOST warnings similar to:

WARNING: drivers/net/tulip/de2104x.o - Section mismatch: reference to
.init.text:de_init_one from .data.rel.local after 'de_driver' (at offset 0x20)
WARNING: drivers/net/tulip/de2104x.o - Section mismatch: reference to
.exit.text:de_remove_one from .data.rel.local after 'de_driver' (at offset 0x28)

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

--- linux-2.6.18.ia64.orig/drivers/net/tulip/de2104x.c	2006-09-19 23:42:06.000000000 -0400
+++ linux-2.6.18.ia64/drivers/net/tulip/de2104x.c	2007-02-14 13:43:55.000000000 -0500
@@ -1685,7 +1685,7 @@ static struct ethtool_ops de_ethtool_ops
 	.get_regs		= de_get_regs,
 };
 
-static void __init de21040_get_mac_address (struct de_private *de)
+static void __devinit de21040_get_mac_address (struct de_private *de)
 {
 	unsigned i;
 
@@ -1703,7 +1703,7 @@ static void __init de21040_get_mac_addre
 	}
 }
 
-static void __init de21040_get_media_info(struct de_private *de)
+static void __devinit de21040_get_media_info(struct de_private *de)
 {
 	unsigned int i;
 
@@ -1730,7 +1730,7 @@ static void __init de21040_get_media_inf
 }
 
 /* Note: this routine returns extra data bits for size detection. */
-static unsigned __init tulip_read_eeprom(void __iomem *regs, int location, int addr_len)
+static unsigned __devinit tulip_read_eeprom(void __iomem *regs, int location, int addr_len)
 {
 	int i;
 	unsigned retval = 0;
@@ -1765,7 +1765,7 @@ static unsigned __init tulip_read_eeprom
 	return retval;
 }
 
-static void __init de21041_get_srom_info (struct de_private *de)
+static void __devinit de21041_get_srom_info (struct de_private *de)
 {
 	unsigned i, sa_offset = 0, ofs;
 	u8 ee_data[DE_EEPROM_SIZE + 6] = {};
@@ -1926,7 +1926,7 @@ bad_srom:
 	goto fill_defaults;
 }
 
-static int __init de_init_one (struct pci_dev *pdev,
+static int __devinit de_init_one (struct pci_dev *pdev,
 				  const struct pci_device_id *ent)
 {
 	struct net_device *dev;
@@ -2082,7 +2082,7 @@ err_out_free:
 	return rc;
 }
 
-static void __exit de_remove_one (struct pci_dev *pdev)
+static void __devexit de_remove_one (struct pci_dev *pdev)
 {
 	struct net_device *dev = pci_get_drvdata(pdev);
 	struct de_private *de = dev->priv;
@@ -2160,7 +2160,7 @@ static struct pci_driver de_driver = {
 	.name		= DRV_NAME,
 	.id_table	= de_pci_tbl,
 	.probe		= de_init_one,
-	.remove		= __exit_p(de_remove_one),
+	.remove		= __devexit_p(de_remove_one),
 #ifdef CONFIG_PM
 	.suspend	= de_suspend,
 	.resume		= de_resume,
