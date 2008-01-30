Return-Path: <linux-kernel-owner+w=401wt.eu-S1759369AbYA3Nle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759369AbYA3Nle (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 08:41:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755565AbYA3NlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 08:41:12 -0500
Received: from mail.southpole.se ([193.12.106.18]:55949 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474AbYA3NlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 08:41:10 -0500
From: Jonas Bonn <jonas@southpole.se>
To: netdev@vger.kernel.org, romieu@fr.zoreil.com, linux-kernel@vger.kernel.org
Cc: Jonas Bonn <jonas@southpole.se>
Subject: [PATCH] [SIS190] Use __devinitconst for const devinit data
Date: Wed, 30 Jan 2008 14:41:05 +0100
Message-Id: <1201700465-11036-1-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080130133742.GA22198@uranus.ravnborg.org>
References: <20080130133742.GA22198@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mixing const and __section was previously not allowed.  New __devinitconst tag
allows this.

This fixes a gcc "section type mismatch" build error.
---
 drivers/net/sis190.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/sis190.c b/drivers/net/sis190.c
index b570402..d3126a9 100644
--- a/drivers/net/sis190.c
+++ b/drivers/net/sis190.c
@@ -326,7 +326,7 @@ static const struct {
 	{ "SiS 191 PCI Gigabit Ethernet adapter" },
 };
 
-static struct pci_device_id sis190_pci_tbl[] __devinitdata = {
+static const struct pci_device_id sis190_pci_tbl[] __devinitconst = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_SI, 0x0190), 0, 0, 0 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_SI, 0x0191), 0, 0, 1 },
 	{ 0, },
@@ -1556,7 +1556,7 @@ static int __devinit sis190_get_mac_addr_from_eeprom(struct pci_dev *pdev,
 static int __devinit sis190_get_mac_addr_from_apc(struct pci_dev *pdev,
 						  struct net_device *dev)
 {
-	static const u16 __devinitdata ids[] = { 0x0965, 0x0966, 0x0968 };
+	static const u16 __devinitconst ids[] = { 0x0965, 0x0966, 0x0968 };
 	struct sis190_private *tp = netdev_priv(dev);
 	struct pci_dev *isa_bridge;
 	u8 reg, tmp8;
-- 
1.5.3.8


