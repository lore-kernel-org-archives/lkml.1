Return-Path: <linux-kernel-owner+w=401wt.eu-S1751748AbXBWGO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748AbXBWGO7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 01:14:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbXBWGO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 01:14:58 -0500
Received: from mtagate2.de.ibm.com ([195.212.29.151]:18587 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbXBWGO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 01:14:58 -0500
Date: Fri, 23 Feb 2007 07:13:32 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, James.Bottomley@SteelEye.com,
       Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH] dma-mapping-broken.h: flesh-out DMA API stubs
Message-ID: <20070223061332.GB27126@osiris.ibm.com>
References: <20070223005945.GA13084@tuxdriver.com> <20070223034243.GA7988@osiris.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070223034243.GA7988@osiris.ibm.com>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

How about this for telling that an architecture doesn't support DMA?
At least we could get rid of dma-mapping-broken.h and don't need to
compile some afterwards dead code.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/Kconfig              |    3 +++
 drivers/base/Makefile          |    4 ++--
 include/asm-s390/dma-mapping.h |    2 --
 lib/Kconfig                    |    5 +++++
 4 files changed, 10 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/s390/Kconfig
===================================================================
--- linux-2.6.orig/arch/s390/Kconfig
+++ linux-2.6/arch/s390/Kconfig
@@ -44,6 +44,9 @@ config GENERIC_TIME
 config NO_IOMEM
 	def_bool y
 
+config NO_DMA
+	def_bool y
+
 mainmenu "Linux Kernel Configuration"
 
 config S390
Index: linux-2.6/drivers/base/Makefile
===================================================================
--- linux-2.6.orig/drivers/base/Makefile
+++ linux-2.6/drivers/base/Makefile
@@ -2,10 +2,10 @@
 
 obj-y			:= core.o sys.o bus.o dd.o \
 			   driver.o class.o platform.o \
-			   cpu.o firmware.o init.o map.o dmapool.o \
-			   dma-mapping.o devres.o \
+			   cpu.o firmware.o init.o map.o devres.o \
 			   attribute_container.o transport_class.o
 obj-y			+= power/
+obj-$(CONFIG_DMA)	+= dma-mapping.o dmapool.o
 obj-$(CONFIG_ISA)	+= isa.o
 obj-$(CONFIG_FW_LOADER)	+= firmware_class.o
 obj-$(CONFIG_NUMA)	+= node.o
Index: linux-2.6/include/asm-s390/dma-mapping.h
===================================================================
--- linux-2.6.orig/include/asm-s390/dma-mapping.h
+++ linux-2.6/include/asm-s390/dma-mapping.h
@@ -9,6 +9,4 @@
 #ifndef _ASM_DMA_MAPPING_H
 #define _ASM_DMA_MAPPING_H
 
-#include <asm-generic/dma-mapping-broken.h>
-
 #endif /* _ASM_DMA_MAPPING_H */
Index: linux-2.6/lib/Kconfig
===================================================================
--- linux-2.6.orig/lib/Kconfig
+++ linux-2.6/lib/Kconfig
@@ -111,4 +111,9 @@ config HAS_IOPORT
 	depends on HAS_IOMEM && !NO_IOPORT
 	default y
 
+config HAS_DMA
+	boolean
+	depends on !NO_DMA
+	default y
+
 endmenu

-- 
Heiko Carstens
Linux on System z Development

IBM Deutschland Entwicklung GmbH
Vorsitzender des Aufsichtsrats: Johann Weihen
Geschaeftsfuehrung : Herbert Kircher
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
