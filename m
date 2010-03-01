Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745Ab0CAPNc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:13:32 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:46340 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab0CAPMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:12:51 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 14/26] w35und: Convert ChanInfo typedef to struct wb35_chan_info
Date: Mon,  1 Mar 2010 17:04:16 +0200
Message-Id: <1267455868-4533-14-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
References: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/localpara.h |    9 ++++-----
 drivers/staging/winbond/reg.c       |   10 +++++-----
 drivers/staging/winbond/sme_api.h   |    2 +-
 drivers/staging/winbond/wb35reg_f.h |    2 +-
 drivers/staging/winbond/wbusb.c     |    8 ++++----
 5 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/winbond/localpara.h b/drivers/staging/winbond/localpara.h
index 54ab3b7..7f22f5b 100644
--- a/drivers/staging/winbond/localpara.h
+++ b/drivers/staging/winbond/localpara.h
@@ -110,11 +110,10 @@
 // 20061108 WPS IE buffer
 #define MAX_IE_APPEND_SIZE					256 + 4 // Due to [E id][Length][OUI][Data] may 257 bytes
 
-typedef struct _ChanInfo
-{
+struct wb35_chan_info {
 	u8		band;
 	u8		ChanNo;
-} ChanInfo, *pChanInfo;
+};
 
 typedef struct _RadioOff
 {
@@ -183,7 +182,7 @@ typedef struct LOCAL_PARA
 	u8			RoamStatus;
 	u8			reserved7[3];
 
-	ChanInfo	CurrentChan;			//Current channel no. and channel band. It may be changed by scanning.
+	struct wb35_chan_info	CurrentChan;			//Current channel no. and channel band. It may be changed by scanning.
 	u8			boHandover;				// Roaming, Hnadover to other AP.
 	u8			boCCAbusy;
 
@@ -240,7 +239,7 @@ typedef struct LOCAL_PARA
     u32	   		_dot11WEPUndecryptableCount;
     u32	   		_dot11FrameDuplicateCount;
 
-	ChanInfo	IbssChanSetting;	// 2B. Start IBSS Channel setting by registry or WWU.
+	struct wb35_chan_info	IbssChanSetting;	// 2B. Start IBSS Channel setting by registry or WWU.
 	u8		reserved_5[2];		//It may not be used after considering RF type,
 									//region and modulation type.
 
diff --git a/drivers/staging/winbond/reg.c b/drivers/staging/winbond/reg.c
index d915cbd..ebfbe1d 100644
--- a/drivers/staging/winbond/reg.c
+++ b/drivers/staging/winbond/reg.c
@@ -1823,12 +1823,12 @@ BBProcessor_initial(  struct hw_data * pHwData )
 		reg->SQ3_filter[i] = 0x2f; // half of Bit 0 ~ 6
 }
 
-void set_tx_power_per_channel_max2829(  struct hw_data * pHwData,  ChanInfo Channel)
+void set_tx_power_per_channel_max2829(  struct hw_data * pHwData,  struct wb35_chan_info Channel)
 {
 	RFSynthesizer_SetPowerIndex( pHwData, 100 ); // 20060620.1 Modify
 }
 
-void set_tx_power_per_channel_al2230(  struct hw_data * pHwData,  ChanInfo Channel )
+void set_tx_power_per_channel_al2230(  struct hw_data * pHwData,  struct wb35_chan_info Channel )
 {
 	u8	index = 100;
 
@@ -1838,7 +1838,7 @@ void set_tx_power_per_channel_al2230(  struct hw_data * pHwData,  ChanInfo Chann
 	RFSynthesizer_SetPowerIndex( pHwData, index );
 }
 
-void set_tx_power_per_channel_al7230(  struct hw_data * pHwData,  ChanInfo Channel)
+void set_tx_power_per_channel_al7230(  struct hw_data * pHwData,  struct wb35_chan_info Channel)
 {
 	u8	i, index = 100;
 
@@ -1868,7 +1868,7 @@ void set_tx_power_per_channel_al7230(  struct hw_data * pHwData,  ChanInfo Chann
 	RFSynthesizer_SetPowerIndex( pHwData, index );
 }
 
-void set_tx_power_per_channel_wb242(  struct hw_data * pHwData,  ChanInfo Channel)
+void set_tx_power_per_channel_wb242(  struct hw_data * pHwData,  struct wb35_chan_info Channel)
 {
 	u8	index = 100;
 
@@ -1901,7 +1901,7 @@ void set_tx_power_per_channel_wb242(  struct hw_data * pHwData,  ChanInfo Channe
 //   None.
 //=============================================================================================================
 void
-RFSynthesizer_SwitchingChannel(  struct hw_data * pHwData,  ChanInfo Channel )
+RFSynthesizer_SwitchingChannel(  struct hw_data * pHwData,  struct wb35_chan_info Channel )
 {
 	struct wb35_reg *reg = &pHwData->reg;
 	u32	pltmp[16]; // The 16 is the maximum capability of hardware
diff --git a/drivers/staging/winbond/sme_api.h b/drivers/staging/winbond/sme_api.h
index 5498783..4a60aca 100644
--- a/drivers/staging/winbond/sme_api.h
+++ b/drivers/staging/winbond/sme_api.h
@@ -203,7 +203,7 @@ void sme_get_rx_antenna(void *pcore_data, u32 *RxAntenna);
 u8 sme_set_rx_antenna(void *pcore_data, u32 RxAntenna);
 void sme_get_tx_antenna(void *pcore_data, u32 *TxAntenna);
 s8 sme_set_tx_antenna(void *pcore_data, u32 TxAntenna);
-s8 sme_set_IBSS_chan(void *pcore_data, ChanInfo chan);
+s8 sme_set_IBSS_chan(void *pcore_data, struct wb35_chan_info chan);
 
 //20061108 WPS
 s8 sme_set_IE_append(void *pcore_data, u8 *buffer, u16 buf_len);
diff --git a/drivers/staging/winbond/wb35reg_f.h b/drivers/staging/winbond/wb35reg_f.h
index 30f5b5a..1b5d065 100644
--- a/drivers/staging/winbond/wb35reg_f.h
+++ b/drivers/staging/winbond/wb35reg_f.h
@@ -14,7 +14,7 @@ void Dxx_initial(  struct hw_data * pHwData );
 void Mxx_initial(  struct hw_data * pHwData );
 void RFSynthesizer_initial(  struct hw_data * pHwData );
 //void RFSynthesizer_SwitchingChannel(  struct hw_data * pHwData,  s8 Channel );
-void RFSynthesizer_SwitchingChannel(  struct hw_data * pHwData,  ChanInfo Channel );
+void RFSynthesizer_SwitchingChannel(  struct hw_data * pHwData,  struct wb35_chan_info Channel );
 void BBProcessor_initial(  struct hw_data * pHwData );
 void BBProcessor_RateChanging(  struct hw_data * pHwData,  u8 rate ); // 20060613.1
 //void RF_RateChanging(  struct hw_data * pHwData,  u8 rate ); // 20060626.5.c Add
diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index 067082a..944d1b4 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -161,7 +161,7 @@ static void hal_set_radio_mode(struct hw_data *pHwData, unsigned char radio_off)
 }
 
 static void
-hal_set_current_channel_ex(struct hw_data *pHwData, ChanInfo channel)
+hal_set_current_channel_ex(struct hw_data *pHwData, struct wb35_chan_info channel)
 {
 	struct wb35_reg *reg = &pHwData->reg;
 
@@ -180,10 +180,10 @@ hal_set_current_channel_ex(struct hw_data *pHwData, ChanInfo channel)
 	reg->M28_MacControl &= ~0xff;	// Clean channel information field
 	reg->M28_MacControl |= channel.ChanNo;
 	Wb35Reg_WriteWithCallbackValue(pHwData, 0x0828, reg->M28_MacControl,
-				       (s8 *) & channel, sizeof(ChanInfo));
+				       (s8 *) & channel, sizeof(struct wb35_chan_info));
 }
 
-static void hal_set_current_channel(struct hw_data *pHwData, ChanInfo channel)
+static void hal_set_current_channel(struct hw_data *pHwData, struct wb35_chan_info channel)
 {
 	hal_set_current_channel_ex(pHwData, channel);
 }
@@ -253,7 +253,7 @@ static void hal_set_accept_beacon(struct hw_data *pHwData, u8 enable)
 static int wbsoft_config(struct ieee80211_hw *dev, u32 changed)
 {
 	struct wbsoft_priv *priv = dev->priv;
-	ChanInfo ch;
+	struct wb35_chan_info ch;
 
 	printk("wbsoft_config called\n");
 
-- 
1.6.3.3

