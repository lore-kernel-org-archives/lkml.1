Return-Path: <linux-kernel-owner+w=401wt.eu-S1755316AbXJ2Gjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbXJ2Gjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 02:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbXJ2Gjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 02:39:37 -0400
Received: from 170.Red-213-96-222.staticIP.rima-tde.net ([213.96.222.170]:43427
	"EHLO smtp.ferdyx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbXJ2Gjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 02:39:37 -0400
X-Greylist: delayed 1437 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Oct 2007 02:39:36 EDT
Date: Mon, 29 Oct 2007 06:15:32 +0000
From: Ciaran McCreesh <ciaran.mccreesh@blueyonder.co.uk>
To: linux-kernel@vger.kernel.org
Subject: Abit F-190HD Onboard rlt8169 Ethernet Controller
Message-ID: <20071029061532.5d10dfc6@snowcone>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.14; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Abit Fatal1ty F-190HD motherboard has a Realtek rlt8169 gigabit
ethernet controller onboard. It shows up in lspci as:

02:00.0 Ethernet controller: Unknown device 0001:8168 (rev 01)
        Subsystem: ABIT Computer Corp. Unknown device 2410
        Flags: bus master, fast devsel, latency 0, IRQ 16
        I/O ports at ee00 [size=256]
        Memory at fdeff000 (64-bit, non-prefetchable) [size=4K]
        [virtual] Expansion ROM at fdd00000 [disabled] [size=128K]
        Capabilities: [40] Power Management version 2
        Capabilities: [48] Vital Product Data
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+
Queue=0/1 Enable-
        Capabilities: [60] Express Endpoint, MSI 00
        Capabilities: [84] Vendor Specific Information
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [12c] Virtual Channel
        Capabilities: [148] Device Serial Number 81-ec-10-00-00-00-4f-04
        Capabilities: [154] Power Budgeting

It is not recognised by 2.6.24-rc1. I'm guessing it's because the
vendor ID is 0001 rather than something sensible. I patched the kernel
as follows:

--- drivers/net/r8169.c.orig	2007-10-29 05:37:02.000000000 +0000
+++ drivers/net/r8169.c	2007-10-29 05:54:30.000000000 +0000
@@ -165,6 +165,7 @@
 	{ PCI_DEVICE(PCI_VENDOR_ID_REALTEK,	0x8136), 0, 0, RTL_CFG_2 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_REALTEK,	0x8167), 0, 0, RTL_CFG_0 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_REALTEK,	0x8168), 0, 0, RTL_CFG_1 },
+	{ PCI_DEVICE(PCI_ANY_ID,		0x8168), 0, 0, RTL_CFG_2 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_REALTEK,	0x8169), 0, 0, RTL_CFG_0 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_DLINK,	0x4300), 0, 0, RTL_CFG_0 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AT,		0xc107), 0, 0, RTL_CFG_0 },

This was enough to get the device recognised and operational. (Only
RTL_CFG_2 works, I have no idea why.) Is this the correct approach?

-- 
Ciaran McCreesh
