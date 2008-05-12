Return-Path: <linux-kernel-owner+w=401wt.eu-S1758646AbYELVUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646AbYELVUj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 17:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756348AbYELVUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 17:20:30 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:45885 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752510AbYELVU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 17:20:28 -0400
Date: Mon, 12 May 2008 23:20:23 +0200
From: Sebastian Siewior <lkml@ml.breakpoint.cc>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Ungerer <gerg@uclinux.org>, uclinux-dev@uclinux.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH resend] m68knommu: Add info about removing mcfserial
Message-ID: <20080512212023.GB27705@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Siewior <bigeasy@linutronix.de>

Schedule a removal for this driver. Alternative driver is available for
a while now.

Signed-off-by: Sebastian Siewior <bigeasy@linutronix.de>
---
Greg is fine with this http://lkml.org/lkml/2008/4/30/561

 Documentation/feature-removal-schedule.txt |    8 ++++++++
 drivers/serial/Kconfig                     |    6 +++++-
 drivers/serial/mcfserial.c                 |    1 +
 3 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 3c35d45..5b3f31f 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -289,6 +289,14 @@ Who:	Glauber Costa <gcosta@redhat.com>
 
 ---------------------------
 
+What:	old style serial driver for ColdFire (CONFIG_SERIAL_COLDFIRE)
+When:	2.6.28
+Why:	This driver still uses the old interface and has been replaced
+	by CONFIG_SERIAL_MCF.
+Who:	Sebastian Siewior <sebastian@breakpoint.cc>
+
+---------------------------
+
 What:	/sys/o2cb symlink
 When:	January 2010
 Why:	/sys/fs/o2cb is the proper location for this information - /sys/o2cb
diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index 36acbcc..62e6eb1 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -976,11 +976,15 @@ config SERIAL_68328_RTS_CTS
 	depends on SERIAL_68328
 
 config SERIAL_COLDFIRE
-	bool "ColdFire serial support"
+	bool "ColdFire serial support (DEPRECATED)"
 	depends on COLDFIRE
 	help
 	  This driver supports the built-in serial ports of the Motorola ColdFire
 	  family of CPUs.
+	  This driver is deprecated because it supports only the old interface
+	  for serial drivers and features like magic keys are not working.
+	  Please switch to the new style driver because this driver will be
+	  removed soon.
 
 config SERIAL_MCF
 	bool "Coldfire serial support (new style driver)"
diff --git a/drivers/serial/mcfserial.c b/drivers/serial/mcfserial.c
index 43af40d..56007cc 100644
--- a/drivers/serial/mcfserial.c
+++ b/drivers/serial/mcfserial.c
@@ -1,3 +1,4 @@
+#warning This driver is deprecated. Check Kconfig for details.
 /*
  * mcfserial.c -- serial driver for ColdFire internal UARTS.
  *
-- 
1.5.5.1

