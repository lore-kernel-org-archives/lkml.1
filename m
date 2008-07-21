Return-Path: <linux-kernel-owner+w=401wt.eu-S1753269AbYGUMNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbYGUMNP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 08:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbYGUMMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 08:12:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:14728 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698AbYGUMMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 08:12:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,223,1215414000"; 
   d="scan'208";a="419942150"
From: Tomas Winkler <tomas.winkler@intel.com>
To: mingo@elte.hu
Cc: davem@davemloft.net, linville@tuxdriver.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>
Subject: [PATCH] iwlwifi: small compile warnings without CONFIG_IWLWIFI_DEBUG
Date: Mon, 21 Jul 2008 15:12:27 +0300
Message-Id: <1216642348-26826-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1216642348-26826-1-git-send-email-tomas.winkler@intel.com>
References: <20080721083654.GA19849@elte.hu>
 <1216642348-26826-1-git-send-email-tomas.winkler@intel.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denis V. Lunev <den@openvz.org>

CC [M]  drivers/net/wireless/iwlwifi/iwl-scan.o
drivers/net/wireless/iwlwifi/iwl-scan.c: In function 'iwl_rx_scan_complete_notif':
drivers/net/wireless/iwlwifi/iwl-scan.c:274: warning: unused variable 'scan_notif'

Signed-off-by: Denis V. Lunev <den@openvz.org>
Acked-by: Tomas Winkler <tomasw@gmail.com>
---
 drivers/net/wireless/iwlwifi/iwl-scan.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 847690b..0033232 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -270,6 +270,7 @@ static void iwl_rx_scan_results_notif(struct iwl_priv *priv,
 static void iwl_rx_scan_complete_notif(struct iwl_priv *priv,
 				       struct iwl_rx_mem_buffer *rxb)
 {
+#ifdef CONFIG_IWLWIFI_DEBUG
 	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
 	struct iwl_scancomplete_notification *scan_notif = (void *)pkt->u.raw;
 
@@ -277,6 +278,7 @@ static void iwl_rx_scan_complete_notif(struct iwl_priv *priv,
 		       scan_notif->scanned_channels,
 		       scan_notif->tsf_low,
 		       scan_notif->tsf_high, scan_notif->status);
+#endif
 
 	/* The HW is no longer scanning */
 	clear_bit(STATUS_SCAN_HW, &priv->status);
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

