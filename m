Return-Path: <linux-kernel-owner+w=401wt.eu-S1753611AbYA1UJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611AbYA1UJA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 15:09:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbYA1UIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 15:08:53 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:53695 "EHLO
	outbound5-wa4-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750920AbYA1UIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 15:08:52 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 9D002D81-0D89-4A8A-BDDE-D174997CF0D6
From: "Joachim Deguara" <joachim.deguara@amd.com>
Organization: AMD
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: [PATCH] x86: add PCI IDs to k8topology_64.c
Date: Mon, 28 Jan 2008 12:11:27 -0800
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
cc: linux-kernel@vger.kernel.org, "Andi Kleen" <ak@suse.de>,
       yinghai.lu@sun.com, "Dean Roe" <roe@cray.com>
MIME-Version: 1.0
Message-ID: <200801281211.28214.joachim.deguara@amd.com>
X-OriginalArrivalTime: 28 Jan 2008 20:08:33.0328 (UTC)
 FILETIME=[8EEDC300:01C861E9]
X-WSS-ID: 6B80E9CD0QK9084628-02-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quick history, this is a harmless patch that got dropped by Andi as a mixup to 
dropping another patch of mine that was made obsolete by Yinghai.
http://thread.gmane.org/gmane.linux.kernel/559581

-Joachim

--

    x86: add PCI IDs to k8topology_64.c
    
    This just adds the PCI IDs of AMD's family 10h and 11h CPU's northbridges 
to
    k8topology discovery.
    
    Signed-off-by: Joachim Deguara <joachim.deguara@amd.com>
    Signed-off-by: Andi Kleen <ak@suse.de>
    Acked-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/arch/x86/mm/k8topology_64.c b/arch/x86/mm/k8topology_64.c
index a96006f..b123ea3 100644
--- a/arch/x86/mm/k8topology_64.c
+++ b/arch/x86/mm/k8topology_64.c
@@ -28,11 +28,15 @@ static __init int find_northbridge(void)
 		u32 header;
 		
 		header = read_pci_config(0, num, 0, 0x00);  
-		if (header != (PCI_VENDOR_ID_AMD | (0x1100<<16)))
+		if (header != (PCI_VENDOR_ID_AMD | (0x1100<<16)) &&
+			header != (PCI_VENDOR_ID_AMD | (0x1200<<16)) &&
+			header != (PCI_VENDOR_ID_AMD | (0x1300<<16)))
 			continue; 	
 
 		header = read_pci_config(0, num, 1, 0x00); 
-		if (header != (PCI_VENDOR_ID_AMD | (0x1101<<16)))
+		if (header != (PCI_VENDOR_ID_AMD | (0x1101<<16)) &&
+			header != (PCI_VENDOR_ID_AMD | (0x1201<<16)) &&
+			header != (PCI_VENDOR_ID_AMD | (0x1301<<16)))
 			continue;	
 		return num; 
 	} 


