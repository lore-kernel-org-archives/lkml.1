Return-Path: <linux-kernel-owner+w=401wt.eu-S1754158Ab0ARCue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab0ARCue (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 21:50:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586Ab0ARCud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 21:50:33 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34948 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751114Ab0ARCud convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 21:50:33 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Linux driver project <devel@driverdev.osuosl.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 18 Jan 2010 02:50:24 +0000
Message-ID: <1263783024.8876.109.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH 1/2] rt2870sta: constify RTUSBMultiWrite(),
 RTUSBFirmwareWrite()
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These functions do not modify the data they are passed.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/rt2860/rtmp.h            |    6 +++---
 drivers/staging/rt2870/common/rtusb_io.c |   10 +++++-----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rt2860/rtmp.h b/drivers/staging/rt2860/rtmp.h
index c50abf4..6c6503d 100644
--- a/drivers/staging/rt2860/rtmp.h
+++ b/drivers/staging/rt2860/rtmp.h
@@ -4043,10 +4043,10 @@ int RTUSBMultiRead(struct rt_rtmp_adapter *pAd,
 			u16 Offset, u8 *pData, u16 length);
 
 int RTUSBMultiWrite(struct rt_rtmp_adapter *pAd,
-			 u16 Offset, u8 *pData, u16 length);
+		    u16 Offset, const u8 *pData, u16 length);
 
 int RTUSBMultiWrite_OneByte(struct rt_rtmp_adapter *pAd,
-				 u16 Offset, u8 *pData);
+			    u16 Offset, const u8 *pData);
 
 int RTUSBReadBBPRegister(struct rt_rtmp_adapter *pAd,
 			      u8 Id, u8 *pValue);
@@ -4112,7 +4112,7 @@ int RTUSBSingleWrite(struct rt_rtmp_adapter *pAd,
 			  u16 Offset, u16 Value);
 
 int RTUSBFirmwareWrite(struct rt_rtmp_adapter *pAd,
-			    u8 *pFwImage, unsigned long FwLen);
+		       const u8 *pFwImage, unsigned long FwLen);
 
 int RTUSBVenderReset(struct rt_rtmp_adapter *pAd);
 
diff --git a/drivers/staging/rt2870/common/rtusb_io.c b/drivers/staging/rt2870/common/rtusb_io.c
index 34443f2..cf0d2f5 100644
--- a/drivers/staging/rt2870/common/rtusb_io.c
+++ b/drivers/staging/rt2870/common/rtusb_io.c
@@ -84,7 +84,7 @@ static int RTUSBFirmwareRun(struct rt_rtmp_adapter *pAd)
 	========================================================================
 */
 int RTUSBFirmwareWrite(struct rt_rtmp_adapter *pAd,
-			    u8 *pFwImage, unsigned long FwLen)
+		       const u8 *pFwImage, unsigned long FwLen)
 {
 	u32 MacReg;
 	int Status;
@@ -167,7 +167,7 @@ int RTUSBMultiRead(struct rt_rtmp_adapter *pAd,
 	========================================================================
 */
 int RTUSBMultiWrite_OneByte(struct rt_rtmp_adapter *pAd,
-				 u16 Offset, u8 *pData)
+			    u16 Offset, const u8 *pData)
 {
 	int Status;
 
@@ -175,18 +175,18 @@ int RTUSBMultiWrite_OneByte(struct rt_rtmp_adapter *pAd,
 	Status = RTUSB_VendorRequest(pAd,
 				     USBD_TRANSFER_DIRECTION_OUT,
 				     DEVICE_VENDOR_REQUEST_OUT,
-				     0x6, 0, Offset, pData, 1);
+				     0x6, 0, Offset, (u8 *)pData, 1);
 
 	return Status;
 }
 
 int RTUSBMultiWrite(struct rt_rtmp_adapter *pAd,
-			 u16 Offset, u8 *pData, u16 length)
+		    u16 Offset, const u8 *pData, u16 length)
 {
 	int Status;
 
 	u16 index = 0, Value;
-	u8 *pSrc = pData;
+	const u8 *pSrc = pData;
 	u16 resude = 0;
 
 	resude = length % 2;
-- 
1.6.6



