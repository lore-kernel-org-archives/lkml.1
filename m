Return-Path: <linux-kernel-owner+w=401wt.eu-S1756924AbZLWUS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924AbZLWUS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 15:18:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756878AbZLWUS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 15:18:27 -0500
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:15323 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756813AbZLWUS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 15:18:26 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAD4KMktbstnt/2dsb2JhbADYfQqEKQSBZQ
Date: Wed, 23 Dec 2009 21:18:22 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Imre Kaloz <kaloz@openwrt.org>,
       H Hartley Sweeten <hartleys@visionengravers.com>
Subject: [WATCHDOG] v2.6.33-rc patches
Message-ID: <20091223201822.GG5402@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 drivers/watchdog/adx_wdt.c        |    4 ++--
 drivers/watchdog/at32ap700x_wdt.c |    2 +-
 drivers/watchdog/davinci_wdt.c    |    2 +-
 drivers/watchdog/iTCO_wdt.c       |    4 ++++
 drivers/watchdog/mpcore_wdt.c     |    2 +-
 drivers/watchdog/mv64x60_wdt.c    |    2 +-
 drivers/watchdog/omap_wdt.c       |    9 ++++-----
 drivers/watchdog/pnx4008_wdt.c    |    2 +-
 drivers/watchdog/s3c2410_wdt.c    |    2 +-
 drivers/watchdog/txx9wdt.c        |    6 ++----
 10 files changed, 18 insertions(+), 17 deletions(-)

with these Changes:

Author: H Hartley Sweeten <hartleys@visionengravers.com>
Date:   Fri Dec 4 12:24:04 2009 -0500

    [WATCHDOG] use resource_size()
    
    Use resource_size().
    
    Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
    Cc: Kevin Hilman <khilman@deeprootsystems.com>
    Cc: Kevin Hilman <khilman@ti.deeprootsystems.com>
    Cc: Ulrik Bech Hald <ubh@ti.com>
    Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Cc: Ming Lei <tom.leiming@gmail.com>
    Cc: Vincent Sanders <support@simtec.co.uk>
    Acked-by: Thierry Reding <thierry.reding@avionic-design.de>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Author: Imre Kaloz <kaloz@openwrt.org>
Date:   Mon Dec 7 20:42:26 2009 +0100

    [WATCHDOG] iTCO_wdt: add PCI ID for the Intel EP80579 (Tolapai) SoC
    
    add PCI ID for the Intel EP80579 (Tolapai) SoC
    
    Signed-off-by: Imre Kaloz <kaloz@openwrt.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/adx_wdt.c b/drivers/watchdog/adx_wdt.c
index 9c65944..9d7d155 100644
--- a/drivers/watchdog/adx_wdt.c
+++ b/drivers/watchdog/adx_wdt.c
@@ -242,14 +242,14 @@ static int __devinit adx_wdt_probe(struct platform_device *pdev)
 	}
 
 	res = devm_request_mem_region(&pdev->dev, res->start,
-			res->end - res->start + 1, res->name);
+			resource_size(res), res->name);
 	if (!res) {
 		dev_err(&pdev->dev, "cannot request I/O memory region\n");
 		return -ENXIO;
 	}
 
 	wdt->base = devm_ioremap_nocache(&pdev->dev, res->start,
-			res->end - res->start + 1);
+			resource_size(res));
 	if (!wdt->base) {
 		dev_err(&pdev->dev, "cannot remap I/O memory region\n");
 		return -ENXIO;
diff --git a/drivers/watchdog/at32ap700x_wdt.c b/drivers/watchdog/at32ap700x_wdt.c
index e8ae638..0378479 100644
--- a/drivers/watchdog/at32ap700x_wdt.c
+++ b/drivers/watchdog/at32ap700x_wdt.c
@@ -326,7 +326,7 @@ static int __init at32_wdt_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	wdt->regs = ioremap(regs->start, regs->end - regs->start + 1);
+	wdt->regs = ioremap(regs->start, resource_size(regs));
 	if (!wdt->regs) {
 		ret = -ENOMEM;
 		dev_dbg(&pdev->dev, "could not map I/O memory\n");
diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
index 9d7520f..887136d 100644
--- a/drivers/watchdog/davinci_wdt.c
+++ b/drivers/watchdog/davinci_wdt.c
@@ -221,7 +221,7 @@ static int __devinit davinci_wdt_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	size = res->end - res->start + 1;
+	size = resource_size(res);
 	wdt_mem = request_mem_region(res->start, size, pdev->name);
 
 	if (wdt_mem == NULL) {
diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index e44fbb3..c8a3bec 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -30,6 +30,7 @@
  *	document number 316972-004, 316973-012: 82801I (ICH9)
  *	document number 319973-002, 319974-002: 82801J (ICH10)
  *	document number 322169-001, 322170-001: 5 Series, 3400 Series (PCH)
+ *	document number 320066-003, 320257-008: EP80597 (IICH)
  */
 
 /*
@@ -100,6 +101,7 @@ enum iTCO_chipsets {
 	TCO_PCH,	/* PCH Desktop Full Featured */
 	TCO_PCHM,	/* PCH Mobile Full Featured */
 	TCO_PCHMSFF,	/* PCH Mobile SFF Full Featured */
+	TCO_EP80579,	/* EP80579 */
 };
 
 static struct {
@@ -143,6 +145,7 @@ static struct {
 	{"PCH Desktop Full Featured", 2},
 	{"PCH Mobile Full Featured", 2},
 	{"PCH Mobile SFF Full Featured", 2},
+	{"EP80579", 2},
 	{NULL, 0}
 };
 
@@ -214,6 +217,7 @@ static struct pci_device_id iTCO_wdt_pci_tbl[] = {
 	{ ITCO_PCI_DEVICE(0x3b00,				TCO_PCH)},
 	{ ITCO_PCI_DEVICE(0x3b01,				TCO_PCHM)},
 	{ ITCO_PCI_DEVICE(0x3b0d,				TCO_PCHMSFF)},
+	{ ITCO_PCI_DEVICE(0x5031,				TCO_EP80579)},
 	{ 0, },			/* End of list */
 };
 MODULE_DEVICE_TABLE(pci, iTCO_wdt_pci_tbl);
diff --git a/drivers/watchdog/mpcore_wdt.c b/drivers/watchdog/mpcore_wdt.c
index 83fa34b..a2dc07c 100644
--- a/drivers/watchdog/mpcore_wdt.c
+++ b/drivers/watchdog/mpcore_wdt.c
@@ -350,7 +350,7 @@ static int __devinit mpcore_wdt_probe(struct platform_device *dev)
 		ret = -ENXIO;
 		goto err_free;
 	}
-	wdt->base = ioremap(res->start, res->end - res->start + 1);
+	wdt->base = ioremap(res->start, resource_size(res));
 	if (!wdt->base) {
 		ret = -ENOMEM;
 		goto err_free;
diff --git a/drivers/watchdog/mv64x60_wdt.c b/drivers/watchdog/mv64x60_wdt.c
index acf589d..a51dbe4 100644
--- a/drivers/watchdog/mv64x60_wdt.c
+++ b/drivers/watchdog/mv64x60_wdt.c
@@ -275,7 +275,7 @@ static int __devinit mv64x60_wdt_probe(struct platform_device *dev)
 	if (!r)
 		return -ENODEV;
 
-	mv64x60_wdt_regs = ioremap(r->start, r->end - r->start + 1);
+	mv64x60_wdt_regs = ioremap(r->start, resource_size(r));
 	if (mv64x60_wdt_regs == NULL)
 		return -ENOMEM;
 
diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index 429ea99..c6aaf28 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -277,8 +277,7 @@ static int __devinit omap_wdt_probe(struct platform_device *pdev)
 		goto err_busy;
 	}
 
-	mem = request_mem_region(res->start, res->end - res->start + 1,
-				 pdev->name);
+	mem = request_mem_region(res->start, resource_size(res), pdev->name);
 	if (!mem) {
 		ret = -EBUSY;
 		goto err_busy;
@@ -306,7 +305,7 @@ static int __devinit omap_wdt_probe(struct platform_device *pdev)
 		goto err_clk;
 	}
 
-	wdev->base = ioremap(res->start, res->end - res->start + 1);
+	wdev->base = ioremap(res->start, resource_size(res));
 	if (!wdev->base) {
 		ret = -ENOMEM;
 		goto err_ioremap;
@@ -358,7 +357,7 @@ err_clk:
 	kfree(wdev);
 
 err_kzalloc:
-	release_mem_region(res->start, res->end - res->start + 1);
+	release_mem_region(res->start, resource_size(res));
 
 err_busy:
 err_get_resource:
@@ -383,7 +382,7 @@ static int __devexit omap_wdt_remove(struct platform_device *pdev)
 		return -ENOENT;
 
 	misc_deregister(&(wdev->omap_wdt_miscdev));
-	release_mem_region(res->start, res->end - res->start + 1);
+	release_mem_region(res->start, resource_size(res));
 	platform_set_drvdata(pdev, NULL);
 
 	clk_put(wdev->ick);
diff --git a/drivers/watchdog/pnx4008_wdt.c b/drivers/watchdog/pnx4008_wdt.c
index 4d227b1..430a584 100644
--- a/drivers/watchdog/pnx4008_wdt.c
+++ b/drivers/watchdog/pnx4008_wdt.c
@@ -264,7 +264,7 @@ static int __devinit pnx4008_wdt_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	size = res->end - res->start + 1;
+	size = resource_size(res);
 	wdt_mem = request_mem_region(res->start, size, pdev->name);
 
 	if (wdt_mem == NULL) {
diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index 85b93e1..8760a26 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -421,7 +421,7 @@ static int __devinit s3c2410wdt_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	size = (res->end - res->start) + 1;
+	size = resource_size(res);
 	wdt_mem = request_mem_region(res->start, size, pdev->name);
 	if (wdt_mem == NULL) {
 		dev_err(dev, "failed to get memory region\n");
diff --git a/drivers/watchdog/txx9wdt.c b/drivers/watchdog/txx9wdt.c
index 6adab77..d635566 100644
--- a/drivers/watchdog/txx9wdt.c
+++ b/drivers/watchdog/txx9wdt.c
@@ -214,12 +214,10 @@ static int __init txx9wdt_probe(struct platform_device *dev)
 	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
 	if (!res)
 		goto exit_busy;
-	if (!devm_request_mem_region(&dev->dev,
-				     res->start, res->end - res->start + 1,
+	if (!devm_request_mem_region(&dev->dev, res->start, resource_size(res),
 				     "txx9wdt"))
 		goto exit_busy;
-	txx9wdt_reg = devm_ioremap(&dev->dev,
-				   res->start, res->end - res->start + 1);
+	txx9wdt_reg = devm_ioremap(&dev->dev, res->start, resource_size(res));
 	if (!txx9wdt_reg)
 		goto exit_busy;
 
