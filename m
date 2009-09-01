Return-Path: <linux-kernel-owner+w=401wt.eu-S1751468AbZIACFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468AbZIACFL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 22:05:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751107AbZIACFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 22:05:10 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48510 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbZIACFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 22:05:09 -0400
Date: Tue, 1 Sep 2009 12:05:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mike Mason <mmlnx@us.ibm.com>, Richard Lary <rlary@us.ibm.com>,
       Grant Likely <grant.likely@secretlab.ca>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, <linuxppc-dev@ozlabs.org>
Subject: linux-next: manual merge of the pci tree with the powerpc tree
Message-Id: <20090901120502.2b40b3b1.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesse,

Today's linux-next merge of the pci tree got a conflict in
arch/powerpc/kernel/pci_64.c between commit
fbe65447197789a3ccccc27755956f6a4c445089 ("powerpc/pci: move pci_64.c
device tree scanning code into pci-common.c") from the powerpc tree and
commit ced66a36d35607c60d18bb531527acd2083c0523 ("PCI/powerpc: support
PCIe fundamental reset") from the pci tree.

The former moved the code that is modified by the latter into another
file.  I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/arch/powerpc/kernel/pci_of_scan.c b/arch/powerpc/kernel/pci_of_scan.c
index 72c31bc..7311fdf 100644
--- a/arch/powerpc/kernel/pci_of_scan.c
+++ b/arch/powerpc/kernel/pci_of_scan.c
@@ -139,6 +139,7 @@ struct pci_dev *of_create_pci_dev(struct device_node *node,
 	dev->dev.bus = &pci_bus_type;
 	dev->devfn = devfn;
 	dev->multifunction = 0;		/* maybe a lie? */
+	dev->needs_freset = 0;		/* pcie fundamental reset required */
 
 	dev->vendor = get_int_prop(node, "vendor-id", 0xffff);
 	dev->device = get_int_prop(node, "device-id", 0xffff);
