Return-Path: <linux-kernel-owner+w=401wt.eu-S1755883AbZA3Sml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbZA3Sml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 13:42:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbZA3Smc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 13:42:32 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1865 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbZA3Smc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 13:42:32 -0500
From: Mark Brown <broonie@sirena.org.uk>
To: David Brownell <dbrownell@users.sourceforge.net>,
       Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org, Mark Brown <broonie@sirena.org.uk>
Date: Fri, 30 Jan 2009 18:42:17 +0000
Message-Id: <1233340937-7679-1-git-send-email-broonie@sirena.org.uk>
X-Mailer: git-send-email 1.5.6.3
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] mfd: Fix TWL4030 build on some ARM variants
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many ARM platforms do not provide a mach/cpu.h so rather than guarding
the use of that header with CONFIG_ARM guard it with the guards used
when testing for the OMAP variants in the body of the code.

Signed-off-by: Mark Brown <broonie@sirena.org.uk>
---
 drivers/mfd/twl4030-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/twl4030-core.c b/drivers/mfd/twl4030-core.c
index e7ab003..68826f1 100644
--- a/drivers/mfd/twl4030-core.c
+++ b/drivers/mfd/twl4030-core.c
@@ -38,7 +38,7 @@
 #include <linux/i2c.h>
 #include <linux/i2c/twl4030.h>
 
-#ifdef CONFIG_ARM
+#if defined(CONFIG_ARCH_OMAP2) || defined(CONFIG_ARCH_OMAP3)
 #include <mach/cpu.h>
 #endif
 
-- 
1.5.6.3

