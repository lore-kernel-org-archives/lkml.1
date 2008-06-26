Return-Path: <linux-kernel-owner+w=401wt.eu-S1756887AbYFZPzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887AbYFZPzK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 11:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbYFZPyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 11:54:53 -0400
Received: from adelie.canonical.com ([91.189.90.139]:54381 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbYFZPyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 11:54:52 -0400
Subject: [PATCH] Fix netxen module device table
From: Ben Collins <ben.collins@canonical.com>
To: Linus Torvalds <torvalds@osdl.org>
Cc: kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: Canonical
Date: Thu, 26 Jun 2008 11:54:46 -0400
Message-Id: <1214495686.7150.7.camel@cunning>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was broken because PCI_DEVICE_CLASS() was duplicating (and
overwriting) .vendor and .device to PCI_ANY.

Signed-off-by: Ben Collins <ben.collins@canonical.com>

diff --git a/drivers/net/netxen/netxen_nic_main.c b/drivers/net/netxen/netxen_nic_main.c
index 6797ed0..0ab5e27 100644
--- a/drivers/net/netxen/netxen_nic_main.c
+++ b/drivers/net/netxen/netxen_nic_main.c
@@ -70,15 +70,18 @@ static void netxen_nic_poll_controller(struct net_device *netdev);
 static irqreturn_t netxen_intr(int irq, void *data);
 static irqreturn_t netxen_msi_intr(int irq, void *data);
 
+#define NETXEN_DEVICE_CLASS \
+	.class = 0x020000, .class_mask = ~0
+
 /*  PCI Device ID Table  */
-static struct pci_device_id netxen_pci_tbl[] __devinitdata = {
-	{PCI_DEVICE(0x4040, 0x0001), PCI_DEVICE_CLASS(0x020000, ~0)},
-	{PCI_DEVICE(0x4040, 0x0002), PCI_DEVICE_CLASS(0x020000, ~0)},
-	{PCI_DEVICE(0x4040, 0x0003), PCI_DEVICE_CLASS(0x020000, ~0)},
-	{PCI_DEVICE(0x4040, 0x0004), PCI_DEVICE_CLASS(0x020000, ~0)},
-	{PCI_DEVICE(0x4040, 0x0005), PCI_DEVICE_CLASS(0x020000, ~0)},
-	{PCI_DEVICE(0x4040, 0x0024), PCI_DEVICE_CLASS(0x020000, ~0)},
-	{PCI_DEVICE(0x4040, 0x0025), PCI_DEVICE_CLASS(0x020000, ~0)},
+static DEFINE_PCI_DEVICE_TABLE(netxen_pci_tbl) = {
+	{PCI_DEVICE(0x4040, 0x0001), NETXEN_DEVICE_CLASS},
+	{PCI_DEVICE(0x4040, 0x0002), NETXEN_DEVICE_CLASS},
+	{PCI_DEVICE(0x4040, 0x0003), NETXEN_DEVICE_CLASS},
+	{PCI_DEVICE(0x4040, 0x0004), NETXEN_DEVICE_CLASS},
+	{PCI_DEVICE(0x4040, 0x0005), NETXEN_DEVICE_CLASS},
+	{PCI_DEVICE(0x4040, 0x0024), NETXEN_DEVICE_CLASS},
+	{PCI_DEVICE(0x4040, 0x0025), NETXEN_DEVICE_CLASS},
 	{0,}
 };


