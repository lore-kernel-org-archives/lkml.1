Return-Path: <linux-kernel-owner+w=401wt.eu-S1761285AbYA3L53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761285AbYA3L53 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 06:57:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756474AbYA3L5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 06:57:19 -0500
Received: from mail.southpole.se ([193.12.106.18]:44186 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206AbYA3L5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 06:57:18 -0500
From: Jonas Bonn <jonas@southpole.se>
To: netdev@vger.kernel.org, romieu@fr.zoreil.com, linux-kernel@vger.kernel.org
Cc: Jonas Bonn <jonas@southpole.se>
Subject: [PATCH] [SIS190] Use _devinitconst for const data
Date: Wed, 30 Jan 2008 12:57:16 +0100
Message-Id: <1201694236-5007-1-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080130112559.GA21346@uranus.ravnborg.org>
References: <20080130112559.GA21346@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes build error as gcc complains about a "section type conflict"
due to the mixing of const and non-const data in same section.
---
 drivers/net/sis190.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/sis190.c b/drivers/net/sis190.c
index b570402..f84c02e 100644
--- a/drivers/net/sis190.c
+++ b/drivers/net/sis190.c
@@ -326,7 +326,7 @@ static const struct {
 	{ "SiS 191 PCI Gigabit Ethernet adapter" },
 };
 
-static struct pci_device_id sis190_pci_tbl[] __devinitdata = {
+static struct pci_device_id sis190_pci_tbl[] __devinitconst = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_SI, 0x0190), 0, 0, 0 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_SI, 0x0191), 0, 0, 1 },
 	{ 0, },
@@ -1556,7 +1556,7 @@ static int __devinit sis190_get_mac_addr_from_eeprom(struct pci_dev *pdev,
 static int __devinit sis190_get_mac_addr_from_apc(struct pci_dev *pdev,
 						  struct net_device *dev)
 {
-	static const u16 __devinitdata ids[] = { 0x0965, 0x0966, 0x0968 };
+	static u16 __devinitconst ids[] = { 0x0965, 0x0966, 0x0968 };
 	struct sis190_private *tp = netdev_priv(dev);
 	struct pci_dev *isa_bridge;
 	u8 reg, tmp8;
-- 
1.5.3.8


