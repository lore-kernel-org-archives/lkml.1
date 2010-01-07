Return-Path: <linux-kernel-owner+w=401wt.eu-S1756504Ab0AGBuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504Ab0AGBuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 20:50:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756271Ab0AGBuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 20:50:22 -0500
Received: from mail.gmx.net ([213.165.64.20]:47679 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756246Ab0AGBuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 20:50:20 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19UOGR7trdUbFANf87dpY/K7AYU7ne1+Xh1uAAHdX
	b4W0e565QA9DeH
From: Peter Huewe <PeterHuewe@gmx.de>
To: Russell King <linux@arm.linux.org.uk>
Subject: [PATCH] arch/arm: Fix build failure for defconfigs without CONFIG_ISA_DMA_API set
Date: Thu, 7 Jan 2010 02:50:13 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.27-05415-g69a8594; KDE/4.3.3; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201001070250.14063.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>
Date: Thu, 7 Jan 2010 02:34:44 +0100

A lot of ARM-defconfigs (those without CONFIG_ISA_DMA_API set) fail to
build [1][2][3] due to the changes of the patch
    [PATCH] PCI: Clean up build for CONFIG_PCI_QUIRKS unset
    by Rafael J. Wysocki (Sat, 2 Jan 2010 22:57:24 +0100) [4]
as the referenced variable 'isa_dma_bridge_buggy' in asm/dma.h is
enclosed by the CONFIG_ISA_DMA_API conditional all configs without this
setting fail to build.

I'm not sure wether moving the condition is the right way to solve the
issue, but atleast it fixes the issue :)

References:
[1] http://kisskb.ellerman.id.au/kisskb/buildresult/1983354/
[2] http://kisskb.ellerman.id.au/kisskb/buildresult/1983333/
[3] http://kisskb.ellerman.id.au/kisskb/buildresult/1983337/
[4] http://lkml.org/lkml/2010/1/2/102

Patch against Linus' tree.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 arch/arm/include/asm/dma.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/dma.h b/arch/arm/include/asm/dma.h
index 7edf353..ca51143 100644
--- a/arch/arm/include/asm/dma.h
+++ b/arch/arm/include/asm/dma.h
@@ -138,12 +138,12 @@ extern int  get_dma_residue(unsigned int chan);
 #define NO_DMA	255
 #endif
 
+#endif /* CONFIG_ISA_DMA_API */
+
 #ifdef CONFIG_PCI
 extern int isa_dma_bridge_buggy;
 #else
 #define isa_dma_bridge_buggy    (0)
 #endif
 
-#endif /* CONFIG_ISA_DMA_API */
-
 #endif /* __ASM_ARM_DMA_H */
-- 
1.6.4.4

