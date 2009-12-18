Return-Path: <linux-kernel-owner+w=401wt.eu-S933044AbZLRVIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044AbZLRVIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 16:08:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932863AbZLRVI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 16:08:29 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:37080 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932800AbZLRVIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 16:08:25 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 4/8] w35und: Convert typedef ChanInfo to struct chan_info
Date: Fri, 18 Dec 2009 23:08:18 +0200
Message-Id: <1261170502-1479-4-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1261170502-1479-3-git-send-email-penberg@cs.helsinki.fi>
References: <1261170502-1479-1-git-send-email-penberg@cs.helsinki.fi>
 <1261170502-1479-2-git-send-email-penberg@cs.helsinki.fi>
 <1261170502-1479-3-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/localpara.h |   10 +++++-----
 drivers/staging/winbond/reg.c       |   10 +++++-----
 drivers/staging/winbond/sme_api.h   |    2 +-
 drivers/staging/winbond/wb35reg_f.h |    2 +-
 drivers/staging/winbond/wbusb.c     |    8 ++++----
 5 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/winbond/localpara.h b/drivers/staging/winbond/localpara.h
index 6b29b56..7ca58d0 100644
--- a/drivers/staging/winbond/localpara.h
+++ b/drivers/staging/winbond/localpara.h
@@ -110,16 +110,16 @@
 // 20061108 WPS IE buffer
 #define MAX_IE_APPEND_SIZE					256 + 4 // Due to [E id][Length][OUI][Data] may 257 bytes
 
-typedef struct _ChanInfo
+struct chan_info
 {
 	u8		band;
 	u8		ChanNo;
-} ChanInfo, *pChanInfo;
+};
 
 typedef struct _CHAN_LIST
 {
 	u16				Count;
-	ChanInfo		Channel[50]; // 100B
+	struct chan_info		Channel[50]; // 100B
 } CHAN_LIST, *psCHAN_LIST;
 
 struct radio_off
@@ -189,7 +189,7 @@ struct wb_local_para
 	u8			RoamStatus;
 	u8			reserved7[3];
 
-	ChanInfo	CurrentChan;			//Current channel no. and channel band. It may be changed by scanning.
+	struct chan_info	CurrentChan;			//Current channel no. and channel band. It may be changed by scanning.
 	u8			boHandover;				// Roaming, Hnadover to other AP.
 	u8			boCCAbusy;
 
@@ -246,7 +246,7 @@ struct wb_local_para
     u32	   		_dot11WEPUndecryptableCount;
     u32	   		_dot11FrameDuplicateCount;
 
-	ChanInfo	IbssChanSetting;	// 2B. Start IBSS Channel setting by registry or WWU.
+	struct chan_info	IbssChanSetting;	// 2B. Start IBSS Channel setting by registry or WWU.
 	u8		reserved_5[2];		//It may not be used after considering RF type,
 									//region and modulation type.
 
diff --git a/drivers/staging/winbond/reg.c b/drivers/staging/winbond/reg.c
index d915cbd..5f5048a 100644
--- a/drivers/staging/winbond/reg.c
+++ b/drivers/staging/winbond/reg.c
@@ -1823,12 +1823,12 @@ BBProcessor_initial(  struct hw_data * pHwData )
 		reg->SQ3_filter[i] = 0x2f; // half of Bit 0 ~ 6
 }
 
-void set_tx_power_per_channel_max2829(  struct hw_data * pHwData,  ChanInfo Channel)
+void set_tx_power_per_channel_max2829(  struct hw_data * pHwData,  struct chan_info Channel)
 {
 	RFSynthesizer_SetPowerIndex( pHwData, 100 ); // 20060620.1 Modify
 }
 
-void set_tx_power_per_channel_al2230(  struct hw_data * pHwData,  ChanInfo Channel )
+void set_tx_power_per_channel_al2230(  struct hw_data * pHwData,  struct chan_info Channel )
 {
 	u8	index = 100;
 
@@ -1838,7 +1838,7 @@ void set_tx_power_per_channel_al2230(  struct hw_data * pHwData,  ChanInfo Chann
 	RFSynthesizer_SetPowerIndex( pHwData, index );
 }
 
-void set_tx_power_per_channel_al7230(  struct hw_data * pHwData,  ChanInfo Channel)
+void set_tx_power_per_channel_al7230(  struct hw_data * pHwData,  struct chan_info Channel)
 {
 	u8	i, index = 100;
 
@@ -1868,7 +1868,7 @@ void set_tx_power_per_channel_al7230(  struct hw_data * pHwData,  ChanInfo Chann
 	RFSynthesizer_SetPowerIndex( pHwData, index );
 }
 
-void set_tx_power_per_channel_wb242(  struct hw_data * pHwData,  ChanInfo Channel)
+void set_tx_power_per_channel_wb242(  struct hw_data * pHwData,  struct chan_info Channel)
 {
 	u8	index = 100;
 
@@ -1901,7 +1901,7 @@ void set_tx_power_per_channel_wb242(  struct hw_data * pHwData,  ChanInfo Channe
 //   None.
 //=============================================================================================================
 void
-RFSynthesizer_SwitchingChannel(  struct hw_data * pHwData,  ChanInfo Channel )
+RFSynthesizer_SwitchingChannel(  struct hw_data * pHwData,  struct chan_info Channel )
 {
 	struct wb35_reg *reg = &pHwData->reg;
 	u32	pltmp[16]; // The 16 is the maximum capability of hardware
diff --git a/drivers/staging/winbond/sme_api.h b/drivers/staging/winbond/sme_api.h
index 62c2564..b589829 100644
--- a/drivers/staging/winbond/sme_api.h
+++ b/drivers/staging/winbond/sme_api.h
@@ -201,7 +201,7 @@ void sme_get_rx_antenna(void *pcore_data, u32 *RxAntenna);
 u8 sme_set_rx_antenna(void *pcore_data, u32 RxAntenna);
 void sme_get_tx_antenna(void *pcore_data, u32 *TxAntenna);
 s8 sme_set_tx_antenna(void *pcore_data, u32 TxAntenna);
-s8 sme_set_IBSS_chan(void *pcore_data, ChanInfo chan);
+s8 sme_set_IBSS_chan(void *pcore_data, struct chan_info chan);
 
 //20061108 WPS
 s8 sme_set_IE_append(void *pcore_data, u8 *buffer, u16 buf_len);
diff --git a/drivers/staging/winbond/wb35reg_f.h b/drivers/staging/winbond/wb35reg_f.h
index 30f5b5a..d352bce 100644
--- a/drivers/staging/winbond/wb35reg_f.h
+++ b/drivers/staging/winbond/wb35reg_f.h
@@ -14,7 +14,7 @@ void Dxx_initial(  struct hw_data * pHwData );
 void Mxx_initial(  struct hw_data * pHwData );
 void RFSynthesizer_initial(  struct hw_data * pHwData );
 //void RFSynthesizer_SwitchingChannel(  struct hw_data * pHwData,  s8 Channel );
-void RFSynthesizer_SwitchingChannel(  struct hw_data * pHwData,  ChanInfo Channel );
+void RFSynthesizer_SwitchingChannel(  struct hw_data * pHwData,  struct chan_info Channel );
 void BBProcessor_initial(  struct hw_data * pHwData );
 void BBProcessor_RateChanging(  struct hw_data * pHwData,  u8 rate ); // 20060613.1
 //void RF_RateChanging(  struct hw_data * pHwData,  u8 rate ); // 20060626.5.c Add
diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index 067082a..1c58763 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -161,7 +161,7 @@ static void hal_set_radio_mode(struct hw_data *pHwData, unsigned char radio_off)
 }
 
 static void
-hal_set_current_channel_ex(struct hw_data *pHwData, ChanInfo channel)
+hal_set_current_channel_ex(struct hw_data *pHwData, struct chan_info channel)
 {
 	struct wb35_reg *reg = &pHwData->reg;
 
@@ -180,10 +180,10 @@ hal_set_current_channel_ex(struct hw_data *pHwData, ChanInfo channel)
 	reg->M28_MacControl &= ~0xff;	// Clean channel information field
 	reg->M28_MacControl |= channel.ChanNo;
 	Wb35Reg_WriteWithCallbackValue(pHwData, 0x0828, reg->M28_MacControl,
-				       (s8 *) & channel, sizeof(ChanInfo));
+				       (s8 *) & channel, sizeof(struct chan_info));
 }
 
-static void hal_set_current_channel(struct hw_data *pHwData, ChanInfo channel)
+static void hal_set_current_channel(struct hw_data *pHwData, struct chan_info channel)
 {
 	hal_set_current_channel_ex(pHwData, channel);
 }
@@ -253,7 +253,7 @@ static void hal_set_accept_beacon(struct hw_data *pHwData, u8 enable)
 static int wbsoft_config(struct ieee80211_hw *dev, u32 changed)
 {
 	struct wbsoft_priv *priv = dev->priv;
-	ChanInfo ch;
+	struct chan_info ch;
 
 	printk("wbsoft_config called\n");
 
-- 
1.6.0.4

