Return-Path: <linux-kernel-owner+w=401wt.eu-S1761998AbXGVRmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761998AbXGVRmX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 13:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753920AbXGVRmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 13:42:14 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:65244 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566AbXGVRmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 13:42:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=cY3rm4JskTQK/csKC3iwnssaPykJtkHcCyyrJU9YAPslBfqk0eCC7+kDtgXdvzHJUkbhAtRAOYXDHTdFofKAUCK4hYyTDVKW8dgO9Jgg8Lay0CgzD2+eWAhrCX+u2sCQXlnJRr78o0FB9RvVAehYjnGpkxy52bsIUBuBmROcnu4=
Message-ID: <46A3966B.9000601@googlemail.com>
Date: Sun, 22 Jul 2007 19:39:55 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: linux-scsi@vger.kernel.org
Subject: [PATCH] Fix drivers/scsi/fdomain.c , CONFIG_PCI=n warnings
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I get this warnings on current git when CONFIG_PCI is not set :

...

drivers/scsi/fdomain.c:390: warning: 'PCI_dev' defined but not used
drivers/scsi/fdomain.c:1768: warning: 'fdomain_pci_tbl' defined but not used

...


Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>

---

diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
index 36169d5..5d282e6 100644
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -387,7 +387,9 @@ static void __iomem *    bios_mem;
 static int               bios_major;
 static int               bios_minor;
 static int               PCI_bus;
+#ifdef CONFIG_PCI
 static struct pci_dev	*PCI_dev;
+#endif
 static int               Quantum;	/* Quantum board variant */
 static int               interrupt_level;
 static volatile int      in_command;
@@ -1764,6 +1766,7 @@ struct scsi_host_template fdomain_driver_template = {
 };
 
 #ifndef PCMCIA
+#ifdef CONFIG_PCI
 
 static struct pci_device_id fdomain_pci_tbl[] __devinitdata = {
 	{ PCI_VENDOR_ID_FD, PCI_DEVICE_ID_FD_36C70,
@@ -1771,7 +1774,7 @@ static struct pci_device_id fdomain_pci_tbl[] __devinitdata = {
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, fdomain_pci_tbl);
-
+#endif
 #define driver_template fdomain_driver_template
 #include "scsi_module.c"
 
