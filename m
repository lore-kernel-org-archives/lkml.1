Return-Path: <linux-kernel-owner+w=401wt.eu-S1756911AbYLOO6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911AbYLOO6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 09:58:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755171AbYLOOzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 09:55:32 -0500
Received: from mga09.intel.com ([134.134.136.24]:26559 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754809AbYLOOzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 09:55:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,224,1228118400"; 
   d="scan'208";a="370995516"
From: Patrick Ohly <patrick.ohly@intel.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       John Stultz <johnstul@us.ibm.com>, linux-api@vger.kernel.org,
       Patrick Ohly <patrick.ohly@intel.com>
Subject: [RFC PATCH 08/12] igb: stub support for SIOCSHWTSTAMP
Date: Mon, 15 Dec 2008 15:54:55 +0100
Message-Id: <1229352899-31330-9-git-send-email-patrick.ohly@intel.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1229352899-31330-8-git-send-email-patrick.ohly@intel.com>
References: <1229352899-31330-1-git-send-email-patrick.ohly@intel.com>
 <1229352899-31330-2-git-send-email-patrick.ohly@intel.com>
 <1229352899-31330-3-git-send-email-patrick.ohly@intel.com>
 <1229352899-31330-4-git-send-email-patrick.ohly@intel.com>
 <1229352899-31330-5-git-send-email-patrick.ohly@intel.com>
 <1229352899-31330-6-git-send-email-patrick.ohly@intel.com>
 <1229352899-31330-7-git-send-email-patrick.ohly@intel.com>
 <1229352899-31330-8-git-send-email-patrick.ohly@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Patrick Ohly <patrick.ohly@intel.com>
---
 drivers/net/igb/igb_main.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/net/igb/igb_main.c b/drivers/net/igb/igb_main.c
index 25df7c9..e9ad560 100644
--- a/drivers/net/igb/igb_main.c
+++ b/drivers/net/igb/igb_main.c
@@ -34,6 +34,7 @@
 #include <linux/ipv6.h>
 #include <net/checksum.h>
 #include <net/ip6_checksum.h>
+#include <linux/net_tstamp.h>
 #include <linux/mii.h>
 #include <linux/ethtool.h>
 #include <linux/if_vlan.h>
@@ -4121,6 +4122,33 @@ static int igb_mii_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
 }
 
 /**
+ * igb_hwtstamp_ioctl - control hardware time stamping
+ * @netdev:
+ * @ifreq:
+ * @cmd:
+ *
+ * Currently cannot enable any kind of hardware time stamping, but
+ * supports SIOCSHWTSTAMP in general.
+ **/
+static int igb_hwtstamp_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
+{
+	struct hwtstamp_config config;
+
+	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
+		return -EFAULT;
+
+	/* reserved for future extensions */
+	if (config.flags)
+		return -EINVAL;
+
+	if (config.tx_type == HWTSTAMP_TX_OFF &&
+		config.rx_filter == HWTSTAMP_FILTER_NONE)
+		return 0;
+
+	return -ERANGE;
+}
+
+/**
  * igb_ioctl -
  * @netdev:
  * @ifreq:
@@ -4133,6 +4161,8 @@ static int igb_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
 	case SIOCGMIIREG:
 	case SIOCSMIIREG:
 		return igb_mii_ioctl(netdev, ifr, cmd);
+	case SIOCSHWTSTAMP:
+		return igb_hwtstamp_ioctl(netdev, ifr, cmd);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
1.5.5.3

