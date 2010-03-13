Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935695Ab0CMBVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:21:20 -0500
Received: from kroah.org ([198.145.64.141]:60747 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934947Ab0CMAU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:20:26 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:11 2010
Message-Id: <20100313001511.285517122@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:12:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Peter Stuge <peter@stuge.se>,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 070/123] ath9k: re-enable ps by default for new single chip families
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Luis R. Rodriguez <lrodriguez@atheros.com>

commit 14acdde6e527950f66c084dbf19bad6fbfcaeedc upstream.

The newer single chip hardware family of chipsets have not been
experiencing issues with power saving set by default with recent
fixes merged (even into stable). The remaining issues are only
reported with AR5416 and since enabling PS by default can increase
power savings considerably best to take advantage of that feature
as this has been tested properly.

For more details on this issue see the bug report:

http://bugzilla.kernel.org/show_bug.cgi?id=14267

We leave AR5416 with PS disabled by default, that seems to require
some more work.

Cc: Peter Stuge <peter@stuge.se>
Cc: Justin P. Mattock  <justinmattock@gmail.com>
Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/main.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1849,6 +1849,8 @@ bad_free_hw:
 
 void ath_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 {
+	struct ath_hw *ah = sc->sc_ah;
+
 	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
 		IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 		IEEE80211_HW_SIGNAL_DBM |
@@ -1866,7 +1868,8 @@ void ath_set_hw_capab(struct ath_softc *
 		BIT(NL80211_IFTYPE_ADHOC) |
 		BIT(NL80211_IFTYPE_MESH_POINT);
 
-	hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
+	if (AR_SREV_5416(ah))
+		hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
 
 	hw->queues = 4;
 	hw->max_rates = 4;


