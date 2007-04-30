Return-Path: <linux-kernel-owner+w=401wt.eu-S1754658AbXD3LVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbXD3LVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 07:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754976AbXD3LVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 07:21:43 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:48802 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754658AbXD3LVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 07:21:41 -0400
Date: Mon, 30 Apr 2007 13:20:50 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Miguel Ojeda Sandonis <maxextreme@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 02/36] Use menuconfig objects II - auxdisplay
In-Reply-To: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704301315590.29151@yvahk01.tjqt.qr>
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
 drivers/auxdisplay/Kconfig |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- linux-2.6.21-mm_20070428.orig/drivers/auxdisplay/Kconfig
+++ linux-2.6.21-mm_20070428/drivers/auxdisplay/Kconfig
@@ -5,7 +5,11 @@
 # Auxiliary display drivers configuration.
 #
 
-menu "Auxiliary Display support"
+menuconfig AUXDISPLAY
+	bool "Auxiliary Display support"
+	default y
+
+if AUXDISPLAY
 
 config KS0108
 	tristate "KS0108 LCD Controller"
@@ -106,4 +110,5 @@ config CFAG12864B_RATE
 
 	  If you compile this as a module, you can still override this
 	  value using the module parameters.
-endmenu
+
+endif # AUXDISPLAY
