Return-Path: <linux-kernel-owner+w=401wt.eu-S1765424AbXHWSqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765424AbXHWSqE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 14:46:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764878AbXHWSpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 14:45:53 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:42909 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764859AbXHWSpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 14:45:52 -0400
Date: Thu, 23 Aug 2007 19:45:49 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz
Subject: [i386] PCI: Remove __devinit from pcibios_get_irq_routing_table
Message-ID: <20070823184549.GA21650@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

pcibios_get_irq_routing_table is an exported symbol.  This results in a
modpost warning:

WARNING: vmlinux.o(.text+0xdca51): Section mismatch: reference to .init.text:pcibios_fixup_bus (between 'pci_scan_child_bus' and 'pci_scan_bus_parented')

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

diff --git a/arch/i386/pci/pcbios.c b/arch/i386/pci/pcbios.c
index 5f51934..10ac8c3 100644
--- a/arch/i386/pci/pcbios.c
+++ b/arch/i386/pci/pcbios.c
@@ -412,7 +412,7 @@ struct irq_routing_options {
 	u16 segment;
 } __attribute__((packed));
 
-struct irq_routing_table * __devinit pcibios_get_irq_routing_table(void)
+struct irq_routing_table * pcibios_get_irq_routing_table(void)
 {
 	struct irq_routing_options opt;
 	struct irq_routing_table *rt = NULL;
