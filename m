Return-Path: <linux-kernel-owner+w=401wt.eu-S1759494AbYHFQng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759494AbYHFQng (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 12:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755508AbYHFQnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 12:43:21 -0400
Received: from mx1.wp.pl ([212.77.101.5]:13194 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755149AbYHFQnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 12:43:20 -0400
Date: Wed, 6 Aug 2008 18:48:45 +0200
From: Krzysztof Helt <krzysztof.h1@wp.pl>
To: airlied@linux.ie
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] agp: fix SIS 5591/5592 wrong PCI id
Message-Id: <20080806184845.226c6c22.krzysztof.h1@wp.pl>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [cRMF]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Helt <krzysztof.h1@wp.pl>

The correct id is the id of the main host (5591) not
the id of the PCI-to-PCI bridge AGP (0001).
Output from "lspci -nv" shows that only the former 
has AGP capabilities flag set:

00:00.0 0600: 1039:5591 (rev 02)
        Flags: bus master, medium devsel, latency 64
        Memory at ec000000 (32-bit, non-prefetchable) [size=32M]
        Capabilities: [c0] AGP version 1.0

00:02.0 0604: 1039:0001 (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        I/O behind bridge: 0000c000-0000cfff
        Memory behind bridge: eb500000-eb5fffff
        Prefetchable memory behind bridge: eb300000-eb3fffff


Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
---

The AGP bridge is correctly detected with the patch applied.
I have tested it on PC Chips M570 motherboard.

--- linux-mm/drivers/char/agp/sis-agp.c~	2008-08-04 18:00:31.133979040 +0200
+++ linux-mm/drivers/char/agp/sis-agp.c	2008-08-06 18:33:02.162916563 +0200
@@ -241,7 +241,7 @@ static struct pci_device_id agp_sis_pci_
 		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
 		.class_mask	= ~0,
 		.vendor		= PCI_VENDOR_ID_SI,
-		.device		= PCI_DEVICE_ID_SI_5591_AGP,
+		.device		= PCI_DEVICE_ID_SI_5591,
 		.subvendor	= PCI_ANY_ID,
 		.subdevice	= PCI_ANY_ID,
 	},
