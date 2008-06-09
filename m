Return-Path: <linux-kernel-owner+w=401wt.eu-S1755650AbYFIWXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650AbYFIWXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 18:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759975AbYFIWXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 18:23:03 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:53867 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759961AbYFIWXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 18:23:01 -0400
Date: Tue, 10 Jun 2008 01:22:07 +0300
From: Adrian Bunk <bunk@kernel.org>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] export ide_doubler
Message-ID: <20080609222207.GC1987@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following build error:

<--  snip  -->

...
  Building modules, stage 2.
  MODPOST 1204 modules
ERROR: "ide_doubler" [drivers/ide/ide-core.ko] undefined!
...
make[2]: *** [__modpost] Error 1

<--  snip  -->

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/ide/legacy/gayle.c |    4 ++++
 1 file changed, 4 insertions(+)

01de9d4a09e34cdaa5f6f7f39c2733bb7fd7147d diff --git a/drivers/ide/legacy/gayle.c b/drivers/ide/legacy/gayle.c
index a9c2593..557f8ea 100644
--- a/drivers/ide/legacy/gayle.c
+++ b/drivers/ide/legacy/gayle.c
@@ -16,6 +16,7 @@
 #include <linux/ide.h>
 #include <linux/init.h>
 #include <linux/zorro.h>
+#include <linux/module.h>
 
 #include <asm/setup.h>
 #include <asm/amigahw.h>
@@ -62,7 +63,10 @@
 					       GAYLE_NUM_HWIFS-1)
 #define GAYLE_HAS_CONTROL_REG	(!ide_doubler)
 #define GAYLE_IDEREG_SIZE	(ide_doubler ? 0x1000 : 0x2000)
+
 int ide_doubler = 0;	/* support IDE doublers? */
+EXPORT_SYMBOL_GPL(ide_doubler);
+
 module_param_named(doubler, ide_doubler, bool, 0);
 MODULE_PARM_DESC(doubler, "enable support for IDE doublers");
 #endif /* CONFIG_BLK_DEV_IDEDOUBLER */

