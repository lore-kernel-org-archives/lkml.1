Return-Path: <linux-kernel-owner+w=401wt.eu-S1752140AbXDWNzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbXDWNzK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 09:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753863AbXDWNzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 09:55:10 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:40373 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752140AbXDWNzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 09:55:08 -0400
Date: Mon, 23 Apr 2007 14:58:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: davem@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] openprom: Switch to ref counting PCI API
Message-ID: <20070423145840.3c74fbf8@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc6-mm1/drivers/sbus/char/openprom.c linux-2.6.21-rc6-mm1/drivers/sbus/char/openprom.c
--- linux.vanilla-2.6.21-rc6-mm1/drivers/sbus/char/openprom.c	2007-04-12 14:14:44.000000000 +0100
+++ linux-2.6.21-rc6-mm1/drivers/sbus/char/openprom.c	2007-04-23 12:13:55.087685248 +0100
@@ -249,7 +249,7 @@
 #ifdef CONFIG_PCI
 		struct pci_dev *pdev;
 		struct pcidev_cookie *pcp;
-		pdev = pci_find_slot (((int *) op->oprom_array)[0],
+		pdev = pci_get_bus_and_slot (((int *) op->oprom_array)[0],
 				      ((int *) op->oprom_array)[1]);
 
 		pcp = pdev->sysdata;
@@ -260,6 +260,7 @@
 			op->oprom_size = sizeof(int);
 			err = copyout(argp, op, bufsize + sizeof(int));
 		}
+		pci_dev_put(pdev);
 #endif
 	}
 
