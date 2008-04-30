Return-Path: <linux-kernel-owner+w=401wt.eu-S932830AbYD3UOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932830AbYD3UOY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 16:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759793AbYD3UOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 16:14:15 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:44578 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756738AbYD3UOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 16:14:14 -0400
Date: Wed, 30 Apr 2008 22:14:08 +0200
From: Sebastian Siewior <bigeasy@linutronix.de>
To: Greg Ungerer <gerg@uclinux.org>
Cc: uclinux-dev@uclinux.org, Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] m68knommu: Add info about removing mcfserial
Message-ID: <20080430201408.GA22731@Chamillionaire.breakpoint.cc>
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

Schedule a removal for this driver. Alternative driver is
available for a while now.

Signed-off-by: Sebastian Siewior <bigeasy@linutronix.de>
---
Greg said [1] and I hope .28 is not too late.
[1] http://www.mail-archive.com/uclinux-dev@uclinux.org/msg04453.html

 Documentation/feature-removal-schedule.txt |    8 ++++++++
 drivers/serial/Kconfig                     |    6 +++++-
 drivers/serial/mcfserial.c                 |    1 +
 3 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 3c35d45..27c0056 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -304,3 +304,11 @@ When:	2.6.26
 Why:	Implementation became generic; users should now include
 	linux/semaphore.h instead.
 Who:	Matthew Wilcox <willy@linux.intel.com>
+
+---------------------------
+
+What:	old style serial driver for ColdFire (CONFIG_SERIAL_COLDFIRE)
+When:	2.6.28
+Why:	This driver still uses the old interface and has been replaced
+	by CONFIG_SERIAL_MCF.
+Who:	Sebastian Siewior <sebastian@breakpoint.cc>
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
1.5.4.3

