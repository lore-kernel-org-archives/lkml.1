Return-Path: <linux-kernel-owner+w=401wt.eu-S1754901AbZEOD0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901AbZEOD0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 23:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754570AbZEOD0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 23:26:07 -0400
Received: from mail.windriver.com ([147.11.1.11]:44757 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754034AbZEOD0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 23:26:04 -0400
From: Harry Ciao <qingtao.cao@windriver.com>
To: norsk5@yahoo.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       bluesmoke-devel@lists.sourceforge.net
Subject: [v1 PATCH 2/2] EDAC: AMD8111 & AMD8131 Kconfig fixup
Date: Fri, 15 May 2009 11:26:46 +0800
Message-Id: <1242358006-28339-3-git-send-email-qingtao.cao@windriver.com>
X-Mailer: git-send-email 1.5.6.2
In-Reply-To: <1242358006-28339-2-git-send-email-qingtao.cao@windriver.com>
References: <1242358006-28339-1-git-send-email-qingtao.cao@windriver.com>
 <1242358006-28339-2-git-send-email-qingtao.cao@windriver.com>
X-OriginalArrivalTime: 15 May 2009 03:25:48.0458 (UTC) FILETIME=[D742E8A0:01C9D50C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The amd8111_edac.c driver will fail allmodconfig on architectures
other than PPC, introduce Kconfig dependency to avoid this, since
both AMD8111 and AMD8131 chips are only adopted on Maple so far.

Signed-off-by: Harry Ciao <qingtao.cao@windriver.com>
---
 drivers/edac/Kconfig  |    8 ++++++--
 drivers/edac/Makefile |    2 ++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index d9a7c25..376a9a4 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -192,17 +192,21 @@ config EDAC_PPC4XX
 
 config EDAC_AMD8131
 	tristate "AMD8131 HyperTransport PCI-X Tunnel"
-	depends on EDAC_MM_EDAC && PCI
+	depends on EDAC_MM_EDAC && PCI && PPC_MAPLE
 	help
 	  Support for error detection and correction on the
 	  AMD8131 HyperTransport PCI-X Tunnel chip.
+	  Note, add more Kconfig dependency if it's adopted
+	  on some machine other than Maple.
 
 config EDAC_AMD8111
 	tristate "AMD8111 HyperTransport I/O Hub"
-	depends on EDAC_MM_EDAC && PCI
+	depends on EDAC_MM_EDAC && PCI && PPC_MAPLE
 	help
 	  Support for error detection and correction on the
 	  AMD8111 HyperTransport I/O Hub chip.
+	  Note, add more Kconfig dependency if it's adopted
+	  on some machine other than Maple.
 
 config EDAC_CPC925
 	tristate "IBM CPC925 Memory Controller (PPC970FX)"
diff --git a/drivers/edac/Makefile b/drivers/edac/Makefile
index ddfd072..be0e705 100644
--- a/drivers/edac/Makefile
+++ b/drivers/edac/Makefile
@@ -36,3 +36,5 @@ obj-$(CONFIG_EDAC_MPC85XX)		+= mpc85xx_edac.o
 obj-$(CONFIG_EDAC_MV64X60)		+= mv64x60_edac.o
 obj-$(CONFIG_EDAC_CELL)			+= cell_edac.o
 obj-$(CONFIG_EDAC_PPC4XX)		+= ppc4xx_edac.o
+obj-$(CONFIG_EDAC_AMD8111)		+= amd8111_edac.o
+obj-$(CONFIG_EDAC_AMD8131)		+= amd8131_edac.o
-- 
1.5.6.2

