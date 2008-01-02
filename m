Return-Path: <linux-kernel-owner+w=401wt.eu-S1755172AbYABOsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbYABOsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 09:48:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbYABOr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 09:47:57 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:61825 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980AbYABOrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 09:47:55 -0500
X-IronPort-AV: E=Sophos;i="4.24,235,1196658000"; 
   d="scan'208";a="59299171"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: gregkh@suse.de
Subject: [PATCH] : Allow embedded developers USB options normally reserved for OTG
Date: Wed, 2 Jan 2008 09:48:51 -0500
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801020948.51310.rgetz@blackfin.uclinux.org>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Jan 2008 14:47:53.0833 (UTC) FILETIME=[748E4D90:01C84D4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Getz <rgetz@blackfin.uclinux.org>

Allow embedded developers to turn support for USB Hubs off even if they have a 
full root hub. This saves the overhead (RAM and Flash size).

Allow embedded developers the capabilities of the "otg_whitelist.h" - a 
product whitelist, so USB peripherals not listed there will be rejected 
during enumeration. This is the desired operation for many embedded products.

Signed-off-by: Robin Getz <rgetz@blackfin.uclinux.org>

---

 drivers/usb/core/Kconfig |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)


Index: linux-2.6.x/drivers/usb/core/Kconfig
===================================================================
--- linux-2.6.x/drivers/usb/core/Kconfig	(revision 4074)
+++ linux-2.6.x/drivers/usb/core/Kconfig	(working copy)
@@ -95,8 +95,9 @@
 
 config USB_OTG_WHITELIST
 	bool "Rely on OTG Targeted Peripherals List"
-	depends on USB_OTG
-	default y
+	depends on USB_OTG || EMBEDDED
+	default y if USB_OTG
+	default n if EMBEDDED
 	help
 	  If you say Y here, the "otg_whitelist.h" file will be used as a
 	  product whitelist, so USB peripherals not listed there will be
@@ -111,7 +112,7 @@
 
 config USB_OTG_BLACKLIST_HUB
 	bool "Disable external hubs"
-	depends on USB_OTG
+	depends on USB_OTG || EMBEDDED
 	help
 	  If you say Y here, then Linux will refuse to enumerate
 	  external hubs.  OTG hosts are allowed to reduce hardware
