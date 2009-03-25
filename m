Return-Path: <linux-kernel-owner+w=401wt.eu-S1757237AbZCYU1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237AbZCYU1j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 16:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754323AbZCYU1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 16:27:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:51471 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260AbZCYU1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 16:27:30 -0400
Message-ID: <49CA9365.9090003@kernel.org>
Date: Wed, 25 Mar 2009 13:26:13 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/pci: make pci=lastbus=255 work when acpi is on
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: scan more peer root buses even acpi is used

move out pci_bios_fixup_peer_bridges of pci_legacy_init.
so pci_bios_fixup_peer_bridges could be called even pci_apci_init is called.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/pci/legacy.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6/arch/x86/pci/legacy.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/legacy.c
+++ linux-2.6/arch/x86/pci/legacy.c
@@ -50,8 +50,6 @@ static int __init pci_legacy_init(void)
 	if (pci_root_bus)
 		pci_bus_add_devices(pci_root_bus);
 
-	pcibios_fixup_peer_bridges();
-
 	return 0;
 }
 
@@ -67,6 +65,7 @@ int __init pci_subsys_init(void)
 	pci_visws_init();
 #endif
 	pci_legacy_init();
+	pcibios_fixup_peer_bridges();
 	pcibios_irq_init();
 	pcibios_init();
 
