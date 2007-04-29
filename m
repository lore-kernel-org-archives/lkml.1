Return-Path: <linux-kernel-owner+w=401wt.eu-S1161369AbXD2VGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161369AbXD2VGG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 17:06:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161361AbXD2VFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 17:05:34 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:48225 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161340AbXD2VF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 17:05:28 -0400
Message-id: <884911045191324382@wsc.cz>
In-reply-to: <1726067771982725064@wsc.cz>
Subject: [PATCH 18/21] Char: cyclades, fix tty device unregister
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Sun, 29 Apr 2007 23:05:27 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cyclades, fix tty device unregister

put_tty_driver after unregistering devices

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 0d1d9602e00c115e03e04ee01f3ecc92adbbf504
tree dbb15b2d6088652a00d30b717bd476ecc697da08
parent fb2b658e64e69e56c52b1242b9957e9d96f28ade
author Jiri Slaby <jirislaby@gmail.com> Sun, 29 Apr 2007 11:27:08 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sun, 29 Apr 2007 11:27:08 +0200

 drivers/char/cyclades.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 620e17c..f23d481 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -5285,8 +5285,6 @@ static void __exit cy_cleanup_module(void)
 		printk(KERN_ERR "failed to unregister Cyclades serial "
 				"driver(%d)\n", e1);
 
-	put_tty_driver(cy_serial_driver);
-
 #ifdef CONFIG_PCI
 	pci_unregister_driver(&cy_pci_driver);
 #endif
@@ -5310,6 +5308,8 @@ static void __exit cy_cleanup_module(void)
 				tty_unregister_device(cy_serial_driver, e1);
 		}
 	}
+
+	put_tty_driver(cy_serial_driver);
 } /* cy_cleanup_module */
 
 module_init(cy_init);
