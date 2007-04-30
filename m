Return-Path: <linux-kernel-owner+w=401wt.eu-S1161260AbXD3Ljd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161260AbXD3Ljd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 07:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161475AbXD3Ljc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 07:39:32 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:44641 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161260AbXD3Ljb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 07:39:31 -0400
Date: Mon, 30 Apr 2007 13:37:55 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 15/36] Use menuconfig objects II - Macintosh
In-Reply-To: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704301336200.29151@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Make a "menuconfig" out of the Kconfig objects "menu, ..., endmenu",
so that the user can disable all the options in that menu at once
instead of having to disable each option separately.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 drivers/macintosh/Kconfig |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- linux-2.6.21-mm_20070428.orig/drivers/macintosh/Kconfig
+++ linux-2.6.21-mm_20070428/drivers/macintosh/Kconfig
@@ -1,6 +1,10 @@
 
-menu "Macintosh device drivers"
+menuconfig MACINTOSH_DRIVERS
+	bool "Macintosh device drivers"
 	depends on PPC || MAC || X86
+	default y
+
+if MACINTOSH_DRIVERS
 
 config ADB
 	bool "Apple Desktop Bus (ADB) support"
@@ -234,4 +238,4 @@ config PMAC_RACKMETER
 	  This driver procides some support to control the front panel
           blue LEDs "vu-meter" of the XServer macs.
 
-endmenu
+endif # MACINTOSH_DRIVERS
