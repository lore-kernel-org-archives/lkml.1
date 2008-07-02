Return-Path: <linux-kernel-owner+w=401wt.eu-S1757159AbYGBVSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159AbYGBVSY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 17:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753649AbYGBVSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 17:18:11 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:12629 "EHLO
	IE1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbYGBVSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 17:18:10 -0400
X-BigFish: VPS22(zzzz10d3izzz32i87il66h)
X-Spam-TCS-SCL: 5:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K3EDTN-02-CTT-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 04/11] x86/pci: Makefile merge: Decoupling options for mp_bus_to_node.o
Date: Wed, 2 Jul 2008 22:50:22 +0200
Message-ID: <1215031829-29124-5-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1215031829-29124-1-git-send-email-robert.richter@amd.com>
References: <1215031829-29124-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 02 Jul 2008 21:17:55.0724 (UTC) FILETIME=[1859FCC0:01C8DC89]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/pci/Makefile |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/pci/Makefile b/arch/x86/pci/Makefile
index 8491894..d69a0fe 100644
--- a/arch/x86/pci/Makefile
+++ b/arch/x86/pci/Makefile
@@ -14,14 +14,12 @@ pci-y				:= fixup.o
 # legacy/irq.o
 pci-$(CONFIG_ACPI)		+= acpi.o
 pci-y				+= legacy.o irq.o
+pci-$(CONFIG_NUMA)		+= mp_bus_to_node.o
 
 # Careful: VISWS and NUMAQ overrule the pci-y above. The colons are
 # therefor correct. This needs a proper fix by distangling the code.
 pci-$(CONFIG_X86_VISWS)		:= visws.o fixup.o
-pci-$(CONFIG_X86_NUMAQ)		:= numa.o irq.o
-
-# Necessary for NUMAQ as well
-pci-$(CONFIG_NUMA)		+= mp_bus_to_node.o
+pci-$(CONFIG_X86_NUMAQ)		:= numa.o irq.o mp_bus_to_node.o
 
 obj-y				+= $(pci-y) common.o early.o
 obj-y				+= amd_bus.o
-- 
1.5.5.4


