Return-Path: <linux-kernel-owner+w=401wt.eu-S1755750AbXJXJlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750AbXJXJlh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 05:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753232AbXJXJla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 05:41:30 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:58005 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752206AbXJXJl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 05:41:29 -0400
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Shannon Nelson <shannon.nelson@intel.com>
Cc: linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       kernel@avr32linux.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH] DMA: Correct invalid assumptions in the Kconfig text
Date: Wed, 24 Oct 2007 11:38:25 +0200
Message-Id: <1193218705-16685-1-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch corrects what I hope are invalid assumptions about the DMA
engine layer: Not only Intel(R) hardware can do DMA, and DMA can be
used for other things than memcpy and RAID offloading.

At the same time, make the DMA Engine menu visible again on AVR32. I'm
currently working on a driver for a DMA controller that can do
mem-to-mem transfers (which is supported by the framework) as well as
device-to-mem and mem-to-device transfers (not currently supported.)

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
Don't get me wrong; I think Intel deserves lots of respect for
creating this framework. But this is also why I got a bit disappointed
when I discovered that it seems to be less generic than I initially
hoped.

DMA controllers, which may support plain memcpy acceleration in
addition to more traditional "slave DMA", are very common in SoC
devices, and I think Linux needs a common framework for it. The
existing DMA Engine framework seems to come pretty close already, but
I think it needs more input from the embedded crowd before it can be
completely usable on a large number of embedded systems.

I'm not going to suggest any changes to the actual framework for
2.6.24, but I think the _intention_ of the framework needs to be
clarified.

Haavard

 drivers/dma/Kconfig |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 9c91b0f..62a9fe5 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -3,11 +3,13 @@
 #
 
 menuconfig DMADEVICES
-	bool "DMA Offload Engine support"
-	depends on (PCI && X86) || ARCH_IOP32X || ARCH_IOP33X || ARCH_IOP13XX
+	bool "DMA Engine support"
+	depends on (PCI && X86) || ARCH_IOP32X || ARCH_IOP33X || ARCH_IOP13XX || AVR32
 	help
-	  Intel(R) offload engines enable offloading memory copies in the
-	  network stack and RAID operations in the MD driver.
+	  DMA engines can do asynchronous data transfers without
+	  involving the host CPU. This can be used to offload memory
+	  copies in the network stack and RAID operations in the MD
+	  driver.
 
 if DMADEVICES
 
-- 
1.5.3.4

