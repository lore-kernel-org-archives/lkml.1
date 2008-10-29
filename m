Return-Path: <linux-kernel-owner+w=401wt.eu-S1757506AbYJ2W4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506AbYJ2W4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 18:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755837AbYJ2WqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 18:46:23 -0400
Received: from kroah.org ([198.145.64.141]:56264 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755797AbYJ2WqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 18:46:04 -0400
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 35/49] Staging: at76_usb: remove compiler warnings
Date: Wed, 29 Oct 2008 15:40:02 -0700
Message-Id: <1225320016-21803-35-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081029223832.GC21657@kroah.com>
References: <20081029223832.GC21657@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@suse.de>

3 functions are now not used, remove them.

Cc: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/at76_usb/at76_usb.c |   54 -----------------------------------
 1 files changed, 0 insertions(+), 54 deletions(-)

diff --git a/drivers/staging/at76_usb/at76_usb.c b/drivers/staging/at76_usb/at76_usb.c
index 4f7ea6f..b8a056d 100644
--- a/drivers/staging/at76_usb/at76_usb.c
+++ b/drivers/staging/at76_usb/at76_usb.c
@@ -880,43 +880,6 @@ static int at76_set_pm_mode(struct at76_priv *priv)
 	return ret;
 }
 
-/* Set the association id for power save mode */
-static int at76_set_associd(struct at76_priv *priv, u16 id)
-{
-	int ret = 0;
-
-	priv->mib_buf.type = MIB_MAC_MGMT;
-	priv->mib_buf.size = 2;
-	priv->mib_buf.index = offsetof(struct mib_mac_mgmt, station_id);
-	priv->mib_buf.data.word = cpu_to_le16(id);
-
-	ret = at76_set_mib(priv, &priv->mib_buf);
-	if (ret < 0)
-		printk(KERN_ERR "%s: set_mib (associd) failed: %d\n",
-		       wiphy_name(priv->hw->wiphy), ret);
-
-	return ret;
-}
-
-/* Set the listen interval for power save mode */
-static int at76_set_listen_interval(struct at76_priv *priv, u16 interval)
-{
-	int ret = 0;
-
-	priv->mib_buf.type = MIB_MAC;
-	priv->mib_buf.size = 2;
-	priv->mib_buf.index = offsetof(struct mib_mac, listen_interval);
-	priv->mib_buf.data.word = cpu_to_le16(interval);
-
-	ret = at76_set_mib(priv, &priv->mib_buf);
-	if (ret < 0)
-		printk(KERN_ERR
-		       "%s: set_mib (listen_interval) failed: %d\n",
-		       wiphy_name(priv->hw->wiphy), ret);
-
-	return ret;
-}
-
 static int at76_set_preamble(struct at76_priv *priv, u8 type)
 {
 	int ret = 0;
@@ -985,23 +948,6 @@ static int at76_set_autorate_fallback(struct at76_priv *priv, int onoff)
 	return ret;
 }
 
-static int at76_add_mac_address(struct at76_priv *priv, void *addr)
-{
-	int ret = 0;
-
-	priv->mib_buf.type = MIB_MAC_ADDR;
-	priv->mib_buf.size = ETH_ALEN;
-	priv->mib_buf.index = offsetof(struct mib_mac_addr, mac_addr);
-	memcpy(priv->mib_buf.data.addr, addr, ETH_ALEN);
-
-	ret = at76_set_mib(priv, &priv->mib_buf);
-	if (ret < 0)
-		printk(KERN_ERR "%s: set_mib (MAC_ADDR, mac_addr) failed: %d\n",
-		       wiphy_name(priv->hw->wiphy), ret);
-
-	return ret;
-}
-
 static int at76_set_tkip_bssid(struct at76_priv *priv, const void *addr)
 {
 	int ret = 0;
-- 
1.6.0.2

