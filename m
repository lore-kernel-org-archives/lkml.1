Return-Path: <linux-kernel-owner+w=401wt.eu-S1764838AbYA3UEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764838AbYA3UEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 15:04:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755796AbYA3UBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 15:01:47 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:37571 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757299AbYA3UBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:01:44 -0500
Date: Wed, 30 Jan 2008 22:02:19 +0200
From: Adrian Bunk <bunk@kernel.org>
To: gregkh@suse.de
Cc: linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: [2.6 patch] pci_setup_bridge() mustn't be __devinit
Message-ID: <20080130200219.GQ29368@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following section mismatch:

<--  snip  -->

...
WARNING: drivers/pci/built-in.o(.text+0x28ee9): Section mismatch in reference from the function pci_bus_assign_resources() to the function .devinit.text:pci_setup_bridge()
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
799449b90fcd191ae39cd6b6147ce337ad8670ea 
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 2cc957d..85e7971 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -140,8 +140,7 @@ EXPORT_SYMBOL(pci_setup_cardbus);
    config space writes, so it's quite possible that an I/O window of
    the bridge will have some undesirable address (e.g. 0) after the
    first write. Ditto 64-bit prefetchable MMIO.  */
-static void __devinit
-pci_setup_bridge(struct pci_bus *bus)
+static void pci_setup_bridge(struct pci_bus *bus)
 {
 	struct pci_dev *bridge = bus->self;
 	struct pci_bus_region region;

