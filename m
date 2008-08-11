Return-Path: <linux-kernel-owner+w=401wt.eu-S1754774AbYHKVuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbYHKVuZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 17:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbYHKVuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 17:50:09 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:32794 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbYHKVuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 17:50:07 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Zhu Yi <yi.zhu@intel.com>, Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/1] iwlwifi: fix printk newlines
Date: Mon, 11 Aug 2008 23:49:41 +0200
Message-Id: <1218491381-1313-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add newlines at printk outputs to not break dmesg.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Zhu Yi <yi.zhu@intel.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>
Cc: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c   |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-sta.c      |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    4 ++--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    6 +++---
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 22bb269..4a0cc78 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -967,7 +967,7 @@ static int iwl4965_interpolate_chan(struct iwl_priv *priv, u32 channel,
 
 	s = iwl4965_get_sub_band(priv, channel);
 	if (s >= EEPROM_TX_POWER_BANDS) {
-		IWL_ERROR("Tx Power can not find channel %d ", channel);
+		IWL_ERROR("Tx Power can not find channel %d\n", channel);
 		return -1;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index bce5383..19985bf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -146,7 +146,7 @@ int iwlcore_eeprom_verify_signature(struct iwl_priv *priv)
 {
 	u32 gp = iwl_read32(priv, CSR_EEPROM_GP);
 	if ((gp & CSR_EEPROM_GP_VALID_MSK) == CSR_EEPROM_GP_BAD_SIGNATURE) {
-		IWL_ERROR("EEPROM not found, EEPROM_GP=0x%08x", gp);
+		IWL_ERROR("EEPROM not found, EEPROM_GP=0x%08x\n", gp);
 		return -ENOENT;
 	}
 	return 0;
@@ -227,7 +227,7 @@ int iwl_eeprom_init(struct iwl_priv *priv)
 
 	ret = priv->cfg->ops->lib->eeprom_ops.verify_signature(priv);
 	if (ret < 0) {
-		IWL_ERROR("EEPROM not found, EEPROM_GP=0x%08x", gp);
+		IWL_ERROR("EEPROM not found, EEPROM_GP=0x%08x\n", gp);
 		ret = -ENOENT;
 		goto err;
 	}
@@ -254,7 +254,7 @@ int iwl_eeprom_init(struct iwl_priv *priv)
 		}
 
 		if (!(r & CSR_EEPROM_REG_READ_VALID_MSK)) {
-			IWL_ERROR("Time out reading EEPROM[%d]", addr);
+			IWL_ERROR("Time out reading EEPROM[%d]\n", addr);
 			ret = -ETIMEDOUT;
 			goto done;
 		}
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 60a6e01..6283a3a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -207,7 +207,7 @@ static void iwl_set_ht_add_station(struct iwl_priv *priv, u8 index,
 	case WLAN_HT_CAP_MIMO_PS_DISABLED:
 		break;
 	default:
-		IWL_WARNING("Invalid MIMO PS mode %d", mimo_ps_mode);
+		IWL_WARNING("Invalid MIMO PS mode %d\n", mimo_ps_mode);
 		break;
 	}
 
@@ -969,7 +969,7 @@ int iwl_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr)
 		return priv->hw_params.bcast_sta_id;
 
 	default:
-		IWL_WARNING("Unknown mode of operation: %d", priv->iw_mode);
+		IWL_WARNING("Unknown mode of operation: %d\n", priv->iw_mode);
 		return priv->hw_params.bcast_sta_id;
 	}
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 4108c7c..d82823b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -493,7 +493,7 @@ int iwl_txq_ctx_reset(struct iwl_priv *priv)
 	/* Alloc keep-warm buffer */
 	ret = iwl_kw_alloc(priv);
 	if (ret) {
-		IWL_ERROR("Keep Warm allocation failed");
+		IWL_ERROR("Keep Warm allocation failed\n");
 		goto error_kw;
 	}
 	spin_lock_irqsave(&priv->lock, flags);
@@ -1463,7 +1463,7 @@ void iwl_rx_reply_compressed_ba(struct iwl_priv *priv,
 	u16 ba_resp_scd_ssn = le16_to_cpu(ba_resp->scd_ssn);
 
 	if (scd_flow >= priv->hw_params.max_txq_num) {
-		IWL_ERROR("BUG_ON scd_flow is bigger than number of queues");
+		IWL_ERROR("BUG_ON scd_flow is bigger than number of queues\n");
 		return;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 444847a..348048a 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1558,7 +1558,7 @@ int iwl3945_eeprom_init(struct iwl3945_priv *priv)
 	BUILD_BUG_ON(sizeof(priv->eeprom) != IWL_EEPROM_IMAGE_SIZE);
 
 	if ((gp & CSR_EEPROM_GP_VALID_MSK) == CSR_EEPROM_GP_BAD_SIGNATURE) {
-		IWL_ERROR("EEPROM not found, EEPROM_GP=0x%08x", gp);
+		IWL_ERROR("EEPROM not found, EEPROM_GP=0x%08x\n", gp);
 		return -ENOENT;
 	}
 
@@ -1583,7 +1583,7 @@ int iwl3945_eeprom_init(struct iwl3945_priv *priv)
 		}
 
 		if (!(r & CSR_EEPROM_REG_READ_VALID_MSK)) {
-			IWL_ERROR("Time out reading EEPROM[%d]", addr);
+			IWL_ERROR("Time out reading EEPROM[%d]\n", addr);
 			return -ETIMEDOUT;
 		}
 		e[addr / 2] = le16_to_cpu((__force __le16)(r >> 16));
@@ -2507,7 +2507,7 @@ static int iwl3945_get_sta_id(struct iwl3945_priv *priv, struct ieee80211_hdr *h
 		return priv->hw_setting.bcast_sta_id;
 
 	default:
-		IWL_WARNING("Unknown mode of operation: %d", priv->iw_mode);
+		IWL_WARNING("Unknown mode of operation: %d\n", priv->iw_mode);
 		return priv->hw_setting.bcast_sta_id;
 	}
 }
-- 
1.5.6.5

