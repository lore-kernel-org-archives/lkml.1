Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab0BSRD3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:03:29 -0500
Received: from kroah.org ([198.145.64.141]:57858 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755104Ab0BSRBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:01:18 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:56 2010
Message-Id: <20100219163256.183228759@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:30:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Wey-Yi Guy <wey-yi.w.guy@intel.com>,
       Reinette Chatre <reinette.chatre@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [90/93] iwlwifi: Fix to set correct ht configuration
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

commit 098dfded5b1b09927995e89c6d689f85a0f53384 upstream.

iwl_set_rxon_ht() only get called in iwl_post_associate(); which cause
possible incorrect ht configuration. Adding the call in iwl_mac_config() if
IEEE80211_CONF_CHANGE_CHANNEL flag is set to re-configure and send rxon
command.

Fixes
http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2146

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2645,6 +2645,7 @@ int iwl_mac_config(struct ieee80211_hw *
 		if ((le16_to_cpu(priv->staging_rxon.channel) != ch))
 			priv->staging_rxon.flags = 0;
 
+		iwl_set_rxon_ht(priv, ht_conf);
 		iwl_set_rxon_channel(priv, conf->channel);
 
 		iwl_set_flags_for_band(priv, conf->channel->band);


