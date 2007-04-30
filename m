Return-Path: <linux-kernel-owner+w=401wt.eu-S1031063AbXD3LbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031063AbXD3LbP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 07:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031090AbXD3LbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 07:31:15 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:34745 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031063AbXD3LbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 07:31:12 -0400
Date: Mon, 30 Apr 2007 13:29:32 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux1394-devel@lists.sourceforge.net
Subject: [PATCH 09/36] Use menuconfig objects II - IEEE1394
In-Reply-To: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704301328340.29151@yvahk01.tjqt.qr>
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

Follows Stefan's suggestion as per http://lkml.org/lkml/2007/4/28/108

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 drivers/ieee1394/Kconfig |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- linux-2.6.21-mm_20070428.orig/drivers/ieee1394/Kconfig
+++ linux-2.6.21-mm_20070428/drivers/ieee1394/Kconfig
@@ -1,4 +1,8 @@
-menu "IEEE 1394 (FireWire) support"
+menuconfig IEEE1394_SUPPORT
+	bool "IEEE 1394 (FireWire) support"
+	default y
+
+if IEEE1394_SUPPORT
 
 source "drivers/firewire/Kconfig"
 
@@ -146,4 +150,4 @@ config IEEE1394_RAWIO
 	  To compile this driver as a module, say M here: the module will be
 	  called raw1394.
 
-endmenu
+endif # IEEE1394_SUPPORT
