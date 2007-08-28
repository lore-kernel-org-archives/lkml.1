Return-Path: <linux-kernel-owner+w=401wt.eu-S1757820AbXH1QBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757820AbXH1QBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 12:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757569AbXH1QBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 12:01:32 -0400
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:47754 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757183AbXH1QBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 12:01:30 -0400
Message-id: <280951420471148977@pripojeni.net>
In-reply-to: <2713029743177393055@pripojeni.net>
Subject: [PATCH 5/5] Net: ath5k, kconfig changes
From: Jiri Slaby <jirislaby@gmail.com>
To: <linville@tuxdriver.com>
Cc: <linux-kernel@vger.kernel.org>
Cc: <linux-wireless@vger.kernel.org>
Cc: <netdev@vger.kernel.org>
Date: Tue, 28 Aug 2007 12:01:30 -0400
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ath5k, kconfig changes

- build 5120, 5111 and 5112 optionally
- alter Kconfig text

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 0902114e92b19bc080780f21f98807688244fc8f
tree d7b4a039e4d14ae73faf1b33907c38825d198461
parent 330c2ab9a53ddce27003218bd546034e8eeeff17
author Jiri Slaby <jirislaby@gmail.com> Tue, 28 Aug 2007 17:39:44 +0200
committer Jiri Slaby <jirislaby@gmail.com> Tue, 28 Aug 2007 17:39:44 +0200

 drivers/net/wireless/Kconfig            |   30 +++++++++++++++++++--------
 drivers/net/wireless/ath5k_hw_inivals.c |   35 ++++++++++++++++++++++++++++---
 drivers/net/wireless/ath5k_hw_phy.c     |   24 +++++++++++++++++++++
 3 files changed, 77 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 00b4fcd..a4608f9 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -856,18 +856,30 @@ config IWL3945
 	  will be called iwl3945.ko.
 
 config ATH5K
-	tristate "Atheros 5xxx wireless cards support"
-	depends on MAC80211
-	depends on PCI
-	default m
+	tristate "Atheros 5xxx PCI/Cardbus wireless cards"
+	depends on PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
 	---help---
-	  This module adds support for atheros 5xxx (e.g. 5212) wireless
-	  cards. If you have this card in your PC, select this to be build.
+	  Say Y here if you intend to attach an Atheros 5xxx 
+	  series Cardbus or PCI wireless Ethernet networking card to 
+	  your computer. This driver uses mac80211 stack.
 
-	  This driver uses the kernel's mac80211 subsystem.
+	  To compile this driver as a module, choose M here: the module will be
+	  called ath5k.  If unsure, say M.
 
-	  If you choose to build a module, it'll be called ath5k. Say M if
-	  unsure.
+config ATH5K_AR5210
+	bool "Support AR5210"
+	depends on ATH5K
+	default y
+
+config ATH5K_AR5211
+	bool "Support AR5211"
+	depends on ATH5K
+	default y
+
+config ATH5K_AR5212
+	bool "Support AR5212"
+	depends on ATH5K
+	default y
 
 source "drivers/net/wireless/hostap/Kconfig"
 source "drivers/net/wireless/bcm43xx/Kconfig"
diff --git a/drivers/net/wireless/ath5k_hw_inivals.c b/drivers/net/wireless/ath5k_hw_inivals.c
index 062e03d..0531ad3 100644
--- a/drivers/net/wireless/ath5k_hw_inivals.c
+++ b/drivers/net/wireless/ath5k_hw_inivals.c
@@ -38,6 +38,7 @@ struct ath5k_ini_mode {
 	u32	mode_value[5];
 };
 
+#ifdef CONFIG_ATH5K_AR5210
 /* Initial register settings for AR5210 */
 static const struct ath5k_ini ar5210_ini[] = {
 	/* PCU and MAC registers */
@@ -249,7 +250,9 @@ static const struct ath5k_ini ar5210_ini[] = {
 	{ AR5K_PHY(52), 0x00000014 },
 	{ AR5K_PHY_ACT, AR5K_PHY_ACT_ENABLE },
 };
+#endif
 
+#ifdef CONFIG_ATH5K_AR5211
 /* Initial register settings for AR5211 */
 static const struct ath5k_ini ar5211_ini[] = {
 	{ AR5K_RXDP,		0x00000000 },
@@ -448,7 +451,9 @@ static const struct ath5k_ini_mode ar5211_ini_mode[] = {
 	{ AR5K_RF_BUFFER_CONTROL_4,
 		{ 0x00000010, 0x00000014, 0x00000010, 0x00000010, 0x00000010 } },
 };
+#endif
 
+#ifdef CONFIG_ATH5K_AR5212
 /* Initial register settings for AR5212 */
 static const struct ath5k_ini ar5212_ini[] = {
 	{ AR5K_RXDP,		0x00000000 },
@@ -842,12 +847,14 @@ static const struct ath5k_ini_mode ar5212_rf5112_ini_mode[] = {
 	{ AR5K_PHY_GAIN_2GHZ,
 		{ 0x642c0140, 0x642c0140, 0x6442c160, 0x6442c160, 0x6442c160 } },
 };
+#endif
 
 /*
  * Initial BaseBand Gain settings for RF5111/5112 (only AR5210 comes with
  * RF5110 so initial BB Gain settings are included in AR5K_AR5210_INI)
  */
 
+#if defined(CONFIG_ATH5K_AR5211) || defined (CONFIG_ATH5K_AR5212)
 /* RF5111 Initial BaseBand Gain settings */
 static const struct ath5k_ini rf5111_ini_bbgain[] = {
 	{ AR5K_BB_GAIN(0), 0x00000000 },
@@ -915,7 +922,9 @@ static const struct ath5k_ini rf5111_ini_bbgain[] = {
 	{ AR5K_BB_GAIN(62), 0x00000002 },
 	{ AR5K_BB_GAIN(63), 0x00000016 },
 };
+#endif
 
+#ifdef CONFIG_ATH5K_AR5212
 /* RF 5112 Initial BaseBand Gain settings */
 static const struct ath5k_ini rf5112_ini_bbgain[] = {
 	{ AR5K_BB_GAIN(0), 0x00000000 },
@@ -983,7 +992,10 @@ static const struct ath5k_ini rf5112_ini_bbgain[] = {
 	{ AR5K_BB_GAIN(62), 0x00000010 },
 	{ AR5K_BB_GAIN(63), 0x0000001a },
 };
+#endif
 
+#if defined(CONFIG_ATH5K_AR5210) || defined(CONFIG_ATH5K_AR5211) \
+	|| defined(CONFIG_ATH5K_AR5212)
 /*
  * Write initial register dump
  */
@@ -1014,7 +1026,12 @@ static void ath5k_hw_ini_registers(struct ath_hw *hal, unsigned int size,
 		}
 	}
 }
+#endif
 
+#if defined(CONFIG_ATH5K_AR5211) || defined(CONFIG_ATH5K_AR5212)
+/*
+ * Write initial mode-specific register dump
+ */
 static void ath5k_hw_ini_mode_registers(struct ath_hw *hal,
 		unsigned int size, const struct ath5k_ini_mode *ini_mode,
 		u8 mode)
@@ -1028,6 +1045,7 @@ static void ath5k_hw_ini_mode_registers(struct ath_hw *hal,
 	}
 
 }
+#endif
 
 int ath5k_hw_write_initvals(struct ath_hw *hal, u8 mode, bool change_channel)
 {
@@ -1035,6 +1053,7 @@ int ath5k_hw_write_initvals(struct ath_hw *hal, u8 mode, bool change_channel)
 	 * Write initial mode-specific settings
 	 */
 	/*For 5212*/
+#ifdef CONFIG_ATH5K_AR5212
 	if (hal->ah_version == AR5K_AR5212) {
 		ath5k_hw_ini_mode_registers(hal, ARRAY_SIZE(ar5212_ini_mode),
 				ar5212_ini_mode, mode);
@@ -1047,16 +1066,19 @@ int ath5k_hw_write_initvals(struct ath_hw *hal, u8 mode, bool change_channel)
 					ARRAY_SIZE(ar5212_rf5112_ini_mode),
 					ar5212_rf5112_ini_mode, mode);
 	}
+#endif
+#ifdef CONFIG_ATH5K_AR5211
 	/*For 5211*/
 	if (hal->ah_version == AR5K_AR5211)
 		ath5k_hw_ini_mode_registers(hal, ARRAY_SIZE(ar5211_ini_mode),
 				ar5211_ini_mode, mode);
+#endif
 	/* For 5210 mode settings check out ath5k_hw_reset_tx_queue */
 
 	/*
 	 * Write initial settings common for all modes
 	 */
-	/*For 5212*/
+#ifdef CONFIG_ATH5K_AR5212
 	if (hal->ah_version == AR5K_AR5212) {
 		ath5k_hw_ini_registers(hal, ARRAY_SIZE(ar5212_ini),
 				ar5212_ini, change_channel);
@@ -1075,16 +1097,23 @@ int ath5k_hw_write_initvals(struct ath_hw *hal, u8 mode, bool change_channel)
 					ARRAY_SIZE(rf5111_ini_bbgain),
 					rf5111_ini_bbgain, change_channel);
 		}
-	} else if (hal->ah_version == AR5K_AR5211) {
+	}
+#endif
+#ifdef CONFIG_ATH5K_AR5211
+	if (hal->ah_version == AR5K_AR5211) {
 		ath5k_hw_ini_registers(hal, ARRAY_SIZE(ar5211_ini),
 				ar5211_ini, change_channel);
 		/* AR5211 only comes with 5111 */
 		ath5k_hw_ini_registers(hal, ARRAY_SIZE(rf5111_ini_bbgain),
 				rf5111_ini_bbgain, change_channel);
-	} else if (hal->ah_version == AR5K_AR5210) {
+	}
+#endif
+#ifdef CONFIG_ATH5K_AR5210
+	if (hal->ah_version == AR5K_AR5210) {
 		ath5k_hw_ini_registers(hal, ARRAY_SIZE(ar5210_ini),
 				ar5210_ini, change_channel);
 	}
+#endif
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath5k_hw_phy.c b/drivers/net/wireless/ath5k_hw_phy.c
index 899b79e..510bf86 100644
--- a/drivers/net/wireless/ath5k_hw_phy.c
+++ b/drivers/net/wireless/ath5k_hw_phy.c
@@ -35,6 +35,7 @@ struct ath5k_gain_opt {
 	const struct ath5k_gain_opt_step	go_step[AR5K_GAIN_STEP_COUNT];
 };
 
+#if defined(CONFIG_ATH5K_AR5211) || defined(CONFIG_ATH5K_AR5212)
 /* RF5111 mode-specific init registers */
 static const struct ath5k_ini_rf rfregs_5111[] = {
 	{ 0, 0x989c,
@@ -214,8 +215,10 @@ static const struct ath5k_gain_opt rfgain_opt_5111 = {
 		{ { 2, 1, 1, 0 }, -6 }
 	}
 };
+#endif
 
 /* RF5112 mode-specific init registers */
+#ifdef CONFIG_ATH5K_AR5212
 static const struct ath5k_ini_rf rfregs_5112[] = {
 	{ 1, 0x98d4,
 	/*    mode a/XR   mode aTurbo mode b      mode g      mode gTurbo */
@@ -529,6 +532,7 @@ static const struct ath5k_gain_opt rfgain_opt_5112 = {
 		{ { 0, 1, 0, 1, 1, 0, 1 }, -16 },
 	}
 };
+#endif
 
 /*
  * Used to modify RF Banks before writing them to AR5K_RF_BUFFER
@@ -661,12 +665,16 @@ static s32 ath5k_hw_rfregs_gain_adjust(struct ath_hw *hal)
 	int ret = 0;
 
 	switch (hal->ah_radio) {
+#if defined(CONFIG_ATH5K_AR5211) || defined(CONFIG_ATH5K_AR5212)
 	case AR5K_RF5111:
 		go = &rfgain_opt_5111;
 		break;
+#endif
+#if defined(CONFIG_ATH5K_AR5212)
 	case AR5K_RF5112:
 		go = &rfgain_opt_5112;
 		break;
+#endif
 	default:
 		return 0;
 	}
@@ -715,6 +723,7 @@ done:
 	return ret;
 }
 
+#if defined(CONFIG_ATH5K_AR5211) || defined(CONFIG_ATH5K_AR5212)
 /*
  * Read EEPROM Calibration data, modify RF Banks and Initialize RF5111
  */
@@ -815,7 +824,9 @@ static int ath5k_hw_rf5111_rfregs(struct ath_hw *hal,
 
 	return 0;
 }
+#endif
 
+#ifdef CONFIG_ATH5K_AR5212
 /*
  * Read EEPROM Calibration data, modify RF Banks and Initialize RF5112
  */
@@ -910,6 +921,7 @@ static int ath5k_hw_rf5112_rfregs(struct ath_hw *hal,
 
 	return 0;
 }
+#endif
 
 /*
  * Initialize RF
@@ -921,10 +933,13 @@ int ath5k_hw_rfregs(struct ath_hw *hal, struct ieee80211_channel *channel,
 	int ret;
 
 	switch (hal->ah_radio) {
+#if defined(CONFIG_ATH5K_AR5211) || defined(CONFIG_ATH5K_AR5212)
 	case AR5K_RF5111:
 		hal->ah_rf_banks_size = sizeof(rfregs_5111);
 		func = ath5k_hw_rf5111_rfregs;
 		break;
+#endif
+#ifdef CONFIG_ATH5K_AR5212
 	case AR5K_RF5112:
 		if (hal->ah_radio_5ghz_revision >= AR5K_SREV_RAD_5112A)
 			hal->ah_rf_banks_size = sizeof(rfregs_5112a);
@@ -932,6 +947,7 @@ int ath5k_hw_rfregs(struct ath_hw *hal, struct ieee80211_channel *channel,
 			hal->ah_rf_banks_size = sizeof(rfregs_5112);
 		func = ath5k_hw_rf5112_rfregs;
 		break;
+#endif
 	default:
 		return -EINVAL;
 	}
@@ -958,14 +974,18 @@ int ath5k_hw_rfgain(struct ath_hw *hal, unsigned int freq)
 	unsigned int i, size;
 
 	switch (hal->ah_radio) {
+#if defined(CONFIG_ATH5K_AR5211) || defined(CONFIG_ATH5K_AR5212)
 	case AR5K_RF5111:
 		ath5k_rfg = rfgain_5111;
 		size = ARRAY_SIZE(rfgain_5111);
 		break;
+#endif
+#ifdef CONFIG_ATH5K_AR5212
 	case AR5K_RF5112:
 		ath5k_rfg = rfgain_5112;
 		size = ARRAY_SIZE(rfgain_5112);
 		break;
+#endif
 	default:
 		return -EINVAL;
 	}
@@ -1031,6 +1051,7 @@ int ath5k_hw_set_rfgain_opt(struct ath_hw *hal)
 {
 	/* Initialize the gain optimization values */
 	switch (hal->ah_radio) {
+#if defined(CONFIG_ATH5K_AR5211) || defined(CONFIG_ATH5K_AR5212)
 	case AR5K_RF5111:
 		hal->ah_gain.g_step_idx = rfgain_opt_5111.go_default;
 		hal->ah_gain.g_step =
@@ -1039,6 +1060,8 @@ int ath5k_hw_set_rfgain_opt(struct ath_hw *hal)
 		hal->ah_gain.g_high = 35;
 		hal->ah_gain.g_active = 1;
 		break;
+#endif
+#ifdef CONFIG_ATH5K_AR5212
 	case AR5K_RF5112:
 		hal->ah_gain.g_step_idx = rfgain_opt_5112.go_default;
 		hal->ah_gain.g_step =
@@ -1047,6 +1070,7 @@ int ath5k_hw_set_rfgain_opt(struct ath_hw *hal)
 		hal->ah_gain.g_high = 85;
 		hal->ah_gain.g_active = 1;
 		break;
+#endif
 	default:
 		return -EINVAL;
 	}
