Return-Path: <linux-kernel-owner+w=401wt.eu-S1755091Ab0AERDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091Ab0AERDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 12:03:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754810Ab0AERDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 12:03:47 -0500
Received: from [206.15.93.42] ([206.15.93.42]:9423 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932115Ab0AERDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 12:03:33 -0500
X-Greylist: delayed 1075 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Jan 2010 12:03:20 EST
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/net/wimax/i2400m/fw.c: use %pM to show MAC address
Date: Tue, 5 Jan 2010 10:01:54 -0700
Cc: netdev@vger.kernel.org, davem@davemloft.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001051001.55024.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the %pM kernel extension to display the MAC address.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David S. Miller <davem@davemloft.net>

---

Repost due to merge issues.

diff --git a/drivers/net/wimax/i2400m/fw.c b/drivers/net/wimax/i2400m/fw.c
index 64cdfeb..e803a7d 100644
--- a/drivers/net/wimax/i2400m/fw.c
+++ b/drivers/net/wimax/i2400m/fw.c
@@ -1041,21 +1041,14 @@ int i2400m_read_mac_addr(struct i2400m *i2400m)
 		dev_err(dev, "BM: read mac addr failed: %d\n", result);
 		goto error_read_mac;
 	}
-	d_printf(2, dev,
-		 "mac addr is %02x:%02x:%02x:%02x:%02x:%02x\n",
-		 ack_buf.ack_pl[0], ack_buf.ack_pl[1],
-		 ack_buf.ack_pl[2], ack_buf.ack_pl[3],
-		 ack_buf.ack_pl[4], ack_buf.ack_pl[5]);
+	d_printf(2, dev, "mac addr is %pM\n", ack_buf.ack_pl);
 	if (i2400m->bus_bm_mac_addr_impaired == 1) {
 		ack_buf.ack_pl[0] = 0x00;
 		ack_buf.ack_pl[1] = 0x16;
 		ack_buf.ack_pl[2] = 0xd3;
 		get_random_bytes(&ack_buf.ack_pl[3], 3);
 		dev_err(dev, "BM is MAC addr impaired, faking MAC addr to "
-			"mac addr is %02x:%02x:%02x:%02x:%02x:%02x\n",
-			ack_buf.ack_pl[0], ack_buf.ack_pl[1],
-			ack_buf.ack_pl[2], ack_buf.ack_pl[3],
-			ack_buf.ack_pl[4], ack_buf.ack_pl[5]);
+			"mac addr is %pM\n", ack_buf.ack_pl);
 		result = 0;
 	}
 	net_dev->addr_len = ETH_ALEN;
