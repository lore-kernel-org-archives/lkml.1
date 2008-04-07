Return-Path: <linux-kernel-owner+w=401wt.eu-S1757540AbYDGV7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540AbYDGV7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 17:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbYDGV7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 17:59:43 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:49125 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbYDGV7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 17:59:40 -0400
Date: Tue, 8 Apr 2008 00:00:11 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, kaszak@gmail.com,
       lcostantino@gmail.com
Subject: w35und: some more cleanups
Message-ID: <20080407220011.GA17986@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some more cleanups for w35und...

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/drivers/net/wireless/winbond/winbondport/knl.c b/drivers/net/wireless/winbond/winbondport/knl.c
index 4e8dad9..442435c 100644
--- a/drivers/net/wireless/winbond/winbondport/knl.c
+++ b/drivers/net/wireless/winbond/winbondport/knl.c
@@ -1,15 +1,15 @@
-//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 //	knl.c
 //		Kernel module
 //	history -- 01/14/03' created 
 //
-//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 #include "os_common.h"
 
 void vKNL_StateMachine(PWB32_ADAPTER Adapter, const K_TRANS** psStateMachineTable,
                        u16 wStateData, pK_MSG psMsg)
 {
-    const K_TRANS* psStateTableEntry;
+	const K_TRANS* psStateTableEntry;
 	
 	if (wStateData == K_NULL_STATE)
 		return;
diff --git a/drivers/net/wireless/winbond/winbondport/linux/common.h b/drivers/net/wireless/winbond/winbondport/linux/common.h
index 66b9c7c..a9884e1 100644
--- a/drivers/net/wireless/winbond/winbondport/linux/common.h
+++ b/drivers/net/wireless/winbond/winbondport/linux/common.h
@@ -110,10 +110,8 @@ #define OS_ATOMIC			u32
 #define OS_ATOMIC_READ( _A, _V )	_V
 #define OS_ATOMIC_INC( _A, _V )		EncapAtomicInc( _A, (void*)_V )
 #define OS_ATOMIC_DEC( _A, _V )		EncapAtomicDec( _A, (void*)_V )
-#define OS_MEMORY_FREE( _V, _S )	kfree( _V )
 #define OS_MEMORY_CLEAR( _A, _S )	memset( (PUCHAR)_A,0,_S)
 #define OS_MEMORY_COMPARE( _A, _B, _S )	(memcmp(_A,_B,_S)? 0 : 1) // Definition is reverse with Ndis 1: the same 0: different
-#define OS_DELAY( _MT )				//NdisStallExecution( _MT ) _MT : microsecond
 
 
 #define OS_SPIN_LOCK				spinlock_t
diff --git a/drivers/net/wireless/winbond/winbondport/linux/new_wireless.c b/drivers/net/wireless/winbond/winbondport/linux/new_wireless.c
index 512b58c..cbe23f6 100644
--- a/drivers/net/wireless/winbond/winbondport/linux/new_wireless.c
+++ b/drivers/net/wireless/winbond/winbondport/linux/new_wireless.c
@@ -611,92 +611,67 @@ int test_get_txpow(struct net_device *de
    DEBUG("END TXPOWER");
    return 0;
 }
-/* VER ORIGINAL -> Faltan cosas del WEP */
+
 int test_set_essid(struct net_device *dev,
-			  struct iw_request_info *info, struct iw_point *data, char *essid)
+		   struct iw_request_info *info, struct iw_point *data, char *essid)
 {
+	u8 		SSID[32]={0};
+	PWB32_ADAPTER Adapter=(PWB32_ADAPTER)dev->priv;
 
-   u8 		SSID[32]={0};
-   PWB32_ADAPTER Adapter=(PWB32_ADAPTER)dev->priv;
+	DEBUG("SIOCSIWESSID test\n");
 
-   DEBUG("SIOCSIWESSID test\n");
+	if(psSME->encrypt_status >= ENCRYPT_TKIP)     {
+		//To add the 64 HEX WPA
+		u32 PasswordLength=strlen(pGlobal_STA_Wpa->WPAPassword);
+		u8* Password=pGlobal_STA_Wpa->WPAPassword;
+		u32 count=0;
 
-   //SIN CRYPTO por ahora......
-# if 0
-   if (pWblinux->boWepKeyOk)
-     {
-	  {
-	     //restore the WEP keys
-	     for (i=0; i<4; i++)
-	       {
-		  if ((pWblinux->WepKeyValid[i] == 1) && (i != pWblinux->WepKeyIndex))
-		    sme_set_add_wep( Adapter, i, pWblinux->WepKeyLen, NULL,
-				     pWblinux->WepKeyValue[i]);
-	       }
-	     sme_set_add_wep( Adapter, pWblinux->WepKeyIndex|0x80000000, pWblinux->WepKeyLen,
-			      NULL, pWblinux->WepKeyValue[pWblinux->WepKeyIndex]);
-	  }
-
-     }
-# endif
-
-   if(psSME->encrypt_status >= ENCRYPT_TKIP)
-     {
-	//////////////////////////////////////////////////
-	//Added by WangJS 2006.8.22
-	//To add the 64 HEX WPA
-	u32 PasswordLength=strlen(pGlobal_STA_Wpa->WPAPassword);
-	u8* Password=pGlobal_STA_Wpa->WPAPassword;
-	u32 count=0;
-
-	if(PasswordLength >= 64)
-	  {
+		if(PasswordLength >= 64)
+		{
 
 # ifdef _WPA_PSK_DEBUG
-	     WBDEBUG(("The Password is too large \n"));
-	     //////////////////////////////////////////////
-	     //For Test
-	     WBDEBUG(("Dump password(1)\n"));
-	     DataDmp(Password,64,0);
+			WBDEBUG(("The Password is too large \n"));
+			//////////////////////////////////////////////
+			//For Test
+			WBDEBUG(("Dump password(1)\n"));
+			DataDmp(Password,64,0);
 # endif
-	     //////////////////////////////////////////////
-
-	     if(PasswordLength>64)
-	       {WBDEBUG(("The Password is >64 HEX \n"));return -EFAULT;}
-	     else
-	       {
-		  WBDEBUG(("The Password is =64 HEX \n"));
-		  for(count=0;count<32;count++)
-		    {
-		       Password[count]=((CharToBin(Password[count*2])<<4) | (CharToBin(Password[count*2+1])) );
-		    }
-		  OS_MEMORY_CLEAR(Password+32,32);
-
-	       }
-
-	     //////////////////////////////////////////////
-	     //For Test
+			//////////////////////////////////////////////
+
+			if(PasswordLength>64)
+			{WBDEBUG(("The Password is >64 HEX \n"));return -EFAULT;}
+			else
+			{
+				WBDEBUG(("The Password is =64 HEX \n"));
+				for(count=0;count<32;count++)
+				{
+					Password[count]=((CharToBin(Password[count*2])<<4) | (CharToBin(Password[count*2+1])) );
+				}
+				OS_MEMORY_CLEAR(Password+32,32);
+
+			}
+
+			//////////////////////////////////////////////
+			//For Test
 # ifdef _WPA_PSK_DEBUG
-	     WBDEBUG(("Dump password(2)\n"));
-	     DataDmp(Password,64,0);
+			WBDEBUG(("Dump password(2)\n"));
+			DataDmp(Password,64,0);
 # endif
-	     //////////////////////////////////////////////
-
-	     //Copy the 64 Byte to pmk
-	     memcpy(pSTA->PMK.m_pmk, Password,32);
-	     //////////////////////////////////////////////////
-	  }
-	else
-	  {
-	     memcpy(SSID,essid, data->length);
-	     AP_PrePasswordHash( Adapter, SSID, strlen(SSID) );
-	  }
-     }
+			//////////////////////////////////////////////
+
+			//Copy the 64 Byte to pmk
+			memcpy(pSTA->PMK.m_pmk, Password,32);
+			//////////////////////////////////////////////////
+		} else {
+			memcpy(SSID,essid, data->length);
+			AP_PrePasswordHash( Adapter, SSID, strlen(SSID) );
+		}
+	}
 
-   sme_set_desired_ssid(Adapter,
-			essid,
-			data->length);
-   return 0;
+	sme_set_desired_ssid(Adapter,
+			     essid,
+			     data->length);
+	return 0;
 }
 
 /* Segun el original no reporta el ssid conectado, veri los comentarios de codigo ahi */
diff --git a/drivers/net/wireless/winbond/winbondport/linux/wb35rx.c b/drivers/net/wireless/winbond/winbondport/linux/wb35rx.c
index 19f3ec6..ea70d84 100644
--- a/drivers/net/wireless/winbond/winbondport/linux/wb35rx.c
+++ b/drivers/net/wireless/winbond/winbondport/linux/wb35rx.c
@@ -153,7 +153,7 @@ void Wb35Rx_Complete(PURB pUrb)
 		if (!pWb35Rx->RxOwner[ RxBufferId ])
 			Wb35Rx_indicate( pHwData );
 		
-		OS_MEMORY_FREE( pWb35Rx->pDRx, MAX_USB_RX_BUFFER);
+		kfree(pWb35Rx->pDRx);
 		// Do the next receive
 		Wb35Rx(pHwData);
 		return;
diff --git a/drivers/net/wireless/winbond/winbondport/mlmetask.c b/drivers/net/wireless/winbond/winbondport/mlmetask.c
index 771a039..9496f65 100644
--- a/drivers/net/wireless/winbond/winbondport/mlmetask.c
+++ b/drivers/net/wireless/winbond/winbondport/mlmetask.c
@@ -405,17 +405,14 @@ void MLME_Halt( PWB32_ADAPTER Adapter)
 	}
 	for (i=MAX_BSS_DESCRIPT_ELEMENT-1; i>0; i--)
 	{
-		while (psBSS(i)->boInTimerHandler == TRUE)
-		{
-			///NdisMSleep(10000);//10ms
-			OS_SLEEP( 10000 );
+		while (psBSS(i)->boInTimerHandler == TRUE) {
+			OS_SLEEP(10000);
 		}
 	}
 
-	if( Adapter->asBSSDescriptElement )
-	{
-		OS_MEMORY_FREE( Adapter->asBSSDescriptElement, sizeof(WB_BSSDESCRIPTION) * MAX_BSS_DESCRIPT_ELEMENT );
-		Adapter->asBSSDescriptElement = NULL;	//[WK 20060626]
+	if (Adapter->asBSSDescriptElement) {
+		kfree(Adapter->asBSSDescriptElement);
+		Adapter->asBSSDescriptElement = NULL;
 	}
 	#ifdef _PE_STATE_DUMP_
 	WBDEBUG(("STATE: Mlme halt.\n"));
@@ -426,10 +423,9 @@ void MLME_Halt( PWB32_ADAPTER Adapter)
 
 void MLME_Stop( PWB32_ADAPTER Adapter)
 {
-    u16     i;
+	u16 i;
 
-	for (i=MAX_BSS_DESCRIPT_ELEMENT-1; i>0; i--)
-	{
+	for (i=MAX_BSS_DESCRIPT_ELEMENT-1; i>0; i--) {
 		vMlmeTimerStop(Adapter, i);
 	}
 }
@@ -500,9 +496,9 @@ void MLME_Entry(PWB32_ADAPTER Adapter, p
 	#endif
 }
 
-//======================================================================================
+//==========================================================================
 //      Action Function of MLME / ESS State Transition Table 
-//======================================================================================
+//==========================================================================
 void vMlmeProc_EssAuthReq(PWB32_ADAPTER Adapter, pK_MSG psMlmeMsg)
 {
 	u16	i;
diff --git a/drivers/net/wireless/winbond/winbondport/os_common.h b/drivers/net/wireless/winbond/winbondport/os_common.h
index b75e4fe..e24ff41 100644
--- a/drivers/net/wireless/winbond/winbondport/os_common.h
+++ b/drivers/net/wireless/winbond/winbondport/os_common.h
@@ -1,5 +1,2 @@
-#ifndef NDIS_MINIPORT_DRIVER
 #include "linux/sysdef.h"
-#else
-#include "sysdef.h"
-#endif
+
diff --git a/drivers/net/wireless/winbond/winbondport/rxisr.c b/drivers/net/wireless/winbond/winbondport/rxisr.c
index 009e851..f1397b1 100644
--- a/drivers/net/wireless/winbond/winbondport/rxisr.c
+++ b/drivers/net/wireless/winbond/winbondport/rxisr.c
@@ -1,6 +1,5 @@
 #include "os_common.h"
 
-//#ifdef _PE_RX_DUMP_
 void DataDmp(u8 *pdata, u32 len, u32 offset)
 {
 	u8      dbg_str[140];
@@ -8,81 +7,77 @@ void DataDmp(u8 *pdata, u32 len, u32 off
 	u8      c;
 	u8      *p;
 
-	//WBDEBUG((" addr of pdata = %p\n", pdata));
-    for (i = 0; i < len; i += 16)
-    {
-	    p = dbg_str;
+	for (i = 0; i < len; i += 16)
+	{
+		p = dbg_str;
 
-        //--------------------------------------------------------------------
-        // Output the offset header
-        n = offset + i;
+		//--------------------------------------------------------------------
+		// Output the offset header
+		n = offset + i;
 
-        for (j=0; j<4; j++)
-        {
+		for (j=0; j<4; j++)
+		{
 			c = (u8) (n % 16);
-            p[3-j] =  (c >= 10) ? 'A'+(c-10) : '0'+c;
+			p[3-j] =  (c >= 10) ? 'A'+(c-10) : '0'+c;
 			n >>= 4 ;
 		}
-        p+= 4;
-
-        *p++ = ':';
-        *p++ = ' ';
-
-        //--------------------------------------------------------------------
-        // Output the hex bytes
-        for (j = i; j < (i+16); j++)
-        {
-            if (j < len)
-            {
-                c = *(pdata+j) / 16 ;
-                *p++ = (c >= 10) ? 'A'+(c-10) : '0'+c;
-
-                c = *(pdata+j) % 16 ;
-                *p++ = (c >= 10) ? 'A'+(c-10) : '0'+c;
-
-                *p++ = ' ';
-            }
-            else
-            {
-                *p++ = ' ';
-                *p++ = ' ';
-                *p++ = ' ';
-            }
-        }
-
-        *p++ = ' ';
-        *p++ = ' ';
-
-        //--------------------------------------------------------------------
-        // Output the ASCII bytes
-        for (j = i; j < (i+16); j++)
-        {
-            if (j < len)
-            {
-                c = *(pdata+j);
-                *p++ = (! isprint(c)) ? '.' : c;
-
-            }
-            else
-            {
-                *p++ = ' ';
-            }
-        }
-
-        *p++ = '\n';
-        *p++ = '\0';
-
-		//PDEBUG(( "%s", dbg_str));
+		p+= 4;
+
+		*p++ = ':';
+		*p++ = ' ';
+
+		//--------------------------------------------------------------------
+		// Output the hex bytes
+		for (j = i; j < (i+16); j++)
+		{
+			if (j < len)
+			{
+				c = *(pdata+j) / 16 ;
+				*p++ = (c >= 10) ? 'A'+(c-10) : '0'+c;
+
+				c = *(pdata+j) % 16 ;
+				*p++ = (c >= 10) ? 'A'+(c-10) : '0'+c;
+
+				*p++ = ' ';
+			}
+			else
+			{
+				*p++ = ' ';
+				*p++ = ' ';
+				*p++ = ' ';
+			}
+		}
+
+		*p++ = ' ';
+		*p++ = ' ';
+
+		//--------------------------------------------------------------------
+		// Output the ASCII bytes
+		for (j = i; j < (i+16); j++)
+		{
+			if (j < len)
+			{
+				c = *(pdata+j);
+				*p++ = (! isprint(c)) ? '.' : c;
+
+			}
+			else
+			{
+				*p++ = ' ';
+			}
+		}
+
+		*p++ = '\n';
+		*p++ = '\0';
+
 		WBDEBUG(("%s", dbg_str));
 
-    }
+	}
 }
-//#endif
 
 
 void Mds_MsduProcess(  PWB32_ADAPTER Adapter,  PRXLAYER1 pRxLayer1,  u8 SlotIndex)
 {
-//	phw_data_t	pHwData = &Adapter->sHwData;
 	struct MAC_frame_control frame_control;
 	struct Data_Frame* pDFrame;
 	PUCHAR			SourceAddress;
@@ -95,28 +90,23 @@ void Mds_MsduProcess(  PWB32_ADAPTER Ada
 	PUCHAR	mic_key = NULL, pframe_mic;
 	u8	LastBufIdx;
 
-
 	// Is management frame??
-	if( pRxLayer1->FrameType != MAC_TYPE_DATA )
-	{
+	if( pRxLayer1->FrameType != MAC_TYPE_DATA ) {
 		// Call MLME function
    		MLMERcvFrame( Adapter, pRxLayer1->BufferQueue, pRxLayer1->BufferNumber, SlotIndex );//The last parameter is needed for SME.
 		return;
 	}
 
 	// Checking this packet(802.3), if valid for Filter. Just discard the frame if the media is disconnected.
-	if ( !CURRENT_LINK_ON )
+	if  (!CURRENT_LINK_ON)
 		return;
 
 	pDFrame = (struct Data_Frame*)pRxLayer1->BufferQueue[0].pBufferAddress;
-	//Temp = cpu_to_le16(*(PUSHORT)pRxLayer1->BufferQueue[0].pBufferAddress);
 	Temp = (*(PUSHORT)pRxLayer1->BufferQueue[0].pBufferAddress); //anson's endian
 	memcpy( &frame_control, &Temp, sizeof(u16) ); // YY's endian
 	WEPed = frame_control.WEP ? TRUE : FALSE;
 	if( (!WEPed && !MLMEGetExcludeUnencrypted(Adapter)) ||
-		(WEPed && Adapter->sSmePara._dot11PrivacyOptionImplemented != FALSE) )
-	{
-		//#ifdef _WPA_
+		(WEPed && Adapter->sSmePara._dot11PrivacyOptionImplemented != FALSE) ) {
 		//TODO: check if there is a MIC err
 		/**/
 		if( WEPed && (pRxLayer1->DecryptionMethod==2) ) //TKIP
@@ -218,11 +208,7 @@ void Mds_MsduProcess(  PWB32_ADAPTER Ada
 			else
 			{
 
-			//	#ifdef _PE_RX_DUMP_
 				WBDEBUG(("!!!!!! MIC error !!!!!!\n"));
-			//	#endif
-
-//				MDS_EVENT_AUTH_REQUEST_PAIRWISE_ERROR( Adapter );
 
 				#ifdef NDIS51_MINIPORT
 				if (mic_key == psSME->rx_mic_key)
@@ -242,7 +228,6 @@ void Mds_MsduProcess(  PWB32_ADAPTER Ada
 				}
 				if (Adapter->Mds.bMICfailCount == 2)
 				{
-					//Adapter->Mds.bMICfailCount = 0;
 					Adapter->Mds.boCounterMeasureBlock = 1;
 					#ifdef _PE_RX_DUMP_
 					WBDEBUG(("!!!!!! Countermeasure Block  !!!!!!\n"));
@@ -256,7 +241,6 @@ void Mds_MsduProcess(  PWB32_ADAPTER Ada
 				return;
 			}
 		}
-		//#endif // End of _WPA_
 
 		//--------------------------------------------
 		//    Convert 802.11 frame to 802.3 frame
@@ -277,9 +261,6 @@ void Mds_MsduProcess(  PWB32_ADAPTER Ada
 		BufAddr += (DOT_11_TYPE_OFFSET - ETH_LENGTH_OF_ADDRESS); // offset 24 is 4n alignment @@
 
 		// PD43 20021220 Added for Type/Length encapsulation adjust
-//		if( *(PULONG)BufAddr==0x0003aaaa      && // little endian
-//			*(PULONG)(BufAddr+4)!=0x37810000  && //PD43 20030418 Modified for HCT 11
-//			(*(PUSHORT)(BufAddr+4)==0 || *(PUSHORT)(BufAddr+4)==0xf800) )
 		// YY's endian
 		if( *(PULONG)BufAddr==cpu_to_le32(0x0003aaaa)      && // little endian // @@ 4n alignment here
 			*(PULONG)(BufAddr+4)!=cpu_to_le32(0x37810000)  && //PD43 20030418 Modified for HCT 11 // @@ 4n alignment here
@@ -339,14 +320,12 @@ void Mds_MsduProcess(  PWB32_ADAPTER Ada
 
 void vRxTimerInit(PWB32_ADAPTER Adapter)
 {
-	OS_TIMER_INITIAL( &(Adapter->Mds.nTimer),
-                          (void*) RxTimerHandler,
-                          (void*) Adapter);
+	OS_TIMER_INITIAL(&(Adapter->Mds.nTimer), (void*) RxTimerHandler, (void*) Adapter);
 }
 
 void vRxTimerStart(PWB32_ADAPTER Adapter, int timeout_value)
 {
-    if (timeout_value<MIN_TIMEOUT_VAL)
+	if (timeout_value<MIN_TIMEOUT_VAL)
 		timeout_value=MIN_TIMEOUT_VAL;
 	
 	OS_TIMER_SET( &(Adapter->Mds.nTimer), timeout_value );
@@ -354,10 +333,6 @@ void vRxTimerStart(PWB32_ADAPTER Adapter
 
 void vRxTimerStop(PWB32_ADAPTER Adapter)
 {
-//   unsigned char boValue=TRUE;
-
-//For clean compile
-//	OS_TIMER_CANCEL( &(Adapter->Mds.nTimer), &boValue );
 	OS_TIMER_CANCEL( &(Adapter->Mds.nTimer), 0 );
 }
 
@@ -365,27 +340,23 @@ void RxTimerHandler_1a( PADAPTER Adapter
 {
 	RxTimerHandler(NULL, Adapter, NULL, NULL);
 }
-void RxTimerHandler( void*			SystemSpecific1,
-					   PWB32_ADAPTER 	Adapter,
-					   void*			SystemSpecific2,
-					   void*			SystemSpecific3)
+
+void RxTimerHandler(void* SystemSpecific1, PWB32_ADAPTER Adapter,
+		    void* SystemSpecific2, void* SystemSpecific3)
 {
 	K_MSG sMsg;
-	u16		wReasonCode;
+	u16 wReasonCode;
 
-	if (Adapter->Mds.bMICfailCount == 1)
-	{
+	if (Adapter->Mds.bMICfailCount == 1) {
 		sMsg.wMsgType = SMEMSG_COUNTERMEASURE_MICFAIL_TIMEOUT;
 	}
-	if (Adapter->Mds.boCounterMeasureBlock == 1)
-	{
-		if (psLOCAL->wConnectedSTAindex != 0)
-		{
+	if (Adapter->Mds.boCounterMeasureBlock == 1) {
+		if (psLOCAL->wConnectedSTAindex != 0) {
 			//Wait for NDIS to send MIC error EAPOL packet, and then disassoc.
 			//But it doesn't appear.
-			#ifdef _PE_STATE_DUMP_
+#ifdef _PE_STATE_DUMP_
 			WBDEBUG(("!!Countermeasure, block timeout, disassoc !!\n"));
-			#endif
+#endif
 
 			FillEventLog(Adapter, EVENT_COUNTERMEASURE);
 
@@ -394,7 +365,7 @@ void RxTimerHandler( void*			SystemSpeci
 			sMsg.pMsgPtr = &wReasonCode;
 			SME_Entry(Adapter, &sMsg);
 		}
-	    sMsg.wMsgType = SMEMSG_COUNTERMEASURE_BLOCK_TIMEOUT;
+		sMsg.wMsgType = SMEMSG_COUNTERMEASURE_BLOCK_TIMEOUT;
 	}
 	sMsg.pMsgPtr = NULL;
 	SME_Entry(Adapter, &sMsg);
@@ -418,11 +389,7 @@ void Mds_MpduProcess(  PWB32_ADAPTER Ada
 	u8		i;
 
 	#ifdef _PE_RX_DUMP_
-	//[WK DUMP]
-	//if ((*((PUCHAR)pRxDes->buffer_address[0]) != 0x80) &&
-	//	(*((PUCHAR)pRxDes->buffer_address[0]) != 0x40))
-	if ( *((PUCHAR)pRxDes->buffer_address[0]) == 0x08)
-	{
+	if ( *((PUCHAR)pRxDes->buffer_address[0]) == 0x08) {
 		ChanInfo ChanTmp;
 
 		WBDEBUG(("$$$$$ DUMP RX MPDU $$$$$\n"));
diff --git a/drivers/net/wireless/winbond/winbondport/wbhal.c b/drivers/net/wireless/winbond/winbondport/wbhal.c
index dc3ef0f..596bf0b 100644
--- a/drivers/net/wireless/winbond/winbondport/wbhal.c
+++ b/drivers/net/wireless/winbond/winbondport/wbhal.c
@@ -1,12 +1,13 @@
 #include "os_common.h"
 
 
-//---------------------------------------------------------------------------------------------------
+//-----------------------------------------------------------------------------------
 void hal_start_tx0(  phw_data_t pHwData )
 {
 	if( !pHwData->SurpriseRemove ) Wb35Tx_start( pHwData );
 }
-//---------------------------------------------------------------------------------------------------
+
+//-----------------------------------------------------------------------------------
 void hal_remove_mapping_key( phw_data_t pHwData, PUCHAR pmac_addr )
 {
 	u32	i;
@@ -95,46 +96,38 @@ unsigned char hal_set_mapping_key( phw_d
 	*pValue |= (key_type << 2);				//bit 2~3
 	*pValue |= (wep_on << 4);				//bit 4
 	pValue += 2;
-    memcpy( pValue, pmac_addr, sizeof(u16) );	//addr 1
+	memcpy(pValue, pmac_addr, sizeof(u16));	//addr 1
 
 	memcpy( &(pKey->DW1_Address2), pmac_addr + 2, sizeof(u32) );
 
-	if( prx_tsc )
-     {
-	
-	
+	if( prx_tsc ) {
 		pValue = (u8 *)pKey +8 ;  //20060926 anson's endian
 		memcpy( pValue, prx_tsc, 6 ); //20060926 anson's endian
 	}
-	if( ptx_tsc )
-	{
-	
+	if( ptx_tsc ) {
 		pValue = (u8 *)pKey +16;   //20060926 anson's endian
 		memcpy( pValue, ptx_tsc, 6 ); //20060926 anson's endian
 	}
+
 	//fill key content [20060623]
 	memcpy( ((PUCHAR)pKey+sizeof(KEY_TABLE)), pkey_data, key_len );
 
 	j = 0xff;
-	for( i=MAPPING_KEY_START_INDEX; i<MAX_KEY_TABLE; i++ )
-	{
-	
+	for( i=MAPPING_KEY_START_INDEX; i<MAX_KEY_TABLE; i++ ) {
 		pValue = (u8 *)pKey + 2;  //20060926 anson's endian
-		if ( OS_MEMORY_COMPARE(pValue, pHwData->Key_slot[i], 6) )  //20060926 anson's endian
-		{
+		if (!memcpy(pValue, pHwData->Key_slot[i], 6)) {
 			pHwData->mapping_key_replace_index = i + 1;
 			if( pHwData->mapping_key_replace_index == MAX_KEY_TABLE )
 				pHwData->mapping_key_replace_index = MAPPING_KEY_START_INDEX;
 			break;
 		}
 
-		if( OS_MEMORY_COMPARE( pHwData->Key_slot[i], "\x00\x00\x00\x00\x00\x00", MAC_ADDR_LENGTH ) )
+		if (!memcpy(pHwData->Key_slot[i], "\x00\x00\x00\x00\x00\x00", MAC_ADDR_LENGTH ))
 			if( j == 0xff )
 				j = i;//Storing the index which can be used
 	}
 
-	if( i == MAX_KEY_TABLE ) //Not found the entry, get one to use
-	{
+	if (i == MAX_KEY_TABLE) { //Not found the entry, get one to use
 		if( j == 0xff )//Is out of resource? If yes, get an elder one index to be replaced
 			i = pHwData->mapping_key_replace_index;
 		else
@@ -207,37 +200,26 @@ unsigned char hal_set_default_key( phw_d
 	#endif
 
 	// Set key table contain
-	OS_MEMORY_CLEAR( Key_content, sizeof(KEY_TABLE) + 16 + 8 ); // 8 bytes for burst writing
+	memset( Key_content, 0, sizeof(KEY_TABLE) + 16 + 8 ); // 8 bytes for burst writing
 	pKey = (PKEY_TABLE)(Key_content + 4 );
-//	//20060926 anson's endian
-//	pKey->DW0_Valid = 1; // Valid bit
-//	pKey->DW0_NullKey = null_key ? 0 : 1; // 35 hardware different with 33
-//	pKey->DW0_Security_Mode = key_type;
-//	pKey->DW0_WEPON = wep_on;
+
 	pValue = (u8 *)pKey;
 	*pValue = 0x01;							//bit 0
 	*pValue |= ((null_key ? 0: 1) << 1);	//bit 1, 35 hardware different with 33
 	*pValue |= (key_type << 2);				//bit 2~3
 	*pValue |= (wep_on << 4);				//bit 4
 
-	if( prx_tsc )
-	{
-               //20060926 anson's endian
-		//pKey->DW2_RxSequenceCount1 = *(PULONG)prx_tsc; // 4n Alignment
-		//pKey->DW3_RxSequenceCount2 = *(PUSHORT)(prx_tsc+4); // 2n Alignment
+	if (prx_tsc) {
                 pValue = (u8 *)pKey +8; //20060926 anson's endian
 	        memcpy( pValue, prx_tsc, 6 ); //20060926 anson's endian
 	}
-	if( ptx_tsc )
-	{
-                //20060926 anson's endian
-		//pKey->DW4_TxSequenceCount1 = *(PULONG)ptx_tsc; // 4n Alignment
-		//pKey->DW5_TxSequenceCount2 = *(PUSHORT)(ptx_tsc+4); // 2n Alignment
+	if( ptx_tsc ) {
                 pValue = (u8 *)pKey+ 16; //20060926 anson's endian
                 memcpy( pValue, ptx_tsc, 6 ); //20060926 anson's endian
 	}
+
 	//fill key content [20060623]
-	memcpy( ((PUCHAR)pKey+sizeof(KEY_TABLE)), pkey_data, key_len );
+	memcpy(((PUCHAR)pKey+sizeof(KEY_TABLE)), pkey_data, key_len );
 
 	// 950301.3.a modify
 	pHwData->CurrentDefaultKeyIndex = index;// Backup default key 941130.2
@@ -251,7 +233,7 @@ unsigned char hal_set_default_key( phw_d
 	pltmp[0] = ltmp; // Burst command
 	pltmp[11] = pltmp[1]; // The last, valid bit set
 	pltmp[1] = 0;// The first, clear the valid bit
-	memcpy( pHwData->Key_content[index], pltmp, sizeof(u32)*12 ); // 20060214 for recover
+	memcpy( pHwData->Key_content[index], pltmp, sizeof(u32)*12 );
         //---20060926 add by anson's endian
         pltmp[0] = cpu_to_le32( ltmp );  
         for( i=0; i<=11; i++)
@@ -265,7 +247,8 @@ unsigned char hal_set_default_key( phw_d
 
 	return TRUE;
 }
-//---------------------------------------------------------------------------------------------------
+
+//--------------------------------------------------------------------------------
 void hal_clear_all_default_key( phw_data_t pHwData )
 {
 	u32	pltmp[GROUP_KEY_START_INDEX];
@@ -280,16 +263,16 @@ void hal_clear_all_default_key( phw_data
 	// M20 KEY data, set to 0
 	Wb35Reg_Write( pHwData, 0x0820, 0 );
 	// M1c KEY write operation
-	for( i=0; i<GROUP_KEY_START_INDEX; i++ )
-	{
+	for( i=0; i<GROUP_KEY_START_INDEX; i++ ) {
 		pltmp[i] = i<<4;
 		pltmp[i] |= 0x4000000;
 	}
 	Wb35Reg_BurstWrite( pHwData, 0x081c, pltmp, GROUP_KEY_START_INDEX, NO_INCREMENT );
-	OS_MEMORY_CLEAR( pHwData->Key_slot[0], GROUP_KEY_START_INDEX*8 ); // 20060214 for recover
+	memset( pHwData->Key_slot[0], 0, GROUP_KEY_START_INDEX*8 ); // 20060214 for recover
 }
-//---------------------------------------------------------------------------------------------------
-void hal_clear_all_group_key( phw_data_t pHwData )
+
+//------------------------------------------------------------------------------------
+void hal_clear_all_group_key(phw_data_t pHwData)
 {
 	u32	pltmp[MAPPING_KEY_START_INDEX-GROUP_KEY_START_INDEX];
 	u8	i;
@@ -309,7 +292,7 @@ void hal_clear_all_group_key( phw_data_t
 		pltmp[i-GROUP_KEY_START_INDEX] |= 0x4000000;
 	}
 	Wb35Reg_BurstWrite( pHwData, 0x081c, pltmp, MAPPING_KEY_START_INDEX-GROUP_KEY_START_INDEX, NO_INCREMENT );
-	OS_MEMORY_CLEAR( pHwData->Key_slot[GROUP_KEY_START_INDEX], (MAPPING_KEY_START_INDEX-GROUP_KEY_START_INDEX)*8 ); // 20060214 for recover
+	memset( pHwData->Key_slot[GROUP_KEY_START_INDEX], 0, (MAPPING_KEY_START_INDEX-GROUP_KEY_START_INDEX)*8 );
 }
 //---------------------------------------------------------------------------------------------------
 void hal_clear_all_mapping_key( phw_data_t pHwData )
@@ -334,7 +317,7 @@ void hal_clear_all_mapping_key( phw_data
 	Wb35Reg_BurstWrite( pHwData, 0x081c, pltmp, MAX_KEY_TABLE-MAPPING_KEY_START_INDEX, NO_INCREMENT );
 
 	pHwData->mapping_key_replace_index = MAPPING_KEY_START_INDEX;
-	OS_MEMORY_CLEAR( pHwData->Key_slot[MAPPING_KEY_START_INDEX], (MAX_KEY_TABLE-MAPPING_KEY_START_INDEX)*8 ); // Modify due to enlarge data struct 6 -> 8
+	memset( pHwData->Key_slot[MAPPING_KEY_START_INDEX], 0, (MAX_KEY_TABLE-MAPPING_KEY_START_INDEX)*8 ); // Modify due to enlarge data struct 6 -> 8
 }
 //---------------------------------------------------------------------------------------------------
 void hal_clear_all_key( phw_data_t pHwData )
@@ -358,7 +341,7 @@ void hal_clear_all_key( phw_data_t pHwDa
 	}
 	Wb35Reg_BurstWrite( pHwData, 0x081c, pltmp, 16, NO_INCREMENT );
 	Wb35Reg_BurstWrite( pHwData, 0x081c, pltmp+16, MAX_KEY_TABLE-16, NO_INCREMENT );
-	OS_MEMORY_CLEAR( pHwData->Key_slot[0], MAX_KEY_TABLE*8 ); // 20060214 for recover
+	memset( pHwData->Key_slot[0], 0, MAX_KEY_TABLE*8 ); // 20060214 for recover
 }
 //---------------------------------------------------------------------------------------------------
 void hal_get_ethernet_address( phw_data_t pHwData, PUCHAR current_address )
@@ -400,17 +383,13 @@ u8 hal_init_hardware(  phw_data_t pHwDat
 	pHwData->MaxReceiveLifeTime = DEFAULT_MSDU_LIFE_TIME; // Setting Rx maximum MSDU life time
 	pHwData->FragmentThreshold = DEFAULT_FRAGMENT_THRESHOLD; // Setting default fragment threshold
 
-	if( WbUsb_initial( pHwData ) )
-	{
+	if (WbUsb_initial(pHwData)) {
 		pHwData->InitialResource = 1;
-		if( Wb35Reg_initial( pHwData ) )
-		{
+		if( Wb35Reg_initial(pHwData)) {
 			pHwData->InitialResource = 2;
-			if( Wb35Tx_initial( pHwData ) )
-			{
+			if (Wb35Tx_initial(pHwData)) {
 				pHwData->InitialResource = 3;
-				if( Wb35Rx_initial( pHwData ) )
-				{
+				if (Wb35Rx_initial(pHwData)) {
 					pHwData->InitialResource = 4;
 					OS_TIMER_INITIAL( &pHwData->LEDTimer, hal_led_control, pHwData );
 					OS_TIMER_SET( &pHwData->LEDTimer, 1000 ); // 20060623
@@ -440,25 +419,23 @@ u8 hal_init_hardware(  phw_data_t pHwDat
 	pHwData->SurpriseRemove = 1;
 	return FALSE;
 }
-//---------------------------------------------------------------------------------------------------
+
+//-------------------------------------------------------------------------------
 void hal_halt(  phw_data_t pHwData,  void *ppa_data )
 {
-//	PADAPTER Adapter = pHwData->Adapter;
-//	PWB35REG pWb35Reg = &pHwData->Wb35Reg;
-//	unsigned char	cancel;
-
 	switch( pHwData->InitialResource )
 	{
 		case 4:
 		case 3: OS_TIMER_CANCEL( &pHwData->LEDTimer, &cancel );
-				OS_SLEEP(100000); // Wait for Timer DPC exit 940623.2
-				Wb35Rx_destroy( pHwData ); // Release the Rx
+			OS_SLEEP(100000); // Wait for Timer DPC exit 940623.2
+			Wb35Rx_destroy( pHwData ); // Release the Rx
 		case 2: Wb35Tx_destroy( pHwData ); // Release the Tx
 		case 1: Wb35Reg_destroy( pHwData ); // Release the Wb35 Regisster resources
 				WbUsb_destroy( pHwData );// Release the WbUsb
 	}
 }
-//---------------------------------------------------------------------------------------------------
+
+//--------------------------------------------------------------------------------
 void
 hal_set_power_save_mode(  phw_data_t pHwData,  unsigned char power_save,  unsigned char wakeup,  unsigned char dtim )
 {
@@ -471,13 +448,9 @@ hal_set_power_save_mode(  phw_data_t pHw
 	//pHwData->desired_power_save = power_save;
 	pWb35Reg->M24_MacControl &= ~0x0200c000;	//clear ps-poll and pwr active/save bits
 
-	if( power_save )
-	{
+	if( power_save ) {
 		pWb35Reg->M24_MacControl |= 0x02004000;	//enable ps-poll and pwr save
-	}
-	else
-	{
-		//if( pWb35Reg->mac_power_save )
+	} else {
 		// Force MAC active
 		pWb35Reg->M24_MacControl |= 0x8000;
 		dtim = 0; // Reset dtim set
@@ -486,7 +459,7 @@ hal_set_power_save_mode(  phw_data_t pHw
 	// Receive DTIM set
 	pHwData->dtim = dtim;
 	pWb35Reg->M24_MacControl &= ~0x00002000;
-	if( pHwData->dtim )
+	if (pHwData->dtim)
 		pWb35Reg->M24_MacControl |= 0x00002000;
 
 	Value = pWb35Reg->M24_MacControl;
@@ -497,7 +470,8 @@ hal_set_power_save_mode(  phw_data_t pHw
 	// Writing into M24
 	Wb35Reg_Write( pHwData, 0x0824, Value );
 }
-//---------------------------------------------------------------------------------------------------
+
+//----------------------------------------------------------------------------------
 void hal_get_power_save_mode(  phw_data_t pHwData,   PBOOLEAN pin_pwr_save )
 {
 	PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
@@ -570,7 +544,7 @@ void hal_set_rates(  phw_data_t pHwData,
 
 	// 930206.2.c M78 setting
 	j = k = Count1 = Count2 = 0;
-	OS_MEMORY_CLEAR( SupportedRate, 16 );
+	memset( SupportedRate, 0, 16 );
 	tmp = 0x00100000;
 	tmp1 = 0x00000100;
 	for( i=0; i<12; i++ ) // Get the supproted rate
@@ -775,7 +749,7 @@ void hal_set_ssid(  phw_data_t pHwData, 
 	if( pHwData->SurpriseRemove ) return;
 
 	memcpy( pHwData->ssid, pssid, ssid_len );
-	OS_MEMORY_CLEAR( (PUCHAR)pltmp, 36 );
+	memset( (PUCHAR)pltmp, 0, 36 );
 	//NOTE [WK endian]: ssid values will be tranfered by cpu_to_le32 in Wb35Reg_BurstWrite().
 	//			 The ssid values must be tranfered first but burst cmd is not necessary.
 	//memcpy( (PUCHAR)(pltmp+1), pssid, ssid_len );
@@ -1110,30 +1084,30 @@ #endif
 
 	return ltmp;
 }
-//----------------------------------------------------------------------------------------------------
+
+//----------------------------------------------------------------------------
 //Info the hardware connection or disconnection
 void hal_set_connect_info(  phw_data_t pHwData,  unsigned char boConnect )
 {
 	if( pHwData->SurpriseRemove ) return;
 
-	if( boConnect )
-	{
+	if (boConnect) {
 		pHwData->LED_LinkOn = 1;
 		pHwData->NullPacketCount = 0;
-	}
-	else
+	} else
 		pHwData->LED_LinkOn = 0;
 }
-//----------------------------------------------------------------------------------------------------
+
+//---------------------------------------------------------------------------
 void hal_led_control_1a(  phw_data_t pHwData )
 {
 	hal_led_control( NULL, pHwData, NULL, NULL );
 }
+
 void hal_led_control(  void* S1,  phw_data_t pHwData,  void* S3,  void* S4 )
 {
 	PADAPTER	Adapter = pHwData->Adapter;
 	PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
-//	PTESTSTA	pTestSta = &Adapter->sTestSta;
 	u32	LEDSet = (pHwData->SoftwareSet & HAL_LED_SET_MASK) >> HAL_LED_SET_SHIFT;
 	u8	LEDgray[20] = { 0,3,4,6,8,10,11,12,13,14,15,14,13,12,11,10,8,6,4,2 };
 	u8	LEDgray2[30] = { 7,8,9,10,11,12,13,14,15,0,0,0,0,0,0,0,0,0,0,0,0,0,15,14,13,12,11,10,9,8 };
@@ -1142,8 +1116,7 @@ void hal_led_control(  void* S1,  phw_da
 
 	if( pHwData->SurpriseRemove ) return;
 
-	if( pHwData->LED_control )
-	{
+	if( pHwData->LED_control ) {
 		ltmp2 = pHwData->LED_control & 0xff;
 		if( ltmp2 < 5 ) // 1 ~ 4 is TS mode
 		{
@@ -1419,7 +1392,8 @@ void hal_led_control(  void* S1,  phw_da
 	Wb35Tx_CurrentTime( pHwData, pHwData->time_count ); // 20060928 add
 	OS_TIMER_SET( &pHwData->LEDTimer, TimeInterval ); // 20060623.1
 }
-//----------------------------------------------------------------------------------------------------
+
+//--------------------------------------------------------------------------
 u8 hal_get_est_sq3(  phw_data_t pHwData, u8 Count )
 {
 	PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
@@ -1446,33 +1420,31 @@ u8 hal_get_est_sq3(  phw_data_t pHwData,
 
 	return (u8)(ltmp/Count);
 }
-//----------------------------------------------------------------------------------------------------
+
 void hal_set_phy_type(  phw_data_t pHwData,  u8 PhyType )
 {
 	pHwData->phy_type = PhyType;
 }
-//----------------------------------------------------------------------------------------------------
+
 void hal_get_phy_type(  phw_data_t pHwData,  u8 *PhyType )
 {
 	*PhyType = pHwData->phy_type;
 }
-//----------------------------------------------------------------------------------------------------
+
 void hal_reset_counter(  phw_data_t pHwData )
 {
 	pHwData->dto_tx_retry_count = 0;
 	pHwData->dto_tx_frag_count = 0;
 	memset( pHwData->tx_retry_count, 0, 8);
 }
-//----------------------------------------------------------------------------------------------------
-//boValue = 1 : radio off
-//			0 : radio on
-void hal_set_radio_mode( phw_data_t pHwData,  unsigned char boValue)
+
+void hal_set_radio_mode( phw_data_t pHwData,  unsigned char radio_off)
 {
 	PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
 
 	if( pHwData->SurpriseRemove ) return;
 
-	if (boValue)	//disable Baseband receive off
+	if (radio_off)	//disable Baseband receive off
 	{
 		pHwData->CurrentRadioSw = 1; // off
 		pWb35Reg->M24_MacControl &= 0xffffffbf;
@@ -1484,11 +1456,10 @@ void hal_set_radio_mode( phw_data_t pHwD
 	}
 	Wb35Reg_Write( pHwData, 0x0824, pWb35Reg->M24_MacControl );
 }
-//----------------------------------------------------------------------------------------------------
+
 void hal_descriptor_indicate(  phw_data_t pHwData,  PDESCRIPTOR pRxDes )
 {
 	PADAPTER Adapter = pHwData->Adapter;
-//	PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
 
 	if( !pHwData->IsInitOK ) // 20060717.3 Add
 		return;
@@ -1499,7 +1470,6 @@ void hal_descriptor_indicate(  phw_data_
 		{ Mds_MpduProcess( Adapter, pRxDes ); }
 }
 
-//----------------------------------------------------------------------------------------------------
 u8 hal_get_antenna_number(  phw_data_t pHwData )
 {
 	PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
@@ -1509,26 +1479,23 @@ u8 hal_get_antenna_number(  phw_data_t p
 	else
 		return 1;
 }
-//----------------------------------------------------------------------------------------------------
+
 void hal_set_antenna_number(  phw_data_t pHwData, u8 number )
 {
 
 	PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
 
-    if (number == 1)
-    {
-        pWb35Reg->BB2C |= BIT(11);
-    }
-    else
-    {
-        pWb35Reg->BB2C &= ~BIT(11);
-    }
+	if (number == 1) {
+		pWb35Reg->BB2C |= BIT(11);
+	} else {
+		pWb35Reg->BB2C &= ~BIT(11);
+	}
 	Wb35Reg_Write( pHwData, 0x102c, pWb35Reg->BB2C );
-	#ifdef _PE_STATE_DUMP_
+#ifdef _PE_STATE_DUMP_
 	WBDEBUG(("Current antenna number : %d\n", number));
-	#endif
+#endif
 }
-//----------------------------------------------------------------------------------------------------
+
 u32 hal_get_bss_pk_cnt(  phw_data_t pHwData )
 {
 	PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
@@ -1545,6 +1512,7 @@ u32 hal_get_bss_pk_cnt(  phw_data_t pHwD
 	Wb35Reg_Read( pHwData, 0x1060, &pWb35Reg->BB60 );
 	return (pWb35Reg->BB60);
 }
+
 //----------------------------------------------------------------------------------------------------
 //0 : radio on; 1: radio off
 u8 hal_get_hw_radio_off(  phw_data_t pHwData )
@@ -1555,34 +1523,24 @@ u8 hal_get_hw_radio_off(  phw_data_t pHw
 
 	//read the bit16 of register U1B0
 	Wb35Reg_Read( pHwData, 0x3b0, &pWb35Reg->U1B0 );
-	if ((pWb35Reg->U1B0 & 0x00010000))
-	{
+	if ((pWb35Reg->U1B0 & 0x00010000)) {
 		pHwData->CurrentRadioHw = 1;
 		return 1;
-	}
-	else
-	{
+	} else {
 		pHwData->CurrentRadioHw = 0;
 		return 0;
 	}
 }
-//----------------------------------------------------------------------------------------------------
+
 unsigned char hal_get_dxx_reg(  phw_data_t pHwData,  u16 number,  PULONG pValue )
 {
-//	PADAPTER Adapter = pHwData->Adapter;
-//	PWB35REG pWb35Reg = &pHwData->Wb35Reg;
-	unsigned char	ret;
-
 	if( number < 0x1000 )
 		number += 0x1000;
-	ret = Wb35Reg_ReadSync( pHwData, number, pValue );
-	return ret;
+	return Wb35Reg_ReadSync( pHwData, number, pValue );
 }
-//----------------------------------------------------------------------------------------------------
+
 unsigned char hal_set_dxx_reg(  phw_data_t pHwData,  u16 number,  u32 value )
 {
-//	PADAPTER Adapter = pHwData->Adapter;
-//	PWB35REG pWb35Reg = &pHwData->Wb35Reg;
 	unsigned char	ret;
 
 	if( number < 0x1000 )
@@ -1590,14 +1548,14 @@ unsigned char hal_set_dxx_reg(  phw_data
 	ret = Wb35Reg_WriteSync( pHwData, number, value );
 	return ret;
 }
-//----------------------------------------------------------------------------------------------------
-void hal_scan_status_indicate(  phw_data_t pHwData,  unsigned char IsOnProgress )
+
+void hal_scan_status_indicate(phw_data_t pHwData, unsigned char IsOnProgress)
 {
 	if( pHwData->SurpriseRemove ) return;
 	pHwData->LED_Scanning = IsOnProgress ? 1 : 0;
 }
-//----------------------------------------------------------------------------------------------------
-void hal_system_power_change(   phw_data_t pHwData, u32 PowerState )
+
+void hal_system_power_change(phw_data_t pHwData, u32 PowerState)
 {
 	if( PowerState != 0 )
 	{
@@ -1611,39 +1569,37 @@ void hal_system_power_change(   phw_data
 			hal_stop( pHwData );
 	}
 }
-//----------------------------------------------------------------------------------------------------
+
 void hal_surprise_remove(  phw_data_t pHwData )
 {
 	PADAPTER Adapter = pHwData->Adapter;
-	if( OS_ATOMIC_INC( Adapter, &pHwData->SurpriseRemoveCount ) == 1 )
-	{
+	if (OS_ATOMIC_INC( Adapter, &pHwData->SurpriseRemoveCount ) == 1) {
 		#ifdef _PE_STATE_DUMP_
 		WBDEBUG(("Calling hal_surprise_remove\n"));
 		#endif
 		OS_STOP( Adapter );
 	}
 }
-//----------------------------------------------------------------------------------------------------
+
 void hal_rate_change(  phw_data_t pHwData ) // Notify the HAL rate is changing 20060613.1
 {
 	PADAPTER	Adapter = pHwData->Adapter;
 	u8		rate = CURRENT_TX_RATE;
 
 	BBProcessor_RateChanging( pHwData, rate );
-//	RF_RateChanging( pHwData, rate );
 }
-//----------------------------------------------------------------------------------------------------
-void hal_set_rf_power(  phw_data_t pHwData,  u8 PowerIndex )
+
+void hal_set_rf_power(phw_data_t pHwData, u8 PowerIndex)
 {
-	PADAPTER	Adapter = pHwData->Adapter;
+	PADAPTER Adapter = pHwData->Adapter;
 
-	if( TS_RUNNING_IN_TESTSTA_MODE )
+	if (TS_RUNNING_IN_TESTSTA_MODE)
 		return; // Ignore setting if access right is not owned by NDIS
 
 	RFSynthesizer_SetPowerIndex( pHwData, PowerIndex );
 }
-//----------------------------------------------------------------------------------------------------
-unsigned char hal_set_LED(  phw_data_t pHwData,  u32 Mode ) // 20061108 for WPS led control
+
+unsigned char hal_set_LED(phw_data_t pHwData, u32 Mode) // 20061108 for WPS led control
 {
 	pHwData->LED_Blinking = 0;
 	pHwData->LED_control = Mode;
diff --git a/drivers/net/wireless/winbond/winbondport/wbndis.c b/drivers/net/wireless/winbond/winbondport/wbndis.c
index d9f3a77..36013b7 100644
--- a/drivers/net/wireless/winbond/winbondport/wbndis.c
+++ b/drivers/net/wireless/winbond/winbondport/wbndis.c
@@ -560,10 +560,10 @@ void WBNDIS_ConnectStatus(  PADAPTER Ada
 #ifdef NDIS50_MINIPORT
 void WbInitializeString(   PNDIS_STRING DestinationString,  PUCHAR SourceString )
 {
-	u16	i, len;
+	u16 i, len;
 
 	len = (u16)strlen( SourceString );
-	if( (OS_MEMORY_ALLOC( (void* *)&DestinationString->Buffer, 100 ) != 1) || // 100 byte maximum
+	if ((OS_MEMORY_ALLOC( (void* *)&DestinationString->Buffer, 100 ) != 1) || // 100 byte maximum
 		(len >= 50 ) )
 	{
 		DestinationString->MaximumLength = 0;
@@ -578,10 +578,9 @@ void WbInitializeString(   PNDIS_STRING 
 		DestinationString->Buffer[i] = SourceString[i];
 }
 
-void WbFreeString(  NDIS_STRING String )
+void WbFreeString( NDIS_STRING String)
 {
-	if( String.Buffer )
-		OS_MEMORY_FREE( String.Buffer, 100 );
+	kfree(String.Buffer);
 	String.Buffer = NULL;
 }
 #endif


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
