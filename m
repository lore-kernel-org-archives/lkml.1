Return-Path: <linux-kernel-owner+w=401wt.eu-S1031120AbXD3LyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031120AbXD3LyK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 07:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031145AbXD3LyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 07:54:10 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:58138 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031120AbXD3LyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 07:54:08 -0400
Date: Mon, 30 Apr 2007 13:53:16 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 29/36] Use menuconfig objects II - Telephony
In-Reply-To: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704301352300.29151@yvahk01.tjqt.qr>
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
 drivers/telephony/Kconfig |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- linux-2.6.21-mm_20070428.orig/drivers/telephony/Kconfig
+++ linux-2.6.21-mm_20070428/drivers/telephony/Kconfig
@@ -2,10 +2,8 @@
 # Telephony device configuration
 #
 
-menu "Telephony Support"
-
-config PHONE
-	tristate "Linux telephony support"
+menuconfig PHONE
+	tristate "Telephony support"
 	---help---
 	  Say Y here if you have a telephony card, which for example allows
 	  you to use a regular phone for voice-over-IP applications.
@@ -16,9 +14,10 @@ config PHONE
 	  To compile this driver as a module, choose M here: the
 	  module will be called phonedev.
 
+if PHONE
+
 config PHONE_IXJ
 	tristate "QuickNet Internet LineJack/PhoneJack support"
-	depends on PHONE
 	---help---
 	  Say M if you have a telephony card manufactured by Quicknet
 	  Technologies, Inc.  These include the Internet PhoneJACK and
@@ -43,5 +42,4 @@ config PHONE_IXJ_PCMCIA
 	  cards manufactured by Quicknet Technologies, Inc.  This changes the
 	  card initialization code to work with the card manager daemon.
 
-endmenu
-
+endif # PHONE
