Return-Path: <linux-kernel-owner+w=401wt.eu-S933017AbZLRVI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017AbZLRVI2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 16:08:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932900AbZLRVI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 16:08:26 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:33519 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932764AbZLRVIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 16:08:25 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 2/8] w35und: Convert typedef RadioOff to struct radio_off
Date: Fri, 18 Dec 2009 23:08:16 +0200
Message-Id: <1261170502-1479-2-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1261170502-1479-1-git-send-email-penberg@cs.helsinki.fi>
References: <1261170502-1479-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/localpara.h |    6 +++---
 drivers/staging/winbond/sme_api.h   |    2 --
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/winbond/localpara.h b/drivers/staging/winbond/localpara.h
index b731875..b82d5ce 100644
--- a/drivers/staging/winbond/localpara.h
+++ b/drivers/staging/winbond/localpara.h
@@ -129,11 +129,11 @@ typedef struct _CHAN_LIST
 	ChanInfo		Channel[50]; // 100B
 } CHAN_LIST, *psCHAN_LIST;
 
-typedef struct _RadioOff
+struct radio_off
 {
 	u8			boHwRadioOff;
 	u8			boSwRadioOff;
-} RadioOff, *psRadioOff;
+};
 
 //===========================================================================
 struct wb_local_para
@@ -186,7 +186,7 @@ struct wb_local_para
     u16			ListenInterval;     	// The listen interval when SME invoking MLME_
             	                    	// (Re)Associate_Request().
 
-	RadioOff		RadioOffStatus;
+	struct radio_off		RadioOffStatus;
 	u8			Reserved0[2];
 
 	u8			boMsRadioOff;			// Ndis demands to be true when set Disassoc. OID and be false when set SSID OID.
diff --git a/drivers/staging/winbond/sme_api.h b/drivers/staging/winbond/sme_api.h
index 5498783..62c2564 100644
--- a/drivers/staging/winbond/sme_api.h
+++ b/drivers/staging/winbond/sme_api.h
@@ -193,8 +193,6 @@ s8 sme_get_cwmin_value(void *pcore_data, u8 *cwmin);
 s8 sme_get_cwmax_value(void *pcore_data, u16 *cwmax);
 s8 sme_get_ms_radio_mode(void *pcore_data, u8 * pMsRadioOff);
 s8 sme_set_ms_radio_mode(void *pcore_data, u8 boMsRadioOff);
-s8 sme_get_radio_mode(void *pcore_data, psRadioOff pRadioOffData);
-s8 sme_set_radio_mode(void *pcore_data, RadioOff RadioOffData);
 
 void sme_get_tx_power_level(void *pcore_data, u32 *TxPower);
 u8 sme_set_tx_power_level(void *pcore_data, u32 TxPower);
-- 
1.6.0.4

