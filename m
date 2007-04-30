Return-Path: <linux-kernel-owner+w=401wt.eu-S1031011AbXD3Luo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031011AbXD3Luo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 07:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031120AbXD3Luo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 07:50:44 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:54770 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031011AbXD3LuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 07:50:19 -0400
Date: Mon, 30 Apr 2007 13:48:59 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Anton Vorontsov <cbou@mail.ru>
Subject: [PATCH 25/36] Use menuconfig objects II - (external_)power
In-Reply-To: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704301347500.29151@yvahk01.tjqt.qr>
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
 drivers/power/Kconfig |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- linux-2.6.21-mm_20070428.orig/drivers/power/Kconfig
+++ linux-2.6.21-mm_20070428/drivers/power/Kconfig
@@ -1,7 +1,5 @@
 
-menu "External power support"
-
-config EXTERNAL_POWER
+menuconfig EXTERNAL_POWER
 	tristate "External power kernel interface"
 	help
 	  Say Y here to enable kernel external power detection interface,
@@ -10,12 +8,13 @@ config EXTERNAL_POWER
 
 	  This interface is mandatory for battery class support.
 
+if EXTERNAL_POWER
+
 config PDA_POWER
 	tristate "Generic PDA/phone power driver"
-	depends on EXTERNAL_POWER
 	help
 	  Say Y here to enable generic power driver for PDAs and phones with
 	  one or two external power supplies (AC/USB) connected to main and
 	  backup batteries, and optional builtin charger.
 
-endmenu
+endif # EXTERNAL_POWER
