Return-Path: <linux-kernel-owner+w=401wt.eu-S939379AbXFHHtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939379AbXFHHtt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938408AbXFHHY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:24:58 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:55305 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938395AbXFHHYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:24:53 -0400
Message-Id: <20070608072206.936034000@sous-sol.org>
References: <20070608072127.352723000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:21:50 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jay Cliburn <jacliburn@bellsouth.net>, acliburn@bellsouth.net,
       csnook@redhat.com, ebiederm@xmission.com,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 23/54] PCI: quirk disable MSI on via vt3351
Content-Disposition: inline; filename=pci-quirk-disable-msi-on-via-vt3351.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Jay Cliburn <jacliburn@bellsouth.net>

The Via VT3351 APIC does not play well with MSI and unleashes a flood
of APIC errors when MSI is used to deliver interrupts.  The problem
was recently exposed when the atl1 network device driver, which enables
MSI by default, stimulated APIC errors on an Asus M2V mainboard, which
employs the Via VT3351.
See http://bugzilla.kernel.org/show_bug.cgi?id=8472 for additional
details on this bug.

Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/pci/quirks.c    |    1 +
 include/linux/pci_ids.h |    1 +
 2 files changed, 2 insertions(+)

--- linux-2.6.21.4.orig/drivers/pci/quirks.c
+++ linux-2.6.21.4/drivers/pci/quirks.c
@@ -1751,6 +1751,7 @@ static void __init quirk_disable_all_msi
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_GCNB_LE, quirk_disable_all_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS400_200, quirk_disable_all_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS480, quirk_disable_all_msi);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VT3351, quirk_disable_all_msi);
 
 /* Disable MSI on chipsets that are known to not support it */
 static void __devinit quirk_disable_msi(struct pci_dev *dev)
--- linux-2.6.21.4.orig/include/linux/pci_ids.h
+++ linux-2.6.21.4/include/linux/pci_ids.h
@@ -1287,6 +1287,7 @@
 #define PCI_DEVICE_ID_VIA_P4M800CE	0x0314
 #define PCI_DEVICE_ID_VIA_P4M890	0x0327
 #define PCI_DEVICE_ID_VIA_VT3336	0x0336
+#define PCI_DEVICE_ID_VIA_VT3351	0x0351
 #define PCI_DEVICE_ID_VIA_8371_0	0x0391
 #define PCI_DEVICE_ID_VIA_8501_0	0x0501
 #define PCI_DEVICE_ID_VIA_82C561	0x0561

-- 
