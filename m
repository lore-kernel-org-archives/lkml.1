Return-Path: <linux-kernel-owner+w=401wt.eu-S1756242AbZC0RrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbZC0RrB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 13:47:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754373AbZC0Rqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 13:46:50 -0400
Received: from smtp-68.nebula.fi ([83.145.220.68]:46866 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609AbZC0Rqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 13:46:49 -0400
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: [PATCH] w35und: remove unused code from wbsoft_configure_filter()
Date: Fri, 27 Mar 2009 19:46:45 +0200
Message-Id: <1238176005-7392-1-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't initialize hardware multicast filter in the driver nor do we know how
to do that. Therefore, remove some code that isn't actually used from
wbsoft_configure_filter().

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/wbusb.c |   24 +++---------------------
 1 files changed, 3 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index f716b2e..5201f5c 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -83,32 +83,14 @@ static void wbsoft_configure_filter(struct ieee80211_hw *dev,
 				     unsigned int *total_flags,
 				     int mc_count, struct dev_mc_list *mclist)
 {
-	unsigned int bit_nr, new_flags;
-	u32 mc_filter[2];
-	int i;
+	unsigned int new_flags;
 
 	new_flags = 0;
 
-	if (*total_flags & FIF_PROMISC_IN_BSS) {
+	if (*total_flags & FIF_PROMISC_IN_BSS)
 		new_flags |= FIF_PROMISC_IN_BSS;
-		mc_filter[1] = mc_filter[0] = ~0;
-	} else if ((*total_flags & FIF_ALLMULTI) || (mc_count > 32)) {
+	else if ((*total_flags & FIF_ALLMULTI) || (mc_count > 32))
 		new_flags |= FIF_ALLMULTI;
-		mc_filter[1] = mc_filter[0] = ~0;
-	} else {
-		mc_filter[1] = mc_filter[0] = 0;
-		for (i = 0; i < mc_count; i++) {
-			if (!mclist)
-				break;
-			printk("Should call ether_crc here\n");
-			//bit_nr = ether_crc(ETH_ALEN, mclist->dmi_addr) >> 26;
-			bit_nr = 0;
-
-			bit_nr &= 0x3F;
-			mc_filter[bit_nr >> 5] |= 1 << (bit_nr & 31);
-			mclist = mclist->next;
-		}
-	}
 
 	dev->flags &= ~IEEE80211_HW_RX_INCLUDES_FCS;
 
-- 
1.5.4.3

