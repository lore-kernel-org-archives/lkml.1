Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab0BVSKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 13:10:42 -0500
Received: from smtp.nokia.com ([192.100.105.134]:27368 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918Ab0BVSKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 13:10:40 -0500
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 08/11] staging: rt2860: use new hex_to_bin() method
Date: Mon, 22 Feb 2010 20:09:07 +0200
Message-Id: <1c143f904aaf005e81f1adf057d8c8df8b6ea294.1266861291.git.ext-andriy.shevchenko@nokia.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <5c02662a55439f65791e24b8282d4face566955e.1266861291.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <d8c224af14aa936dcd692c70656559fe9726d997.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <5627f8a3ddb2d746e58409d1d59338a99b77291a.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <c515333a5ade859310436de33402a057080ec429.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <939cb3c63fbf6639b5d301ddc79c64d5642a6b81.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <d8efe17f827514a0c470191dccaf00afd09c2854.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <8470deda388af7015db44e96fa69560dd6e30126.1266861291.git.ext-andriy.shevchenko@nokia.com>
 <5c02662a55439f65791e24b8282d4face566955e.1266861291.git.ext-andriy.shevchenko@nokia.com>
In-Reply-To: <cover.1266861291.git.ext-andriy.shevchenko@nokia.com>
References: <cover.1266861291.git.ext-andriy.shevchenko@nokia.com>
X-OriginalArrivalTime: 22 Feb 2010 18:10:30.0292 (UTC) FILETIME=[51673D40:01CAB3EA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Instead of using own implementation involve hex_to_bin() function. It requires
to have hex_to_bin() introduced by starter patch in series.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/rt2860/common/rtmp_init.c |   15 ++-------------
 drivers/staging/rt2860/rtmp.h             |    2 --
 2 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/rt2860/common/rtmp_init.c b/drivers/staging/rt2860/common/rtmp_init.c
index 21a95ff..a090385 100644
--- a/drivers/staging/rt2860/common/rtmp_init.c
+++ b/drivers/staging/rt2860/common/rtmp_init.c
@@ -2810,17 +2810,6 @@ void UserCfgInit(struct rt_rtmp_adapter *pAd)
 }
 
 /* IRQL = PASSIVE_LEVEL */
-u8 BtoH(char ch)
-{
-	if (ch >= '0' && ch <= '9')
-		return (ch - '0');	/* Handle numerals */
-	if (ch >= 'A' && ch <= 'F')
-		return (ch - 'A' + 0xA);	/* Handle capitol hex digits */
-	if (ch >= 'a' && ch <= 'f')
-		return (ch - 'a' + 0xA);	/* Handle small hex digits */
-	return (255);
-}
-
 /* */
 /*  FUNCTION: AtoH(char *, u8 *, int) */
 /* */
@@ -2847,8 +2836,8 @@ void AtoH(char *src, u8 *dest, int destlen)
 	destTemp = (u8 *)dest;
 
 	while (destlen--) {
-		*destTemp = BtoH(*srcptr++) << 4;	/* Put 1st ascii byte in upper nibble. */
-		*destTemp += BtoH(*srcptr++);	/* Add 2nd ascii byte to above. */
+		*destTemp = hex_to_bin(*srcptr++) << 4;	/* Put 1st ascii byte in upper nibble. */
+		*destTemp += hex_to_bin(*srcptr++);	/* Add 2nd ascii byte to above. */
 		destTemp++;
 	}
 }
diff --git a/drivers/staging/rt2860/rtmp.h b/drivers/staging/rt2860/rtmp.h
index c50abf4..c91dfc2 100644
--- a/drivers/staging/rt2860/rtmp.h
+++ b/drivers/staging/rt2860/rtmp.h
@@ -2366,8 +2366,6 @@ void RTMPMoveMemory(void *pDest, void *pSrc, unsigned long Length);
 
 void AtoH(char *src, u8 *dest, int destlen);
 
-u8 BtoH(char ch);
-
 void RTMPPatchMacBbpBug(struct rt_rtmp_adapter *pAd);
 
 void RTMPInitTimer(struct rt_rtmp_adapter *pAd,
-- 
1.5.6.5

