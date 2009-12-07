Return-Path: <linux-kernel-owner+w=401wt.eu-S935603AbZLGWUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935603AbZLGWUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 17:20:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934088AbZLGWUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 17:20:53 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:43650 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932821AbZLGWUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 17:20:52 -0500
Date: Tue, 8 Dec 2009 09:20:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "David S. Miller" <davem@davemloft.net>,
       "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: net/wireless/wireless-current tree build warning
Message-Id: <20091208092057.dd2eeaeb.sfr@canb.auug.org.au>
In-Reply-To: <1260191754.3737.1.camel@johannes.local>
References: <20091201133524.32756cef.sfr@canb.auug.org.au>
	<1260191754.3737.1.camel@johannes.local>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave, John,

On Mon, 07 Dec 2009 14:15:54 +0100 Johannes Berg <johannes@sipsolutions.net> wrote:
>
> > drivers/net/wireless/iwlwifi/iwl-tx.c: In function 'iwl_tx_agg_stop':
> > drivers/net/wireless/iwlwifi/iwl-tx.c:1356: warning: passing argument 1 of 'ieee80211_stop_tx_ba_cb_irqsafe' from incompatible pointer type
> > include/net/mac80211.h:2128: note: expected 'struct ieee80211_vif *' but argument is of type 'struct ieee80211_hw *'
> 
> This has now snuck into wireless-testing as well.

Johannes is right, the patch I posted need to be part of the wireless
tree once the wireless-current tree was merged into it.  Now this patch
(reposted below) is needed in the wireless and net trees ...

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 1 Dec 2009 13:19:44 +1100
Subject: [PATCH] wireless: fix for mismerge

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/wireless/iwlwifi/iwl-tx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 58b132f..00da5e1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -1353,7 +1353,7 @@ int iwl_tx_agg_stop(struct iwl_priv *priv , const u8 *ra, u16 tid)
 	if (priv->stations[sta_id].tid[tid].agg.state ==
 				IWL_EMPTYING_HW_QUEUE_ADDBA) {
 		IWL_DEBUG_HT(priv, "AGG stop before setup done\n");
-		ieee80211_stop_tx_ba_cb_irqsafe(priv->hw, ra, tid);
+		ieee80211_stop_tx_ba_cb_irqsafe(priv->vif, ra, tid);
 		priv->stations[sta_id].tid[tid].agg.state = IWL_AGG_OFF;
 		return 0;
 	}
-- 
1.6.5.3


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
