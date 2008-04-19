Return-Path: <linux-kernel-owner+w=401wt.eu-S1759916AbYDSNrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759916AbYDSNrU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 09:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754217AbYDSNrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 09:47:13 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:58349 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396AbYDSNrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 09:47:12 -0400
Date: Sat, 19 Apr 2008 15:47:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, kaszak@gmail.com,
       lcostantino@gmail.com
Subject: w35und: remove teststa mode
Message-ID: <20080419134756.GA26456@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove TESTSTA mode.

---
commit 691a6ec372a481499e882739106864d33ef8f4eb
tree 4481b25b2c1400003cff4fd3da64a32b8ca95c27
parent 192dfca4d5a025bd7d14ba1284897e0108a1cee6
author Pavel <pavel@amd.ucw.cz> Sat, 19 Apr 2008 15:47:16 +0200
committer Pavel <pavel@amd.ucw.cz> Sat, 19 Apr 2008 15:47:16 +0200

 drivers/net/wireless/winbond/winbondport/adapter.h |    1 -
 .../wireless/winbond/winbondport/linux/teststa.h   |   22 ----------------------
 drivers/net/wireless/winbond/winbondport/mds.c     |   17 +--------------
 drivers/net/wireless/winbond/winbondport/wbhal.c   |   18 ++--------------
 drivers/net/wireless/winbond/winbondport/wblinux.c |    2 --
 5 files changed, 3 insertions(+), 57 deletions(-)

diff --git a/drivers/net/wireless/winbond/winbondport/adapter.h b/drivers/net/wireless/winbond/winbondport/adapter.h
index b5f3408..609701d 100644
--- a/drivers/net/wireless/winbond/winbondport/adapter.h
+++ b/drivers/net/wireless/winbond/winbondport/adapter.h
@@ -15,7 +15,6 @@ typedef struct WB32_ADAPTER
 	MTO_PARAMETERS		sMtoPara; // MTO_struct ...
 	hw_data_t			sHwData; //For HAL
 	MDS					Mds;
-	TESTSTA				sTestSta; // For test station
 
 	WBLINUX		WbLinux;
         struct iw_statistics iw_stats;
diff --git a/drivers/net/wireless/winbond/winbondport/linux/teststa.h b/drivers/net/wireless/winbond/winbondport/linux/teststa.h
index 9011b77..e69de29 100644
--- a/drivers/net/wireless/winbond/winbondport/linux/teststa.h
+++ b/drivers/net/wireless/winbond/winbondport/linux/teststa.h
@@ -1,22 +0,0 @@
-//
-// TestSTA.H -
-// For test station.  Used with the WLANUTIL_W35.EXE.
-// [TS]
-#define	TS_RUNNING_IN_TESTSTA_MODE	(Adapter->sTestSta.ulTestStation)
-#define TS_GetPacketSize( _A )			0
-#define TS_GetNextPacket( _A, _B )
-#define TS_initial( _A )			1
-#define TS_destroy( _A )
-#define TS_SendResult( _A, _B, _C )
-#define TS_STARTUP( _A )
-#define TS_MpduProcess( _A, _D )
-#define OS_RSSI_TEST_SET( _A )		0
-#define TS_GetNextPacketComplete( _A, _D )
-#define Ts_Led_Control( _A )
-
-typedef struct _TESTSTA
-{
-	u32	ulTestStation;              // Test station mode
-	u32	ulIsTestInitial;			// Is test mode initial
-} TESTSTA, *PTESTSTA;
-
diff --git a/drivers/net/wireless/winbond/winbondport/mds.c b/drivers/net/wireless/winbond/winbondport/mds.c
index b2bd830..97a978a 100644
--- a/drivers/net/wireless/winbond/winbondport/mds.c
+++ b/drivers/net/wireless/winbond/winbondport/mds.c
@@ -73,7 +73,7 @@ Mds_Tx(PADAPTER Adapter)
 				PacketFrom = 1;
 				PacketSize = QUERY_SIZE_FIRST( Adapter );
 				if (!PacketSize) {
-					if (!TS_RUNNING_IN_TESTSTA_MODE) { // If driver doesn't run in test mode, send MLME and normal data frame
+					if (1) { // If driver doesn't run in test mode, send MLME and normal data frame
 						PacketFrom = 2;
 						PacketSize = QUERY_SIZE_SECOND(Adapter);
 						if (!PacketSize) {
@@ -707,34 +707,19 @@ Mds_DurationSet(  PADAPTER Adapter,  PDE
 ///////////////////////////////////////////////////////////////////////////////
 u16 MDS_GetPacketSize(  PADAPTER Adapter ) // Get packet size
 {
-	// Case 1 : send TS frame
-	if( TS_RUNNING_IN_TESTSTA_MODE )
-		return TS_GetPacketSize( Adapter );
-
 	return 0;
 }
 
 void MDS_GetNextPacket(  PADAPTER Adapter,  PDESCRIPTOR pDes )
 {
-	// Case 1 :  Get TS frame entity
-	if( TS_RUNNING_IN_TESTSTA_MODE )
-		TS_GetNextPacket( Adapter, pDes );
 }
 
 void MDS_GetNextPacketComplete(  PADAPTER Adapter,  PDESCRIPTOR pDes )
 {
-	// Case 1 : send TS frame
-	if( TS_RUNNING_IN_TESTSTA_MODE )
-		TS_GetNextPacketComplete( Adapter, pDes );
 }
 
 void MDS_SendResult(  PADAPTER Adapter,  u8 PacketId,  unsigned char SendOK )
 {
-	// Case 1 : send TS frame
-	if( TS_RUNNING_IN_TESTSTA_MODE )
-		TS_SendResult( Adapter, PacketId, SendOK );
-
-	// Case 2 : Ignore WPA send result
 }
 
 void MDS_EthernetPacketReceive(  PADAPTER Adapter,  PRXLAYER1 pRxLayer1 )
diff --git a/drivers/net/wireless/winbond/winbondport/wbhal.c b/drivers/net/wireless/winbond/winbondport/wbhal.c
index 55eccde..0622ecb 100644
--- a/drivers/net/wireless/winbond/winbondport/wbhal.c
+++ b/drivers/net/wireless/winbond/winbondport/wbhal.c
@@ -448,9 +448,6 @@ void hal_set_current_channel(  phw_data_
 {
 	PADAPTER	Adapter = pHwData->Adapter;
 
-	if( TS_RUNNING_IN_TESTSTA_MODE )
-		return; // Ignore setting if access right is not owned by NDIS
-
 	hal_set_current_channel_ex( pHwData, channel );
 }
 //---------------------------------------------------------------------------------------------------
@@ -764,12 +761,7 @@ void hal_led_control(  void* S1,  phw_da
 
 	if( pHwData->LED_control ) {
 		ltmp2 = pHwData->LED_control & 0xff;
-		if( ltmp2 < 5 ) // 1 ~ 4 is TS mode
-		{
-			Ts_Led_Control( Adapter );
-			TimeInterval = 20;
-		}
-		else if( ltmp2 == 5 ) // 5 is WPS mode
+		if( ltmp2 == 5 ) // 5 is WPS mode
 		{
 			TimeInterval = 100;
 			ltmp2 = (pHwData->LED_control>>8) & 0xff;
@@ -1110,10 +1102,7 @@ void hal_descriptor_indicate(phw_data_t 
 	if (!pHwData->IsInitOK)
 		return;
 
-	if (TS_RUNNING_IN_TESTSTA_MODE)
-		{ TS_MpduProcess(Adapter, pRxDes); }
-	else
-		{ Mds_MpduProcess(Adapter, pRxDes); }	/* Ouch, MpduProcess has three parameters but we only pass two?! */
+	{ Mds_MpduProcess(Adapter, pRxDes); }	/* Ouch, MpduProcess has three parameters but we only pass two?! */
 }
 
 u8 hal_get_antenna_number(  phw_data_t pHwData )
@@ -1239,9 +1228,6 @@ void hal_set_rf_power(phw_data_t pHwData
 {
 	PADAPTER Adapter = pHwData->Adapter;
 
-	if (TS_RUNNING_IN_TESTSTA_MODE)
-		return; // Ignore setting if access right is not owned by NDIS
-
 	RFSynthesizer_SetPowerIndex( pHwData, PowerIndex );
 }
 
diff --git a/drivers/net/wireless/winbond/winbondport/wblinux.c b/drivers/net/wireless/winbond/winbondport/wblinux.c
index ab7a27c..fd07130 100644
--- a/drivers/net/wireless/winbond/winbondport/wblinux.c
+++ b/drivers/net/wireless/winbond/winbondport/wblinux.c
@@ -209,8 +209,6 @@ #endif
 		// For TS module
 		//
 		InitStep = 2;
-		if (!TS_initial(Adapter))
-			break;
 
 		// For MDS module
 		InitStep = 3;
