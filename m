Return-Path: <linux-kernel-owner+w=401wt.eu-S1752910Ab0AGUd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab0AGUd1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 15:33:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580Ab0AGUd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 15:33:26 -0500
Received: from mail.gmx.net ([213.165.64.20]:46207 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750944Ab0AGUd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 15:33:26 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+zBJVaTvKztFilBSfSNhjyT8+jZMh/2YO42n6v0A
	f0ZVdTTGaVt+ch
From: Peter Huewe <PeterHuewe@gmx.de>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: [PATCH 1/3] staging/otus: Add select WEXT_PRIV to Kconfig to prevent build failure
Date: Thu, 7 Jan 2010 21:33:20 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.27-05415-g69a8594; KDE/4.3.3; x86_64; ; )
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201001072133.20487.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>
Date: Thu, 7 Jan 2010 21:13:55 +0100

Without WEXT_PRIV set the driver fails to build due to unknown fields in
the iw_handler_def struct.
Those fields are enclosed in WEXT_PRIV conditionals in the prototype
of iw_handler_def in include/net/iw_handler.h

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
Patch against Linux-next of Do 7. Jan 19:59:41 CET 2010

drivers/staging/otus/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/otus/Kconfig b/drivers/staging/otus/Kconfig
index f6cc262..409e01c 100644
--- a/drivers/staging/otus/Kconfig
+++ b/drivers/staging/otus/Kconfig
@@ -1,6 +1,8 @@
 config OTUS
 	tristate "Atheros OTUS 802.11n USB wireless support"
 	depends on USB && WLAN && MAC80211
+    select WIRELESS_EXT
+    select WEXT_PRIV
 	default N
 	---help---
 	  Enable support for Atheros 802.11n USB hardware:
-- 
1.6.4.4

