Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327Ab0AMN7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab0AMN7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 08:59:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754847Ab0AMN7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 08:59:39 -0500
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:36777 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753519Ab0AMN7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 08:59:38 -0500
Date: Wed, 13 Jan 2010 14:59:37 +0100
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
To: linux-kernel@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>,
       Stefano Brivio <stefano.brivio@polimi.it>,
       linux-wireless@vger.kernel.org
Cc: siccegge@stud.informatik.uni-erlangen.de,
       Reinhard.Tartler@informatik.uni-erlangen.de
Subject: [PATCH] obsolete in kernel source (B43_LEGACY_RFKILL)
Message-ID: <20100113135937.GA5588@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="4SFOXa2GPu3tIq4H"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4SFOXa2GPu3tIq4H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all!

	As part of the VAMOS[0] research project at the University of
Erlangen we're checking referential integrity between kernel KConfig
options and in-code Conditional blocks.

	While the config option B43_LEGACY_RFKILL was dropped when the
driver's rfkill facility was ported to cfg80211 in [2] it is still
referenced for debug output in [1] probably we just want to get rid of
it.

	Please keep me informed of this patch getting confirmed /
merged so we can keep track of it.

Regards

	Christoph Egger

[0] http://vamos1.informatik.uni-erlangen.de/
[1] ./drivers/net/wireless/b43legacy/main.c
[2] f41f3f373dd72344c65d801d6381fe83ef3a2c54

--4SFOXa2GPu3tIq4H
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-Remove-config-option-B43_LEGACY_RFKILL-completely.patch"

>From 9e0756f23bdfcb7f34c8d6f896a5a32cd2abc06e Mon Sep 17 00:00:00 2001
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Date: Wed, 13 Jan 2010 14:36:24 +0100
Subject: [PATCH] Remove config option B43_LEGACY_RFKILL completely

In f41f3f373dd72344c65d801d6381fe83ef3a2c54 the B43 driver was ported
to use the cfg80211 API for rfkill and consequently the config option
was dropped (RFKILL is now unconditionally enabled).

However in the Kernel Info the feature is still checked and reported
missing. This patch just removes the conditional and the relevant code
blocks while still reporting that feature unconditionally would be
another option (it's always there).

Signed-off-by: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
---
 drivers/net/wireless/b43legacy/main.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
index 4a905b6..9a0f819 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -3960,7 +3960,7 @@ static struct ssb_driver b43legacy_ssb_driver = {
 
 static void b43legacy_print_driverinfo(void)
 {
-	const char *feat_pci = "", *feat_leds = "", *feat_rfkill = "",
+	const char *feat_pci = "", *feat_leds = "",
 		   *feat_pio = "", *feat_dma = "";
 
 #ifdef CONFIG_B43LEGACY_PCI_AUTOSELECT
@@ -3969,9 +3969,6 @@ static void b43legacy_print_driverinfo(void)
 #ifdef CONFIG_B43LEGACY_LEDS
 	feat_leds = "L";
 #endif
-#ifdef CONFIG_B43LEGACY_RFKILL
-	feat_rfkill = "R";
-#endif
 #ifdef CONFIG_B43LEGACY_PIO
 	feat_pio = "I";
 #endif
@@ -3979,9 +3976,9 @@ static void b43legacy_print_driverinfo(void)
 	feat_dma = "D";
 #endif
 	printk(KERN_INFO "Broadcom 43xx-legacy driver loaded "
-	       "[ Features: %s%s%s%s%s, Firmware-ID: "
+	       "[ Features: %s%s%s%s, Firmware-ID: "
 	       B43legacy_SUPPORTED_FIRMWARE_ID " ]\n",
-	       feat_pci, feat_leds, feat_rfkill, feat_pio, feat_dma);
+	       feat_pci, feat_leds, feat_pio, feat_dma);
 }
 
 static int __init b43legacy_init(void)
-- 
1.6.3.3


--4SFOXa2GPu3tIq4H--
