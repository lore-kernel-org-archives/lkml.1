Return-Path: <linux-kernel-owner+w=401wt.eu-S1760646AbZGAAcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760646AbZGAAcB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758308AbZGAAaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:30:05 -0400
Received: from kroah.org ([198.145.64.141]:34321 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759613AbZGAAaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:30:01 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:03:57 2009
Message-Id: <20090701000357.437400136@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 16:59:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Shaohua Li <shaohua.li@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [patch 08/30] PCI: disable ASPM on VIA root-port-under-bridge configurations
References: <20090630235944.868879272@mini.kroah.org>
Content-Disposition: inline; filename=pci-disable-aspm-on-via-root-port-under-bridge-configurations.patch
In-Reply-To: <20090701002817.GA6156@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Shaohua Li <shaohua.li@intel.com>

commit 8e822df700694ca6850d1e0c122fd7004b2778d8 upstream.

VIA has a strange chipset, it has root port under a bridge. Disable ASPM
for such strange chipset.

Tested-by: Wolfgang Denk <wd@denx.de>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/pcie/aspm.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -633,6 +633,10 @@ void pcie_aspm_init_link_state(struct pc
 	if (pdev->pcie_type != PCI_EXP_TYPE_ROOT_PORT &&
 		pdev->pcie_type != PCI_EXP_TYPE_DOWNSTREAM)
 		return;
+	/* VIA has a strange chipset, root port is under a bridge */
+	if (pdev->pcie_type == PCI_EXP_TYPE_ROOT_PORT &&
+		pdev->bus->self)
+		return;
 	down_read(&pci_bus_sem);
 	if (list_empty(&pdev->subordinate->devices))
 		goto out;


