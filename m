Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509AbZDZIXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbZDZIXg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 04:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753200AbZDZIXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 04:23:25 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:25899 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbZDZIXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 04:23:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:user-agent:mime-version
         :content-type;
        b=cDaRsMK2yi1oKYSwKXgXFrfPyFzh8hIGWXzzCcN4zGjrPpjNtIn584/LV7STANyYJJ
         Rr/MVISYHOewsYOSbM2dWDDVRo6duemncDkfLY6KSn34pa+uXUhq9bH3OMzgRoOIjGVE
         ZQAQeFsK1IdfnkiCvjrobYHTW32cOXqiDiCds=
Date: Sun, 26 Apr 2009 10:23:50 +0200 (CEST)
From: Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2.6.29-rc8] drivers/staging/otus/80211core/amsdu.c: Fix Coding
 Style
Message-ID: <alpine.DEB.2.00.0904261022490.9155@Sentinel>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>

--- drivers/staging/otus/80211core/amsdu.c	2009-03-19 20:26:41.000000000 +0100
+++ drivers/staging/otus/80211core/amsdu_cs_fix.c	2009-03-25 00:15:52.000000000 +0100
@@ -34,53 +34,53 @@
 /*      Stephen Chen        Atheros Communications, INC.    2007.2      */
 /*                                                                      */
 /************************************************************************/
-zbuf_t* zfGetAmsduSubFrame(zdev_t* dev, zbuf_t* buf, u16_t* offset)
+zbuf_t *zfGetAmsduSubFrame(zdev_t *dev, zbuf_t *buf, u16_t *offset)
 {
-    u16_t subframeLen;
-    u16_t amsduLen = zfwBufGetSize(dev, buf);
-    zbuf_t* newBuf;
-
-    ZM_PERFORMANCE_RX_AMSDU(dev, buf, amsduLen);
-
-    /* Verify A-MSDU length */
-    if (amsduLen < (*offset + 14))
-    {
-        return NULL;
-    }
-
-    /* Locate A-MSDU subframe by offset and verify subframe length */
-    subframeLen = (zmw_buf_readb(dev, buf, *offset + 12) << 8) +
-                  zmw_buf_readb(dev, buf, *offset + 13);
-    if (subframeLen == 0)
-    {
-        return NULL;
-    }
-
-    /* Verify A-MSDU subframe length */
-    if ((*offset+14+subframeLen) <= amsduLen)
-    {
-        /* Allocate a new buffer */
-        if ((newBuf = zfwBufAllocate(dev, 24+2+subframeLen)) != NULL)
-        {
+	u16_t subframeLen;
+	u16_t amsduLen = zfwBufGetSize(dev, buf);
+	zbuf_t *newBuf;
+
+	ZM_PERFORMANCE_RX_AMSDU(dev, buf, amsduLen);
+
+	/* Verify A-MSDU length */
+	if (amsduLen < (*offset + 14))
+		return NULL;
+
+	/* Locate A-MSDU subframe by offset and verify subframe length */
+	subframeLen = (zmw_buf_readb(dev, buf, *offset + 12) << 8) +
+		zmw_buf_readb(dev, buf, *offset + 13);
+
+	if (subframeLen == 0)
+		return NULL;
+
+	/* Verify A-MSDU subframe length */
+	if ((*offset+14+subframeLen) <= amsduLen) {
+		/* Allocate a new buffer */
+		newBuf = zfwBufAllocate(dev, 24+2+subframeLen);
+		if (newBuf != NULL) {
 #ifdef ZM_ENABLE_NATIVE_WIFI
-            /* Copy and convert subframe to wlan frame format */
-            /* SHALL NOT INCLUDE QOS and AMSDU header. Ray 20070807 For Vista */
-            zfRxBufferCopy(dev, newBuf, buf, 0, 0, 24);
-            zfRxBufferCopy(dev, newBuf, buf, 24, *offset+14, subframeLen);
-            zfwBufSetSize(dev, newBuf, 24+subframeLen);
+			/* Copy and convert subframe to wlan frame format
+			* SHALL NOT INCLUDE QOS and AMSDU header.
+			* Ray 20070807 For Vista
+			*/
+			zfRxBufferCopy(dev, newBuf, buf, 0, 0, 24);
+			zfRxBufferCopy(dev, newBuf, buf, 24, *offset+14,
+					subframeLen);
+			zfwBufSetSize(dev, newBuf, 24+subframeLen);
 #else
-            /* Copy subframe to new buffer */
-            zfRxBufferCopy(dev, newBuf, buf, 0, *offset, 14+subframeLen);
-            zfwBufSetSize(dev, newBuf, 14+subframeLen);
+			/* Copy subframe to new buffer */
+			zfRxBufferCopy(dev, newBuf, buf, 0, *offset,
+					14+subframeLen);
+			zfwBufSetSize(dev, newBuf, 14+subframeLen);
 #endif
-            /* Update offset */
-            *offset += (((14+subframeLen)+3) & 0xfffc);
+			/* Update offset */
+			*offset += (((14+subframeLen)+3) & 0xfffc);
 
-            /* Return buffer pointer */
-            return newBuf;
-        }
-    }
-    return NULL;
+			/* Return buffer pointer */
+			return newBuf;
+		}
+	}
+	return NULL;
 }
 
 
@@ -101,34 +101,29 @@ zbuf_t* zfGetAmsduSubFrame(zdev_t* dev, 
 /*      Stephen Chen        Atheros Communications, INC.    2007.2      */
 /*                                                                      */
 /************************************************************************/
-void zfDeAmsdu(zdev_t* dev, zbuf_t* buf, u16_t vap, u8_t encryMode)
+void zfDeAmsdu(zdev_t *dev, zbuf_t *buf, u16_t vap, u8_t encryMode)
 {
-    u16_t offset = ZM_SIZE_OF_WLAN_DATA_HEADER+ZM_SIZE_OF_QOS_CTRL;
-    zbuf_t* subframeBuf;
-    zmw_get_wlan_dev(dev);
-
-    ZM_BUFFER_TRACE(dev, buf)
-
-    if (encryMode == ZM_AES || encryMode == ZM_TKIP)
-    {
-        offset += (ZM_SIZE_OF_IV + ZM_SIZE_OF_EXT_IV);
-    }
-    else if (encryMode == ZM_WEP64 || encryMode == ZM_WEP128)
-    {
-        offset += ZM_SIZE_OF_IV;
-    }
-
-    /* Repeatly calling zfGetAmsduSubFrame() until NULL returned */
-    while ((subframeBuf = zfGetAmsduSubFrame(dev, buf, &offset)) != NULL)
-    {
-        wd->commTally.NotifyNDISRxFrmCnt++;
-        if (wd->zfcbRecvEth != NULL)
-    	{
-            wd->zfcbRecvEth(dev, subframeBuf, (u8_t)vap);
-            ZM_PERFORMANCE_RX_MSDU(dev, wd->tick);
-        }
-    }
-    zfwBufFree(dev, buf, 0);
+	u16_t offset = ZM_SIZE_OF_WLAN_DATA_HEADER+ZM_SIZE_OF_QOS_CTRL;
+	zbuf_t *subframeBuf;
+	zmw_get_wlan_dev(dev);
+
+	ZM_BUFFER_TRACE(dev, buf)
+
+	if (encryMode == ZM_AES || encryMode == ZM_TKIP)
+		offset += (ZM_SIZE_OF_IV + ZM_SIZE_OF_EXT_IV);
+	else if (encryMode == ZM_WEP64 || encryMode == ZM_WEP128)
+		offset += ZM_SIZE_OF_IV;
+
+
+	/* Repeatly calling zfGetAmsduSubFrame() until NULL returned */
+	while ((subframeBuf = zfGetAmsduSubFrame(dev, buf, &offset)) != NULL) {
+		wd->commTally.NotifyNDISRxFrmCnt++;
+		if (wd->zfcbRecvEth != NULL) {
+			wd->zfcbRecvEth(dev, subframeBuf, (u8_t)vap);
+			ZM_PERFORMANCE_RX_MSDU(dev, wd->tick);
+		}
+	}
+	zfwBufFree(dev, buf, 0);
 
-    return;
+	return;
 }
