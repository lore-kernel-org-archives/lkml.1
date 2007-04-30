Return-Path: <linux-kernel-owner+w=401wt.eu-S1031042AbXD3L3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031042AbXD3L3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 07:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031022AbXD3L3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 07:29:23 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:60767 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031011AbXD3L3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 07:29:21 -0400
Date: Mon, 30 Apr 2007 13:27:48 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Jiri Kosina <jkosina@suse.cz>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-input@atrey.karlin.mff.cuni.cz
Subject: [PATCH 07/36] Use menuconfig objects II - HID
In-Reply-To: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704301326230.29151@yvahk01.tjqt.qr>
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
 drivers/hid/Kconfig |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- linux-2.6.21-mm_20070428.orig/drivers/hid/Kconfig
+++ linux-2.6.21-mm_20070428/drivers/hid/Kconfig
@@ -1,8 +1,12 @@
 #
 # HID driver configuration
 #
-menu "HID Devices"
+menuconfig HID_SUPPORT
+	bool "HID Devices"
 	depends on INPUT
+	default y
+
+if HID_SUPPORT
 
 config HID
 	tristate "Generic HID support"
@@ -58,5 +62,4 @@ config HIDRAW
 
 source "drivers/hid/usbhid/Kconfig"
 
-endmenu
-
+endif # HID_SUPPORT
