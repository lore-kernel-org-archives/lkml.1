Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab0BVFbj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 00:31:39 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:33914 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953Ab0BVFbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 00:31:38 -0500
Date: Mon, 22 Feb 2010 16:31:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Frederic Leroy <fredo@starox.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       Joe Perches <joe@perches.com>
Subject: linux-next: manual merge of the staging tree with the wireless tree
Message-Id: <20100222163134.367353e7.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/rtl8192su/ieee80211/ieee80211_rx.c between commit
e2117cea27c6b27e1a379acac5eb0433eeb7033a ("staging: rtl8192su: fix
compile error from wireless-testing commit") from the wireless tree and
commit 7332868b1aea2a5900a70acadf767f7632b1c2c2 ("Staging: rtl8187x: Use %
pM for mac address output") from the staging tree.

Just context changes.  I fixed it up (see below) and can carry the fix
as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/rtl8192su/ieee80211/ieee80211_rx.c
index 095b8c6,67b99ad..0000000
--- a/drivers/staging/rtl8192su/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8192su/ieee80211/ieee80211_rx.c
@@@ -2366,11 -2366,11 +2366,11 @@@ static inline void ieee80211_process_pr
  		(beacon->capability & (1<<0x0)) ? '1' : '0');
  
  	if (ieee80211_network_init(ieee, beacon, &network, stats)) {
- 		IEEE80211_DEBUG_SCAN("Dropped '%s' (" MAC_FMT ") via %s.\n",
+ 		IEEE80211_DEBUG_SCAN("Dropped '%s' (%pM) via %s.\n",
  				     escape_essid(info_element->data,
  						  info_element->len),
- 				     MAC_ARG(beacon->header.addr3),
+ 				     beacon->header.addr3,
 -				     WLAN_FC_GET_STYPE(beacon->header.frame_ctl) ==
 +				     WLAN_FC_GET_STYPE(beacon->header.frame_control) ==
  				     IEEE80211_STYPE_PROBE_RESP ?
  				     "PROBE RESPONSE" : "BEACON");
  		return;
@@@ -2492,11 -2492,11 +2492,11 @@@
  
  
  #ifdef CONFIG_IEEE80211_DEBUG
- 		IEEE80211_DEBUG_SCAN("Adding '%s' (" MAC_FMT ") via %s.\n",
+ 		IEEE80211_DEBUG_SCAN("Adding '%s' (%pM) via %s.\n",
  				     escape_essid(network.ssid,
  						  network.ssid_len),
- 				     MAC_ARG(network.bssid),
+ 				     network.bssid,
 -				     WLAN_FC_GET_STYPE(beacon->header.frame_ctl) ==
 +				     WLAN_FC_GET_STYPE(beacon->header.frame_control) ==
  				     IEEE80211_STYPE_PROBE_RESP ?
  				     "PROBE RESPONSE" : "BEACON");
  #endif
@@@ -2505,11 -2505,11 +2505,11 @@@
  		if(ieee->softmac_features & IEEE_SOFTMAC_ASSOCIATE)
  			ieee80211_softmac_new_net(ieee,&network);
  	} else {
- 		IEEE80211_DEBUG_SCAN("Updating '%s' (" MAC_FMT ") via %s.\n",
+ 		IEEE80211_DEBUG_SCAN("Updating '%s' (%pM) via %s.\n",
  				     escape_essid(target->ssid,
  						  target->ssid_len),
- 				     MAC_ARG(target->bssid),
+ 				     target->bssid,
 -				     WLAN_FC_GET_STYPE(beacon->header.frame_ctl) ==
 +				     WLAN_FC_GET_STYPE(beacon->header.frame_control) ==
  				     IEEE80211_STYPE_PROBE_RESP ?
  				     "PROBE RESPONSE" : "BEACON");
  
