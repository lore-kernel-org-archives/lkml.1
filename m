Return-Path: <linux-kernel-owner+w=401wt.eu-S934261AbXLRCCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934261AbXLRCCl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 21:02:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbXLRCC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 21:02:29 -0500
Received: from mga03.intel.com ([143.182.124.21]:24734 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574AbXLRCC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 21:02:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,178,1196668800"; 
   d="scan'208";a="343732584"
Subject: [patch 2/3] pci: correctly initialize a structure
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>
Content-Type: text/plain
Date: Tue, 18 Dec 2007 09:56:56 +0800
Message-Id: <1197943016.17023.17.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

save_state->cap_nr should be correctly set, otherwise we can't find the
saved cap at resume.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

Index: linux/drivers/pci/pci.c
===================================================================
--- linux.orig/drivers/pci/pci.c	2007-12-18 09:35:52.000000000 +0800
+++ linux/drivers/pci/pci.c	2007-12-18 09:36:40.000000000 +0800
@@ -569,6 +569,7 @@ static int pci_save_pcie_state(struct pc
 	pci_read_config_word(dev, pos + PCI_EXP_LNKCTL, &cap[i++]);
 	pci_read_config_word(dev, pos + PCI_EXP_SLTCTL, &cap[i++]);
 	pci_read_config_word(dev, pos + PCI_EXP_RTCTL, &cap[i++]);
+	save_state->cap_nr = PCI_CAP_ID_EXP;
 	pci_add_saved_cap(dev, save_state);
 	return 0;
 }
@@ -612,6 +613,7 @@ static int pci_save_pcix_state(struct pc
 	cap = (u16 *)&save_state->data[0];
 
 	pci_read_config_word(dev, pos + PCI_X_CMD, &cap[i++]);
+	save_state->cap_nr = PCI_CAP_ID_PCIX;
 	pci_add_saved_cap(dev, save_state);
 	return 0;
 }


