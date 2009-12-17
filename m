Return-Path: <linux-kernel-owner+w=401wt.eu-S936355AbZLQENp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936355AbZLQENp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:13:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936322AbZLQELy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:11:54 -0500
Received: from kroah.org ([198.145.64.141]:56030 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936192AbZLQEFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:05:48 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:57:00 2009
Message-Id: <20091217035700.621604509@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:57:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Florian Fainelli <ffainelli@freebox.fr>,
       "David S. Miller" <davem@davemloft.net>
Subject: [136/151] bcm63xx_enet: fix compilation failure after get_stats_count removal
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Florian Fainelli <ffainelli@freebox.fr>

commit a3f92eea04101d9a8e14d50f8048cc5b7bca07a8 upstream.

This patch converts bcm63xx_enet to uset get_sset_count
like the other drivers do.

Signed-off-by: Florian Fainelli <ffainelli@freebox.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/bcm63xx_enet.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/net/bcm63xx_enet.c
+++ b/drivers/net/bcm63xx_enet.c
@@ -1248,9 +1248,15 @@ static void bcm_enet_get_drvinfo(struct 
 	drvinfo->n_stats = BCM_ENET_STATS_LEN;
 }
 
-static int bcm_enet_get_stats_count(struct net_device *netdev)
+static int bcm_enet_get_sset_count(struct net_device *netdev,
+					int string_set)
 {
-	return BCM_ENET_STATS_LEN;
+	switch (string_set) {
+	case ETH_SS_STATS:
+		return BCM_ENET_STATS_LEN;
+	default:
+		return -EINVAL;
+	}
 }
 
 static void bcm_enet_get_strings(struct net_device *netdev,
@@ -1476,7 +1482,7 @@ static int bcm_enet_set_pauseparam(struc
 
 static struct ethtool_ops bcm_enet_ethtool_ops = {
 	.get_strings		= bcm_enet_get_strings,
-	.get_stats_count	= bcm_enet_get_stats_count,
+	.get_sset_count		= bcm_enet_get_sset_count,
 	.get_ethtool_stats      = bcm_enet_get_ethtool_stats,
 	.get_settings		= bcm_enet_get_settings,
 	.set_settings		= bcm_enet_set_settings,


