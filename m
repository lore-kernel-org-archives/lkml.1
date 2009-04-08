Return-Path: <linux-kernel-owner+w=401wt.eu-S1762562AbZDHIRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762562AbZDHIRk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 04:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762723AbZDHIO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 04:14:26 -0400
Received: from smtp-68.nebula.fi ([83.145.220.68]:47891 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762348AbZDHIOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 04:14:18 -0400
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 07/11] w35und: clean up comments in wbusb.c
Date: Wed,  8 Apr 2009 11:14:02 +0300
Message-Id: <1239178446-12893-7-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1239178446-12893-1-git-send-email-penberg@cs.helsinki.fi>
References: <1239178446-12893-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Remove some useless comments and clean up others.

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/wbusb.c |   71 ++++++++++++++-------------------------
 1 files changed, 25 insertions(+), 46 deletions(-)

diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index 5dc1ba6..fad3b99 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -124,27 +124,17 @@ static int wbsoft_config(struct ieee80211_hw *dev, u32 changed)
 
 	printk("wbsoft_config called\n");
 
+	/* Should use channel_num, or something, as that is already pre-translated */
 	ch.band = 1;
-	ch.ChanNo = 1;	/* Should use channel_num, or something, as that is already pre-translated */
-
+	ch.ChanNo = 1;
 
 	hal_set_current_channel(&priv->sHwData, ch);
 	hal_set_beacon_period(&priv->sHwData, conf->beacon_int);
-//	hal_set_cap_info(&priv->sHwData, ?? );
-// hal_set_ssid(struct hw_data * pHwData,  u8 * pssid,  u8 ssid_len); ??
 	hal_set_accept_broadcast(&priv->sHwData, 1);
 	hal_set_accept_promiscuous(&priv->sHwData,  1);
 	hal_set_accept_multicast(&priv->sHwData,  1);
 	hal_set_accept_beacon(&priv->sHwData,  1);
 	hal_set_radio_mode(&priv->sHwData,  0);
-	//hal_set_antenna_number(  struct hw_data * pHwData, u8 number )
-	//hal_set_rf_power(struct hw_data * pHwData, u8 PowerIndex)
-
-
-//	hal_start_bss(&priv->sHwData, WLAN_BSSTYPE_INFRASTRUCTURE);	??
-
-//void hal_set_rates(struct hw_data * pHwData, u8 * pbss_rates,
-//		   u8 length, unsigned char basic_rate_set)
 
 	return 0;
 }
@@ -165,7 +155,7 @@ static u64 wbsoft_get_tsf(struct ieee80211_hw *dev)
 
 static const struct ieee80211_ops wbsoft_ops = {
 	.tx			= wbsoft_tx,
-	.start			= wbsoft_start,		/* Start can be pretty much empty as we do wb35_hw_init() during probe? */
+	.start			= wbsoft_start,
 	.stop			= wbsoft_stop,
 	.add_interface		= wbsoft_add_interface,
 	.remove_interface	= wbsoft_remove_interface,
@@ -175,7 +165,6 @@ static const struct ieee80211_ops wbsoft_ops = {
 	.get_stats		= wbsoft_get_stats,
 	.get_tx_stats		= wbsoft_get_tx_stats,
 	.get_tsf		= wbsoft_get_tsf,
-// conf_tx: hal_set_cwmin()/hal_set_cwmax;
 };
 
 static void hal_led_control(unsigned long data)
@@ -469,9 +458,8 @@ static int hal_init_hardware(struct ieee80211_hw *hw)
 	struct hw_data * pHwData = &priv->sHwData;
 	u16 SoftwareSet;
 
-	// Initial the variable
-	pHwData->MaxReceiveLifeTime = DEFAULT_MSDU_LIFE_TIME; // Setting Rx maximum MSDU life time
-	pHwData->FragmentThreshold = DEFAULT_FRAGMENT_THRESHOLD; // Setting default fragment threshold
+	pHwData->MaxReceiveLifeTime = DEFAULT_MSDU_LIFE_TIME;
+	pHwData->FragmentThreshold = DEFAULT_FRAGMENT_THRESHOLD;
 
 	if (!Wb35Reg_initial(pHwData))
 		goto error_reg_destroy;
@@ -488,9 +476,6 @@ static int hal_init_hardware(struct ieee80211_hw *hw)
 	pHwData->LEDTimer.expires = jiffies + msecs_to_jiffies(1000);
 	add_timer(&pHwData->LEDTimer);
 
-	//
-	// For restrict to vendor's hardware
-	//
 	SoftwareSet = hal_software_set( pHwData );
 
 	#ifdef Vendor2
@@ -526,12 +511,9 @@ static int wb35_hw_init(struct ieee80211_hw *hw)
 	u8		HwRadioOff;
 	int err;
 
-	//
-	// Setting default value for Linux
-	//
 	priv->sLocalPara.region_INF = REGION_AUTO;
 	priv->sLocalPara.TxRateMode = RATE_AUTO;
-	priv->sLocalPara.bMacOperationMode = MODE_802_11_BG;	// B/G mode
+	priv->sLocalPara.bMacOperationMode = MODE_802_11_BG;
 	priv->Mds.TxRTSThreshold = DEFAULT_RTSThreshold;
 	priv->Mds.TxFragmentThreshold = DEFAULT_FRAGMENT_THRESHOLD;
 	hal_set_phy_type( &priv->sHwData, RF_WB_242_1 );
@@ -541,12 +523,10 @@ static int wb35_hw_init(struct ieee80211_hw *hw)
 	pHwData = &priv->sHwData;
 	hal_set_phy_type( pHwData, RF_DECIDE_BY_INF );
 
-	//added by ws for wep key error detection
 	priv->sLocalPara.bWepKeyError= false;
 	priv->sLocalPara.bToSelfPacketReceived = false;
-	priv->sLocalPara.WepKeyDetectTimerCount= 2 * 100; /// 2 seconds
+	priv->sLocalPara.WepKeyDetectTimerCount= 2 * 100; /* 2 seconds */
 
-	// Initial USB hal
 	pHwData = &priv->sHwData;
 	err = hal_init_hardware(hw);
 	if (err)
@@ -559,7 +539,7 @@ static int wb35_hw_init(struct ieee80211_hw *hw)
 		if (priv->sLocalPara.region_INF != REGION_AUTO)
 			priv->sLocalPara.region = priv->sLocalPara.region_INF;
 		else
-			priv->sLocalPara.region = REGION_USA;	//default setting
+			priv->sLocalPara.region = REGION_USA; /* default setting */
 	}
 
 	// Get Software setting flag from hal
@@ -567,32 +547,31 @@ static int wb35_hw_init(struct ieee80211_hw *hw)
 	if (hal_software_set(pHwData) & 0x00000001)
 		priv->sLocalPara.boAntennaDiversity = true;
 
-	// For MDS module
 	Mds_initial(priv);
 
-	//=======================================
-	// Initialize the SME, SCAN, MLME, ROAM
-	//=======================================
-
-	// If no user-defined address in the registry, use the addresss "burned" on the NIC instead.
+	/*
+	 * If no user-defined address in the registry, use the addresss
+	 * "burned" on the NIC instead.
+	 */
 	pMacAddr = priv->sLocalPara.ThisMacAddress;
 	pMacAddr2 = priv->sLocalPara.PermanentAddress;
-	hal_get_permanent_address( pHwData, priv->sLocalPara.PermanentAddress );// Reading ethernet address from EEPROM
+
+	/* Reading ethernet address from EEPROM */
+	hal_get_permanent_address( pHwData, priv->sLocalPara.PermanentAddress );
 	if (memcmp(pMacAddr, "\x00\x00\x00\x00\x00\x00", MAC_ADDR_LENGTH) == 0)
 		memcpy(pMacAddr, pMacAddr2, MAC_ADDR_LENGTH);
 	else {
-		// Set the user define MAC address
+		/* Set the user define MAC address */
 		hal_set_ethernet_address(pHwData, priv->sLocalPara.ThisMacAddress);
 	}
 
-	//get current antenna
 	priv->sLocalPara.bAntennaNo = hal_get_antenna_number(pHwData);
 #ifdef _PE_STATE_DUMP_
 	printk("Driver init, antenna no = %d\n", psLOCAL->bAntennaNo);
 #endif
 	hal_get_hw_radio_off( pHwData );
 
-	// Waiting for HAL setting OK
+	/* Waiting for HAL setting OK */
 	while (!hal_idle(pHwData))
 		msleep(10);
 
@@ -603,9 +582,8 @@ static int wb35_hw_init(struct ieee80211_hw *hw)
 
 	hal_set_radio_mode( pHwData, (unsigned char)(priv->sLocalPara.RadioOffStatus.boSwRadioOff || priv->sLocalPara.RadioOffStatus.boHwRadioOff) );
 
-	hal_driver_init_OK(pHwData) = 1; // Notify hal that the driver is ready now.
-	//set a tx power for reference.....
-//	sme_set_tx_power_level(priv, 12);	FIXME?
+	/* Notify hal that the driver is ready now. */
+	hal_driver_init_OK(pHwData) = 1;
 
 error:
 	return err;
@@ -624,7 +602,7 @@ static int wb35_probe(struct usb_interface *intf, const struct usb_device_id *id
 
 	usb_get_dev(udev);
 
-	// 20060630.2 Check the device if it already be opened
+	/* Check the device if it already be opened */
 	nr = usb_control_msg(udev, usb_rcvctrlpipe( udev, 0 ),
 			     0x01, USB_TYPE_VENDOR|USB_RECIP_DEVICE|USB_DIR_IN,
 			     0x0, 0x400, &ltmp, 4, HZ*100 );
@@ -633,8 +611,9 @@ static int wb35_probe(struct usb_interface *intf, const struct usb_device_id *id
 		goto error;
 	}
 
+	/* Is already initialized? */
 	ltmp = cpu_to_le32(ltmp);
-	if (ltmp) {  // Is already initialized?
+	if (ltmp) {
 		err = -EBUSY;
 		goto error;
 	}
@@ -711,14 +690,14 @@ static void wb35_hw_halt(struct wbsoft_priv *adapter)
 {
 	Mds_Destroy( adapter );
 
-	// Turn off Rx and Tx hardware ability
+	/* Turn off Rx and Tx hardware ability */
 	hal_stop( &adapter->sHwData );
 #ifdef _PE_USB_INI_DUMP_
 	printk("[w35und] Hal_stop O.K.\n");
 #endif
-	msleep(100);// Waiting Irp completed
+	/* Waiting Irp completed */
+	msleep(100);
 
-	// Halt the HAL
 	hal_halt(&adapter->sHwData);
 }
 
-- 
1.5.6.3

