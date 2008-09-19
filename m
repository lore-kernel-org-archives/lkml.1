Return-Path: <linux-kernel-owner+w=401wt.eu-S1753489AbYISKih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbYISKih (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 06:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751026AbYISKiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 06:38:23 -0400
Received: from smtp.nokia.com ([192.100.105.134]:42427 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbYISKiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 06:38:21 -0400
From: Felipe Balbi <felipe.balbi@nokia.com>
To: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Wim Van Sebroeck <wim@iguana.be>,
       Andrew Morton <akpm@linux-foundation.org>,
       "George G. Davis" <gdavis@mvista.com>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: [PATCH 4/5] watchdog: move omap_wdt.h to include/linux/watchdog
Date: Fri, 19 Sep 2008 13:32:38 +0300
Message-Id: <1221820359-8943-5-git-send-email-felipe.balbi@nokia.com>
X-Mailer: git-send-email 1.6.0.1.308.gede4c
In-Reply-To: <1221820359-8943-4-git-send-email-felipe.balbi@nokia.com>
References: <1221820359-8943-1-git-send-email-felipe.balbi@nokia.com>
 <1221820359-8943-2-git-send-email-felipe.balbi@nokia.com>
 <1221820359-8943-3-git-send-email-felipe.balbi@nokia.com>
 <1221820359-8943-4-git-send-email-felipe.balbi@nokia.com>
X-OriginalArrivalTime: 19 Sep 2008 10:32:44.0717 (UTC) FILETIME=[0D6D55D0:01C91A43]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a new include/linux/watchdog directory
for holding watchdog chips headers, move omap_wdt.h
to the new location and update the include path in
the driver source.

Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
---
 drivers/watchdog/omap_wdt.c       |    3 +-
 drivers/watchdog/omap_wdt.h       |   54 -------------------------------------
 include/linux/watchdog/omap_wdt.h |   54 +++++++++++++++++++++++++++++++++++++
 3 files changed, 55 insertions(+), 56 deletions(-)
 delete mode 100644 drivers/watchdog/omap_wdt.h
 create mode 100644 include/linux/watchdog/omap_wdt.h

diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index b670ad5..8b68bc0 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -33,6 +33,7 @@
 #include <linux/mm.h>
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
+#include <linux/watchdog/omap_wdt.h>
 #include <linux/reboot.h>
 #include <linux/init.h>
 #include <linux/err.h>
@@ -46,8 +47,6 @@
 #include <mach/hardware.h>
 #include <mach/prcm.h>
 
-#include "omap_wdt.h"
-
 static struct platform_device *omap_wdt_dev;
 
 static unsigned timer_margin;
diff --git a/drivers/watchdog/omap_wdt.h b/drivers/watchdog/omap_wdt.h
deleted file mode 100644
index fc02ec6..0000000
--- a/drivers/watchdog/omap_wdt.h
+++ /dev/null
@@ -1,54 +0,0 @@
-/*
- *  linux/drivers/char/watchdog/omap_wdt.h
- *
- *  BRIEF MODULE DESCRIPTION
- *      OMAP Watchdog timer register definitions
- *
- *  Copyright (C) 2004 Texas Instruments.
- *
- *  This program is free software; you can redistribute  it and/or modify it
- *  under  the terms of  the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the  License, or (at your
- *  option) any later version.
- *
- *  THIS  SOFTWARE  IS PROVIDED   ``AS  IS'' AND   ANY  EXPRESS OR IMPLIED
- *  WARRANTIES,   INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF
- *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN
- *  NO  EVENT  SHALL   THE AUTHOR  BE    LIABLE FOR ANY   DIRECT, INDIRECT,
- *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
- *  NOT LIMITED   TO, PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES; LOSS OF
- *  USE, DATA,  OR PROFITS; OR  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
- *  ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT
- *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
- *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- *  You should have received a copy of the  GNU General Public License along
- *  with this program; if not, write  to the Free Software Foundation, Inc.,
- *  675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-#ifndef _OMAP_WATCHDOG_H
-#define _OMAP_WATCHDOG_H
-
-#define OMAP_WATCHDOG_REV		(0x00)
-#define OMAP_WATCHDOG_SYS_CONFIG	(0x10)
-#define OMAP_WATCHDOG_STATUS		(0x14)
-#define OMAP_WATCHDOG_CNTRL		(0x24)
-#define OMAP_WATCHDOG_CRR		(0x28)
-#define OMAP_WATCHDOG_LDR		(0x2c)
-#define OMAP_WATCHDOG_TGR		(0x30)
-#define OMAP_WATCHDOG_WPS		(0x34)
-#define OMAP_WATCHDOG_SPR		(0x48)
-
-/* Using the prescaler, the OMAP watchdog could go for many
- * months before firing.  These limits work without scaling,
- * with the 60 second default assumed by most tools and docs.
- */
-#define TIMER_MARGIN_MAX    	(24 * 60 * 60)	/* 1 day */
-#define TIMER_MARGIN_DEFAULT	60	/* 60 secs */
-#define TIMER_MARGIN_MIN	1
-
-#define PTV			0	/* prescale */
-#define GET_WLDR_VAL(secs)	(0xffffffff - ((secs) * (32768/(1<<PTV))) + 1)
-
-#endif				/* _OMAP_WATCHDOG_H */
diff --git a/include/linux/watchdog/omap_wdt.h b/include/linux/watchdog/omap_wdt.h
new file mode 100644
index 0000000..62e6a74
--- /dev/null
+++ b/include/linux/watchdog/omap_wdt.h
@@ -0,0 +1,54 @@
+/*
+ *  include/linux/watchdog/omap_wdt.h
+ *
+ *  BRIEF MODULE DESCRIPTION
+ *      OMAP Watchdog timer register definitions
+ *
+ *  Copyright (C) 2004 Texas Instruments.
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ *  THIS  SOFTWARE  IS PROVIDED   ``AS  IS'' AND   ANY  EXPRESS OR IMPLIED
+ *  WARRANTIES,   INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF
+ *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN
+ *  NO  EVENT  SHALL   THE AUTHOR  BE    LIABLE FOR ANY   DIRECT, INDIRECT,
+ *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
+ *  NOT LIMITED   TO, PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES; LOSS OF
+ *  USE, DATA,  OR PROFITS; OR  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
+ *  ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT
+ *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
+ *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *  You should have received a copy of the  GNU General Public License along
+ *  with this program; if not, write  to the Free Software Foundation, Inc.,
+ *  675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef _OMAP_WATCHDOG_H
+#define _OMAP_WATCHDOG_H
+
+#define OMAP_WATCHDOG_REV		(0x00)
+#define OMAP_WATCHDOG_SYS_CONFIG	(0x10)
+#define OMAP_WATCHDOG_STATUS		(0x14)
+#define OMAP_WATCHDOG_CNTRL		(0x24)
+#define OMAP_WATCHDOG_CRR		(0x28)
+#define OMAP_WATCHDOG_LDR		(0x2c)
+#define OMAP_WATCHDOG_TGR		(0x30)
+#define OMAP_WATCHDOG_WPS		(0x34)
+#define OMAP_WATCHDOG_SPR		(0x48)
+
+/* Using the prescaler, the OMAP watchdog could go for many
+ * months before firing.  These limits work without scaling,
+ * with the 60 second default assumed by most tools and docs.
+ */
+#define TIMER_MARGIN_MAX	(24 * 60 * 60)	/* 1 day */
+#define TIMER_MARGIN_DEFAULT	60	/* 60 secs */
+#define TIMER_MARGIN_MIN	1
+
+#define PTV			0	/* prescale */
+#define GET_WLDR_VAL(secs)	(0xffffffff - ((secs) * (32768/(1<<PTV))) + 1)
+
+#endif				/* _OMAP_WATCHDOG_H */
-- 
1.6.0.1.308.gede4c

