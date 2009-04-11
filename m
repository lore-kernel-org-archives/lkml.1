Return-Path: <linux-kernel-owner+w=401wt.eu-S1758514AbZDKTDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758514AbZDKTDT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 15:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754558AbZDKTDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 15:03:10 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:65100 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504AbZDKTDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 15:03:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=hpAb8bQnbRX+A3WlG2LCmjqq0je44UmJ6G1TnFVzwKyfh6m0m+F/MilHSpXKyFrf7l
         CxTIrMISbnBzmLVVTKotMenMvZMMMIL+JW47Vq1CWhSbuJmJx4Ks22WE6AfbUqf7647/
         Mw2xS6VYA/fsj0lXCU4QRM6nAaFaBM+w5mXc0=
Date: Sat, 11 Apr 2009 23:03:04 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Staging: stlc45xx: replace print_mac with %pM
Message-ID: <20090411190304.GB18885@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 drivers/staging/stlc45xx/stlc45xx.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/stlc45xx/stlc45xx.c b/drivers/staging/stlc45xx/stlc45xx.c
index 3eced55..cfdaac9 100644
--- a/drivers/staging/stlc45xx/stlc45xx.c
+++ b/drivers/staging/stlc45xx/stlc45xx.c
@@ -1787,7 +1787,6 @@ static int stlc45xx_tx_pspoll(struct stlc45xx *stlc, bool powersave)
 	int payload_len, padding, i;
 	struct s_lm_data_out *data;
 	struct txbuffer *entry;
-	DECLARE_MAC_BUF(mac);
 	struct sk_buff *skb;
 	char *payload;
 	u16 fc;
@@ -1813,8 +1812,8 @@ static int stlc45xx_tx_pspoll(struct stlc45xx *stlc, bool powersave)
 	memcpy(pspoll->addr1, stlc->bssid, ETH_ALEN);
 	memcpy(pspoll->addr2, stlc->mac_addr, ETH_ALEN);
 
-	stlc45xx_debug(DEBUG_PSM, "sending PS-Poll frame to %s (powersave %d, "
-		       "fc 0x%x, aid %d)", print_mac(mac, pspoll->addr1),
+	stlc45xx_debug(DEBUG_PSM, "sending PS-Poll frame to %pM (powersave %d, "
+		       "fc 0x%x, aid %d)", pspoll->addr1,
 		       powersave, fc, stlc->aid);
 
 	spin_lock_bh(&stlc->tx_lock);
@@ -1903,7 +1902,6 @@ static int stlc45xx_tx_nullfunc(struct stlc45xx *stlc, bool powersave)
 	int payload_len, padding, i;
 	struct s_lm_data_out *data;
 	struct txbuffer *entry;
-	DECLARE_MAC_BUF(mac);
 	struct sk_buff *skb;
 	char *payload;
 	u16 fc;
@@ -1928,9 +1926,8 @@ static int stlc45xx_tx_nullfunc(struct stlc45xx *stlc, bool powersave)
 	memcpy(nullfunc->addr2, stlc->mac_addr, ETH_ALEN);
 	memcpy(nullfunc->addr3, stlc->bssid, ETH_ALEN);
 
-	stlc45xx_debug(DEBUG_PSM, "sending Null frame to %s (powersave %d, "
-		       "fc 0x%x)",
-		       print_mac(mac, nullfunc->addr1), powersave, fc);
+	stlc45xx_debug(DEBUG_PSM, "sending Null frame to %pM (powersave %d, "
+		       "fc 0x%x)", nullfunc->addr1, powersave, fc);
 
 	spin_lock_bh(&stlc->tx_lock);
 
