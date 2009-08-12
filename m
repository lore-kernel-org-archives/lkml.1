Return-Path: <linux-kernel-owner+w=401wt.eu-S1754668AbZHLIEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbZHLIEy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 04:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754389AbZHLIEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 04:04:53 -0400
Received: from smtp6.welho.com ([213.243.153.40]:57041 "EHLO smtp6.welho.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754114AbZHLIDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 04:03:42 -0400
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 7/7] w35und: Remove some write-only struct members
Date: Wed, 12 Aug 2009 11:03:39 +0300
Message-Id: <1250064219-7372-7-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1250064219-7372-6-git-send-email-penberg@cs.helsinki.fi>
References: <1250064219-7372-1-git-send-email-penberg@cs.helsinki.fi>
 <1250064219-7372-2-git-send-email-penberg@cs.helsinki.fi>
 <1250064219-7372-3-git-send-email-penberg@cs.helsinki.fi>
 <1250064219-7372-4-git-send-email-penberg@cs.helsinki.fi>
 <1250064219-7372-5-git-send-email-penberg@cs.helsinki.fi>
 <1250064219-7372-6-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no point in keeping around struct members that are only written
to but never read.

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/localpara.h |    1 -
 drivers/staging/winbond/mto.c       |   26 +--------------
 drivers/staging/winbond/mto.h       |   62 -----------------------------------
 drivers/staging/winbond/wbusb.c     |    5 ---
 4 files changed, 1 insertions(+), 93 deletions(-)

diff --git a/drivers/staging/winbond/localpara.h b/drivers/staging/winbond/localpara.h
index 607bb05..5626a76 100644
--- a/drivers/staging/winbond/localpara.h
+++ b/drivers/staging/winbond/localpara.h
@@ -190,7 +190,6 @@ typedef struct LOCAL_PARA
 	u8			Reserved0[2];
 
 	u8			boMsRadioOff;			// Ndis demands to be true when set Disassoc. OID and be false when set SSID OID.
-	u8			boAntennaDiversity;		//TRUE/ON or FALSE/OFF
 	u8			bAntennaNo;				//which antenna
 	u8			bConnectFlag;			//the connect status flag for roaming task
 
diff --git a/drivers/staging/winbond/mto.c b/drivers/staging/winbond/mto.c
index 7deb5c7..5e7fa1c 100644
--- a/drivers/staging/winbond/mto.c
+++ b/drivers/staging/winbond/mto.c
@@ -76,23 +76,6 @@ void hal_get_dto_para(struct wbsoft_priv *adapter, char *buffer);
 void MTO_Init(struct wbsoft_priv *adapter)
 {
     int i;
-	//[WKCHEN]pMTOcore_data = pcore_data;
-// 20040510 Turbo add for global variable
-    MTO_TMR_CNT()       = 0;
-    MTO_TOGGLE_STATE()  = TOGGLE_STATE_IDLE;
-    MTO_TX_RATE_REDUCTION_STATE() = RATE_CHGSTATE_IDLE;
-    MTO_BACKOFF_TMR()   = 0;
-    MTO_LAST_RATE()     = 11;
-    MTO_CO_EFFICENT()   = 0;
-
-    //MTO_TH_FIXANT()     = MTO_DEFAULT_TH_FIXANT;
-    MTO_TH_CNT()        = MTO_DEFAULT_TH_CNT;
-    MTO_TH_SQ3()        = MTO_DEFAULT_TH_SQ3;
-    MTO_TH_IDLE_SLOT()  = MTO_DEFAULT_TH_IDLE_SLOT;
-    MTO_TH_PR_INTERF()  = MTO_DEFAULT_TH_PR_INTERF;
-
-    MTO_TMR_AGING()     = MTO_DEFAULT_TMR_AGING;
-    MTO_TMR_PERIODIC()  = MTO_DEFAULT_TMR_PERIODIC;
 
     //[WKCHEN]MTO_CCA_MODE_SETUP()= (u8) hal_get_cca_mode(MTO_HAL());
     //[WKCHEN]MTO_CCA_MODE()      = MTO_CCA_MODE_SETUP();
@@ -100,17 +83,12 @@ void MTO_Init(struct wbsoft_priv *adapter)
     //MTO_PREAMBLE_TYPE() = MTO_PREAMBLE_LONG;
     MTO_PREAMBLE_TYPE() = MTO_PREAMBLE_SHORT;   // for test
 
-    MTO_ANT_SEL()       = hal_get_antenna_number(MTO_HAL());
-    MTO_ANT_MAC()       = MTO_ANT_SEL();
     MTO_CNT_ANT(0)      = 0;
     MTO_CNT_ANT(1)      = 0;
     MTO_SQ_ANT(0)       = 0;
     MTO_SQ_ANT(1)       = 0;
-    MTO_ANT_DIVERSITY() = MTO_ANTENNA_DIVERSITY_ON;
-    //CardSet_AntennaDiversity(adapter, MTO_ANT_DIVERSITY());
-    //PLMESetAntennaDiversity( adapter, MTO_ANT_DIVERSITY());
 
-    MTO_AGING_TIMEOUT() = 0;//MTO_TMR_AGING() / MTO_TMR_PERIODIC();
+    MTO_AGING_TIMEOUT() = 0;
 
     // The following parameters should be initialized to the values set by user
     //
@@ -128,9 +106,7 @@ void MTO_Init(struct wbsoft_priv *adapter)
     MTO_FRAG_CHANGE_ENABLE()    = 0;          // 1.1.29.1000 Turbo add don't support frag
 	//The default valud of ANTDIV_DEFAULT_ON will be decided by EEPROM
 	//#ifdef ANTDIV_DEFAULT_ON
-    //MTO_ANT_DIVERSITY_ENABLE()  = 1;
 	//#else
-    //MTO_ANT_DIVERSITY_ENABLE()  = 0;
 	//#endif
     MTO_POWER_CHANGE_ENABLE()   = 1;
 	MTO_PREAMBLE_CHANGE_ENABLE()= 1;
diff --git a/drivers/staging/winbond/mto.h b/drivers/staging/winbond/mto.h
index e6d2ccb..4fe24b0 100644
--- a/drivers/staging/winbond/mto.h
+++ b/drivers/staging/winbond/mto.h
@@ -15,51 +15,18 @@
 
 struct wbsoft_priv;
 
-#define MTO_DEFAULT_TH_CNT              5
-#define MTO_DEFAULT_TH_SQ3              112  //OLD IS 13 reference JohnXu
-#define MTO_DEFAULT_TH_IDLE_SLOT        15
-#define MTO_DEFAULT_TH_PR_INTERF        30
-#define MTO_DEFAULT_TMR_AGING           25  // unit: slot time  10 reference JohnXu
-#define MTO_DEFAULT_TMR_PERIODIC        5   // unit: slot time
-
-#define MTO_ANTENNA_DIVERSITY_OFF       0
-#define MTO_ANTENNA_DIVERSITY_ON        1
-
 // LA20040210_DTO kevin
 //#define MTO_PREAMBLE_LONG               0
 //#define MTO_PREAMBLE_SHORT              1
 #define MTO_PREAMBLE_LONG               WLAN_PREAMBLE_TYPE_LONG
 #define MTO_PREAMBLE_SHORT              WLAN_PREAMBLE_TYPE_SHORT
 
-typedef enum {
-    TOGGLE_STATE_IDLE             = 0,
-    TOGGLE_STATE_WAIT0            = 1,
-    TOGGLE_STATE_WAIT1            = 2,
-    TOGGLE_STATE_MAKEDESISION     = 3,
-	TOGGLE_STATE_BKOFF            = 4
-} TOGGLE_STATE;
-
-typedef enum {
-    RATE_CHGSTATE_IDLE         = 0,
-    RATE_CHGSTATE_CALCULATE    = 1,
-    RATE_CHGSTATE_BACKOFF	   = 2
-} TX_RATE_REDUCTION_STATE;
-
 //============================================================================
 // struct _MTOParameters --
 //
 //   Defines the parameters used in the MAC Throughput Optimization algorithm
 //============================================================================
 struct wb35_mto_params {
-	u8      Th_Fixant;
-	u8      Th_Cnt;
-	u8      Th_SQ3;
-	u8      Th_IdleSlot;
-
-	u16     Tmr_Aging;
-	u8      Th_PrInterf;
-	u8      Tmr_Periodic;
-
 	//---------        wkchen added      -------------
 	u32		TxFlowCount;	//to judge what kind the tx flow(sparse or busy) is
 	//------------------------------------------------
@@ -83,9 +50,6 @@ struct wb35_mto_params {
 
 	u8      PowerChangeEnable;
 	u8      AntDiversityEnable;
-	u8      Ant_mac;
-	u8      Ant_div;
-
 	u8      CCA_Mode;
 	u8      CCA_Mode_Setup;
 	u8      Preamble_Type;
@@ -112,13 +76,6 @@ struct wb35_mto_params {
 	u32     SQ_Ant[2];
 
 // 20040510 remove from globe vairable
-	u32                     TmrCnt;
-	u32                     BackoffTmr;
-	TOGGLE_STATE            ToggleState;
-	TX_RATE_REDUCTION_STATE TxRateReductionState;
-
-	u8                      Last_Rate;
-	u8                      Co_efficent;
 	u8		FallbackRateLevel;
 	u8		OfdmRateLevel;
 
@@ -140,26 +97,8 @@ struct wb35_mto_params {
 #define LOCAL_ANTENNA_NO()			(adapter->sLocalPara.bAntennaNo)
 #define LOCAL_IS_CONNECTED()		(adapter->sLocalPara.wConnectedSTAindex != 0)
 #define MTO_INITTXRATE_MODE			(adapter->sHwData.SoftwareSet&0x2)	//bit 1
-// 20040510 Turbo add
-#define MTO_TMR_CNT()               MTO_DATA().TmrCnt
-#define MTO_TOGGLE_STATE()          MTO_DATA().ToggleState
-#define MTO_TX_RATE_REDUCTION_STATE() MTO_DATA().TxRateReductionState
-#define MTO_BACKOFF_TMR()           MTO_DATA().BackoffTmr
-#define MTO_LAST_RATE()             MTO_DATA().Last_Rate
-#define MTO_CO_EFFICENT()           MTO_DATA().Co_efficent
-
-#define MTO_TH_CNT()                MTO_DATA().Th_Cnt
-#define MTO_TH_SQ3()                MTO_DATA().Th_SQ3
-#define MTO_TH_IDLE_SLOT()          MTO_DATA().Th_IdleSlot
-#define MTO_TH_PR_INTERF()          MTO_DATA().Th_PrInterf
-
-#define MTO_TMR_AGING()             MTO_DATA().Tmr_Aging
-#define MTO_TMR_PERIODIC()          MTO_DATA().Tmr_Periodic
 
 #define MTO_POWER_CHANGE_ENABLE()   MTO_DATA().PowerChangeEnable
-#define MTO_ANT_DIVERSITY_ENABLE()  adapter->sLocalPara.boAntennaDiversity
-#define MTO_ANT_MAC()               MTO_DATA().Ant_mac
-#define MTO_ANT_DIVERSITY()         MTO_DATA().Ant_div
 #define MTO_CCA_MODE()              MTO_DATA().CCA_Mode
 #define MTO_CCA_MODE_SETUP()        MTO_DATA().CCA_Mode_Setup
 #define MTO_PREAMBLE_TYPE()         MTO_DATA().Preamble_Type
@@ -178,7 +117,6 @@ struct wb35_mto_params {
 #define MTO_PR_INTERF()             MTO_DATA().Pr_Interf
 #define MTO_AVG_GAP_BTWN_INTERF()   MTO_DATA().AvgGapBtwnInterf
 
-#define MTO_ANT_SEL()               MTO_DATA().Ant_sel
 #define MTO_CNT_ANT(x)              MTO_DATA().Cnt_Ant[(x)]
 #define MTO_SQ_ANT(x)               MTO_DATA().SQ_Ant[(x)]
 #define MTO_AGING_TIMEOUT()         MTO_DATA().aging_timeout
diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index 745279c..8950724 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -716,11 +716,6 @@ static int wb35_hw_init(struct ieee80211_hw *hw)
 			priv->sLocalPara.region = REGION_USA;	/* default setting */
 	}
 
-	// Get Software setting flag from hal
-	priv->sLocalPara.boAntennaDiversity = false;
-	if (hal_software_set(pHwData) & 0x00000001)
-		priv->sLocalPara.boAntennaDiversity = true;
-
 	Mds_initial(priv);
 
 	/*
-- 
1.5.6.3

