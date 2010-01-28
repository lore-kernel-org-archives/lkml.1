Return-Path: <linux-kernel-owner+w=401wt.eu-S932297Ab0A1TMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297Ab0A1TMk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 14:12:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756336Ab0A1TMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 14:12:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:34872 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753641Ab0A1TMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 14:12:38 -0500
Message-ID: <4B61E116.6050208@kernel.org>
Date: Thu, 28 Jan 2010 11:10:14 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Jeff Garrett <jeff@jgarrett.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>, Myron Stowe <myron.stowe@hp.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH -v2] x86/pci: print ioh resources only
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera> <201001261348.59508.rjw@sisk.pl> <201001261032.37053.bjorn.helgaas@hp.com> <201001261902.13911.rjw@sisk.pl> <20100126101752.78196900@jbarnes-piketon> <4B5F735B.2040308@kernel.org> <alpine.LFD.2.00.1001271748300.3570@localhost.localdomain> <20100127192409.79af96db@jbarnes-piketon> <20100128040226.GB8964@jgarrett.org> <20100128082432.05a97ebc@jbarnes-piketon> <4B61D7C4.1050405@kernel.org> <alpine.LFD.2.00.1001281052510.22433@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1001281052510.22433@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


don't use them for peer pci root bus resource yet.
so could cross check _CRS results

-v2: dont put info struct in stack according to Linus.
     because that is kbytes big

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/pci/intel_bus.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

Index: linux-2.6/arch/x86/pci/intel_bus.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/intel_bus.c
+++ linux-2.6/arch/x86/pci/intel_bus.c
@@ -53,13 +53,9 @@ static void __devinit pci_root_bus_res(s
 	if (dev->cfg_size < 0x120)
 		return;
 
-	if (pci_root_num >= PCI_ROOT_NR) {
-		printk(KERN_DEBUG "intel_bus.c: PCI_ROOT_NR is too small\n");
+	info = kmalloc(sizeof(struct pci_root_info), GFP_KERNEL);
+	if (!info)
 		return;
-	}
-
-	info = &pci_root_info[pci_root_num];
-	pci_root_num++;
 
 	pci_read_config_word(dev, IOH_LCFGBUS, &word);
 	bus_base = (word & 0xff);
