Return-Path: <linux-kernel-owner+w=401wt.eu-S1753537AbZL3U1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbZL3U1j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 15:27:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753523AbZL3U1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 15:27:38 -0500
Received: from exprod6og101.obsmtp.com ([64.18.1.181]:50065 "HELO
	exprod6og101.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753522AbZL3U1g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 15:27:36 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] drivers/net/wimax/i2400m/fw.c: use %pM to show MAC address
Date: Wed, 30 Dec 2009 15:27:36 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200F677@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] drivers/net/wimax/i2400m/fw.c: use %pM to show MAC address
Thread-Index: AcqJjoYjZbZGmyLqRAW/levPAIv/iw==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Cc: "David Miller" <davem@davemloft.net>
X-OriginalArrivalTime: 30 Dec 2009 20:27:34.0882 (UTC) FILETIME=[85559420:01CA898E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the %pM kernel extension to display the MAC address.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David S. Miller <davem@davemloft.net>

---

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
