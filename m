Return-Path: <linux-kernel-owner+w=401wt.eu-S1761895AbXHURHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761895AbXHURHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 13:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758543AbXHURHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 13:07:24 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35484 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757666AbXHURHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 13:07:23 -0400
Date: Tue, 21 Aug 2007 10:07:13 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Kevin E <kevin360@yahoo.com>
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: [RFT] sky2: yukon-ec-u phy power problems
Message-ID: <20070821100713.2867dce3@freepuppy.rosehill.hemminger.net>
In-Reply-To: <623107.14278.qm@web38905.mail.mud.yahoo.com>
References: <20070819093221.4d3291e9@freepuppy.rosehill.hemminger.net>
	<623107.14278.qm@web38905.mail.mud.yahoo.com>
Organization: Linux Foundation
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The sky2 driver clears some bits in the PHY control register, that cause
the PHY interface to get changed.  Some of these deal with voltage and power
savings as well. This may explain some of the failures on Gigabyte DS-3 motherboard.

The clue to possible problem was looking at why loading/unloading sky2 would
break vendor sk98lin driver (ie what registers changed).


--- a/drivers/net/sky2.c	2007-08-21 09:53:41.000000000 -0700
+++ b/drivers/net/sky2.c	2007-08-21 09:53:43.000000000 -0700
@@ -696,8 +696,8 @@ static void sky2_mac_init(struct sky2_hw
 	int i;
 	const u8 *addr = hw->dev[port]->dev_addr;
 
-	sky2_write32(hw, SK_REG(port, GPHY_CTRL), GPC_RST_SET);
-	sky2_write32(hw, SK_REG(port, GPHY_CTRL), GPC_RST_CLR);
+	sky2_write8(hw, SK_REG(port, GPHY_CTRL), GPC_RST_SET);
+	sky2_write8(hw, SK_REG(port, GPHY_CTRL), GPC_RST_CLR);
 
 	sky2_write8(hw, SK_REG(port, GMAC_CTRL), GMC_RST_CLR);
 
