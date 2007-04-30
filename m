Return-Path: <linux-kernel-owner+w=401wt.eu-S1161543AbXD3Lku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161543AbXD3Lku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 07:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161499AbXD3Lkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 07:40:49 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:45547 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161543AbXD3Lkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 07:40:35 -0400
Date: Mon, 30 Apr 2007 13:40:16 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 17/36] Use menuconfig objects II - misc strange dev
In-Reply-To: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704301339240.29151@yvahk01.tjqt.qr>
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
 drivers/misc/Kconfig |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- linux-2.6.21-mm_20070428.orig/drivers/misc/Kconfig
+++ linux-2.6.21-mm_20070428/drivers/misc/Kconfig
@@ -2,7 +2,11 @@
 # Misc strange devices
 #
 
-menu "Misc devices"
+menuconfig MISC_STRANGE_DEV
+	bool "Misc devices"
+	default y
+
+if MISC_STRANGE_DEV
 
 config IBM_ASM
 	tristate "Device driver for IBM RSA service processor"
@@ -186,5 +190,4 @@ config BLINK
 	  output something to the screen like kexec kernels to give the user
 	  a visual indication that the kernel is doing something.
 
-
-endmenu
+endif # MISC_STRANGE_DEV
