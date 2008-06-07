Return-Path: <linux-kernel-owner+w=401wt.eu-S1762506AbYFGQrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762506AbYFGQrS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 12:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759565AbYFGQrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 12:47:07 -0400
Received: from liberdade.minaslivre.org ([72.232.18.203]:44966 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757267AbYFGQrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 12:47:06 -0400
X-Greylist: delayed 1459 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Jun 2008 12:47:06 EDT
Date: Sat, 7 Jun 2008 13:22:39 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@minaslivre.org>
To: linux-kernel@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>
Subject: [PATCH] Correct type and description of
	CONFIG_AC97_POWER_SAVE_DEFAULT
Message-ID: <20080607162238.GA7893@vespa.holoscopio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While CONFIG_HDA_POWER_SAVE_DEFAULT is used as a timeout in seconds,
CONFIG_AC97_POWER_SAVE_DEFAULT simply enables or disables AC97 power
saving.
---
 sound/pci/Kconfig           |    6 +++---
 sound/pci/ac97/ac97_codec.c |    6 +++++-
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/sound/pci/Kconfig b/sound/pci/Kconfig
index 7e47421..fe6aad2 100644
--- a/sound/pci/Kconfig
+++ b/sound/pci/Kconfig
@@ -968,11 +968,11 @@ config SND_AC97_POWER_SAVE
 	  sysfs, too.
 
 config SND_AC97_POWER_SAVE_DEFAULT
-	int "Default time-out for AC97 power-save mode"
+	bool "Activate AC97 power-save mode by default"
 	depends on SND_AC97_POWER_SAVE
 	default 0
 	help
-	  The default time-out value in seconds for AC97 automatic
-	  power-save mode.  0 means to disable the power-save mode.
+    By default, AC97 power-save mode is not active. This option
+    activates it by default.
 
 endmenu
diff --git a/sound/pci/ac97/ac97_codec.c b/sound/pci/ac97/ac97_codec.c
index 45fd290..0566e3a 100644
--- a/sound/pci/ac97/ac97_codec.c
+++ b/sound/pci/ac97/ac97_codec.c
@@ -48,7 +48,11 @@ module_param(enable_loopback, bool, 0444);
 MODULE_PARM_DESC(enable_loopback, "Enable AC97 ADC/DAC Loopback Control");
 
 #ifdef CONFIG_SND_AC97_POWER_SAVE
-static int power_save = CONFIG_SND_AC97_POWER_SAVE_DEFAULT;
+#ifdef CONFIG_SND_AC97_POWER_SAVE_DEFAULT
+static int power_save = 1;
+#else
+static int power_save = 0;
+#endif
 module_param(power_save, bool, 0644);
 MODULE_PARM_DESC(power_save, "Enable AC97 power-saving control");
 #endif
-- 
1.5.5.3
