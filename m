Return-Path: <linux-kernel-owner+w=401wt.eu-S1759496AbXGJMr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759496AbXGJMr1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 08:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754328AbXGJMom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 08:44:42 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:56654 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756085AbXGJMoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 08:44:16 -0400
Date: Tue, 10 Jul 2007 14:44:49 +0200
From: Adrian Bunk <bunk@stusta.de>
To: "David S. Miller" <davem@davemloft.net>, jgarzik@pobox.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2,6 patch] sunhme.c:quattro_pci_find() must be __devinit
Message-ID: <20070710124449.GZ3492@stusta.de>
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
WARNING: drivers/built-in.o(.text+0x272f8b): Section mismatch: reference to .init.text:quattro_pci_find (between 'happy_meal_pci_probe' and 'happy_meal_pci_remove')
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc6-mm1/drivers/net/sunhme.c.old	2007-07-10 04:41:59.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/net/sunhme.c	2007-07-10 04:42:56.000000000 +0200
@@ -2625,7 +2625,7 @@
 #endif /* CONFIG_SBUS */
 
 #ifdef CONFIG_PCI
-static struct quattro * __init quattro_pci_find(struct pci_dev *pdev)
+static struct quattro * __devinit quattro_pci_find(struct pci_dev *pdev)
 {
 	struct pci_dev *bdev = pdev->bus->self;
 	struct quattro *qp;

