Return-Path: <linux-kernel-owner+w=401wt.eu-S1753164AbYJ2GSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbYJ2GSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 02:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbYJ2GS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 02:18:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:20926 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588AbYJ2GS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 02:18:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,505,1220252400"; 
   d="scan'208";a="353444546"
Subject: Re: [2.6.28-rc2]: iwl4965 doesn't connect / cfg80211 failure
From: Zhu Yi <yi.zhu@intel.com>
To: Mirco Tischler <mt-ml@gmx.de>
Cc: Arjan van de Ven <arjan@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "John W.Linville" <linville@tuxdriver.com>,
       "Chatre, Reinette" <reinette.chatre@intel.com>,
       Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <20081028172418.3c8e91f1@mtlp.12.dimension>
References: <20081028020212.0dfcb6c9@mtlp.12.dimension>
	 <1225157618.2917.215.camel@debian.sh.intel.com>
	 <20081027213217.53558319@infradead.org>
	 <1225171414.2917.229.camel@debian.sh.intel.com>
	 <20081028172418.3c8e91f1@mtlp.12.dimension>
Content-Type: multipart/mixed; boundary="=-blndQUlLRpFDXlDE6HV9"
Organization: Intel Corp.
Date: Wed, 29 Oct 2008 14:18:04 +0800
Message-Id: <1225261084.2917.254.camel@debian.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-blndQUlLRpFDXlDE6HV9
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, 2008-10-29 at 00:24 +0800, Mirco Tischler wrote:
> 
> I tested it quickly and not very thoroughly on the wpa-eap encrypted
> network at
> university and it showed the same behaviour: no connection without
> CONFIG_WIRELESS_OLD_REGULATORY and no problems with it enabled.

Interesting. The only difference between without and with
CONFIG_WIRELESS_OLD_REGULATORY is the txpower is lower and you can only
do passive scan. Can you try attached patch?

Thanks,
-yi

--=-blndQUlLRpFDXlDE6HV9
Content-Disposition: attachment; filename=iwlwifi-oldreg-debug.patch
Content-Type: text/x-patch; name=iwlwifi-oldreg-debug.patch; charset=GB2312
Content-Transfer-Encoding: 7bit

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 0953a9c..8123156 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1523,6 +1523,7 @@ static int iwl4965_send_tx_power(struct iwl_priv *priv)
 		 * the stack trace to find out who is calling this during
 		 * a scan. */
 		IWL_WARNING("TX Power requested while scanning!\n");
+		dump_stack();
 		return -EAGAIN;
 	}
 
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 5dab72d..7ffa736 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -71,9 +71,7 @@ static const struct ieee80211_regdomain world_regdom = {
 	.n_reg_rules = 1,
 	.alpha2 =  "00",
 	.reg_rules = {
-		REG_RULE(2412-10, 2462+10, 40, 6, 20,
-			NL80211_RRF_PASSIVE_SCAN |
-			NL80211_RRF_NO_IBSS),
+		REG_RULE(2412-10, 2462+10, 40, 6, 27, 0),
 	}
 };
 

--=-blndQUlLRpFDXlDE6HV9--

