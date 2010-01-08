Return-Path: <linux-kernel-owner+w=401wt.eu-S1753250Ab0AHICO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab0AHICO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 03:02:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251Ab0AHIBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 03:01:37 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:54979 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab0AHIBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 03:01:34 -0500
Message-Id: <20100108075920.747421764@vergenet.net>
User-Agent: quilt/0.48-1
Date: Fri, 08 Jan 2010 18:57:50 +1100
From: horms@vergenet.net
Subject: [patch 2/6] otus: remove unused variables
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Peter Huewe <PeterHuewe@gmx.de>
References: <20100108075748.059645106@vergenet.net>
Content-Disposition: inline; filename=otus-unused-variables.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Simon Horman <horms@verge.net.au>

Index: linux-2.6/drivers/staging/otus/hal/hprw.c
===================================================================
--- linux-2.6.orig/drivers/staging/otus/hal/hprw.c	2010-01-08 16:16:40.000000000 +1100
+++ linux-2.6/drivers/staging/otus/hal/hprw.c	2010-01-08 16:17:51.000000000 +1100
@@ -282,7 +282,6 @@ void zfIdlRsp(zdev_t* dev, u32_t* rsp, u
     else if (src == ZM_OID_FLASH_READ)
     {
         u32_t  datalen;
-        u16_t i;
 
         datalen = (rsp[0] & 255);
 
Index: linux-2.6/drivers/staging/otus/80211core/cagg.c
===================================================================
--- linux-2.6.orig/drivers/staging/otus/80211core/cagg.c	2010-01-08 16:16:40.000000000 +1100
+++ linux-2.6/drivers/staging/otus/80211core/cagg.c	2010-01-08 16:17:51.000000000 +1100
@@ -1832,8 +1832,7 @@ u16_t zfAggRxClear(zdev_t* dev, u32_t ti
 
 struct agg_tid_rx* zfAggRxEnabled(zdev_t* dev, zbuf_t* buf)
 {
-    u16_t   dst0, src[3], ac, aid, fragOff;
-    u8_t    up;
+    u16_t   dst0, src[3], aid;
     u16_t   offset = 0;
     u16_t   seq_no;
     u16_t frameType;
Index: linux-2.6/drivers/staging/otus/80211core/ledmgr.c
===================================================================
--- linux-2.6.orig/drivers/staging/otus/80211core/ledmgr.c	2010-01-08 16:16:40.000000000 +1100
+++ linux-2.6/drivers/staging/otus/80211core/ledmgr.c	2010-01-08 16:17:51.000000000 +1100
@@ -187,7 +187,6 @@ void zfLedCtrlType2_scan(zdev_t* dev);
 
 void zfLedCtrlType2(zdev_t* dev)
 {
-    u32_t ton, toff, tmp, period;
     u16_t OperateLED;
     zmw_get_wlan_dev(dev);
 
Index: linux-2.6/drivers/staging/otus/80211core/cmm.c
===================================================================
--- linux-2.6.orig/drivers/staging/otus/80211core/cmm.c	2010-01-08 16:19:35.000000000 +1100
+++ linux-2.6/drivers/staging/otus/80211core/cmm.c	2010-01-08 16:19:51.000000000 +1100
@@ -346,8 +346,6 @@ u16_t zfFindSuperGElement(zdev_t* dev, z
     u8_t super_feature;
     u8_t ouiSuperG[6] = {0x00,0x03,0x7f,0x01, 0x01, 0x00};
 
-    zmw_get_wlan_dev(dev);
-
     /* Get offset of first element */
     subType = (zmw_rx_buf_readb(dev, buf, 0) >> 4);
     if ((offset = zgElementOffsetTable[subType]) == 0xff)
@@ -411,8 +409,6 @@ u16_t zfFindXRElement(zdev_t* dev, zbuf_
     u8_t id;
     u8_t ouixr[6] = {0x00,0x03,0x7f,0x03, 0x01, 0x00};
 
-    zmw_get_wlan_dev(dev);
-
     /* Get offset of first element */
     subType = (zmw_rx_buf_readb(dev, buf, 0) >> 4);
     if ((offset = zgElementOffsetTable[subType]) == 0xff)
Index: linux-2.6/drivers/staging/otus/80211core/cmmsta.c
===================================================================
--- linux-2.6.orig/drivers/staging/otus/80211core/cmmsta.c	2010-01-08 16:20:01.000000000 +1100
+++ linux-2.6/drivers/staging/otus/80211core/cmmsta.c	2010-01-08 16:28:16.000000000 +1100
@@ -4848,8 +4848,6 @@ u16_t zfStaAddIePowerCap(zdev_t* dev, zb
     u8_t MaxTxPower;
     u8_t MinTxPower;
 
-    zmw_get_wlan_dev(dev);
-
     /* Element ID */
     zmw_tx_buf_writeb(dev, buf, offset++, ZM_WLAN_EID_POWER_CAPABILITY);
 
@@ -5276,7 +5274,6 @@ u16_t zfStaRxValidateFrame(zdev_t* dev, 
     u8_t   da0;
     //u16_t  sa[3];
     u16_t  ret;
-    u16_t  i;
     //u8_t    sa0;
 
     zmw_get_wlan_dev(dev);
@@ -5738,8 +5735,6 @@ u16_t zfComputeBssInfoWeightValue(zdev_t
 	u8_t  weightOfN40BelowThr = 16;
 	u8_t  weightOfN40UpThr    = 32;
 
-    zmw_get_wlan_dev(dev);
-
     if( isBMode == 0 )
         return (signalStrength + weightOfB);    // pure b mode , do not add the weight value for this AP !
     else
Index: linux-2.6/drivers/staging/otus/80211core/ctxrx.c
===================================================================
--- linux-2.6.orig/drivers/staging/otus/80211core/ctxrx.c	2010-01-08 16:18:23.000000000 +1100
+++ linux-2.6/drivers/staging/otus/80211core/ctxrx.c	2010-01-08 16:26:59.000000000 +1100
@@ -882,7 +882,6 @@ zlError:
 /************************************************************************/
 u16_t zfTxSendEth(zdev_t* dev, zbuf_t* buf, u16_t port, u16_t bufType, u16_t flag)
 {
-    u16_t err;
     //u16_t addrTblSize;
     //struct zsAddrTbl addrTbl;
     u16_t removeLen;
@@ -904,7 +903,6 @@ u16_t zfTxSendEth(zdev_t* dev, zbuf_t* b
     u8_t qosType, keyIdx = 0;
     u16_t fragOff;
     u16_t newFlag;
-    struct zsMicVar*  pMicKey;
     u8_t tkipFrameOffset = 0;
 
     zmw_get_wlan_dev(dev);
@@ -1692,8 +1690,6 @@ void zfShowTxEAPOL(zdev_t* dev, zbuf_t* 
     u16_t  packetLen, keyInfo, keyLen, keyDataLen, length, Op_Code;
     u32_t  replayCounterH, replayCounterL, vendorId, VendorType;
 
-    zmw_get_wlan_dev(dev);
-
     zm_debug_msg1("EAPOL Packet size = ", zfwBufGetSize(dev, buf));
 
     /* EAPOL packet type */
@@ -2436,7 +2432,6 @@ void zfiRecv80211(zdev_t* dev, zbuf_t* b
                     u16_t IvOffset;
                     u8_t keyLen = 5;
                     u8_t iv[3];
-                    u8_t *wepKey;
                     u8_t keyIdx;
 
                     IvOffset = offset + ZM_SIZE_OF_WLAN_DATA_HEADER;
Index: linux-2.6/drivers/staging/otus/hal/hpmain.c
===================================================================
--- linux-2.6.orig/drivers/staging/otus/hal/hpmain.c	2010-01-08 16:16:09.000000000 +1100
+++ linux-2.6/drivers/staging/otus/hal/hpmain.c	2010-01-08 16:17:55.000000000 +1100
@@ -1316,7 +1316,6 @@ void zfHpSetFrequencyEx(zdev_t* dev, u32
         u8_t extOffset, u8_t initRF)
 {
     u32_t cmd[9];
-    u32_t cmdB[3];
     u16_t ret;
     u8_t old_band;
     u8_t new_band;
@@ -3434,7 +3433,6 @@ void zfSetPowerCalTable(zdev_t* dev, u32
     /* Write PHY regs 672-703 */
     for (i=0; i<128; i+=4)
     {
-        u32_t regAddr = 0x9800 + (672 * 4);
         u32_t val;
 
         val = ((u32_t)vpd_chain1[i+3]<<24) |
@@ -3485,7 +3483,6 @@ void zfSetPowerCalTable(zdev_t* dev, u32
     /* Write PHY regs 672-703 + 0x1000 */
     for (i=0; i<128; i+=4)
     {
-        u32_t regAddr = 0x9800 + (672 * 4) + 0x1000;
         u32_t val;
 
         val = ((u32_t)vpd_chain3[i+3]<<24) |
@@ -4584,7 +4581,6 @@ void zfHpSetRollCallTable(zdev_t* dev)
 void zfHpSetTTSIFSTime(zdev_t* dev, u8_t sifs_time)
 {
     u32_t reg_value = 0;
-    zmw_get_wlan_dev(dev);
 
     sifs_time &= 0x3f;
     reg_value = 0x14400b | (((u32_t)sifs_time)<<24);
Index: linux-2.6/drivers/staging/otus/80211core/cfunc.c
===================================================================
--- linux-2.6.orig/drivers/staging/otus/80211core/cfunc.c	2010-01-08 16:21:00.000000000 +1100
+++ linux-2.6/drivers/staging/otus/80211core/cfunc.c	2010-01-08 16:21:06.000000000 +1100
@@ -1194,8 +1194,6 @@ u16_t zfFindMinimumUtilizationChannelInd
     u8_t   i;
     u16_t  tempMinIndex, tempMinValue;
 
-    zmw_get_wlan_dev(dev);
-
     i = 1;
     tempMinIndex = 0;
     tempMinValue = array[tempMinIndex];
Index: linux-2.6/drivers/staging/otus/80211core/cpsmgr.c
===================================================================
--- linux-2.6.orig/drivers/staging/otus/80211core/cpsmgr.c	2010-01-08 16:28:42.000000000 +1100
+++ linux-2.6/drivers/staging/otus/80211core/cpsmgr.c	2010-01-08 16:28:59.000000000 +1100
@@ -381,8 +381,6 @@ static void zfPowerSavingMgrSleepIfIdle(
 
 static void zfPowerSavingMgrDisconnectMain(zdev_t* dev)
 {
-    zmw_get_wlan_dev(dev);
-
 #ifdef ZM_ENABLE_DISCONNECT_PS
     switch(wd->sta.psMgr.state)
     {
Index: linux-2.6/drivers/staging/otus/80211core/cscanmgr.c
===================================================================
--- linux-2.6.orig/drivers/staging/otus/80211core/cscanmgr.c	2010-01-08 16:29:15.000000000 +1100
+++ linux-2.6/drivers/staging/otus/80211core/cscanmgr.c	2010-01-08 16:29:23.000000000 +1100
@@ -289,8 +289,6 @@ static void zfScanMgrEventSetFreqComplet
 
 static void zfScanMgrEventScanCompleteCb(zdev_t* dev)
 {
-    zmw_get_wlan_dev(dev);
-
     if ((zfStaIsConnected(dev)) && (!zfPowerSavingMgrIsSleeping(dev)))
     {
         zfSendNullData(dev, 0);

