Return-Path: <linux-kernel-owner+w=401wt.eu-S1754301AbZJLHLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbZJLHLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 03:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882AbZJLHLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 03:11:16 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:30196 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbZJLHLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 03:11:15 -0400
Subject: [PATCH 4/5] PCI: use better error return values in aer_inject
To: ying.huang@intel.com
From: Andrew Patterson <andrew.patterson@hp.com>
Cc: prarit@redhat.com, andi@firstfloor.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, pci-linux@vger.kernel.org
Date: Mon, 12 Oct 2009 01:03:09 -0600
Message-ID: <20091012070309.27029.80298.stgit@bob.kio>
In-Reply-To: <20091012070248.27029.78378.stgit@bob.kio>
References: <20091012070248.27029.78378.stgit@bob.kio>
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
 

