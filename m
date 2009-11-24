Return-Path: <linux-kernel-owner+w=401wt.eu-S932803AbZKXLQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803AbZKXLQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 06:16:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932307AbZKXLQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 06:16:40 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44033 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932077AbZKXLQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 06:16:39 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Remove build time warning for WM835x register default tables
Date: Tue, 24 Nov 2009 11:16:45 +0000
Message-Id: <1259061405-24442-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Systems using the WM835x need to choose which of the default register
settings are required on the system.  Currently there is a compile time
warning as well as a runtime error intended to flag up to users that
this is required but this also triggers for people building the driver
in order to obtain build coverage.

Remove the build warning, leaving only the runtime error, in order to
reduce noise for people doing generic kernel work.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8350-regmap.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/mfd/wm8350-regmap.c b/drivers/mfd/wm8350-regmap.c
index 7ccc1ea..e965139 100644
--- a/drivers/mfd/wm8350-regmap.c
+++ b/drivers/mfd/wm8350-regmap.c
@@ -3170,14 +3170,6 @@ const u16 wm8352_mode3_defaults[] = {
 };
 #endif
 
-/* The register defaults for the config mode used must be compiled in but
- * due to the impact on kernel size it is possible to disable
- */
-#ifndef WM8350_HAVE_CONFIG_MODE
-#warning No WM8350 config modes supported - select at least one of the
-#warning MFD_WM8350_CONFIG_MODE_n options from the board driver.
-#endif
-
 /*
  * Access masks.
  */
-- 
1.6.3.3

