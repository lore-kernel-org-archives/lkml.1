Return-Path: <linux-kernel-owner+w=401wt.eu-S932977AbXGTDf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932977AbXGTDf5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 23:35:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759077AbXGTDeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 23:34:01 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35679 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765578AbXGTDd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 23:33:58 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH 8/8] m68k: exclude more unbuildable drivers
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Message-Id: <E1IBjFe-0004nH-6H@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Fri, 20 Jul 2007 04:33:58 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


anything that wants working dma-mapping won't work
parport_pc won't work on m68k unless we have ISA

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/m68k/Kconfig       |    3 +++
 drivers/parport/Kconfig |    2 +-
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 684de4c..20a9c08 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -49,6 +49,9 @@ config ARCH_MAY_HAVE_PC_FDC
 config NO_IOPORT
 	def_bool y
 
+config NO_DMA
+	def_bool SUN3
+
 mainmenu "Linux/68k Kernel Configuration"
 
 source "init/Kconfig"
diff --git a/drivers/parport/Kconfig b/drivers/parport/Kconfig
index 09c93ff..d449b15 100644
--- a/drivers/parport/Kconfig
+++ b/drivers/parport/Kconfig
@@ -35,7 +35,7 @@ if PARPORT
 
 config PARPORT_PC
 	tristate "PC-style hardware"
-	depends on (!SPARC64 || PCI) && !SPARC32 && !M32R && !FRV
+	depends on (!SPARC64 || PCI) && !SPARC32 && !M32R && !FRV && (!M68K || ISA)
 	---help---
 	  You should say Y here if you have a PC-style parallel port. All
 	  IBM PC compatible computers and some Alphas have PC-style
-- 
1.5.3.GIT

