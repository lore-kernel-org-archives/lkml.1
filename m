Return-Path: <linux-kernel-owner+w=401wt.eu-S1762339AbYAZQNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762339AbYAZQNA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 11:13:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760336AbYAZQKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 11:10:03 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:63824 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761540AbYAZQKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 11:10:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=vfB5e4B2sMzAki8oN2dg6JCsuNPvHnoB+Z72I8Ank/N73RdEyEYU0HPhOPTZmVj6F96iwOETK+ca1mmAv/Aiuarbi9exyLK/DikIx760xRNEIcaDiOUHR9yvl9dy886UbYTPOFfHvbUGFHIrCB88+pNY4T7yfPY1wF5BaRbw9wA=
Date: Sat, 26 Jan 2008 19:09:36 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Thomas Tuttle <linux-kernel@ttuttle.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Wu <flamingice@sourmilk.net>,
       LWML <linux-wireless@vger.kernel.org>
Subject: [PATCH] wireless: iwlwifi3945/4965 - fix incorrect counting of
	memory
Message-ID: <20080126160936.GB6738@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does fix incorrect counting of memory allocated by kmalloc.
It seems that could lead to allocated memory overrun and corrupt
nearlaid memory area.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>

---

 iwl3945-base.c |    2 +-
 iwl4965-base.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.git/drivers/net/wireless/iwlwifi/iwl3945-base.c
===================================================================
--- linux-2.6.git.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-01-24 18:26:11.000000000 +0300
+++ linux-2.6.git/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-01-26 18:45:03.000000000 +0300
@@ -6631,7 +6631,7 @@ static void iwl_bg_request_scan(struct w
 	 * that based on the direct_mask added to each channel entry */
 	scan->tx_cmd.len = cpu_to_le16(
 		iwl_fill_probe_req(priv, (struct ieee80211_mgmt *)scan->data,
-			IWL_MAX_SCAN_SIZE - sizeof(scan), 0));
+			IWL_MAX_SCAN_SIZE - sizeof(*scan), 0));
 	scan->tx_cmd.tx_flags = TX_CMD_FLG_SEQ_CTL_MSK;
 	scan->tx_cmd.sta_id = priv->hw_setting.bcast_sta_id;
 	scan->tx_cmd.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;

Index: linux-2.6.git/drivers/net/wireless/iwlwifi/iwl4965-base.c
===================================================================
--- linux-2.6.git.orig/drivers/net/wireless/iwlwifi/iwl4965-base.c	2008-01-26 18:45:38.000000000 +0300
+++ linux-2.6.git/drivers/net/wireless/iwlwifi/iwl4965-base.c	2008-01-26 18:46:06.000000000 +0300
@@ -6992,7 +6992,7 @@ static void iwl_bg_request_scan(struct w
 	 * that based on the direct_mask added to each channel entry */
 	scan->tx_cmd.len = cpu_to_le16(
 		iwl_fill_probe_req(priv, (struct ieee80211_mgmt *)scan->data,
-			IWL_MAX_SCAN_SIZE - sizeof(scan), 0));
+			IWL_MAX_SCAN_SIZE - sizeof(*scan), 0));
 	scan->tx_cmd.tx_flags = TX_CMD_FLG_SEQ_CTL_MSK;
 	scan->tx_cmd.sta_id = priv->hw_setting.bcast_sta_id;
 	scan->tx_cmd.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
