Return-Path: <linux-kernel-owner+w=401wt.eu-S1946831AbXBJL6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946831AbXBJL6R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 06:58:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933397AbXBJLvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 06:51:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55791 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933389AbXBJLue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 06:50:34 -0500
From: Andi Kleen <ak@suse.de>
References: <200702101250.142420000@suse.de>
In-Reply-To: <200702101250.142420000@suse.de>
To: Olivier Galibert <galibert@pobox.com>, Andi Kleen <ak@suse.de>,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.21 review I] [15/25] i386: Only call unreachable_devices() when type 1 is available.
Message-Id: <20070210115028.14D7513DD5@wotan.suse.de>
Date: Sat, 10 Feb 2007 12:50:28 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Olivier Galibert <galibert@pobox.com>

unreachable_devices compares between the results of pci configuration accesses
through type1 and mmconfig, so it should be called only if type1 actually
works in the first place.

Signed-off-by: Olivier Galibert <galibert@pobox.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/pci/mmconfig-shared.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/arch/i386/pci/mmconfig-shared.c
===================================================================
--- linux.orig/arch/i386/pci/mmconfig-shared.c
+++ linux/arch/i386/pci/mmconfig-shared.c
@@ -80,7 +80,8 @@ void __init pci_mmcfg_init(int type)
 	}
 
 	if (pci_mmcfg_arch_init()) {
-		unreachable_devices();
+		if (type == 1)
+			unreachable_devices();
 		pci_probe = (pci_probe & ~PCI_PROBE_MASK) | PCI_PROBE_MMCONF;
 	}
 }
