Return-Path: <linux-kernel-owner+w=401wt.eu-S933591AbYFGB2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933591AbYFGB2z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760539AbYFGBKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:10:09 -0400
Received: from sous-sol.org ([216.99.217.87]:42591 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760898AbYFGBKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:10:07 -0400
Message-Id: <20080607010619.349634333@sous-sol.org>
References: <20080607010215.358296706@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 18:02:46 -0700
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
       Gary Hade <garyhade@us.ibm.com>, Greg KH <greg@kroah.com>,
       Jan Beulich <jbeulich@novell.com>,
       "Junichi Nomura" <j-nomura@ce.jp.nec.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 31/50] Revert "PCI: remove default PCI expansion ROM memory allocation"
Content-Disposition: inline; filename=revert-pci-remove-default-pci-expansion-rom-memory-allocation.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

upstream commit: 8d539108560ec121d59eee05160236488266221c

This reverts commit 9f8daccaa05c14e5643bdd4faf5aed9cc8e6f11e, which was
reported to break X startup (xf86-video-ati-6.8.0). See

	http://bugs.freedesktop.org/show_bug.cgi?id=15523

for details.

Reported-by: Laurence Withers <l@lwithers.me.uk>
Cc: Gary Hade <garyhade@us.ibm.com>
Cc: Greg KH <greg@kroah.com>
Cc: Jan Beulich <jbeulich@novell.com>
Cc: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[cebbert@redhat.com: backport, remove first hunk to make port easier]
[chrisw@sous-sol.org: add back first hunk]
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/x86/pci/common.c |   17 -----------------
 1 file changed, 17 deletions(-)

--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -130,19 +130,6 @@ static void __devinit pcibios_fixup_ghos
 	}
 }
 
-static void __devinit pcibios_fixup_device_resources(struct pci_dev *dev)
-{
-	struct resource *rom_r = &dev->resource[PCI_ROM_RESOURCE];
-
-	if (rom_r->parent)
-		return;
-	if (rom_r->start)
-		/* we deal with BIOS assigned ROM later */
-		return;
-	if (!(pci_probe & PCI_ASSIGN_ROMS))
-		rom_r->start = rom_r->end = rom_r->flags = 0;
-}
-
 /*
  *  Called after each bus is probed, but before its children
  *  are examined.
@@ -150,12 +137,8 @@ static void __devinit pcibios_fixup_devi
 
 void __devinit  pcibios_fixup_bus(struct pci_bus *b)
 {
-	struct pci_dev *dev;
-
 	pcibios_fixup_ghosts(b);
 	pci_read_bridge_bases(b);
-	list_for_each_entry(dev, &b->devices, bus_list)
-		pcibios_fixup_device_resources(dev);
 }
 
 /*

-- 
