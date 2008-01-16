Return-Path: <linux-kernel-owner+w=401wt.eu-S1753828AbYAPNve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbYAPNve (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 08:51:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbYAPNvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 08:51:24 -0500
Received: from mtagate2.de.ibm.com ([195.212.29.151]:54720 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbYAPNvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 08:51:23 -0500
From: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: [PATCH] IB/ipoib: Fix undefined symbol (priv->cm) if ipoib_cm disabled
Date: Wed, 16 Jan 2008 14:44:35 +0100
User-Agent: KMail/1.8.2
Cc: Christoph Raisch <RAISCH@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801161444.35365.hnguyen@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index e499626..0a58ac4 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -181,6 +181,7 @@ static int ipoib_change_mtu(struct net_device *dev, int new_mtu)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 
+#ifdef CONFIG_INFINIBAND_IPOIB_CM
 	/* dev->mtu > 2K ==> connected mode */
 	if (ipoib_cm_admin_enabled(dev)) {
 		if (new_mtu > priv->cm.max_cm_mtu)
@@ -193,6 +194,7 @@ static int ipoib_change_mtu(struct net_device *dev, int new_mtu)
 		dev->mtu = new_mtu;
 		return 0;
 	}
+#endif
 
 	if (new_mtu > IPOIB_PACKET_SIZE - IPOIB_ENCAP_LEN)
 		return -EINVAL;
-- 
1.5.2


