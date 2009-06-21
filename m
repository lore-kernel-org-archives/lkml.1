Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbZFUSvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbZFUSvi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 14:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755751AbZFUSvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 14:51:18 -0400
Received: from proxima.lp0.eu ([81.2.80.65]:45066 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755568AbZFUSvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 14:51:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:Subject:Content-Type:Content-Transfer-Encoding;
	b=KTJQLUJDXeqbkbTXI3Z2+61GTfGChTZs2gOoq3b4iRDpJG5QJCP1MDhAIABlj1oK9WUrkuNzBozOu0QRlwnNYgJra0FL76j5gpv/hWkKEZI1i6GdGlReVFpXzMkntS7s;
Message-ID: <4A3E7FC5.6060400@simon.arlott.org.uk>
Date: Sun, 21 Jun 2009 19:45:25 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.21 (X11/20090328)
MIME-Version: 1.0
To: netdev <netdev@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Francois Romieu <romieu@fr.zoreil.com>
Subject: [PATCH] r8169: add phy_reset parameter
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When booting over the network the physical link will already be up
and configured appropriately, so there is no need to reset it and
cause auto-negotiation to occur again. Adding an option to disable
this makes it possible to avoid a 2 second delay while booting.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 drivers/net/r8169.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index 4e22462..ca34a63 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -187,6 +187,7 @@ MODULE_DEVICE_TABLE(pci, rtl8169_pci_tbl);
 
 static int rx_copybreak = 200;
 static int use_dac;
+static int phy_reset;
 static struct {
 	u32 msg_enable;
 } debug = { -1 };
@@ -504,6 +505,8 @@ module_param(rx_copybreak, int, 0);
 MODULE_PARM_DESC(rx_copybreak, "Copy breakpoint for copy-only-tiny-frames");
 module_param(use_dac, int, 0);
 MODULE_PARM_DESC(use_dac, "Enable PCI DAC. Unsafe on 32 bit PCI slot.");
+module_param(phy_reset, int, 1);
+MODULE_PARM_DESC(phy_reset, "Reset PHY when initialising device");
 module_param_named(debug, debug.msg_enable, int, 0);
 MODULE_PARM_DESC(debug, "Debug verbosity level (0=none, ..., 16=all)");
 MODULE_LICENSE("GPL");
@@ -1798,6 +1801,9 @@ static void rtl8169_init_phy(struct net_device *dev, struct rtl8169_private *tp)
 		mdio_write(ioaddr, 0x0b, 0x0000); //w 0x0b 15 0 0
 	}
 
+	if (!phy_reset)
+		return;
+
 	rtl8169_phy_reset(dev, tp);
 
 	/*
-- 
1.6.3.1

-- 
Simon Arlott
