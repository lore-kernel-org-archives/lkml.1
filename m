Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322Ab0AEUlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab0AEUlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 15:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932094Ab0AEUlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 15:41:15 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51705 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932084Ab0AEUlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 15:41:14 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 5/4] mfd: Don't allow WM8350 to be built modular
Date: Tue,  5 Jan 2010 20:40:47 +0000
Message-Id: <1262724047-4042-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.5.7
In-Reply-To: <1262699949-3079-4-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1262699949-3079-4-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The genirq implementation does not allow modules to implement irq_chips
so the conversion of WM8350 to genirq means we can no longer allow the
driver to be built as a module.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

Sorry, I thought I'd sent a patch for this earlier but I appear to be
imagining things.

 drivers/mfd/Kconfig |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 8782978..1414cec 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -205,7 +205,7 @@ config MFD_WM831X
 	  functionality of the device.
 
 config MFD_WM8350
-	tristate
+	bool
 
 config MFD_WM8350_CONFIG_MODE_0
 	bool
@@ -256,9 +256,9 @@ config MFD_WM8352_CONFIG_MODE_3
 	depends on MFD_WM8350
 
 config MFD_WM8350_I2C
-	tristate "Support Wolfson Microelectronics WM8350 with I2C"
+	bool "Support Wolfson Microelectronics WM8350 with I2C"
 	select MFD_WM8350
-	depends on I2C
+	depends on I2C=y
 	help
 	  The WM8350 is an integrated audio and power management
 	  subsystem with watchdog and RTC functionality for embedded
-- 
1.6.5.7

