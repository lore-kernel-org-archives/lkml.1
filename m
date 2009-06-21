Return-Path: <linux-kernel-owner+w=401wt.eu-S1754857AbZFUQxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbZFUQxb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 12:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbZFUQww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 12:52:52 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:38660 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbZFUQwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 12:52:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SXggzBA42UDqoLdM5I8uQ9YvATQDDLysQ3E7tWP0iTdnBaHsBkk8NUIukRxrXQcW46
         WaZ9rglvdFJcfBkI4MldUVpBpSOveRp050ZKwXSZBF9t0VTaXKVwSmCTNGu5NbNaadjU
         BZHUnewWzavGLE3XCaDeZ+zCkWlcskPLlZA5U=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH 3/3] Staging: rtl8187se: remove dependency on WIRELESS_EXT version
Date: Sun, 21 Jun 2009 20:52:41 +0400
Message-Id: <1245603161-2900-3-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245603161-2900-2-git-send-email-a.beregalov@gmail.com>
References: <1245603161-2900-1-git-send-email-a.beregalov@gmail.com>
 <1245603161-2900-2-git-send-email-a.beregalov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the driver is in mainline now we can remove such dependencies.
WIRELESS_EXT is 22 now.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/staging/rtl8187se/ieee80211.h              |    9 -------
 drivers/staging/rtl8187se/ieee80211/ieee80211.h    |    9 -------
 .../rtl8187se/ieee80211/ieee80211_crypt_tkip.c     |   24 --------------------
 drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c |    4 ---
 drivers/staging/rtl8187se/r8180_core.c             |   13 ----------
 drivers/staging/rtl8187se/r8180_wx.c               |    4 ---
 6 files changed, 0 insertions(+), 63 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211.h b/drivers/staging/rtl8187se/ieee80211.h
index 5833608..f5b8de6 100644
--- a/drivers/staging/rtl8187se/ieee80211.h
+++ b/drivers/staging/rtl8187se/ieee80211.h
@@ -196,15 +196,6 @@ typedef struct ieee_param {
 }ieee_param;
 
 
-#if WIRELESS_EXT < 17
-#define IW_QUAL_QUAL_INVALID   0x10
-#define IW_QUAL_LEVEL_INVALID  0x20
-#define IW_QUAL_NOISE_INVALID  0x40
-#define IW_QUAL_QUAL_UPDATED   0x1
-#define IW_QUAL_LEVEL_UPDATED  0x2
-#define IW_QUAL_NOISE_UPDATED  0x4
-#endif
-
 // linux under 2.6.9 release may not support it, so modify it for common use
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,9))
 #define MSECS(t)	(1000 * ((t) / HZ) + 1000 * ((t) % HZ) / HZ)
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211.h b/drivers/staging/rtl8187se/ieee80211/ieee80211.h
index 5833608..f5b8de6 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211.h
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211.h
@@ -196,15 +196,6 @@ typedef struct ieee_param {
 }ieee_param;
 
 
-#if WIRELESS_EXT < 17
-#define IW_QUAL_QUAL_INVALID   0x10
-#define IW_QUAL_LEVEL_INVALID  0x20
-#define IW_QUAL_NOISE_INVALID  0x40
-#define IW_QUAL_QUAL_UPDATED   0x1
-#define IW_QUAL_LEVEL_UPDATED  0x2
-#define IW_QUAL_NOISE_UPDATED  0x4
-#endif
-
 // linux under 2.6.9 release may not support it, so modify it for common use
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,9))
 #define MSECS(t)	(1000 * ((t) / HZ) + 1000 * ((t) % HZ) / HZ)
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_tkip.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_tkip.c
index de97bbe..5266253 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_tkip.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_tkip.c
@@ -753,7 +753,6 @@ static int ieee80211_michael_mic_add(struct sk_buff *skb, int hdr_len, void *pri
 }
 
 
-#if WIRELESS_EXT >= 18
 static void ieee80211_michael_mic_failure(struct net_device *dev,
 				       struct ieee80211_hdr *hdr,
 				       int keyidx)
@@ -774,29 +773,6 @@ static void ieee80211_michael_mic_failure(struct net_device *dev,
 	wrqu.data.length = sizeof(ev);
 	wireless_send_event(dev, IWEVMICHAELMICFAILURE, &wrqu, (char *) &ev);
 }
-#elif WIRELESS_EXT >= 15
-static void ieee80211_michael_mic_failure(struct net_device *dev,
-				       struct ieee80211_hdr *hdr,
-				       int keyidx)
-{
-	union iwreq_data wrqu;
-	char buf[128];
-
-	/* TODO: needed parameters: count, keyid, key type, TSC */
-	sprintf(buf, "MLME-MICHAELMICFAILURE.indication(keyid=%d %scast addr="
-		MAC_FMT ")", keyidx, hdr->addr1[0] & 0x01 ? "broad" : "uni",
-		MAC_ARG(hdr->addr2));
-	memset(&wrqu, 0, sizeof(wrqu));
-	wrqu.data.length = strlen(buf);
-	wireless_send_event(dev, IWEVCUSTOM, &wrqu, buf);
-}
-#else /* WIRELESS_EXT >= 15 */
-static inline void ieee80211_michael_mic_failure(struct net_device *dev,
-					      struct ieee80211_hdr *hdr,
-					      int keyidx)
-{
-}
-#endif /* WIRELESS_EXT >= 15 */
 
 
 static int ieee80211_michael_mic_verify(struct sk_buff *skb, int keyidx,
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
index 4d4ee56..8de1289 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
@@ -644,7 +644,6 @@ int ieee80211_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 	hdrlen = ieee80211_get_hdrlen(fc);
 
 #ifdef NOT_YET
-#if WIRELESS_EXT > 15
 	/* Put this code here so that we avoid duplicating it in all
 	 * Rx paths. - Jean II */
 #ifdef IW_WIRELESS_SPY		/* defined in iw_handler.h */
@@ -658,18 +657,15 @@ int ieee80211_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 		wireless_spy_update(dev, hdr->addr2, &wstats);
 	}
 #endif /* IW_WIRELESS_SPY */
-#endif /* WIRELESS_EXT > 15 */
 	hostap_update_rx_stats(local->ap, hdr, rx_stats);
 #endif
 
-#if WIRELESS_EXT > 15
 	if (ieee->iw_mode == IW_MODE_MONITOR) {
 		ieee80211_monitor_rx(ieee, skb, rx_stats);
 		stats->rx_packets++;
 		stats->rx_bytes += skb->len;
 		return 1;
 	}
-#endif
 	if (ieee->host_decrypt) {
 		int idx = 0;
 		if (skb->len >= hdrlen + 3)
diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index 7e2feca..3a00e42 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -592,14 +592,6 @@ static int proc_get_stats_tx(char *page, char **start,
 }
 
 
-#if WIRELESS_EXT < 17
-static struct iw_statistics *r8180_get_wireless_stats(struct net_device *dev)
-{
-       struct r8180_priv *priv = ieee80211_priv(dev);
-
-       return &priv->wstats;
-}
-#endif
 void rtl8180_proc_module_init(void)
 {
 	DMESG("Initializing proc filesystem");
@@ -5950,12 +5942,7 @@ static int __devinit rtl8180_pci_probe(struct pci_dev *pdev,
 	dev->netdev_ops = &rtl8180_netdev_ops;
 	dev->wireless_handlers = &r8180_wx_handlers_def;
 
-#if WIRELESS_EXT >= 12
-#if WIRELESS_EXT < 17
-	dev->get_wireless_stats = r8180_get_wireless_stats;
-#endif
 	dev->wireless_handlers = (struct iw_handler_def *) &r8180_wx_handlers_def;
-#endif
 
 	dev->type=ARPHRD_ETHER;
 	dev->watchdog_timeo = HZ*3; //added by david woo, 2007.12.13
diff --git a/drivers/staging/rtl8187se/r8180_wx.c b/drivers/staging/rtl8187se/r8180_wx.c
index 979ba0b..ad0ed8d 100644
--- a/drivers/staging/rtl8187se/r8180_wx.c
+++ b/drivers/staging/rtl8187se/r8180_wx.c
@@ -1543,7 +1543,6 @@ static iw_handler r8180_private_handler[] = {
 	r8180_wx_set_forcerate,
 };
 
-#if WIRELESS_EXT >= 17
 static inline int is_same_network(struct ieee80211_network *src,
                                   struct ieee80211_network *dst,
 				  struct ieee80211_device *ieee)
@@ -1626,7 +1625,6 @@ static struct iw_statistics *r8180_get_wireless_stats(struct net_device *dev)
 	wstats->qual.updated = IW_QUAL_ALL_UPDATED| IW_QUAL_DBM;
 	return wstats;
 }
-#endif
 
 
 struct iw_handler_def  r8180_wx_handlers_def={
@@ -1635,9 +1633,7 @@ struct iw_handler_def  r8180_wx_handlers_def={
 	.private = r8180_private_handler,
 	.num_private = sizeof(r8180_private_handler) / sizeof(iw_handler),
  	.num_private_args = sizeof(r8180_private_args) / sizeof(struct iw_priv_args),
-#if WIRELESS_EXT >= 17
 	.get_wireless_stats = r8180_get_wireless_stats,
-#endif
 	.private_args = (struct iw_priv_args *)r8180_private_args,
 };
 
-- 
1.6.3.1

