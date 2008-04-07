Return-Path: <linux-kernel-owner+w=401wt.eu-S1753940AbYDGT2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbYDGT2K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 15:28:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbYDGT1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 15:27:55 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:45765 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbYDGT1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 15:27:50 -0400
Date: Mon, 7 Apr 2008 21:28:12 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, kaszak@gmail.com,
       lcostantino@gmail.com
Subject: w35und: more cleanups
Message-ID: <20080407192812.GA18868@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Next set of cleanups to bring kernel closer to kernel coding style...

Signed-off-by: Pavel Machek <pavel@suse.cz>


diff --git a/drivers/net/wireless/winbond/winbondport/linux/common.h b/drivers/net/wireless/winbond/winbondport/linux/common.h
index 3e63f3f..2731e5b 100644
--- a/drivers/net/wireless/winbond/winbondport/linux/common.h
+++ b/drivers/net/wireless/winbond/winbondport/linux/common.h
@@ -50,10 +50,10 @@ typedef u8*		PBOOLEAN;
 typedef u16*		PUSHORT;
 typedef u32*		PULONG;
 
-typedef u32		UINT;//$
+typedef u32		UINT;
 typedef u64		ULONG64;
 typedef s32		LONG;
-typedef s32		INT;//$
+typedef s32		INT;
 typedef s16		SHORT;
 typedef s16*	PSHORT;
 
@@ -123,7 +123,7 @@ typedef int	URB_STATUS;
 // Common function definition
 //==================================================================================================
 #ifndef abs
-#define abs(_T)							((_T) < 0 ? -_T : _T)   //Added by wangJS 2006.7.25
+#define abs(_T)							((_T) < 0 ? -_T : _T)
 #endif
 #define DEBUG_ENABLED
 #define ETH_LENGTH_OF_ADDRESS	6
@@ -133,26 +133,19 @@ #else
 #define WBDEBUG( _M )	0
 #endif
 
-// #define OS_PACKET_SIZE( _A )						<-- Supported. In WbLinux module
-// #define OS_LINK_STATUS							<-- Supported. In WbLinux module
-// #define OS_SET_SHUTDOWN( _A )					<-- Supported. In WbLinux module
-// #define OS_CONNECT_STATUS_INDICATE( _A, _F )		<-- Supported. In WbLinux module
 #define OS_DISCONNECTED	0
 #define OS_CONNECTED	1
-// #define OS_STOP( _A )							<-- Supported. In WbLinux module
 
-// #define OS_CURRENT_RX_BYTE( _A )					<-- Supported. In WbLinux module
-// #define OS_CURRENT_TX_BYTE( _A )					<-- Supported. In WbLinux module
+
 #define OS_EVENT_INDICATE( _A, _B, _F )
 #define OS_PMKID_STATUS_EVENT( _A )
-// #define OS_RECEIVE_PACKET_INDICATE( _A, _D )		<-- Supported. In WbLinux module
-// #define OS_GET_PACKET( _A, _D )					<-- Supported. In WbLinux module
-// #define OS_GET_PACKET_COMPLETE( _A, _D )			<-- Supported. In WbLinux module
 
-// #define cpu_to_le32( _A )			<-- Supported. Linux OS
-// #define cpu_to_le16( _A )			<-- Supported. Linux OS
+
 #define __ALIGN_PACK__                  __attribute__ ((packed))
 
+/* Uff, no, longs are not atomic on all architectures Linux
+ * supports. This should really use tomic_t */
+
 #define OS_ATOMIC						ULONG
 #define OS_ATOMIC_READ( _A, _V )		_V
 #define OS_ATOMIC_INC( _A, _V )			EncapAtomicInc( _A, (PVOID)_V )
@@ -165,13 +158,13 @@ #define OS_MEMORY_COPY( _T, _S, _SIZE )	
 #define OS_MEMORY_CLEAR( _A, _S )		memset( (PUCHAR)_A,0,_S)
 #define OS_MEMORY_COMPARE( _A, _B, _S )	(memcmp(_A,_B,_S)? 0 : 1) // Definition is reverse with Ndis 1: the same 0: different
 #define OS_DELAY( _MT )					//NdisStallExecution( _MT ) _MT : microsecond
-//#define OS_SLEEP( _MT )					<--- Supported in WbUsb module
 
-#define OS_SPIN_LOCK					spinlock_t//NDIS_SPIN_LOCK
-#define OS_SPIN_LOCK_ALLOCATE( _S )		spin_lock_init( _S ); //NdisAllocateSpinLock( _S )	
-#define OS_SPIN_LOCK_FREE( _S )			//NdisFreeSpinLock( _S )
+
+#define OS_SPIN_LOCK					spinlock_t
+#define OS_SPIN_LOCK_ALLOCATE( _S )		spin_lock_init( _S );
+#define OS_SPIN_LOCK_FREE( _S )
 #define OS_SPIN_LOCK_ACQUIRED( _S )		spin_lock_irq( _S )
-#define OS_SPIN_LOCK_RELEASED( _S )		spin_unlock_irq( _S ); //NdisReleaseSpinLock( _S )
+#define OS_SPIN_LOCK_RELEASED( _S )		spin_unlock_irq( _S );
 
 #define OS_TIMER						struct timer_list
 #define OS_TIMER_INITIAL( _T, _F, _P )			\
@@ -180,6 +173,7 @@ #define OS_TIMER_INITIAL( _T, _F, _P )		
 	(_T)->function = (void *)_F##_1a;			\
 	(_T)->data = (unsigned long)_P;				\
 }
+
 // _S : Millisecond
 // 20060420 At least 1 large than jiffies
 #define OS_TIMER_SET( _T, _S )					\
@@ -187,7 +181,7 @@ #define OS_TIMER_SET( _T, _S )					\
 	(_T)->expires = jiffies + ((_S*HZ+999)/1000);\
 	add_timer( _T );							\
 }
-#define OS_TIMER_CANCEL( _T, _B )		del_timer_sync( _T ) //NdisMCancelTimer( _T, _B )
+#define OS_TIMER_CANCEL( _T, _B )		del_timer_sync( _T )
 #define OS_TIMER_GET_SYS_TIME( _T )		(*_T=jiffies)
 
 
diff --git a/drivers/net/wireless/winbond/winbondport/linux/new_wireless.c b/drivers/net/wireless/winbond/winbondport/linux/new_wireless.c
index ab25007..2d2c9f3 100644
--- a/drivers/net/wireless/winbond/winbondport/linux/new_wireless.c
+++ b/drivers/net/wireless/winbond/winbondport/linux/new_wireless.c
@@ -1,6 +1,6 @@
 /*************
 
-new_wireless.c, written from dispatch.c by lconstano, some cleanings by scythe
+new_wireless.c, written from dispatch.c by lconstano, some cleanups by scythe
 
 *************/
 
@@ -20,222 +20,203 @@ static int wl3501_chan2freq[] =
 // channel number -> channel freq.
 void ChannelNumToFreq(UCHAR NetworkType, UCHAR ChannelNumber, ULONG *freq)
 {
-   //freq : MHz
-   *freq = wl3501_chan2freq[ChannelNumber] * 100000;
-
-   return; //???? What the hack is this?
-   switch ( NetworkType)
-     {
-      case BAND_TYPE_DSSS:
-      case BAND_TYPE_OFDM_24:
-	if (ChannelNumber <=13)
-	  *freq = 2407 + ChannelNumber*5;
-	else
-	  *freq = 2484;
-	break;
-      case BAND_TYPE_OFDM_5:
-	if (ChannelNumber <= 161)
-	  *freq = 5000 + ChannelNumber*5;
-	else
-	  *freq = 4000 + ChannelNumber*5;
-	break;
-      default:
-	break;
-     }
+	//freq : MHz
+	*freq = wl3501_chan2freq[ChannelNumber] * 100000;
+
+	return; //???? What the hack is this?
+	switch ( NetworkType)
+	{
+	case BAND_TYPE_DSSS:
+	case BAND_TYPE_OFDM_24:
+		if (ChannelNumber <=13)
+			*freq = 2407 + ChannelNumber*5;
+		else
+			*freq = 2484;
+		break;
+	case BAND_TYPE_OFDM_5:
+		if (ChannelNumber <= 161)
+			*freq = 5000 + ChannelNumber*5;
+		else
+			*freq = 4000 + ChannelNumber*5;
+		break;
+	default:
+		break;
+	}
 }
 
-// channel freq. -> channel number
+// channel freq. -> channel number, freq in MHz
 void FreqToChannelNum(UCHAR Band, UCHAR *ChannelNumber, ULONG freq)
 {
-   //freg : MHz
-   switch ( Band )
-     {
-      case BAND_TYPE_DSSS:
-      case BAND_TYPE_OFDM_24:
-	if (freq < 2484)
-	  *ChannelNumber = (UCHAR)((freq-2407)/5);
-	else
-	  *ChannelNumber = 14;
-	break;
-      case BAND_TYPE_OFDM_5:
-	if (freq < 4920)
-	  *ChannelNumber = (UCHAR)((freq-5000)/5);
-	else
-	  *ChannelNumber = (UCHAR)((freq-4000)/5);
-	break;
-      default:
-	break;
-     }
+	switch ( Band ) {
+	case BAND_TYPE_DSSS:
+	case BAND_TYPE_OFDM_24:
+		if (freq < 2484)
+			*ChannelNumber = (UCHAR)((freq-2407)/5);
+		else
+			*ChannelNumber = 14;
+		break;
+	case BAND_TYPE_OFDM_5:
+		if (freq < 4920)
+			*ChannelNumber = (UCHAR)((freq-5000)/5);
+		else
+			*ChannelNumber = (UCHAR)((freq-4000)/5);
+		break;
+	default:
+		break;
+	}
 }
 
 int test_get_name(struct net_device *dev,
 			 struct iw_request_info *info, char *name, char *extra)
 {
-
-   strcpy(name, "IEEE IOCTL TEST");
-   return 0;
+	strcpy(name, "w35und");
+	return 0;
 }
 
 int test_set_scan(struct net_device *dev,
 			 struct iw_request_info *info, struct iw_point *srq, char *extra)
 {
-   PWB32_ADAPTER Adapter=(PWB32_ADAPTER)dev->priv;
-   DEBUG("SET SCAN\n");
-   sme_set_bssid_list_scan( Adapter, NULL );
-   psSCAN->ScanTimeStamp++;//background scan 20061121 Add here for get the last List
+	PWB32_ADAPTER Adapter=(PWB32_ADAPTER)dev->priv;
+	DEBUG("SET SCAN\n");
+	sme_set_bssid_list_scan( Adapter, NULL );
+	psSCAN->ScanTimeStamp++;
 
-      /* We do everything in get_scan */
-   return 0;
+	/* We do everything in get_scan */
+	return 0;
 }
 
 int test_get_scan(struct net_device *dev,
-			 struct iw_request_info *info, struct iw_point *srq, char *extra)
-
+		  struct iw_request_info *info, struct iw_point *srq, char *extra)
 {
-
-   int  i;
-   struct iw_event iwe;
-   char *cev = extra;
-   LONG rssi;
-   char *end_buf = extra + IW_SCAN_MAX_DATA;
-   UCHAR count;
-   PWB32_ADAPTER Adapter=(PWB32_ADAPTER)dev->priv;
-   phw_data_t pHwData=&(Adapter->sHwData);
-
-   WB_BSSDESCRIPTION	*pscan_bss = NULL;
-   ULONG freq;
-   UCHAR scannedESSID[32];
-   int  essid_len;
-
-   //Added by WangJS 2006.7.24
-
-   sme_get_scan_bss_count(Adapter, &count);
-
-   DEBUG(" perform scanning \n");
-   DEBUG(" Total %d STAs have found\n", count);
-
-   if (count > 0)
-     {
-
-	for (i=0; i< count; i++)
-	  {
-	     memset( scannedESSID,0x00,32);
-	     essid_len = 0;
-	     rssi = 0;
-	     sme_get_scan_bss(Adapter, i, (void*)&pscan_bss);
-
-	     Assemble_IE(Adapter, pscan_bss->wIndex);
-	     DEBUG("BSSTYPE: %d\n",pscan_bss->bBssType);
-	     strcpy(scannedESSID, pscan_bss->SSID.SSID);
-	     essid_len = pscan_bss->SSID.Length;
-
-	     //during tests, an outside ap appears twice, ( same mac, same freq, etc ), one essid is empty, the second one is ok,
-	     // so i discard for now the esidd_len = 0
-	     if( essid_len == 0 )
-	       continue;
-	     DEBUG("SSID length:%d ,SSID: %s\n",pscan_bss->SSID.Length,pscan_bss->SSID.SSID);
-	     //	     DataDmp(pscan_bss->SSID.SSID, pscan_bss->SSID.Length, 0);
-
-	     //ACa esta en 1
-	     DEBUG("BSSTYPE: %d\n",pscan_bss->bBssType);
-	     iwe.cmd = SIOCGIWAP;
-	     iwe.u.ap_addr.sa_family = ARPHRD_ETHER;
-	     //REVISTAR ESTO, COPIA MAL
-	     memset(iwe.u.ap_addr.sa_data,0x00,6);
-	     memcpy( iwe.u.ap_addr.sa_data, pscan_bss->abBssID, 6);
-	     cev = iwe_stream_add_event(cev, end_buf, &iwe, IW_EV_ADDR_LEN);
-
-	     DEBUG("WESSID");
-	     //ACA YA PASO a 0 , cambio las capa.......... porq?
-	     DEBUG("BSSTYPE: %d\n",pscan_bss->bBssType);
-	     //----------------------------------------------------
-	     iwe.cmd = SIOCGIWESSID;
-	     iwe.u.data.length = essid_len;
-	     iwe.u.data.flags = 1;
-	     if( iwe.u.data.length > 32 )
-	       iwe.u.data.length = 32;
-
-	     DEBUG("IW Lengt: %d -> %d\n",iwe.u.data.length,essid_len);
-	     cev = iwe_stream_add_point(cev, end_buf, &iwe, scannedESSID);
-	     DEBUG("BSSTYPE: %d\n",pscan_bss->bBssType);
-	     DEBUG("FREQ");
-	     //-----------------------------------------------------
-	     iwe.cmd = SIOCGIWFREQ;
-
-	     ChannelNumToFreq(pscan_bss->band,
-			      pscan_bss->DS_Parameter_Set.Current_Channel,
-			      &freq);
-	     //iwe->u.freq.m = freq;
-	     iwe.u.freq.m = freq;
-
-	     //OS_MEMORY_COPY( &(iwe->u.freq.m), &freq, sizeof(iwe->u.freq.m) );
-	     iwe.u.freq.e = 6;
-	     cev = iwe_stream_add_event(cev, end_buf, &iwe, IW_EV_FREQ_LEN);
-	     DEBUG("BSSTYPE: %d\n",pscan_bss->bBssType);
-	     //------------------------------------------------------
-	     iwe.cmd = SIOCGIWMODE;
-
-	     DEBUG("Mode: %d     (ESS %d) (IBSS %d)\n", pscan_bss->bBssType,ESS_NET,IBSS_NET);
-	     if (pscan_bss->bBssType == ESS_NET)
-	       {
-		  DEBUG("bBssType is ESS_NET\n");
-		  iwe.u.mode =IW_MODE_INFRA;
-	       }
-	     else if (pscan_bss->bBssType == IBSS_NET)
-	       {
-		  DEBUG("bBssType is IBSS_NET\n");
-
-		  iwe.u.mode=IW_MODE_ADHOC;
-	       }
-
-	     cev = iwe_stream_add_event(cev, end_buf, &iwe, IW_EV_UINT_LEN);
-
-	     //------------------------------------------------------
-	     iwe.cmd = IWEVQUAL;
-
-	     //rssi, quality will depend on this value ( dont know h' to get noise lvl from ch)
-	     //GET_QUALITY should get a percentage based on min and max rssi reported by the network interface ...
-	     rssi = hal_get_rssi(pHwData, pscan_bss->HalRssi,MAX_ACC_RSSI_COUNT);
-	     iwe.u.qual.level = rssi;
-	     iwe.u.qual.updated = 7;
-
-	     iwe.u.qual.qual = GET_QUALITY_PERCENTAGE(rssi);
-	     cev = iwe_stream_add_event(cev, end_buf, &iwe, IW_EV_QUAL_LEN);
-	     //iwe->u.qual.level = pscan_bss->HalRssi;
-
-	     //-------------------------------------------------------
-	     iwe.cmd = SIOCGIWENCODE;
-	     iwe.u.data.length = 0;
-
-	     DEBUG("Privacy: 0x%x\nInfo wValue: 0x%x\n",pscan_bss->CapabilityInformation.Capability.CF_Privacy,
-		   pscan_bss->CapabilityInformation.wValue);
-	     if( (!pscan_bss->CapabilityInformation.Capability.CF_Privacy)
-		 && !(pscan_bss->CapabilityInformation.wValue & BIT(4)) )
-	       {
-		  iwe.u.data.flags = IW_ENCODE_DISABLED;
-	       }
-	     else
-	       iwe.u.data.flags = IW_ENCODE_ENABLED;
-	     cev = iwe_stream_add_point(cev, end_buf, &iwe, NULL);
-
-	  }
+	int  i;
+	struct iw_event iwe;
+	char *cev = extra;
+	LONG rssi;
+	char *end_buf = extra + IW_SCAN_MAX_DATA;
+	UCHAR count;
+	PWB32_ADAPTER Adapter=(PWB32_ADAPTER)dev->priv;
+	phw_data_t pHwData=&(Adapter->sHwData);
+
+	WB_BSSDESCRIPTION	*pscan_bss = NULL;
+	ULONG freq;
+	UCHAR scannedESSID[32];
+	int  essid_len;
+
+	sme_get_scan_bss_count(Adapter, &count);
+
+	DEBUG(" perform scanning \n");
+	DEBUG(" Total %d STAs have found\n", count);
+
+	if (count <= 0)
+		return 0;
+	for (i=0; i< count; i++) {
+		memset(scannedESSID, 0x00, 32);
+		essid_len = 0;
+		rssi = 0;
+		sme_get_scan_bss(Adapter, i, (void*)&pscan_bss);
+
+		Assemble_IE(Adapter, pscan_bss->wIndex);
+		DEBUG("BSSTYPE: %d\n", pscan_bss->bBssType);
+		strcpy(scannedESSID, pscan_bss->SSID.SSID);
+		essid_len = pscan_bss->SSID.Length;
+
+		/* during tests, an outside ap appears twice, ( same mac, same freq, etc ), one essid is empty, the second one is ok,
+		 * so i discard for now the esidd_len = 0 */
+		if (!essid_len)
+			continue;
+		DEBUG("SSID length:%d ,SSID: %s\n",pscan_bss->SSID.Length,pscan_bss->SSID.SSID);
+		//	     DataDmp(pscan_bss->SSID.SSID, pscan_bss->SSID.Length, 0);
+
+		//ACa esta en 1
+		DEBUG("BSSTYPE: %d\n",pscan_bss->bBssType);
+		iwe.cmd = SIOCGIWAP;
+		iwe.u.ap_addr.sa_family = ARPHRD_ETHER;
+		//REVISTAR ESTO, COPIA MAL
+		memset(iwe.u.ap_addr.sa_data,0x00,6);
+		memcpy( iwe.u.ap_addr.sa_data, pscan_bss->abBssID, 6);
+		cev = iwe_stream_add_event(cev, end_buf, &iwe, IW_EV_ADDR_LEN);
+
+		DEBUG("WESSID");
+		//ACA YA PASO a 0 , cambio las capa.......... porq?
+		DEBUG("BSSTYPE: %d\n",pscan_bss->bBssType);
+		//----------------------------------------------------
+		iwe.cmd = SIOCGIWESSID;
+		iwe.u.data.length = essid_len;
+		iwe.u.data.flags = 1;
+		if (iwe.u.data.length > 32)
+			iwe.u.data.length = 32;
+
+		DEBUG("IW Lengt: %d -> %d\n",iwe.u.data.length,essid_len);
+		cev = iwe_stream_add_point(cev, end_buf, &iwe, scannedESSID);
+		DEBUG("BSSTYPE: %d\n",pscan_bss->bBssType);
+		DEBUG("FREQ");
+		//-----------------------------------------------------
+		iwe.cmd = SIOCGIWFREQ;
+
+		ChannelNumToFreq(pscan_bss->band,
+				 pscan_bss->DS_Parameter_Set.Current_Channel,
+				 &freq);
+		//iwe->u.freq.m = freq;
+		iwe.u.freq.m = freq;
+
+		//OS_MEMORY_COPY( &(iwe->u.freq.m), &freq, sizeof(iwe->u.freq.m) );
+		iwe.u.freq.e = 6;
+		cev = iwe_stream_add_event(cev, end_buf, &iwe, IW_EV_FREQ_LEN);
+		DEBUG("BSSTYPE: %d\n",pscan_bss->bBssType);
+		//------------------------------------------------------
+		iwe.cmd = SIOCGIWMODE;
+
+		DEBUG("Mode: %d     (ESS %d) (IBSS %d)\n", pscan_bss->bBssType,ESS_NET,IBSS_NET);
+		if (pscan_bss->bBssType == ESS_NET)
+		{
+			DEBUG("bBssType is ESS_NET\n");
+			iwe.u.mode =IW_MODE_INFRA;
+		}
+		else if (pscan_bss->bBssType == IBSS_NET)
+		{
+			DEBUG("bBssType is IBSS_NET\n");
+
+			iwe.u.mode=IW_MODE_ADHOC;
+		}
+
+		cev = iwe_stream_add_event(cev, end_buf, &iwe, IW_EV_UINT_LEN);
+
+		//------------------------------------------------------
+		iwe.cmd = IWEVQUAL;
+
+		//rssi, quality will depend on this value ( dont know h' to get noise lvl from ch)
+		//GET_QUALITY should get a percentage based on min and max rssi reported by the network interface ...
+		rssi = hal_get_rssi(pHwData, pscan_bss->HalRssi,MAX_ACC_RSSI_COUNT);
+		iwe.u.qual.level = rssi;
+		iwe.u.qual.updated = 7;
+
+		iwe.u.qual.qual = GET_QUALITY_PERCENTAGE(rssi);
+		cev = iwe_stream_add_event(cev, end_buf, &iwe, IW_EV_QUAL_LEN);
+		//iwe->u.qual.level = pscan_bss->HalRssi;
+
+		//-------------------------------------------------------
+		iwe.cmd = SIOCGIWENCODE;
+		iwe.u.data.length = 0;
+
+		DEBUG("Privacy: 0x%x\nInfo wValue: 0x%x\n",pscan_bss->CapabilityInformation.Capability.CF_Privacy,
+		      pscan_bss->CapabilityInformation.wValue);
+		if( (!pscan_bss->CapabilityInformation.Capability.CF_Privacy)
+		    && !(pscan_bss->CapabilityInformation.wValue & BIT(4)) )
+		{
+			iwe.u.data.flags = IW_ENCODE_DISABLED;
+		}
+		else
+			iwe.u.data.flags = IW_ENCODE_ENABLED;
+		cev = iwe_stream_add_point(cev, end_buf, &iwe, NULL);
+	}
 
 	srq->length = cev - extra;
 	srq->flags = 0;
 
 	return 0;
-
-     }
-   else
-     {
-	DEBUG("Calling Internal Scanning!\n");
-	//	test_scanning(dev, info,srq, extra);
-
-     }
-
-   return 0;
 }
 
+
 int test_get_freq(struct net_device *dev,
 			 struct iw_request_info *info, struct iw_freq *freq, char *extra)
 {
diff --git a/drivers/net/wireless/winbond/winbondport/linux/sysdef.h b/drivers/net/wireless/winbond/winbondport/linux/sysdef.h
index e4ec713..093b726 100644
--- a/drivers/net/wireless/winbond/winbondport/linux/sysdef.h
+++ b/drivers/net/wireless/winbond/winbondport/linux/sysdef.h
@@ -77,7 +77,7 @@ #include "../wbhal_f.h"
 #include "../wblinux_f.h"
 #include "new_wireless.h"
 // Kernel Timer resolution, NDIS is 10ms, 10000us
-#define MIN_TIMEOUT_VAL				(10)		//ms
+#define MIN_TIMEOUT_VAL	(10) //ms
 
 
 #endif
diff --git a/drivers/net/wireless/winbond/winbondport/linux/wb35reg.c b/drivers/net/wireless/winbond/winbondport/linux/wb35reg.c
index a1e1392..ef3245b 100644
--- a/drivers/net/wireless/winbond/winbondport/linux/wb35reg.c
+++ b/drivers/net/wireless/winbond/winbondport/linux/wb35reg.c
@@ -1,7 +1,6 @@
 #include "sysdef.h"
 
-//Huh?????? phy_cal.h?????
-void phy_calibration_winbond(hw_data_t *phw_data, u32 frequency);
+extern void phy_calibration_winbond(hw_data_t *phw_data, u32 frequency);
 
 // TRUE  : read command process successfully
 // FALSE : register not support
@@ -19,18 +18,16 @@ Wb35Reg_BurstWrite( IN phw_data_t pHwDat
 	USHORT		UrbSize;
 	struct      usb_ctrlrequest *dr;
 	USHORT		i, DataSize = NumberOfData*4;
-//	BOOLEAN	result = FALSE;
 
 	// Module shutdown
-	if( pHwData->SurpriseRemove )
+	if (pHwData->SurpriseRemove)
 		return FALSE;
 
 	// Trying to use burst write function if use new hardware
 	UrbSize = sizeof(REG_QUEUE) + DataSize + sizeof(struct usb_ctrlrequest);
 	OS_MEMORY_ALLOC( (PVOID *)&pRegQueue, UrbSize );
 	pUrb = wb_usb_alloc_urb(0);
-	if( pUrb && pRegQueue )
-	{
+	if( pUrb && pRegQueue ) {
 		pRegQueue->DIRECT = 2;// burst write register
 		pRegQueue->INDEX = RegisterNo;
 		pRegQueue->pBuffer = (PULONG)((PUCHAR)pRegQueue + sizeof(REG_QUEUE));
@@ -50,7 +47,7 @@ Wb35Reg_BurstWrite( IN phw_data_t pHwDat
 		pRegQueue->pUrb = pUrb;
 
 		OS_SPIN_LOCK_ACQUIRED( &pWb35Reg->EP0VM_spin_lock );
-		if( pWb35Reg->pRegFirst == NULL )
+		if (pWb35Reg->pRegFirst == NULL)
 			pWb35Reg->pRegFirst = pRegQueue;
 		else
 			pWb35Reg->pRegLast->Next = pRegQueue;
@@ -59,16 +56,14 @@ Wb35Reg_BurstWrite( IN phw_data_t pHwDat
 		OS_SPIN_LOCK_RELEASED( &pWb35Reg->EP0VM_spin_lock );
 
 		// Start EP0VM
-		Wb35Reg_EP0VM_start( pHwData );
+		Wb35Reg_EP0VM_start(pHwData);
 
 		return TRUE;
-	}
-	else
-	{
-		if( pUrb )
-			usb_free_urb( pUrb );
-		if( pRegQueue )
-			kfree( pRegQueue );
+	} else {
+		if (pUrb)
+			usb_free_urb(pUrb);
+		if (pRegQueue)
+			kfree(pRegQueue);
 		return FALSE;
 	}
    return FALSE;
@@ -78,8 +73,7 @@ VOID
 Wb35Reg_Update( IN phw_data_t pHwData, IN USHORT RegisterNo, IN ULONG RegisterValue )
 {
 	PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
-	switch( RegisterNo )
-	{
+	switch (RegisterNo) {
 	case 0x3b0: pWb35Reg->U1B0 = RegisterValue; break;
 	case 0x3bc: pWb35Reg->U1BC_LEDConfigure = RegisterValue; break;
 	case 0x400: pWb35Reg->D00_DmaControl = RegisterValue; break;
@@ -109,7 +103,7 @@ Wb35Reg_Update( IN phw_data_t pHwData, I
 	case 0x1030: pWb35Reg->BB30 = RegisterValue; break;
 	case 0x103c: pWb35Reg->BB3C = RegisterValue; break;
 	case 0x1048: pWb35Reg->BB48 = RegisterValue; break;
-	case 0x104c: pWb35Reg->BB4C = RegisterValue; break; // 20060615.1 Add
+	case 0x104c: pWb35Reg->BB4C = RegisterValue; break;
 	case 0x1050: pWb35Reg->BB50 = RegisterValue; break;
 	case 0x1054: pWb35Reg->BB54 = RegisterValue; break;
 	case 0x1058: pWb35Reg->BB58 = RegisterValue; break;
@@ -127,7 +121,7 @@ Wb35Reg_WriteSync( IN phw_data_t pHwData
 	int ret = -1;
 
 	// Module shutdown
-	if( pHwData->SurpriseRemove )
+	if (pHwData->SurpriseRemove)
 		return FALSE;
 
 	RegisterValue = cpu_to_le32(RegisterValue);
@@ -136,30 +130,26 @@ Wb35Reg_WriteSync( IN phw_data_t pHwData
 	pWb35Reg->SyncIoPause = 1;
 
 	// 20060717.5 Wait until EP0VM stop
-	while( pWb35Reg->EP0vm_state != VM_STOP )
+	while (pWb35Reg->EP0vm_state != VM_STOP)
 		OS_SLEEP(10000);
 
-	// Sync IoCallDriver -> EL RUNNING TENGO Q PORTARLO ES IMPORTANTE EL ESTADO...... IGUAL VER SI CRASHEA SIN ESO AUNQUE NO ESPERA PARA REENVIAR
+	// Sync IoCallDriver
 	pWb35Reg->EP0vm_state = VM_RUNNING;
 	ret = usb_control_msg( pHwData->WbUsb.udev,
-						   usb_sndctrlpipe( pHwData->WbUsb.udev, 0 ),
-						   0x03 ,
-						   USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
-						   0x0,RegisterNo, &RegisterValue,
-						   4, HZ*100 );
+			       usb_sndctrlpipe( pHwData->WbUsb.udev, 0 ),
+			       0x03, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
+			       0x0,RegisterNo, &RegisterValue, 4, HZ*100 );
 	pWb35Reg->EP0vm_state = VM_STOP;
 	pWb35Reg->SyncIoPause = 0;
 
-	Wb35Reg_EP0VM_start( pHwData );
+	Wb35Reg_EP0VM_start(pHwData);
 
-	if( ret < 0 )
-	{
+	if (ret < 0) {
 		#ifdef _PE_REG_DUMP_
 		WBDEBUG(("EP0 Write register usb message sending error\n"));
 		#endif
 
 		pHwData->SurpriseRemove = 1; // 20060704.2
-
 		return FALSE;
 	}
 
@@ -171,29 +161,28 @@ Wb35Reg_WriteSync( IN phw_data_t pHwData
 BOOLEAN
 Wb35Reg_Write( IN phw_data_t pHwData, IN USHORT RegisterNo, IN ULONG RegisterValue )
 {
-    PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
+	PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
 	struct usb_ctrlrequest *dr;
 	PURB		pUrb = NULL;
 	PREG_QUEUE	pRegQueue = NULL;
 	USHORT		UrbSize;
 
 
-    // Module shutdown
-	if( pHwData->SurpriseRemove )
+	// Module shutdown
+	if (pHwData->SurpriseRemove)
 		return FALSE;
 
 	// update the register by send urb request------------------------------------
 	UrbSize = sizeof(REG_QUEUE) + sizeof(struct usb_ctrlrequest);
 	OS_MEMORY_ALLOC( (PVOID *)&pRegQueue, UrbSize );
 	pUrb = wb_usb_alloc_urb(0);
-	if( pUrb && pRegQueue )
-	{
+	if (pUrb && pRegQueue) {
 		pRegQueue->DIRECT = 1;// burst write register
 		pRegQueue->INDEX = RegisterNo;
 		pRegQueue->VALUE = cpu_to_le32(RegisterValue);
 		pRegQueue->RESERVED_VALID = FALSE;
 		dr = (struct usb_ctrlrequest *)((PUCHAR)pRegQueue + sizeof(REG_QUEUE));
-        dr->bRequestType = USB_TYPE_VENDOR|USB_DIR_OUT |USB_RECIP_DEVICE;
+		dr->bRequestType = USB_TYPE_VENDOR|USB_DIR_OUT |USB_RECIP_DEVICE;
 		dr->bRequest = 0x03; // USB or vendor-defined request code, burst mode
 		dr->wValue = cpu_to_le16(0x0);
 		dr->wIndex = cpu_to_le16(RegisterNo);
@@ -202,10 +191,10 @@ Wb35Reg_Write( IN phw_data_t pHwData, IN
 		// Enter the sending queue
 		pRegQueue->Next = NULL;
 		pRegQueue->pUsbReq = dr;
-        pRegQueue->pUrb = pUrb;
+		pRegQueue->pUrb = pUrb;
 
 		OS_SPIN_LOCK_ACQUIRED(&pWb35Reg->EP0VM_spin_lock );
-		if( pWb35Reg->pRegFirst == NULL )
+		if (pWb35Reg->pRegFirst == NULL)
 			pWb35Reg->pRegFirst = pRegQueue;
 		else
 			pWb35Reg->pRegLast->Next = pRegQueue;
@@ -214,16 +203,13 @@ Wb35Reg_Write( IN phw_data_t pHwData, IN
 		OS_SPIN_LOCK_RELEASED( &pWb35Reg->EP0VM_spin_lock );
 
 		// Start EP0VM
-		Wb35Reg_EP0VM_start( pHwData );
+		Wb35Reg_EP0VM_start(pHwData);
 
 		return TRUE;
-	}
-	else
-	{
-	    if( pUrb )
-			usb_free_urb( pUrb );
-		if( pRegQueue )
-			kfree( pRegQueue );
+	} else {
+		if (pUrb)
+			usb_free_urb(pUrb);
+		kfree(pRegQueue);
 		return FALSE;
 	}
 }
@@ -233,29 +219,24 @@ Wb35Reg_Write( IN phw_data_t pHwData, IN
 // TRUE  : read command process successfully
 // FALSE : register not support
 BOOLEAN
-Wb35Reg_WriteWithCallbackValue( IN phw_data_t pHwData,
-								IN USHORT RegisterNo,
-								IN ULONG RegisterValue,
-								IN PCHAR pValue,
-								IN CHAR	Len)
+Wb35Reg_WriteWithCallbackValue( phw_data_t pHwData, USHORT RegisterNo, ULONG RegisterValue,
+				PCHAR pValue, CHAR Len)
 {
-    PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
+	PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
 	struct usb_ctrlrequest *dr;
 	PURB		pUrb = NULL;
 	PREG_QUEUE	pRegQueue = NULL;
 	USHORT		UrbSize;
 
-
 	// Module shutdown
-	if( pHwData->SurpriseRemove )
+	if (pHwData->SurpriseRemove)
 		return FALSE;
 
 	// update the register by send urb request------------------------------------
 	UrbSize = sizeof(REG_QUEUE) + sizeof(struct usb_ctrlrequest);
-	OS_MEMORY_ALLOC( (PVOID *)&pRegQueue, UrbSize );
+	OS_MEMORY_ALLOC((PVOID *) &pRegQueue, UrbSize );
 	pUrb = wb_usb_alloc_urb(0);
-	if( pUrb && pRegQueue )
-	{
+	if (pUrb && pRegQueue) {
 		pRegQueue->DIRECT = 1;// burst write register
 		pRegQueue->INDEX = RegisterNo;
 		pRegQueue->VALUE = cpu_to_le32(RegisterValue);
@@ -283,16 +264,12 @@ Wb35Reg_WriteWithCallbackValue( IN phw_d
 		OS_SPIN_LOCK_RELEASED ( &pWb35Reg->EP0VM_spin_lock );
 
 		// Start EP0VM
-		Wb35Reg_EP0VM_start( pHwData );
-
+		Wb35Reg_EP0VM_start(pHwData);
 		return TRUE;
-	}
-	else
-	{
-	    if( pUrb )
-			usb_free_urb( pUrb );
-		if( pRegQueue )
-			kfree( pRegQueue );
+	} else {
+		if (pUrb)
+			usb_free_urb(pUrb);
+		kfree(pRegQueue);
 		return FALSE;
 	}
 }
@@ -306,10 +283,9 @@ Wb35Reg_ReadSync( IN phw_data_t pHwData,
 	PWB35REG pWb35Reg = &pHwData->Wb35Reg;
 	PULONG	pltmp = pRegisterValue;
 	int ret = -1;
-	
 
 	// Module shutdown
-	if( pHwData->SurpriseRemove )
+	if (pHwData->SurpriseRemove)
 		return FALSE;
 
 	// Read the register by send usb message------------------------------------
@@ -317,35 +293,30 @@ Wb35Reg_ReadSync( IN phw_data_t pHwData,
 	pWb35Reg->SyncIoPause = 1;
 
 	// 20060717.5 Wait until EP0VM stop
-	while( pWb35Reg->EP0vm_state != VM_STOP )
+	while (pWb35Reg->EP0vm_state != VM_STOP)
 		OS_SLEEP(10000);
 
 	pWb35Reg->EP0vm_state = VM_RUNNING;
 	ret = usb_control_msg( pHwData->WbUsb.udev,
-						   usb_rcvctrlpipe(pHwData->WbUsb.udev, 0),
-						   0x01,
-						   USB_TYPE_VENDOR|USB_RECIP_DEVICE|USB_DIR_IN,
-						   0x0, RegisterNo, pltmp,
-						   4, HZ*100 );
+			       usb_rcvctrlpipe(pHwData->WbUsb.udev, 0),
+			       0x01, USB_TYPE_VENDOR|USB_RECIP_DEVICE|USB_DIR_IN,
+			       0x0, RegisterNo, pltmp, 4, HZ*100 );
 
 	*pRegisterValue = cpu_to_le32(*pltmp);
 
 	pWb35Reg->EP0vm_state = VM_STOP;
 
-	// 20051230 Add
 	Wb35Reg_Update( pHwData, RegisterNo, *pRegisterValue );
 	pWb35Reg->SyncIoPause = 0;
 
 	Wb35Reg_EP0VM_start( pHwData );
 
-	if( ret < 0 )
-	{
+	if (ret < 0) {
 		#ifdef _PE_REG_DUMP_
 		WBDEBUG(("EP0 Read register usb message sending error\n"));
 		#endif
 
 		pHwData->SurpriseRemove = 1; // 20060704.2
-
 		return FALSE;
 	}
 
@@ -356,17 +327,16 @@ Wb35Reg_ReadSync( IN phw_data_t pHwData,
 // FALSE : register not support
 // pRegisterValue : It must be a resident buffer due to asynchronous read register.
 BOOLEAN
-Wb35Reg_Read( IN phw_data_t pHwData, IN USHORT RegisterNo, IN OUT PULONG pRegisterValue )
+Wb35Reg_Read(phw_data_t pHwData, USHORT RegisterNo, OUT PULONG pRegisterValue )
 {
-    PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
-    struct usb_ctrlrequest * dr;
+	PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
+	struct usb_ctrlrequest * dr;
 	PURB		pUrb;
 	PREG_QUEUE	pRegQueue;
 	USHORT		UrbSize;
 
-
 	// Module shutdown
-	if( pHwData->SurpriseRemove )
+	if (pHwData->SurpriseRemove)
 		return FALSE;
 
 	// update the variable by send Urb to read register ------------------------------------
@@ -402,13 +372,10 @@ Wb35Reg_Read( IN phw_data_t pHwData, IN 
 		Wb35Reg_EP0VM_start( pHwData );
 
 		return TRUE;
-	}
-	else
-	{
-		if( pUrb )
+	} else {
+		if (pUrb)
 			usb_free_urb( pUrb );
-		if( pRegQueue )
-			kfree( pRegQueue );
+		kfree(pRegQueue);
 		return FALSE;
 	}
 }
@@ -417,19 +384,17 @@ Wb35Reg_Read( IN phw_data_t pHwData, IN 
 VOID
 Wb35Reg_EP0VM_start( IN phw_data_t pHwData )
 {
-    PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
+	PWB35REG pWb35Reg = &pHwData->Wb35Reg;
     
-	if( OS_ATOMIC_INC( pHwData->Adapter, &pWb35Reg->RegFireCount) == 1 )
-	{
-	    pWb35Reg->EP0vm_state = VM_RUNNING;
+	if (OS_ATOMIC_INC( pHwData->Adapter, &pWb35Reg->RegFireCount) == 1) {
+		pWb35Reg->EP0vm_state = VM_RUNNING;
 		Wb35Reg_EP0VM(pHwData);
-	}
-	else
+	} else
 		OS_ATOMIC_DEC( pHwData->Adapter, &pWb35Reg->RegFireCount );
 }
 
 VOID
-Wb35Reg_EP0VM( IN phw_data_t pHwData )
+Wb35Reg_EP0VM(phw_data_t pHwData )
 {
 	PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
 	PURB		pUrb;
@@ -439,62 +404,57 @@ Wb35Reg_EP0VM( IN phw_data_t pHwData )
 	PREG_QUEUE	pRegQueue;
 
 
-    do
-	{
-		if( pWb35Reg->SyncIoPause )
-			break;
+	if (pWb35Reg->SyncIoPause)
+		goto cleanup;
 
-		if( pHwData->SurpriseRemove )
-			break;
+	if (pHwData->SurpriseRemove)
+		goto cleanup;
 
-		// Get the register data and send to USB through Irp
-		OS_SPIN_LOCK_ACQUIRED( &pWb35Reg->EP0VM_spin_lock );
-		pRegQueue = pWb35Reg->pRegFirst;
-		OS_SPIN_LOCK_RELEASED( &pWb35Reg->EP0VM_spin_lock );
+	// Get the register data and send to USB through Irp
+	OS_SPIN_LOCK_ACQUIRED( &pWb35Reg->EP0VM_spin_lock );
+	pRegQueue = pWb35Reg->pRegFirst;
+	OS_SPIN_LOCK_RELEASED( &pWb35Reg->EP0VM_spin_lock );
 
-		if( pRegQueue == NULL )
-			break;
+	if (!pRegQueue)
+		goto cleanup;
 
-		// Get an Urb, send it
-		pUrb = (PURB)pRegQueue->pUrb;
+	// Get an Urb, send it
+	pUrb = (PURB)pRegQueue->pUrb;
 
-		dr = pRegQueue->pUsbReq;
-		pUrb = pRegQueue->pUrb;
-		pBuffer = pRegQueue->pBuffer;
-		if( pRegQueue->DIRECT == 1 ) // output
-			pBuffer = &pRegQueue->VALUE;
+	dr = pRegQueue->pUsbReq;
+	pUrb = pRegQueue->pUrb;
+	pBuffer = pRegQueue->pBuffer;
+	if (pRegQueue->DIRECT == 1) // output
+		pBuffer = &pRegQueue->VALUE;
 
-		usb_fill_control_urb( pUrb,
-					  pHwData->WbUsb.udev,
-					  REG_DIRECTION(pHwData->WbUsb.udev,pRegQueue),
-					  (PUCHAR)dr,pBuffer,cpu_to_le16(dr->wLength),
-					  Wb35Reg_EP0VM_complete,(void*)pHwData);
+	usb_fill_control_urb( pUrb, pHwData->WbUsb.udev,
+			      REG_DIRECTION(pHwData->WbUsb.udev,pRegQueue),
+			      (PUCHAR)dr,pBuffer,cpu_to_le16(dr->wLength),
+			      Wb35Reg_EP0VM_complete, (void*)pHwData);
 
-		pWb35Reg->EP0vm_state = VM_RUNNING;
+	pWb35Reg->EP0vm_state = VM_RUNNING;
 		
-		ret = wb_usb_submit_urb( pUrb );
-
-    		if( ret < 0 )
-    		{
-			#ifdef _PE_REG_DUMP_
-			WBDEBUG(("EP0 Irp sending error\n"));
-			#endif
-			break;
-    		}
+	ret = wb_usb_submit_urb( pUrb );
 
-		return;
+	if (ret < 0) {
+#ifdef _PE_REG_DUMP_
+		WBDEBUG(("EP0 Irp sending error\n"));
+#endif
+		goto cleanup;
+	}
 
-	}while(FALSE);
+	return;
 
+ cleanup:
 	pWb35Reg->EP0vm_state = VM_STOP;
 	OS_ATOMIC_DEC( pHwData->Adapter, &pWb35Reg->RegFireCount );
 }
 
 
 VOID
-Wb35Reg_EP0VM_complete( IN PURB pUrb )
+Wb35Reg_EP0VM_complete(PURB pUrb)
 {
-    phw_data_t  pHwData = (phw_data_t)pUrb->context;
+	phw_data_t  pHwData = (phw_data_t)pUrb->context;
 	PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
 	PREG_QUEUE	pRegQueue;
 
@@ -503,157 +463,140 @@ Wb35Reg_EP0VM_complete( IN PURB pUrb )
 	pWb35Reg->EP0vm_state = VM_COMPLETED;
 	pWb35Reg->EP0VM_status = pUrb->status;
 
-	if( pHwData->SurpriseRemove ) // Let WbWlanHalt to handle surprise remove
-	{
+	if (pHwData->SurpriseRemove) { // Let WbWlanHalt to handle surprise remove
 		pWb35Reg->EP0vm_state = VM_STOP;
 		OS_ATOMIC_DEC( pHwData->Adapter, &pWb35Reg->RegFireCount );
-	}
-	else
-	{
+	} else {
 		// Complete to send, remove the URB from the first
 		OS_SPIN_LOCK_ACQUIRED( &pWb35Reg->EP0VM_spin_lock );
 		pRegQueue = pWb35Reg->pRegFirst;
-		if( pRegQueue == pWb35Reg->pRegLast )
+		if (pRegQueue == pWb35Reg->pRegLast)
 			pWb35Reg->pRegLast = NULL;
 		pWb35Reg->pRegFirst = pWb35Reg->pRegFirst->Next;
 		OS_SPIN_LOCK_RELEASED( &pWb35Reg->EP0VM_spin_lock );
 
-		if( pWb35Reg->EP0VM_status != 0 )
-		{
-			#ifdef _PE_REG_DUMP_
+		if (pWb35Reg->EP0VM_status) {
+#ifdef _PE_REG_DUMP_
 			WBDEBUG(("EP0 IoCompleteRoutine return error\n"));
 			DebugUsbdStatusInformation( pWb35Reg->EP0VM_status );
-			#endif
+#endif
 			pWb35Reg->EP0vm_state = VM_STOP;
 			pHwData->SurpriseRemove = 1;
-		}
-		else
-		{
+		} else {
 			// Success. Update the result
-		    if( pRegQueue->DIRECT == 0 ) // Update for input only
-			{
+			if (pRegQueue->DIRECT == 0) { // Update for input only
 				*(ULONG*)pRegQueue->pBuffer = cpu_to_le32( *(ULONG*)pRegQueue->pBuffer);
-
-				// 20051230 Add
 				Wb35Reg_Update( pHwData, pRegQueue->INDEX, *(PULONG)pRegQueue->pBuffer );
 
 				// Do more thing
 				switch( pRegQueue->INDEX )
 				{
-					case 0x830: if( pHwData->bssid_pointer )
-								{
-									//------20061011 anson's endian
-									*(PULONG)pHwData->bssid = le32_to_cpu(*(PULONG)pHwData->bssid);
-									*(PULONG)(pHwData->bssid + 4) = le32_to_cpu(*(PULONG)(pHwData->bssid +4 ));
-
-									//WBDEBUG(("get bssid:%08x-%08x\n",*(PULONG)pHwData->bssid,*(PULONG)(pHwData->bssid+4)));	
-									//---end anson's endian
-									OS_MEMORY_COPY( pHwData->bssid_pointer, pHwData->bssid, ETH_LENGTH_OF_ADDRESS );
-									hal_get_bssid_complete( pHwData );
-									pHwData->bssid_pointer = NULL;
-								}
-								break;
-					case 0x84c: pWb35Reg->mac_power_save = FALSE;
-				        	    if( !(pWb35Reg->M4C_MacStatus & 0x20000000) )
-								    pWb35Reg->mac_power_save = TRUE;
-
-								if( pHwData->power_save_point )
-								{
-									*pHwData->power_save_point = pWb35Reg->mac_power_save;
-									hal_get_power_save_mode_complete( pHwData );
-									pHwData->power_save_point = NULL;
-								}
-								break;
+				case 0x830: if( pHwData->bssid_pointer )
+				{
+					*(PULONG)pHwData->bssid = le32_to_cpu(*(PULONG)pHwData->bssid);
+					*(PULONG)(pHwData->bssid + 4) = le32_to_cpu(*(PULONG)(pHwData->bssid +4 ));
+
+					OS_MEMORY_COPY( pHwData->bssid_pointer, pHwData->bssid, ETH_LENGTH_OF_ADDRESS );
+					hal_get_bssid_complete( pHwData );
+					pHwData->bssid_pointer = NULL;
 				}
-			}
-		    else //setting
-			{
+					break;
+				case 0x84c: pWb35Reg->mac_power_save = FALSE;
+					if (!(pWb35Reg->M4C_MacStatus & 0x20000000))
+						pWb35Reg->mac_power_save = TRUE;
+
+					if (pHwData->power_save_point) {
+						*pHwData->power_save_point = pWb35Reg->mac_power_save;
+						hal_get_power_save_mode_complete( pHwData );
+						pHwData->power_save_point = NULL;
+					}
+					break;
+				}
+			} else {
+				//setting
+		
 				switch( pRegQueue->INDEX )
 				{
-					case 0x881c: if( pHwData->IsKeyPreSet ) // 20060727 Modify for burst command
-								{
-									pHwData->IsKeyPreSet = 0;
-									#ifdef _PE_REG_DUMP_
-									WBDEBUG(("35: Defer send cancel. Start to send at set[%d] key data\n", 8));
-									#endif
-									Wb35Tx_start( pHwData );
-								}
-								break;
-
-					case 0x824:	if ((pHwData->IsWaitJoinComplete) && 
-									(pHwData->bss_type==1))	//infrastructure mode only
-								{
-									#ifdef _PE_REG_DUMP_
-									WBDEBUG(("** Join OK **\n"));
-									#endif
-									pHwData->IsWaitJoinComplete = FALSE;
-									hal_join_OK( pHwData );
-								}
-								break;
-					case 0x828:	if (pRegQueue->RESERVED_VALID)
-								{
-									ChanInfo HwChan;
-
-									HwChan = *(ChanInfo *)pRegQueue->RESERVED;
-									//Indicate the H/W real setting
-									hal_set_chan_complete(pHwData, HwChan);
-								}
-								break;
-					case 0x840: if( !(pRegQueue->VALUE & 0x4000) )
-								{
-									#ifdef _PE_REG_DUMP_
-									WBDEBUG(("35: ACK is ON\n"));
-									#endif
-								}
-								break;
+				case 0x881c: if( pHwData->IsKeyPreSet ) // 20060727 Modify for burst command
+				{
+					pHwData->IsKeyPreSet = 0;
+#ifdef _PE_REG_DUMP_
+					WBDEBUG(("35: Defer send cancel. Start to send at set[%d] key data\n", 8));
+#endif
+					Wb35Tx_start( pHwData );
+				}
+					break;
+
+				case 0x824:	if ((pHwData->IsWaitJoinComplete) && 
+						    (pHwData->bss_type==1))	//infrastructure mode only
+				{
+#ifdef _PE_REG_DUMP_
+					WBDEBUG(("** Join OK **\n"));
+#endif
+					pHwData->IsWaitJoinComplete = FALSE;
+					hal_join_OK( pHwData );
+				}
+					break;
+				case 0x828:	if (pRegQueue->RESERVED_VALID)
+				{
+					ChanInfo HwChan;
+
+					HwChan = *(ChanInfo *)pRegQueue->RESERVED;
+					//Indicate the H/W real setting
+					hal_set_chan_complete(pHwData, HwChan);
+				}
+					break;
+				case 0x840: if( !(pRegQueue->VALUE & 0x4000) )
+				{
+#ifdef _PE_REG_DUMP_
+					WBDEBUG(("35: ACK is ON\n"));
+#endif
+				}
+					break;
 				}
 			}
 
 			// Start the next send
-    		Wb35Reg_EP0VM(pHwData);
+			Wb35Reg_EP0VM(pHwData);
 		}
 
-   		kfree( pRegQueue );
+   		kfree(pRegQueue);
 	}
 
-    usb_free_urb( pUrb );
+	usb_free_urb(pUrb);
 }
 
 
 VOID
-Wb35Reg_destroy( IN phw_data_t pHwData )
+Wb35Reg_destroy(phw_data_t pHwData)
 {
 	PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
 	PURB		pUrb;
 	PREG_QUEUE	pRegQueue;
 
 
-	Uxx_power_off_procedure( pHwData );
+	Uxx_power_off_procedure(pHwData);
 
 	// Wait for Reg operation completed
-	do{
+	do {
 		OS_SLEEP(10000); // Delay for waiting function enter 940623.1.a
-	}while( pWb35Reg->EP0vm_state != VM_STOP );
+	} while (pWb35Reg->EP0vm_state != VM_STOP);
 	OS_SLEEP(10000);  // Delay for waiting function enter 940623.1.b
 
 	// Release all the data in RegQueue
 	OS_SPIN_LOCK_ACQUIRED( &pWb35Reg->EP0VM_spin_lock );
 	pRegQueue = pWb35Reg->pRegFirst;
-	while( pRegQueue != NULL )
-	{
-		if( pRegQueue == pWb35Reg->pRegLast )
+	while (pRegQueue) {
+		if (pRegQueue == pWb35Reg->pRegLast)
 			pWb35Reg->pRegLast = NULL;
 		pWb35Reg->pRegFirst = pWb35Reg->pRegFirst->Next;
 
 		pUrb = pRegQueue->pUrb;
 		OS_SPIN_LOCK_RELEASED( &pWb35Reg->EP0VM_spin_lock );
-		if( pUrb )
-		{
+		if (pUrb) {
 			usb_free_urb(pUrb);
 			kfree(pRegQueue);
-		}
-		else
-		{
+		} else {
 			#ifdef _PE_REG_DUMP_
 			WBDEBUG(("EP0 queue release error\n"));
 			#endif
@@ -668,49 +611,49 @@ Wb35Reg_destroy( IN phw_data_t pHwData )
 	OS_SPIN_LOCK_FREE(  &pWb35Reg->EP0VM_spin_lock );
 }
 
-//===============================================================================================
+//====================================================================================
 // The function can be run in passive-level only.
-//===============================================================================================
+//====================================================================================
 BOOLEAN Wb35Reg_initial( IN phw_data_t pHwData )
 {
-    PWB35REG pWb35Reg=&pHwData->Wb35Reg;
-	ULONG		ltmp;
-	ULONG		SoftwareSet, VCO_trim, TxVga, Region_ScanInterval;
+	PWB35REG pWb35Reg=&pHwData->Wb35Reg;
+	ULONG ltmp;
+	ULONG SoftwareSet, VCO_trim, TxVga, Region_ScanInterval;
 	
 	// Spin lock is acquired for read and write IRP command
 	OS_SPIN_LOCK_ALLOCATE( &pWb35Reg->EP0VM_spin_lock );
 
-	// Getting RF module type from EEPROM -----------------------------------------------
+	// Getting RF module type from EEPROM ------------------------------------
 	Wb35Reg_WriteSync( pHwData, 0x03b4, 0x080d0000 ); // Start EEPROM access + Read + address(0x0d)
 	Wb35Reg_ReadSync( pHwData, 0x03b4, &ltmp );
+
 	//Update RF module type and determine the PHY type by inf or EEPROM
 	pWb35Reg->EEPROMPhyType = (UCHAR)( ltmp & 0xff );
 	// 0 V MAX2825, 1 V MAX2827, 2 V MAX2828, 3 V MAX2829
 	// 16V AL2230, 17 - AL7230, 18 - AL2230S
 	// 32 Reserved
 	// 33 - W89RF242(TxVGA 0~19), 34 - W89RF242(TxVGA 0~34)
-	if( pWb35Reg->EEPROMPhyType != RF_DECIDE_BY_INF )
-	{
+	if (pWb35Reg->EEPROMPhyType != RF_DECIDE_BY_INF) {
 		if( (pWb35Reg->EEPROMPhyType == RF_MAXIM_2825)	||
 			(pWb35Reg->EEPROMPhyType == RF_MAXIM_2827)	||
 			(pWb35Reg->EEPROMPhyType == RF_MAXIM_2828)	||
 			(pWb35Reg->EEPROMPhyType == RF_MAXIM_2829)	||
 			(pWb35Reg->EEPROMPhyType == RF_MAXIM_V1)	||
 			(pWb35Reg->EEPROMPhyType == RF_AIROHA_2230)	||
-			(pWb35Reg->EEPROMPhyType == RF_AIROHA_2230S)|| // 20060420 Add this
+			(pWb35Reg->EEPROMPhyType == RF_AIROHA_2230S)    ||
 			(pWb35Reg->EEPROMPhyType == RF_AIROHA_7230)	||
 			(pWb35Reg->EEPROMPhyType == RF_WB_242)		||
-			(pWb35Reg->EEPROMPhyType == RF_WB_242_1) ) // 20060619.5 Add
+			(pWb35Reg->EEPROMPhyType == RF_WB_242_1))
 			pHwData->phy_type = pWb35Reg->EEPROMPhyType;
 	}	
 
 	// Power On procedure running. The relative parameter will be set according to phy_type
-    Uxx_power_on_procedure( pHwData );
+	Uxx_power_on_procedure( pHwData );
 
 	// Reading MAC address
 	Uxx_ReadEthernetAddress( pHwData );
 
-    // Read VCO trim for RF parameter
+	// Read VCO trim for RF parameter
 	Wb35Reg_WriteSync( pHwData, 0x03b4, 0x08200000 );
 	Wb35Reg_ReadSync( pHwData, 0x03b4, &VCO_trim );
 
@@ -721,14 +664,13 @@ BOOLEAN Wb35Reg_initial( IN phw_data_t p
 	// Read TXVGA
 	Wb35Reg_WriteSync( pHwData, 0x03b4, 0x08100000 );
 	Wb35Reg_ReadSync( pHwData, 0x03b4, &TxVga );
-
 	
 	// Get Scan interval setting from EEPROM offset 0x1c
 	Wb35Reg_WriteSync( pHwData, 0x03b4, 0x081d0000 );
 	Wb35Reg_ReadSync( pHwData, 0x03b4, &Region_ScanInterval );
 
 	// Update Ethernet address
-	OS_MEMORY_COPY( pHwData->CurrentMacAddress,	pHwData->PermanentMacAddress, ETH_LENGTH_OF_ADDRESS );
+	OS_MEMORY_COPY( pHwData->CurrentMacAddress, pHwData->PermanentMacAddress, ETH_LENGTH_OF_ADDRESS );
 
 	#ifdef _PE_REG_DUMP_
 	{
@@ -749,7 +691,7 @@ BOOLEAN Wb35Reg_initial( IN phw_data_t p
 	TxVga &= 0x000000ff;
 	pHwData->PowerIndexFromEEPROM = (u8)TxVga;
 	pHwData->VCO_trim = (UCHAR)VCO_trim & 0xff;
-	if( pHwData->VCO_trim == 0xff )
+	if (pHwData->VCO_trim == 0xff)
 		pHwData->VCO_trim = 0x28;
 
 	pWb35Reg->EEPROMRegion = (UCHAR)(Region_ScanInterval>>8); // 20060720
@@ -761,27 +703,26 @@ BOOLEAN Wb35Reg_initial( IN phw_data_t p
 
 	// Set Scan Interval
 	pHwData->Scan_Interval = (UCHAR)(Region_ScanInterval & 0xff) * 10;
-	if( (pHwData->Scan_Interval == 2550) || (pHwData->Scan_Interval < 10) ) // Is default setting 0xff * 10
+	if ((pHwData->Scan_Interval == 2550) || (pHwData->Scan_Interval < 10)) // Is default setting 0xff * 10
 		pHwData->Scan_Interval = SCAN_MAX_CHNL_TIME;
 
 	// Initial register
-	RFSynthesizer_initial( pHwData );
+	RFSynthesizer_initial(pHwData);
 
-	BBProcessor_initial( pHwData ); // Async write, must wait until complete
+	BBProcessor_initial(pHwData); // Async write, must wait until complete
 
-	Wb35Reg_phy_calibration( pHwData );
+	Wb35Reg_phy_calibration(pHwData);
 
-	Mxx_initial( pHwData );
+	Mxx_initial(pHwData);
+	Dxx_initial(pHwData);
 
-	Dxx_initial( pHwData ); // 20060901 swap with above
-
-	if( pHwData->SurpriseRemove )
+	if (pHwData->SurpriseRemove)
 		return FALSE;
 	else
 		return TRUE; // Initial fail
 }
 
-//=============================================================================================================
+//===================================================================================
 //  CardComputeCrc --
 //
 //  Description:
@@ -797,10 +738,9 @@ BOOLEAN Wb35Reg_initial( IN phw_data_t p
 //  Note:
 //    This is adapted from the comments in the assembly language
 //    version in _GENREQ.ASM of the DWB NE1000/2000 driver.
-//=============================================================================================================
+//==================================================================================
 ULONG
-CardComputeCrc( IN PUCHAR Buffer,
-                IN UINT Length)
+CardComputeCrc(PUCHAR Buffer, UINT Length)
 {
     ULONG Crc, Carry;
     UINT  i, j;
@@ -828,7 +768,6 @@ CardComputeCrc( IN PUCHAR Buffer,
 }
 
 
-// 1.0.6.114 Added
 //==================================================================
 // BitReverse --
 //   Reverse the bits in the input argument, dwData, which is 
@@ -843,45 +782,38 @@ CardComputeCrc( IN PUCHAR Buffer,
 //==================================================================
 ULONG BitReverse( ULONG dwData, ULONG DataLength)
 {
+	ULONG   HalfLength, i, j;
+	ULONG   BitA, BitB;
 
-    ULONG   HalfLength, i, j;
-    ULONG   BitA, BitB;
-
-    if ( DataLength <= 0)       return 0;   // No conversion is done.
+	if ( DataLength <= 0)       return 0;   // No conversion is done.
 	dwData = dwData & (0xffffffff >> (32 - DataLength));
 
-    HalfLength = DataLength / 2;
-    for ( i = 0, j = DataLength-1 ; i < HalfLength; i++, j--)
-    {
-        BitA = GetBit( dwData, i);
-        BitB = GetBit( dwData, j);
-        if ( BitA && !BitB)
-        {
-            dwData = ClearBit( dwData, i);
-            dwData = SetBit( dwData, j);
-        }
-        else if ( !BitA && BitB)
-        {
-            dwData = SetBit( dwData, i);
-            dwData = ClearBit( dwData, j);
-        }
-        else
-        {
-            // Do nothing since these two bits are of the save values.
-        }
-    }
+	HalfLength = DataLength / 2;
+	for ( i = 0, j = DataLength-1 ; i < HalfLength; i++, j--)
+	{
+		BitA = GetBit( dwData, i);
+		BitB = GetBit( dwData, j);
+		if (BitA && !BitB) {
+			dwData = ClearBit( dwData, i);
+			dwData = SetBit( dwData, j);
+		} else if (!BitA && BitB) {
+			dwData = SetBit( dwData, i);
+			dwData = ClearBit( dwData, j);
+		} else
+		{
+			// Do nothing since these two bits are of the save values.
+		}
+	}
 
-    return dwData;
+	return dwData;
 }
 
 VOID Wb35Reg_phy_calibration( IN phw_data_t pHwData )
 {
-//	PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
-	ULONG		BB3c, BB54;
+	ULONG BB3c, BB54;
 
-	if( (pHwData->phy_type == RF_WB_242) ||
-		(pHwData->phy_type == RF_WB_242_1) ) // 20060619.5 Add
-	{
+	if ((pHwData->phy_type == RF_WB_242) ||
+		(pHwData->phy_type == RF_WB_242_1)) {
 		phy_calibration_winbond ( pHwData, 2412 ); // Sync operation
 		Wb35Reg_ReadSync( pHwData, 0x103c, &BB3c );
 		Wb35Reg_ReadSync( pHwData, 0x1054, &BB54 );
@@ -889,8 +821,8 @@ VOID Wb35Reg_phy_calibration( IN phw_dat
 		pHwData->BB3c_cal = BB3c;
 		pHwData->BB54_cal = BB54;
 
-		RFSynthesizer_initial( pHwData );
-		BBProcessor_initial( pHwData ); // Async operation
+		RFSynthesizer_initial(pHwData);
+		BBProcessor_initial(pHwData); // Async operation
 
 		Wb35Reg_WriteSync( pHwData, 0x103c, BB3c );
 		Wb35Reg_WriteSync( pHwData, 0x1054, BB54 );
diff --git a/drivers/net/wireless/winbond/winbondport/linux/wb35rx.c b/drivers/net/wireless/winbond/winbondport/linux/wb35rx.c
index 021ef9a..f55db13 100644
--- a/drivers/net/wireless/winbond/winbondport/linux/wb35rx.c
+++ b/drivers/net/wireless/winbond/winbondport/linux/wb35rx.c
@@ -11,18 +11,16 @@
 #include "sysdef.h"
 
 
-VOID Wb35Rx_start( IN phw_data_t pHwData )
+VOID Wb35Rx_start(phw_data_t pHwData)
 {
-	PWB35RX		pWb35Rx = &pHwData->Wb35Rx;
+	PWB35RX pWb35Rx = &pHwData->Wb35Rx;
 
 	// Allow only one thread to run into the Wb35Rx() function
-	if( OS_ATOMIC_INC( pHwData->Adapter, &pWb35Rx->RxFireCounter ) == 1 )
-	{
+	if (OS_ATOMIC_INC(pHwData->Adapter, &pWb35Rx->RxFireCounter) == 1) {
 		pWb35Rx->EP3vm_state = VM_RUNNING;
-		Wb35Rx( pHwData );
-	}
-	else
-		OS_ATOMIC_DEC( pHwData->Adapter, &pWb35Rx->RxFireCounter );
+		Wb35Rx(pHwData);
+	} else
+		OS_ATOMIC_DEC(pHwData->Adapter, &pWb35Rx->RxFireCounter);
 }
 
 // This function cannot reentrain
@@ -31,25 +29,22 @@ VOID Wb35Rx( IN phw_data_t pHwData )
 	PWB35RX		pWb35Rx = &pHwData->Wb35Rx;
 	PUCHAR		pRxBufferAddress;
 	PURB		pUrb = (PURB)pWb35Rx->RxUrb;
-	int			retv;
+	int		retv;
 	ULONG		RxBufferId;
 
-
 	//
 	// Issuing URB
 	//
-	do
-	{
-		if( pHwData->SurpriseRemove || pHwData->HwStop )
+	do {
+		if (pHwData->SurpriseRemove || pHwData->HwStop)
 			break;
 
-		if( pWb35Rx->rx_halt )
+		if (pWb35Rx->rx_halt)
 			break;
 
 		// Get RxBuffer's ID
 		RxBufferId = pWb35Rx->RxBufferId;
-		if( !pWb35Rx->RxOwner[ RxBufferId ] )
-		{
+		if (!pWb35Rx->RxOwner[RxBufferId]) {
 			// It's impossible to run here.
 			#ifdef _PE_RX_DUMP_
 			WBDEBUG(("Rx driver fifo unavailable\n"));
@@ -62,49 +57,36 @@ VOID Wb35Rx( IN phw_data_t pHwData )
 		pWb35Rx->RxBufferId++;
 		pWb35Rx->RxBufferId %= MAX_USB_RX_BUFFER_NUMBER;
 
-		pWb35Rx->CurrentRxBufferId = RxBufferId; // 20060331 for complete routine usage
+		pWb35Rx->CurrentRxBufferId = RxBufferId;
 
-		//pRxBufferAddress = pWb35Rx->RxBuffer[ RxBufferId ];
-		//142_o add by anson
-		if (OS_MEMORY_ALLOC_OK != OS_MEMORY_ALLOC((PVOID *)&pWb35Rx->pDRx, MAX_USB_RX_BUFFER))
-		{
-			#ifdef _PE_STATE_DUMP_
-			WBDEBUG(("Rx memory alloc failed\n"));
-			#endif
+		if (OS_MEMORY_ALLOC_OK != OS_MEMORY_ALLOC((PVOID *)&pWb35Rx->pDRx, MAX_USB_RX_BUFFER)) {
+			printk("w35und: Rx memory alloc failed\n");
 			break;
 		}
 		pRxBufferAddress = pWb35Rx->pDRx;
-		
 
-		usb_fill_bulk_urb( pUrb,
-					pHwData->WbUsb.udev,
-					usb_rcvbulkpipe(pHwData->WbUsb.udev, 3),
-					pRxBufferAddress,
-					MAX_USB_RX_BUFFER,
-					Wb35Rx_Complete,
-					pHwData);
+		usb_fill_bulk_urb(pUrb, pHwData->WbUsb.udev,
+				  usb_rcvbulkpipe(pHwData->WbUsb.udev, 3),
+				  pRxBufferAddress, MAX_USB_RX_BUFFER,
+				  Wb35Rx_Complete, pHwData);
 
 		pWb35Rx->EP3vm_state = VM_RUNNING;
 
-		retv = wb_usb_submit_urb( pUrb );
+		retv = wb_usb_submit_urb(pUrb);
 
-		if( retv != 0 )
-		{
-			#ifdef _PE_RX_DUMP_
-			WBDEBUG(("Rx URB sending error\n"));
-			#endif
+		if (retv != 0) {
+			printk("Rx URB sending error\n");
 			break;
 		}
-
 		return;
-
-	}while(FALSE);
+	} while(FALSE);
 
 	// VM stop
 	pWb35Rx->EP3vm_state = VM_STOP;
 	OS_ATOMIC_DEC( pHwData->Adapter, &pWb35Rx->RxFireCounter );
 }
-VOID Wb35Rx_Complete( IN PURB pUrb )
+
+VOID Wb35Rx_Complete(PURB pUrb)
 {
 	phw_data_t	pHwData = pUrb->context;
 	PWB35RX		pWb35Rx = &pHwData->Wb35Rx;
@@ -112,54 +94,50 @@ VOID Wb35Rx_Complete( IN PURB pUrb )
 	ULONG		SizeCheck;
 	USHORT		BulkLength;
 	ULONG		RxBufferId;
-	R00_DESCRIPTOR 	R00; //20060926 add by anson's endian
+	R00_DESCRIPTOR 	R00;
 
 	// Variable setting
 	pWb35Rx->EP3vm_state = VM_COMPLETED;
 	pWb35Rx->EP3VM_status = pUrb->status;//Store the last result of Irp
 
-	do
-	{
+	do {
 		RxBufferId = pWb35Rx->CurrentRxBufferId;
-		//142_o add by anson
-		//pRxBufferAddress = pWb35Rx->RxBuffer[ RxBufferId ];
+
 		pRxBufferAddress = pWb35Rx->pDRx;
 		BulkLength = (USHORT)pUrb->actual_length;
 
 		//The IRP is completed
 		pWb35Rx->EP3vm_state = VM_COMPLETED;
 
-		if( pHwData->SurpriseRemove || pHwData->HwStop ) // Must be here, or RxBufferId is invalid
+		if (pHwData->SurpriseRemove || pHwData->HwStop) // Must be here, or RxBufferId is invalid
 			break;
 
 		if( pWb35Rx->rx_halt )
 			break;
 
-		//Start to process the data only in successful condition
+		// Start to process the data only in successful condition
 		pWb35Rx->RxOwner[ RxBufferId ] = 0; // Set the owner to driver
-		//pR00 = (PR00_DESCRIPTOR)pRxBufferAddress;  
-		R00.value = le32_to_cpu(*(PULONG)pRxBufferAddress);  //20060926 anson's endian
+		R00.value = le32_to_cpu(*(PULONG)pRxBufferAddress);
+
 		//The URB is completed, check the result
-		if( pWb35Rx->EP3VM_status != 0 )
-		{
+		if (pWb35Rx->EP3VM_status != 0) {
 			#ifdef _PE_USB_STATE_DUMP_
 			WBDEBUG(("EP3 IoCompleteRoutine return error\n"));
 			DebugUsbdStatusInformation( pWb35Rx->EP3VM_status );
 			#endif
 			pWb35Rx->EP3vm_state = VM_STOP;
-			break; // Exit while(FALSE);
+			break;
 		}
 
 		// 20060220 For recovering. check if operating in single USB mode
-		if( !HAL_USB_MODE_BURST( pHwData ) )
-		{
+		if (!HAL_USB_MODE_BURST(pHwData)) {
 			SizeCheck = R00.R00_receive_byte_count;  //20060926 anson's endian
-			if( (SizeCheck & 0x03) > 0 )
+			if ((SizeCheck & 0x03) > 0)
 				SizeCheck -= 4;
 			SizeCheck = (SizeCheck + 3) & ~0x03;
 			SizeCheck += 12; // 8 + 4 badbeef
 			if( (BulkLength > 1600) || 
-				(SizeCheck > 1600) || //1548) )// 1536 + 8 + 4
+				(SizeCheck > 1600) ||
 				(BulkLength != SizeCheck) || 
 				(BulkLength == 0) ) // Add for fail Urb
 			{
@@ -172,25 +150,23 @@ VOID Wb35Rx_Complete( IN PURB pUrb )
 		pWb35Rx->ByteReceived += BulkLength;
 		pWb35Rx->RxBufferSize[ RxBufferId ] = BulkLength;
 
-
-		if( !pWb35Rx->RxOwner[ RxBufferId ])
+		if (!pWb35Rx->RxOwner[ RxBufferId ])
 			Wb35Rx_indicate( pHwData );
 		
 		OS_MEMORY_FREE( pWb35Rx->pDRx, MAX_USB_RX_BUFFER);
 		// Do the next receive
-		Wb35Rx( pHwData );
-
+		Wb35Rx(pHwData);
 		return;
 
-	}while(FALSE);
+	} while(FALSE);
 
 	pWb35Rx->RxOwner[ RxBufferId ] = 1; // Set the owner to hardware
 	OS_ATOMIC_DEC( pHwData->Adapter, &pWb35Rx->RxFireCounter );
 	pWb35Rx->EP3vm_state = VM_STOP;
 }
 
-//============================================================================================
-BOOLEAN Wb35Rx_initial( IN phw_data_t pHwData )
+//=====================================================================================
+BOOLEAN Wb35Rx_initial(phw_data_t pHwData)
 {
 	PWB35RX pWb35Rx = &pHwData->Wb35Rx;
 
@@ -198,19 +174,15 @@ BOOLEAN Wb35Rx_initial( IN phw_data_t pH
 	Wb35Rx_reset_descriptor( pHwData );
 
 	pWb35Rx->RxUrb = wb_usb_alloc_urb(0);
-	if( !pWb35Rx->RxUrb )
-		return FALSE;
-
-	return TRUE;
+	return (!!pWb35Rx->RxUrb);
 }
 
-VOID Wb35Rx_stop( IN phw_data_t pHwData )
+VOID Wb35Rx_stop(phw_data_t pHwData)
 {
-	PWB35RX		pWb35Rx = &pHwData->Wb35Rx;
+	PWB35RX pWb35Rx = &pHwData->Wb35Rx;
 
 	// Canceling the Irp if already sends it out.
-	if( pWb35Rx->EP3vm_state == VM_RUNNING )
-	{
+	if (pWb35Rx->EP3vm_state == VM_RUNNING) {
 		usb_unlink_urb( pWb35Rx->RxUrb ); // Only use unlink, let Wb35Rx_destrot to free them
 		#ifdef _PE_RX_DUMP_
 		WBDEBUG(("EP3 Rx stop\n"));
@@ -219,13 +191,13 @@ VOID Wb35Rx_stop( IN phw_data_t pHwData 
 }
 
 // Only can be run in passive-level
-VOID Wb35Rx_destroy( IN phw_data_t pHwData )
+VOID Wb35Rx_destroy(phw_data_t pHwData)
 {
 	PWB35RX pWb35Rx = &pHwData->Wb35Rx;
 
-	do{
+	do {
 		OS_SLEEP(10000); // Delay for waiting function enter 940623.1.a
-	}while( pWb35Rx->EP3vm_state != VM_STOP );
+	} while (pWb35Rx->EP3vm_state != VM_STOP);
 	OS_SLEEP(10000); // Delay for waiting function exit 940623.1.b
 
 	if( pWb35Rx->RxUrb )
@@ -251,36 +223,35 @@ VOID Wb35Rx_reset_descriptor( IN phw_dat
 		pWb35Rx->RxOwner[i] = 1;
 }
 
-VOID Wb35Rx_adjust( IN PDESCRIPTOR pRxDes )
+VOID Wb35Rx_adjust(PDESCRIPTOR pRxDes)
 {
 	PULONG	pRxBufferAddress;
 	ULONG	DecryptionMethod;
 	ULONG	i;
 	USHORT	BufferSize;
 
-
 	DecryptionMethod = pRxDes->R01.R01_decryption_method;
 	pRxBufferAddress = pRxDes->buffer_address[0];
 	BufferSize = pRxDes->buffer_size[0];
 
 	// Adjust the last part of data. Only data left
 	BufferSize -= 4; // For CRC-32
-	if( DecryptionMethod )
+	if (DecryptionMethod)
 		BufferSize -= 4;
-	if( DecryptionMethod == 3 ) // For CCMP
+	if (DecryptionMethod == 3) // For CCMP
 		BufferSize -= 4;
 
 	// Adjust the IV field which after 802.11 header and ICV field.
-	if( DecryptionMethod == 1 ) // For WEP
+	if (DecryptionMethod == 1) // For WEP
 	{
 		for( i=6; i>0; i-- )
 			pRxBufferAddress[i] = pRxBufferAddress[i-1];
-		pRxDes->buffer_address[0] = pRxBufferAddress + 1;//Update the descriptor, shift 4 byte
+		pRxDes->buffer_address[0] = pRxBufferAddress + 1;
 		BufferSize -= 4; // 4 byte for IV
 	}
 	else if( DecryptionMethod ) // For TKIP and CCMP
 	{
-		for( i=7; i>1; i-- )
+		for (i=7; i>1; i--)
 			pRxBufferAddress[i] = pRxBufferAddress[i-2];
 		pRxDes->buffer_address[0] = pRxBufferAddress + 2;//Update the descriptor, shift 8 byte
 		BufferSize -= 8; // 8 byte for IV + ICV
@@ -289,10 +260,9 @@ VOID Wb35Rx_adjust( IN PDESCRIPTOR pRxDe
 }
 
 //931130.4.b
-USHORT Wb35Rx_indicate( IN phw_data_t pHwData )
+USHORT Wb35Rx_indicate(phw_data_t pHwData)
 {
 	DESCRIPTOR	RxDes;
-//	PWB35REG pWb35Reg = &pHwData->Wb35Reg;
 	PWB35RX	pWb35Rx = &pHwData->Wb35Rx;
 	PUCHAR		pRxBufferAddress;
 	USHORT		PacketSize;
@@ -300,15 +270,14 @@ USHORT Wb35Rx_indicate( IN phw_data_t pH
 	ULONG		RxBufferId;
 
 	// Only one thread be allowed to run into the follow
-	do
-	{
+	do {
 		RxBufferId = pWb35Rx->RxProcessIndex;
 		if( pWb35Rx->RxOwner[ RxBufferId ] )//Owner by VM
 			break;
 
 		pWb35Rx->RxProcessIndex++;
 		pWb35Rx->RxProcessIndex %= MAX_USB_RX_BUFFER_NUMBER;
-		//142_o add by anson
+
 		//pRxBufferAddress = pWb35Rx->RxBuffer[ RxBufferId ];
 		pRxBufferAddress = pWb35Rx->pDRx;
 		BufferSize = pWb35Rx->RxBufferSize[ RxBufferId ];
@@ -316,20 +285,19 @@ USHORT Wb35Rx_indicate( IN phw_data_t pH
 		// Parse the bulkin buffer
 		while( BufferSize >= 4 )
 		{
-			if( ( cpu_to_le32(*(PULONG)pRxBufferAddress) & 0x0fffffff) == RX_END_TAG ) //Is ending? 921002.9.a
+			if ((cpu_to_le32(*(PULONG)pRxBufferAddress) & 0x0fffffff) == RX_END_TAG) //Is ending? 921002.9.a
 				break;
 
 			// Get the R00 R01 first
-			RxDes.R00.value =le32_to_cpu(*(PULONG)pRxBufferAddress); //20060926 add by anson's endian
+			RxDes.R00.value = le32_to_cpu(*(PULONG)pRxBufferAddress); //20060926 add by anson's endian
 			PacketSize = (USHORT)RxDes.R00.R00_receive_byte_count;
 			RxDes.R01.value = le32_to_cpu(*((PULONG)(pRxBufferAddress+4))); //20060926 anson's ednian
 			// For new DMA 4k
-			if( (PacketSize & 0x03) > 0 )
+			if ((PacketSize & 0x03) > 0)
 				PacketSize -= 4;
 
-			//Basic check for Rx length. Is length valid?
-			if( PacketSize > MAX_PACKET_SIZE )
-			{
+			// Basic check for Rx length. Is length valid?
+			if (PacketSize > MAX_PACKET_SIZE) {
 				#ifdef _PE_RX_DUMP_
 				WBDEBUG(("Serious ERROR : Rx data size too long, size =%d\n", PacketSize));
 				#endif
@@ -365,8 +333,7 @@ USHORT Wb35Rx_indicate( IN phw_data_t pH
 
 		// Reclaim resource
 		pWb35Rx->RxOwner[ RxBufferId ] = 1;
-
-	}while(TRUE);
+	} while(TRUE);
 
 	return stmp2;
 }
diff --git a/drivers/net/wireless/winbond/winbondport/linux/wb35tx.c b/drivers/net/wireless/winbond/winbondport/linux/wb35tx.c
index 0dc00b8..6253f01 100644
--- a/drivers/net/wireless/winbond/winbondport/linux/wb35tx.c
+++ b/drivers/net/wireless/winbond/winbondport/linux/wb35tx.c
@@ -12,30 +12,28 @@ #include "sysdef.h"
 
 
 BOOLEAN
-Wb35Tx_get_tx_buffer( IN phw_data_t pHwData, IN PUCHAR *pBuffer )
+Wb35Tx_get_tx_buffer(phw_data_t pHwData, PUCHAR *pBuffer )
 {
-	PWB35TX		pWb35Tx = &pHwData->Wb35Tx;
+	PWB35TX pWb35Tx = &pHwData->Wb35Tx;
 
 	*pBuffer = pWb35Tx->TxBuffer[0];
 	return TRUE;
 }
 
-VOID Wb35Tx_start( IN phw_data_t pHwData )
+VOID Wb35Tx_start(phw_data_t pHwData)
 {
-	PWB35TX		pWb35Tx = &pHwData->Wb35Tx;
+	PWB35TX pWb35Tx = &pHwData->Wb35Tx;
 
 	// Allow only one thread to run into function
-	if( OS_ATOMIC_INC( pHwData->Adapter, &pWb35Tx->TxFireCounter ) == 1 )
-	{
+	if( OS_ATOMIC_INC( pHwData->Adapter, &pWb35Tx->TxFireCounter ) == 1 ) {
 		pWb35Tx->EP4vm_state = VM_RUNNING;
 		Wb35Tx( pHwData );
-	}
-	else
+	} else
 		OS_ATOMIC_DEC( pHwData->Adapter, &pWb35Tx->TxFireCounter );
 }
 
 
-VOID Wb35Tx( IN phw_data_t pHwData )
+VOID Wb35Tx(phw_data_t pHwData)
 {
 	PWB35TX		pWb35Tx = &pHwData->Wb35Tx;
 	PADAPTER	Adapter = pHwData->Adapter;
@@ -46,38 +44,30 @@ VOID Wb35Tx( IN phw_data_t pHwData )
 	ULONG		SendIndex;
 
 
-	do
-	{
-		if( pHwData->SurpriseRemove || pHwData->HwStop )
+	do {
+		if (pHwData->SurpriseRemove || pHwData->HwStop)
 			break;
 
-		if( pWb35Tx->tx_halt )
+		if (pWb35Tx->tx_halt)
 			break;
 
-		//Ownership checking
+		// Ownership checking
 		SendIndex = pWb35Tx->TxSendIndex;
-		if( !pMds->TxOwner[ SendIndex ] )//No more data need to be sent, return immediately
+		if (!pMds->TxOwner[SendIndex]) //No more data need to be sent, return immediately
 			break;
 
 		pTxBufferAddress = pWb35Tx->TxBuffer[SendIndex];
-		#ifdef CONFIG_BOARD_W90N740 //Added by WangJS 2006.9.7
-		pTxBufferAddress = (PUCHAR)((ULONG)pTxBufferAddress | 0x80000000);
-		#endif
 		//
 		// Issuing URB
 		//
-		usb_fill_bulk_urb( pUrb,
-						   pHwData->WbUsb.udev,
-						   usb_sndbulkpipe(pHwData->WbUsb.udev, 4),
-						   pTxBufferAddress,
-						   pMds->TxBufferSize[ SendIndex ],
-						   Wb35Tx_complete,
-						   pHwData);
+		usb_fill_bulk_urb(pUrb, pHwData->WbUsb.udev,
+				  usb_sndbulkpipe(pHwData->WbUsb.udev, 4),
+				  pTxBufferAddress, pMds->TxBufferSize[ SendIndex ],
+				  Wb35Tx_complete, pHwData);
 
 		pWb35Tx->EP4vm_state = VM_RUNNING;
 		retv = wb_usb_submit_urb( pUrb );
-		if( retv<0 )
-		{
+		if (retv<0) {
 			#ifdef _PE_TX_DUMP_
 			WBDEBUG(("EP4 Tx Irp sending error\n"));
 			#endif
@@ -86,15 +76,12 @@ VOID Wb35Tx( IN phw_data_t pHwData )
 
 		// Check if driver needs issue Irp for EP2
 		pWb35Tx->TxFillCount += pMds->TxCountInBuffer[SendIndex];
-		#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
 		if( pWb35Tx->TxFillCount > 12 ) // Fixed to 12. 20060928
 			Wb35Tx_EP2VM_start( pHwData );
-		#endif
 
 		pWb35Tx->ByteTransfer += pMds->TxBufferSize[SendIndex];
 		return;
-
-	}while(FALSE);
+	} while(FALSE);
 
 	pWb35Tx->EP4vm_state = VM_STOP;
 	OS_ATOMIC_DEC( pHwData->Adapter, &pWb35Tx->TxFireCounter );
@@ -106,7 +93,6 @@ VOID Wb35Tx_complete( IN PURB pUrb )
 	phw_data_t	pHwData = pUrb->context;
 	PADAPTER	Adapter = (PADAPTER)pHwData->Adapter;
 	PWB35TX		pWb35Tx = &pHwData->Wb35Tx;
-//	PWBLINUX	pWbLinux = &Adapter->WbLinux;
 	PMDS		pMds = &Adapter->Mds;
 
 	// Variable setting
@@ -118,13 +104,13 @@ VOID Wb35Tx_complete( IN PURB pUrb )
 	
 	do
 	{
-		if( pHwData->SurpriseRemove || pHwData->HwStop ) // Let WbWlanHalt to handle surprise remove
+		if (pHwData->SurpriseRemove || pHwData->HwStop) // Let WbWlanHalt to handle surprise remove
 			break;
 
-		if( pWb35Tx->tx_halt )
+		if (pWb35Tx->tx_halt)
 			break;
 
-		//The URB is completed, check the result
+		// The URB is completed, check the result
 		if( pWb35Tx->EP4VM_status != 0 )
 		{
 			#ifdef _PE_USB_STATE_DUMP_
@@ -138,10 +124,8 @@ VOID Wb35Tx_complete( IN PURB pUrb )
 		// Do the next send
 		Mds_Tx( Adapter );
 		Wb35Tx( pHwData );
-	
 		return;
-
-	}while(FALSE);
+	} while(FALSE);
 
 	OS_ATOMIC_DEC( pHwData->Adapter, &pWb35Tx->TxFireCounter );
 	pWb35Tx->EP4vm_state = VM_STOP;
@@ -155,16 +139,16 @@ VOID Wb35Tx_reset_descriptor( IN phw_dat
 	pWb35Tx->tx_halt = 0;
 }
 
-BOOLEAN Wb35Tx_initial(	IN phw_data_t pHwData )
+BOOLEAN Wb35Tx_initial(phw_data_t pHwData)
 {
 	PWB35TX pWb35Tx = &pHwData->Wb35Tx;
 
 	pWb35Tx->Tx4Urb = wb_usb_alloc_urb(0);
-	if( !pWb35Tx->Tx4Urb )
+	if (!pWb35Tx->Tx4Urb)
 		return FALSE;
 
 	pWb35Tx->Tx2Urb = wb_usb_alloc_urb(0);
-	if( !pWb35Tx->Tx2Urb )
+	if (!pWb35Tx->Tx2Urb)
 	{
 		usb_free_urb( pWb35Tx->Tx4Urb );
 		return FALSE;
@@ -179,16 +163,14 @@ VOID Wb35Tx_stop( IN phw_data_t pHwData 
 	PWB35TX pWb35Tx = &pHwData->Wb35Tx;
 
 	// Trying to canceling the Trp of EP2
-	#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
-	if( pWb35Tx->EP2vm_state == VM_RUNNING )
-	#endif
-        usb_unlink_urb( pWb35Tx->Tx2Urb ); // Only use unlink, let Wb35Tx_destrot to free them
+	if (pWb35Tx->EP2vm_state == VM_RUNNING)
+		usb_unlink_urb( pWb35Tx->Tx2Urb ); // Only use unlink, let Wb35Tx_destrot to free them
 	#ifdef _PE_TX_DUMP_
 	WBDEBUG(("EP2 Tx stop\n"));
 	#endif
 
 	// Trying to canceling the Irp of EP4
-	if( pWb35Tx->EP4vm_state == VM_RUNNING )
+	if (pWb35Tx->EP4vm_state == VM_RUNNING)
 		usb_unlink_urb( pWb35Tx->Tx4Urb ); // Only use unlink, let Wb35Tx_destrot to free them
 	#ifdef _PE_TX_DUMP_
 	WBDEBUG(("EP4 Tx stop\n"));
@@ -196,20 +178,20 @@ VOID Wb35Tx_stop( IN phw_data_t pHwData 
 }
 
 //======================================================
-VOID Wb35Tx_destroy( IN phw_data_t pHwData )
+VOID Wb35Tx_destroy(phw_data_t pHwData)
 {
 	PWB35TX pWb35Tx = &pHwData->Wb35Tx;
 
 	// Wait for VM stop
-	do{
+	do {
 		OS_SLEEP(10000);  // Delay for waiting function enter 940623.1.a
-	}while( (pWb35Tx->EP2vm_state != VM_STOP) && (pWb35Tx->EP4vm_state != VM_STOP) );
+	} while( (pWb35Tx->EP2vm_state != VM_STOP) && (pWb35Tx->EP4vm_state != VM_STOP) );
 	OS_SLEEP(10000);  // Delay for waiting function enter 940623.1.b
 
-	if( pWb35Tx->Tx4Urb )
+	if (pWb35Tx->Tx4Urb)
 		usb_free_urb( pWb35Tx->Tx4Urb );
 
-	if( pWb35Tx->Tx2Urb )
+	if (pWb35Tx->Tx2Urb)
 		usb_free_urb( pWb35Tx->Tx2Urb );
 
 	#ifdef _PE_TX_DUMP_
@@ -222,17 +204,14 @@ VOID Wb35Tx_CurrentTime( IN phw_data_t p
 	PWB35TX pWb35Tx = &pHwData->Wb35Tx;
 	BOOL Trigger = FALSE;
 
-	if( pWb35Tx->TxTimer > TimeCount )
+	if (pWb35Tx->TxTimer > TimeCount)
 		Trigger = TRUE;
-	else if( TimeCount > (pWb35Tx->TxTimer+500) )
+	else if (TimeCount > (pWb35Tx->TxTimer+500))
 		Trigger = TRUE;
 
-	if( Trigger )
-	{
+	if (Trigger) {
 		pWb35Tx->TxTimer = TimeCount;
-		#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
 		Wb35Tx_EP2VM_start( pHwData );
-		#endif
 	}
 }
 
@@ -251,15 +230,14 @@ VOID Wb35Tx_EP2VM_start( IN phw_data_t p
 }
 
 
-VOID Wb35Tx_EP2VM( IN phw_data_t pHwData )
+VOID Wb35Tx_EP2VM(phw_data_t pHwData)
 {
     PWB35TX pWb35Tx = &pHwData->Wb35Tx;
     PURB	pUrb = (PURB)pWb35Tx->Tx2Urb;
 	PULONG	pltmp = (PULONG)pWb35Tx->EP2_buf;
 	int		retv;
 
-	do
-	{
+	do {
 		if( pHwData->SurpriseRemove || pHwData->HwStop )
 			break;
 
@@ -290,7 +268,7 @@ VOID Wb35Tx_EP2VM( IN phw_data_t pHwData
 
 		return;
 
-	}while(FALSE);
+	} while(FALSE);
 
 	pWb35Tx->EP2vm_state = VM_STOP;
 	OS_ATOMIC_DEC( pHwData->Adapter, &pWb35Tx->TxResultCount );
@@ -322,7 +300,7 @@ VOID Wb35Tx_EP2VM_complete( IN PURB pUrb
 			break;
 
 		//The Urb is completed, check the result
-		if( pWb35Tx->EP2VM_status != 0 )
+		if (pWb35Tx->EP2VM_status != 0)
 		{
 			//#ifdef _PE_USB_STATE_DUMP_
 			WBDEBUG(("EP2 IoCompleteRoutine return error\n"));
@@ -360,26 +338,10 @@ VOID Wb35Tx_EP2VM_complete( IN PURB pUrb
 			T02.value = cpu_to_le32(pltmp[i]) >> 8;
 		}
 
-// 20060928
-//		// Start to get the next result, if previous Irp return OK
-//		pWb35Tx->EP2vm_state = VM_RUNNING;
-//
-//		#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
-//		Wb35Tx_EP2VM( pHwData );
-//		#endif
-
 		return;
-
-	}while(FALSE);
+	} while(FALSE);
 
 	OS_ATOMIC_DEC( pHwData->Adapter, &pWb35Tx->TxResultCount );
 	pWb35Tx->EP2vm_state = VM_STOP;
 }
 
-
-
-//===================================================================================================
-//===================================================================================================
-
-
-
diff --git a/drivers/net/wireless/winbond/winbondport/linux/wbusb.c b/drivers/net/wireless/winbond/winbondport/linux/wbusb.c
index 2f2347c..7c23a77 100644
--- a/drivers/net/wireless/winbond/winbondport/linux/wbusb.c
+++ b/drivers/net/wireless/winbond/winbondport/linux/wbusb.c
@@ -107,12 +107,11 @@ int wb35_probe( struct usb_interface *in
 					   4, HZ*100 );
 		if( ret < 0 )
 			break;
-		ltmp = cpu_to_le32(ltmp);
 
-		if( ltmp ) // Is already initialized?
+		ltmp = cpu_to_le32(ltmp);
+		if (ltmp)  // Is already initialized?
 			break;
 
-
 		netdev = alloc_etherdev( sizeof(ADAPTER) );
 
 		if (!netdev) {
@@ -175,11 +174,8 @@ int wb35_probe( struct usb_interface *in
 		dev_alloc_name(netdev, "wlan%d");
 
 		SET_NETDEV_DEV( netdev, &intf->dev );
-		if( register_netdev( netdev ) !=0 )
-		{
-			#ifdef _PE_USB_INI_DUMP_
-			WBDEBUG(("couldn't register the device of net !\n"));
-			#endif
+		if (register_netdev(netdev)) {
+			printk("w35und: couldn't register the netdev!\n");
 			break;
 		}
 		usb_set_intfdata( intf, Adapter );
@@ -190,7 +186,7 @@ int wb35_probe( struct usb_interface *in
 	} while(FALSE);
 
 	if (netdev)
-		free_netdev( netdev );
+		free_netdev(netdev);
 	return -ENOMEM;
 }
 
@@ -210,30 +206,9 @@ int wb35_open( struct net_device *netdev
 {
 	PADAPTER Adapter = (PADAPTER)netdev->priv;
 	phw_data_t pHwData = &Adapter->sHwData;
-        #ifdef _PE_USB_INI_DUMP_
-        u8 mac_addr[8];   
-	int ep_cnt=0;
-        #endif
 
-//	This needs to be in wb35_probe, moved - Scythe
-//	hal_get_permanent_address( pHwData, netdev->dev_addr );
         netif_start_queue(netdev);
 
-	#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-	MOD_INC_USE_COUNT;
-	#endif
-
-	#ifdef _PE_USB_INI_DUMP_
-
-	WBDEBUG(("[w35und] MAC ADDR: "));
-	for( ep_cnt = 0; ep_cnt < 6; ep_cnt++ )
-	{
-		WBDEBUG(("%x ", mac_addr[ep_cnt]));
-	}
-	WBDEBUG(("\n"));
-	WBDEBUG(("[w35und] Wb35_open<-\n"));
-        #endif
-
 	//TODO : put here temporarily
 	hal_set_accept_broadcast( pHwData, 1); // open accept broadcast
 
@@ -242,55 +217,23 @@ int wb35_open( struct net_device *netdev
 
 int wb35_close( struct net_device *netdev )
 {
-	netif_stop_queue( netdev );
-
-	#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-	MOD_DEC_USE_COUNT;
-	#endif
-
-    #ifdef _PE_USB_INI_DUMP_
-	WBDEBUG(("[w35und] Wb35_close\n"));
-    #endif
-
+	netif_stop_queue(netdev);
 	return 0;
 }
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-void wb35_disconnect( struct usb_device *udev, void *ptr )
-#else
 void wb35_disconnect( struct usb_interface *intf )
-#endif
 {
-    PWBLINUX pWbLinux;
-	#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-	PADAPTER Adapter = (PADAPTER)ptr;
-	#else
+	PWBLINUX pWbLinux;
 	PADAPTER Adapter = usb_get_intfdata( intf );
 	usb_set_intfdata( intf, NULL );
-	#endif
 
         pWbLinux = &Adapter->WbLinux;
 
-    #ifdef _PE_USB_INI_DUMP_
-	WBDEBUG(("[w35und] wb35_disconnect -->\n"));
-    #endif
-
 	// Card remove
 	WbWlanHalt( Adapter );
 
-	#if LINUX_VERSION_CODE <KERNEL_VERSION(2,5,0)
-	if( pWbLinux->netdev )
-		kfree( pWbLinux->netdev );
-	if( Adapter )
-		kfree( Adapter );
-	#else
 	if( pWbLinux->netdev )
 		free_netdev( pWbLinux->netdev );
-	#endif
-
-	#ifdef _PE_USB_INI_DUMP_
-	WBDEBUG(("[w35und] wb35_disconnect <---\n"));
-    #endif
 }
 
 
diff --git a/drivers/net/wireless/winbond/winbondport/linux/wbusb_f.h b/drivers/net/wireless/winbond/winbondport/linux/wbusb_f.h
index 58848bb..5d04861 100644
--- a/drivers/net/wireless/winbond/winbondport/linux/wbusb_f.h
+++ b/drivers/net/wireless/winbond/winbondport/linux/wbusb_f.h
@@ -11,34 +11,20 @@
 //	  
 //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 
-int wb35_open( struct net_device *netdev );
-int wb35_close( struct net_device *netdev );
-BOOL WbUsb_initial( IN phw_data_t pHwData );
-VOID WbUsb_destroy( IN phw_data_t pHwData );
-BOOL WbWLanInitialize( IN PADAPTER Adapter );
+int wb35_open(struct net_device *netdev);
+int wb35_close(struct net_device *netdev);
+BOOL WbUsb_initial(phw_data_t pHwData);
+VOID WbUsb_destroy(phw_data_t pHwData);
+BOOL WbWLanInitialize(PADAPTER Adapter);
 #define	WbUsb_Stop( _A )
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-	void *wb35_probe( struct usb_device *udev, unsigned int ifnum, const struct usb_device_id *id_table );
-	void wb35_disconnect(struct usb_device *udev, void *ptr);
-#else
-	int wb35_probe( struct usb_interface *intf,const struct usb_device_id *id_table );
-	void wb35_disconnect(struct usb_interface *intf);
-#endif
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-	#define wb_usb_submit_urb(_A) usb_submit_urb(_A)
-#else
-	#define wb_usb_submit_urb(_A) usb_submit_urb(_A,GFP_ATOMIC)
-#endif
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-	#define wb_usb_alloc_urb(_A) usb_alloc_urb(_A)
-#else
-	#define wb_usb_alloc_urb(_A) usb_alloc_urb(_A,GFP_ATOMIC)
-#endif
+int wb35_probe(struct usb_interface *intf,const struct usb_device_id *id_table);
+void wb35_disconnect(struct usb_interface *intf);
 
 
+#define wb_usb_submit_urb(_A) usb_submit_urb(_A, GFP_ATOMIC)
+#define wb_usb_alloc_urb(_A) usb_alloc_urb(_A, GFP_ATOMIC)
+
 #define WbUsb_CheckForHang( _P )
 #define WbUsb_DetectStart( _P, _I )
 
diff --git a/drivers/net/wireless/winbond/winbondport/mds.c b/drivers/net/wireless/winbond/winbondport/mds.c
index 5556e6a..7d40c0e 100644
--- a/drivers/net/wireless/winbond/winbondport/mds.c
+++ b/drivers/net/wireless/winbond/winbondport/mds.c
@@ -34,7 +34,7 @@ Mds_Destroy( IN PADAPTER Adapter )
 }
 
 VOID
-Mds_Tx( IN PADAPTER Adapter )
+Mds_Tx(PADAPTER Adapter)
 {
 	phw_data_t	pHwData = &Adapter->sHwData;
 	PMDS		pMds = &Adapter->Mds;
@@ -47,10 +47,10 @@ Mds_Tx( IN PADAPTER Adapter )
 
 
 	//931130.5.a
-	if( pMds->TxPause )
+	if (pMds->TxPause)
 		return;
 	// 20060717.3 Add
-	if( !hal_driver_init_OK( pHwData ) )
+	if (!hal_driver_init_OK(pHwData))
 		return;
 
 	//Only one thread can be run here
diff --git a/drivers/net/wireless/winbond/winbondport/mlmetxrx.c b/drivers/net/wireless/winbond/winbondport/mlmetxrx.c
index 5109c57..2701019 100644
--- a/drivers/net/wireless/winbond/winbondport/mlmetxrx.c
+++ b/drivers/net/wireless/winbond/winbondport/mlmetxrx.c
@@ -17,23 +17,23 @@
 //============================================================================
 #include "os_common.h"
 
-void MLMEResetTxRx(IN PWB32_ADAPTER Adapter)
+void MLMEResetTxRx(PWB32_ADAPTER Adapter)
 {
-    INT     i;
+	INT     i;
 
-    // Reset the interface between MDS and MLME
-    for (i = 0; i < MAX_NUM_TX_MMPDU; i++)
-        Adapter->sMlmeFrame.TxMMPDUInUse[i] = FALSE;
-    for (i = 0; i < MAX_NUM_RX_MMPDU; i++)
-        Adapter->sMlmeFrame.SaveRxBufSlotInUse[i] = FALSE;
+	// Reset the interface between MDS and MLME
+	for (i = 0; i < MAX_NUM_TX_MMPDU; i++)
+		Adapter->sMlmeFrame.TxMMPDUInUse[i] = FALSE;
+	for (i = 0; i < MAX_NUM_RX_MMPDU; i++)
+		Adapter->sMlmeFrame.SaveRxBufSlotInUse[i] = FALSE;
         
-    Adapter->sMlmeFrame.wNumRxMMPDUInMLME   = 0;
-    Adapter->sMlmeFrame.wNumRxMMPDUDiscarded = 0;
-    Adapter->sMlmeFrame.wNumRxMMPDU          = 0;
-    Adapter->sMlmeFrame.wNumTxMMPDUDiscarded = 0;
-    Adapter->sMlmeFrame.wNumTxMMPDU          = 0;
-    Adapter->sLocalPara.boCCAbusy    = FALSE;
-    Adapter->sLocalPara.iPowerSaveMode     = PWR_ACTIVE;     // Power active
+	Adapter->sMlmeFrame.wNumRxMMPDUInMLME   = 0;
+	Adapter->sMlmeFrame.wNumRxMMPDUDiscarded = 0;
+	Adapter->sMlmeFrame.wNumRxMMPDU          = 0;
+	Adapter->sMlmeFrame.wNumTxMMPDUDiscarded = 0;
+	Adapter->sMlmeFrame.wNumTxMMPDU          = 0;
+	Adapter->sLocalPara.boCCAbusy    = FALSE;
+	Adapter->sLocalPara.iPowerSaveMode     = PWR_ACTIVE;     // Power active
 }
 
 //=============================================================================
@@ -53,32 +53,30 @@ void MLMEResetTxRx(IN PWB32_ADAPTER Adap
 //=============================================================================
 UCHAR *MLMEGetMMPDUBuffer(IN PWB32_ADAPTER Adapter)
 {
-    INT i;
-    UCHAR *returnVal;
+	INT i;
+	UCHAR *returnVal;
     
-    for (i = 0; i< MAX_NUM_TX_MMPDU; i++)
-    {
-        if (Adapter->sMlmeFrame.TxMMPDUInUse[i] == FALSE)
-            break;
-    }
-    if (i >= MAX_NUM_TX_MMPDU) return NULL;
+	for (i = 0; i< MAX_NUM_TX_MMPDU; i++) {
+		if (Adapter->sMlmeFrame.TxMMPDUInUse[i] == FALSE)
+			break;
+	}
+	if (i >= MAX_NUM_TX_MMPDU) return NULL;
 
-    returnVal = (UCHAR *)&(Adapter->sMlmeFrame.TxMMPDU[i]);
+	returnVal = (UCHAR *)&(Adapter->sMlmeFrame.TxMMPDU[i]);
 	Adapter->sMlmeFrame.TxMMPDUInUse[i] = TRUE;
 
-    return returnVal;
+	return returnVal;
 }
 
 //=============================================================================
 UCHAR MLMESendFrame( PWB32_ADAPTER Adapter,
 				   UCHAR *pMMPDU,
 				   USHORT len,
-				   IN UCHAR DataType)
+				   UCHAR DataType)
 /*	DataType : FRAME_TYPE_802_11_MANAGEMENT, FRAME_TYPE_802_11_MANAGEMENT_CHALLENGE,
 				FRAME_TYPE_802_11_DATA */
 {
-	if( Adapter->sMlmeFrame.IsInUsed != PACKET_FREE_TO_USE )
-	{
+	if( Adapter->sMlmeFrame.IsInUsed != PACKET_FREE_TO_USE ) {
 		Adapter->sMlmeFrame.wNumTxMMPDUDiscarded ++;
 		return FALSE;
 	}
@@ -92,32 +90,12 @@ UCHAR MLMESendFrame( PWB32_ADAPTER Adapt
 
 	// H/W will enter power save by set the register. S/W don't send null frame
 	//with PWRMgt bit enbled to enter power save now.
-	/*
-	//PowerSaveMode bit of FRAME_TYPE_802_11_DATA frames have been set before 
-	//this function, such as SendNullData()
-	if (DataType != FRAME_TYPE_802_11_DATA)
-	{
-		if (Adapter->sLocalPara.iPowerSaveMode == PWR_SAVE)
-		{
-    	    // Enable the PWRMgt bit in the Frame Control field
-        	pMMPDU[1] |= 0x10;
-		}
-    }
-	*/
 
 	// Transmit NDIS packet
 	Mds_Tx( Adapter );
-    #ifdef _PE_TX_DUMP_
-    WBDEBUG(("MLMESendFrame->mds_tx_ok\n"));
-    #endif
-	//Suppose Tx is always successful even it is not sent in Mds_Tx(). -- WKChen
-	//(1)If it is "probe request", we can't queue it in the Mds_Tx(). Because
-	//	 the channel may have been changed
-	//(2)If it is "authentication or association" frame, the connection will fail.
-	// The follow function will be called in GET_DESCRIPTOR_SECOND_COMPLETED
-	// It can make sure the buffer can be released safely.
-	// MLME_SendComplete( Adapter, 0, TRUE); 20051220 Move to GET_DESCRIPTOR_SECOND_COMPLETED
-
+#ifdef _PE_TX_DUMP_
+	WBDEBUG(("MLMESendFrame->mds_tx_ok\n"));
+#endif
 	return TRUE;
 }
 
diff --git a/drivers/net/wireless/winbond/winbondport/phy_calibration.c b/drivers/net/wireless/winbond/winbondport/phy_calibration.c
index d89047b..1e36218 100644
--- a/drivers/net/wireless/winbond/winbondport/phy_calibration.c
+++ b/drivers/net/wireless/winbond/winbondport/phy_calibration.c
@@ -19,15 +19,12 @@ #include "phy_calibration.h"
 /****************** LOCAL CONSTANT AND MACRO SECTION ************************/
 #define LOOP_TIMES      20
 #define US              1000//MICROSECOND
-//#define US              100//MICROSECOND
 
 #define AG_CONST        0.6072529350
 #define FIXED(X)        ((s32)((X) * 32768.0))
-#define FLOAT(X)        ((X) / 32768.0)
 #define DEG2RAD(X)      0.017453 * (X)
 
 /****************** LOCAL TYPE DEFINITION SECTION ***************************/
-//typedef long int        fixed; /* 16.16 fixed-point */
 typedef s32         fixed; /* 16.16 fixed-point */
 
 static const fixed Angles[]=
diff --git a/drivers/net/wireless/winbond/winbondport/smetask.c b/drivers/net/wireless/winbond/winbondport/smetask.c
index 8c250ba..97476d7 100644
--- a/drivers/net/wireless/winbond/winbondport/smetask.c
+++ b/drivers/net/wireless/winbond/winbondport/smetask.c
@@ -91,101 +91,101 @@ void vSmeProc_CountermeasureBlockCancel(
 //========== Define the state machine table of SME module =================
 static const K_TRANS asDisabled[] =
 {
-	{SMEMSG_SCAN_REQ,			vSmeProc_ScanReq					},
-	{SMEMSG_START_IBSS,			vSmeProc_StartIBSSReq				},
-	{SMEMSG_JOIN_REQ,			vSmeProc_JoinReq					},
-	{K_NULL_MSG,				vProc_Null						}
+	{ SMEMSG_SCAN_REQ,	vSmeProc_ScanReq	},
+	{ SMEMSG_START_IBSS,	vSmeProc_StartIBSSReq	},
+	{ SMEMSG_JOIN_REQ,	vSmeProc_JoinReq	},
+	{ K_NULL_MSG,		vProc_Null		}
 };
 
 static const K_TRANS asInit_Scan[] =
 {
-	{SMEMSG_START_IBSS,			vSmeProc_StartIBSSReq				},
-	{SMEMSG_JOIN_REQ,			vSmeProc_JoinReq					},
-	{SMEMSG_SCAN_CFM,			vSmeProc_ScanCfm					},
-	{K_NULL_MSG,				vProc_Null						}
+	{SMEMSG_START_IBSS,	vSmeProc_StartIBSSReq	},
+	{SMEMSG_JOIN_REQ,	vSmeProc_JoinReq	},
+	{SMEMSG_SCAN_CFM,	vSmeProc_ScanCfm	},
+	{K_NULL_MSG,		vProc_Null		}
 };
 
 static const K_TRANS asScan_Ready[] =
 {
-	{SMEMSG_JOIN_REQ,			vSmeProc_JoinActive				},
-	{SMEMSG_SCAN_REQ,			vSmeProc_ReScan					},
-	{SMEMSG_SCAN_JOIN_REQ,		vSmeProc_ScanThenJoin			},
-	{SMEMSG_START_IBSS,			vSmeProc_StartIBSSActive		},
-	{SMEMSG_HANDOVER_JOIN_REQ,	vSmeProc_HandoverJoin			},
-	{SMEMSG_END_ROAMING,		vSmeProc_EndRoaming				},
-	{SMEMSG_SCAN_CFM,			vSmeProc_ScanCfm					},
+	{SMEMSG_JOIN_REQ,		vSmeProc_JoinActive	},
+	{SMEMSG_SCAN_REQ,		vSmeProc_ReScan		},
+	{SMEMSG_SCAN_JOIN_REQ,		vSmeProc_ScanThenJoin	},
+	{SMEMSG_START_IBSS,		vSmeProc_StartIBSSActive},
+	{SMEMSG_HANDOVER_JOIN_REQ,	vSmeProc_HandoverJoin	},
+	{SMEMSG_END_ROAMING,		vSmeProc_EndRoaming	},
+	{SMEMSG_SCAN_CFM,		vSmeProc_ScanCfm	},
 	{SMEMSG_COUNTERMEASURE_BLOCK_TIMEOUT,	vSmeProc_CountermeasureBlockCancel	},
-	{SMEMSG_POWERSAVE_REQ,		vSmeProc_PowerSaveReq			},
-	{K_NULL_MSG,				vProc_Null						}
+	{SMEMSG_POWERSAVE_REQ,		vSmeProc_PowerSaveReq	},
+	{K_NULL_MSG,			vProc_Null		}
 };
 
 static const K_TRANS asStart_IBSS[] =
 {
-	{SMEMSG_START_IBSS_CFM,		vSmeProc_IbssStartCfm				},
-	//{SMEMSG_TIMEOUT,			vSmeProc_IbssScanTimer				}, // In IBSS state, STA continue passive scan waiting Beacon
-	//{SMEMSG_SCAN_REQ,			vSmeProc_IbssScanReq				}, // don't need extra timer to trigger scan action
+	{SMEMSG_START_IBSS_CFM,		vSmeProc_IbssStartCfm	},
+	//{SMEMSG_TIMEOUT,		vSmeProc_IbssScanTimer	}, // In IBSS state, STA continue passive scan waiting Beacon
+	//{SMEMSG_SCAN_REQ,		vSmeProc_IbssScanReq	}, // don't need extra timer to trigger scan action
 	//TODO: following msg is marked at 12/27/03', it will accept the same join 
 	//		request(same ssid) if XP launch same join request twice.
-	{SMEMSG_JOIN_REQ,			vSmeProc_ManualHandoverJoin		},
+	{SMEMSG_JOIN_REQ,		vSmeProc_ManualHandoverJoin		},
 	//{SMEMSG_IBSS_JOIN_UPDATE_BSSID, vSmeProc_IBSSJoinUpdateBSSID},
-	{SMEMSG_SCAN_REQ,			vSmeProc_BgScan					},
-	{K_NULL_MSG,				vProc_Null						}
+	{SMEMSG_SCAN_REQ,		vSmeProc_BgScan				},
+	{K_NULL_MSG,			vProc_Null				}
 };
 
 static const K_TRANS asJoin_Pending[] =
 {
-	{SMEMSG_TSF_SYNC_IND,		vSmeProc_JoinCfm					},
-	//{SMEMSG_START_IBSS_CFM,	vSmeProc_JoinCfm					},
-	{SMEMSG_JOIN_REQ,			vSmeProc_ManualHandoverJoin		},
-	{SMEMSG_TIMEOUT,			vSmeProc_JoinFail					},
-	{SMEMSG_END_ROAMING,		vSmeProc_EndRoaming				},
-	{K_NULL_MSG,				vProc_Null						}
+	{SMEMSG_TSF_SYNC_IND,		vSmeProc_JoinCfm	},
+	//{SMEMSG_START_IBSS_CFM,	vSmeProc_JoinCfm	},
+	{SMEMSG_JOIN_REQ,		vSmeProc_ManualHandoverJoin		},
+	{SMEMSG_TIMEOUT,		vSmeProc_JoinFail	},
+	{SMEMSG_END_ROAMING,		vSmeProc_EndRoaming	},
+	{K_NULL_MSG,			vProc_Null		}
 };
 
 static const K_TRANS asJoin_Cfm[]=
 {
-	{SMEMSG_AUTHEN_REQ,			vSmeProc_AuthenReq					},
-	//{SMEMSG_TIMEOUT,			vSmeProc_IbssWaitAuthTimeout		},
-	{K_NULL_MSG,				vProc_Null						}
+	{SMEMSG_AUTHEN_REQ,	vSmeProc_AuthenReq		},
+	//{SMEMSG_TIMEOUT,	vSmeProc_IbssWaitAuthTimeout	},
+	{K_NULL_MSG,		vProc_Null			}
 };
 
 static const K_TRANS asAuthenticate_Pending[] =
 {
-	{SMEMSG_AUTHEN_CFM,			vSmeProc_EssAuthenCfm			},
-	{SMEMSG_TIMEOUT,			vSmeProc_AuthRetryTimeOut		},
-	{K_NULL_MSG,				vProc_Null						}
+	{SMEMSG_AUTHEN_CFM,	vSmeProc_EssAuthenCfm		},
+	{SMEMSG_TIMEOUT,	vSmeProc_AuthRetryTimeOut	},
+	{K_NULL_MSG,		vProc_Null			}
 };
 
 static const K_TRANS asAuthenticated[] =
 {
-	{SMEMSG_ASSOC_CFM,			vSmeProc_AssocCfm				},
-	{SMEMSG_ASSOC_REQ,			vSmeProc_AssocReq				},
-	{SMEMSG_DEAUTHEN_IND,		vSmeProc_DeauthenInd			},
-	//{SMEMSG_DISASSOC_IND,		vSmeProc_DisassocInd			},
-	{SMEMSG_DISASSOC_IND,		vSmeProc_DeauthenInd			},
-	{K_NULL_MSG,				vProc_Null						}
+	{SMEMSG_ASSOC_CFM,	vSmeProc_AssocCfm		},
+	{SMEMSG_ASSOC_REQ,	vSmeProc_AssocReq		},
+	{SMEMSG_DEAUTHEN_IND,	vSmeProc_DeauthenInd		},
+	//{SMEMSG_DISASSOC_IND,	vSmeProc_DisassocInd		},
+	{SMEMSG_DISASSOC_IND,	vSmeProc_DeauthenInd		},
+	{K_NULL_MSG,		vProc_Null			}
 };
 
 static const K_TRANS asConnected[] =
 {
-	{SMEMSG_DISCONNECT_REQ,		vSmeProc_Disconnect				},
-	{SMEMSG_DEAUTHEN_REQ,		vSmeProc_Disconnect				},
-	{SMEMSG_DISASSOC_REQ,		vSmeProc_Disconnect				},
-	{SMEMSG_SCAN_REQ,			vSmeProc_BgScan					},
-	{SMEMSG_JOIN_REQ,			vSmeProc_ManualHandoverJoin		},
-	{SMEMSG_HANDOVER_JOIN_REQ,	vSmeProc_HandoverJoin			},
-	{SMEMSG_DEAUTHEN_IND,		vSmeProc_DeauthenInd			},
-	//{SMEMSG_DISASSOC_IND,		vSmeProc_DisassocInd			},
-	{SMEMSG_DISASSOC_IND,		vSmeProc_DeauthenInd			},
-	{SMEMSG_POWERSAVE_REQ,		vSmeProc_PowerSaveReq			},
-	{SMEMSG_AUTHEN_REQ,			vSmeProc_IbssAuth				},
-	{SMEMSG_END_ROAMING,		vSmeProc_Disconnect				},//Only for IBSS, because
-									//ESS may try to handover, its state will not be CONNECT
+	{SMEMSG_DISCONNECT_REQ,		vSmeProc_Disconnect	},
+	{SMEMSG_DEAUTHEN_REQ,		vSmeProc_Disconnect	},
+	{SMEMSG_DISASSOC_REQ,		vSmeProc_Disconnect	},
+	{SMEMSG_SCAN_REQ,		vSmeProc_BgScan		},
+	{SMEMSG_JOIN_REQ,		vSmeProc_ManualHandoverJoin		},
+	{SMEMSG_HANDOVER_JOIN_REQ,	vSmeProc_HandoverJoin	},
+	{SMEMSG_DEAUTHEN_IND,		vSmeProc_DeauthenInd	},
+	//{SMEMSG_DISASSOC_IND,		vSmeProc_DisassocInd	},
+	{SMEMSG_DISASSOC_IND,		vSmeProc_DeauthenInd	},
+	{SMEMSG_POWERSAVE_REQ,		vSmeProc_PowerSaveReq	},
+	{SMEMSG_AUTHEN_REQ,		vSmeProc_IbssAuth	},
+	{SMEMSG_END_ROAMING,		vSmeProc_Disconnect	},//Only for IBSS, because
+				//ESS may try to handover, its state will not be CONNECT
 	//{SMEMSG_IBSS_JOIN_UPDATE_BSSID, vSmeProc_IBSSJoinUpdateBSSID},
 	//for WPA countermeasure
 	{SMEMSG_COUNTERMEASURE_MICFAIL_TIMEOUT,	vSmeProc_CountermeaureCancel		},
 	{SMEMSG_COUNTERMEASURE_BLOCK_TIMEOUT,	vSmeProc_CountermeasureBlockCancel	},
-	{K_NULL_MSG,				vProc_Null						}
+	{K_NULL_MSG,			vProc_Null		}
 };
 
 
@@ -208,23 +208,17 @@ static const K_TRANS* psSMETransTable[] 
 //=========================================================================
 void SME_Init(PWB32_ADAPTER Adapter)
 {
-
 	#ifdef _PE_STATE_DUMP_
 	WBDEBUG(("STATE: MiniportInit\n"));
 	#endif
 
 	//------------- H/W ------------
-	//hal_set_accept_beacon(&Adapter->sHwData, FALSE);
 	hal_set_accept_beacon(&Adapter->sHwData, TRUE);
 	hal_stop_sync_bss(&Adapter->sHwData);
 
 	//------------- S/W ------------
 	SME_ResetPara(Adapter);
 	//Initilize SME timer
-	///NdisMInitializeTimer(&((psSME)->nTimer),
-	///					  Adapter->WbNdis.MiniportAdapterHandle,
-    ///                      (PVOID) vSmeTimerHandler,
-    ///                      (PVOID) Adapter);
 	OS_TIMER_INITIAL( &((psSME)->nTimer),
                           (PVOID) vSmeTimerHandler,
                           (PVOID) Adapter);
@@ -254,11 +248,9 @@ void SME_ResetPara(PWB32_ADAPTER Adapter
 
 	psSME->encrypt_status = ENCRYPT_DISABLE;
 	psSME->_dot11PrivacyInvoked=FALSE;
-	//psSME->_dot11ExcludeUnencrypted=TRUE;
 	psSME->_dot11PrivacyOptionImplemented=FALSE;
 	psSME->_dot11WEPDefaultKeyID = 0;
 	psSME->bDesiredAuthMode = OPEN_AUTH;
-	//psSME->bDesiredAuthMode = WPA_AUTH;
 
 	psLOCAL->wConnectedSTAindex = 0;
 	psLOCAL->boHandover = FALSE;  // Initial, not Handover
@@ -272,30 +264,23 @@ void SME_ResetPara(PWB32_ADAPTER Adapter
 	psLOCAL->boShortSlotTime = FALSE;
 	psLOCAL->CWMin = 255;	//set according to 802.11 spec.
 
-	//#ifdef _WPA_
 	psSME->wpa_ok = 0;
-	//#endif
 	//TODO : WPA2
 	#ifdef _WPA2_
-	psSME->PmkidTableIndex=0;//added by ws 05/05/04
+	psSME->PmkidTableIndex=0;
 	#endif //end def _WPA2_
 
-	if (psLOCAL->bMacOperationMode == MODE_802_11_A)
-	{
+	if (psLOCAL->bMacOperationMode == MODE_802_11_A) {
 		psLOCAL->CurrentTxRate = RATE_6M;
 		psLOCAL->CurrentTxRateForMng = RATE_6M;
-	}
-	else
-	{
+	} else {
 		psLOCAL->CurrentTxRate = RATE_1M;
 		psLOCAL->CurrentTxRateForMng = RATE_1M;
 	}
     
 	GetSupportChanRange(Adapter);
 	GetIbssChan(Adapter);
-	//WBDEBUG((" ------ The IBSS channel is: band= %d, no=%d\n", psSME->IbssChan.band, psSME->IbssChan.ChanNo));
-    psLOCAL->boMsRadioOff = 0;
-
+	psLOCAL->boMsRadioOff = 0;
 
 	psLOCAL->SignalLostTh = 69;
 	psLOCAL->SignalRoamTh = 68;
@@ -303,8 +288,7 @@ void SME_ResetPara(PWB32_ADAPTER Adapter
 
 void SME_Entry(PWB32_ADAPTER Adapter, K_MSG* psSmeMsg)
 {
-	if (psSmeMsg->wMsgType==KNLMSG_RESET)
-	{
+	if (psSmeMsg->wMsgType==KNLMSG_RESET) {
 		// reset state to DISABLED and stop Timer
 		SMEstate=DISABLED;
 		vSmeTimerStop(Adapter);
@@ -330,15 +314,12 @@ void SME_Halt(PWB32_ADAPTER Adapter)
 	#ifdef _PE_STATE_DUMP_
 	//WBDEBUG(("STATE: sme timer stop OK.\n"));
 	#endif
-	while (psSME->boInTimerHandler == TRUE)
-	{
-		///NdisMSleep(10000);//10ms
+	while (psSME->boInTimerHandler == TRUE) {
 		OS_SLEEP( 10000 );
 	}
 	#ifdef _PE_STATE_DUMP_
 	WBDEBUG(("STATE: SME halt.\n"));
 	#endif
-
 }
 
 void SME_Stop(PWB32_ADAPTER Adapter)
@@ -360,7 +341,7 @@ void vActiveHWMAC_join(PWB32_ADAPTER Ada
 {
 	USHORT	wDscptIndex;
 	K_MSG	sMsg;
-	UCHAR		OpRate[MAX_OPT_RATE_SET], OpRateCount;
+	UCHAR	OpRate[MAX_OPT_RATE_SET], OpRateCount;
 	ChanInfo ChanTmp;
 
 	//12/03/03' : to avoid the join action is interrupted by scan
@@ -375,7 +356,8 @@ void vActiveHWMAC_join(PWB32_ADAPTER Ada
 	ChanTmp.band = psBSS(wDscptIndex)->band;
 	ChanTmp.ChanNo = psBSS(wDscptIndex)->DS_Parameter_Set.Current_Channel;
 	hal_set_current_channel(&Adapter->sHwData, ChanTmp);
-    // Write the SSID
+
+	// Write the SSID
 	hal_set_ssid(&Adapter->sHwData, psBSS(wDscptIndex)->SSID.SSID,
 					psBSS(wDscptIndex)->SSID.Length);
 	//dump SSID
@@ -388,24 +370,23 @@ void vActiveHWMAC_join(PWB32_ADAPTER Ada
 		WBDEBUG(("join ssid=%s\n", ssid));
 	}
 	#endif
-    // Write the capability information
+	// Write the capability information
 	hal_set_cap_info(&Adapter->sHwData, psSME->wCapabilityInfo);
-    // Write the BSSID
+
+	// Write the BSSID
 	hal_set_bssid(&Adapter->sHwData, psBSS(wDscptIndex)->abBssID);
-    // Write the Beacon Interval
+
+	// Write the Beacon Interval
 	hal_set_beacon_period(&Adapter->sHwData, psBSS(wDscptIndex)->Beacon_Period);
 
 	hal_set_rsn_wpa(&Adapter->sHwData,&psLOCAL->RSN_IE_Bitmap,&psLOCAL->RSN_OUI_Type,psSME->bDesiredAuthMode); //added by WS 07/22/04
 
-    // Write the supported rate
+	// Write the supported rate
 	//basic rates follow the target STA
 	hal_set_basic_rates(&Adapter->sHwData,
 						 psSME->BSSBasicRateSet,
 						 psSME->NumOfBSSBasicRate);
-	//operational rate use local supported
-	//hal_set_op_rates(&Adapter->sHwData,
-	//				 psSME->OperationalRateSet,
-	//				 psSME->NumOfOperationalRate);
+
 	//Operational rates will include the basic rates to avoid the condition that
 	// supported rate element is lack of operational rates.
 	OS_MEMORY_COPY( OpRate, psSME->BSSBasicRateSet, psSME->NumOfBSSBasicRate );
@@ -416,20 +397,13 @@ void vActiveHWMAC_join(PWB32_ADAPTER Ada
 	//Before the connection is successful, always use the long preamble
 	psLOCAL->boShortPreamble = 0;
 
-    // Instruct the HW-MAC to synchronize with the specified BSS
-    if (psBSS(wDscptIndex)->bBssType == ESS_NET)
-    {
-        //NdisStallExecution(1);
-        hal_join_request(&Adapter->sHwData, WLAN_BSSTYPE_INFRASTRUCTURE);
-    }
-	else
-	{
-        //NdisStallExecution(1);
-        hal_join_request(&Adapter->sHwData, WLAN_BSSTYPE_INDEPENDENT);
-	}
-	{
-		//while (psBSS(wDscptIndex)->DS_Parameter_Set.Current_Channel != Adapter->sHwData.Channel)
-		//	NdisStallExecution(100);
+	// Instruct the HW-MAC to synchronize with the specified BSS
+	if (psBSS(wDscptIndex)->bBssType == ESS_NET) {
+		//NdisStallExecution(1);
+		hal_join_request(&Adapter->sHwData, WLAN_BSSTYPE_INFRASTRUCTURE);
+	} else 	{
+		//NdisStallExecution(1);
+		hal_join_request(&Adapter->sHwData, WLAN_BSSTYPE_INDEPENDENT);
 	}
 	return;
 }
@@ -448,7 +422,7 @@ void vActiveHWMAC_join(PWB32_ADAPTER Ada
 void vActiveHWMAC_IBSS(PWB32_ADAPTER Adapter, PWB_BSSDESCRIPTION psDesData)
 {
 	K_MSG	sMsg;
-	UCHAR		OpRate[MAX_OPT_RATE_SET], OpRateCount;
+	UCHAR	OpRate[MAX_OPT_RATE_SET], OpRateCount;
 	ChanInfo ChanTmp;
 
 	//12/03/03' : to avoid the join action is interrupted by scan
@@ -456,19 +430,19 @@ void vActiveHWMAC_IBSS(PWB32_ADAPTER Ada
 	sMsg.pMsgPtr = NULL;
 	Scan_Entry(Adapter, &sMsg);
 
-    // Stop to synchronize with a BSS if it does.
+	// Stop to synchronize with a BSS if it does.
 	hal_stop_sync_bss(&Adapter->sHwData);
 
-    // Write the SSID
+	// Write the SSID
 	hal_set_ssid(&Adapter->sHwData, psDesData->SSID.SSID, psDesData->SSID.Length);
 
-    // Write the capability information
-    // Do not report short preamble capability since once the STA starts an IBSS
-    // ,the STA cannot connect (e.g. Ping) to the NIC (ATMEL chip) for the IP layer
-    // although the NIC (ATMEL chip) can join succesfully this IBSS.
-    // ATMEL does not reply to the STA with short preample capability.?
-    //
-    // CapabilityInfo |= 0x0020;       // Short preamble
+	// Write the capability information
+	// Do not report short preamble capability since once the STA starts an IBSS
+	// ,the STA cannot connect (e.g. Ping) to the NIC (ATMEL chip) for the IP layer
+	// although the NIC (ATMEL chip) can join succesfully this IBSS.
+	// ATMEL does not reply to the STA with short preample capability.?
+	//
+	// CapabilityInfo |= 0x0020;       // Short preamble
 	hal_set_cap_info(&Adapter->sHwData, psDesData->CapabilityInformation.wValue);
 
 	ChanTmp.band = psDesData->band;
@@ -476,11 +450,9 @@ void vActiveHWMAC_IBSS(PWB32_ADAPTER Ada
 	hal_set_current_channel(&Adapter->sHwData, ChanTmp);
 
 	hal_set_basic_rates(&Adapter->sHwData,
-						psSME->BSSBasicRateSet,
-						psSME->NumOfBSSBasicRate);
-//	hal_set_op_rates(&Adapter->sHwData,
-//					 psSME->OperationalRateSet,
-//					 psSME->NumOfOperationalRate);
+			    psSME->BSSBasicRateSet,
+			    psSME->NumOfBSSBasicRate);
+
 	//Operational rates will include the basic rates to avoid the condition that
 	// supported rate element is lack of operational rates.
 	OS_MEMORY_COPY( OpRate, psSME->BSSBasicRateSet, psSME->NumOfBSSBasicRate );
@@ -491,30 +463,30 @@ void vActiveHWMAC_IBSS(PWB32_ADAPTER Ada
 
 	hal_set_rsn_wpa(&Adapter->sHwData,&psLOCAL->RSN_IE_Bitmap,&psLOCAL->RSN_OUI_Type,psSME->bDesiredAuthMode); //added by WS 07/22/04
 
-	#ifdef _PE_STATE_DUMP_
+#ifdef _PE_STATE_DUMP_
 	WBDEBUG(("STATE: IBSS write BSSID =%02x-%02x-%02x-%02x-%02x-%02x\n",
-								psDesData->abBssID[0],psDesData->abBssID[1],
-								psDesData->abBssID[2],psDesData->abBssID[3],
-								psDesData->abBssID[4],psDesData->abBssID[5]));
-	#endif
-    // Write the Beacon Interval and probe delay
+		 psDesData->abBssID[0],psDesData->abBssID[1],
+		 psDesData->abBssID[2],psDesData->abBssID[3],
+		 psDesData->abBssID[4],psDesData->abBssID[5]));
+#endif
+	// Write the Beacon Interval and probe delay
 	hal_set_beacon_period(&Adapter->sHwData, psDesData->Beacon_Period);
 
-    // Write the ATIM Window
+	// Write the ATIM Window
 	hal_set_atim_window(&Adapter->sHwData, psDesData->wATIM_Window);
-	#ifdef _TMP_MARK_
-    if (psSME->wATIM_Window == 0)
-        CardDisableATIMMode(Adapter);
-    else
-        CardEnableATIMMode(Adapter);
-    //NdisStallExecution(1);
-	#endif
+#ifdef _TMP_MARK_
+	if (psSME->wATIM_Window == 0)
+		CardDisableATIMMode(Adapter);
+	else
+		CardEnableATIMMode(Adapter);
+	//NdisStallExecution(1);
+#endif
 
-    // Instruct the HW-MAC to initialize an IBSS
+	// Instruct the HW-MAC to initialize an IBSS
 	hal_start_bss(&Adapter->sHwData, WLAN_BSSTYPE_INDEPENDENT);
-    //NdisStallExecution(2);
+	//NdisStallExecution(2);
     
-    //wiat for another STA to join this IBSS
+	//wiat for another STA to join this IBSS
 	//hal_set_accept_beacon(&Adapter->sHwData, TRUE);
 }
 
@@ -530,23 +502,23 @@ void vActiveHWMAC_IBSS(PWB32_ADAPTER Ada
 //============================================================================
 void vNetConnectIndicate(PWB32_ADAPTER Adapter)
 {
-	#ifdef _PE_STATE_DUMP_
+#ifdef _PE_STATE_DUMP_
 	UCHAR ssid[33];
 
 	OS_MEMORY_COPY( ssid, psBSS(psLOCAL->wConnectedSTAindex)->SSID.SSID,
-					psBSS(psLOCAL->wConnectedSTAindex)->SSID.Length );
+			psBSS(psLOCAL->wConnectedSTAindex)->SSID.Length );
 	ssid[psBSS(psLOCAL->wConnectedSTAindex)->SSID.Length] = '\0';
 	WBDEBUG(("STATE: Connect! ,Idx=%x ,", psLOCAL->wConnectedSTAindex));
 	WBDEBUG(("SSID=%s\n",ssid));
-	#endif
-    Adapter->sLocalPara.bWepKeyError= FALSE;//added by ws 02/02/04
+#endif
+	Adapter->sLocalPara.bWepKeyError= FALSE;//added by ws 02/02/04
 	Adapter->sLocalPara.bToSelfPacketReceived = FALSE;
-    Adapter->sLocalPara.WepKeyDetectTimerCount= 2 * 100; /// 2 seconds
+	Adapter->sLocalPara.WepKeyDetectTimerCount= 2 * 100; /// 2 seconds
     
-    //for receiving packets from AP and address3 is ourself 
-    //the register of accepting all packets should be open until pass 2*1000.  
-    if(psSME->encrypt_status==ENCRYPT_WEP)
-       hal_set_accept_promiscuous(&Adapter->sHwData,1);
+	//for receiving packets from AP and address3 is ourself 
+	//the register of accepting all packets should be open until pass 2*1000.  
+	if(psSME->encrypt_status==ENCRYPT_WEP)
+		hal_set_accept_promiscuous(&Adapter->sHwData,1);
     
 	hal_set_connect_info(&Adapter->sHwData, TRUE);
 	OS_CONNECT_STATUS_INDICATE( Adapter, OS_CONNECTED );
@@ -594,28 +566,9 @@ BOOL boJoinfilter(PWB32_ADAPTER Adapter,
 {
 	ULONG tmp,SupportRateBitmap;
 	UCHAR i;
-//	UCHAR	ChanLimit;
 
 	//filter 2.4G channel based on the region
-	if (psBSS(wBssIdx)->band == BAND_TYPE_OFDM_24)
-	{
-/*
-		switch (psLOCAL->region)
-		{
-			case REGION_EUROPE:
-				ChanLimit = 13;
-				break;
-			case REGION_JAPAN:
-			case REGION_UNKNOWN:
-				ChanLimit = 14;
-				break;
-			case REGION_USA:
-			default:
-				ChanLimit = 11;
-				break;
-		}
-*/
-		//if (psBSS(wBssIdx)->DS_Parameter_Set.Current_Channel > ChanLimit)
+	if (psBSS(wBssIdx)->band == BAND_TYPE_OFDM_24) {
 		if (boChanFilter(Adapter, psBSS(wBssIdx)->DS_Parameter_Set.Current_Channel))
 		{
 			#ifdef _PE_STATE_DUMP_
@@ -633,11 +586,9 @@ BOOL boJoinfilter(PWB32_ADAPTER Adapter,
 		SupportRateBitmap = LOCAL_ALL_SUPPORTED_RATES_BITMAP;
 
 	//check basic rates
-	tmp =	psBSS(wBssIdx)->dwBasicRateBitmap ^ SupportRateBitmap;
-	if (tmp!=0)
-	{
-		if ((tmp & psBSS(wBssIdx)->dwBasicRateBitmap)!=0)
-		{
+	tmp = psBSS(wBssIdx)->dwBasicRateBitmap ^ SupportRateBitmap;
+	if (tmp!=0) {
+		if ((tmp & psBSS(wBssIdx)->dwBasicRateBitmap)!=0) {
 			#ifdef _PE_STATE_DUMP_
 			WBDEBUG(("Join filter ==> basic rate\n"));
 			#endif
@@ -647,8 +598,7 @@ BOOL boJoinfilter(PWB32_ADAPTER Adapter,
 		}
 	}
 	//check capability
-	if (psSME->_dot11PrivacyInvoked != psBSS(wBssIdx)->CapabilityInformation.Capability.CF_Privacy)
-	{
+	if (psSME->_dot11PrivacyInvoked != psBSS(wBssIdx)->CapabilityInformation.Capability.CF_Privacy) {
 		#ifdef _PE_STATE_DUMP_
 		WBDEBUG(("Join filter ==> capability\n"));
 		#endif
@@ -657,10 +607,8 @@ BOOL boJoinfilter(PWB32_ADAPTER Adapter,
 	}
 
 	Assemble_IE(Adapter, wBssIdx);
-	if (psBSS(wBssIdx)->RsnIe_len == 0)	//RSN element doesn't exist
-	{
-		if (psSME->bDesiredAuthMode > ANY_AUTH)
-		{
+	if (psBSS(wBssIdx)->RsnIe_len == 0) {	//RSN element doesn't exist
+		if (psSME->bDesiredAuthMode > ANY_AUTH) {
 			#ifdef _PE_STATE_DUMP_
 			WBDEBUG(("Join filter ==> Auth mode\n"));
 			#endif
@@ -670,10 +618,8 @@ BOOL boJoinfilter(PWB32_ADAPTER Adapter,
 	}
 
 	//added by ws 04/22/05
-	if((psSME->bDesiredAuthMode==WPA_AUTH)||(psSME->bDesiredAuthMode==WPAPSK_AUTH))
-	{
-		for(i=0;i<psBSS(wBssIdx)->pairwise_key_cipher_suite_count;i++)
-		{
+	if((psSME->bDesiredAuthMode==WPA_AUTH)||(psSME->bDesiredAuthMode==WPAPSK_AUTH)) {
+		for(i=0;i<psBSS(wBssIdx)->pairwise_key_cipher_suite_count;i++) {
 			if((psSME->DesiredEncrypt == psBSS(wBssIdx)->pairwise_key_cipher_suites[i].SuitSelector.Type))
 				return 1;
 		}
@@ -681,10 +627,8 @@ BOOL boJoinfilter(PWB32_ADAPTER Adapter,
 		return 0;
 	}
 	#ifdef _WPA2_
-	else if((psSME->bDesiredAuthMode==WPA2_AUTH)||(psSME->bDesiredAuthMode==WPA2PSK_AUTH))
-	{
-		for(i=0;i<psBSS(wBssIdx)->wpa2_pairwise_key_cipher_suite_count;i++)
-		{
+	else if((psSME->bDesiredAuthMode==WPA2_AUTH)||(psSME->bDesiredAuthMode==WPA2PSK_AUTH)) {
+		for(i=0;i<psBSS(wBssIdx)->wpa2_pairwise_key_cipher_suite_count;i++) {
 			if((psSME->DesiredEncrypt <= psBSS(wBssIdx)->wpa2_pairwise_key_cipher_suites[i].SuitSelector.Type))
 				return 1;
 		}
@@ -716,39 +660,31 @@ void SetDesiredLocalRate(PWB32_ADAPTER A
 	ULONG	BitMap;
 	UCHAR	num1;
 
-	if (psBSS(wIndex)->bBssType == ESS_NET)
-	{
+	if (psBSS(wIndex)->bBssType == ESS_NET)	{
 		//basic rates follow the destination BSS
 		//Suppose AP won't use OFDM rates at channel 14
 		psSME->NumOfBSSBasicRate = (UCHAR)strlen(psBSS(wIndex)->BasicRate);
 		OS_MEMORY_COPY( psSME->BSSBasicRateSet, psBSS(wIndex)->BasicRate, psSME->NumOfBSSBasicRate );
 		psSME->BasicRateBitmap = psBSS(wIndex)->dwBasicRateBitmap;
-	}
-	else
-	{
+	} else {
 		//The STAs in the IBSS may have different mode settings, so we can't just follow someone's setting
 		if (psLOCAL->bMacOperationMode == MODE_802_11_A)
 			psSME->BasicRateBitmap = LOCAL_11A_BASIC_RATE_BITMAP;
-		else if (psLOCAL->bMacOperationMode == MODE_802_11_BG_IBSS)
-		{
+		else if (psLOCAL->bMacOperationMode == MODE_802_11_BG_IBSS) {
 			if (psBSS(wIndex)->DS_Parameter_Set.Current_Channel != 14)
 				psSME->BasicRateBitmap = LOCAL_11G_BASIC_RATE_BITMAP;
 			else	//channel 14 can't use OFDM rates
 				psSME->BasicRateBitmap = LOCAL_11B_BASIC_RATE_BITMAP;
-		}
-		else if (psLOCAL->bMacOperationMode == MODE_AUTO)
-		{
+		} else if (psLOCAL->bMacOperationMode == MODE_AUTO) {
 			if (psBSS(wIndex)->band == BAND_TYPE_OFDM_5)
 				psSME->BasicRateBitmap = LOCAL_11A_BASIC_RATE_BITMAP;
 			else
 				psSME->BasicRateBitmap = LOCAL_11B_BASIC_RATE_BITMAP;
-		}
-		else
+		} else
 			psSME->BasicRateBitmap = LOCAL_11B_BASIC_RATE_BITMAP;
 
 		num1 = 0;
-		for (BitIndex=0 ; BitIndex<32; BitIndex++)
-		{
+		for (BitIndex=0 ; BitIndex<32; BitIndex++) {
 			tmp3	= 1<<BitIndex;
 			if (psSME->BasicRateBitmap & tmp3)
 				psSME->BSSBasicRateSet[num1++] = bBitmapToRate(BitIndex);
diff --git a/drivers/net/wireless/winbond/winbondport/wblinux.c b/drivers/net/wireless/winbond/winbondport/wblinux.c
index 147989f..3a836c4 100644
--- a/drivers/net/wireless/winbond/winbondport/wblinux.c
+++ b/drivers/net/wireless/winbond/winbondport/wblinux.c
@@ -10,19 +10,15 @@
 //============================================================================
 #include "os_common.h"
 #include "linux/new_wireless.h"
+
 ULONG
-  WBLINUX_MemoryAlloc( OUT PVOID *VirtualAddress, IN UINT Length )
+WBLINUX_MemoryAlloc( OUT PVOID *VirtualAddress, IN UINT Length )
 {
-#ifndef CONFIG_BOARD_W90N740
-   *VirtualAddress = kmalloc( Length, GFP_ATOMIC ); //GFP_KERNEL is not suitable
-#else
-   //Added by WangJS 2006.9.1,
-   //To suit for cache mechanism of W90N740 board, the MSB of assined address must be 1
-   *VirtualAddress = (PVOID)((ULONG)kmalloc( Length, GFP_ATOMIC ) | 0x80000000); //GFP_KERNEL is not suitable
-#endif
-   if( *VirtualAddress == NULL )
-     return OS_MEMORY_ALLOC_FAIL;
-   return OS_MEMORY_ALLOC_OK;
+	*VirtualAddress = kmalloc( Length, GFP_ATOMIC ); //GFP_KERNEL is not suitable
+
+	if (*VirtualAddress == NULL)
+		return OS_MEMORY_ALLOC_FAIL;
+	return OS_MEMORY_ALLOC_OK;
 }
 
 LONG
diff --git a/drivers/net/wireless/winbond/winbondport/wblinux_s.h b/drivers/net/wireless/winbond/winbondport/wblinux_s.h
index 4995194..6faf1e4 100644
--- a/drivers/net/wireless/winbond/winbondport/wblinux_s.h
+++ b/drivers/net/wireless/winbond/winbondport/wblinux_s.h
@@ -1,43 +1,42 @@
 //============================================================
 // wblinux_s.h
 //
-#define OS_MEMORY_ALLOC( _V, _S )					WBLINUX_MemoryAlloc( _V, _S )
-#define OS_PACKET_SIZE( _A )						(!Adapter->WbLinux.shutdown && Adapter->WbLinux.skb_array[Adapter->WbLinux.skb_GetIndex]) ? (USHORT)Adapter->WbLinux.skb_array[Adapter->WbLinux.skb_GetIndex]->len : 0
-#define OS_LINK_STATUS							(Adapter->WbLinux.LinkStatus == OS_CONNECTED)
-#define OS_SET_SHUTDOWN( _A )						_A->WbLinux.shutdown=1
-#define OS_SET_RESUME( _A )							_A->WbLinux.shutdown=0
+#define OS_MEMORY_ALLOC( _V, _S )	WBLINUX_MemoryAlloc( _V, _S )
+#define OS_PACKET_SIZE( _A )		(!Adapter->WbLinux.shutdown && Adapter->WbLinux.skb_array[Adapter->WbLinux.skb_GetIndex]) ? (USHORT)Adapter->WbLinux.skb_array[Adapter->WbLinux.skb_GetIndex]->len : 0
+#define OS_LINK_STATUS			(Adapter->WbLinux.LinkStatus == OS_CONNECTED)
+#define OS_SET_SHUTDOWN( _A )		_A->WbLinux.shutdown=1
+#define OS_SET_RESUME( _A )		_A->WbLinux.shutdown=0
 #define OS_CONNECT_STATUS_INDICATE( _A, _F )		WBLINUX_ConnectStatus( _A, _F )
 #define OS_DISCONNECTED	0
 #define OS_CONNECTED	1
 #define OS_STOP( _A )	WBLINUX_stop( _A )
 
-#define OS_CURRENT_RX_BYTE( _A )					_A->WbLinux.RxByteCount
-#define OS_CURRENT_TX_BYTE( _A )					_A->WbLinux.TxByteCount
+#define OS_CURRENT_RX_BYTE( _A )		_A->WbLinux.RxByteCount
+#define OS_CURRENT_TX_BYTE( _A )		_A->WbLinux.TxByteCount
 #define OS_EVENT_INDICATE( _A, _B, _F )
 #define OS_PMKID_STATUS_EVENT( _A )
 #define OS_RECEIVE_PACKET_INDICATE( _A, _D )		WBLinux_ReceivePacket( _A, _D )
 #define OS_RECEIVE_802_1X_PACKET_INDICATE( _A, _D )	EAP_ReceivePacket( _A, _D )
-#define OS_GET_PACKET( _A, _D )						WBLINUX_GetNextPacket( _A, _D )
-#define OS_GET_PACKET_COMPLETE( _A, _D )			WBLINUX_GetNextPacketCompleted( _A, _D )
+#define OS_GET_PACKET( _A, _D )				WBLINUX_GetNextPacket( _A, _D )
+#define OS_GET_PACKET_COMPLETE( _A, _D )	WBLINUX_GetNextPacketCompleted( _A, _D )
 #define OS_SEND_RESULT( _A, _ID, _R )
 
 #define WBLINUX_PACKET_ARRAY_SIZE	(ETHERNET_TX_DESCRIPTORS*4)
 
-
 typedef struct _WBLINUX
 {
 	OS_SPIN_LOCK	AtomicSpinLock;
 	OS_SPIN_LOCK	SpinLock;
-	ULONG	shutdown;// 931130.4.s
+	ULONG	shutdown;
 
 	// For storing the 802.3 NDIS packet
 	struct net_device_stats 	stats;
 
 	OS_ATOMIC	ThreadCount;
 
-	struct net_device *			netdev;
+	struct net_device *netdev;
 
-	ULONG	LinkStatus;		// OS_DISCONNECTED	or  OS_CONNECTED
+	ULONG	LinkStatus;		// OS_DISCONNECTED or OS_CONNECTED
 
 	ULONG	RxByteCount;
 	ULONG	TxByteCount;
@@ -47,7 +46,6 @@ typedef struct _WBLINUX
 	LONG	skb_SetIndex;
 	LONG	skb_GetIndex;
 	LONG	netif_state_stop; // 1: stop  0: normal
-
 } WBLINUX, *PWBLINUX;
 
 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
