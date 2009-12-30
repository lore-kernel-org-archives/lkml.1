Return-Path: <linux-kernel-owner+w=401wt.eu-S1753258AbZL3SkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbZL3SkO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 13:40:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbZL3SkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 13:40:13 -0500
Received: from exprod6og105.obsmtp.com ([64.18.1.189]:39884 "HELO
	exprod6og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752767AbZL3SkM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 13:40:12 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] drivers/net/ixgbe/ixgbe_common.c: use %pM to show MAC address
Date: Wed, 30 Dec 2009 13:40:04 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200F642@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] drivers/net/ixgbe/ixgbe_common.c: use %pM to show MAC address
Thread-Index: AcqJf4CX0hayYq/1TPWC5lzd0F7fzg==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Cc: "David Miller" <davem@davemloft.net>
X-OriginalArrivalTime: 30 Dec 2009 18:40:04.0265 (UTC) FILETIME=[80778990:01CA897F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the %pM kernel extension to display the MAC address.

The only difference in the output is that the MAC address is
shown in the usual colon-separated hex notation.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David S. Miller <davem@davemloft.net>

---

diff --git a/drivers/net/ixgbe/ixgbe_common.c b/drivers/net/ixgbe/ixgbe_common.c
index 688b8ca..1cedb9a 100644
--- a/drivers/net/ixgbe/ixgbe_common.c
+++ b/drivers/net/ixgbe/ixgbe_common.c
@@ -1278,19 +1278,11 @@ s32 ixgbe_init_rx_addrs_generic(struct ixgbe_hw *hw)
 		/* Get the MAC address from the RAR0 for later reference */
 		hw->mac.ops.get_mac_addr(hw, hw->mac.addr);
 
-		hw_dbg(hw, " Keeping Current RAR0 Addr =%.2X %.2X %.2X ",
-		       hw->mac.addr[0], hw->mac.addr[1],
-		       hw->mac.addr[2]);
-		hw_dbg(hw, "%.2X %.2X %.2X\n", hw->mac.addr[3],
-		       hw->mac.addr[4], hw->mac.addr[5]);
+		hw_dbg(hw, " Keeping Current RAR0 Addr =%pM\n", hw->mac.addr);
 	} else {
 		/* Setup the receive address. */
 		hw_dbg(hw, "Overriding MAC Address in RAR[0]\n");
-		hw_dbg(hw, " New MAC Addr =%.2X %.2X %.2X ",
-		       hw->mac.addr[0], hw->mac.addr[1],
-		       hw->mac.addr[2]);
-		hw_dbg(hw, "%.2X %.2X %.2X\n", hw->mac.addr[3],
-		       hw->mac.addr[4], hw->mac.addr[5]);
+		hw_dbg(hw, " New MAC Addr =%pM\n", hw->mac.addr);
 
 		hw->mac.ops.set_rar(hw, 0, hw->mac.addr, 0, IXGBE_RAH_AV);
 	} 
