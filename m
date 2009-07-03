Return-Path: <linux-kernel-owner+w=401wt.eu-S1757119AbZGCM0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119AbZGCM0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 08:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756429AbZGCM0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 08:26:08 -0400
Received: from mail-bw0-f207.google.com ([209.85.218.207]:61294 "EHLO
	mail-bw0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350AbZGCM0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 08:26:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Qh3cgCUYtQWpaE6ltk40n9wjLPTqFaIjJR4K95nMWNHOG+LpCSqwlXGc9akmHacM3U
         nTCx6dUWKaTBcxpbwEQjQXPn/yfxtfIAN2FHPqYqw79Ee3cM/sAj8kx6EKFoXyShtvxD
         Skvx/2sv2k5hVEe1urYipP9aQo/YBtlEFlFFc=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH 4/4] Staging: wlan-ng: remove dependency on WIRELESS_EXT version
Date: Fri,  3 Jul 2009 16:25:53 +0400
Message-Id: <1246623953-23215-4-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1246623953-23215-3-git-send-email-a.beregalov@gmail.com>
References: <1246623953-23215-1-git-send-email-a.beregalov@gmail.com>
 <1246623953-23215-2-git-send-email-a.beregalov@gmail.com>
 <1246623953-23215-3-git-send-email-a.beregalov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the driver is in mainline now we can remove such dependency.
WIRELESS_EXT is 22 now and it is always defined.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/staging/wlan-ng/p80211netdev.c |    3 ---
 drivers/staging/wlan-ng/p80211wext.c   |    8 --------
 drivers/staging/wlan-ng/prism2sta.c    |    2 --
 3 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/wlan-ng/p80211netdev.c b/drivers/staging/wlan-ng/p80211netdev.c
index 3c69a95..d64f06d 100644
--- a/drivers/staging/wlan-ng/p80211netdev.c
+++ b/drivers/staging/wlan-ng/p80211netdev.c
@@ -767,9 +767,6 @@ int wlan_setup(wlandevice_t *wlandev)
 		dev->ml_priv = wlandev;
 		dev->netdev_ops = &p80211_netdev_ops;
 
-#if (WIRELESS_EXT < 21)
-		dev->get_wireless_stats = p80211wext_get_wireless_stats;
-#endif
 		dev->wireless_handlers = &p80211wext_handler_def;
 
 		netif_stop_queue(dev);
diff --git a/drivers/staging/wlan-ng/p80211wext.c b/drivers/staging/wlan-ng/p80211wext.c
index c7c86ea..64d387b 100644
--- a/drivers/staging/wlan-ng/p80211wext.c
+++ b/drivers/staging/wlan-ng/p80211wext.c
@@ -692,9 +692,6 @@ static int p80211wext_giwessid(netdevice_t *dev,
 		data->flags = 1;
 		memcpy(essid, wlandev->ssid.data, data->length);
 		essid[data->length] = 0;
-#if (WIRELESS_EXT < 21)
-		data->length++;
-#endif
 	} else {
 		memset(essid, 0, sizeof(wlandev->ssid.data));
 		data->length = 0;
@@ -727,11 +724,6 @@ static int p80211wext_siwessid(netdevice_t *dev,
 
 	msg.msgcode = DIDmsg_lnxreq_autojoin;
 
-#if (WIRELESS_EXT < 21)
-	if (length)
-		length--;
-#endif
-
 	/* Trim the last '\0' to fit the SSID format */
 	if (length && essid[length - 1] == '\0')
 		length--;
diff --git a/drivers/staging/wlan-ng/prism2sta.c b/drivers/staging/wlan-ng/prism2sta.c
index 2df8b74..39f061a 100644
--- a/drivers/staging/wlan-ng/prism2sta.c
+++ b/drivers/staging/wlan-ng/prism2sta.c
@@ -1447,9 +1447,7 @@ void prism2sta_processing_defer(struct work_struct *data)
 	}
 
 	wlandev->linkstatus = (hw->link_status == HFA384x_LINK_CONNECTED);
-#ifdef WIRELESS_EXT
 	p80211wext_event_associated(wlandev, wlandev->linkstatus);
-#endif
 
 failed:
 	return;
-- 
1.6.3.3

