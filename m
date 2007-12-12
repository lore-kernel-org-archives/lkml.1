Return-Path: <linux-kernel-owner+w=401wt.eu-S1757563AbXLLBJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563AbXLLBJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 20:09:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757202AbXLLBJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 20:09:20 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:34067 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757177AbXLLBJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 20:09:19 -0500
Date: Tue, 11 Dec 2007 17:09:13 -0800
From: Gary Hade <garyhade@us.ibm.com>
To: gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz
Cc: jbeulich@novell.com, linux-kernel@vger.kernel.org, j-nomura@ce.jp.nec.com,
       lcm@us.ibm.com
Subject: [PATCH] PCI: Restore PCI expansion ROM P2P prefetch window creation
Message-ID: <20071212010913.GC6755@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Restore PCI expansion ROM P2P prefetch window creation.

This patch reverts previous "Avoid creating P2P prefetch
window for expansion ROMs" change due to regressions that
were spotted on some systems.

Signed-off-by: Gary Hade <garyhade@us.ibm.com>
---

--- linux-2.6.24-rc5/drivers/pci/probe.c.orig	2007-12-11 10:16:04.000000000 -0800
+++ linux-2.6.24-rc5/drivers/pci/probe.c	2007-12-11 09:57:11.000000000 -0800
@@ -276,7 +276,8 @@ static void pci_read_bases(struct pci_de
 			sz = pci_size(l, sz, (u32)PCI_ROM_ADDRESS_MASK);
 			if (sz) {
 				res->flags = (l & IORESOURCE_ROM_ENABLE) |
-				  IORESOURCE_MEM | IORESOURCE_READONLY;
+				  IORESOURCE_MEM | IORESOURCE_PREFETCH |
+				  IORESOURCE_READONLY | IORESOURCE_CACHEABLE;
 				res->start = l & PCI_ROM_ADDRESS_MASK;
 				res->end = res->start + (unsigned long) sz;
 			}
