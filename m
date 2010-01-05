Return-Path: <linux-kernel-owner+w=401wt.eu-S1754980Ab0AEAqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab0AEAqH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:46:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754946Ab0AEAp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:45:56 -0500
Received: from kroah.org ([198.145.64.141]:34394 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754375Ab0AEAff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:35:35 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Reinette Chatre <reinette.chatre@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 53/97] iwl3945: disable power save
Date: Mon,  4 Jan 2010 16:33:06 -0800
Message-Id: <1262651630-7354-53-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Reinette Chatre <reinette.chatre@intel.com>

commit bc45a67079c916a9bd0a95b0b879cc0f259bac6e upstream.

we see from http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2125
that power saving does not work well on 3945. Since then power saving has
also been connected with association problems where an AP deathenticates a
3945 after it is unable to transmit data to it - this happens when 3945
enters power savings mode.

Disable power save support until issues are resolved.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    2 ++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    8 +++++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index f059b49..9d60f6c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2895,6 +2895,7 @@ static struct iwl_cfg iwl3945_bg_cfg = {
 	.mod_params = &iwl3945_mod_params,
 	.use_isr_legacy = true,
 	.ht_greenfield_support = false,
+	.broken_powersave = true,
 };
 
 static struct iwl_cfg iwl3945_abg_cfg = {
@@ -2909,6 +2910,7 @@ static struct iwl_cfg iwl3945_abg_cfg = {
 	.mod_params = &iwl3945_mod_params,
 	.use_isr_legacy = true,
 	.ht_greenfield_support = false,
+	.broken_powersave = true,
 };
 
 struct pci_device_id iwl3945_hw_card_ids[] = {
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index d00a803..9bf94f0 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3854,9 +3854,11 @@ static int iwl3945_setup_mac(struct iwl_priv *priv)
 	/* Tell mac80211 our characteristics */
 	hw->flags = IEEE80211_HW_SIGNAL_DBM |
 		    IEEE80211_HW_NOISE_DBM |
-		    IEEE80211_HW_SPECTRUM_MGMT |
-		    IEEE80211_HW_SUPPORTS_PS |
-		    IEEE80211_HW_SUPPORTS_DYNAMIC_PS;
+		    IEEE80211_HW_SPECTRUM_MGMT;
+
+	if (!priv->cfg->broken_powersave)
+		hw->flags |= IEEE80211_HW_SUPPORTS_PS |
+			     IEEE80211_HW_SUPPORTS_DYNAMIC_PS;
 
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_STATION) |
-- 
1.6.6

