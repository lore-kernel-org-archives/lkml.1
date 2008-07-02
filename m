Return-Path: <linux-kernel-owner+w=401wt.eu-S1759691AbYGBVUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759691AbYGBVUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 17:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757226AbYGBVSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 17:18:30 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:6002 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757281AbYGBVSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 17:18:25 -0400
X-BigFish: VPS24(zzzz10d3izzz32i87il43j64h)
X-Spam-TCS-SCL: 3:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K3EDU3-01-1X3-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 05/11] x86/pci: Makefile merge: Changing 64bit ordering
Date: Wed, 2 Jul 2008 22:50:23 +0200
Message-ID: <1215031829-29124-6-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1215031829-29124-1-git-send-email-robert.richter@amd.com>
References: <1215031829-29124-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 02 Jul 2008 21:17:55.0943 (UTC) FILETIME=[187B6770:01C8DC89]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should be save since mmconfig*.o and init.o do not contain
*initcalls with the same level as in other files.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/pci/Makefile |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/pci/Makefile b/arch/x86/pci/Makefile
index d69a0fe..0fc3425 100644
--- a/arch/x86/pci/Makefile
+++ b/arch/x86/pci/Makefile
@@ -30,14 +30,13 @@ else
 # Makefile for X86_64 specific PCI routines
 #
 
-obj-y				:= i386.o
+obj-y				:= i386.o init.o
+obj-$(CONFIG_PCI_MMCONFIG)	+= mmconfig_64.o direct.o mmconfig-shared.o
 obj-$(CONFIG_PCI_DIRECT)	+= direct.o
-obj-y				+= fixup.o init.o
+obj-y				+= fixup.o
 obj-$(CONFIG_ACPI)		+= acpi.o
-obj-y				+= legacy.o irq.o common.o early.o
-# mmconfig has a 64bit special
-obj-$(CONFIG_PCI_MMCONFIG)	+= mmconfig_64.o direct.o mmconfig-shared.o
-
+obj-y				+= legacy.o irq.o
+obj-y				+= common.o early.o
 obj-y				+= amd_bus.o
 
 endif
-- 
1.5.5.4


