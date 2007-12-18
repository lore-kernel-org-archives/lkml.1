Return-Path: <linux-kernel-owner+w=401wt.eu-S1762900AbXLRCFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762900AbXLRCFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 21:05:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751110AbXLRCFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 21:05:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:24731 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbXLRCFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 21:05:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,178,1196668800"; 
   d="scan'208";a="243837896"
Subject: [PATCH 1/3]pci: fix typo in pci_save_pcix_state
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>
Content-Type: text/plain
Date: Tue, 18 Dec 2007 09:56:47 +0800
Message-Id: <1197943007.17023.16.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci_save/store_state has multiple bugs, which will cause cap can't be
saved/restored correctly. Below 3 patches fix them.


fix the typo in pci_save_pcix_state

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

Index: linux/drivers/pci/pci.c
===================================================================
--- linux.orig/drivers/pci/pci.c	2007-12-18 09:35:00.000000000 +0800
+++ linux/drivers/pci/pci.c	2007-12-18 09:35:38.000000000 +0800
@@ -602,7 +602,7 @@ static int pci_save_pcix_state(struct pc
 	if (pos <= 0)
 		return 0;
 
-	save_state = pci_find_saved_cap(dev, PCI_CAP_ID_EXP);
+	save_state = pci_find_saved_cap(dev, PCI_CAP_ID_PCIX);
 	if (!save_state)
 		save_state = kzalloc(sizeof(*save_state) + sizeof(u16), GFP_KERNEL);
 	if (!save_state) {


