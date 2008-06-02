Return-Path: <linux-kernel-owner+w=401wt.eu-S1758281AbYFBRiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758281AbYFBRiw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 13:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbYFBRii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 13:38:38 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:14422 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752364AbYFBRih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 13:38:37 -0400
Date: Mon, 2 Jun 2008 21:38:36 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Kumar Gala <galak@kernel.crashing.org>, Wim Van Sebroeck <wim@iguana.be>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jochen Friedrich <jochen@scram.de>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       Scott Wood <scottwood@freescale.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] [WATCHDOG] mpc83xx_wdt: fix checkpatch issues
Message-ID: <20080602173836.GA30705@polina.dev.rtsoft.ru>
References: <20080602173726.GA24556@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080602173726.GA24556@polina.dev.rtsoft.ru>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quite tired of these warnings ;-), checkpatch spitting them when
seeing the rename patch.

WARNING: Use #include <linux/io.h> instead of <asm/io.h>
#25: FILE: watchdog/mpc83xx_wdt.c:25:
+#include <asm/io.h>

WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
#26: FILE: watchdog/mpc83xx_wdt.c:26:
+#include <asm/uaccess.h>

WARNING: line over 80 characters
#45: FILE: watchdog/mpc83xx_wdt.c:45:
+MODULE_PARM_DESC(timeout, "Watchdog timeout in ticks. (0<timeout<65536, default=65535");

WARNING: line over 80 characters
#49: FILE: watchdog/mpc83xx_wdt.c:49:
+MODULE_PARM_DESC(reset, "Watchdog Interrupt/Reset Mode. 0 = interrupt, 1 = reset");

WARNING: space prohibited between function name and open parenthesis '('
#164: FILE: watchdog/mpc83xx_wdt.c:164:
+       wd_base = ioremap(r->start, sizeof (struct mpc83xx_wdt));

total: 0 errors, 5 warnings, 230 lines checked

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/watchdog/mpc83xx_wdt.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/watchdog/mpc83xx_wdt.c b/drivers/watchdog/mpc83xx_wdt.c
index b16c5cd..6905712 100644
--- a/drivers/watchdog/mpc83xx_wdt.c
+++ b/drivers/watchdog/mpc83xx_wdt.c
@@ -22,8 +22,8 @@
 #include <linux/platform_device.h>
 #include <linux/module.h>
 #include <linux/watchdog.h>
-#include <asm/io.h>
-#include <asm/uaccess.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
 struct mpc83xx_wdt {
 	__be32 res0;
@@ -42,11 +42,13 @@ static struct mpc83xx_wdt __iomem *wd_base;
 
 static u16 timeout = 0xffff;
 module_param(timeout, ushort, 0);
-MODULE_PARM_DESC(timeout, "Watchdog timeout in ticks. (0<timeout<65536, default=65535");
+MODULE_PARM_DESC(timeout, "Watchdog timeout in ticks. "
+		 "(0<timeout<65536, default=65535");
 
 static int reset = 1;
 module_param(reset, bool, 0);
-MODULE_PARM_DESC(reset, "Watchdog Interrupt/Reset Mode. 0 = interrupt, 1 = reset");
+MODULE_PARM_DESC(reset, "Watchdog Interrupt/Reset Mode. "
+		 "0 = interrupt, 1 = reset");
 
 /*
  * We always prescale, but if someone really doesn't want to they can set this
@@ -161,7 +163,7 @@ static int __devinit mpc83xx_wdt_probe(struct platform_device *dev)
 		goto err_out;
 	}
 
-	wd_base = ioremap(r->start, sizeof (struct mpc83xx_wdt));
+	wd_base = ioremap(r->start, sizeof(struct mpc83xx_wdt));
 
 	if (wd_base == NULL) {
 		ret = -ENOMEM;
-- 
1.5.5.1

