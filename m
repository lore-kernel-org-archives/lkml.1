Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659Ab0BHWof (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 17:44:35 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:7223 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab0BHWoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 17:44:25 -0500
Subject: [PATCH v2 1/7] PCI: make disabled window printk style match the
	enabled ones
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Tony Luck <tony.luck@intel.com>,
       linux-pci@vger.kernel.org, Peter Haight <peterh@sapros.com>,
       Gary Hade <garyhade@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Larry Finger <Larry.Finger@lwfinger.net>
Date: Mon, 08 Feb 2010 15:44:23 -0700
Message-ID: <20100208224423.27954.37294.stgit@bob.kio>
In-Reply-To: <20100208224236.27954.4358.stgit@bob.kio>
References: <20100208224236.27954.4358.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


No functional change; this just tweaks the changes from 349e1823a405
so the new printks for disabled PCI-to-PCI bridge windows match the
ones for the enabled windows.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 drivers/pci/probe.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index d300943..2555d66 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -325,7 +325,7 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 		dev_printk(KERN_DEBUG, &dev->dev, "  bridge window %pR\n", res);
 	} else {
 		dev_printk(KERN_DEBUG, &dev->dev,
-			 "  bridge window [io  %04lx - %04lx] reg reading\n",
+			 "  bridge window [io  %#06lx-%#06lx] (disabled)\n",
 				 base, limit);
 	}
 
@@ -341,7 +341,7 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 		dev_printk(KERN_DEBUG, &dev->dev, "  bridge window %pR\n", res);
 	} else {
 		dev_printk(KERN_DEBUG, &dev->dev,
-			"  bridge window [mem 0x%08lx - 0x%08lx] reg reading\n",
+			"  bridge window [mem %#010lx-%#010lx] (disabled)\n",
 					 base, limit + 0xfffff);
 	}
 
@@ -384,7 +384,7 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 		dev_printk(KERN_DEBUG, &dev->dev, "  bridge window %pR\n", res);
 	} else {
 		dev_printk(KERN_DEBUG, &dev->dev,
-		     "  bridge window [mem 0x%08lx - %08lx pref] reg reading\n",
+		     "  bridge window [mem %#010lx-%#010lx pref] (disabled)\n",
 					 base, limit + 0xfffff);
 	}
 }

