Return-Path: <linux-kernel-owner+w=401wt.eu-S1757812AbZLODpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757812AbZLODpN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 22:45:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754582AbZLODpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 22:45:10 -0500
Received: from adelie.canonical.com ([91.189.90.139]:47356 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180AbZLODpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 22:45:08 -0500
From: Ike Panhc <ike.pan@canonical.com>
To: kernel-team@lists.ubuntu.com
Cc: stable@kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
       Tomas Winkler <tomas.winkler@intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] iwlwifi: change IWL6000_UCODE_API_MAX to v4
Date: Tue, 15 Dec 2009 11:44:59 +0800
Message-Id: <1260848699-5616-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1260848655-5582-1-git-send-email-ike.pan@canonical.com>
References: <1260848655-5582-1-git-send-email-ike.pan@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

uCode version changed to v4 for 6000 series

The additional parameter added to v4 is providing current tx power for
each chain in tx statistics portion of "statistics notification"
command.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
(cherry picked from commit fcbaf8b06da385c73cb6218f079e9ddba9ee9f7c)

CC: stable@kernel.org
Signed-off-by: Ike Panhc <ike.pan@canonical.com>

BugLink: http://bugs.launchpad.net/bugs/496496

---
 drivers/net/wireless/iwlwifi/iwl-6000.c     |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-commands.h |   18 ++++++++++++++++--
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index e4a405f..45a3b57 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -46,8 +46,8 @@
 #include "iwl-5000-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL6000_UCODE_API_MAX 3
-#define IWL6050_UCODE_API_MAX 3
+#define IWL6000_UCODE_API_MAX 4
+#define IWL6050_UCODE_API_MAX 4
 
 /* Lowest firmware API version supported */
 #define IWL6000_UCODE_API_MIN 1
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index c87033b..69a97c7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2913,6 +2913,20 @@ struct statistics_rx {
 	struct statistics_rx_ht_phy ofdm_ht;
 } __attribute__ ((packed));
 
+/**
+ * struct statistics_tx_power - current tx power
+ *
+ * @ant_a: current tx power on chain a in 1/2 dB step
+ * @ant_b: current tx power on chain b in 1/2 dB step
+ * @ant_c: current tx power on chain c in 1/2 dB step
+ */
+struct statistics_tx_power {
+	u8 ant_a;
+	u8 ant_b;
+	u8 ant_c;
+	u8 reserved;
+} __attribute__ ((packed));
+
 struct statistics_tx_non_phy_agg {
 	__le32 ba_timeout;
 	__le32 ba_reschedule_frames;
@@ -2924,8 +2938,6 @@ struct statistics_tx_non_phy_agg {
 	__le32 underrun;
 	__le32 bt_prio_kill;
 	__le32 rx_ba_rsp_cnt;
-	__le32 reserved2;
-	__le32 reserved3;
 } __attribute__ ((packed));
 
 struct statistics_tx {
@@ -2944,6 +2956,8 @@ struct statistics_tx {
 	__le32 cts_timeout_collision;
 	__le32 ack_or_ba_timeout_collision;
 	struct statistics_tx_non_phy_agg agg;
+	struct statistics_tx_power tx_power;
+	__le32 reserved1;
 } __attribute__ ((packed));
 
 
-- 
1.6.3.3

