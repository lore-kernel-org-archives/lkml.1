Return-Path: <linux-kernel-owner+w=401wt.eu-S1760784AbYAVJE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760784AbYAVJE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 04:04:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbYAVJEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 04:04:15 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:48252 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756074AbYAVJEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 04:04:12 -0500
Date: Tue, 22 Jan 2008 01:10:19 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: AMD Family 10h enable ext config in quirk
In-reply-to: <200801220245.m0M2jDAs000524@imap1.linux-foundation.org>
To: akpm@linux-foundation.org, greg@kroah.com
Cc: LKML <linux-kernel@vger.kernel.org>, ak@suse.de, hpa@zytor.com,
       mingo@elte.hu, tglx@linutronix.de
Message-id: <200801220110.19571.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200801220245.m0M2jDAs000524@imap1.linux-foundation.org>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

need to be applied after
gregkh-pci-pci-make-pci-extended-config-space-a-driver-opt-in.patch
x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-used.patch

[PATCH] x86_64: AMD Family 10h enable ext config in quirk

because of changes of
gregkh-pci-pci-make-pci-extended-config-space-a-driver-opt-in.patch

need to call pci_enable_ext_config to enable mmconfig before set right cfg_size
even MCFG is there

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

--- a/arch/x86/pci/fixup.c	2008-01-22 00:54:38.000000000 -0800
+++ b/arch/x86/pci/fixup.c	2008-01-22 00:55:06.000000000 -0800
@@ -498,10 +498,12 @@
  * access it.  Maybe we don't have a way to generate extended config space
  * accesses.   So check it
  */
-static void fam10h_pci_cfg_space_size(struct pci_dev *dev)
+static void fam10h_enable_pci_ext_cfg(struct pci_dev *dev)
 {
+	pci_enable_ext_config(dev);
+	/* recheck cfg_size without pcie_pcix checking */
 	dev->cfg_size = pci_cfg_space_size_ext(dev, 0);
 }
 
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_ANY_ID,
-			 fam10h_pci_cfg_space_size);
+			 fam10h_enable_pci_ext_cfg);

