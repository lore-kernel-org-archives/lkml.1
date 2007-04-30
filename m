Return-Path: <linux-kernel-owner+w=401wt.eu-S1031149AbXD3Lzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031149AbXD3Lzh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 07:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031525AbXD3Lzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 07:55:37 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:59699 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031149AbXD3Lzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 07:55:35 -0400
Date: Mon, 30 Apr 2007 13:54:47 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Greg KH <greg@kroah.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 31/36] Use menuconfig objects II - UIO
In-Reply-To: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704301353460.29151@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Change Kconfig objects from "menu, config" into "menuconfig" so
that the user can disable the whole feature without having to
enter the menu first.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 drivers/uio/Kconfig |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- linux-2.6.21-mm_20070428.orig/drivers/uio/Kconfig
+++ linux-2.6.21-mm_20070428/drivers/uio/Kconfig
@@ -1,5 +1,4 @@
-menu "Userspace I/O"
-config UIO
+menuconfig UIO
 	tristate "Userspace I/O drivers"
 	default n
 	help
@@ -11,9 +10,10 @@ config UIO
 
 	  If you don't know what to do here, say N.
 
+if UIO
+
 config UIO_DUMMY
 	tristate "Userspace I/O dummy driver"
-	depends on UIO
 	default n
 	help
 	  This is an example dummy driver for the Userspace I/O
@@ -25,9 +25,9 @@ config UIO_DUMMY
 
 config UIO_CIF
 	tristate "generic Hilscher CIF Card driver"
-	depends on UIO && PCI
+	depends on PCI
 	default n
 	help
 	  Driver for Hilscher CIF cards.
 
-endmenu
+endif # UIO
