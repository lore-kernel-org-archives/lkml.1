Return-Path: <linux-kernel-owner+w=401wt.eu-S1755188Ab0AERF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188Ab0AERF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 12:05:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755219Ab0AERFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 12:05:45 -0500
Received: from [206.15.93.42] ([206.15.93.42]:9423 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754903Ab0AERDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 12:03:25 -0500
X-Greylist: delayed 1075 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Jan 2010 12:03:20 EST
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/net/ixgbe/ixgbe_common.c: use %pM to show MAC address
Date: Tue, 5 Jan 2010 09:56:52 -0700
Cc: netdev@vger.kernel.org, davem@davemloft.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001050956.53199.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the %pM kernel extension to display the MAC address.

The only difference in the output is that the MAC address is
shown in the usual colon-separated hex notation.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David S. Miller <davem@davemloft.net>

---

Repost due to merge issues.

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
