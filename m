Return-Path: <linux-kernel-owner+w=401wt.eu-S1758874AbZC2Pbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758874AbZC2Pbs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 11:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758236AbZC2Pbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 11:31:35 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:55116 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758251AbZC2Pbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 11:31:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=xX1MQAgG98R6MwTHxG1PU9BuSoP1xNrmDE6i4v5To+xftqsbfDwza4zFi8F6U9vUPC
         dCguVeMun9jOGUCwtz4CbQ0UZrgPYAySPJoq7t3ubZgLw92Mic8YkBYoygmCI0xAUenb
         frD9gHhrszW0sYsTvt46KZRsFJ6QwHqoMu2VY=
Date: Sun, 29 Mar 2009 19:31:28 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 10/10] Staging: wlan-ng: convert to netdev_ops
Message-ID: <20090329153128.GJ11056@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 drivers/staging/wlan-ng/p80211netdev.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wlan-ng/p80211netdev.c b/drivers/staging/wlan-ng/p80211netdev.c
index b2a606a..393e4df 100644
--- a/drivers/staging/wlan-ng/p80211netdev.c
+++ b/drivers/staging/wlan-ng/p80211netdev.c
@@ -711,6 +711,20 @@ static int wlan_change_mtu(netdevice_t *dev, int new_mtu)
 	return 0;
 }
 
+static const struct net_device_ops p80211_netdev_ops = {
+	.ndo_init		= p80211knetdev_init,
+	.ndo_open		= p80211knetdev_open,
+	.ndo_stop		= p80211knetdev_stop,
+	.ndo_get_stats		= p80211knetdev_get_stats,
+	.ndo_start_xmit		= p80211knetdev_hard_start_xmit,
+	.ndo_set_multicast_list	= p80211knetdev_set_multicast_list,
+	.ndo_do_ioctl		= p80211knetdev_do_ioctl,
+	.ndo_set_mac_address	= p80211knetdev_set_mac_address,
+	.ndo_tx_timeout		= p80211knetdev_tx_timeout,
+	.ndo_change_mtu		= wlan_change_mtu,
+	.ndo_validate_addr	= eth_validate_addr,
+};
+
 /*----------------------------------------------------------------
 * wlan_setup
 *
@@ -756,11 +770,7 @@ int wlan_setup(wlandevice_t *wlandev)
 	} else {
 		wlandev->netdev = dev;
 		dev->ml_priv = wlandev;
-		dev->hard_start_xmit = p80211knetdev_hard_start_xmit;
-		dev->get_stats = p80211knetdev_get_stats;
-		dev->init = p80211knetdev_init;
-		dev->open = p80211knetdev_open;
-		dev->stop = p80211knetdev_stop;
+		dev->netdev_ops = &p80211_netdev_ops;
 
 		mutex_init(&wlandev->ioctl_lock);
 		/* block ioctls until fully initialised. Don't forget to call
