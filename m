Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591Ab0CAPNw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:13:52 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:46342 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab0CAPMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:12:49 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 15/26] w35und: Convert RadioOff typedef to struct wb35_radio_off
Date: Mon,  1 Mar 2010 17:04:17 +0200
Message-Id: <1267455868-4533-15-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
References: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/localpara.h |    7 +++----
 drivers/staging/winbond/sme_api.h   |    4 ++--
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/winbond/localpara.h b/drivers/staging/winbond/localpara.h
index 7f22f5b..ebce37f 100644
--- a/drivers/staging/winbond/localpara.h
+++ b/drivers/staging/winbond/localpara.h
@@ -115,11 +115,10 @@ struct wb35_chan_info {
 	u8		ChanNo;
 };
 
-typedef struct _RadioOff
-{
+struct wb35_radio_off {
 	u8			boHwRadioOff;
 	u8			boSwRadioOff;
-} RadioOff, *psRadioOff;
+};
 
 //===========================================================================
 typedef struct LOCAL_PARA
@@ -172,7 +171,7 @@ typedef struct LOCAL_PARA
     u16			ListenInterval;     	// The listen interval when SME invoking MLME_
             	                    	// (Re)Associate_Request().
 
-	RadioOff		RadioOffStatus;
+	struct wb35_radio_off	RadioOffStatus;
 	u8			Reserved0[2];
 
 	u8			boMsRadioOff;			// Ndis demands to be true when set Disassoc. OID and be false when set SSID OID.
diff --git a/drivers/staging/winbond/sme_api.h b/drivers/staging/winbond/sme_api.h
index 4a60aca..6aba9a9 100644
--- a/drivers/staging/winbond/sme_api.h
+++ b/drivers/staging/winbond/sme_api.h
@@ -193,8 +193,8 @@ s8 sme_get_cwmin_value(void *pcore_data, u8 *cwmin);
 s8 sme_get_cwmax_value(void *pcore_data, u16 *cwmax);
 s8 sme_get_ms_radio_mode(void *pcore_data, u8 * pMsRadioOff);
 s8 sme_set_ms_radio_mode(void *pcore_data, u8 boMsRadioOff);
-s8 sme_get_radio_mode(void *pcore_data, psRadioOff pRadioOffData);
-s8 sme_set_radio_mode(void *pcore_data, RadioOff RadioOffData);
+s8 sme_get_radio_mode(void *pcore_data, struct wb35_radio_off *pRadioOffData);
+s8 sme_set_radio_mode(void *pcore_data, struct wb35_radio_off RadioOffData);
 
 void sme_get_tx_power_level(void *pcore_data, u32 *TxPower);
 u8 sme_set_tx_power_level(void *pcore_data, u32 TxPower);
-- 
1.6.3.3

