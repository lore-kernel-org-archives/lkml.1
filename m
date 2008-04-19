Return-Path: <linux-kernel-owner+w=401wt.eu-S1758919AbYDSU32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919AbYDSU32 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 16:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755790AbYDSU3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 16:29:19 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:45024 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755764AbYDSU3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 16:29:16 -0400
Date: Sat, 19 Apr 2008 22:29:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, kaszak@gmail.com,
       lcostantino@gmail.com, linux-wireless@vger.kernel.org
Subject: w35und: remove some more unneccessary code
Message-ID: <20080419202952.GA26630@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can still associate and ping...

diff --git a/drivers/net/wireless/winbond/winbondport/bssdbase.c b/drivers/net/wireless/winbond/winbondport/bssdbase.c
index ffa6f40..e69de29 100644
--- a/drivers/net/wireless/winbond/winbondport/bssdbase.c
+++ b/drivers/net/wireless/winbond/winbondport/bssdbase.c
@@ -1,31 +0,0 @@
-//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-//	bssdbase.c
-//		manage BSS descriptor data base
-//	history :
-//
-//	Description:
-//		BSS descriptor data base will store the information of the stations at the
-//		surrounding environment. The first entry( psBSS(0) ) will not be used and the
-//		second one( psBSS(1) ) will be used for the broadcast address.
-//
-//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-
-
-#include "os_common.h"
-
-//Get an empty BSS descriptor entry
-u16 wBSSGetEntry(PWB32_ADAPTER Adapter)
-{
-	BUG(); /* foo */
-}
-
-u16 wBSSsearchMACaddr(PWB32_ADAPTER Adapter, u8 *pbMacAddr, u8 band)
-{
-	BUG(); /* foo */
-}
-
-// NOTE: return(1) means 'EQ', return(0) means 'NEQ'
-unsigned char boCmpMacAddr( PUCHAR adr1, PUCHAR adr2 )
-{
-	return OS_MEMORY_COMPARE( adr1, adr2, MAC_ADDR_LENGTH );	/* foo */
-}
diff --git a/drivers/net/wireless/winbond/winbondport/ds_tkip.c b/drivers/net/wireless/winbond/winbondport/ds_tkip.c
index de4cc7b..e69de29 100644
--- a/drivers/net/wireless/winbond/winbondport/ds_tkip.c
+++ b/drivers/net/wireless/winbond/winbondport/ds_tkip.c
@@ -1,16 +0,0 @@
-#include "os_common.h"
-
-void
-_append_data( PUCHAR pData, u16 size, tkip_t *p )
-{
-	BUG();
-}
-
-
-void
-Mds_MicFill(  void* p1,  void* p2,  PUCHAR XmitBufAddress )
-{
-	BUG();
-}
-
-
diff --git a/drivers/net/wireless/winbond/winbondport/knl.c b/drivers/net/wireless/winbond/winbondport/knl.c
index 442435c..e69de29 100644
--- a/drivers/net/wireless/winbond/winbondport/knl.c
+++ b/drivers/net/wireless/winbond/winbondport/knl.c
@@ -1,27 +0,0 @@
-//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-//	knl.c
-//		Kernel module
-//	history -- 01/14/03' created 
-//
-//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-#include "os_common.h"
-
-void vKNL_StateMachine(PWB32_ADAPTER Adapter, const K_TRANS** psStateMachineTable,
-                       u16 wStateData, pK_MSG psMsg)
-{
-	const K_TRANS* psStateTableEntry;
-	
-	if (wStateData == K_NULL_STATE)
-		return;
-	psStateTableEntry = psStateMachineTable[wStateData];
-	while ((psStateTableEntry->wMsg != K_NULL_MSG) && (psStateTableEntry->wMsg != psMsg->wMsgType))
-		psStateTableEntry++;
-	if (psStateTableEntry->rActionFunction != K_NULL_ROUTINE)
-		(*psStateTableEntry->rActionFunction)(Adapter, psMsg);
-}
-
-void vProc_Null(PWB32_ADAPTER Adapter, pK_MSG psMsg)
-{
-}
-
-
diff --git a/drivers/net/wireless/winbond/winbondport/knl.h b/drivers/net/wireless/winbond/winbondport/knl.h
index 98f3bd2..e69de29 100644
--- a/drivers/net/wireless/winbond/winbondport/knl.h
+++ b/drivers/net/wireless/winbond/winbondport/knl.h
@@ -1,33 +0,0 @@
-//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-//	knl.h
-//  	Definitions of the kernel 
-//	history -- 01/14/03' created 
-//
-//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-
-
-typedef struct K_MSG
-{
-	u16 wMsgType;
-	u16 wInstance;
-	void *pMsgPtr;
-} K_MSG, *pK_MSG;
-
-typedef void (* K_Trans_Proc)(PWB32_ADAPTER, pK_MSG);
-
-typedef struct K_TRANS
-{
-	u16			wMsg;
-	K_Trans_Proc	rActionFunction;
-} K_TRANS;
-
-#define KNLMSG_RESET					(250)
-#define K_NULL_MSG                      (u16) 0
-#define K_IDLE_STATE					(u16) 0
-#define K_NULL_STATE                    (u16) (~0)
-#define K_NULL_ROUTINE                  (K_Trans_Proc) 0
-
-
-void vKNL_StateMachine(PWB32_ADAPTER, const K_TRANS** psStateMachineTable,
-                       u16 wStateData, pK_MSG psMsg);
-void vProc_Null(PWB32_ADAPTER, pK_MSG);
diff --git a/drivers/net/wireless/winbond/winbondport/linux/new_wireless.c b/drivers/net/wireless/winbond/winbondport/linux/new_wireless.c
index f98def1..e69de29 100644
--- a/drivers/net/wireless/winbond/winbondport/linux/new_wireless.c
+++ b/drivers/net/wireless/winbond/winbondport/linux/new_wireless.c
@@ -1,67 +0,0 @@
-/*************
-
-new_wireless.c, written from dispatch.c by lconstano, some cleanups by scythe
-
-*************/
-
-#include "sysdef.h"
-#include "new_wireless.h"
-
-//Only used here
-//Would generate warnings for other obj if defined static in a header
-//Would not be linkable in not defined static but in a header
-static int wl3501_chan2freq[] =
-{
-   [0]  = 2412, [1]  = 2417, [2]  = 2422, [3]  = 2427, [4] = 2432,
-   [5]  = 2437, [6]  = 2442, [7]  = 2447, [8]  = 2452, [9] = 2457,
-   [10] = 2462, [11] = 2467, [12] = 2472, [13] = 2477,
-};
-
-// channel number -> channel freq.
-void ChannelNumToFreq(u8 NetworkType, u8 ChannelNumber, u32 *freq)
-{
-	//freq : MHz
-	*freq = wl3501_chan2freq[ChannelNumber] * 100000;
-
-	return; //???? What the hack is this?
-	switch ( NetworkType)
-	{
-	case BAND_TYPE_DSSS:
-	case BAND_TYPE_OFDM_24:
-		if (ChannelNumber <=13)
-			*freq = 2407 + ChannelNumber*5;
-		else
-			*freq = 2484;
-		break;
-	case BAND_TYPE_OFDM_5:
-		if (ChannelNumber <= 161)
-			*freq = 5000 + ChannelNumber*5;
-		else
-			*freq = 4000 + ChannelNumber*5;
-		break;
-	default:
-		break;
-	}
-}
-
-// channel freq. -> channel number, freq in MHz
-void FreqToChannelNum(u8 Band, u8 *ChannelNumber, u32 freq)
-{
-	switch ( Band ) {
-	case BAND_TYPE_DSSS:
-	case BAND_TYPE_OFDM_24:
-		if (freq < 2484)
-			*ChannelNumber = (u8)((freq-2407)/5);
-		else
-			*ChannelNumber = 14;
-		break;
-	case BAND_TYPE_OFDM_5:
-		if (freq < 4920)
-			*ChannelNumber = (u8)((freq-5000)/5);
-		else
-			*ChannelNumber = (u8)((freq-4000)/5);
-		break;
-	default:
-		break;
-	}
-}
diff --git a/drivers/net/wireless/winbond/winbondport/mds.c b/drivers/net/wireless/winbond/winbondport/mds.c
index 97a978a..743a2f2 100644
--- a/drivers/net/wireless/winbond/winbondport/mds.c
+++ b/drivers/net/wireless/winbond/winbondport/mds.c
@@ -223,7 +223,6 @@ Mds_SendComplete(PADAPTER Adapter, PT02_
 	u8	PacketId = (u8)pT02->T02_Tx_PktID;
 	unsigned char	SendOK = TRUE;
 	u8	RetryCount, TxRate;
-	K_MSG	sSmeMsg;
 	u16	wIndex, wReasonCode;
 
 
diff --git a/drivers/net/wireless/winbond/winbondport/mlme_assoc.c b/drivers/net/wireless/winbond/winbondport/mlme_assoc.c
index 0271bf6..e69de29 100644
--- a/drivers/net/wireless/winbond/winbondport/mlme_assoc.c
+++ b/drivers/net/wireless/winbond/winbondport/mlme_assoc.c
@@ -1,46 +0,0 @@
-////////////////////////////////////////////////////////////
-//
-// association.c
-// PE23 20021023 update algorithm
-// These functions will handle all the association-related messages. This
-// includes, association, reassociation and disassociation.
-//
-///////////////////////////////////////////////////////////////
-
-#include "os_common.h"
-
-//===========================================================================
-//  SendAssociationRequest --
-//
-//  Description:
-//    Send the association request frame or reassociation request to the AP.
-//
-//  Arguments:
-//    Adapter       - The pointer to the Miniport Adapter Context
-//    peerSTAAddress- The Address of the peer STA (acting as an AP) that is
-//                    desired to associate with.
-//    capabilityInfo- Capability information in the Asso. request. To report
-//                    this STA capability.
-//    ListenInterval- The number of beacon intervals that may pass before this
-//                    STA awakens and listerns for the next beacon.
-//
-//  Return Value:
-//   -1     - Failed to send.
-//    1     - Has sent to the Tx handler
-//============================================================================
-s8 SendAssociationRequest(PWB32_ADAPTER   Adapter,
-                            u16          iMSindex,
-                            unsigned char Reasso)
-{	BUG();
-}
-
-//===========================================================================
-//  SendDisassociation -- for DUT test only
-//  Implement like SendDeauthentication()
-//============================================================================
-s8 SendDisassociation(PWB32_ADAPTER   Adapter,
-                        u16 			iMSindex,
-                        u16        	reasonCode)
-{	BUG();
-}
-
diff --git a/drivers/net/wireless/winbond/winbondport/mlme_auth.c b/drivers/net/wireless/winbond/winbondport/mlme_auth.c
index a387bba..e69de29 100644
--- a/drivers/net/wireless/winbond/winbondport/mlme_auth.c
+++ b/drivers/net/wireless/winbond/winbondport/mlme_auth.c
@@ -1,9 +0,0 @@
-// Authentication.c - this processes and creates authentication messages
-// PE23 20021023 update algorithm
-// the authentication frame body structure contains space for the first 3
-// elements of each authentication frame (algorithm type, sequence # and status
-// code). The following bits will have, if present, algorithm specific infor-
-// mation (like a challenge sequence)
-
-#include "os_common.h"
-
diff --git a/drivers/net/wireless/winbond/winbondport/mlme_f.h b/drivers/net/wireless/winbond/winbondport/mlme_f.h
index 4e04ea9..e69de29 100644
--- a/drivers/net/wireless/winbond/winbondport/mlme_f.h
+++ b/drivers/net/wireless/winbond/winbondport/mlme_f.h
@@ -1,48 +0,0 @@
-//
-// MLME task global functions
-//
-
-
-/////////////////////////////////////////////////////////////////////////////
-//Global Functions
-extern unsigned char MLME_Init(PWB32_ADAPTER);
-extern void MLME_Halt(PWB32_ADAPTER);
-extern void MLME_Stop( PWB32_ADAPTER Adapter);
-extern void MLME_Entry(PWB32_ADAPTER , pK_MSG);
-extern void MLME_initState(PWB_BSSDESCRIPTION);
-extern void MLME_IBSSinitState(PWB32_ADAPTER Adapter);
-extern void MLME_findSTA(PWB_BSSDESCRIPTION);
-extern void MLME_JoinCfm(PWB_BSSDESCRIPTION psBSS, u8 BssType);
-//extern unsigned char boMLME_InactiveState(PWB_BSSDESCRIPTION);
-//extern unsigned char boMLME_IdleScanState(PWB_BSSDESCRIPTION);
-//extern unsigned char boMLME_FoundSTAinfo(PWB_BSSDESCRIPTION);
-extern void vMlmeTimerStop(PWB32_ADAPTER Adapter, u16 wIdx);
-#ifdef _IBSS_BEACON_SEQ_STICK_
-extern void vMlmeTimerStart(PWB32_ADAPTER Adapter, u16 wIdx, u32 timeout_value);
-#endif
-extern int SendProbeRequest(PWB32_ADAPTER Adapter, struct SSID_Element *SSID);
-
-extern s8 SendAuthenticationRequest(PWB32_ADAPTER    Adapter,
-                               u16              iMSindex,
-                               u16             wAuthenType,
-                               u16             wAuthenSeqNum,
-                               u16             wStatus,
-                               PUCHAR           ChallengeText);
-extern s8 SendDeauthentication(PWB32_ADAPTER Adapter,
-                          u16 iMSindex,
-                          u16 reasonCode);
-s8 SendAssociationRequest(PWB32_ADAPTER   Adapter,
-                            u16             iMSindex,
-                            unsigned char         Reasso);//added by ws 07/22/04
-                            
-/*int SendReassociationRequest(PWB32_ADAPTER Adapter,
-                             int         iMSindex);*/
-                           //  omint by ws 07/22/04
-                             
-s8 SendDisassociation(PWB32_ADAPTER   Adapter,
-                        u16 			iMSindex,
-                        u16        	reasonCode);
-
-#define CardGetChallengeText( _AA_ , _BB_ )
-
-
diff --git a/drivers/net/wireless/winbond/winbondport/mlmetask.c b/drivers/net/wireless/winbond/winbondport/mlmetask.c
index aaaf88d..e69de29 100644
--- a/drivers/net/wireless/winbond/winbondport/mlmetask.c
+++ b/drivers/net/wireless/winbond/winbondport/mlmetask.c
@@ -1,10 +0,0 @@
-//NOTE: Check if the order of necessary operations and state modificaton in every
-//		action is correct --WKCHEN 4/17/03'
-
-//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-//	MlmeModule.c
-//		MLME module
-//	history -- 01/14/03' created 
-//
-//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-#include "os_common.h"
diff --git a/drivers/net/wireless/winbond/winbondport/mlmetxrx.c b/drivers/net/wireless/winbond/winbondport/mlmetxrx.c
index f58e458..7dea640 100644
--- a/drivers/net/wireless/winbond/winbondport/mlmetxrx.c
+++ b/drivers/net/wireless/winbond/winbondport/mlmetxrx.c
@@ -126,7 +126,6 @@ void
 MLME_SendComplete(PADAPTER Adapter, u8 PacketID, unsigned char SendOK)
 {
 	MLME_TXCALLBACK	TxCallback;
-	K_MSG		sMlmeMsg;
 	u8		DataTmp[200];
 
 	memcpy(DataTmp, Adapter->sMlmeFrame.pMMPDU, Adapter->sMlmeFrame.len);
@@ -140,7 +139,6 @@ MLME_SendComplete(PADAPTER Adapter, u8 P
 	MLMEfreeMMPDUBuffer( Adapter, Adapter->sMlmeFrame.pMMPDU );
 
 
-	sMlmeMsg.wMsgType = MLMEMSG_TX_CALLBACK;
 	//TxCallback.wFrameType = pData[0];  //&0xf0;
 	//TODO : ?? The pData has been returned, but we still use it to know what kind
 	//			of mlme frame it is. Will it be dangerous??
@@ -185,117 +183,7 @@ MLMERcvFrame(
      u8             NumOfBuffer,
      u8            SlotIndex)
 {
-    s32     i, FreeSlot, FrameSize;
-	K_MSG	sMsg;
-	RXDATA	sRxFrameData;
-	#ifdef _IBSS_BEACON_SEQ_STICK_
-	unsigned char	boIsProbeReq = FALSE;
-	#endif
-
-    if (pRxBufferArray == NULL || NumOfBuffer == 0)   {
-        // Invalid parameters
-        return;
-    }
-
-    if (Adapter->sMlmeFrame.wNumRxMMPDUInMLME >= MAX_NUM_RX_MMPDU ||
-         pRxBufferArray->pBufferAddress == NULL)   {
-        // Exceeding the number of MMPDUs allowed in the MLME module
-        Adapter->sMlmeFrame.wNumRxMMPDUDiscarded ++;
-        return;
-    }
-
-    Adapter->sMlmeFrame.wNumRxMMPDUInMLME ++;
-    for (i = 0; i < MAX_NUM_RX_MMPDU; i++)   {
-        // To find an free slot to store the info.
-        if (Adapter->sMlmeFrame.SaveRxBufSlotInUse[i] == FALSE)
-            break;
-    }
-    if (i >= MAX_NUM_RX_MMPDU) {
-        // Should not occur.
-        Adapter->sMlmeFrame.wNumRxMMPDUInMLME --;
-        return;
-    }
-    FreeSlot = i;
-    Adapter->sMlmeFrame.SaveRxBufSlotInUse[FreeSlot]      = TRUE;
-
-    //=================================================
-    // Collect the frame data in the buffer segments
-    // into a single data buffer
-    //=================================================
-    FrameSize = 0;
-    for (i = 0; i < (s32) NumOfBuffer; i++)
-	{
-        if (FrameSize + pRxBufferArray->BufferSize > MAX_MMPDU_SIZE    ||
-             pRxBufferArray->pBufferAddress == NULL)
-		{
-            // Discard the management frame larger than MAX_MMPDU_SIZE
-            // Should increase the current MAX_MMPDU_SIZE if exists such MMPDU
-            //
-            Adapter->sMlmeFrame.wNumRxMMPDUInMLME --;
-            Adapter->sMlmeFrame.SaveRxBufSlotInUse[FreeSlot] = FALSE;
-            Adapter->sMlmeFrame.wNumRxMMPDUDiscarded ++;
-            return;
-        }
-        ///NdisMoveMemory(&Adapter->sMlmeFrame.RxMMPDU[FreeSlot][FrameSize],
-        memcpy( &Adapter->sMlmeFrame.RxMMPDU[FreeSlot][FrameSize],
-                        pRxBufferArray->pBufferAddress,
-                        pRxBufferArray->BufferSize);
-        FrameSize = FrameSize + pRxBufferArray->BufferSize;
-        pRxBufferArray ++;                    // Pointer to next buffer segment
-    }
-	#ifdef _PE_RX_DUMP_
-	//	WBDEBUG(("RX: Receive len in mlme =%d\n", FrameSize));
-	#endif
-    //======================
-	// MLME data processing
-    //======================
-    Adapter->sMlmeFrame.wNumRxMMPDU ++;
-
-	sRxFrameData.pbFramePtr = Adapter->sMlmeFrame.RxMMPDU[FreeSlot];
-	sRxFrameData.FrameLength = FrameSize;
-	sMsg.wInstance = SlotIndex;
-	sMsg.pMsgPtr = &sRxFrameData;
-	if ((sRxFrameData.pbFramePtr[0]&0xf0) == MAC_SUBTYPE_MNGMNT_BEACON)
-	{
-	}
-	else if ((sRxFrameData.pbFramePtr[0]&0xf0) == MAC_SUBTYPE_MNGMNT_PROBE_RESPONSE)
-	{
-	}
-	//else if ((sRxFrameData.pbFramePtr[0]&0xf0) != MAC_SUBTYPE_MNGMNT_PROBE_REQUEST) // ignore Probe_Req
-	//{
-	//	sMsg.wMsgType = MLMEMSG_RCV_MLMEFRAME;
-	//	MLME_Entry(Adapter, &sMsg);
-	//}
-	else if ((sRxFrameData.pbFramePtr[0]&0xf0) == MAC_SUBTYPE_MNGMNT_PROBE_REQUEST) // ignore Probe_Req
-	{
-		#ifdef _IBSS_BEACON_SEQ_STICK_
-		boIsProbeReq = TRUE;
-		#endif
-	}
-	else// if ((sRxFrameData.pbFramePtr[0]&0xf0) != MAC_SUBTYPE_MNGMNT_PROBE_REQUEST) // ignore Probe_Req
-	{
-	}
-
-    // Note: NDIS driver does not support such function. Reclaim the received
-    // packet resource to the MDS part immediately.
-    Adapter->sMlmeFrame.wNumRxMMPDUInMLME --;
-    Adapter->sMlmeFrame.SaveRxBufSlotInUse[FreeSlot] = FALSE;
-	#ifdef _IBSS_BEACON_SEQ_STICK_
-	if (boIsProbeReq)
-	{
-		if ((psSME->wDesiredJoinBSS != 0) &&
-			//(Adapter->Mds.TxToggle == FALSE) &&
-			(psBSS(psSME->wDesiredJoinBSS)->bBssType == IBSS_NET))
-		{
-			if ((psLOCAL->wConnectedSTAindex != 0) &&
-				(Adapter->Mds.TxToggle == TRUE))
-				return;
-			//SendBCNullData(Adapter, psSME->wDesiredJoinBSS);
-			//vMlmeTimerStart(Adapter, 1, 100);	//100ms, utilize the timer of psBSS(1)
-			vMlmeTimerStart(Adapter, 1, 300);	//300ms, utilize the timer of psBSS(1)
-		}
-	}
-	#endif
+	BUG();
     return;
 }
 
diff --git a/drivers/net/wireless/winbond/winbondport/rxisr.c b/drivers/net/wireless/winbond/winbondport/rxisr.c
index 40c4f55..33dfd23 100644
--- a/drivers/net/wireless/winbond/winbondport/rxisr.c
+++ b/drivers/net/wireless/winbond/winbondport/rxisr.c
@@ -1,178 +1,5 @@
 #include "os_common.h"
 
-void DataDmp(u8 *pdata, u32 len, u32 offset)
-{
-	u8      dbg_str[140];
-	u32     i, j, n;
-	u8      c;
-	u8      *p;
-
-	for (i = 0; i < len; i += 16)
-	{
-		p = dbg_str;
-
-		//--------------------------------------------------------------------
-		// Output the offset header
-		n = offset + i;
-
-		for (j=0; j<4; j++)
-		{
-			c = (u8) (n % 16);
-			p[3-j] =  (c >= 10) ? 'A'+(c-10) : '0'+c;
-			n >>= 4 ;
-		}
-		p+= 4;
-
-		*p++ = ':';
-		*p++ = ' ';
-
-		//--------------------------------------------------------------------
-		// Output the hex bytes
-		for (j = i; j < (i+16); j++)
-		{
-			if (j < len)
-			{
-				c = *(pdata+j) / 16 ;
-				*p++ = (c >= 10) ? 'A'+(c-10) : '0'+c;
-
-				c = *(pdata+j) % 16 ;
-				*p++ = (c >= 10) ? 'A'+(c-10) : '0'+c;
-
-				*p++ = ' ';
-			}
-			else
-			{
-				*p++ = ' ';
-				*p++ = ' ';
-				*p++ = ' ';
-			}
-		}
-
-		*p++ = ' ';
-		*p++ = ' ';
-
-		//--------------------------------------------------------------------
-		// Output the ASCII bytes
-		for (j = i; j < (i+16); j++)
-		{
-			if (j < len)
-			{
-				c = *(pdata+j);
-				*p++ = (! isprint(c)) ? '.' : c;
-
-			}
-			else
-			{
-				*p++ = ' ';
-			}
-		}
-
-		*p++ = '\n';
-		*p++ = '\0';
-
-		WBDEBUG(("%s", dbg_str));
-
-	}
-}
-
-
-void Mds_MsduProcess(  PWB32_ADAPTER Adapter,  PRXLAYER1 pRxLayer1,  u8 SlotIndex)
-{
-	struct MAC_frame_control frame_control;
-	struct Data_Frame* pDFrame;
-	PUCHAR			SourceAddress;
-	PUCHAR			BufAddr;
-	u16			BufSize;
-	u16			_8023FrameSize, Temp;
-	unsigned char			WEPed;
-	u8			i;
-	u8	mic[8];
-	PUCHAR	mic_key = NULL, pframe_mic;
-	u8	LastBufIdx;
-
-	// Is management frame??
-	if (pRxLayer1->FrameType != MAC_TYPE_DATA) {
-		// Call MLME function
-   		MLMERcvFrame(Adapter, pRxLayer1->BufferQueue, pRxLayer1->BufferNumber, SlotIndex); //The last parameter is needed for SME.
-		return;
-	}
-
-	// Checking this packet(802.3), if valid for Filter. Just discard the frame if the media is disconnected.
-	if (!CURRENT_LINK_ON)
-		return;
-
-	pDFrame = (struct Data_Frame*) pRxLayer1->BufferQueue[0].pBufferAddress;
-	Temp = (*(PUSHORT)pRxLayer1->BufferQueue[0].pBufferAddress);
-	memcpy( &frame_control, &Temp, sizeof(u16) );
-	WEPed = frame_control.WEP ? TRUE : FALSE;
-	if( (!WEPed && !MLMEGetExcludeUnencrypted(Adapter))) {
-		// TODO: check if there is a MIC err
-		/**/
-
-
-		//--------------------------------------------
-		//    Convert 802.11 frame to 802.3 frame
-		//--------------------------------------------
-
-		// Updating the MSDU counter 'GS_RCV_OK'
-		MIB_GS_RCV_OK_INC;
-
-		// Get the Source address
-		SourceAddress = pDFrame->Addr3;
-		if (!frame_control.from_ds)
-			SourceAddress = pDFrame->Addr2;
-
-		BufSize = pRxLayer1->BufferQueue[0].BufferSize;
-		BufAddr = pRxLayer1->BufferQueue[0].pBufferAddress;
-
-		// Point to the frame body
-		BufAddr += (DOT_11_TYPE_OFFSET - ETH_LENGTH_OF_ADDRESS); // offset 24 is 4n alignment @@
-
-		// PD43 20021220 Added for Type/Length encapsulation adjust
-		if (*(PULONG)BufAddr==cpu_to_le32(0x0003aaaa)      && // little endian // @@ 4n alignment here
-			*(PULONG)(BufAddr+4)!=cpu_to_le32(0x37810000)  && //PD43 20030418 Modified for HCT 11 // @@ 4n alignment here
-			(*(PUSHORT)(BufAddr+4)==0 || *(PUSHORT)(BufAddr+4)==cpu_to_le16(0xf800)) ) // @@ 4n alignment here
-		{
-			// Converted to Type-encapsulated 802.3 frame.
-			// Do nothing here
-			pRxLayer1->TypeEncapsulated = TRUE;
-			pRxLayer1->BufferQueue[0].BufferSize -= 18;
-		} else {
-			// Converted to Length-encapsulated 802.3 frame.
-			// Reserved 2 bytes for length field.
-			BufAddr -= (2 + ETH_LENGTH_OF_ADDRESS);
-			pRxLayer1->TypeEncapsulated = FALSE;
-			pRxLayer1->BufferQueue[0].BufferSize -= 10;
-		}
-
-		memcpy( BufAddr, SourceAddress, MAC_ADDR_LENGTH );
-
-		// Copy DA
-		BufAddr -= ETH_LENGTH_OF_ADDRESS;
-		SourceAddress = pRxLayer1->BufferQueue[0].pBufferAddress + DOT_11_DA_OFFSET;
-		memcpy( BufAddr, SourceAddress, MAC_ADDR_LENGTH );
-		pRxLayer1->BufferQueue[0].pBufferAddress = BufAddr;
-
-		// Is 802.3 frame format?
-		if (!pRxLayer1->TypeEncapsulated) {
-			_8023FrameSize = 0; // PD43 20021220 Added
-			for (i=0; i<pRxLayer1->BufferNumber; i++) {
-				BufSize = pRxLayer1->BufferQueue[i].BufferSize;
-				_8023FrameSize += BufSize;
-			}
-
-			//modify the length field
-			_8023FrameSize -= (6 + 6 + 2);  // DA + SA + Type/Len
-			Temp            = (_8023FrameSize & 0xff00) >> 8;
-			_8023FrameSize  = (_8023FrameSize << 8) | Temp;
-			*((PUSHORT)&pRxLayer1->BufferQueue[0].pBufferAddress[12]) = cpu_to_le16(_8023FrameSize); // YY's endian
-		}
-
-		// Indicate to Upper Module
-		Adapter->sLocalPara._NumRxMSDU++; // A packet be indicated
-	}
-}
-
 void vRxTimerInit(PWB32_ADAPTER Adapter)
 {
 	OS_TIMER_INITIAL(&(Adapter->Mds.nTimer), (void*) RxTimerHandler, (void*) Adapter);
@@ -201,255 +28,3 @@ void RxTimerHandler(void* SystemSpecific
 {
 	WARN_ON(1);
 }
-
-// For efficiency, the routine supports packet indicating asynchronous.
-// If the Descriptor status macro DESCRIPTOR_STATUS_RESOURCES is true.
-// the asynchronous indicating can be achieved.
-void Mds_MpduProcess(  PWB32_ADAPTER Adapter,  PDESCRIPTOR pRxDes )
-{
-	struct Data_Frame* pDataFrame;
-	phw_data_t	pHwData = &Adapter->sHwData;
-	PUCHAR		pBufferAddress;
-	PUCHAR		pMyMACAddr;
-	PRXLAYER1	pRxLayer1;
-	u16		BufferSize;
-	u16		FrameArrivedTime;
-	u16		SequenceNumber;
-	u8		FragmentNumber;
-	u8		ReturnSlotIndex;
-	u8		i;
-
-	#ifdef _PE_RX_DUMP_
-	if ( *((PUCHAR)pRxDes->buffer_address[0]) == 0x08) {
-		ChanInfo ChanTmp;
-
-		WBDEBUG(("$$$$$ DUMP RX MPDU $$$$$\n"));
-		hal_get_current_channel(&Adapter->sHwData, &ChanTmp);
-		WBDEBUG(("ChanNo = %d, ChanBand =%d \n", ChanTmp.ChanNo, ChanTmp.band));
-		for (i=0; i<pRxDes->buffer_number; i++)
-		{
-			DataDmp(pRxDes->buffer_address[i], pRxDes->buffer_size[i], 0);
-		}
-	}
-	#endif
-
-	FrameArrivedTime = DESCRIPTOR_RX_RECEIVE_TIME( pRxDes );
-	pBufferAddress = pRxDes->buffer_address[0];// Get the first buffer for processing
-	pDataFrame = pRxDes->buffer_address[0];// Get the first buffer for processing
-	BufferSize = pRxDes->buffer_size[0];
-
-	do
-	{
-		// 911014.1 Checking for frame if receive fail
-		if( DESCRIPTOR_RX_STATUS_ERROR( pRxDes ) )
-		{
-			u16 seq;
-			seq = cpu_to_le16(*(PUSHORT)(pBufferAddress+22));  //20060926 anson's endian
-			seq >>= 4;
-			#ifdef _PE_RX_DUMP_
-			WBDEBUG(("Rx[%d] flag err = %x\n", seq, pRxDes->R01.value));
-			#endif
-			Adapter->sLocalPara.GS_RCV_ERROR++;
-			//TODO:
-			pHwData->rx_err_count[0]++;
-			break;
-		}
-		else
-		{
-			pHwData->rx_ok_count[0]++;
-		}
-
-		// Not a Management or Data frame
-		i = pDataFrame->frame_control.mac_frame_info;
-		if( ((i&0x0f)!=MAC_TYPE_MANAGEMENT) && (i!=MAC_TYPE_DATA) )
-		{
-			#ifdef _PE_RX_DUMP_
-			WBDEBUG(("Rx Not a Management and Data(Null) frame. Type=%x\n", i));
-			#endif
-			break;
-		}
-
-		// Is a station role
-		if( pDataFrame->frame_control.to_ds )
-		{
-			#ifdef _PE_STATE_DUMP_
-			WBDEBUG(("Rx not a station role\n"));
-			#endif
-			#ifdef _PE_RX_DUMP_
-			//[WK DUMP]
-			WBDEBUG(("$$$$$ DUMP ERR RX MPDU $$$$$\n"));
-			for (i=0; i<pRxDes->buffer_number; i++)
-			{
-				DataDmp(pRxDes->buffer_address[i], pRxDes->buffer_size[i], 0);
-			}
-			#endif
-			break;
-		}
-
-		// Get the SA from incoming frame
-		pMyMACAddr = pDataFrame->Addr2;
-
-		// Searching the SA in the Descriptor database
-		if ((ReturnSlotIndex=(u8)wBSSsearchMACaddr(Adapter, pMyMACAddr, psLOCAL->CurrentChan.band)) == 0)
-		{
-			#ifdef _PE_STATE_DUMP_
-			WBDEBUG(("$$$ New Idx, band =%d\n", psLOCAL->CurrentChan.band));
-			DataDmp( pMyMACAddr, 6, 0);
-			#endif
-
-			if ((ReturnSlotIndex=(u8)wBSSGetEntry(Adapter)) == 0)
-				break;	// Dropt
-			else
-			{
-				memcpy( psBSS(ReturnSlotIndex)->abPeerAddress, pMyMACAddr, MAC_ADDR_LENGTH );
-
-				//if( HAL_HW_VERSION( pHwData ) < 0x200 ) // For FA
-					psBSS(ReturnSlotIndex)->band = psLOCAL->CurrentChan.band;
-				//else
-				//{
-				//	if (DESCRIPTOR_RX_STATUS_BAND(pRxDes))
-				//		psBSS(ReturnSlotIndex)->band = BAND_TYPE_OFDM_5;
-				//	else
-				//		psBSS(ReturnSlotIndex)->band = BAND_TYPE_OFDM_24;
-				//}
-			}
-		}
-		pRxLayer1 = &psBSS(ReturnSlotIndex)->RxLayer1;
-
-
-
-		// Get the frame information
-		FragmentNumber = cpu_to_le16( pDataFrame->Sequence_Control ) & MASK_FRAGMENT_NUMBER ;//20060926 anson's endian
-		SequenceNumber = cpu_to_le16( pDataFrame->Sequence_Control ) >> SEQUENCE_NUMBER_SHIFT; //20060926 anson's endian
-
-		// Is Sequence Number match?
-		if( SequenceNumber == pRxLayer1->SequenceNumber )
-		{
-			if( pRxLayer1->DeFragmentNumber > FragmentNumber )
-				Adapter->sLocalPara._dot11FrameDuplicateCount ++;
-
-			// Is Fragment Number match
-			if( pRxLayer1->InUsed ) //910829.2 If waiting for another Fragment
-			{
-				if( pRxLayer1->DeFragmentNumber != FragmentNumber )
-					break;
-			}
-			else
-			{
-				// 20061004 For fix intel 3945 ABG 's bug
-				i = pBufferAddress[0] & 0xfc;
-				if( ( i != 0x80 ) && // Not a beacon
-					( i != 0x50 ) && // Not a probe response
-					//[20041005 wkchen]
-					//89c35 H/W will lanuch probe responses with zero sequence number.
-					//So if the peer BSS is 89c35 device, we may mis-judge and drop probe responses
-					//when the BSS descriptor entry is newly allocated.
-					( (pRxLayer1->LastFrameType&0xfc) != 0x80 ) ) // Last time received does not a beacon
-					break;
-			}
-		}
-		else
-		{
-			if( FragmentNumber )
-				break; //910923.8 Add this condition checking
-
-			if( pRxLayer1->InUsed )// Return resource
-			{
-//				pRxLayer1->BufferQueue[0].BufferSize = 0;
-			}
-
-			// Updating RxLayer1
-			pRxLayer1->SequenceNumber = SequenceNumber;
-		}
-
-		pRxLayer1->LastFrameType = pBufferAddress[0]; // 20061004 For fix intel 3945's bug
-
-		// 910918.5 Store the fragment flag
-		pRxLayer1->InUsed = pDataFrame->frame_control.more_frag;
-		pRxLayer1->FrameType = pDataFrame->frame_control.mac_frame_info & MASK_PROTOCOL_VERSION_TYPE;
-
-		//-------------------------------------------------------------------
-		// Frame has passed the entire check. Fill information into RxLayer1
-		//-------------------------------------------------------------------
-		//psBSS(ReturnSlotIndex)->HalRssi = pRxDes->R01.value;// Update RSSI
-		//ws added for wep error detection in 02/02/05
-		
-        if( boCmpMacAddr( pDataFrame->Addr3, Adapter->sLocalPara.ThisMacAddress ) )
-                Adapter->sLocalPara.bToSelfPacketReceived = TRUE;
-
-		psBSS(ReturnSlotIndex)->HalRssi[psBSS(ReturnSlotIndex)->HalRssiIndex++] = pRxDes->R01.value;// Update RSSI
-		psBSS(ReturnSlotIndex)->HalRssiIndex %= MAX_ACC_RSSI_COUNT;
-
-		if( FragmentNumber ) // Cut the 802.11 header
-		{
-			pBufferAddress += DOT_11_DATA_OFFSET;
-			BufferSize -=  DOT_11_DATA_OFFSET;
-			pRxLayer1->BufferTotalSize += BufferSize;
-		}
-		else
-		{
-			pRxLayer1->DecryptionMethod = DESCRIPTOR_RX_DECRYPTION_METHOD( pRxDes );
-			pRxLayer1->FirstFrameArrivedTime = FrameArrivedTime;// Update the First frame arrived time
-			pRxLayer1->DeFragmentNumber = 0;
-			pRxLayer1->BufferNumber = 0;
-			pRxLayer1->BufferTotalSize = BufferSize;
-		}
-
-		//Update total number of buffer
-		pRxLayer1->DeFragmentNumber++;
-
-		// Copy data into buffer, if fragmental frame
-		if( pDataFrame->frame_control.more_frag )
-		{
-			if( !FragmentNumber )
-			{
-				pRxLayer1->ReservedBufferPoint = pRxLayer1->ReservedBuffer;//Initial the point for reserved zone
-				pRxLayer1->BufferQueue[0].pBufferAddress = pRxLayer1->ReservedBuffer;
-				pRxLayer1->BufferQueue[0].BufferSize = 0;
-				pRxLayer1->BufferNumber = 1;
-			}
-
-			pRxLayer1->BufferQueue[0].BufferSize += BufferSize;
-			memcpy( pRxLayer1->ReservedBufferPoint, pBufferAddress, BufferSize );
-			pRxLayer1->ReservedBufferPoint += BufferSize; //Move to the next available start address
-		}
-		else
-		{
-			// 802.11 MSDU Complete
-			if( FragmentNumber )
-			{
-				// To ensure that all the fragment are in one buffer.
-				memcpy( pRxLayer1->ReservedBufferPoint, pBufferAddress, BufferSize );
-				pRxLayer1->BufferQueue[0].BufferSize += BufferSize;
-			}
-			else
-			{
-				pRxLayer1->BufferQueue[0].pBufferAddress = pBufferAddress;
-				pRxLayer1->BufferQueue[0].BufferSize = BufferSize;
-				pRxLayer1->BufferNumber = 1;
-			}
-
-			// PD43 20030117 Added for evaluating whether the remote STA has entered the PS mode.
-			psBSS(ReturnSlotIndex)->PowerSaveMode = FALSE;
-			if( pDataFrame->frame_control.pwr_mgt )
-				psBSS(ReturnSlotIndex)->PowerSaveMode = TRUE;
-
-
-			if( (FrameArrivedTime - pRxLayer1->FirstFrameArrivedTime) < 1000 )//For IS89C35 = 1sec
-			{
-				// Packet processing
-				Mds_MsduProcess( Adapter, pRxLayer1, ReturnSlotIndex);
-			}
-			else
-			{
-				#ifdef _PE_STATE_DUMP_
-				WBDEBUG(("!!RX Error!!: excess the max receive life time\n"));
-				#endif
-			}
-		}
-
-		return;
-	}while(FALSE);
-}
-
-
diff --git a/drivers/net/wireless/winbond/winbondport/scan_f.h b/drivers/net/wireless/winbond/winbondport/scan_f.h
index 833b835..e69de29 100644
--- a/drivers/net/wireless/winbond/winbondport/scan_f.h
+++ b/drivers/net/wireless/winbond/winbondport/scan_f.h
@@ -1,14 +0,0 @@
-//
-// SCAN task global functions
-//
-
-
-/////////////////////////////////////////////////////////////////////////////
-//Global Functions
-extern void Scan_Init(PWB32_ADAPTER Adapter);
-extern void Scan_ResetPara(PWB32_ADAPTER Adapter);
-extern void Scan_Entry(PWB32_ADAPTER Adapter, K_MSG* psScanMsg);
-extern void SCAN_Halt(PWB32_ADAPTER Adapter);
-extern void Scan_Stop(PWB32_ADAPTER Adapter);
-extern void vScanTimerStop(PWB32_ADAPTER Adapter);
-extern void Scan_SetScanChanRange(PWB32_ADAPTER Adapter, psSCAN_REQ_PARA pScanPara);
diff --git a/drivers/net/wireless/winbond/winbondport/scan_probe.c b/drivers/net/wireless/winbond/winbondport/scan_probe.c
index 16bc366..e69de29 100644
--- a/drivers/net/wireless/winbond/winbondport/scan_probe.c
+++ b/drivers/net/wireless/winbond/winbondport/scan_probe.c
@@ -1,22 +0,0 @@
-//============================================================================
-//  PROBE.C -
-//
-//  Description:
-//
-//  Revision history:
-//  --------------------------------------------------------------------------
-//           200209    UN20 Frank
-//                     Initial release
-//           200211    PD43 Austin Liu
-//                     Modify for HW-MAC version
-//
-//  Copyright (c) 2002 Winbond Electronics Corp. All rights reserved.
-//============================================================================
-#include "os_common.h"
-
-//============================================================================
-int SendProbeRequest(PWB32_ADAPTER Adapter, struct SSID_Element *SSID)
-{
-	BUG();
-}
-
diff --git a/drivers/net/wireless/winbond/winbondport/sme_f.h b/drivers/net/wireless/winbond/winbondport/sme_f.h
index 631e113..e69de29 100644
--- a/drivers/net/wireless/winbond/winbondport/sme_f.h
+++ b/drivers/net/wireless/winbond/winbondport/sme_f.h
@@ -1,45 +0,0 @@
-// NOTE : 1.Scan parameters in the SME_PARAMETERS need to be seperated
-//          by using the data structure
-// 		  2.How the SME module know the description index of the connected
-//			STA?
-//			->MLME supplies a function call  
-
-//
-// SME task global functions
-//
-
-
-/////////////////////////////////////////////////////////////////////////////
-//Global Functions
-extern void SME_Init(PWB32_ADAPTER);
-extern void SME_ResetPara(PWB32_ADAPTER);
-extern void SME_Entry(PWB32_ADAPTER , pK_MSG);
-extern void SME_Halt(PWB32_ADAPTER Adapter);
-extern void SME_Stop(PWB32_ADAPTER Adapter);
-extern void vSmeTimerStop(PWB32_ADAPTER Adapter);
-extern void vNetDisconnectInd(PWB32_ADAPTER Adapter);
-unsigned char boJoinfilter(PWB32_ADAPTER Adapter, u16 wBssIdx);
-
-void UpdateBssidFromHw(PWB32_ADAPTER Adapter);
-void GetMacPsStateComplete(PWB32_ADAPTER Adapter);
-void HwSetChanComplete(PWB32_ADAPTER Adapter, ChanInfo Chan);
-
-void UNKNOWN_ChanRange(PWB32_ADAPTER , u8 , psCHAN_LIST );
-void EUROPE_ChanRange(PWB32_ADAPTER , u8 , psCHAN_LIST );
-void JAPAN_ChanRange(PWB32_ADAPTER , u8 , psCHAN_LIST );
-void USA_ChanRange(PWB32_ADAPTER , u8 , psCHAN_LIST );
-void SPAIN_ChanRange(PWB32_ADAPTER , u8 , psCHAN_LIST );
-void FRANCE_ChanRange(PWB32_ADAPTER , u8 , psCHAN_LIST );
-void ISRAEL_ChanRange(PWB32_ADAPTER , u8 , psCHAN_LIST );
-void GetSupportChanRange(PWB32_ADAPTER Adapter);
-void GetIbssChan(PWB32_ADAPTER Adapter);
-void FillEventLog(PWB32_ADAPTER Adapter, u16 EventValue);
-
-void CheckHwRadioStatus(  PWB32_ADAPTER Adapter );
-void CheckRadioOffForDisassoc(  PWB32_ADAPTER Adapter,
-								RadioOff DesiredRadioOffData,
-								RadioOff CurrentRadioOffData );
-#define SME_SEND_NULL_PACKET( _A, _F )	BUG()
-
-
-
diff --git a/drivers/net/wireless/winbond/winbondport/wbhal.c b/drivers/net/wireless/winbond/winbondport/wbhal.c
index 0622ecb..439023c 100644
--- a/drivers/net/wireless/winbond/winbondport/wbhal.c
+++ b/drivers/net/wireless/winbond/winbondport/wbhal.c
@@ -1020,7 +1020,6 @@ void hal_led_control(  void* S1,  phw_da
 			pHwData->NullPacketCount += TimeInterval;
 			if( pHwData->NullPacketCount >= DEFAULT_NULL_PACKET_COUNT )
 			{
-				SME_SEND_NULL_PACKET( Adapter,PWR_ACTIVE );
 				pHwData->NullPacketCount = 0;
 			}
 		}
@@ -1095,16 +1094,6 @@ void hal_set_radio_mode( phw_data_t pHwD
 	Wb35Reg_Write( pHwData, 0x0824, pWb35Reg->M24_MacControl );
 }
 
-void hal_descriptor_indicate(phw_data_t pHwData, PDESCRIPTOR pRxDes)
-{
-	PADAPTER Adapter = pHwData->Adapter;
-
-	if (!pHwData->IsInitOK)
-		return;
-
-	{ Mds_MpduProcess(Adapter, pRxDes); }	/* Ouch, MpduProcess has three parameters but we only pass two?! */
-}
-
 u8 hal_get_antenna_number(  phw_data_t pHwData )
 {
 	PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
diff --git a/drivers/net/wireless/winbond/winbondport/wbndis.c b/drivers/net/wireless/winbond/winbondport/wbndis.c
index 3bab529..e69de29 100644
--- a/drivers/net/wireless/winbond/winbondport/wbndis.c
+++ b/drivers/net/wireless/winbond/winbondport/wbndis.c
@@ -1 +0,0 @@
-/* No more Window$ c0d3 */
diff --git a/drivers/net/wireless/winbond/winbondport/wbndis51.c b/drivers/net/wireless/winbond/winbondport/wbndis51.c
index db124b9..e69de29 100644
--- a/drivers/net/wireless/winbond/winbondport/wbndis51.c
+++ b/drivers/net/wireless/winbond/winbondport/wbndis51.c
@@ -1 +0,0 @@
-/* We don't need no windows code */
diff --git a/drivers/net/wireless/winbond/winbondport/wbndis_entry.c b/drivers/net/wireless/winbond/winbondport/wbndis_entry.c
index 7cae451..e69de29 100644
--- a/drivers/net/wireless/winbond/winbondport/wbndis_entry.c
+++ b/drivers/net/wireless/winbond/winbondport/wbndis_entry.c
@@ -1 +0,0 @@
-/* No windows code needed...? */

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
