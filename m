Return-Path: <linux-kernel-owner+w=401wt.eu-S1752292AbZL1Wyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292AbZL1Wyi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 17:54:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752256AbZL1Wyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 17:54:36 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:57892 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752215AbZL1Wye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 17:54:34 -0500
Date: Tue, 29 Dec 2009 09:54:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Samuel Ortiz <sameo@linux.intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Holger Schurig <holgerschurig@googlemail.com>
Subject: linux-next: manual merge of the net tree with the wireless-current
 tree
Message-Id: <20091229095432.f39a887e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the net tree got a conflict in
drivers/net/wireless/libertas/scan.c between commit
659c8e5243caf14564155ad8421404f044dd8031 ("libertas: Remove carrier
signaling from the scan code") from the wireless-current tree and commit
602114ae595af6c89eab149cf9f939e3f7ef4a34 ("libertas: add access functions
for mesh open/connect status") from the net tree.

I fixed it up (see below) and can carry the fix for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/wireless/libertas/scan.c
index b0b1c78,4a0c3e3..0000000
--- a/drivers/net/wireless/libertas/scan.c
+++ b/drivers/net/wireless/libertas/scan.c
@@@ -632,13 -635,16 +632,13 @@@ out2
  	priv->scan_channel = 0;
  
  out:
 -	if (priv->connect_status == LBS_CONNECTED) {
 -		netif_carrier_on(priv->dev);
 -		if (!priv->tx_pending_len)
 -			netif_wake_queue(priv->dev);
 -	}
 -	if (priv->mesh_dev && lbs_mesh_connected(priv)) {
 -		netif_carrier_on(priv->mesh_dev);
 -		if (!priv->tx_pending_len)
 -			netif_wake_queue(priv->mesh_dev);
 -	}
 +	if (priv->connect_status == LBS_CONNECTED && !priv->tx_pending_len)
 +		netif_wake_queue(priv->dev);
 +
- 	if (priv->mesh_dev && (priv->mesh_connect_status == LBS_CONNECTED) &&
++	if (priv->mesh_dev && lbs_mesh_connected(priv) &&
 +	    !priv->tx_pending_len)
 +		netif_wake_queue(priv->mesh_dev);
 +
  	kfree(chan_list);
  
  	lbs_deb_leave_args(LBS_DEB_SCAN, "ret %d", ret);
