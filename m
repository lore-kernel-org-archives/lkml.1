Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbXJAOVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbXJAOVI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 10:21:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbXJAOU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 10:20:56 -0400
Received: from styx.suse.cz ([82.119.242.94]:58479 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753776AbXJAOUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 10:20:55 -0400
Date: Mon, 1 Oct 2007 16:20:46 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Greg KH <greg@kroah.com>, Ayaz Abdulla <aabdulla@nvidia.com>
Cc: jgarzik@pobox.com, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org
Subject: [PATCH] PCI: nVidia's MCP61 ethernet card needs quirk for wrong
 class
Message-ID: <Pine.LNX.4.64.0710011615390.7567@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

PCI: nVidia's MCP61 ethernet card needs quirk for wrong class

The MCP61 ethernet controller from nVidia (NVENET_19) contains wrong
PCI class:

	00:07.0 Bridge [0680]: nVidia Corporation MCP61 Ethernet [10de:03ef] (rev a2)

i.e. it identifies itself as a bridge. Fix this.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 50f2dd9..fbf6a89 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1511,6 +1511,13 @@ static void __devinit fixup_rev1_53c810(struct pci_dev* dev)
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NCR, PCI_DEVICE_ID_NCR_53C810, fixup_rev1_53c810);
 
+/* nVidia's MCP61 ethernet card has wrong PCI class (0x0680) */
+static void __devinit fixup_nvenet_19(struct pci_dev *dev)
+{
+	dev->class = PCI_CLASS_NETWORK_ETHERNET << 8;
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NVENET_19, fixup_nvenet_19);
+
 static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f, struct pci_fixup *end)
 {
 	while (f < end) {
