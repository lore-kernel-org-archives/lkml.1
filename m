Return-Path: <linux-kernel-owner+w=401wt.eu-S1754096AbYI3WXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096AbYI3WXA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 18:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbYI3WWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 18:22:51 -0400
Received: from main.gmane.org ([80.91.229.2]:59253 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046AbYI3WWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 18:22:51 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: [PATCH] PCIE: Reduce cannot add device warnings to KERN_INFO
Date: Tue, 30 Sep 2008 23:22:53 +0100
Message-ID: <48E2A6BD.60703@yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060902010106070902070902"
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 87.114.16.235.plusnet.thn-ag3.dyn.plus.net
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060902010106070902070902
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On my EeePC 900 when the wired and wireless ethernet are enabled and the 
system is booted with pciehp.pciehp_force=1 the following when booting 
with the quiet parameter:

pciehp: Device 0000:03:00.0 already exists at 3:0, cannot hot-add
pciehp: Cannot add device 0x3:0
pciehp: Device 0000:01:00.0 already exists at 1:0, cannot hot-add
pciehp: Cannot add device 0x1:0

This changed prevents the messages turning up during a quiet boot.

Signed-off-by: Sitsofe Wheeler <sitsofe@yahoo.com>
--

--------------060902010106070902070902
Content-Type: text/plain; x-mac-type="0"; x-mac-creator="0";
 name="pciehp_quiet.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pciehp_quiet.patch"

 drivers/pci/hotplug/pciehp_ctrl.c |    2 +-
 drivers/pci/hotplug/pciehp_pci.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp_ctrl.c b/drivers/pci/hotplug/pciehp_ctrl.c
index 96a5d55..1e6f7fc 100644
--- a/drivers/pci/hotplug/pciehp_ctrl.c
+++ b/drivers/pci/hotplug/pciehp_ctrl.c
@@ -239,7 +239,7 @@ static int board_added(struct slot *p_slot)
 
 	retval = pciehp_configure_device(p_slot);
 	if (retval) {
-		err("Cannot add device 0x%x:%x\n", p_slot->bus,
+		info("Cannot add device 0x%x:%x\n", p_slot->bus,
 		    p_slot->device);
 		goto err_exit;
 	}
diff --git a/drivers/pci/hotplug/pciehp_pci.c b/drivers/pci/hotplug/pciehp_pci.c
index 6040dcc..8acff65 100644
--- a/drivers/pci/hotplug/pciehp_pci.c
+++ b/drivers/pci/hotplug/pciehp_pci.c
@@ -201,7 +201,7 @@ int pciehp_configure_device(struct slot *p_slot)
 
 	dev = pci_get_slot(parent, PCI_DEVFN(p_slot->device, 0));
 	if (dev) {
-		err("Device %s already exists at %x:%x, cannot hot-add\n",
+		info("Device %s already exists at %x:%x, cannot hot-add\n",
 				pci_name(dev), p_slot->bus, p_slot->device);
 		pci_dev_put(dev);
 		return -EINVAL;

--------------060902010106070902070902--

