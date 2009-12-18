Return-Path: <linux-kernel-owner+w=401wt.eu-S1752725AbZLRJ27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbZLRJ27 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 04:28:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbZLRJ26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 04:28:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857AbZLRJ24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 04:28:56 -0500
Date: Fri, 18 Dec 2009 04:28:27 -0500
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Corentin Chary <corentincj@iksaif.net>,
       ibm-acpi-devel@lists.sourceforge.net, Len Brown <len.brown@intel.com>,
       Amerigo Wang <amwang@redhat.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>, akpm@linux-foundation.org,
       helight.xu@gmail.com
Message-Id: <20091218093132.4415.23424.sendpatchset@localhost.localdomain>
Subject: [Patch] thinkpad_acpi: fix a build error
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixes the following build error:

 Building modules, stage 2.
 MODPOST 1834 modules
ERROR: "snd_card_create" [drivers/platform/x86/thinkpad_acpi.ko] undefined!
ERROR: "snd_ctl_notify" [drivers/platform/x86/thinkpad_acpi.ko] undefined!
ERROR: "snd_ctl_boolean_mono_info" [drivers/platform/x86/thinkpad_acpi.ko] undefined!
ERROR: "snd_ctl_new1" [drivers/platform/x86/thinkpad_acpi.ko] undefined!
ERROR: "snd_card_free" [drivers/platform/x86/thinkpad_acpi.ko] undefined!
ERROR: "snd_card_register" [drivers/platform/x86/thinkpad_acpi.ko] undefined!
ERROR: "snd_ctl_add" [drivers/platform/x86/thinkpad_acpi.ko] undefined!

Cc: Len Brown <len.brown@intel.com>
Cc: Corentin Chary <corentincj@iksaif.net>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Reported-by: Helight.Xu <helight.xu@gmail.com>
Signed-off-by: WANG Cong <amwang@redhat.com>
Tested-by: Helight.Xu <helight.xu@gmail.com>

---
diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index fc5bf9d..596966c 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -215,6 +215,7 @@ config THINKPAD_ACPI
 	depends on ACPI
 	depends on INPUT
 	depends on RFKILL || RFKILL = n
+	depends on SOUND
 	select BACKLIGHT_LCD_SUPPORT
 	select BACKLIGHT_CLASS_DEVICE
 	select HWMON
