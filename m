Return-Path: <linux-kernel-owner+w=401wt.eu-S1758016AbZCWPBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016AbZCWPBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 11:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbZCWPBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 11:01:13 -0400
Received: from mx1.emlix.com ([193.175.82.87]:37753 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173AbZCWPBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 11:01:12 -0400
From: =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org,
       =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
Subject: [patch] xtensa: implement CLK API
Date: Mon, 23 Mar 2009 16:02:13 +0100
Message-Id: <1237820533-30543-1-git-send-email-dg@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Organization: emlix gmbh, Goettingen, Germany"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement access to the peripheral clock (half of cpu clock) by means
of the generic CLK API.

Signed-off-by: Daniel Glöckner <dg@emlix.com>
---
 arch/xtensa/platforms/s6105/Makefile |    2 +-
 arch/xtensa/platforms/s6105/clocks.c |   49 ++++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+), 1 deletions(-)
 create mode 100644 arch/xtensa/platforms/s6105/clocks.c

diff --git a/arch/xtensa/platforms/s6105/Makefile b/arch/xtensa/platforms/s6105/Makefile
index 0be6194..294427b 100644
--- a/arch/xtensa/platforms/s6105/Makefile
+++ b/arch/xtensa/platforms/s6105/Makefile
@@ -1,3 +1,3 @@
 # Makefile for the Stretch S6105 eval board
 
-obj-y		:= setup.o device.o
+obj-y		:= setup.o device.o clocks.o
diff --git a/arch/xtensa/platforms/s6105/clocks.c b/arch/xtensa/platforms/s6105/clocks.c
new file mode 100644
index 0000000..fcd3bad
--- /dev/null
+++ b/arch/xtensa/platforms/s6105/clocks.c
@@ -0,0 +1,49 @@
+/*
+ * Copyright (c) 2009 emlix GmbH
+ * Author:	Daniel Gloeckner <dg@emlix.com>
+ */
+
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include <asm/param.h>
+#include <asm/timex.h>
+
+struct clk {
+	unsigned long rate;
+};
+
+static struct clk pclk;
+
+struct clk *clk_get(struct device *dev, const char *id)
+{
+	if (!strcmp(id, "PCLK")) {
+		pclk.rate = CCOUNT_PER_JIFFY * HZ / 2;
+		return &pclk;
+	}
+	return ERR_PTR(-ENODEV);
+}
+EXPORT_SYMBOL(clk_get);
+
+int clk_enable(struct clk *clk)
+{
+	return 0;
+}
+EXPORT_SYMBOL(clk_enable);
+
+void clk_disable(struct clk *clk)
+{
+}
+EXPORT_SYMBOL(clk_disable);
+
+unsigned long clk_get_rate(struct clk *clk)
+{
+	return clk->rate;
+}
+EXPORT_SYMBOL(clk_get_rate);
+
+void clk_put(struct clk *clk)
+{
+}
+EXPORT_SYMBOL(clk_put);
-- 
1.6.2.107.ge47ee

