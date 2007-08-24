Return-Path: <linux-kernel-owner+w=401wt.eu-S1763014AbXHXOhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763014AbXHXOhq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 10:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754045AbXHXOgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 10:36:47 -0400
Received: from 85-18-251-172.ip.fastwebnet.it ([85.18.251.172]:56128 "EHLO
	memento.home.lan" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752217AbXHXOgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 10:36:45 -0400
X-Greylist: delayed 489 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Aug 2007 10:36:45 EDT
From: "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>
Subject: [PATCH 1/2] Replace CONFIG_USB_OHCI with CONFIG_USB_OHCI_HCD in a few
	overlooked files
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Giuseppe =?utf-8?q?Patan=C3=A8?= <giuseppe.patane@tvblob.com>,
       Ralf Baechle <ralf@linux-mips.org>, <linux-mips@linux-mips.org>,
       "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>
Date: Fri, 24 Aug 2007 13:28:57 +0200
Message-ID: <20070824112857.9607.22924.stgit@americanbeauty.home.lan>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Finish the rename of CONFIG_USB_OHCI to CONFIG_USB_OHCI_HCD, which started
in 2005 (before 2.6.12-rc2). The patch in this message has not been applied yet;
moreover, it is not something to fix afterwards. I've verified that no more
instances of 'CONFIG_USB_[UOE]HCI\>' exist in the source tree.

http://www.linux-mips.org/archives/linux-mips/2005-06/msg00060.html

I'm also sending a script to detect undefined Kconfig variables in next patch.

Thanks to my colleague Giuseppe Patanè for the original report: he discovered
the original mail (above) and for verified that the fix had not yet been
applied.

Cc: Giuseppe Patanè <giuseppe.patane@tvblob.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: <linux-mips@linux-mips.org>
Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
---

 arch/mips/au1000/mtx-1/board_setup.c  |    4 ++--
 arch/mips/au1000/pb1000/board_setup.c |    6 +++---
 arch/mips/au1000/pb1100/board_setup.c |    4 ++--
 arch/mips/au1000/pb1500/board_setup.c |    6 +++---
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/mips/au1000/mtx-1/board_setup.c b/arch/mips/au1000/mtx-1/board_setup.c
index 7bc5af8..1688ca9 100644
--- a/arch/mips/au1000/mtx-1/board_setup.c
+++ b/arch/mips/au1000/mtx-1/board_setup.c
@@ -54,11 +54,11 @@ void board_reset (void)
 
 void __init board_setup(void)
 {
-#ifdef CONFIG_USB_OHCI
+#ifdef CONFIG_USB_OHCI_HCD
 	// enable USB power switch
 	au_writel( au_readl(GPIO2_DIR) | 0x10, GPIO2_DIR );
 	au_writel( 0x100000, GPIO2_OUTPUT );
-#endif // defined (CONFIG_USB_OHCI)
+#endif // defined (CONFIG_USB_OHCI_HCD)
 
 #ifdef CONFIG_PCI
 #if defined(__MIPSEB__)
diff --git a/arch/mips/au1000/pb1000/board_setup.c b/arch/mips/au1000/pb1000/board_setup.c
index 824cfaf..f25b38f 100644
--- a/arch/mips/au1000/pb1000/board_setup.c
+++ b/arch/mips/au1000/pb1000/board_setup.c
@@ -54,7 +54,7 @@ void __init board_setup(void)
 	au_writel(0, SYS_PINSTATERD);
 	udelay(100);
 
-#ifdef CONFIG_USB_OHCI
+#ifdef CONFIG_USB_OHCI_HCD
 	/* zero and disable FREQ2 */
 	sys_freqctrl = au_readl(SYS_FREQCTRL0);
 	sys_freqctrl &= ~0xFFF00000;
@@ -102,7 +102,7 @@ void __init board_setup(void)
 	/*
 	 * Route 48MHz FREQ2 into USB Host and/or Device
 	 */
-#ifdef CONFIG_USB_OHCI
+#ifdef CONFIG_USB_OHCI_HCD
 	sys_clksrc |= ((4<<12) | (0<<11) | (0<<10));
 #endif
 	au_writel(sys_clksrc, SYS_CLKSRC);
@@ -116,7 +116,7 @@ void __init board_setup(void)
 	au_writel(pin_func, SYS_PINFUNC);
 	au_writel(0x2800, SYS_TRIOUTCLR);
 	au_writel(0x0030, SYS_OUTPUTCLR);
-#endif // defined (CONFIG_USB_OHCI)
+#endif // defined (CONFIG_USB_OHCI_HCD)
 
 	// make gpio 15 an input (for interrupt line)
 	pin_func = au_readl(SYS_PINFUNC) & (u32)(~0x100);
diff --git a/arch/mips/au1000/pb1100/board_setup.c b/arch/mips/au1000/pb1100/board_setup.c
index 6bc1f8e..3205f88 100644
--- a/arch/mips/au1000/pb1100/board_setup.c
+++ b/arch/mips/au1000/pb1100/board_setup.c
@@ -54,7 +54,7 @@ void __init board_setup(void)
 	au_writel(0, SYS_PININPUTEN);
 	udelay(100);
 
-#ifdef CONFIG_USB_OHCI
+#ifdef CONFIG_USB_OHCI_HCD
 	{
 		u32 pin_func, sys_freqctrl, sys_clksrc;
 
@@ -98,7 +98,7 @@ void __init board_setup(void)
 		pin_func |= 0x8000;
 		au_writel(pin_func, SYS_PINFUNC);
 	}
-#endif // defined (CONFIG_USB_OHCI)
+#endif // defined (CONFIG_USB_OHCI_HCD)
 
 	/* Enable sys bus clock divider when IDLE state or no bus activity. */
 	au_writel(au_readl(SYS_POWERCTRL) | (0x3 << 5), SYS_POWERCTRL);
diff --git a/arch/mips/au1000/pb1500/board_setup.c b/arch/mips/au1000/pb1500/board_setup.c
index c9b6556..118e32a 100644
--- a/arch/mips/au1000/pb1500/board_setup.c
+++ b/arch/mips/au1000/pb1500/board_setup.c
@@ -56,7 +56,7 @@ void __init board_setup(void)
 	au_writel(0, SYS_PINSTATERD);
 	udelay(100);
 
-#ifdef CONFIG_USB_OHCI
+#ifdef CONFIG_USB_OHCI_HCD
 
 	/* GPIO201 is input for PCMCIA card detect */
 	/* GPIO203 is input for PCMCIA interrupt request */
@@ -85,7 +85,7 @@ void __init board_setup(void)
 	/*
 	 * Route 48MHz FREQ2 into USB Host and/or Device
 	 */
-#ifdef CONFIG_USB_OHCI
+#ifdef CONFIG_USB_OHCI_HCD
 	sys_clksrc |= ((4<<12) | (0<<11) | (0<<10));
 #endif
 	au_writel(sys_clksrc, SYS_CLKSRC);
@@ -95,7 +95,7 @@ void __init board_setup(void)
 	// 2nd USB port is USB host
 	pin_func |= 0x8000;
 	au_writel(pin_func, SYS_PINFUNC);
-#endif // defined (CONFIG_USB_OHCI)
+#endif // defined (CONFIG_USB_OHCI_HCD)
 
 
 

