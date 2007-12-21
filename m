Return-Path: <linux-kernel-owner+w=401wt.eu-S1758065AbXLUDAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065AbXLUDAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 22:00:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758205AbXLUDAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 22:00:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57057 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756765AbXLUDAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 22:00:16 -0500
Subject: patch pci-correctly-initialize-a-structure-for-pcie_save_pcix_state.patch added to gregkh-2.6 tree
To: shaohua.li@intel.com, akpm@linux-foundation.org, gregkh@suse.de,
       linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Thu, 20 Dec 2007 18:59:01 -0800
In-Reply-To: <1197943016.17023.17.camel@sli10-desk.sh.intel.com>
Message-ID: <11982059403587@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: PCI: correctly initialize a structure for pcie_save_pcix_state()

to my gregkh-2.6 tree.  Its filename is

     pci-correctly-initialize-a-structure-for-pcie_save_pcix_state.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From shaohua.li@intel.com Mon Dec 17 18:02:37 2007
From: Shaohua Li <shaohua.li@intel.com>
Date: Tue, 18 Dec 2007 09:56:56 +0800
Subject: PCI: correctly initialize a structure for pcie_save_pcix_state()
To: lkml <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>
Message-ID: <1197943016.17023.17.camel@sli10-desk.sh.intel.com>


save_state->cap_nr should be correctly set, otherwise we can't find the
saved cap at resume.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/pci.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -587,6 +587,7 @@ static int pci_save_pcie_state(struct pc
 	pci_read_config_word(dev, pos + PCI_EXP_LNKCTL, &cap[i++]);
 	pci_read_config_word(dev, pos + PCI_EXP_SLTCTL, &cap[i++]);
 	pci_read_config_word(dev, pos + PCI_EXP_RTCTL, &cap[i++]);
+	save_state->cap_nr = PCI_CAP_ID_EXP;
 	pci_add_saved_cap(dev, save_state);
 	return 0;
 }
@@ -630,6 +631,7 @@ static int pci_save_pcix_state(struct pc
 	cap = (u16 *)&save_state->data[0];
 
 	pci_read_config_word(dev, pos + PCI_X_CMD, &cap[i++]);
+	save_state->cap_nr = PCI_CAP_ID_PCIX;
 	pci_add_saved_cap(dev, save_state);
 	return 0;
 }


Patches currently in gregkh-2.6 which might be from shaohua.li@intel.com are

driver/kobject-change-drivers-cpuidle-sysfs.c-to-use-kobject_init_and_add.patch
pci/pcie-port-driver-correctly-detect-native-pme-feature.patch
pci/pcie-utilize-pcie-transaction-pending-bit.patch
pci/pci-add-pci-quirk-function-for-some-chipsets.patch
pci/pci-avoid-save-the-same-type-of-cap-multiple-times.patch
pci/pci-correctly-initialize-a-structure-for-pcie_save_pcix_state.patch
pci/pci-fix-typo-in-pci_save_pcix_state.patch
