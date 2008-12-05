Return-Path: <linux-kernel-owner+w=401wt.eu-S1755000AbYLEIly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000AbYLEIly (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 03:41:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750831AbYLEIlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 03:41:46 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:11508 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbYLEIlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 03:41:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=HmWLyEBe8ntVPmMBeuvQFfmVGzK3L0D8W/jpNHKKbDcrpQnmd2vqqQlUB7kyZyOc86
         wCjtdha1CbsjWUm/tLPdyPIcWXMiD8+Yn7EOUydQOAdlx4gf5eeMYTuO7b3aLHzTmz24
         WnBMBWD4NMB/uIXTaAe5DDuxgHrXvOqRSRpyc=
Date: Fri, 5 Dec 2008 11:45:59 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org, ben-linux@fluff.org
Cc: linux-kernel@vger.kernel.org
Subject: sm501: fix section mismatches
Message-ID: <20081205084559.GA22502@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drv => driver renaming is needed otherwise modpost will spit false positives
re pointing to __devinit function from regular data.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/mfd/sm501.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/drivers/mfd/sm501.c
+++ b/drivers/mfd/sm501.c
@@ -1295,7 +1295,7 @@ static unsigned int sm501_mem_local[] = {
  * Common init code for an SM501
 */
 
-static int sm501_init_dev(struct sm501_devdata *sm)
+static int __devinit sm501_init_dev(struct sm501_devdata *sm)
 {
 	struct sm501_initdata *idata;
 	struct sm501_platdata *pdata;
@@ -1371,7 +1371,7 @@ static int sm501_init_dev(struct sm501_devdata *sm)
 	return 0;
 }
 
-static int sm501_plat_probe(struct platform_device *dev)
+static int __devinit sm501_plat_probe(struct platform_device *dev)
 {
 	struct sm501_devdata *sm;
 	int ret;
@@ -1560,8 +1560,8 @@ static struct sm501_platdata sm501_pci_platdata = {
 	.gpio_base	= -1,
 };
 
-static int sm501_pci_probe(struct pci_dev *dev,
-			   const struct pci_device_id *id)
+static int __devinit sm501_pci_probe(struct pci_dev *dev,
+				     const struct pci_device_id *id)
 {
 	struct sm501_devdata *sm;
 	int err;
@@ -1667,7 +1667,7 @@ static void sm501_dev_remove(struct sm501_devdata *sm)
 	sm501_gpio_remove(sm);
 }
 
-static void sm501_pci_remove(struct pci_dev *dev)
+static void __devexit sm501_pci_remove(struct pci_dev *dev)
 {
 	struct sm501_devdata *sm = pci_get_drvdata(dev);
 
@@ -1701,16 +1701,16 @@ static struct pci_device_id sm501_pci_tbl[] = {
 
 MODULE_DEVICE_TABLE(pci, sm501_pci_tbl);
 
-static struct pci_driver sm501_pci_drv = {
+static struct pci_driver sm501_pci_driver = {
 	.name		= "sm501",
 	.id_table	= sm501_pci_tbl,
 	.probe		= sm501_pci_probe,
-	.remove		= sm501_pci_remove,
+	.remove		= __devexit_p(sm501_pci_remove),
 };
 
 MODULE_ALIAS("platform:sm501");
 
-static struct platform_driver sm501_plat_drv = {
+static struct platform_driver sm501_plat_driver = {
 	.driver		= {
 		.name	= "sm501",
 		.owner	= THIS_MODULE,
@@ -1723,14 +1723,14 @@ static struct platform_driver sm501_plat_drv = {
 
 static int __init sm501_base_init(void)
 {
-	platform_driver_register(&sm501_plat_drv);
-	return pci_register_driver(&sm501_pci_drv);
+	platform_driver_register(&sm501_plat_driver);
+	return pci_register_driver(&sm501_pci_driver);
 }
 
 static void __exit sm501_base_exit(void)
 {
-	platform_driver_unregister(&sm501_plat_drv);
-	pci_unregister_driver(&sm501_pci_drv);
+	platform_driver_unregister(&sm501_plat_driver);
+	pci_unregister_driver(&sm501_pci_driver);
 }
 
 module_init(sm501_base_init);
