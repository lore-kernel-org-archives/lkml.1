Return-Path: <linux-kernel-owner+w=401wt.eu-S1764398AbXJXQqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764398AbXJXQqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760100AbXJXQ0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:26:09 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:60999 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760089AbXJXQ0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:26:06 -0400
Date: Wed, 24 Oct 2007 18:26:35 +0200
From: Adrian Bunk <bunk@kernel.org>
To: David Vrabel <david.vrabel@csr.com>, Marcel Holtmann <marcel@holtmann.org>,
       maxk@qualcomm.com
Cc: bluez-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/bluetooth/btsdio.c: fix double-free
Message-ID: <20071024162635.GM30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a double-free spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

09bae986c340a634714517659822959cef72f66d 
diff --git a/drivers/bluetooth/btsdio.c b/drivers/bluetooth/btsdio.c
index b786f61..58630cc 100644
--- a/drivers/bluetooth/btsdio.c
+++ b/drivers/bluetooth/btsdio.c
@@ -162,10 +162,8 @@ static int btsdio_rx_packet(struct btsdio_data *data)
 	bt_cb(skb)->pkt_type = hdr[3];
 
 	err = hci_recv_frame(skb);
-	if (err < 0) {
-		kfree(skb);
+	if (err < 0)
 		return err;
-	}
 
 	sdio_writeb(data->func, 0x00, REG_PC_RRT, NULL);
 
