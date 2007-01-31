Return-Path: <linux-kernel-owner+w=401wt.eu-S1030271AbXAaQws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030271AbXAaQws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 11:52:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030277AbXAaQws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 11:52:48 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59729 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030271AbXAaQwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 11:52:47 -0500
Date: Wed, 31 Jan 2007 17:04:56 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org, jeff@garzik.org
Subject: [PATCH] atl1_main: pci_module_int returns to haunt us
Message-ID: <20070131170456.69fe6441@localhost.localdomain>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Perhaps Adrian would care to simply delete the pci_module_init ancient compat
code so nobody else can inadvertently merge a driver that uses it.

Signed-off-by: Alan Cox <alan@redhat.com>


diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-rc6-mm3/drivers/net/atl1/atl1_main.c linux-2.6.20-rc6-mm3/drivers/net/atl1/atl1_main.c
--- linux.vanilla-2.6.20-rc6-mm3/drivers/net/atl1/atl1_main.c	2007-01-31 14:20:41.000000000 +0000
+++ linux-2.6.20-rc6-mm3/drivers/net/atl1/atl1_main.c	2007-01-31 15:25:29.083361224 +0000
@@ -2482,12 +2482,9 @@
  **/
 static int __init atl1_init_module(void)
 {
-	int ret;
 	printk(KERN_INFO "%s - version %s\n", atl1_driver_string, DRIVER_VERSION);
 	printk(KERN_INFO "%s\n", atl1_copyright);
-	ret = pci_module_init(&atl1_driver);
-
-	return ret;
+	return pci_register_driver(&atl1_driver);
 }
 
 module_init(atl1_init_module);
