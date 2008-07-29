Return-Path: <linux-kernel-owner+w=401wt.eu-S1757126AbYG2GCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126AbYG2GCc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 02:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754368AbYG2GBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 02:01:52 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:5661 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047AbYG2GBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 02:01:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=lq/DJcZKIpLBKTQ1mSZByMTR3BK4NZCtfp2nSZDMhKLOYtB6SDQbqrUCQ58oi9PbLA
         IJekKkO8QemgKhk5Vs5zq9v5wG+o9ZOrY/LQwwNMonnPXTaSRP+WCPQH2jSizKO07qHj
         8Qq0bdqGAesxbmpT9hafHgmc0U868US51UvXI=
Subject: [PATCH 3/8] wireless: replace __FUNCTION__ with __func__
From: Harvey Harrison <harvey.harrison@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 28 Jul 2008 23:01:34 -0700
Message-Id: <1217311294.23389.26.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/net/wireless/airo.c                   |   16 ++++++++--------
 drivers/net/wireless/hermes.c                 |    2 +-
 drivers/net/wireless/ipw2100.c                |    2 +-
 drivers/net/wireless/ipw2200.h                |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-3945-debug.h |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-debug.h      |    4 ++--
 drivers/net/wireless/iwlwifi/iwl3945-base.c   |    4 ++--
 drivers/net/wireless/iwlwifi/iwl4965-base.c   |    4 ++--
 drivers/net/wireless/libertas/if_cs.c         |    2 +-
 drivers/net/wireless/prism54/isl_ioctl.c      |    8 ++++----
 drivers/net/wireless/rt2x00/rt2x00.h          |    4 ++--
 drivers/net/wireless/wl3501_cs.c              |    8 ++++----
 12 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index b5cd850..ae58a12 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -1915,7 +1915,7 @@ static int mpi_start_xmit(struct sk_buff *skb, struct net_device *dev) {
 	struct airo_info *ai = dev->priv;
 
 	if (!skb) {
-		airo_print_err(dev->name, "%s: skb == NULL!",__FUNCTION__);
+		airo_print_err(dev->name, "%s: skb == NULL!",__func__);
 		return 0;
 	}
 	npacks = skb_queue_len (&ai->txq);
@@ -1964,7 +1964,7 @@ static int mpi_send_packet (struct net_device *dev)
 	if ((skb = skb_dequeue(&ai->txq)) == NULL) {
 		airo_print_err(dev->name,
 			"%s: Dequeue'd zero in send_packet()",
-			__FUNCTION__);
+			__func__);
 		return 0;
 	}
 
@@ -2115,7 +2115,7 @@ static int airo_start_xmit(struct sk_buff *skb, struct net_device *dev) {
 	u32 *fids = priv->fids;
 
 	if ( skb == NULL ) {
-		airo_print_err(dev->name, "%s: skb == NULL!", __FUNCTION__);
+		airo_print_err(dev->name, "%s: skb == NULL!", __func__);
 		return 0;
 	}
 
@@ -2186,7 +2186,7 @@ static int airo_start_xmit11(struct sk_buff *skb, struct net_device *dev) {
 	}
 
 	if ( skb == NULL ) {
-		airo_print_err(dev->name, "%s: skb == NULL!", __FUNCTION__);
+		airo_print_err(dev->name, "%s: skb == NULL!", __func__);
 		return 0;
 	}
 
@@ -4127,7 +4127,7 @@ static int PC4500_writerid(struct airo_info *ai, u16 rid,
 		if (test_bit(FLAG_ENABLED, &ai->flags) && (RID_WEP_TEMP != rid))
 			airo_print_err(ai->dev->name,
 				"%s: MAC should be disabled (rid=%04x)",
-				__FUNCTION__, rid);
+				__func__, rid);
 		memset(&cmd, 0, sizeof(cmd));
 		memset(&rsp, 0, sizeof(rsp));
 
@@ -4142,7 +4142,7 @@ static int PC4500_writerid(struct airo_info *ai, u16 rid,
 			&ai->config_desc.rid_desc, sizeof(Rid));
 
 		if (len < 4 || len > 2047) {
-			airo_print_err(ai->dev->name, "%s: len=%d", __FUNCTION__, len);
+			airo_print_err(ai->dev->name, "%s: len=%d", __func__, len);
 			rc = -1;
 		} else {
 			memcpy((char *)ai->config_desc.virtual_host_addr,
@@ -4151,9 +4151,9 @@ static int PC4500_writerid(struct airo_info *ai, u16 rid,
 			rc = issuecommand(ai, &cmd, &rsp);
 			if ((rc & 0xff00) != 0) {
 				airo_print_err(ai->dev->name, "%s: Write rid Error %d",
-						__FUNCTION__, rc);
+						__func__, rc);
 				airo_print_err(ai->dev->name, "%s: Cmd=%04x",
-						__FUNCTION__, cmd.cmd);
+						__func__, cmd.cmd);
 			}
 
 			if ((rsp.status & 0x7f00))
diff --git a/drivers/net/wireless/hermes.c b/drivers/net/wireless/hermes.c
index 29d3910..2cd86af 100644
--- a/drivers/net/wireless/hermes.c
+++ b/drivers/net/wireless/hermes.c
@@ -463,7 +463,7 @@ int hermes_read_ltv(hermes_t *hw, int bap, u16 rid, unsigned bufsize,
 	if (rtype != rid)
 		printk(KERN_WARNING "hermes @ %p: %s(): "
 		       "rid (0x%04x) does not match type (0x%04x)\n",
-		       hw->iobase, __FUNCTION__, rid, rtype);
+		       hw->iobase, __func__, rid, rtype);
 	if (HERMES_RECLEN_TO_BYTES(rlength) > bufsize)
 		printk(KERN_WARNING "hermes @ %p: "
 		       "Truncating LTV record from %d to %d bytes. "
diff --git a/drivers/net/wireless/ipw2100.c b/drivers/net/wireless/ipw2100.c
index 5bf9e00..c71bb09 100644
--- a/drivers/net/wireless/ipw2100.c
+++ b/drivers/net/wireless/ipw2100.c
@@ -212,7 +212,7 @@ static u32 ipw2100_debug_level = IPW_DL_NONE;
 do { \
 	if (ipw2100_debug_level & (level)) { \
 		printk(KERN_DEBUG "ipw2100: %c %s ", \
-                       in_interrupt() ? 'I' : 'U',  __FUNCTION__); \
+                       in_interrupt() ? 'I' : 'U',  __func__); \
 		printk(message); \
 	} \
 } while (0)
diff --git a/drivers/net/wireless/ipw2200.h b/drivers/net/wireless/ipw2200.h
index d4ab28b..0bad1ec 100644
--- a/drivers/net/wireless/ipw2200.h
+++ b/drivers/net/wireless/ipw2200.h
@@ -1394,13 +1394,13 @@ BIT_ARG16(x)
 #define IPW_DEBUG(level, fmt, args...) \
 do { if (ipw_debug_level & (level)) \
   printk(KERN_DEBUG DRV_NAME": %c %s " fmt, \
-         in_interrupt() ? 'I' : 'U', __FUNCTION__ , ## args); } while (0)
+         in_interrupt() ? 'I' : 'U', __func__ , ## args); } while (0)
 
 #ifdef CONFIG_IPW2200_DEBUG
 #define IPW_LL_DEBUG(level, fmt, args...) \
 do { if (ipw_debug_level & (level)) \
   printk(KERN_DEBUG DRV_NAME": %c %s " fmt, \
-         in_interrupt() ? 'I' : 'U', __FUNCTION__ , ## args); } while (0)
+         in_interrupt() ? 'I' : 'U', __func__ , ## args); } while (0)
 #else
 #define IPW_LL_DEBUG(level, fmt, args...) do {} while (0)
 #endif				/* CONFIG_IPW2200_DEBUG */
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-debug.h b/drivers/net/wireless/iwlwifi/iwl-3945-debug.h
index f1d002f..33016fb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-debug.h
@@ -34,12 +34,12 @@ extern u32 iwl3945_debug_level;
 #define IWL_DEBUG(level, fmt, args...) \
 do { if (iwl3945_debug_level & (level)) \
   printk(KERN_ERR DRV_NAME": %c %s " fmt, \
-	 in_interrupt() ? 'I' : 'U', __FUNCTION__ , ## args); } while (0)
+	 in_interrupt() ? 'I' : 'U', __func__ , ## args); } while (0)
 
 #define IWL_DEBUG_LIMIT(level, fmt, args...) \
 do { if ((iwl3945_debug_level & (level)) && net_ratelimit()) \
   printk(KERN_ERR DRV_NAME": %c %s " fmt, \
-	 in_interrupt() ? 'I' : 'U', __FUNCTION__ , ## args); } while (0)
+	 in_interrupt() ? 'I' : 'U', __func__ , ## args); } while (0)
 
 static inline void iwl3945_print_hex_dump(int level, void *p, u32 len)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 5838480..097a72f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -33,12 +33,12 @@
 #define IWL_DEBUG(level, fmt, args...) \
 do { if (priv->debug_level & (level)) \
   dev_printk(KERN_ERR, &(priv->hw->wiphy->dev), "%c %s " fmt, \
-	 in_interrupt() ? 'I' : 'U', __FUNCTION__ , ## args); } while (0)
+	 in_interrupt() ? 'I' : 'U', __func__ , ## args); } while (0)
 
 #define IWL_DEBUG_LIMIT(level, fmt, args...) \
 do { if ((priv->debug_level & (level)) && net_ratelimit()) \
   dev_printk(KERN_ERR, &(priv->hw->wiphy->dev), "%c %s " fmt, \
-	 in_interrupt() ? 'I' : 'U', __FUNCTION__ , ## args); } while (0)
+	 in_interrupt() ? 'I' : 'U', __func__ , ## args); } while (0)
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 struct iwl_debugfs {
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 4a22d3f..64d2f71 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -6336,7 +6336,7 @@ static void iwl3945_bg_post_associate(struct work_struct *data)
 	DECLARE_MAC_BUF(mac);
 
 	if (priv->iw_mode == IEEE80211_IF_TYPE_AP) {
-		IWL_ERROR("%s Should not be called in AP mode\n", __FUNCTION__);
+		IWL_ERROR("%s Should not be called in AP mode\n", __func__);
 		return;
 	}
 
@@ -6417,7 +6417,7 @@ static void iwl3945_bg_post_associate(struct work_struct *data)
 
 	default:
 		 IWL_ERROR("%s Should not be called in %d mode\n",
-			   __FUNCTION__, priv->iw_mode);
+			   __func__, priv->iw_mode);
 		break;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 71f5da3..04e8795 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2415,7 +2415,7 @@ static void iwl4965_post_associate(struct iwl_priv *priv)
 	unsigned long flags;
 
 	if (priv->iw_mode == IEEE80211_IF_TYPE_AP) {
-		IWL_ERROR("%s Should not be called in AP mode\n", __FUNCTION__);
+		IWL_ERROR("%s Should not be called in AP mode\n", __func__);
 		return;
 	}
 
@@ -2491,7 +2491,7 @@ static void iwl4965_post_associate(struct iwl_priv *priv)
 
 	default:
 		IWL_ERROR("%s Should not be called in %d mode\n",
-				__FUNCTION__, priv->iw_mode);
+				__func__, priv->iw_mode);
 		break;
 	}
 
diff --git a/drivers/net/wireless/libertas/if_cs.c b/drivers/net/wireless/libertas/if_cs.c
index 04d7a25..92837a2 100644
--- a/drivers/net/wireless/libertas/if_cs.c
+++ b/drivers/net/wireless/libertas/if_cs.c
@@ -720,7 +720,7 @@ static int if_cs_host_to_card(struct lbs_private *priv,
 		ret = if_cs_send_cmd(priv, buf, nb);
 		break;
 	default:
-		lbs_pr_err("%s: unsupported type %d\n", __FUNCTION__, type);
+		lbs_pr_err("%s: unsupported type %d\n", __func__, type);
 	}
 
 	lbs_deb_leave_args(LBS_DEB_CS, "ret %d", ret);
diff --git a/drivers/net/wireless/prism54/isl_ioctl.c b/drivers/net/wireless/prism54/isl_ioctl.c
index 97fa14e..0a639a9 100644
--- a/drivers/net/wireless/prism54/isl_ioctl.c
+++ b/drivers/net/wireless/prism54/isl_ioctl.c
@@ -71,7 +71,7 @@ prism54_mib_mode_helper(islpci_private *priv, u32 iw_mode)
 	if (iw_mode == IW_MODE_REPEAT || iw_mode == IW_MODE_SECOND) {
 		printk(KERN_DEBUG
 		       "%s(): Sorry, Repeater mode and Secondary mode "
-		       "are not yet supported by this driver.\n", __FUNCTION__);
+		       "are not yet supported by this driver.\n", __func__);
 		return -EINVAL;
 	}
 
@@ -333,7 +333,7 @@ prism54_set_mode(struct net_device *ndev, struct iw_request_info *info,
 	if (*uwrq > IW_MODE_MONITOR || *uwrq < IW_MODE_AUTO) {
 		printk(KERN_DEBUG
 		       "%s: %s() You passed a non-valid init_mode.\n",
-		       priv->ndev->name, __FUNCTION__);
+		       priv->ndev->name, __func__);
 		return -EINVAL;
 	}
 
@@ -1234,7 +1234,7 @@ prism54_set_txpower(struct net_device *ndev, struct iw_request_info *info,
 		/* don't know how to disable radio */
 		printk(KERN_DEBUG
 		       "%s: %s() disabling radio is not yet supported.\n",
-		       priv->ndev->name, __FUNCTION__);
+		       priv->ndev->name, __func__);
 		return -ENOTSUPP;
 	} else if (vwrq->fixed)
 		/* currently only fixed value is supported */
@@ -1242,7 +1242,7 @@ prism54_set_txpower(struct net_device *ndev, struct iw_request_info *info,
 	else {
 		printk(KERN_DEBUG
 		       "%s: %s() auto power will be implemented later.\n",
-		       priv->ndev->name, __FUNCTION__);
+		       priv->ndev->name, __func__);
 		return -ENOTSUPP;
 	}
 }
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 07b03b3..c0edc72 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -53,11 +53,11 @@
  */
 #define DEBUG_PRINTK_MSG(__dev, __kernlvl, __lvl, __msg, __args...)	\
 	printk(__kernlvl "%s -> %s: %s - " __msg,			\
-	       wiphy_name((__dev)->hw->wiphy), __FUNCTION__, __lvl, ##__args)
+	       wiphy_name((__dev)->hw->wiphy), __func__, __lvl, ##__args)
 
 #define DEBUG_PRINTK_PROBE(__kernlvl, __lvl, __msg, __args...)	\
 	printk(__kernlvl "%s -> %s: %s - " __msg,		\
-	       KBUILD_MODNAME, __FUNCTION__, __lvl, ##__args)
+	       KBUILD_MODNAME, __func__, __lvl, ##__args)
 
 #ifdef CONFIG_RT2X00_DEBUG
 #define DEBUG_PRINTK(__dev, __kernlvl, __lvl, __msg, __args...)	\
diff --git a/drivers/net/wireless/wl3501_cs.c b/drivers/net/wireless/wl3501_cs.c
index 3771419..b6d4e04 100644
--- a/drivers/net/wireless/wl3501_cs.c
+++ b/drivers/net/wireless/wl3501_cs.c
@@ -79,7 +79,7 @@ static int pc_debug = PCMCIA_DEBUG;
 module_param(pc_debug, int, 0);
 #define dprintk(n, format, args...) \
 	{ if (pc_debug > (n)) \
-		printk(KERN_INFO "%s: " format "\n", __FUNCTION__ , ##args); }
+		printk(KERN_INFO "%s: " format "\n", __func__ , ##args); }
 #else
 #define dprintk(n, format, args...)
 #endif
@@ -470,7 +470,7 @@ static int wl3501_pwr_mgmt(struct wl3501_card *this, int suspend)
 			spin_unlock_irqrestore(&this->lock, flags);
 			rc = wait_event_interruptible(this->wait,
 				this->sig_pwr_mgmt_confirm.status != 255);
-			printk(KERN_INFO "%s: %s status=%d\n", __FUNCTION__,
+			printk(KERN_INFO "%s: %s status=%d\n", __func__,
 			       suspend ? "suspend" : "resume",
 			       this->sig_pwr_mgmt_confirm.status);
 			goto out;
@@ -1199,7 +1199,7 @@ static int wl3501_reset_board(struct wl3501_card *this)
 		}
 		WL3501_NOPLOOP(10);
 	}
-	printk(KERN_WARNING "%s: failed to reset the board!\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: failed to reset the board!\n", __func__);
 	rc = -ENODEV;
 out:
 	return rc;
@@ -1250,7 +1250,7 @@ static int wl3501_init_firmware(struct wl3501_card *this)
 out:
 	return rc;
 fail:
-	printk(KERN_WARNING "%s: failed!\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: failed!\n", __func__);
 	goto out;
 }
 
-- 
1.6.0.rc1.154.ge3fc


