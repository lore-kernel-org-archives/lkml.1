Return-Path: <linux-kernel-owner+w=401wt.eu-S1758780AbYDBQdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780AbYDBQdh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 12:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756624AbYDBQd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 12:33:28 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:2850 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755604AbYDBQd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 12:33:27 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       Miles Lane <miles.lane@gmail.com>, reinette.chatre@intel.com
Subject: [PATCH] iwlwifi/Kconfg: make IWLWIFI_LEDS invisible
Date: Wed,  2 Apr 2008 12:10:04 -0400
Message-Id: <1207152604-22973-1-git-send-email-linville@tuxdriver.com>
X-Mailer: git-send-email 1.5.3.3
In-Reply-To: <a44ae5cd0804020404k295ffc7ew8761cc0901996e20@mail.gmail.com>
References: <a44ae5cd0804020404k295ffc7ew8761cc0901996e20@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Select IWLWIFI_LEDS automatically when either IWL3945_LEDS or
IWL4965_LEDS is selected.  This avoids potential misconfigurations
which lead to build failures for iwl-led.c.

Cc: Miles Lane <miles.lane@gmail.com>
Cc: reinette.chatre@intel.com
Signed-off-by: John w. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/iwlwifi/Kconfig |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 4a5c8c0..8137690 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -3,11 +3,8 @@ config IWLCORE
 	depends on PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
 
 config IWLWIFI_LEDS
-	bool "Enable LEDS features in iwlwifi driver"
-	depends on IWLCORE && MAC80211_LEDS && LEDS_CLASS
-	---help---
-	  This option enables LEDS for the iwlwifi drivers
-
+	bool
+	default n
 
 config IWLCORE_RFKILL
 	boolean "IWLWIFI RF kill support"
@@ -52,7 +49,8 @@ config IWL4965_HT
 
 config IWL4965_LEDS
 	bool "Enable LEDS features in iwl4965 driver"
-	depends on IWL4965 && IWLWIFI_LEDS
+	depends on IWL4965 && MAC80211_LEDS && LEDS_CLASS
+	select IWLWIFI_LEDS
 	---help---
 	  This option enables LEDS for the iwlwifi drivers
 
@@ -137,6 +135,7 @@ config IWL3945_SPECTRUM_MEASUREMENT
 config IWL3945_LEDS
 	bool "Enable LEDS features in iwl3945 driver"
 	depends on IWL3945 && MAC80211_LEDS && LEDS_CLASS
+	select IWLWIFI_LEDS
 	---help---
 	  This option enables LEDS for the iwl3945 driver.
 
-- 
1.5.3.3

