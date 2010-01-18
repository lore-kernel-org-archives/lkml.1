Return-Path: <linux-kernel-owner+w=401wt.eu-S1754602Ab0ARRSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602Ab0ARRSb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:18:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754768Ab0ARRSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:18:24 -0500
Received: from mail.gmx.net ([213.165.64.20]:55729 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754067Ab0ARRST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:18:19 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19QzSMJ4mZQrRPlrAYbfG8Ih/ypTW0ps2c+ryWIHw
	Rzu+6TJZak1kbD
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Lennert Buytenhek <kernel@wantstofly.org>
Subject: [PATCH] arch/arm: Fix build failure for ixp23xx-defconfig caused by typo
Date: Mon, 18 Jan 2010 18:18:10 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.27-05415-g69a8594; KDE/4.3.3; x86_64; ; )
Cc: Russell King <linux@arm.linux.org.uk>,
       "Anders =?iso-8859-1?q?Grafstr=F6m?=" 
	<anders.grafstrom@netinsight.net>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201001181818.10397.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.56000000000000005
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>
Date: Mon, 18 Jan 2010 18:07:20 +0100

This patch fixes a build failure[1] caused by an odd parenthesis.

References:
[1] http://kisskb.ellerman.id.au/kisskb/buildresult/2020080/

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
KernelVersion: 2.6.33-rc4

Checkpatch generates warnings for the patch - but this is due to the original code, not the change.

 arch/arm/mach-ixp23xx/include/mach/memory.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-ixp23xx/include/mach/memory.h b/arch/arm/mach-ixp23xx/include/mach/memory.h
index 94a3a86..6ef65d8 100644
--- a/arch/arm/mach-ixp23xx/include/mach/memory.h
+++ b/arch/arm/mach-ixp23xx/include/mach/memory.h
@@ -19,7 +19,7 @@
  */
 #define PHYS_OFFSET		(0x00000000)
 
-#define IXP23XX_PCI_SDRAM_OFFSET (*((volatile int *)IXP23XX_PCI_SDRAM_BAR) & 0xfffffff0))
+#define IXP23XX_PCI_SDRAM_OFFSET (*((volatile int *)IXP23XX_PCI_SDRAM_BAR) & 0xfffffff0)
 
 #define __phys_to_bus(x)	((x) + (IXP23XX_PCI_SDRAM_OFFSET - PHYS_OFFSET))
 #define __bus_to_phys(x)	((x) - (IXP23XX_PCI_SDRAM_OFFSET - PHYS_OFFSET))
-- 
1.6.4.4

