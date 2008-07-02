Return-Path: <linux-kernel-owner+w=401wt.eu-S1758463AbYGBVTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758463AbYGBVTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 17:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756812AbYGBVSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 17:18:22 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:5834 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756741AbYGBVSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 17:18:21 -0400
X-BigFish: VPS24(zzzz10d3izzz32i87il43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K3EDU0-01-1WZ-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 09/11] x86/pci: Makefile merge: Coalescing 32 and 64 bit
Date: Wed, 2 Jul 2008 22:50:27 +0200
Message-ID: <1215031829-29124-10-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1215031829-29124-1-git-send-email-robert.richter@amd.com>
References: <1215031829-29124-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 02 Jul 2008 21:17:56.0287 (UTC) FILETIME=[18AFE4F0:01C8DC89]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/pci/Makefile |   21 +--------------------
 1 files changed, 1 insertions(+), 20 deletions(-)

diff --git a/arch/x86/pci/Makefile b/arch/x86/pci/Makefile
index 58a3749..c92dc6f 100644
--- a/arch/x86/pci/Makefile
+++ b/arch/x86/pci/Makefile
@@ -1,9 +1,7 @@
-ifeq ($(CONFIG_X86_32),y)
-
 obj-y				:= i386.o init.o
 
 obj-$(CONFIG_PCI_BIOS)		+= pcbios.o
-obj-$(CONFIG_PCI_MMCONFIG)	+= mmconfig_32.o direct.o mmconfig-shared.o
+obj-$(CONFIG_PCI_MMCONFIG)	+= mmconfig_$(BITS).o direct.o mmconfig-shared.o
 obj-$(CONFIG_PCI_DIRECT)	+= direct.o
 obj-$(CONFIG_PCI_OLPC)		+= olpc.o
 
@@ -22,20 +20,3 @@ pci-$(CONFIG_X86_NUMAQ)		:= numa.o irq.o
 
 obj-y				+= $(pci-y) common.o early.o
 obj-y				+= amd_bus.o
-
-else
-
-#
-# Makefile for X86_64 specific PCI routines
-#
-
-obj-y				:= i386.o init.o
-obj-$(CONFIG_PCI_MMCONFIG)	+= mmconfig_64.o direct.o mmconfig-shared.o
-obj-$(CONFIG_PCI_DIRECT)	+= direct.o
-pci-y				:= fixup.o
-pci-$(CONFIG_ACPI)		+= acpi.o
-pci-y				+= legacy.o irq.o
-obj-y				+= $(pci-y) common.o early.o
-obj-y				+= amd_bus.o
-
-endif
-- 
1.5.5.4


