Return-Path: <linux-kernel-owner+w=401wt.eu-S1752855AbZHRHHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855AbZHRHHW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 03:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752494AbZHRHHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 03:07:21 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54245 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975AbZHRHHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 03:07:20 -0400
From: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
To: linux-mtd@lists.infradead.org
Cc: davinci-linux-open-source@linux.davincidsp.com, david-b@pacbell.net,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       Sudhakar Rajashekhara <sudhakar.raj@ti.com>
Subject: [PATCH] [MTD] driver/Makefile: Initialize "mtd" and "spi" before "net"
Date: Tue, 18 Aug 2009 12:34:04 -0400
Message-Id: <1250613244-25447-1-git-send-email-sudhakar.raj@ti.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On TI's da850/omap-l138 EVM, MAC address is stored in SPI flash.

This patch changes the initialization sequence of the drivers
by moving mtd and spi ahead of net in drivers/Makefile thereby
enabling da850/omap-l138 ethernet driver to read the MAC address
while booting.

Signed-off-by: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
---
 drivers/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/Makefile b/drivers/Makefile
index bc4205d..2a1d41f 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -42,6 +42,8 @@ obj-y				+= macintosh/
 obj-$(CONFIG_IDE)		+= ide/
 obj-$(CONFIG_SCSI)		+= scsi/
 obj-$(CONFIG_ATA)		+= ata/
+obj-$(CONFIG_MTD)		+= mtd/
+obj-$(CONFIG_SPI)		+= spi/
 obj-y				+= net/
 obj-$(CONFIG_ATM)		+= atm/
 obj-$(CONFIG_FUSION)		+= message/
@@ -50,8 +52,6 @@ obj-y				+= ieee1394/
 obj-$(CONFIG_UIO)		+= uio/
 obj-y				+= cdrom/
 obj-y				+= auxdisplay/
-obj-$(CONFIG_MTD)		+= mtd/
-obj-$(CONFIG_SPI)		+= spi/
 obj-$(CONFIG_PCCARD)		+= pcmcia/
 obj-$(CONFIG_DIO)		+= dio/
 obj-$(CONFIG_SBUS)		+= sbus/
-- 
1.5.6

