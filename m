Return-Path: <linux-kernel-owner+w=401wt.eu-S1753534AbZI1XeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbZI1XeP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 19:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753509AbZI1XeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 19:34:14 -0400
Received: from mail.gmx.net ([213.165.64.20]:36298 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753488AbZI1XeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 19:34:13 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+edpUgNyqelhnH0LFVd82cgXHnlKSE/sxUzEu7XG
	xNvEoAlPdotRvi
From: Peter Huewe <PeterHuewe@gmx.de>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: [PATCH] staging/et131x:  adding __init/__exit macros
Date: Tue, 29 Sep 2009 01:34:14 +0200
User-Agent: KMail/1.9.10
Cc: Alan Cox <alan@linux.intel.com>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, Jiri Kosina <trivial@kernel.org>,
       kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909290134.15295.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

Trivial patch which adds the __init/__exit macros to the module_init/
module_exit functions of ./staging/et131x/et131x_initpci.c

Greg, please have a look at the small patch and either pull it through
your staging tree, or please ack' it so Jiri can pull it through the trivial tree.

linux version v2.6.32-rc1 - linus git tree, Di 29. Sep 01:10:18 CEST 2009

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
diff --git a/drivers/staging/et131x/et131x_initpci.c b/drivers/staging/et131x/et131x_initpci.c
index 9db2056..5ec0d5b 100644
--- a/drivers/staging/et131x/et131x_initpci.c
+++ b/drivers/staging/et131x/et131x_initpci.c
@@ -989,7 +989,7 @@ static struct pci_driver et131x_driver = {
  *
  * Returns 0 on success, errno on failure (as defined in errno.h)
  */
-static int et131x_init_module(void)
+static int __init et131x_init_module(void)
 {
 	if (et131x_speed_set < PARM_SPEED_DUPLEX_MIN ||
 	    et131x_speed_set > PARM_SPEED_DUPLEX_MAX) {
@@ -1002,7 +1002,7 @@ static int et131x_init_module(void)
 /**
  * et131x_cleanup_module - The entry point called on driver cleanup
  */
-static void et131x_cleanup_module(void)
+static void __exit et131x_cleanup_module(void)
 {
 	pci_unregister_driver(&et131x_driver);
 }
