Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918Ab0AOOna (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 09:43:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774Ab0AOOna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 09:43:30 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:33541 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751743Ab0AOOn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 09:43:29 -0500
Date: Fri, 15 Jan 2010 15:43:48 +0100
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
To: linux-kernel@vger.kernel.org, sameo@linux.intel.com
Cc: siccegge@stud.informatik.uni-erlangen.de,
        Reinhard.Tartler@informatik.uni-erlangen.de
Subject: [PATCH] obsolete config in kernel source (TWL4030_BCI_BATTERY)
Message-ID: <20100115144347.GA3921@faui49.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all!

	As part of the VAMOS[0] research project at the University of
Erlangen we're checking referential integrity between kernel KConfig
options and in-code Conditional blocks.

	The in-code config option CONFIG_TWL4030_BCI_BATTERY seems to
originate from the omap project[1]. However some variant of that patch
was rejected from mainline inclusion (sorry no links at hand right
now) and the functionality seems to get implemented under another name
[2] so this config option is probably dead.

	Please keep me informed of this patch getting confirmed /
merged so we can keep track of it.

Regards

	Christoph Egger

[0] http://vamos1.informatik.uni-erlangen.de/
[1] http://linux.omap.com/pub/kernel/3430sdp/patches-applicable-over-linux-omap-2.6.git/twl4030_bci_battery_20080305.patch
[2] http://lwn.net/Articles/364310/

--y0ulUmNC+osPPQO6
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-remove-leftover-from-discontinued-TWL4030-battery-pa.patch"

>From 85b4ae895062f4980b35f9868589f361702cfaba Mon Sep 17 00:00:00 2001
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Date: Fri, 15 Jan 2010 15:33:46 +0100
Subject: [PATCH] remove leftover from discontinued TWL4030 battery patch

The TWL4030_BCI_BATTERY config option originates from a patch to the
omap git tree. However inclusion in linux was seemingly rejected and
the functionality nears inclusion under a different name so this
removes the bits of the old version that made it into the mainline
kernel again.

Signed-off-by: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
---
 drivers/mfd/twl-core.c  |   19 -------------------
 include/linux/i2c/twl.h |    7 +------
 2 files changed, 1 insertions(+), 25 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index aeaeac4..f5f5e17 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -58,13 +58,6 @@
 
 #define DRIVER_NAME			"twl"
 
-#if defined(CONFIG_TWL4030_BCI_BATTERY) || \
-	defined(CONFIG_TWL4030_BCI_BATTERY_MODULE)
-#define twl_has_bci()		true
-#else
-#define twl_has_bci()		false
-#endif
-
 #if defined(CONFIG_KEYBOARD_TWL4030) || defined(CONFIG_KEYBOARD_TWL4030_MODULE)
 #define twl_has_keypad()	true
 #else
@@ -587,18 +580,6 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
 	struct device	*child;
 	unsigned sub_chip_id;
 
-	if (twl_has_bci() && pdata->bci &&
-	    !(features & (TPS_SUBSET | TWL5031))) {
-		child = add_child(3, "twl4030_bci",
-				pdata->bci, sizeof(*pdata->bci),
-				false,
-				/* irq0 = CHG_PRES, irq1 = BCI */
-				pdata->irq_base + BCI_PRES_INTR_OFFSET,
-				pdata->irq_base + BCI_INTR_OFFSET);
-		if (IS_ERR(child))
-			return PTR_ERR(child);
-	}
-
 	if (twl_has_gpio() && pdata->gpio) {
 		child = add_child(SUB_CHIP_ID1, "twl4030_gpio",
 				pdata->gpio, sizeof(*pdata->gpio),
diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
index bf1c5be..32172dc 100644
--- a/include/linux/i2c/twl.h
+++ b/include/linux/i2c/twl.h
@@ -601,12 +601,7 @@ int twl4030_sih_setup(int module);
 #define TWL4030_VAUX3_DEV_GRP		0x1F
 #define TWL4030_VAUX3_DEDICATED		0x22
 
-#if defined(CONFIG_TWL4030_BCI_BATTERY) || \
-	defined(CONFIG_TWL4030_BCI_BATTERY_MODULE)
-	extern int twl4030charger_usb_en(int enable);
-#else
-	static inline int twl4030charger_usb_en(int enable) { return 0; }
-#endif
+static inline int twl4030charger_usb_en(int enable) { return 0; }
 
 /*----------------------------------------------------------------------*/
 
-- 
1.6.3.3


--y0ulUmNC+osPPQO6--
