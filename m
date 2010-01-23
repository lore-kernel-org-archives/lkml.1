Return-Path: <linux-kernel-owner+w=401wt.eu-S1752257Ab0AWVYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257Ab0AWVYc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 16:24:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751752Ab0AWVYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 16:24:31 -0500
Received: from fallback3.mail.ru ([94.100.176.58]:48189 "EHLO
	fallback3.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab0AWVYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 16:24:31 -0500
From: Dmitry Artamonow <mad_soft@inbox.ru>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Magnus Damm <damm@opensource.se>,
       Ian Molton <ian@mnementh.co.uk>,
       Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH] mfd: fix asic3 build
Date: Sun, 24 Jan 2010 00:20:20 +0300
Message-Id: <1264281620-24378-1-git-send-email-mad_soft@inbox.ru>
X-Mailer: git-send-email 1.6.6
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 64e8867ba8 (mfd: tmio_mmc hardware abstraction for CNF area)
missed to update Makefile rule for asic3, which leads to following
error during linking:
  LD      .tmp_vmlinux1
drivers/built-in.o: In function `asic3_mmc_clk_div':
ledtrig-backlight.c:(.text+0x3de28): undefined reference to `tmio_core_mmc_clk_div'
drivers/built-in.o: In function `asic3_mmc_pwr':
ledtrig-backlight.c:(.text+0x3de50): undefined reference to `tmio_core_mmc_pwr'
drivers/built-in.o: In function `asic3_mmc_enable':
ledtrig-backlight.c:(.text+0x3e154): undefined reference to `tmio_core_mmc_enable'
make: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
---
This is a patch for regression introduced in -rc5 (-rc4 was ok)
Error above is from building kernel 2.6.33-rc5 with magician_defconfig.
Sorry if this already been reported/fixed.

 drivers/mfd/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 8f0d184..97134c5 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -3,7 +3,7 @@
 #
 
 obj-$(CONFIG_MFD_SM501)		+= sm501.o
-obj-$(CONFIG_MFD_ASIC3)		+= asic3.o
+obj-$(CONFIG_MFD_ASIC3)		+= asic3.o tmio_core.o
 obj-$(CONFIG_MFD_SH_MOBILE_SDHI)		+= sh_mobile_sdhi.o
 
 obj-$(CONFIG_HTC_EGPIO)		+= htc-egpio.o
-- 
1.6.6

