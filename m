Return-Path: <linux-kernel-owner+w=401wt.eu-S1755570AbZLRTjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbZLRTjN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 14:39:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752575AbZLRTiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 14:38:50 -0500
Received: from kroah.org ([198.145.64.141]:47447 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167AbZLRTgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 14:36:33 -0500
Subject: patch staging-slicoss-use-dev-stats-rather-than-adapter-stats.patch added to gregkh-2.6 tree
To: randy.dunlap@oracle.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       sfr@canb.auug.org.au
From: <gregkh@suse.de>
Date: Fri, 18 Dec 2009 11:33:53 -0800
In-Reply-To: <20091218075745.GA4519@coldcone>
Message-ID: <12611648334164@kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: staging: slicoss Use dev->stats rather than adapter->stats.

to my gregkh-2.6 tree.  Its filename is

    staging-slicoss-use-dev-stats-rather-than-adapter-stats.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From kirjanov@gmail.com  Fri Dec 18 10:33:54 2009
From: "Denis Kirjanov <kirjanov@gmail.com" <kirjanov@gmail.com>
Date: Fri, 18 Dec 2009 10:57:45 +0300
Subject: staging: slicoss Use dev->stats rather than adapter->stats.
To: gregkh@suse.de, liodot@gmail.com, charrer@alacritech.com
Cc: devel@linuxdriverproject.org
Message-ID: <20091218075745.GA4519@coldcone>
Content-Disposition: inline


Use dev->stats rather than adapter->stats.

Signed-off-by: Denis Kirjanov <kirjanov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/staging/slicoss/slicoss.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -1230,21 +1230,20 @@ static void slic_init_cleanup(struct ada
 static struct net_device_stats *slic_get_stats(struct net_device *dev)
 {
 	struct adapter *adapter = netdev_priv(dev);
-	struct net_device_stats *stats;
 
 	ASSERT(adapter);
-	stats = &adapter->stats;
-	stats->collisions = adapter->slic_stats.iface.xmit_collisions;
-	stats->rx_errors = adapter->slic_stats.iface.rcv_errors;
-	stats->tx_errors = adapter->slic_stats.iface.xmt_errors;
-	stats->rx_missed_errors = adapter->slic_stats.iface.rcv_discards;
-	stats->tx_heartbeat_errors = 0;
-	stats->tx_aborted_errors = 0;
-	stats->tx_window_errors = 0;
-	stats->tx_fifo_errors = 0;
-	stats->rx_frame_errors = 0;
-	stats->rx_length_errors = 0;
-	return &adapter->stats;
+	dev->stats.collisions = adapter->slic_stats.iface.xmit_collisions;
+	dev->stats.rx_errors = adapter->slic_stats.iface.rcv_errors;
+	dev->stats.tx_errors = adapter->slic_stats.iface.xmt_errors;
+	dev->stats.rx_missed_errors = adapter->slic_stats.iface.rcv_discards;
+	dev->stats.tx_heartbeat_errors = 0;
+	dev->stats.tx_aborted_errors = 0;
+	dev->stats.tx_window_errors = 0;
+	dev->stats.tx_fifo_errors = 0;
+	dev->stats.rx_frame_errors = 0;
+	dev->stats.rx_length_errors = 0;
+
+	return &dev->stats;
 }
 
 /*

