Return-Path: <linux-kernel-owner+w=401wt.eu-S1946649AbXBIQkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946649AbXBIQkw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:40:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946666AbXBIQkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:40:37 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51739 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946635AbXBIQkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:40:01 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] [eo]hci_{read,write}l() does force casts to wrong type for no reason
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Message-Id: <E1HFYn2-0006rQ-On@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Fri, 09 Feb 2007 16:40:00 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


readl() et.al. expect iomem pointer, so WTF force-cast it to normal one???

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/usb/host/ehci.h |   12 ++++++------
 drivers/usb/host/ohci.h |   12 ++++++------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/host/ehci.h b/drivers/usb/host/ehci.h
index ec0da03..46fa57a 100644
--- a/drivers/usb/host/ehci.h
+++ b/drivers/usb/host/ehci.h
@@ -677,10 +677,10 @@ static inline unsigned int ehci_readl (const struct ehci_hcd *ehci,
 {
 #ifdef CONFIG_USB_EHCI_BIG_ENDIAN_MMIO
 	return ehci_big_endian_mmio(ehci) ?
-		readl_be((__force u32 *)regs) :
-		readl((__force u32 *)regs);
+		readl_be(regs) :
+		readl(regs);
 #else
-	return readl((__force u32 *)regs);
+	return readl(regs);
 #endif
 }
 
@@ -689,10 +689,10 @@ static inline void ehci_writel (const struct ehci_hcd *ehci,
 {
 #ifdef CONFIG_USB_EHCI_BIG_ENDIAN_MMIO
 	ehci_big_endian_mmio(ehci) ?
-		writel_be(val, (__force u32 *)regs) :
-		writel(val, (__force u32 *)regs);
+		writel_be(val, regs) :
+		writel(val, regs);
 #else
-	writel(val, (__force u32 *)regs);
+	writel(val, regs);
 #endif
 }
 
diff --git a/drivers/usb/host/ohci.h b/drivers/usb/host/ohci.h
index 0dafcda..c2b5ecf 100644
--- a/drivers/usb/host/ohci.h
+++ b/drivers/usb/host/ohci.h
@@ -507,10 +507,10 @@ static inline unsigned int _ohci_readl (const struct ohci_hcd *ohci,
 {
 #ifdef CONFIG_USB_OHCI_BIG_ENDIAN_MMIO
 	return big_endian_mmio(ohci) ?
-		readl_be ((__force u32 *)regs) :
-		readl ((__force u32 *)regs);
+		readl_be (regs) :
+		readl (regs);
 #else
-	return readl ((__force u32 *)regs);
+	return readl (regs);
 #endif
 }
 
@@ -519,10 +519,10 @@ static inline void _ohci_writel (const struct ohci_hcd *ohci,
 {
 #ifdef CONFIG_USB_OHCI_BIG_ENDIAN_MMIO
 	big_endian_mmio(ohci) ?
-		writel_be (val, (__force u32 *)regs) :
-		writel (val, (__force u32 *)regs);
+		writel_be (val, regs) :
+		writel (val, regs);
 #else
-		writel (val, (__force u32 *)regs);
+		writel (val, regs);
 #endif
 }
 
-- 
1.5.0-rc2.GIT


