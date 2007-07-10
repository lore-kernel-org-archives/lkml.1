Return-Path: <linux-kernel-owner+w=401wt.eu-S1755089AbXGJMor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089AbXGJMor (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 08:44:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754972AbXGJMoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 08:44:08 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:56636 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751200AbXGJMoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 08:44:02 -0400
Date: Tue, 10 Jul 2007 14:44:35 +0200
From: Adrian Bunk <bunk@stusta.de>
To: venza@brownhat.org, jgarzik@pobox.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] sis900_mii_probe() must be __devinit
Message-ID: <20070710124435.GR3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following section mismatch:

<--  snip  -->

...
  MODPOST vmlinux
WARNING: drivers/built-in.o(.text+0x298170): Section mismatch: reference to .init.text:sis900_mii_probe (between 'sis900_probe' and 'sis900_default_phy')
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc6-mm1/drivers/net/sis900.c.old	2007-07-10 04:02:23.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/net/sis900.c	2007-07-10 04:03:31.000000000 +0200
@@ -573,7 +573,7 @@
  *	return error if it failed to found.
  */
 
-static int __init sis900_mii_probe(struct net_device * net_dev)
+static int __devinit sis900_mii_probe(struct net_device * net_dev)
 {
 	struct sis900_private * sis_priv = net_dev->priv;
 	const char *dev_name = pci_name(sis_priv->pci_dev);

