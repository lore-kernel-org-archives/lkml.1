Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab0CGOeL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 09:34:11 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:52013 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437Ab0CGOeI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 09:34:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=tGcIbohE6hqhFpf+7Bn8M9EK9JpJA35sD3lRVqiNCPFqmv/sV92zqekyF66m14sl2z
         OaY/302osS0lfhmkA4+L+ZQDvT3+llYZtqjqHUi1qwX5dzbmo1maz1x9Ew/KpzzDQEPY
         b+yAQqO/GYaskfS5Hc1MYm8UrDpdje7Tz5BJ0=
Date: Sun, 7 Mar 2010 15:33:29 +0100
From: Ali =?UTF-8?B?R8O8bmTDvHo=?= <gndz.ali@gmail.com>
To: gregkh@suse.de
Cc: bzolnier@gmail.com, sd@sedf.de, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Staging-rt2860-fix-coding-style-issues-in-rt_linux.c.patch
Message-ID: <20100307153329.29c44889@200>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Staging: rt2860: fix coding style issues in rt_linux.c
This is a patch to rt_linux.c that fixes various coding style issues
Signed-off-by: Ali Gündüz <gndz.ali@gmail.com>
diff --git a/drivers/staging/rt2860/rt_linux.c
b/drivers/staging/rt2860/rt_linux.c index 9357fb2..9afc7dd 100644
--- a/drivers/staging/rt2860/rt_linux.c
+++ b/drivers/staging/rt2860/rt_linux.c
@@ -80,7 +80,7 @@ char const
*pWirelessFloodEventText[IW_FLOOD_EVENT_TYPE_NUM] = { };
 
 /* timeout -- ms */
-void RTMP_SetPeriodicTimer(struct timer_list * pTimer,
+void RTMP_SetPeriodicTimer(struct timer_list *pTimer,
 			   IN unsigned long timeout)
 {
 	timeout = ((timeout * OS_HZ) / 1000);
@@ -90,7 +90,7 @@ void RTMP_SetPeriodicTimer(struct timer_list * pTimer,
 
 /* convert NdisMInitializeTimer --> RTMP_OS_Init_Timer */
 void RTMP_OS_Init_Timer(struct rt_rtmp_adapter *pAd,
-			struct timer_list * pTimer,
+			struct timer_list *pTimer,
 			IN TIMER_FUNCTION function, void *data)
 {
 	init_timer(pTimer);
@@ -98,7 +98,7 @@ void RTMP_OS_Init_Timer(struct rt_rtmp_adapter *pAd,
 	pTimer->function = function;
 }
 
-void RTMP_OS_Add_Timer(struct timer_list * pTimer,
+void RTMP_OS_Add_Timer(struct timer_list *pTimer,
 		       IN unsigned long timeout)
 {
 	if (timer_pending(pTimer))
@@ -109,22 +109,20 @@ void RTMP_OS_Add_Timer(struct timer_list * pTimer,
 	add_timer(pTimer);
 }
 
-void RTMP_OS_Mod_Timer(struct timer_list * pTimer,
+void RTMP_OS_Mod_Timer(struct timer_list *pTimer,
 		       IN unsigned long timeout)
 {
 	timeout = ((timeout * OS_HZ) / 1000);
 	mod_timer(pTimer, jiffies + timeout);
 }
 
-void RTMP_OS_Del_Timer(struct timer_list * pTimer,
+void RTMP_OS_Del_Timer(struct timer_list *pTimer,
 		       OUT BOOLEAN * pCancelled)
 {
-	if (timer_pending(pTimer)) {
+	if (timer_pending(pTimer))
 		*pCancelled = del_timer_sync(pTimer);
-	} else {
+	else
 		*pCancelled = TRUE;
-	}
-
 }
 
 void RTMP_OS_Release_Packet(struct rt_rtmp_adapter *pAd, struct
rt_queue_entry *pEntry) @@ -144,7 +142,7 @@ void RTMPusecDelay(unsigned
long usec) udelay(usec % 50);
 }
 
-void RTMP_GetCurrentSystemTime(LARGE_INTEGER * time)
+void RTMP_GetCurrentSystemTime(LARGE_INTEGER *time)
 {
 	time->u.LowPart = jiffies;
 }
@@ -154,9 +152,9 @@ int os_alloc_mem(struct rt_rtmp_adapter *pAd, u8 **
mem, unsigned long size) {
 	*mem = (u8 *)kmalloc(size, GFP_ATOMIC);
 	if (*mem)
-		return (NDIS_STATUS_SUCCESS);
+		return NDIS_STATUS_SUCCESS;
 	else
-		return (NDIS_STATUS_FAILURE);
+		return NDIS_STATUS_FAILURE;
 }
 
 /* pAd MUST allow to be NULL */
@@ -165,7 +163,7 @@ int os_free_mem(struct rt_rtmp_adapter *pAd, void
*mem) 
 	ASSERT(mem);
 	kfree(mem);
-	return (NDIS_STATUS_SUCCESS);
+	return NDIS_STATUS_SUCCESS;
 }
 
 void *RtmpOSNetPktAlloc(struct rt_rtmp_adapter *pAd, IN int size)
@@ -189,9 +187,8 @@ void *RTMP_AllocateFragPacketBuffer(struct
rt_rtmp_adapter *pAd, ("can't allocate frag rx %ld size packet\n",
Length)); }
 
-	if (pkt) {
+	if (pkt)
 		RTMP_SET_PACKET_SOURCE(OSPKT_TO_RTPKT(pkt),
PKTSRC_NDIS);
-	}
 
 	return (void *)pkt;
 }
@@ -199,7 +196,7 @@ void *RTMP_AllocateFragPacketBuffer(struct
rt_rtmp_adapter *pAd, void *RTMP_AllocateTxPacketBuffer(struct
rt_rtmp_adapter *pAd, unsigned long Length,
 					 IN BOOLEAN Cached,
-					 void ** VirtualAddress)
+					 void **VirtualAddress)
 {
 	struct sk_buff *pkt;
 
@@ -267,7 +264,7 @@ void RTMPFreeAdapter(struct rt_rtmp_adapter *pAd)
 
 BOOLEAN OS_Need_Clone_Packet(void)
 {
-	return (FALSE);
+	return FALSE;
 }
 
 /*
@@ -295,7 +292,7 @@ BOOLEAN OS_Need_Clone_Packet(void)
 int RTMPCloneNdisPacket(struct rt_rtmp_adapter *pAd,
 				IN BOOLEAN pInsAMSDUHdr,
 				void *pInPacket,
-				void ** ppOutPacket)
+				void **ppOutPacket)
 {
 
 	struct sk_buff *pkt;
@@ -306,9 +303,8 @@ int RTMPCloneNdisPacket(struct rt_rtmp_adapter *pAd,
 	/* 1. Allocate a packet */
 	pkt = dev_alloc_skb(2048);
 
-	if (pkt == NULL) {
+	if (pkt == NULL)
 		return NDIS_STATUS_FAILURE;
-	}
 
 	skb_put(pkt, GET_OS_PKT_LEN(pInPacket));
 	NdisMoveMemory(pkt->data, GET_OS_PKT_DATAPTR(pInPacket),
@@ -324,7 +320,7 @@ int RTMPCloneNdisPacket(struct rt_rtmp_adapter *pAd,
 
 /* the allocated NDIS PACKET must be freed via RTMPFreeNdisPacket() */
 int RTMPAllocateNdisPacket(struct rt_rtmp_adapter *pAd,
-				   void ** ppPacket,
+				   void **ppPacket,
 				   u8 *pHeader,
 				   u32 HeaderLen,
 				   u8 *pData, u32 DataLen)
@@ -387,7 +383,7 @@ int Sniff2BytesFromNdisBuffer(char *pFirstBuffer,
 
 void RTMP_QueryPacketInfo(void *pPacket,
 			  struct rt_packet_info *pPacketInfo,
-			  u8 ** pSrcBufVA, u32 * pSrcBufLen)
+			  u8 **pSrcBufVA, u32 * pSrcBufLen)
 {
 	pPacketInfo->BufferCount = 1;
 	pPacketInfo->pFirstBuffer = (char
*)GET_OS_PKT_DATAPTR(pPacket); @@ -398,9 +394,9 @@ void
RTMP_QueryPacketInfo(void *pPacket, *pSrcBufLen =
GET_OS_PKT_LEN(pPacket); }
 
-void RTMP_QueryNextPacketInfo(void ** ppPacket,
+void RTMP_QueryNextPacketInfo(void **ppPacket,
 			      struct rt_packet_info *pPacketInfo,
-			      u8 ** pSrcBufVA, u32 * pSrcBufLen)
+			      u8 **pSrcBufVA, u32 * pSrcBufLen)
 {
 	void *pPacket = NULL;
 
@@ -585,7 +581,7 @@ rt_get_sg_list_from_packet(void *pPacket, struct
rt_rtmp_sg_list *sg) sg->NumberOfElements = 1;
 	sg->Elements[0].Address = GET_OS_PKT_DATAPTR(pPacket);
 	sg->Elements[0].Length = GET_OS_PKT_LEN(pPacket);
-	return (sg);
+	return sg;
 }
 
 void hex_dump(char *str, unsigned char *pSrcBufVA, unsigned int
SrcBufLen) @@ -784,11 +780,11 @@ void send_monitor_packets(struct
rt_rtmp_adapter *pAd, struct rt_rx_blk *pRxBlk) pRxBlk->pData +=
header_len; }			/*end if */
 
-	if (pRxBlk->DataSize < pOSPkt->len) {
+	if (pRxBlk->DataSize < pOSPkt->len)
 		skb_trim(pOSPkt, pRxBlk->DataSize);
-	} else {
+	else
 		skb_put(pOSPkt, (pRxBlk->DataSize - pOSPkt->len));
-	}			/*end if */
+				/*end if */
 
 	if ((pRxBlk->pData - pOSPkt->data) > 0) {
 		skb_put(pOSPkt, (pRxBlk->pData - pOSPkt->data));
@@ -1243,7 +1239,7 @@ void RtmpOSNetDevFree(struct net_device *pNetDev)
 	free_netdev(pNetDev);
 }
 
-int RtmpOSNetDevAlloc(struct net_device ** new_dev_p, u32 privDataSize)
+int RtmpOSNetDevAlloc(struct net_device **new_dev_p, u32 privDataSize)
 {
 	/* assign it as null first. */
 	*new_dev_p = NULL;
@@ -1308,9 +1304,8 @@ int RtmpOSNetDevAttach(struct net_device *pNetDev,
 		/* OS specific flags, here we used to indicate if we
are virtual interface */ pNetDev->priv_flags = pDevOpHook->priv_flags;
 
-		if (pAd->OpMode == OPMODE_STA) {
+		if (pAd->OpMode == OPMODE_STA)
 			pNetDev->wireless_handlers =
&rt28xx_iw_handler_def;
-		}
 
 		/* copy the net device mac address to the net_device
structure. */ NdisMoveMemory(pNetDev->dev_addr,
 		&pDevOpHook->devAddr[0],
