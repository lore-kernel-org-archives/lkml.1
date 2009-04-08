Return-Path: <linux-kernel-owner+w=401wt.eu-S1763466AbZDHIwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763466AbZDHIwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 04:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758786AbZDHIvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 04:51:39 -0400
Received: from smtp-68.nebula.fi ([83.145.220.68]:60968 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761524AbZDHIv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 04:51:27 -0400
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 3/4] w35und: inline hal_set_rf_power() to mto.c
Date: Wed,  8 Apr 2009 11:51:21 +0300
Message-Id: <1239180682-22860-3-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1239180682-22860-1-git-send-email-penberg@cs.helsinki.fi>
References: <1239180682-22860-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

It's a trivial wrapper that is used in only one place, so lets inline it.

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/mto.c     |    2 +-
 drivers/staging/winbond/wbhal.c   |    5 -----
 drivers/staging/winbond/wbhal_f.h |    1 -
 3 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/winbond/mto.c b/drivers/staging/winbond/mto.c
index 94a060b..7deb5c7 100644
--- a/drivers/staging/winbond/mto.c
+++ b/drivers/staging/winbond/mto.c
@@ -175,7 +175,7 @@ void MTO_Init(struct wbsoft_priv *adapter)
 	}
 	else	//follow the setting from EEPROM
 		MTOPARA_TXPOWER_INDEX() = MTO_TXPOWER_FROM_EEPROM;
-	hal_set_rf_power(MTO_HAL(), (u8)MTOPARA_TXPOWER_INDEX());
+	RFSynthesizer_SetPowerIndex(MTO_HAL(), (u8)MTOPARA_TXPOWER_INDEX());
 	//------------------------------------------------
 
 	// For RSSI turning 20060808.4 Cancel load from EEPROM
diff --git a/drivers/staging/winbond/wbhal.c b/drivers/staging/winbond/wbhal.c
index 01626a1..b9a6e38 100644
--- a/drivers/staging/winbond/wbhal.c
+++ b/drivers/staging/winbond/wbhal.c
@@ -18,8 +18,3 @@ unsigned char hal_set_dxx_reg(struct hw_data *pHwData, u16 number, u32 value)
 	ret = Wb35Reg_WriteSync(pHwData, number, value);
 	return ret;
 }
-
-void hal_set_rf_power(struct hw_data *pHwData, u8 PowerIndex)
-{
-	RFSynthesizer_SetPowerIndex(pHwData, PowerIndex);
-}
diff --git a/drivers/staging/winbond/wbhal_f.h b/drivers/staging/winbond/wbhal_f.h
index c4934cb..fd1d3c2 100644
--- a/drivers/staging/winbond/wbhal_f.h
+++ b/drivers/staging/winbond/wbhal_f.h
@@ -39,7 +39,6 @@ void hal_set_cwmax(  struct hw_data * pHwData,  u16 cwin_max );
 void hal_set_rsn_wpa(  struct hw_data * pHwData,  u32 * RSN_IE_Bitmap , u32 * RSN_OUI_type , unsigned char bDesiredAuthMode);
 void hal_set_connect_info(  struct hw_data * pHwData,  unsigned char boConnect );
 u8 hal_get_est_sq3(  struct hw_data * pHwData,  u8 Count );
-void hal_set_rf_power(  struct hw_data * pHwData,  u8 PowerIndex ); // 20060621 Modify
 void hal_descriptor_indicate(  struct hw_data * pHwData,  PDESCRIPTOR pDes );
 u8 hal_get_antenna_number(  struct hw_data * pHwData );
 u32 hal_get_bss_pk_cnt(  struct hw_data * pHwData );
-- 
1.5.6.3

