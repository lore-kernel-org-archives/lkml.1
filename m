Return-Path: <linux-kernel-owner+w=401wt.eu-S1751712Ab0ARNYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712Ab0ARNYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 08:24:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751356Ab0ARNYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 08:24:15 -0500
Received: from alternativer.internetendpunkt.de ([88.198.24.89]:52439 "EHLO
	geheimer.internetendpunkt.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751323Ab0ARNYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 08:24:14 -0500
X-Greylist: delayed 536 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Jan 2010 08:24:14 EST
From: Hagen Paul Pfeifer <hagen@jauu.net>
To: linux-kernel@vger.kernel.org
Cc: hmh@hmh.eng.br
Subject: [PATCH 1/1] thinkpad-acpi: fix link error to include sound arch
Date: Mon, 18 Jan 2010 14:15:16 +0100
Message-Id: <1263820516-6924-1-git-send-email-hagen@jauu.net>
X-Mailer: git-send-email 1.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thinkpad ACPI depends on sound for resume/suspend/shutdown
events. This fix corrects the Kconfig dependency between
in-kernel build and module build. The preprocessor
directive #ifdef CONFIG_THINKPAD_ACPI_ALSA_SUPPORT
isn't sufficient to handle this build dependency.

Signed-off-by: Hagen Paul Pfeifer <hagen@jauu.net>
---
 drivers/platform/x86/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index db32c25..a4a31b5 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -214,6 +214,7 @@ config THINKPAD_ACPI
 	tristate "ThinkPad ACPI Laptop Extras"
 	depends on ACPI
 	depends on INPUT
+	depends on SND
 	depends on RFKILL || RFKILL = n
 	select BACKLIGHT_LCD_SUPPORT
 	select BACKLIGHT_CLASS_DEVICE
-- 
1.6.5

