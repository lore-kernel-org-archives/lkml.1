Return-Path: <linux-kernel-owner+w=401wt.eu-S1756430AbZJAXib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430AbZJAXib (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 19:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755274AbZJAXi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 19:38:28 -0400
Received: from kroah.org ([198.145.64.141]:42111 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755903AbZJAXi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 19:38:26 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 16:33:23 2009
Message-Id: <20091001233323.116532896@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 16:31:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [patch 29/30] PM / PCMCIA: Drop second argument of pcmcia_socket_dev_suspend()
References: <20091001233116.947658905@mini.kroah.org>
Content-Disposition: inline; filename=pm-pcmcia-drop-second-argument-of-pcmcia_socket_dev_suspend.patch
In-Reply-To: <20091001233504.GA17709@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Rafael J. Wysocki <rjw@sisk.pl>

commit 827b4649d4626bf97b203b4bcd69476bb9b4e760 upstream.

pcmcia_socket_dev_suspend() doesn't use its second argument, so it
may be dropped safely.

This change is necessary for the subsequent yenta suspend/resume fix.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

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
 drivers/pcmcia/yenta_socket.c   |    2 +-
 include/pcmcia/ss.h             |    2 +-
 18 files changed, 18 insertions(+), 18 deletions(-)

--- a/drivers/pcmcia/at91_cf.c
+++ b/drivers/pcmcia/at91_cf.c
@@ -363,7 +363,7 @@ static int at91_cf_suspend(struct platfo
 	struct at91_cf_socket	*cf = platform_get_drvdata(pdev);
 	struct at91_cf_data	*board = cf->board;
 
-	pcmcia_socket_dev_suspend(&pdev->dev, mesg);
+	pcmcia_socket_dev_suspend(&pdev->dev);
 	if (device_may_wakeup(&pdev->dev)) {
 		enable_irq_wake(board->det_pin);
 		if (board->irq_pin)
--- a/drivers/pcmcia/au1000_generic.c
+++ b/drivers/pcmcia/au1000_generic.c
@@ -515,7 +515,7 @@ static int au1x00_drv_pcmcia_probe(struc
 static int au1x00_drv_pcmcia_suspend(struct platform_device *dev,
 				     pm_message_t state)
 {
-	return pcmcia_socket_dev_suspend(&dev->dev, state);
+	return pcmcia_socket_dev_suspend(&dev->dev);
 }
 
 static int au1x00_drv_pcmcia_resume(struct platform_device *dev)
--- a/drivers/pcmcia/bfin_cf_pcmcia.c
+++ b/drivers/pcmcia/bfin_cf_pcmcia.c
@@ -302,7 +302,7 @@ static int __devexit bfin_cf_remove(stru
 
 static int bfin_cf_suspend(struct platform_device *pdev, pm_message_t mesg)
 {
-	return pcmcia_socket_dev_suspend(&pdev->dev, mesg);
+	return pcmcia_socket_dev_suspend(&pdev->dev);
 }
 
 static int bfin_cf_resume(struct platform_device *pdev)
--- a/drivers/pcmcia/cs.c
+++ b/drivers/pcmcia/cs.c
@@ -101,7 +101,7 @@ EXPORT_SYMBOL(pcmcia_socket_list_rwsem);
 static int socket_resume(struct pcmcia_socket *skt);
 static int socket_suspend(struct pcmcia_socket *skt);
 
-int pcmcia_socket_dev_suspend(struct device *dev, pm_message_t state)
+int pcmcia_socket_dev_suspend(struct device *dev)
 {
 	struct pcmcia_socket *socket;
 
--- a/drivers/pcmcia/i82092.c
+++ b/drivers/pcmcia/i82092.c
@@ -42,7 +42,7 @@ MODULE_DEVICE_TABLE(pci, i82092aa_pci_id
 #ifdef CONFIG_PM
 static int i82092aa_socket_suspend (struct pci_dev *dev, pm_message_t state)
 {
-	return pcmcia_socket_dev_suspend(&dev->dev, state);
+	return pcmcia_socket_dev_suspend(&dev->dev);
 }
 
 static int i82092aa_socket_resume (struct pci_dev *dev)
--- a/drivers/pcmcia/i82365.c
+++ b/drivers/pcmcia/i82365.c
@@ -1241,7 +1241,7 @@ static int pcic_init(struct pcmcia_socke
 static int i82365_drv_pcmcia_suspend(struct platform_device *dev,
 				     pm_message_t state)
 {
-	return pcmcia_socket_dev_suspend(&dev->dev, state);
+	return pcmcia_socket_dev_suspend(&dev->dev);
 }
 
 static int i82365_drv_pcmcia_resume(struct platform_device *dev)
--- a/drivers/pcmcia/m32r_cfc.c
+++ b/drivers/pcmcia/m32r_cfc.c
@@ -699,7 +699,7 @@ static struct pccard_operations pcc_oper
 static int cfc_drv_pcmcia_suspend(struct platform_device *dev,
 				     pm_message_t state)
 {
-	return pcmcia_socket_dev_suspend(&dev->dev, state);
+	return pcmcia_socket_dev_suspend(&dev->dev);
 }
 
 static int cfc_drv_pcmcia_resume(struct platform_device *dev)
--- a/drivers/pcmcia/m32r_pcc.c
+++ b/drivers/pcmcia/m32r_pcc.c
@@ -675,7 +675,7 @@ static struct pccard_operations pcc_oper
 static int pcc_drv_pcmcia_suspend(struct platform_device *dev,
 				     pm_message_t state)
 {
-	return pcmcia_socket_dev_suspend(&dev->dev, state);
+	return pcmcia_socket_dev_suspend(&dev->dev);
 }
 
 static int pcc_drv_pcmcia_resume(struct platform_device *dev)
--- a/drivers/pcmcia/m8xx_pcmcia.c
+++ b/drivers/pcmcia/m8xx_pcmcia.c
@@ -1296,7 +1296,7 @@ static int m8xx_remove(struct of_device 
 #ifdef CONFIG_PM
 static int m8xx_suspend(struct platform_device *pdev, pm_message_t state)
 {
-	return pcmcia_socket_dev_suspend(&pdev->dev, state);
+	return pcmcia_socket_dev_suspend(&pdev->dev);
 }
 
 static int m8xx_resume(struct platform_device *pdev)
--- a/drivers/pcmcia/omap_cf.c
+++ b/drivers/pcmcia/omap_cf.c
@@ -334,7 +334,7 @@ static int __exit omap_cf_remove(struct 
 
 static int omap_cf_suspend(struct platform_device *pdev, pm_message_t mesg)
 {
-	return pcmcia_socket_dev_suspend(&pdev->dev, mesg);
+	return pcmcia_socket_dev_suspend(&pdev->dev);
 }
 
 static int omap_cf_resume(struct platform_device *pdev)
--- a/drivers/pcmcia/pd6729.c
+++ b/drivers/pcmcia/pd6729.c
@@ -758,7 +758,7 @@ static void __devexit pd6729_pci_remove(
 #ifdef CONFIG_PM
 static int pd6729_socket_suspend(struct pci_dev *dev, pm_message_t state)
 {
-	return pcmcia_socket_dev_suspend(&dev->dev, state);
+	return pcmcia_socket_dev_suspend(&dev->dev);
 }
 
 static int pd6729_socket_resume(struct pci_dev *dev)
--- a/drivers/pcmcia/pxa2xx_base.c
+++ b/drivers/pcmcia/pxa2xx_base.c
@@ -302,7 +302,7 @@ static int pxa2xx_drv_pcmcia_remove(stru
 
 static int pxa2xx_drv_pcmcia_suspend(struct platform_device *dev, pm_message_t state)
 {
-	return pcmcia_socket_dev_suspend(&dev->dev, state);
+	return pcmcia_socket_dev_suspend(&dev->dev);
 }
 
 static int pxa2xx_drv_pcmcia_resume(struct platform_device *dev)
--- a/drivers/pcmcia/sa1100_generic.c
+++ b/drivers/pcmcia/sa1100_generic.c
@@ -89,7 +89,7 @@ static int sa11x0_drv_pcmcia_remove(stru
 static int sa11x0_drv_pcmcia_suspend(struct platform_device *dev,
 				     pm_message_t state)
 {
-	return pcmcia_socket_dev_suspend(&dev->dev, state);
+	return pcmcia_socket_dev_suspend(&dev->dev);
 }
 
 static int sa11x0_drv_pcmcia_resume(struct platform_device *dev)
--- a/drivers/pcmcia/sa1111_generic.c
+++ b/drivers/pcmcia/sa1111_generic.c
@@ -159,7 +159,7 @@ static int __devexit pcmcia_remove(struc
 
 static int pcmcia_suspend(struct sa1111_dev *dev, pm_message_t state)
 {
-	return pcmcia_socket_dev_suspend(&dev->dev, state);
+	return pcmcia_socket_dev_suspend(&dev->dev);
 }
 
 static int pcmcia_resume(struct sa1111_dev *dev)
--- a/drivers/pcmcia/tcic.c
+++ b/drivers/pcmcia/tcic.c
@@ -366,7 +366,7 @@ static int __init get_tcic_id(void)
 static int tcic_drv_pcmcia_suspend(struct platform_device *dev,
 				     pm_message_t state)
 {
-	return pcmcia_socket_dev_suspend(&dev->dev, state);
+	return pcmcia_socket_dev_suspend(&dev->dev);
 }
 
 static int tcic_drv_pcmcia_resume(struct platform_device *dev)
--- a/drivers/pcmcia/vrc4171_card.c
+++ b/drivers/pcmcia/vrc4171_card.c
@@ -707,7 +707,7 @@ __setup("vrc4171_card=", vrc4171_card_se
 static int vrc4171_card_suspend(struct platform_device *dev,
 				     pm_message_t state)
 {
-	return pcmcia_socket_dev_suspend(&dev->dev, state);
+	return pcmcia_socket_dev_suspend(&dev->dev);
 }
 
 static int vrc4171_card_resume(struct platform_device *dev)
--- a/drivers/pcmcia/yenta_socket.c
+++ b/drivers/pcmcia/yenta_socket.c
@@ -1230,7 +1230,7 @@ static int yenta_dev_suspend (struct pci
 	struct yenta_socket *socket = pci_get_drvdata(dev);
 	int ret;
 
-	ret = pcmcia_socket_dev_suspend(&dev->dev, state);
+	ret = pcmcia_socket_dev_suspend(&dev->dev);
 
 	if (socket) {
 		if (socket->type && socket->type->save_state)
--- a/include/pcmcia/ss.h
+++ b/include/pcmcia/ss.h
@@ -279,7 +279,7 @@ extern struct pccard_resource_ops pccard
 extern struct pccard_resource_ops pccard_nonstatic_ops;
 
 /* socket drivers are expected to use these callbacks in their .drv struct */
-extern int pcmcia_socket_dev_suspend(struct device *dev, pm_message_t state);
+extern int pcmcia_socket_dev_suspend(struct device *dev);
 extern int pcmcia_socket_dev_resume(struct device *dev);
 
 /* socket drivers use this callback in their IRQ handler */


