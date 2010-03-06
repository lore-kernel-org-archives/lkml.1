Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab0CFNgq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 08:36:46 -0500
Received: from mail.gmx.net ([213.165.64.20]:48459 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751066Ab0CFNgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 08:36:44 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+laYFN0eyltf08ElZdSxFtgWrqoNmuViZdP4+zZK
	TG+++RgVGfyiUr
From: Peter Huewe <PeterHuewe@gmx.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH] mfd/ucb1x00: Fix build failure for collie_defconfig caused by missing include
Date: Sat, 6 Mar 2010 14:36:38 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.27-05415-g69a8594; KDE/4.3.5; x86_64; ; )
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Kay Sievers <kay.sievers@vrfy.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       "Russell King - ARM Linux" <linux@arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201003061436.38544.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.56000000000000005
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

This patch fixes a build failure[1], by adding the missing semaphore.h include

References:
[1] http://kisskb.ellerman.id.au/kisskb/buildresult/2234322/

Patch against linux-next as of 20100306
Applies smoothly to Linus' tree as well.
The build failure happens to be only in linux-next yet.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
KernelVersion: 2.6.33-linux-next-20100306

 drivers/mfd/ucb1x00-core.c  |    1 +
 include/linux/mfd/ucb1x00.h |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/ucb1x00-core.c b/drivers/mfd/ucb1x00-core.c
index 252b741..b281217 100644
--- a/drivers/mfd/ucb1x00-core.c
+++ b/drivers/mfd/ucb1x00-core.c
@@ -27,6 +27,7 @@
 #include <linux/mutex.h>
 #include <linux/mfd/ucb1x00.h>
 #include <linux/gpio.h>
+#include <linux/semaphore.h>
 
 #include <mach/dma.h>
 #include <mach/hardware.h>
diff --git a/include/linux/mfd/ucb1x00.h b/include/linux/mfd/ucb1x00.h
index aa9c378..4321f04 100644
--- a/include/linux/mfd/ucb1x00.h
+++ b/include/linux/mfd/ucb1x00.h
@@ -12,6 +12,7 @@
 
 #include <linux/mfd/mcp.h>
 #include <linux/gpio.h>
+#include <linux/semaphore.h>
 
 #define UCB_IO_DATA	0x00
 #define UCB_IO_DIR	0x01
-- 
1.6.4.4

