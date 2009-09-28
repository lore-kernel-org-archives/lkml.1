Return-Path: <linux-kernel-owner+w=401wt.eu-S1753541AbZI1XlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbZI1XlA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 19:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753514AbZI1Xk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 19:40:59 -0400
Received: from mail.gmx.net ([213.165.64.20]:41289 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753510AbZI1Xk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 19:40:59 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+JcTIMkLSJ3QAwatOaYpd1fLECY3kheDs0bQB7Mj
	YB3jRg50zvlaPs
From: Peter Huewe <PeterHuewe@gmx.de>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: [PATCH] staging/cx25821:  adding __init/__exit macros
Date: Tue, 29 Sep 2009 01:40:59 +0200
User-Agent: KMail/1.9.10
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
       Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Jiri Kosina <trivial@kernel.org>, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909290141.00324.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

Trivial patch which adds the __init/__exit macros to the module_init/
module_exit functions of ./staging/cx25821/cx25821-core.c

Greg, please have a look at the small patch and either pull it through
your staging tree, or please ack' it so Jiri can pull it through the trivial tree.

linux version v2.6.32-rc1 - linus git tree, Di 29. Sep 01:10:18 CEST 2009

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
diff --git a/drivers/staging/cx25821/cx25821-core.c b/drivers/staging/cx25821/cx25821-core.c
index 8aceae5..67f689d 100644
--- a/drivers/staging/cx25821/cx25821-core.c
+++ b/drivers/staging/cx25821/cx25821-core.c
@@ -1521,7 +1521,7 @@ static struct pci_driver cx25821_pci_driver = {
 	.resume = NULL,
 };
 
-static int cx25821_init(void)
+static int __init cx25821_init(void)
 {
 	INIT_LIST_HEAD(&cx25821_devlist);
 	printk(KERN_INFO "cx25821 driver version %d.%d.%d loaded\n",
@@ -1530,7 +1530,7 @@ static int cx25821_init(void)
 	return pci_register_driver(&cx25821_pci_driver);
 }
 
-static void cx25821_fini(void)
+static void __exit cx25821_fini(void)
 {
 	pci_unregister_driver(&cx25821_pci_driver);
 }
