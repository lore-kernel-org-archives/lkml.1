Return-Path: <linux-kernel-owner+w=401wt.eu-S1751257AbXBMKvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751257AbXBMKvI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 05:51:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbXBMKvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 05:51:08 -0500
Received: from mfe1.polimi.it ([131.175.12.23]:43273 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751257AbXBMKvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 05:51:07 -0500
X-Greylist: delayed 1063 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Feb 2007 05:51:06 EST
Date: Tue, 13 Feb 2007 11:30:10 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [PATCH] fix error management in 8250_pci.c pciserial_resume_one
Message-ID: <20070213113010.27125d53@localhost>
X-Mailer: Sylpheed-Claws 2.5.6cvs10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.3.0.289146, Antispam-Engine: 2.5.0.283055, Antispam-Data: 2007.2.13.21933
X-PerlMx-Spam: Gauge=I, Probability=81%, Report='RELAY_IN_CBL 8, RDNS_GENERIC_POOLED 0, RDNS_SUSP_GENERIC 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0'
X-Spam-Score: ***** (Spam Prob: 81% GAuge: XXXXXXXX)
X-Probable-Spam: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  CC      drivers/serial/8250_pci.o
drivers/serial/8250_pci.c: In function 'pciserial_resume_one':
drivers/serial/8250_pci.c:1830: warning: ignoring return value of 'pci_enable_device', declared with attribute warn_unused_result

This patch fixes it.

Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
---

--- drivers/serial/8250_pci.c.orig	2007-02-13 11:04:03.579805618 +0100
+++ drivers/serial/8250_pci.c	2007-02-13 11:12:52.128454010 +0100
@@ -1819,6 +1819,7 @@
 static int pciserial_resume_one(struct pci_dev *dev)
 {
 	struct serial_private *priv = pci_get_drvdata(dev);
+	int rc;
 
 	pci_set_power_state(dev, PCI_D0);
 	pci_restore_state(dev);
@@ -1827,7 +1828,9 @@
 		/*
 		 * The device may have been disabled.  Re-enable it.
 		 */
-		pci_enable_device(dev);
+		rc = pci_enable_device(dev);
+		if (rc)
+			return rc;
 
 		pciserial_resume_ports(priv);
 	}
