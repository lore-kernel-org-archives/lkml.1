Return-Path: <linux-kernel-owner+w=401wt.eu-S1756904AbYJ3QLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904AbYJ3QLt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 12:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754885AbYJ3QLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 12:11:40 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:10349 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666AbYJ3QLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 12:11:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=kxHiRporfzGgL85yDsOSPRl9Hj0Lpb9NIfGMF697dFeKFk8GlJIYXb31r79DthHujN
         VB3ZlAIrKzHDcZj2p+yTMtqR3kBCMFofutLibC3iahIifLrG1K0RrNmDt5wmT+lO7gxA
         6zQHx0UH8jPEAO9NteJUKfXd1R6IFYE/f/8hI=
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@suse.cz>
Subject: [PATCH 3/7] w35und: remove unused ->ShutDowned member from struct LOCAL_PARA
Date: Thu, 30 Oct 2008 18:12:03 +0200
Message-Id: <1225383127-16406-3-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1225383127-16406-2-git-send-email-penberg@cs.helsinki.fi>
References: <>
 <1225383127-16406-1-git-send-email-penberg@cs.helsinki.fi>
 <1225383127-16406-2-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not actually read by anyone so we might as well remove it.

Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/localpara.h |    1 -
 drivers/staging/winbond/wbusb.c     |    6 ------
 2 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/winbond/localpara.h b/drivers/staging/winbond/localpara.h
index a308ac2..607bb05 100644
--- a/drivers/staging/winbond/localpara.h
+++ b/drivers/staging/winbond/localpara.h
@@ -149,7 +149,6 @@ typedef struct LOCAL_PARA
 
     //// power-save variables
     u8  		  	iPowerSaveMode;     // 0 indicates it is on, 1 indicates it is off
-	u8			ShutDowned;
 	u8			ATIMmode;
 	u8			ExcludeUnencrypted;
 
diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index 673875d..0f70101 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -220,9 +220,6 @@ static unsigned char wb35_hw_init(struct ieee80211_hw *hw)
 	pHwData = &priv->sHwData;
 	hal_set_phy_type( pHwData, RF_DECIDE_BY_INF );
 
-	// Initial Software variable
-	priv->sLocalPara.ShutDowned = false;
-
 	//added by ws for wep key error detection
 	priv->sLocalPara.bWepKeyError= false;
 	priv->sLocalPara.bToSelfPacketReceived = false;
@@ -424,9 +421,6 @@ void packet_came(struct ieee80211_hw *hw, char *pRxBufferAddress, int PacketSize
 
 static void wb35_hw_halt(struct wbsoft_priv *adapter)
 {
-	//---------------------
-	adapter->sLocalPara.ShutDowned = true;
-
 	Mds_Destroy( adapter );
 
 	// Turn off Rx and Tx hardware ability
-- 
1.5.3.7

