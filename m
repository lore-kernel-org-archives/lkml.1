Return-Path: <linux-kernel-owner+w=401wt.eu-S933107AbZJLTO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933107AbZJLTO6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 15:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933066AbZJLTOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 15:14:49 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:46194 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933090AbZJLTOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 15:14:48 -0400
Subject: [PATCH v2 3/4] PCI: use better error return values in aer_inject
To: ying.huang@intel.com
From: Andrew Patterson <andrew.patterson@hp.com>
Cc: prarit@redhat.com, linux-pci@vger.kernel.org, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org
Date: Mon, 12 Oct 2009 13:14:10 -0600
Message-ID: <20091012191410.14959.32732.stgit@bob.kio>
In-Reply-To: <20091012191354.14959.47024.stgit@bob.kio>
References: <20091012191354.14959.47024.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI: use better error return values in aer_inject

Replaced some error return values in aer_inject. Use -ENODEV when we
can't find a device and -ENOTTY when the device does not support PCIe AER.

Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
---

diff --git a/drivers/pci/pcie/aer/aer_inject.c b/drivers/pci/pcie/aer/aer_inject.c
index ac0b5e7..da2ad6e 100644
--- a/drivers/pci/pcie/aer/aer_inject.c
+++ b/drivers/pci/pcie/aer/aer_inject.c
@@ -326,23 +326,23 @@ static int aer_inject(struct aer_error_inj *einj)
 
 	dev = pci_get_domain_bus_and_slot((int)einj->domain, einj->bus, devfn);
 	if (!dev)
-		return -EINVAL;
+		return -ENODEV;
 	rpdev = pcie_find_root_port(dev);
 	if (!rpdev) {
-		ret = -EINVAL;
+		ret = -ENOTTY;
 		goto out_put;
 	}
 
 	pos_cap_err = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ERR);
 	if (!pos_cap_err) {
-		ret = -EIO;
+		ret = -ENOTTY;
 		goto out_put;
 	}
 	pci_read_config_dword(dev, pos_cap_err + PCI_ERR_UNCOR_SEVER, &sever);
 
 	rp_pos_cap_err = pci_find_ext_capability(rpdev, PCI_EXT_CAP_ID_ERR);
 	if (!rp_pos_cap_err) {
-		ret = -EIO;
+		ret = -ENOTTY;
 		goto out_put;
 	}
 

