Return-Path: <linux-kernel-owner+w=401wt.eu-S933892AbZHWN3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933892AbZHWN3M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 09:29:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933840AbZHWN3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 09:29:10 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:58451 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933760AbZHWN3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 09:29:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=XRPqDfTczgSujgLkZZn6PwRbZzNmPPkU4DFlVu6cCYZ0V3aYSlB/Ig7TgRmPQimySU
         uSLnKqxsgOdBXQxETNcBItwzv4t8oihOgxbE6lK9ujR3jXj9cBEkWO/DXn/IA4Q+4zJK
         7BPI/Y8yPyEy+YkC+FAKnjhCgRsbyCNnNvRyg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Date: Sun, 23 Aug 2009 15:29:32 +0200
Message-Id: <20090823132932.17784.15655.sendpatchset@localhost.localdomain>
In-Reply-To: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
References: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
Subject: [PATCH 07/33] Staging: rt3070: WEP fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rt3070: WEP fixes

Propagate WEP fixes from rt28[67]0 to rt3070.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/common/cmm_wpa.c |   12 ++----------
 drivers/staging/rt2860/common/mlme.c    |   22 ++--------------------
 drivers/staging/rt2860/sta/wpa.c        |    4 ----
 drivers/staging/rt2860/sta_ioctl.c      |    2 --
 4 files changed, 4 insertions(+), 36 deletions(-)

Index: b/drivers/staging/rt2860/common/cmm_wpa.c
===================================================================
--- a/drivers/staging/rt2860/common/cmm_wpa.c
+++ b/drivers/staging/rt2860/common/cmm_wpa.c
@@ -39,14 +39,10 @@
 // WPA OUI
 UCHAR		OUI_WPA_NONE_AKM[4]		= {0x00, 0x50, 0xF2, 0x00};
 UCHAR       OUI_WPA_VERSION[4]      = {0x00, 0x50, 0xF2, 0x01};
-#ifndef RT30xx
 UCHAR       OUI_WPA_WEP40[4]      = {0x00, 0x50, 0xF2, 0x01};
-#endif
 UCHAR       OUI_WPA_TKIP[4]     = {0x00, 0x50, 0xF2, 0x02};
 UCHAR       OUI_WPA_CCMP[4]     = {0x00, 0x50, 0xF2, 0x04};
-#ifndef RT30xx
 UCHAR       OUI_WPA_WEP104[4]      = {0x00, 0x50, 0xF2, 0x05};
-#endif
 UCHAR       OUI_WPA_8021X_AKM[4]	= {0x00, 0x50, 0xF2, 0x01};
 UCHAR       OUI_WPA_PSK_AKM[4]      = {0x00, 0x50, 0xF2, 0x02};
 // WPA2 OUI
@@ -55,9 +51,7 @@ UCHAR       OUI_WPA2_TKIP[4]        = {0
 UCHAR       OUI_WPA2_CCMP[4]        = {0x00, 0x0F, 0xAC, 0x04};
 UCHAR       OUI_WPA2_8021X_AKM[4]   = {0x00, 0x0F, 0xAC, 0x01};
 UCHAR       OUI_WPA2_PSK_AKM[4]   	= {0x00, 0x0F, 0xAC, 0x02};
-#ifndef RT30xx
 UCHAR       OUI_WPA2_WEP104[4]   = {0x00, 0x0F, 0xAC, 0x05};
-#endif
 // MSA OUI
 UCHAR   	OUI_MSA_8021X_AKM[4]    = {0x00, 0x0F, 0xAC, 0x05};		// Not yet final - IEEE 802.11s-D1.06
 UCHAR   	OUI_MSA_PSK_AKM[4]   	= {0x00, 0x0F, 0xAC, 0x06};		// Not yet final - IEEE 802.11s-D1.06
@@ -376,7 +370,6 @@ static VOID RTMPInsertRsnIeCipher(
                 break;
         }
 
-#ifndef RT30xx
 		if ((pAd->OpMode == OPMODE_STA) &&
 			(pAd->StaCfg.GroupCipher != Ndis802_11Encryption2Enabled) &&
 			(pAd->StaCfg.GroupCipher != Ndis802_11Encryption3Enabled))
@@ -392,7 +385,7 @@ static VOID RTMPInsertRsnIeCipher(
 					break;
 			}
 		}
-#endif
+
 		// swap for big-endian platform
 		pRsnie_cipher->version = cpu2le16(pRsnie_cipher->version);
 	    pRsnie_cipher->ucount = cpu2le16(pRsnie_cipher->ucount);
@@ -453,7 +446,6 @@ static VOID RTMPInsertRsnIeCipher(
                 break;
         }
 
-#ifndef RT30xx
 		if ((pAd->OpMode == OPMODE_STA) &&
 			(pAd->StaCfg.GroupCipher != Ndis802_11Encryption2Enabled) &&
 			(pAd->StaCfg.GroupCipher != Ndis802_11Encryption3Enabled))
@@ -469,7 +461,7 @@ static VOID RTMPInsertRsnIeCipher(
 					break;
 			}
 		}
-#endif
+
 		// swap for big-endian platform
 		pRsnie_cipher->version = cpu2le16(pRsnie_cipher->version);
 	    pRsnie_cipher->ucount = cpu2le16(pRsnie_cipher->ucount);
Index: b/drivers/staging/rt2860/common/mlme.c
===================================================================
--- a/drivers/staging/rt2860/common/mlme.c
+++ b/drivers/staging/rt2860/common/mlme.c
@@ -3912,11 +3912,8 @@ VOID BssTableSsidSort(
 							continue;
 
 					// check group cipher
-					if (
-#ifndef RT30xx
-					    pInBss->WPA.GroupCipher != Ndis802_11GroupWEP40Enabled &&
+					if (pInBss->WPA.GroupCipher != Ndis802_11GroupWEP40Enabled &&
 					    pInBss->WPA.GroupCipher != Ndis802_11GroupWEP104Enabled &&
-#endif
 					    pAd->StaCfg.WepStatus < pInBss->WPA.GroupCipher)
 						continue;
 
@@ -3936,11 +3933,8 @@ VOID BssTableSsidSort(
 							continue;
 
 					// check group cipher
-					if (
-#ifndef RT30xx
-					    pInBss->WPA2.GroupCipher != Ndis802_11GroupWEP40Enabled &&
+					if (pInBss->WPA2.GroupCipher != Ndis802_11GroupWEP40Enabled &&
 					    pInBss->WPA2.GroupCipher != Ndis802_11GroupWEP104Enabled &&
-#endif
 					    pAd->StaCfg.WepStatus < pInBss->WPA2.GroupCipher)
 						continue;
 
@@ -4219,16 +4213,10 @@ VOID BssCipherParse(
 				switch (*pTmp)
 				{
 					case 1:
-#ifndef RT30xx
 						pBss->WPA.GroupCipher = Ndis802_11GroupWEP40Enabled;
 						break;
 					case 5:
 						pBss->WPA.GroupCipher = Ndis802_11GroupWEP104Enabled;
-#endif
-#ifdef RT30xx
-					case 5:	// Although WEP is not allowed in WPA related auth mode, we parse it anyway
-						pBss->WPA.GroupCipher = Ndis802_11Encryption1Enabled;
-#endif
 						break;
 					case 2:
 						pBss->WPA.GroupCipher = Ndis802_11Encryption2Enabled;
@@ -4344,16 +4332,10 @@ VOID BssCipherParse(
 				switch (pCipher->Type)
 				{
 					case 1:
-#ifndef RT30xx
 						pBss->WPA2.GroupCipher = Ndis802_11GroupWEP40Enabled;
 						break;
 					case 5:
 						pBss->WPA2.GroupCipher = Ndis802_11GroupWEP104Enabled;
-#endif
-#ifdef RT30xx
-					case 5:	// Although WEP is not allowed in WPA related auth mode, we parse it anyway
-						pBss->WPA2.GroupCipher = Ndis802_11Encryption1Enabled;
-#endif
 						break;
 					case 2:
 						pBss->WPA2.GroupCipher = Ndis802_11Encryption2Enabled;
Index: b/drivers/staging/rt2860/sta/wpa.c
===================================================================
--- a/drivers/staging/rt2860/sta/wpa.c
+++ b/drivers/staging/rt2860/sta/wpa.c
@@ -1384,12 +1384,10 @@ VOID	WpaGroupMsg1Action(
 			pAd->SharedKey[BSS0][pAd->StaCfg.DefaultKeyId].CipherAlg = CIPHER_TKIP;
 		else if (pAd->StaCfg.GroupCipher == Ndis802_11Encryption3Enabled)
 			pAd->SharedKey[BSS0][pAd->StaCfg.DefaultKeyId].CipherAlg = CIPHER_AES;
-#ifndef RT30xx
 		else if (pAd->StaCfg.GroupCipher == Ndis802_11GroupWEP40Enabled)
 			pAd->SharedKey[BSS0][pAd->StaCfg.DefaultKeyId].CipherAlg = CIPHER_WEP64;
 		else if (pAd->StaCfg.GroupCipher == Ndis802_11GroupWEP104Enabled)
 			pAd->SharedKey[BSS0][pAd->StaCfg.DefaultKeyId].CipherAlg = CIPHER_WEP128;
-#endif
 
     	//hex_dump("Group Key :", pAd->SharedKey[BSS0][pAd->StaCfg.DefaultKeyId].Key, LEN_TKIP_EK);
 	}
@@ -1797,12 +1795,10 @@ BOOLEAN ParseKeyData(
 		pAd->SharedKey[BSS0][pAd->StaCfg.DefaultKeyId].CipherAlg = CIPHER_TKIP;
 	else if (pAd->StaCfg.GroupCipher == Ndis802_11Encryption3Enabled)
 		pAd->SharedKey[BSS0][pAd->StaCfg.DefaultKeyId].CipherAlg = CIPHER_AES;
-#ifndef RT30xx
 	else if (pAd->StaCfg.GroupCipher == Ndis802_11GroupWEP40Enabled)
 		pAd->SharedKey[BSS0][pAd->StaCfg.DefaultKeyId].CipherAlg = CIPHER_WEP64;
 	else if (pAd->StaCfg.GroupCipher == Ndis802_11GroupWEP104Enabled)
 		pAd->SharedKey[BSS0][pAd->StaCfg.DefaultKeyId].CipherAlg = CIPHER_WEP128;
-#endif
 
 	return TRUE;
 
Index: b/drivers/staging/rt2860/sta_ioctl.c
===================================================================
--- a/drivers/staging/rt2860/sta_ioctl.c
+++ b/drivers/staging/rt2860/sta_ioctl.c
@@ -2216,7 +2216,6 @@ int rt_ioctl_siwencodeext(struct net_dev
 
                 NdisZeroMemory(pAdapter->SharedKey[BSS0][keyIdx].Key,  16);
 			    NdisMoveMemory(pAdapter->SharedKey[BSS0][keyIdx].Key, ext->key, ext->key_len);
-#ifndef RT30xx
 				if (pAdapter->StaCfg.GroupCipher == Ndis802_11GroupWEP40Enabled ||
 					pAdapter->StaCfg.GroupCipher == Ndis802_11GroupWEP104Enabled)
 				{
@@ -2231,7 +2230,6 @@ int rt_ioctl_siwencodeext(struct net_dev
     				// Indicate Connected for GUI
     				pAdapter->IndicateMediaState = NdisMediaStateConnected;
 				}
-#endif
     			break;
             case IW_ENCODE_ALG_TKIP:
                 DBGPRINT(RT_DEBUG_TRACE, ("%s::IW_ENCODE_ALG_TKIP - keyIdx = %d, ext->key_len = %d\n", __func__, keyIdx, ext->key_len));
