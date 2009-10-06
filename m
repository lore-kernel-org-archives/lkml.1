Return-Path: <linux-kernel-owner+w=401wt.eu-S933220AbZJFUgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933220AbZJFUgB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 16:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932797AbZJFUgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 16:36:01 -0400
Received: from xenotime.net ([72.52.64.118]:59096 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756546AbZJFUgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 16:36:00 -0400
Date: Tue, 6 Oct 2009 13:27:29 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linville@tuxdriver.com
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org
Subject: [PATCH -next] wireless: fix CFG80211_WEXT build problems
Message-Id: <20091006132729.8b4f9345.rdunlap@xenotime.net>
In-Reply-To: <20091006165220.b5cb1c44.sfr@canb.auug.org.au>
References: <20091006165220.b5cb1c44.sfr@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix CFG80211_WEXT build dependencies/errors:

ERROR: "cfg80211_wext_siwscan" [drivers/net/wireless/orinoco/orinoco.ko] undefined!
ERROR: "cfg80211_wext_siwmode" [drivers/net/wireless/orinoco/orinoco.ko] undefined!
ERROR: "cfg80211_wext_giwrange" [drivers/net/wireless/orinoco/orinoco.ko] undefined!
ERROR: "cfg80211_wext_giwmode" [drivers/net/wireless/orinoco/orinoco.ko] undefined!
ERROR: "cfg80211_wext_giwname" [drivers/net/wireless/orinoco/orinoco.ko] undefined!
ERROR: "cfg80211_wext_giwscan" [drivers/net/wireless/orinoco/orinoco.ko] undefined!
ERROR: "cfg80211_wext_giwname" [drivers/net/wireless/ipw2x00/ipw2200.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/net/wireless/ipw2x00/Kconfig |    2 +-
 drivers/net/wireless/orinoco/Kconfig |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20091006.orig/drivers/net/wireless/ipw2x00/Kconfig
+++ linux-next-20091006/drivers/net/wireless/ipw2x00/Kconfig
@@ -65,7 +65,7 @@ config IPW2100_DEBUG
 
 config IPW2200
 	tristate "Intel PRO/Wireless 2200BG and 2915ABG Network Connection"
-	depends on PCI && WLAN_80211 && CFG80211
+	depends on PCI && WLAN_80211 && CFG80211 && CFG80211_WEXT
 	select WIRELESS_EXT
 	select WEXT_SPY
 	select WEXT_PRIV
--- linux-next-20091006.orig/drivers/net/wireless/orinoco/Kconfig
+++ linux-next-20091006/drivers/net/wireless/orinoco/Kconfig
@@ -1,7 +1,7 @@
 config HERMES
 	tristate "Hermes chipset 802.11b support (Orinoco/Prism2/Symbol)"
 	depends on (PPC_PMAC || PCI || PCMCIA) && WLAN_80211
-	depends on CFG80211
+	depends on CFG80211 && CFG80211_WEXT
 	select WIRELESS_EXT
 	select WEXT_SPY
 	select WEXT_PRIV
