Return-Path: <linux-kernel-owner+w=401wt.eu-S1755249AbYIPN1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbYIPN1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 09:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754242AbYIPN1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 09:27:24 -0400
Received: from ptb-relay01.plus.net ([212.159.14.145]:37512 "EHLO
	ptb-relay01.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161AbYIPN1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 09:27:23 -0400
Subject: [PATCH 2.6.27-rc6] PCI: Fix pcie_aspm=force
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Li, Shaohua" <shaohua.li@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 16 Sep 2008 14:27:13 +0100
Message-Id: <1221571633.4060.19.camel@galvatron>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-Plusnet-Relay: 67c50b3cb2258b3f94d3db76cc57bbb2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sitsofe Wheeler <sitsofe@yahoo.com>

pcie_aspm=force did not work because aspm_force was being double negated
leading to the sanity check failing. Moving a bracket should fix this.

Signed-off-by: Sitsofe Wheeler <sitsofe@yahoo.com>

---
 drivers/pci/pcie/aspm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 9a7c9e1..851f5b8 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -527,7 +527,7 @@ static int pcie_aspm_sanity_check(struct pci_dev *pdev)
 		 */
 		pci_read_config_dword(child_dev, child_pos + PCI_EXP_DEVCAP,
 			&reg32);
-		if (!(reg32 & PCI_EXP_DEVCAP_RBER && !aspm_force)) {
+		if (!(reg32 & PCI_EXP_DEVCAP_RBER) && !aspm_force) {
 			printk("Pre-1.1 PCIe device detected, "
 				"disable ASPM for %s. It can be enabled forcedly"
 				" with 'pcie_aspm=force'\n", pci_name(pdev));



