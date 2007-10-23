Return-Path: <linux-kernel-owner+w=401wt.eu-S1756522AbXJWWj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522AbXJWWj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 18:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755691AbXJWWgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 18:36:50 -0400
Received: from havoc.gtf.org ([69.61.125.42]:49461 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755641AbXJWWgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 18:36:48 -0400
To: LKML <linux-kernel@vger.kernel.org>
From: Jeff Garzik <jeff@garzik.org>
Cc: akpm@linux-foundation.org, linux-wireless@vger.kernel.org,
       linville@tuxdriver.com
References: <tueoct232007613pm.likjasfdlkjdas987@havoc.gtf.org>
Subject: [PATCH 10/12] mac80211: fix warning created by BIT()
Message-Id: <20071023223645.421AB1F81B6@havoc.gtf.org>
Date: Tue, 23 Oct 2007 18:36:45 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Now that BIT() forces unsigned long, this warning appears:

net/mac80211/ieee80211_sta.c: In function ‘ieee80211_rx_mgmt_assoc_resp’:
net/mac80211/ieee80211_sta.c:1187: warning: format ‘%d’ expects type ‘int’, but argument 7 has type ‘long unsigned int’

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---

diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index f7ffeec..bdfd901 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -1182,7 +1182,7 @@ static void ieee80211_rx_mgmt_assoc_resp(struct net_device *dev,
 	aid = le16_to_cpu(mgmt->u.assoc_resp.aid);
 
 	printk(KERN_DEBUG "%s: RX %sssocResp from %s (capab=0x%x "
-	       "status=%d aid=%d)\n",
+	       "status=%d aid=%ld)\n",
 	       dev->name, reassoc ? "Rea" : "A", print_mac(mac, mgmt->sa),
 	       capab_info, status_code, aid & ~(BIT(15) | BIT(14)));
 
