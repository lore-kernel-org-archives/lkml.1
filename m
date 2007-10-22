Return-Path: <linux-kernel-owner+w=401wt.eu-S1753962AbXJVRN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbXJVRN4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 13:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbXJVRNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 13:13:39 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:52318 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbXJVRNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 13:13:37 -0400
Date: Mon, 22 Oct 2007 18:13:24 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>, Jeff Garzik <jgarzik@pobox.com>
cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] defxx.c: dfx_bus_init() is __devexit not __devinit
Message-ID: <Pine.LNX.4.64N.0710221809350.988@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 The dfx_bus_uninit() call is called from dfx_unregister() which is 
__devexit and which is ultimately the ->remove call for the device.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
 It should be obvious.  Please apply.

  Maciej

patch-mips-2.6.23-rc5-20070904-defxx-devexit-0
diff -up --recursive --new-file linux-mips-2.6.23-rc5-20070904.macro/drivers/net/defxx.c linux-mips-2.6.23-rc5-20070904/drivers/net/defxx.c
--- linux-mips-2.6.23-rc5-20070904.macro/drivers/net/defxx.c	2007-09-04 04:55:41.000000000 +0000
+++ linux-mips-2.6.23-rc5-20070904/drivers/net/defxx.c	2007-10-12 00:21:35.000000000 +0000
@@ -806,7 +806,7 @@ static void __devinit dfx_bus_init(struc
  *   Interrupts are disabled at the adapter bus-specific logic.
  */
 
-static void __devinit dfx_bus_uninit(struct net_device *dev)
+static void __devexit dfx_bus_uninit(struct net_device *dev)
 {
 	DFX_board_t *bp = netdev_priv(dev);
 	struct device *bdev = bp->bus_dev;
