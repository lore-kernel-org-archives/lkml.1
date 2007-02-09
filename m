Return-Path: <linux-kernel-owner+w=401wt.eu-S1946585AbXBIQG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946585AbXBIQG5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:06:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946569AbXBIQFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:05:53 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:53636 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946581AbXBIQFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:05:32 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] ps3 usb missed the addition of new argument to ps3_alloc_io_irq()
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Message-Id: <E1HFYFg-0004rz-19@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Fri, 09 Feb 2007 16:05:32 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/usb/host/ehci-ps3.c |    2 +-
 drivers/usb/host/ohci-ps3.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/ehci-ps3.c b/drivers/usb/host/ehci-ps3.c
index 371f194..4d781a2 100644
--- a/drivers/usb/host/ehci-ps3.c
+++ b/drivers/usb/host/ehci-ps3.c
@@ -104,7 +104,7 @@ static int ps3_ehci_sb_probe(struct ps3_system_bus_device *dev)
 	dev_dbg(&dev->core, "%s:%d: mmio mapped_addr %lxh\n", __func__,
 		__LINE__, dev->m_region->lpar_addr);
 
-	result = ps3_alloc_io_irq(dev->interrupt_id, &virq);
+	result = ps3_alloc_io_irq(PS3_BINDING_CPU_ANY, dev->interrupt_id, &virq);
 
 	if (result) {
 		dev_dbg(&dev->core, "%s:%d: ps3_construct_io_irq(%d) failed.\n",
diff --git a/drivers/usb/host/ohci-ps3.c b/drivers/usb/host/ohci-ps3.c
index 69d948b..62283a3 100644
--- a/drivers/usb/host/ohci-ps3.c
+++ b/drivers/usb/host/ohci-ps3.c
@@ -107,7 +107,7 @@ static int ps3_ohci_sb_probe(struct ps3_system_bus_device *dev)
 	dev_dbg(&dev->core, "%s:%d: mmio mapped_addr %lxh\n", __func__,
 		__LINE__, dev->m_region->lpar_addr);
 
-	result = ps3_alloc_io_irq(dev->interrupt_id, &virq);
+	result = ps3_alloc_io_irq(PS3_BINDING_CPU_ANY, dev->interrupt_id, &virq);
 
 	if (result) {
 		dev_dbg(&dev->core, "%s:%d: ps3_construct_io_irq(%d) failed.\n",
-- 
1.5.0-rc2.GIT


