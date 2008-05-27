Return-Path: <linux-kernel-owner+w=401wt.eu-S1755429AbYE0Fby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429AbYE0Fby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 01:31:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbYE0Fbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 01:31:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50897 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbYE0Fbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 01:31:46 -0400
Subject: [MTD] [MAPS] ck804rom: fix driver_data in probe table.
From: David Woodhouse <dwmw2@infradead.org>
To: Abhijit Menon-Sen <ams@toroid.org>
Cc: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesper Krogh <jesper@krogh.cc>, linux-kernel@vger.kernel.org
In-Reply-To: <20080527015243.GA19756@toroid.org>
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org>
	 <483B2A9B.4050007@krogh.cc>
	 <alpine.LFD.1.10.0805261428140.2958@woody.linux-foundation.org>
	 <483B60DB.7020402@gmx.net> <483B6287.2000202@gmx.net>
	 <20080527015243.GA19756@toroid.org>
Content-Type: text/plain
Date: Tue, 27 May 2008 06:31:43 +0100
Message-Id: <1211866303.10205.4.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's a reason why using C99 initialisers even in the supposedly
trivial structs is a good idea.

Signed-off-by: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
Signed-off-by: David Woodhouse <dwmw2@infradead.org>

diff --git a/drivers/mtd/maps/ck804xrom.c b/drivers/mtd/maps/ck804xrom.c
index 59d8fb4..effaf7c 100644
--- a/drivers/mtd/maps/ck804xrom.c
+++ b/drivers/mtd/maps/ck804xrom.c
@@ -331,15 +331,15 @@ static void __devexit ck804xrom_remove_one (struct pci_dev *pdev)
 }
 
 static struct pci_device_id ck804xrom_pci_tbl[] = {
-	{ PCI_VENDOR_ID_NVIDIA, 0x0051, PCI_ANY_ID, PCI_ANY_ID, DEV_CK804 },
-	{ PCI_VENDOR_ID_NVIDIA, 0x0360, PCI_ANY_ID, PCI_ANY_ID, DEV_MCP55 },
-	{ PCI_VENDOR_ID_NVIDIA, 0x0361, PCI_ANY_ID, PCI_ANY_ID, DEV_MCP55 },
-	{ PCI_VENDOR_ID_NVIDIA, 0x0362, PCI_ANY_ID, PCI_ANY_ID, DEV_MCP55 },
-	{ PCI_VENDOR_ID_NVIDIA, 0x0363, PCI_ANY_ID, PCI_ANY_ID, DEV_MCP55 },
-	{ PCI_VENDOR_ID_NVIDIA, 0x0364, PCI_ANY_ID, PCI_ANY_ID, DEV_MCP55 },
-	{ PCI_VENDOR_ID_NVIDIA, 0x0365, PCI_ANY_ID, PCI_ANY_ID, DEV_MCP55 },
-	{ PCI_VENDOR_ID_NVIDIA, 0x0366, PCI_ANY_ID, PCI_ANY_ID, DEV_MCP55 },
-	{ PCI_VENDOR_ID_NVIDIA, 0x0367, PCI_ANY_ID, PCI_ANY_ID, DEV_MCP55 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0051), .driver_data = DEV_CK804 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0360), .driver_data = DEV_MCP55 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0361), .driver_data = DEV_MCP55 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0362), .driver_data = DEV_MCP55 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0363), .driver_data = DEV_MCP55 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0364), .driver_data = DEV_MCP55 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0365), .driver_data = DEV_MCP55 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0366), .driver_data = DEV_MCP55 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0367), .driver_data = DEV_MCP55 },
 	{ 0, }
 };
 

-- 
dwmw2

