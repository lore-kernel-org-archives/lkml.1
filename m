Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab0BIVfG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 16:35:06 -0500
Received: from mail.df.lth.se ([194.47.250.12]:53071 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751169Ab0BIVfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 16:35:04 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH] Debugging options for the DMA engine subsystem
Date: Tue,  9 Feb 2010 22:34:54 +0100
Message-Id: <1265751294-23584-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds Kconfig options for DEBUG and VERBOSE_DEBUG to the DMA
engine subsystem, I got tired of editing the Makefile manually
each time I want to debug things in here, modelled this on the
debug switches for other subsystems and works like a charm when
working on our DMA engines.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/Kconfig  |   16 ++++++++++++++++
 drivers/dma/Makefile |    7 +++++++
 2 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index e02d74b..1f4bbd6 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -13,6 +13,22 @@ menuconfig DMADEVICES
 	  DMA Device drivers supported by the configured arch, it may
 	  be empty in some cases.
 
+config DMADEVICES_DEBUG
+        bool "DMA Engine debugging"
+        depends on DMADEVICES != n
+        help
+          This is an option for use by developers; most people should
+          say N here.  This enables DMA engine core and driver debugging.
+
+config DMADEVICES_VDEBUG
+        bool "DMA Engine verbose debugging"
+        depends on DMADEVICES_DEBUG != n
+        help
+          This is an option for use by developers; most people should
+          say N here.  This enables deeper (more verbose) debugging of
+          the DMA engine core and drivers.
+
+
 if DMADEVICES
 
 comment "DMA Devices"
diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
index 807053d..54112d6 100644
--- a/drivers/dma/Makefile
+++ b/drivers/dma/Makefile
@@ -1,3 +1,10 @@
+ifeq ($(CONFIG_DMADEVICES_DEBUG),y)
+	EXTRA_CFLAGS	+= -DDEBUG
+endif
+ifeq ($(CONFIG_DMADEVICES_VDEBUG),y)
+	EXTRA_CFLAGS	+= -DVERBOSE_DEBUG
+endif
+
 obj-$(CONFIG_DMA_ENGINE) += dmaengine.o
 obj-$(CONFIG_NET_DMA) += iovlock.o
 obj-$(CONFIG_DMATEST) += dmatest.o
-- 
1.6.3.3

