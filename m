Return-Path: <linux-kernel-owner+w=401wt.eu-S1752746AbZIYXZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbZIYXZp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 19:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbZIYXZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 19:25:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54673 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926AbZIYXZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 19:25:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 1/2] PM / PCMCIA: Drop second argument of pcmcia_socket_dev_suspend()
Date: Sat, 26 Sep 2009 01:25:11 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       linux-pcmcia@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Florian <fs-kernelbugzilla@spline.de>
References: <200909260122.59030.rjw@sisk.pl>
In-Reply-To: <200909260122.59030.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909260125.11149.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

pcmcia_socket_dev_suspend() doesn't use its second argument, so it
may be dropped safely.

This change is necessary for the subsequent yenta suspend/resume fix.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pcmcia/at91_cf.c        |    2 +-
 drivers/pcmcia/au1000_generic.c |    2 +-
 drivers/pcmcia/bfin_cf_pcmcia.c |    2 +-
 drivers/pcmcia/cs.c             |    2 +-
 drivers/pcmcia/i82092.c         |    2 +-
 drivers/pcmcia/i82365.c         |    2 +-
 drivers/pcmcia/m32r_cfc.c       |    2 +-
 drivers/pcmcia/m32r_pcc.c       |    2 +-
 drivers/pcmcia/m8xx_pcmcia.c    |    2 +-
 drivers/pcmcia/omap_cf.c        |    2 +-
 drivers/pcmcia/pd6729.c         |    2 +-
 drivers/pcmcia/pxa2xx_base.c    |    2 +-
 drivers/pcmcia/sa1100_generic.c |    2 +-
 drivers/pcmcia/sa1111_generic.c |    2 +-
 drivers/pcmcia/tcic.c           |    2 +-
 drivers/pcmcia/vrc4171_card.c   |    2 +-
 include/pcmcia/ss.h             |    2 +-
 17 files changed, 17 insertions(+), 17 deletions(-)

Index: linux-2.6/drivers/pcmcia/at91_cf.c
===================================================================
--- linux-2.6.orig/drivers/pcmcia/at91_cf.c
+++ linux-2.6/drivers/pcmcia/at91_cf.c
@@ -363,7 +363,7 @@ static int at91_cf_suspend(struct platfo
 	struct at91_cf_socket	*cf = platform_get_drvdata(pdev);
 	struct at91_cf_data	*board = cf->board;
 
-	pcmcia_socket_dev_suspend(&pdev->dev, mesg);
+	pcmcia_socket_dev_suspend(&pdev->dev);
 	if (device_may_wakeup(&pdev->dev)) {
 		enable_irq_wake(board->det_pin);
 		if (board->irq_pin)
Index: linux-2.6/drivers/pcmcia/au1000_generic.c
===================================================================
--- linux-2.6.orig/drivers/pcmcia/au1000_generic.c
+++ linux-2.6/drivers/pcmcia/au1000_generic.c
@@ -515,7 +515,7 @@ static int au1x00_drv_pcmcia_probe(struc
 static int au1x00_drv_pcmcia_suspend(struct platform_device *dev,
 				     pm_message_t state)
 {
-	return pcmcia_socket_dev_suspend(&dev->dev, state);
+	return pcmcia_socket_dev_suspend(&dev->dev);
 }
 
 static int au1x00_drv_pcmcia_resume(struct platform_device *dev)
Index: linux-2.6/drivers/pcmcia/bfin_cf_pcmcia.c
===================================================================
--- linux-2.6.orig/drivers/pcmcia/bfin_cf_pcmcia.c
+++ linux-2.6/drivers/pcmcia/bfin_cf_pcmcia.c
@@ -302,7 +302,7 @@ static int __devexit bfin_cf_remove(stru
 
 static int bfin_cf_suspend(struct platform_device *pdev, pm_message_t mesg)
 {
-	return pcmcia_socket_dev_suspend(&pdev->dev, mesg);
+	return pcmcia_socket_dev_suspend(&pdev->dev);
 }
 
 static int bfin_cf_resume(struct platform_device *pdev)
Index: linux-2.6/drivers/pcmcia/cs.c
===================================================================
--- linux-2.6.orig/drivers/pcmcia/cs.c
+++ linux-2.6/drivers/pcmcia/cs.c
@@ -101,7 +101,7 @@ EXPORT_SYMBOL(pcmcia_socket_list_rwsem);
 static int socket_resume(struct pcmcia_socket *skt);
 static int socket_suspend(struct pcmcia_socket *skt);
 
-int pcmcia_socket_dev_suspend(struct device *dev, pm_message_t state)
+int pcmcia_socket_dev_suspend(struct device *dev)
 {
 	struct pcmcia_socket *socket;
 
Index: linux-2.6/drivers/pcmcia/i82092.c
===================================================================
--- linux-2.6.orig/drivers/pcmcia/i82092.c
+++ linux-2.6/drivers/pcmcia/i82092.c
@@ -42,7 +42,7 @@ MODULE_DEVICE_TABLE(pci, i82092aa_pci_id
 #ifdef CONFIG_PM
 static int i82092aa_socket_suspend (struct pci_dev *dev, pm_message_t state)
 {
-	return pcmcia_socket_dev_suspend(&dev->dev, state);
+	return pcmcia_socket_dev_suspend(&dev->dev);
 }
 
 static int i82092aa_socket_resume (struct pci_dev *dev)
Index: linux-2.6/include/pcmcia/ss.h
===================================================================
--- linux-2.6.orig/include/pcmcia/ss.h
+++ linux-2.6/include/pcmcia/ss.h
@@ -279,7 +279,7 @@ extern struct pccard_resource_ops pccard
 extern struct pccard_resource_ops pccard_nonstatic_ops;
 
 /* socket drivers are expected to use these callbacks in their .drv struct */
-extern int pcmcia_socket_dev_suspend(struct device *dev, pm_message_t state);
+extern int pcmcia_socket_dev_suspend(struct device *dev);
 extern int pcmcia_socket_dev_resume(struct device *dev);
 
 /* socket drivers use this callback in their IRQ handler */
Index: linux-2.6/drivers/pcmcia/i82365.c
===================================================================
--- linux-2.6.orig/drivers/pcmcia/i82365.c
+++ linux-2.6/drivers/pcmcia/i82365.c
@@ -1241,7 +1241,7 @@ static int pcic_init(struct pcmcia_socke
 static int i82365_drv_pcmcia_suspend(struct platform_device *dev,
 				     pm_message_t state)
 {
-	return pcmcia_socket_dev_suspend(&dev->dev, state);
+	return pcmcia_socket_dev_suspend(&dev->dev);
 }
 
 static int i82365_drv_pcmcia_resume(struct platform_device *dev)
Index: linux-2.6/drivers/pcmcia/m32r_cfc.c
===================================================================
--- linux-2.6.orig/drivers/pcmcia/m32r_cfc.c
+++ linux-2.6/drivers/pcmcia/m32r_cfc.c
@@ -699,7 +699,7 @@ static struct pccard_operations pcc_oper
 static int cfc_drv_pcmcia_suspend(struct platform_device *dev,
 				     pm_message_t state)
 {
-	return pcmcia_socket_dev_suspend(&dev->dev, state);
+	return pcmcia_socket_dev_suspend(&dev->dev);
 }
 
 static int cfc_drv_pcmcia_resume(struct platform_device *dev)
Index: linux-2.6/drivers/pcmcia/m32r_pcc.c
===================================================================
--- linux-2.6.orig/drivers/pcmcia/m32r_pcc.c
+++ linux-2.6/drivers/pcmcia/m32r_pcc.c
@@ -675,7 +675,7 @@ static struct pccard_operations pcc_oper
 static int pcc_drv_pcmcia_suspend(struct platform_device *dev,
 				     pm_message_t state)
 {
-	return pcmcia_socket_dev_suspend(&dev->dev, state);
+	return pcmcia_socket_dev_suspend(&dev->dev);
 }
 
 static int pcc_drv_pcmcia_resume(struct platform_device *dev)
Index: linux-2.6/drivers/pcmcia/m8xx_pcmcia.c
===================================================================
--- linux-2.6.orig/drivers/pcmcia/m8xx_pcmcia.c
+++ linux-2.6/drivers/pcmcia/m8xx_pcmcia.c
@@ -1296,7 +1296,7 @@ static int m8xx_remove(struct of_device 
 #ifdef CONFIG_PM
 static int m8xx_suspend(struct platform_device *pdev, pm_message_t state)
 {
-	return pcmcia_socket_dev_suspend(&pdev->dev, state);
+	return pcmcia_socket_dev_suspend(&pdev->dev);
 }
 
 static int m8xx_resume(struct platform_device *pdev)
Index: linux-2.6/drivers/pcmcia/omap_cf.c
===================================================================
--- linux-2.6.orig/drivers/pcmcia/omap_cf.c
+++ linux-2.6/drivers/pcmcia/omap_cf.c
@@ -334,7 +334,7 @@ static int __exit omap_cf_remove(struct 
 
 static int omap_cf_suspend(struct platform_device *pdev, pm_message_t mesg)
 {
-	return pcmcia_socket_dev_suspend(&pdev->dev, mesg);
+	return pcmcia_socket_dev_suspend(&pdev->dev);
 }
 
 static int omap_cf_resume(struct platform_device *pdev)
Index: linux-2.6/drivers/pcmcia/pd6729.c
===================================================================
--- linux-2.6.orig/drivers/pcmcia/pd6729.c
+++ linux-2.6/drivers/pcmcia/pd6729.c
@@ -758,7 +758,7 @@ static void __devexit pd6729_pci_remove(
 #ifdef CONFIG_PM
 static int pd6729_socket_suspend(struct pci_dev *dev, pm_message_t state)
 {
-	return pcmcia_socket_dev_suspend(&dev->dev, state);
+	return pcmcia_socket_dev_suspend(&dev->dev);
 }
 
 static int pd6729_socket_resume(struct pci_dev *dev)
Index: linux-2.6/drivers/pcmcia/pxa2xx_base.c
===================================================================
--- linux-2.6.orig/drivers/pcmcia/pxa2xx_base.c
+++ linux-2.6/drivers/pcmcia/pxa2xx_base.c
@@ -302,7 +302,7 @@ static int pxa2xx_drv_pcmcia_remove(stru
 
 static int pxa2xx_drv_pcmcia_suspend(struct device *dev)
 {
-	return pcmcia_socket_dev_suspend(dev, PMSG_SUSPEND);
+	return pcmcia_socket_dev_suspend(dev);
 }
 
 static int pxa2xx_drv_pcmcia_resume(struct device *dev)
Index: linux-2.6/drivers/pcmcia/sa1100_generic.c
===================================================================
--- linux-2.6.orig/drivers/pcmcia/sa1100_generic.c
+++ linux-2.6/drivers/pcmcia/sa1100_generic.c
@@ -89,7 +89,7 @@ static int sa11x0_drv_pcmcia_remove(stru
 static int sa11x0_drv_pcmcia_suspend(struct platform_device *dev,
 				     pm_message_t state)
 {
-	return pcmcia_socket_dev_suspend(&dev->dev, state);
+	return pcmcia_socket_dev_suspend(&dev->dev);
 }
 
 static int sa11x0_drv_pcmcia_resume(struct platform_device *dev)
Index: linux-2.6/drivers/pcmcia/sa1111_generic.c
===================================================================
--- linux-2.6.orig/drivers/pcmcia/sa1111_generic.c
+++ linux-2.6/drivers/pcmcia/sa1111_generic.c
@@ -159,7 +159,7 @@ static int __devexit pcmcia_remove(struc
 
 static int pcmcia_suspend(struct sa1111_dev *dev, pm_message_t state)
 {
-	return pcmcia_socket_dev_suspend(&dev->dev, state);
+	return pcmcia_socket_dev_suspend(&dev->dev);
 }
 
 static int pcmcia_resume(struct sa1111_dev *dev)
Index: linux-2.6/drivers/pcmcia/tcic.c
===================================================================
--- linux-2.6.orig/drivers/pcmcia/tcic.c
+++ linux-2.6/drivers/pcmcia/tcic.c
@@ -366,7 +366,7 @@ static int __init get_tcic_id(void)
 static int tcic_drv_pcmcia_suspend(struct platform_device *dev,
 				     pm_message_t state)
 {
-	return pcmcia_socket_dev_suspend(&dev->dev, state);
+	return pcmcia_socket_dev_suspend(&dev->dev);
 }
 
 static int tcic_drv_pcmcia_resume(struct platform_device *dev)
Index: linux-2.6/drivers/pcmcia/vrc4171_card.c
===================================================================
--- linux-2.6.orig/drivers/pcmcia/vrc4171_card.c
+++ linux-2.6/drivers/pcmcia/vrc4171_card.c
@@ -707,7 +707,7 @@ __setup("vrc4171_card=", vrc4171_card_se
 static int vrc4171_card_suspend(struct platform_device *dev,
 				     pm_message_t state)
 {
-	return pcmcia_socket_dev_suspend(&dev->dev, state);
+	return pcmcia_socket_dev_suspend(&dev->dev);
 }
 
 static int vrc4171_card_resume(struct platform_device *dev)

