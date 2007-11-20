Return-Path: <linux-kernel-owner+w=401wt.eu-S1764189AbXKTUxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764189AbXKTUxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 15:53:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764087AbXKTUwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 15:52:43 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:45634 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764067AbXKTUwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 15:52:41 -0500
Date: Tue, 20 Nov 2007 21:52:37 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: marcel@holtmann.org, maxk@qualcomm.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/bluetooth: Convert kfree to kfree_skb
Message-ID: <Pine.LNX.4.64.0711202151430.25786@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

kfree_skb rather than kfree should be used for values of type struct
sk_buff *.

This was fixed using the following semantic patch
(http://www.emn.fr/x-info/coccinelle/).

// <smpl>
@@
struct sk_buff *skb;
@@

- kfree(skb)
+ kfree_skb(skb)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -u -p a/drivers/bluetooth/bpa10x.c b/drivers/bluetooth/bpa10x.c
--- a/drivers/bluetooth/bpa10x.c 2007-11-01 10:30:39.000000000 +0100
+++ b/drivers/bluetooth/bpa10x.c 2007-11-20 21:07:42.000000000 +0100
@@ -446,8 +446,8 @@ static void bpa10x_destruct(struct hci_d
 
 	BT_DBG("%s", hdev->name);
 
-	kfree(data->rx_skb[0]);
-	kfree(data->rx_skb[1]);
+	kfree_skb(data->rx_skb[0]);
+	kfree_skb(data->rx_skb[1]);
 	kfree(data);
 }
 
diff -u -p a/drivers/bluetooth/btsdio.c b/drivers/bluetooth/btsdio.c
--- a/drivers/bluetooth/btsdio.c 2007-11-01 10:30:39.000000000 +0100
+++ b/drivers/bluetooth/btsdio.c 2007-11-20 21:07:44.000000000 +0100
@@ -152,7 +152,7 @@ static int btsdio_rx_packet(struct btsdi
 
 	err = sdio_readsb(data->func, skb->data, REG_RDAT, len - 4);
 	if (err < 0) {
-		kfree(skb);
+		kfree_skb(skb);
 		return err;
 	}
 
@@ -163,7 +163,7 @@ static int btsdio_rx_packet(struct btsdi
 
 	err = hci_recv_frame(skb);
 	if (err < 0) {
-		kfree(skb);
+		kfree_skb(skb);
 		return err;
 	}
 
