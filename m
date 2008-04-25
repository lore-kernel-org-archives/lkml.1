Return-Path: <linux-kernel-owner+w=401wt.eu-S1760384AbYDYOgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760384AbYDYOgu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 10:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754516AbYDYOgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 10:36:41 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:50721 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757866AbYDYOgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 10:36:40 -0400
Date: Fri, 25 Apr 2008 16:37:20 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, kaszak@gmail.com,
       lcostantino@gmail.com, linux-wireless@vger.kernel.org
Subject: w35und: remove warnings
Message-ID: <20080425143720.GB30033@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Remove some warnings.

---
commit b8ad3cb3e88202aea88c7fca3d4adfd1a0940808
tree eddd540a2b5779a95d05d6ad0ed1c2185d075631
parent dde5f03291e3dd8cb1f958134c57cfcd406ab748
author Pavel <pavel@amd.ucw.cz> Fri, 25 Apr 2008 16:35:36 +0200
committer Pavel <pavel@amd.ucw.cz> Fri, 25 Apr 2008 16:35:36 +0200

 .../net/wireless/winbond/winbondport/linux/wbusb.c |    4 +---
 drivers/net/wireless/winbond/winbondport/mds.c     |    8 --------
 drivers/net/wireless/winbond/winbondport/wbhal.c   |    4 ----
 drivers/net/wireless/winbond/winbondport/wblinux.c |    2 --
 4 files changed, 1 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/winbond/winbondport/linux/wbusb.c b/drivers/net/wireless/winbond/winbondport/linux/wbusb.c
index d883873..8c9451a 100644
--- a/drivers/net/wireless/winbond/winbondport/linux/wbusb.c
+++ b/drivers/net/wireless/winbond/winbondport/linux/wbusb.c
@@ -78,7 +78,6 @@ static void wbsoft_configure_filter(stru
 				     unsigned int *total_flags,
 				     int mc_count, struct dev_mc_list *mclist)
 {
-	static const u8 bcast[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
 	unsigned int bit_nr, new_flags;
 	u32 mc_filter[2];
 	int i;
@@ -129,9 +128,8 @@ static int wbsoft_start(struct ieee80211
 
 static int wbsoft_config(struct ieee80211_hw *dev, struct ieee80211_conf *conf)
 {
-	printk("wbsoft_config called\n");
-
 	ChanInfo ch;
+	printk("wbsoft_config called\n");
 
 	ch.band = 1;
 	ch.ChanNo = 1;	/* Should use channel_num, or something, as that is already pre-translated */
diff --git a/drivers/net/wireless/winbond/winbondport/mds.c b/drivers/net/wireless/winbond/winbondport/mds.c
index 743a2f2..66def9b 100644
--- a/drivers/net/wireless/winbond/winbondport/mds.c
+++ b/drivers/net/wireless/winbond/winbondport/mds.c
@@ -219,19 +219,12 @@ Mds_SendComplete(PADAPTER Adapter, PT02_
 {
 	PMDS	pMds = &Adapter->Mds;
 	phw_data_t	pHwData = &Adapter->sHwData;
-	PUCHAR	pTxBuffer;
 	u8	PacketId = (u8)pT02->T02_Tx_PktID;
 	unsigned char	SendOK = TRUE;
 	u8	RetryCount, TxRate;
-	u16	wIndex, wReasonCode;
-
 
 	if (pT02->T02_IgnoreResult) // Don't care the result
 		return;
-    #ifdef _PE_TX_DUMP_
-	WBDEBUG(("###  Tx complete, PacketId =%x, pT02->T02_Tx_PktID =%x\n",
-							PacketId, pT02->T02_Tx_PktID));
-    #endif	
 	if (pT02->T02_IsLastMpdu) {
 		//TODO: DTO -- get the retry count and fragment count
 		// Tx rate
@@ -300,7 +293,6 @@ Mds_HeaderCopy(PADAPTER Adapter, PDESCRI
 {
 	PMDS	pMds = &Adapter->Mds;
 	PUCHAR	src_buffer = pDes->buffer_address[0];//931130.5.g
-	PUCHAR	buffer;
 	PT00_DESCRIPTOR	pT00;
 	PT01_DESCRIPTOR	pT01;
 	u16	stmp;
diff --git a/drivers/net/wireless/winbond/winbondport/wbhal.c b/drivers/net/wireless/winbond/winbondport/wbhal.c
index 6cdc162..1cdd10c 100644
--- a/drivers/net/wireless/winbond/winbondport/wbhal.c
+++ b/drivers/net/wireless/winbond/winbondport/wbhal.c
@@ -211,8 +211,6 @@ void hal_set_current_channel_ex(  phw_da
 //---------------------------------------------------------------------------------------------------
 void hal_set_current_channel(  phw_data_t pHwData,  ChanInfo channel )
 {
-	PADAPTER	Adapter = pHwData->Adapter;
-
 	hal_set_current_channel_ex( pHwData, channel );
 }
 //---------------------------------------------------------------------------------------------------
@@ -867,8 +865,6 @@ void hal_rate_change(  phw_data_t pHwDat
 
 void hal_set_rf_power(phw_data_t pHwData, u8 PowerIndex)
 {
-	PADAPTER Adapter = pHwData->Adapter;
-
 	RFSynthesizer_SetPowerIndex( pHwData, PowerIndex );
 }
 
diff --git a/drivers/net/wireless/winbond/winbondport/wblinux.c b/drivers/net/wireless/winbond/winbondport/wblinux.c
index fd07130..d486508 100644
--- a/drivers/net/wireless/winbond/winbondport/wblinux.c
+++ b/drivers/net/wireless/winbond/winbondport/wblinux.c
@@ -79,8 +79,6 @@ WBLINUX_GetNextPacketCompleted(PADAPTER 
 void
 WBLINUX_Destroy(PADAPTER Adapter)
 {
-	PWBLINUX pWbLinux = &Adapter->WbLinux;
-
 	WBLINUX_stop( Adapter );
 	OS_SPIN_LOCK_FREE( &pWbNdis->SpinLock );
 #ifdef _PE_USB_INI_DUMP_

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
