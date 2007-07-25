Return-Path: <linux-kernel-owner+w=401wt.eu-S1764834AbXGYWIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764834AbXGYWIK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 18:08:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756276AbXGYWH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 18:07:58 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:51028 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754649AbXGYWH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 18:07:57 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Date: Thu, 26 Jul 2007 03:39:31 +0530 (IST)
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: akpm@linux-foundation.org
cc: shannon.nelson@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH -mm] dma: INTEL_IOATDMA build fix
Message-ID: <Pine.LNX.4.64.0707260336280.3877@cselinux1.cse.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make CONFIG_INTEL_IOATDMA select CONFIG_DCA because it uses code
exported from said dependency:

# CONFIG_DCA is not set
CONFIG_INTEL_IOATDMA=m

ERROR: "alloc_dca_provider" [drivers/dma/ioatdma.ko] undefined!
ERROR: "register_dca_provider" [drivers/dma/ioatdma.ko] undefined!
ERROR: "unregister_dca_provider" [drivers/dma/ioatdma.ko] undefined!
ERROR: "free_dca_provider" [drivers/dma/ioatdma.ko] undefined!
make[1]: *** [__modpost] Error 1

"select" seems ok because CONFIG_DCA looks library-like and doesn't itself
depend upon anything else.

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>

---

 drivers/dma/Kconfig |    1 +
 1 files changed, 1 insertion(+)

diff -ruNp a/drivers/dma/Kconfig b/drivers/dma/Kconfig
--- a/drivers/dma/Kconfig	2007-07-26 03:31:47.000000000 +0530
+++ b/drivers/dma/Kconfig	2007-07-26 03:32:14.000000000 +0530
@@ -28,6 +28,7 @@ comment "DMA Devices"
 config INTEL_IOATDMA
 	tristate "Intel I/OAT DMA support"
 	depends on DMA_ENGINE && PCI
+	select DCA
 	default m
 	---help---
 	  Enable support for the Intel(R) I/OAT DMA engine.
