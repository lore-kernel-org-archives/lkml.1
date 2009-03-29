Return-Path: <linux-kernel-owner+w=401wt.eu-S1757807AbZC2PZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757807AbZC2PZB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 11:25:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751413AbZC2PYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 11:24:48 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:25905 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbZC2PYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 11:24:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=nDK+NmL3zKUYwtoIWTUumRiJr+XyCBTTyj10f7Et1b3bqlz5/Vcem7jMEFqE774n81
         3aW5WxdW6I3L/DEMZg01X6uhfN+/z4F7D8JmWUdwwKkSKMRqxlY6o5triErSbK99K9nq
         gatQ1Tv/iY+AfF16Waa6fbsNr+/xs/TMddaII=
Date: Sun, 29 Mar 2009 19:24:32 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 2/10] Staging: epl: convert to netdev_ops
Message-ID: <20090329152432.GB11056@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 drivers/staging/epl/VirtualEthernetLinux.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/epl/VirtualEthernetLinux.c b/drivers/staging/epl/VirtualEthernetLinux.c
index 21206c4..077724a 100644
--- a/drivers/staging/epl/VirtualEthernetLinux.c
+++ b/drivers/staging/epl/VirtualEthernetLinux.c
@@ -284,6 +284,17 @@ static tEplKernel VEthRecvFrame(tEplFrameInfo * pFrameInfo_p)
 	return Ret;
 }
 
+static const struct net_device_ops epl_netdev_ops = {
+	.ndo_open		= VEthOpen,
+	.ndo_stop		= VEthClose,
+	.ndo_get_stats		= VEthGetStats,
+	.ndo_start_xmit		= VEthXmit,
+	.ndo_tx_timeout		= VEthTimeout,
+	.ndo_change_mtu		= eth_change_mtu,
+	.ndo_set_mac_address	= eth_mac_addr,
+	.ndo_validate_addr	= eth_validate_addr,
+};
+
 tEplKernel VEthAddInstance(tEplDllkInitParam *pInitParam_p)
 {
 	tEplKernel Ret = kEplSuccessful;
@@ -299,11 +310,7 @@ tEplKernel VEthAddInstance(tEplDllkInitParam *pInitParam_p)
 		goto Exit;
 	}
 
-	pVEthNetDevice_g->open = VEthOpen;
-	pVEthNetDevice_g->stop = VEthClose;
-	pVEthNetDevice_g->get_stats = VEthGetStats;
-	pVEthNetDevice_g->hard_start_xmit = VEthXmit;
-	pVEthNetDevice_g->tx_timeout = VEthTimeout;
+	pVEthNetDevice_g->netdev_ops = &epl_netdev_ops;
 	pVEthNetDevice_g->watchdog_timeo = EPL_VETH_TX_TIMEOUT;
 	pVEthNetDevice_g->destructor = free_netdev;
 
