Return-Path: <linux-kernel-owner+w=401wt.eu-S938927AbXGSOG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938927AbXGSOG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 10:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761883AbXGSNtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:49:15 -0400
Received: from mail.suse.de ([195.135.220.2]:54581 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765098AbXGSNtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:49:08 -0400
From: Andi Kleen <ak@suse.de>
References: <20070719348.540885000@suse.de>
In-Reply-To: <20070719348.540885000@suse.de>
To: joachim.deguara@amd.com, linux-kernel@vger.kernel.org
Subject: [PATCH for review] [36/48] x86_64: k8topology add family 10h and 11h PCI IDs
Message-Id: <20070719134906.D3A0314E6E@wotan.suse.de>
Date: Thu, 19 Jul 2007 15:49:06 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Joachim Deguara" <joachim.deguara@amd.com>
This just adds the PCI IDs of AMD's family 10h and 11h CPU's northbridges to 
k8topology discovery.

Signed-off-by: Joachim Deguara <joachim.deguara@amd.com>
Signed-off-by: Andi Kleen <ak@suse.de>

--
---
 arch/x86_64/mm/k8topology.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: linux/arch/x86_64/mm/k8topology.c
===================================================================
--- linux.orig/arch/x86_64/mm/k8topology.c
+++ linux/arch/x86_64/mm/k8topology.c
@@ -28,11 +28,15 @@ static __init int find_northbridge(void)
 		u32 header;
 		
 		header = read_pci_config(0, num, 0, 0x00);  
-		if (header != (PCI_VENDOR_ID_AMD | (0x1100<<16)))
+		if (header != (PCI_VENDOR_ID_AMD | (0x1100<<16)) &&
+			header != (PCI_VENDOR_ID_AMD | (0x1200<<16)) &&
+			header != (PCI_VENDOR_ID_AMD | (0x1300<<16)) )
 			continue; 	
 
 		header = read_pci_config(0, num, 1, 0x00); 
-		if (header != (PCI_VENDOR_ID_AMD | (0x1101<<16)))
+		if (header != (PCI_VENDOR_ID_AMD | (0x1101<<16)) &&
+			header != (PCI_VENDOR_ID_AMD | (0x1201<<16)) &&
+			header != (PCI_VENDOR_ID_AMD | (0x1301<<16)) )
 			continue;	
 		return num; 
 	} 
